import 'dart:io';

import 'package:deck/claude/facts.dart';
import 'package:deck/core/models/overview.dart';
import 'package:deck/data/deck_home.dart';
import 'package:deck/data/overview_store.dart';
import 'package:deck/state/project_overview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('deck-overview'));
  tearDown(() => dir.deleteSync(recursive: true));

  ProjectUpdate u(String id, DateTime at) => ProjectUpdate(id: id, at: at, provider: 'slack', source: '#team', text: id);

  test('updates are appended once each, newest first, stamped when added', () async {
    final store = OverviewStore(DeckHome(dir.path));
    expect(await store.add('p', [u('a', DateTime(2026, 11, 1)), u('b', DateTime(2026, 11, 2))]), 2);
    expect(await store.add('p', [u('a', DateTime(2026, 11, 1)), u('c', DateTime(2026, 10, 1))]), 1);
    final all = await store.updates('p');
    expect(all.map((x) => x.id), ['b', 'a', 'c']);
    expect(all.every((x) => x.added != null), isTrue);
    expect(newSince(all, all.first.added!.subtract(const Duration(seconds: 1))), 3);
    expect(newSince(all, all.first.added!.add(const Duration(seconds: 1))), 0);
  });

  test('documents are kept once per url, a removed one stays out until you add it again', () async {
    final store = OverviewStore(DeckHome(dir.path));
    ProjectDoc d(String url, String title) => ProjectDoc(url: url, title: title, provider: 'slack', at: DateTime(2026, 11, 1));
    expect(await store.addDocs('p', [d('https://a', 'A'), d('https://b', 'B')]), 2);
    expect(await store.addDocs('p', [d('https://a', 'A again')]), 0);
    await store.removeDoc('p', 'https://a');
    expect(await store.addDocs('p', [d('https://a', 'A')]), 0);
    expect((await store.docs('p')).firstWhere((x) => x.url == 'https://a').removed, isTrue);
    expect(await store.addDocs('p', [d('https://a', 'Mine')], force: true), 1);
    expect((await store.docs('p')).map((x) => (x.title, x.removed)), containsAll([('Mine', false), ('B', false)]));
  });

  test('facts are read from a fenced answer, unknown sections and empty lines dropped', () {
    final facts = parseFacts(
      'Here:\n```json\n[{"section":"release","text":"Freeze Nov 12","was":"Nov 5"},{"section":"gossip","text":"x"},{"section":"people","text":" "}]\n```',
    );
    expect(facts, [const Fact(section: 'release', text: 'Freeze Nov 12', was: 'Nov 5')]);
  });

  test('a fact keeps the ref of an update it was given, never a made up one', () {
    final facts = parseFacts('[{"section":"release","text":"A","ref":"slack:1"},{"section":"release","text":"B","ref":"slack:9"}]', refs: {'slack:1'});
    expect(facts.map((f) => f.ref), ['slack:1', null]);
  });
}
