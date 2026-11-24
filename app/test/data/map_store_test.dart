// Port of Skim's packages/core/tests/map.test.ts: same rules, same messages.
import 'dart:convert';
import 'dart:io';

import 'package:deck/data/map_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

late Directory _tmp;
late String root;
late MapStore map;

void git(List<String> args) {
  final r = Process.runSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@example.com', '-c', 'commit.gpgsign=false', ...args], workingDirectory: root);
  if (r.exitCode != 0) throw StateError('git ${args.join(' ')}: ${r.stderr}');
}

void write(String path, String text) {
  final f = File(p.join(root, path));
  f.parent.createSync(recursive: true);
  f.writeAsStringSync(text);
}

String gitOut(List<String> args) => Process.runSync('git', args, workingDirectory: root).stdout as String;

Matcher refused(String part) => throwsA(isA<MapError>().having((e) => e.message, 'message', contains(part)));

const cache = {
  'id': 'track-cache',
  'title': 'Track cache',
  'summary': 'Tracks from disk first.',
  'paths': ['src/cache/', 'a.txt'],
  'graph': {
    'nodes': [
      {'name': 'TrackCache', 'status': 'context', 'role': 'Keeps tracks on disk.', 'path': 'src/cache/TrackCache.kt', 'line': 1},
    ],
  },
};

const seq = 'sequenceDiagram\n  A->>B: go';
const stateSrc = 'stateDiagram-v2\n  [*] --> preview\n  preview --> nap';

