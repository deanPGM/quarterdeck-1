import 'package:deck/core/auto_close.dart';
import 'package:deck/core/classify/message.dart';
import 'package:deck/core/classify/todo.dart';
import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/records.dart';
import 'package:deck/core/models/snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 10, 15, 9, 30);

MessageRecord _msg({bool done = false, bool ask = true, bool waiting = false}) =>
    MessageRecord(id: 'C1/2', url: 'https://x.slack.com/archives/C1/p2', at: _now, title: 'Deploy?', ask: ask, need: 'Decide.', done: done, waiting: waiting);

void main() {
  test('reads the project and iid from a merge request link', () {
    expect(mrOfUrl('https://gitlab.com/acme/platform/backend/-/merge_requests/412'), ('acme/platform/backend', 412));
    expect(mrOfUrl('https://gitlab.com/acme/x/-/merge_requests/9#note_1'), ('acme/x', 9));
    expect(mrOfUrl('https://gitlab.com/acme/x/-/issues/9'), isNull);
    expect(mrOfUrl(''), isNull);
  });

  test('only open todos with a merge request link are checked', () {
    DeckCard todo(String key, String url) => classifyTodo({'title': 't', 'need': 'n', 'url': url}, _now).copyWith(key: key);
    final snap = Snapshot(
      cards: [
        todo('a', 'https://gitlab.com/p/-/merge_requests/1'),
        todo('b', 'https://gitlab.com/p/-/merge_requests/2'),
        todo('c', 'https://gitlab.com/p/-/merge_requests/3'),
        todo('d', 'https://slack.com/x'),
      ],
    );
    final triage = {'b': const Triage(done: true), 'c': const Triage(keepOpen: true)};
    expect([for (final (c, _, _) in openMrTodos(snap, triage)) c.key], ['a']);
  });

  test('closing keeps your triage, skips done and reopened cards', () {
    final out = closeCards({'a': const Triage(pin: true), 'b': const Triage(done: true), 'c': const Triage(keepOpen: true)}, ['a', 'b', 'c', 'd'], 'MR merged');
    expect(out['a'], const Triage(pin: true, done: true, doneReason: 'MR merged'));
    expect(out['b'], const Triage(done: true));
    expect(out['c'], const Triage(keepOpen: true));
    expect(out['d'], const Triage(done: true, doneReason: 'MR merged'));
  });

  group('merging messages read again', () {
    final open = classifyMessage(_msg(), 'slack', _now)!;

    test('an ask you answered since is kept and reported as replied', () {
      final r = mergeMessages([open], [_msg(done: true)], 'slack', _now);
      expect(r.cards.map((c) => c.key), ['slack:C1/2']);
      expect(r.replied, ['slack:C1/2']);
    });

    test('an ask you answered and now wait on moves to waiting', () {
      final r = mergeMessages([open], [_msg(waiting: true)], 'slack', _now);
      expect(r.cards.single.bucket, Bucket.blocked);
      expect(r.replied, isEmpty);
    });

    test('a new message already answered never shows', () {
      final r = mergeMessages([], [_msg(done: true)], 'slack', _now);
      expect(r.cards, isEmpty);
      expect(r.replied, isEmpty);
    });

    test('a message no longer judged an ask keeps the old card', () {
      final r = mergeMessages([open], [_msg(ask: false)], 'slack', _now);
      expect(r.cards.single, open);
      expect(r.replied, isEmpty);
    });

    test('a message from before the last check is skipped, unless its card is open', () {
      final open = classifyMessage(_msg(), 'slack', _now)!;
      final again = MessageRecord(id: 'C1/2-other-id', url: 'https://x.slack.com/archives/C1/p2', at: _now, title: 'Deploy?', ask: true, need: 'Decide.');
      final since = _now.add(const Duration(minutes: 1));
      expect(mergeMessages([], [again], 'slack', _now, since: since).cards, isEmpty);
      expect(mergeMessages([open], [_msg(done: true)], 'slack', _now, since: since).replied, ['slack:C1/2']);
      expect(mergeMessages([], [again], 'slack', _now, since: _now.subtract(const Duration(minutes: 1))).cards, hasLength(1));
    });
  });

  group('leftInbox', () {
    DeckCard mail(String id, String kind, {List<String>? threads, DateTime? at, String from = 'news@acme.com'}) => DeckCard(
      key: 'mail:$id',
      provider: 'mail',
      lane: Lane.reply,
      ref: from,
      url: 'https://mail.google.com',
      title: id,
      next: '',
      bucket: Bucket.action,
      score: 30,
      kind: kind,
      updatedAt: at ?? _now,
      channel: from,
      threads: threads ?? [id],
    );
    final later = _now.add(const Duration(hours: 1));

    test('closes FYI and noise whose mail left the inbox, never asks', () {
      final cards = [
        mail('a', 'fyi'),
        mail('b', 'fyi'),
        mail('c', 'ask'),
        mail('n', 'noise', threads: ['n1', 'n2']),
      ];
      expect(
        leftInbox(cards, {
          'news@acme.com': {'b'},
        }, later),
        ['mail:a', 'mail:n'],
      );
    });

    test('keeps a noise group while one of its mails is still in the inbox', () {
      final group = mail('n', 'noise', threads: ['n1', 'n2']);
      expect(
        leftInbox(
          [group],
          {
            'news@acme.com': {'n2'},
          },
          later,
        ),
        isEmpty,
      );
    });

    test('keeps the cards of a sender the listing left out', () {
      expect(leftInbox([mail('a', 'fyi', from: 'sam@acme.com')], {'news@acme.com': {}}, later), isEmpty);
    });

    test('keeps mail that came in after the inbox was listed', () {
      expect(leftInbox([mail('a', 'fyi', at: later)], {'news@acme.com': {}}, _now), isEmpty);
    });

    test('checks only FYI and noise mail with a sender email', () {
      expect(inboxSender(mail('a', 'fyi', from: ' News@Acme.com')), 'news@acme.com');
      expect(inboxSender(mail('a', 'ask')), isNull);
      expect(inboxSender(mail('a', 'fyi', from: 'Acme News')), isNull);
      expect(inboxSender(mail('a', 'fyi', from: 'x@acme.com}-in:inbox{')), isNull);
    });
  });
}
