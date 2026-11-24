// The diff pipeline against a real temp repository: git three ways, moved
// blocks, formatting-only, lock files, generated files and .skim.yml.
import 'dart:io';

import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/skim_config.dart';
import 'package:deck/data/review_git.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

late Directory _tmp;
late String root;
late String base, head;

void git(List<String> args) {
  final r = Process.runSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@example.com', '-c', 'commit.gpgsign=false', ...args], workingDirectory: root);
  if (r.exitCode != 0) throw StateError('git ${args.join(' ')}: ${r.stderr}');
}

void write(String path, String text) {
  final f = File(p.join(root, path));
  f.parent.createSync(recursive: true);
  f.writeAsStringSync(text);
}

String sha(String ref) => (Process.runSync('git', ['rev-parse', ref], workingDirectory: root).stdout as String).trim();

const helper = '''
  Future<void> refreshTheCacheFromDisk() async {
    final tracks = await storage.readAllTracks();
    for (final track in tracks) {
      cache.putTrackIntoMemory(track.identifier, track);
    }
  }
''';

void main() {
  setUpAll(() {
    _tmp = Directory.systemTemp.createTempSync('deck-review-git-');
    root = _tmp.path;
    git(['init', '-q', '-b', 'main']);
    write('lib/player.dart', 'class Player {\n  void play() {}\n\n$helper\n  void stop() {}\n}\n');
    write('lib/cache.dart', 'class Cache {\n  void clear() {}\n}\n');
    write('lib/format.dart', 'void main() {\n  print(1);\n}\n');
    write('pubspec.lock', 'packages:\n  a: 1.0.0\n');
    write('lib/track.g.dart', '// part of track\nconst a = 1;\n');
    write('schema/api.json', '{"a": 1}\n');
    write('assets/strings.json', '{"hello": "hi"}\n');
    write('.gitattributes', 'schema/*.json linguist-generated\n');
    write('.skim.yml', 'tags:\n  "assets/**": [docs]\nhidden_by_default: [lockfile, generated, moved-only]\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
    base = sha('HEAD');
    git(['checkout', '-q', '-b', 'feat/APP-7-move']);
    // The helper moves from Player to Cache, and play() really changes.
    write('lib/player.dart', 'class Player {\n  void play() { start(); }\n\n  void stop() {}\n}\n');
    write('lib/cache.dart', 'class Cache {\n  void clear() {}\n\n$helper}\n');
    write('lib/format.dart', 'void main() {\n    print(1);\n\n}\n');
    write('pubspec.lock', 'packages:\n  a: 1.1.0\n');
    write('lib/track.g.dart', '// part of track\nconst a = 2;\n');
    write('schema/api.json', '{"a": 2}\n');
    write('assets/strings.json', '{"hello": "hello"}\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'APP-7 move the cache refresh\n\nSee #3.']);
    head = sha('HEAD');
  });

  tearDownAll(() => _tmp.deleteSync(recursive: true));

  group('deriveSnapshot', () {
    late DiffSnapshot snap;
    DiffFile file(String path) => snap.files.firstWhere((f) => f.path == path);

    setUpAll(() async => snap = await deriveSnapshot(root, base, head, 'main', 'feat/APP-7-move'));

    test('keeps the refs and every changed file', () {
      expect([snap.baseSha, snap.headSha, snap.baseRef, snap.headRef], [base, head, 'main', 'feat/APP-7-move']);
      expect(snap.files.map((f) => f.path).toSet(), {
        'lib/player.dart', 'lib/cache.dart', 'lib/format.dart', 'pubspec.lock', 'lib/track.g.dart', 'schema/api.json', 'assets/strings.json', //
      });
    });

    test('marks the moved block and leaves it out of the real counts', () {
      final player = file('lib/player.dart'), cache = file('lib/cache.dart');
      expect(player.hunks.expand((h) => h.lines).where((l) => l.type == lineDelete && l.content.contains('readAllTracks')).single.moved, isTrue);
      expect(player.realAdditions, 1);
      expect(player.realDeletions, 1);
      expect(player.deletions, greaterThan(5));
      expect(player.tags, isNot(contains('moved-only')));
      expect(cache.realAdditions, lessThan(cache.additions));
      expect(cache.hunks.expand((h) => h.lines).where((l) => l.type == lineAdd && l.content.contains('readAllTracks')).single.moved, isTrue);
    });

    test('tags formatting-only, lockfile and generated (by name and by .gitattributes)', () {
      expect(file('lib/format.dart').tags, contains('formatting-only'));
      expect(file('pubspec.lock').tags, contains('lockfile'));
      expect(file('lib/track.g.dart').tags, contains('generated'));
      expect(file('schema/api.json').tags, contains('generated'));
      expect(file('lib/player.dart').tags, isEmpty);
    });

    test('applies .skim.yml tag rules and hidden list', () {
      expect(file('assets/strings.json').tags, ['docs']);
      expect(snap.hidden, ['lockfile', 'generated', 'moved-only']);
      // formatting-only is no longer hidden here: lock + two generated, and cache.dart if git saw it as moved only.
      expect(snap.hiddenCount, snap.files.where((f) => f.tags.any(['lockfile', 'generated', 'moved-only'].contains)).length);
      expect(snap.hiddenCount, greaterThanOrEqualTo(3));
    });
  });

  group('git helpers', () {
    test('revParse, mergeBase and commitMessages', () async {
      expect(await revParse(root, 'main'), base);
      expect(await mergeBase(root, 'main', 'feat/APP-7-move'), base);
      expect(await commitMessages(root, base, head), ['APP-7 move the cache refresh\n\nSee #3.']);
    });

    test('showFile reads a file at a commit', () async {
      expect(await showFile(root, base, 'pubspec.lock'), 'packages:\n  a: 1.0.0\n');
      expect(await showFile(root, head, 'pubspec.lock'), 'packages:\n  a: 1.1.0\n');
    });

    test('refuses refs and paths git could read as options', () {
      expect(() => revParse(root, '--all'), throwsArgumentError);
      expect(() => revParse(root, 'a b'), throwsArgumentError);
      expect(() => showFile(root, head, '../etc/passwd'), throwsArgumentError);
      expect(() => assertSafePath('-x'), throwsArgumentError);
    });

    test('an unknown ref is a git error', () {
      expect(revParse(root, 'nope'), throwsA(isA<ProcessException>()));
    });
  });

  group('loadSkimConfig', () {
    test('reads <root>/.skim.yml', () {
      final c = loadSkimConfig(root);
      expect(c.tags, {
        'assets/**': ['docs'],
      });
      expect(c.hiddenByDefault, ['lockfile', 'generated', 'moved-only']);
    });

    test('returns defaults when the file is missing', () {
      final empty = Directory.systemTemp.createTempSync('deck-skim-empty-');
      addTearDown(() => empty.deleteSync(recursive: true));
      final c = loadSkimConfig(empty.path);
      expect(c.generated, isEmpty);
      expect(c.hiddenByDefault, hiddenByDefault);
    });

    test('throws a SkimConfigError on a broken file', () {
      final broken = Directory.systemTemp.createTempSync('deck-skim-broken-');
      addTearDown(() => broken.deleteSync(recursive: true));
      File(p.join(broken.path, '.skim.yml')).writeAsStringSync('generated:\n  - "lib/gen/**"\ntags: [not, a, mapping\n');
      expect(() => loadSkimConfig(broken.path), throwsA(isA<SkimConfigError>()));
    });
  });
}