void main() {
  setUpAll(() {
    _tmp = Directory.systemTemp.createTempSync('deck-map-');
    root = _tmp.path;
    git(['init', '-q', '-b', 'main']);
    write('a.txt', 'one\n');
    write('b.txt', 'new file\n');
    write('src/cache/TrackCache.kt', 'class TrackCache\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
    map = MapStore(root);
  });

  tearDownAll(() => _tmp.deleteSync(recursive: true));

  group('the feature map', () {
    test('is empty before the first pass', () async {
      final m = await map.readMap();
      expect(m.commit, isNull);
      expect(m.features, isEmpty);
      expect(m.staleFeatures, isEmpty);
    });

    test('writes one file per feature in a folder that ignores itself', () async {
      final r = await map.writeFeature(cache);
      expect(r.warnings, isEmpty);
      expect(r.feature.paths, ['src/cache', 'a.txt']);
      expect(r.feature.graph!.nodes.single.path, 'src/cache/TrackCache.kt');
      expect(map.readFeature('track-cache'), r.feature);
      expect(File(p.join(root, '.skim/map/.gitignore')).readAsStringSync(), contains('\n*\n'));
      expect(gitOut(['status', '--porcelain']), '');
    });

    test('refuses a bad id, no path, a path outside the repository and a bad graph', () async {
      expect(map.writeFeature({...cache, 'id': 'Track Cache'}), refused('lowercase slug'));
      expect(map.writeFeature({...cache, 'paths': <String>[]}), refused('at least one path'));
      expect(
        map.writeFeature({
          ...cache,
          'paths': ['nope'],
        }),
        refused('Path not in the repository: nope'),
      );
      expect(
        map.writeFeature({
          ...cache,
          'paths': ['../x'],
        }),
        refused('Path not in the repository'),
      );
      expect(
        map.writeFeature({
          ...cache,
          'paths': ['./'],
        }),
        refused('not the whole repository'),
      );
      expect(
        (await map.writeFeature({
          ...cache,
          'id': 'spelled',
          'paths': ['./src/cache/', 'src/cache'],
        })).feature.paths,
        ['src/cache'],
      );
      map.removeFeature('spelled');
      expect(
        map.writeFeature({
          ...cache,
          'graph': {
            'nodes': [
              {'name': 'A', 'status': 'context', 'path': 'gone.kt'},
            ],
          },
        }),
        refused('Path not in the repository: gone.kt'),
      );
    });

    test('tells which features a commit made stale and which changed files no feature claims', () async {
      final stamped = await map.stamp();
      expect(stamped.commit, stamped.head);
      write('src/cache/TrackCache.kt', 'class TrackCache(val max: Int)\n');
      write('c.txt', 'new\n');
      git(['add', '.']);
      git(['commit', '-q', '-m', 'more']);
      final m = await map.readMap();
      expect([...m.changedFiles]..sort(), ['c.txt', 'src/cache/TrackCache.kt']);
      expect(m.staleFeatures, ['track-cache']);
      expect(m.uncoveredFiles, ['c.txt']);
    });

    test('marks every feature stale when the stamped commit is gone', () async {
      write('.skim/map/index.json', jsonEncode({'commit': 'f' * 40, 'updatedAt': 'x'}));
      final m = await map.readMap();
      expect(m.commitMissing, isTrue);
      expect(m.staleFeatures, ['track-cache']);
    });

    test('judges a feature from the commit it was drawn at, not from the stamp', () async {
      expect((await map.stamp()).staleFeatures, ['track-cache']);
      await map.writeFeature(cache);
      expect((await map.readMap()).staleFeatures, isEmpty);
    });

    test('leaves out a feature file that does not parse', () async {
      write('.skim/map/features/broken.json', '{"id": "bro');
      expect((await map.readMap()).features.map((f) => f.id), ['track-cache']);
      File(p.join(root, '.skim/map/features/broken.json')).deleteSync();
    });
  });

  group('the views of a map feature', () {
    const base = {
      'id': 'clock-screen',
      'title': 'Clock screen',
      'paths': ['src/cache'],
    };

    test('reads a file written with one sequence as one main flow', () {
      write(
        '.skim/map/features/old-one.json',
        jsonEncode({
          'id': 'old-one',
          'title': 'Old one',
          'paths': ['a.txt'],
          'graph': null,
          'sequence': {'mermaid': seq, 'caption': 'the flow', 'steps': <Object>[]},
          'commit': 'abc',
        }),
      );
      final f = map.readFeature('old-one');
      expect(f.sequences.single.caption, 'the flow');
      expect(f.sequences.single.title, '');
      map.removeFeature('old-one');
    });

    test('stores every view and warns about a feature not drawn yet', () async {
      final r = await map.writeFeature({
        ...base,
        'graph': {
          'nodes': [
            {'name': 'ClockScreen', 'status': 'context', 'side': 'clock', 'path': 'src/cache/TrackCache.kt', 'line': 1},
            {'name': 'Nap', 'status': 'context', 'side': 'clock', 'feature': 'nap'},
          ],
          'edges': [
            {'from': 'ClockScreen', 'to': 'Nap', 'kind': 'uses'},
          ],
        },
        'sequences': [
          {
            'title': 'Timer',
            'mermaid': seq,
            'steps': [
              {'title': 'go', 'mark': 'concern', 'severity': 'high', 'why': 'races'},
            ],
          },
          {'title': 'Alarm', 'mermaid': seq},
        ],
        'states': [
          {
            'title': 'Mode',
            'mermaid': stateSrc,
            'transitions': [
              {'title': 'Nap starts', 'path': 'a.txt', 'line': 2},
            ],
          },
        ],
        'links': [
          {'feature': 'nap', 'kind': 'calls', 'detail': 'starts a nap'},
          {'feature': 'track-cache', 'kind': 'calledBy'},
        ],
        'notes': [
          {'kind': 'dead-code', 'text': ' Old timer. ', 'path': 'a.txt', 'line': 3},
        ],
      });
      expect(r.feature.graph!.nodes[1].feature, 'nap');
      expect(r.feature.sequences.map((q) => q.title), ['Timer', 'Alarm']);
      expect(r.feature.sequences[0].steps[0].severity, 'high');
      expect(r.feature.states[0].transitions.single.line, 2);
      expect(r.feature.notes.single.text, 'Old timer.');
      expect(r.warnings, ['No feature "nap" in the map yet: write it in this pass, or fix the link.']);
      expect((await map.readMap()).brokenLinks.map((l) => '${l.from}>${l.to}'), ['clock-screen>nap']);
      expect(map.stamp(), refused('Not stamped: links to features the map does not have (clock-screen -> nap)'));
      await map.writeFeature({
        'id': 'nap',
        'title': 'Nap',
        'paths': ['a.txt'],
      });
      expect((await map.readMap()).brokenLinks, isEmpty);
    });

    test('refuses a malformed view', () {
      Future<Object?> w(Map<String, Object?> extra) => map.writeFeature({...base, ...extra});
      const s = {'mermaid': seq};
      expect(
        w({
          'sequence': s,
          'sequences': [s],
        }),
        refused('not both'),
      );
      expect(
        w({
          'sequences': [
            for (var i = 0; i < 4; i++) {...s, 'title': 'f$i'},
          ],
        }),
        refused('at most 3 sequences'),
      );
      expect(
        w({
          'sequences': [
            {...s, 'title': 'a'},
            s,
          ],
        }),
        refused('each needs a title'),
      );
      expect(
        w({
          'sequences': [
            {'mermaid': ' '},
          ],
        }),
        refused('needs its mermaid source'),
      );
      expect(
        w({
          'sequences': [
            {'mermaid': 'sequenceDiagram\n  participant Par as Parent\n  Par->>B: go'},
          ],
        }),
        refused('participant "Par" is a mermaid keyword'),
      );
      expect(
        w({
          'sequences': [
            {
              ...s,
              'steps': [
                {'title': 'x', 'severity': 'high'},
              ],
            },
          ],
        }),
        refused('goes with mark concern'),
      );
      expect(
        w({
          'states': [
            {'title': 'Mode', 'mermaid': seq},
          ],
        }),
        refused('must be mermaid stateDiagram-v2'),
      );
      expect(
        w({
          'links': [
            {'feature': 'clock-screen', 'kind': 'calls'},
          ],
        }),
        refused('does not link to itself'),
      );
      expect(
        w({
          'links': [
            {'feature': 'nap', 'kind': 'uses'},
          ],
        }),
        refused('link kind must be one of calls, calledBy'),
      );
      expect(
        w({
          'notes': [
            {'kind': 'todo', 'text': 'x'},
          ],
        }),
        refused('note kind must be one of'),
      );
    });

    test('confirms a stale feature at head, unless a path is gone', () async {
      final before = map.readFeature('nap');
      write('a.txt', 'changed again\n');
      git(['add', '.']);
      git(['commit', '-q', '-m', 'fix inside']);
      expect((await map.readMap()).staleFeatures, contains('nap'));
      final after = await map.confirmFeature('nap');
      expect(after.commit, isNot(before.commit));
      expect(after.copyWith(commit: '', updatedAt: ''), before.copyWith(commit: '', updatedAt: ''));
      expect((await map.readMap()).staleFeatures, isNot(contains('nap')));
      await map.writeFeature({
        'id': 'moving',
        'title': 'Moving',
        'paths': ['c.txt'],
      });
      git(['rm', '-q', 'c.txt']);
      git(['commit', '-q', '-m', 'gone']);
      expect(map.confirmFeature('moving'), refused('Paths gone from the repository: c.txt'));
    });
  });

  group('the data dictionary', () {
    const envelope = {
      'name': 'Envelope',
      'boundary': 'wire',
      'since': '1',
      'fields': [
        {'name': 'type', 'type': 'String', 'note': ' the kind '},
        {'name': 'payload', 'type': 'ClockState', 'optional': true},
      ],
      'definitions': [
        {'path': './a.txt', 'line': 1},
        {'path': 'b.txt'},
      ],
    };

    test('writes one file per type, with every place it is declared', () async {
      final t = await map.writeDataType('envelope', envelope);
      expect(t.definitions.map((d) => '${d.path}:${d.line}'), ['a.txt:1', 'b.txt:null']);
      expect(t.fields.first.note, 'the kind');
      expect(map.readDataType('envelope'), t);
    });

    test('refuses a bad id, boundary, field or definition', () {
      expect(map.writeDataType('Bad Id', envelope), refused('lowercase slug'));
      expect(map.writeDataType('x', {...envelope, 'boundary': 'memory'}), refused('data boundary must be one of wire, storage, url, file'));
      expect(map.writeDataType('x', {...envelope, 'definitions': <Object>[]}), refused('at least one definition'));
      expect(
        map.writeDataType('x', {
          ...envelope,
          'definitions': [
            {'path': 'gone.dart'},
          ],
        }),
        refused('Path not in the repository: gone.dart'),
      );
      expect(
        map.writeDataType('x', {
          ...envelope,
          'fields': [
            {'name': 'a', 'type': 'int'},
            {'name': 'a', 'type': 'int'},
          ],
        }),
        refused('appears twice'),
      );
    });

    test('goes stale when a file that declares it changes', () async {
      write('b.txt', 'new field\n');
      git(['add', '.']);
      git(['commit', '-q', '-m', 'envelope grows']);
      expect((await map.readMap()).staleData, ['envelope']);
      await map.writeDataType('envelope', envelope);
      expect((await map.readMap()).staleData, isEmpty);
      map.removeDataType('envelope');
      expect(() => map.readDataType('envelope'), refused('No data type "envelope"'));
    });
  });

  group('a stopped pass', () {
    test('keeps its plan, says what is left, and a stamp clears it', () async {
      final drawn = map.readFeatures().map((f) => f.id).toList();
      map.writePlan([...drawn.take(1), 'later-one']);
      await Future<void>.delayed(const Duration(milliseconds: 5));
      var m = await map.readMap();
      expect(m.plan, [drawn.first, 'later-one']);
      expect(m.planLeft, [drawn.first, 'later-one']);
      await map.confirmFeature(drawn.first);
      m = await map.readMap();
      expect(m.planLeft, ['later-one']);
      await map.writeFeature({
        'id': 'later-one',
        'title': 'Later one',
        'paths': ['a.txt'],
      });
      expect((await map.readMap()).planLeft, isEmpty);
      await map.stamp();
      expect((await map.readMap()).plan, isEmpty);
    });
  });

  group('the architecture', () {
    const arch = {
      'summary': 'Two layers.',
      'layers': [
        {
          'id': 'view',
          'name': 'Views',
          'naming': ['*Screen'],
          'paths': ['src'],
        },
        {
          'id': 'store',
          'name': 'Stores',
          'naming': ['*Store'],
        },
      ],
      'flows': [
        {'from': 'view', 'to': 'store'},
      ],
      'violations': [
        {
          'from': 'HomeScreen',
          'fromLayer': 'view',
          'to': ['Db'],
          'toLayer': 'store',
          'severity': 'high',
          'why': 'Writes the db itself.',
          'path': 'a.txt',
          'line': 1,
        },
      ],
      'sources': ['b.txt'],
    };

    test('is written with its layers, flows and violations, and read back with the map', () async {
      final a = await map.writeArchitecture(arch);
      expect(a.layers.map((l) => l.id), ['view', 'store']);
      expect(a.violations.single.line, 1);
      final m = await map.readMap();
      expect(m.architecture, a);
      expect(m.staleArchitecture, isFalse);
    });

    test('refuses unknown layers, severities and paths', () {
      expect(map.writeArchitecture({...arch, 'layers': <Object>[]}), refused('at least one layer'));
      expect(
        map.writeArchitecture({
          ...arch,
          'flows': [
            {'from': 'view', 'to': 'db'},
          ],
        }),
        refused('flow to must be a layer id'),
      );
      expect(
        map.writeArchitecture({
          ...arch,
          'violations': [
            {'from': 'X', 'fromLayer': 'view', 'toLayer': 'store', 'severity': 'awful', 'why': 'x'},
          ],
        }),
        refused('violation severity must be one of high, medium, low, accepted'),
      );
      expect(
        map.writeArchitecture({
          ...arch,
          'sources': ['docs/none.md'],
        }),
        refused('Path not in the repository: docs/none.md'),
      );
    });

    test('goes stale when its docs change', () async {
      await map.writeArchitecture(arch);
      write('b.txt', 'new rules\n');
      git(['add', '.']);
      git(['commit', '-q', '-m', 'rules']);
      expect((await map.readMap()).staleArchitecture, isTrue);
    });
  });

  group('the UI', () {
    const ui = {
      'summary': 'One theme.',
      'rules': ['Colors come from the theme.'],
      'sources': ['b.txt'],
      'paths': ['src'],
      'tokens': [
        {'kind': 'color', 'name': 'c.label', 'path': 'a.txt', 'line': 1},
      ],
      'components': [
        {'name': 'CodeChip', 'role': 'A path.'},
      ],
      'screens': [
        {
          'name': 'HomeScreen',
          'uses': ['CodeChip'],
        },
      ],
      'duplicates': [
        {
          'title': 'Path chip',
          'severity': 'medium',
          'why': 'Same widget twice.',
          'use': 'CodeChip',
          'copies': [
            {'name': '_Chip', 'path': 'a.txt'},
            {'name': '_PathChip', 'path': 'b.txt', 'line': 2},
          ],
        },
      ],
      'breaks': [
        {'rule': 'Raw color', 'severity': 'low', 'why': 'Skips dark mode.', 'count': 4, 'path': 'a.txt'},
      ],
    };

    test('is written and read back with the map', () async {
      final u = await map.writeUi(ui);
      expect(u.duplicates.single.copies.last.line, 2);
      expect(u.breaks.single.count, 4);
      final m = await map.readMap();
      expect(m.ui, u);
      expect(m.staleUi, isFalse);
    });

    test('refuses a duplicate with one copy, unknown kinds and paths', () {
      expect(map.writeUi({...ui, 'paths': <Object>[]}), refused('paths must list the folders'));
      expect(
        map.writeUi({
          ...ui,
          'tokens': [
            {'kind': 'smell', 'name': 'x'},
          ],
        }),
        refused('token kind must be one of'),
      );
      expect(
        map.writeUi({
          ...ui,
          'duplicates': [
            {
              'title': 'X',
              'severity': 'low',
              'why': 'x',
              'copies': [
                {'name': 'A'},
              ],
            },
          ],
        }),
        refused('duplicate "X" needs two copies or more'),
      );
      expect(
        map.writeUi({
          ...ui,
          'breaks': [
            {'rule': 'X', 'severity': 'awful', 'why': 'x'},
          ],
        }),
        refused('break severity must be one of'),
      );
      expect(
        map.writeUi({
          ...ui,
          'sources': ['docs/none.md'],
        }),
        refused('Path not in the repository: docs/none.md'),
      );
    });

    test('goes stale when its guidelines change', () async {
      await map.writeUi(ui);
      write('b.txt', 'new UI rules\n');
      git(['add', '.']);
      git(['commit', '-q', '-m', 'rules']);
      expect((await map.readMap()).staleUi, isTrue);
    });
  });
}
