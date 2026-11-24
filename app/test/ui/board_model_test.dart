import 'package:deck/core/models/board_filter.dart';
import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/config.dart';
import 'package:deck/core/models/snapshot.dart';
import 'package:deck/ui/board/board_model.dart';
import 'package:deck/ui/board/filter_field.dart';
import 'package:flutter_test/flutter_test.dart' hide matches;

void main() {
  DeckCard card(String key, int score) =>
      DeckCard(key: key, provider: 'mail', lane: Lane.reply, ref: key, url: '', title: key, next: '', bucket: Bucket.action, score: score, kind: 'fyi');

  test('a snoozed card sinks below the others, whatever its rank', () {
    final now = DateTime(2026, 10, 17);
    final snaps = {
      'mail': Snapshot(cards: [card('high', 90), card('low', 10)]),
    };
    final triage = {'high': Triage(snoozeUntil: now.add(const Duration(days: 1)))};
    final items = buildItems(snaps, triage, const {}, const DeckConfig(), now);
    expect(items.map((i) => i.card.key), ['low', 'high']);
  });

  test('Flow: started cards are Doing until they wait on others, low value mail is swept, only today\'s done shows', () {
    final now = DateTime(2026, 11, 3, 15);
    DeckCard task(String key, int score, {Bucket bucket = Bucket.action}) =>
        DeckCard(key: key, provider: 'jira', lane: Lane.task, ref: key, url: '', title: key, next: '', bucket: bucket, score: score);
    final snaps = {
      'jira': Snapshot(
        cards: [
          task('a', 80),
          task('b', 60),
          task('started', 50),
          task('waits', 70, bucket: Bucket.blocked),
          task('started, now waits', 65, bucket: Bucket.blocked),
          task('started, now clear', 64, bucket: Bucket.clear),
          task('old', 40),
          task('today', 40),
        ],
      ),
      'mail': Snapshot(cards: [card('fyi', 30)]),
    };
    final triage = {
      'started': Triage(startedAt: now),
      'started, now waits': Triage(startedAt: now),
      'started, now clear': Triage(startedAt: now),
      'old': Triage(done: true, doneAt: now.subtract(const Duration(days: 1))),
      'today': Triage(done: true, doneAt: now),
    };
    final f = flowOf(buildItems(snaps, triage, const {}, const DeckConfig(), now), now);
    expect(f.next.map((i) => i.card.key), ['a', 'b']);
    expect(f.doing.map((i) => i.card.key), ['started']);
    expect(f.waiting.map((i) => i.card.key), ['waits', 'started, now waits']);
    expect(f.sweep.map((i) => i.card.key), ['fyi']);
    expect(f.done.map((i) => i.card.key), ['today']);
    expect(sweepSummary(f.sweep), '1 mail: 1 FYI.');
  });

  test('filter: any token inside a kind, every kind, and the text', () {
    final now = DateTime(2026, 11, 3);
    final items = buildItems(
      {
        'mail': Snapshot(cards: [card('mail a', 50)]),
        'jira': Snapshot(
          cards: [
            DeckCard(key: 'VPN-1', provider: 'jira', lane: Lane.task, ref: 'VPN-1', url: '', title: 'Fix crash', next: '', bucket: Bucket.action, score: 50),
          ],
        ),
      },
      const {},
      const {},
      const DeckConfig(),
      now,
    );
    List<String> keys(BoardFilter f) => [
      for (final i in items)
        if (matches(i, f)) i.card.key,
    ];
    const task = FilterOption(FilterKind.type, 'task', 'Tasks'), reply = FilterOption(FilterKind.type, 'reply', 'Replies');
    expect(keys(toggle(const BoardFilter(), task)), ['VPN-1']);
    expect(keys(toggle(toggle(const BoardFilter(), task), reply)).length, 2);
    expect(keys(toggle(const BoardFilter(providers: {'mail'}), task)), isEmpty);
    expect(keys(const BoardFilter(text: 'crash')), ['VPN-1']);
    expect(toggle(toggle(const BoardFilter(), task), task, remove: true), const BoardFilter());
  });

  test('each item lists its linked items, ranked; drops move cards between Flow columns', () {
    final now = DateTime(2026, 10, 17);
    final snaps = {
      'mail': Snapshot(cards: [card('a', 90), card('b', 50), card('c', 10)]),
    };
    final items = buildItems(snaps, {'c': Triage(startedAt: now)}, const {}, const DeckConfig(), now, links: {'a|c': true, 'b|c': true});
    final by = {for (final i in items) i.card.key: i};
    expect(by['c']!.links.map((l) => l.item.card.key), ['a', 'b']);
    expect(by['a']!.links.single.manual, isTrue);
    expect(linked(by['a']!, by['b']!), isFalse);
    expect(canDrop(by['a']!, FlowDrop.doing), isTrue);
    expect(canDrop(by['c']!, FlowDrop.doing), isFalse, reason: 'already started');
    expect(canDrop(by['c']!, FlowDrop.next), isTrue);
    expect(canDrop(by['a']!, FlowDrop.done), isTrue, reason: 'a mail can be marked done');
  });
}
