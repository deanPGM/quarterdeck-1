// Deleting a review: its state file, its fix worktree and the branch Deck
// fetched go; your own branch and uncommitted edits stay.
import 'dart:io';

import 'package:deck/core/models/config.dart';
import 'package:deck/core/review/review.dart';
import 'package:deck/data/deck_home.dart';
import 'package:deck/data/review_store.dart';
import 'package:deck/data/stores.dart';
import 'package:deck/state/reviews.dart';
import 'package:deck/state/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

class _Home extends Home {
  _Home(this.dir);
  final String dir;

  @override
  DeckHome build() => DeckHome(dir);
}

void main() {
  late Directory tmp;
  late String repo;
  late DeckHome home;
  late ProviderContainer ref;

  String git(List<String> args) {
    final r = Process.runSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@example.com', '-c', 'commit.gpgsign=false', ...args], workingDirectory: repo);
    if (r.exitCode != 0) throw StateError('${r.stderr}');
    return '${r.stdout}';
  }

  bool branch(String name) => git(['branch', '--list', name]).trim().isNotEmpty;
  String tree(String id) => p.join(home.cache.path, 'worktrees', 'app', id);

  Future<void> review(String id, String head, {bool local = false}) async {
    git(['branch', head]);
    git(['worktree', 'add', '--quiet', tree(id), head]);
    await ReviewStore(home).save(Review(id: id, project: 'app', baseRef: 'main', headRef: head, createdAt: '2026-11-03T00:00:00Z', local: local));
  }

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('deck-review-delete-');
    repo = p.join(tmp.path, 'repo');
    Directory(repo).createSync();
    git(['init', '-q', '-b', 'main']);
    File(p.join(repo, 'a.txt')).writeAsStringSync('a\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
    home = DeckHome(p.join(tmp.path, 'deck'));
    await ConfigStore(home).save(
      DeckConfig(
        projects: [ProjectConfig(id: 'app', name: 'App', dir: repo)],
      ),
    );
    ref = ProviderContainer(overrides: [homeProvider.overrideWith(() => _Home(home.dir))]);
  });

  tearDown(() {
    ref.dispose();
    tmp.deleteSync(recursive: true);
  });

  test('drops the state file, the fix worktree and the fetched branch', () async {
    await review('gitlab-12', 'skim/mr-12');
    await ref.read(reviewsProvider.notifier).delete((project: 'app', id: 'gitlab-12'));
    expect(ReviewStore(home).list('app'), isEmpty);
    expect(Directory(tree('gitlab-12')).existsSync(), isFalse);
    expect(branch('skim/mr-12'), isFalse);
  });

  test('keeps your own branch', () async {
    await review('gitlab-13', 'feat/login', local: true);
    await ref.read(reviewsProvider.notifier).delete((project: 'app', id: 'gitlab-13'));
    expect(ReviewStore(home).list('app'), isEmpty);
    expect(branch('feat/login'), isTrue);
  });

  test('refuses while the fix worktree holds edits, and keeps the review', () async {
    await review('gitlab-14', 'skim/mr-14');
    File(p.join(tree('gitlab-14'), 'a.txt')).writeAsStringSync('edited\n');
    await expectLater(ref.read(reviewsProvider.notifier).delete((project: 'app', id: 'gitlab-14')), throwsA(isA<ReviewError>()));
    expect(ReviewStore(home).list('app'), hasLength(1));
    expect(branch('skim/mr-14'), isTrue);
  });
}
