import 'package:deck/actions/launcher.dart';
import 'package:deck/core/classify/gitlab.dart';
import 'package:deck/core/classify/jira.dart';
import 'package:deck/core/classify/message.dart';
import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/config.dart';
import 'package:deck/core/models/records.dart';
import 'package:deck/core/projects.dart';
import 'package:deck/core/tickets.dart';
import 'package:flutter_test/flutter_test.dart';

final now = DateTime.utc(2026, 10, 15, 12);
DateTime daysAgo(int d) => now.subtract(Duration(days: d));

MrRecord mr({
  MrRole role = MrRole.review,
  List<ThreadRecord> threads = const [],
  String pipeline = 'SUCCESS',
  bool approved = false,
  List<String> approvers = const [],
  bool draft = false,
  int idle = 1,
}) => MrRecord(
  path: 'acme/mobile/vpn-ios',
  iid: 952,
  title: 'fix(AVPN-98): IKEv2 cold launch',
  url: 'https://gitlab.com/acme/mobile/vpn-ios/-/merge_requests/952',
  author: 'alex.kim',
  role: role,
  pipeline: pipeline,
  approved: approved,
  approvers: approvers,
  draft: draft,
  createdAt: daysAgo(5),
  updatedAt: daysAgo(idle),
  threads: threads,
);

void main() {
  group('merge requests', () {
    test('replies in my threads ask for another review', () {
      final t = [for (var i = 0; i < 3; i++) const ThreadRecord(start: 'sam.lee', last: 'alex.kim')];
      final c = classifyMr(mr(threads: t), 'sam.lee', now);
      expect(c.next, 'Answer 3 replies in your threads.');
      expect(c.reviewable, isTrue);
      expect(c.bucket, Bucket.action);
      expect(c.ref, 'vpn-ios!952');
      expect(c.lane, Lane.review);
    });

    test('threads waiting on me in my MR offer to address feedback', () {
      final t = [const ThreadRecord(start: 'alex.kim', last: 'alex.kim')];
      final c = classifyMr(mr(role: MrRole.mine, threads: t), 'sam.lee', now);
      expect(c.next, 'Answer 1 review thread.');
      expect(c.feedback, isTrue);
      expect(c.lane, Lane.mine);
    });

    test('threads waiting on me in my draft also offer feedback', () {
      final t = [const ThreadRecord(start: 'alex.kim', last: 'alex.kim')];
      final c = classifyMr(mr(role: MrRole.mine, draft: true, threads: t), 'sam.lee', now);
      expect(c.next, 'Answer 1 review thread, then finish the draft.');
      expect(c.feedback, isTrue);
    });

    test('a new review request asks for a review', () {
      final c = classifyMr(mr(), 'sam.lee', now);
      expect(c.next, 'Review it.');
      expect(c.reviewable, isTrue);
      expect(c.score, 73);
    });

    test('my approved MR with a green pipeline is ready to merge', () {
      final c = classifyMr(mr(role: MrRole.mine, approved: true, approvers: ['jordanPM']), 'sam.lee', now);
      expect(c.next, 'Merge it (your decision).');
      expect(c.tags.first.label, 'Ready to merge');
      expect(c.lane, Lane.mine);
    });

    test('my MR without reviewer waits, and says so after 3 idle days', () {
      final c = classifyMr(mr(role: MrRole.mine, idle: 4), 'sam.lee', now);
      expect(c.bucket, Bucket.blocked);
      expect(c.tags.first.label, 'No review for 4d');
    });

    test('my draft asks to finish it', () {
      final c = classifyMr(mr(role: MrRole.mine, draft: true), 'sam.lee', now);
      expect(c.next, 'Finish the draft and mark it ready.');
    });
  });

  group('jira', () {
    IssueRecord issue({String type = 'Story', String status = 'In Progress', CommentRecord? last, int idle = 2}) => IssueRecord(
      key: 'OM-801',
      summary: 'Customer cannot connect',
      url: 'https://acme.atlassian.net/browse/OM-801',
      status: status,
      statusCategory: 'indeterminate',
      type: type,
      created: daysAgo(30),
      updated: daysAgo(idle),
      lastComment: last,
    );

    test('escalation where my last reply is old asks for a status update', () {
      final c = classifyIssue(
        issue(
          type: 'Customer Escalation',
          last: CommentRecord(mine: true, at: daysAgo(15)),
        ),
        now,
      );
      expect(c.next, 'Post a status update. Your last reply was 15 days ago.');
      expect(c.tags.first.label, 'Customer Escalation');
    });

    test('issue without dates or comments still makes a card', () {
      const i = IssueRecord(
        key: 'OM-803',
        summary: 'No internet',
        url: 'https://acme.atlassian.net/browse/OM-803',
        status: 'In Progress',
        statusCategory: 'indeterminate',
        type: 'Customer Escalation',
      );
      final c = classifyIssue(i, now);
      expect(c.next, 'Check the last comment on the ticket.');
      expect(c.tags.map((t) => t.label), isNot(contains('No comments')));
      expect(
        classifyIssue(
          IssueRecord.fromJson({
            ...i.toJson()
              ..remove('created')
              ..remove('updated'),
          }),
          now,
        ).updatedAt,
        isNull,
      );
    });

    test('escalation with a comment from someone else waits on me', () {
      final c = classifyIssue(
        issue(
          type: 'Customer Escalation',
          last: CommentRecord(author: 'Jo', at: daysAgo(1)),
        ),
        now,
      );
      expect(c.next, 'Answer Jo.');
      expect(c.score, 84);
    });

    test('recent In Review waits for review', () {
      final c = classifyIssue(issue(status: 'In Review'), now);
      expect(c.bucket, Bucket.blocked);
    });
  });

  group('board issues', () {
    IssueRecord board(List<String> labels) => boardIssue(
      key: 'acme/vpn-ios#141',
      title: 'Benchmark WebExt',
      url: 'https://gitlab.com/acme/vpn-ios/-/work_items/141',
      labels: labels,
      createdAt: '2026-10-01T09:00:00Z',
      updatedAt: '2026-10-13T09:00:00Z',
    );

    test('a GitLab issue becomes a ticket of its project', () {
      final c = classifyIssue(board([]), now, provider: 'gitlab');
      expect(c.key, 'gitlab:acme/vpn-ios#141');
      expect(c.ref, 'vpn-ios#141');
      expect(c.path, 'acme/vpn-ios');
      expect(c.lane, Lane.task);
      expect(c.next, 'Plan it.');
      expect(projectsOf(c, const [ProjectConfig(id: 'p', name: 'P', board: 'gitlab:acme/vpn-ios')]), ['p']);
    });

    test('labels give the status', () {
      expect(classifyIssue(board(['WaitingForReview']), now, provider: 'github').bucket, Bucket.blocked);
      final blocked = classifyIssue(board(['Blocked']), now, provider: 'github');
      expect(blocked.bucket, Bucket.blocked);
      expect(blocked.next, 'Blocked. Check that the blocker still holds.');
      expect(classifyIssue(board(['In progress']), now, provider: 'github').next, 'Continue the work.');
    });
  });

  group('messages', () {
    MessageRecord msg({bool ask = true, bool done = false, bool task = false}) => MessageRecord(
      id: 'D1/1',
      url: 'https://slack.com/x',
      from: 'Jordan Park',
      where: 'DM',
      at: daysAgo(0),
      title: 'Joining daily?',
      ask: ask,
      need: 'Reply whether you are joining the daily',
      done: done,
      task: task,
    );

    test('an open ask becomes a card', () {
      final c = classifyMessage(msg(), 'slack', now)!;
      expect(c.next, 'Reply whether you are joining the daily');
      expect(c.lane, Lane.reply);
      expect(c.why, 'From Jordan Park');
    });

    test('no ask, or an answered ask, gives no card', () {
      expect(classifyMessage(msg(ask: false), 'slack', now), isNull);
      expect(classifyMessage(msg(done: true), 'slack', now), isNull);
    });

    test('an ask that is work is a task, and stays open after you replied', () {
      expect(classifyMessage(msg(task: true), 'slack', now)!.lane, Lane.task);
      expect(classifyMessage(msg(task: true, done: true), 'slack', now)!.lane, Lane.task);
    });

    test('lanes stored before the four types still read', () {
      Lane read(String old) =>
          DeckCard.fromJson({'key': 'k', 'provider': 'todo', 'lane': old, 'ref': '', 'url': '', 'title': '', 'next': '', 'bucket': 'action', 'score': 0}).lane;
      expect([read('asks'), read('tickets'), read('todos'), read('mine')], [Lane.reply, Lane.task, Lane.task, Lane.mine]);
    });
  });

  group('mail', () {
    MessageRecord mail(String id, String kind, {String from = 'news@example.com', int ago = 0}) =>
        MessageRecord(id: id, url: 'https://mail.google.com/x/$id', from: 'Example News', where: from, at: daysAgo(ago), title: 'Weekly digest', kind: kind);

    test('noise from one sender lands on one card with a filter action', () {
      final r = mergeMessages([], [mail('t1', 'noise'), mail('t2', 'noise'), mail('t3', 'noise', from: 'other@example.com')], 'mail', now);
      expect(r.cards, hasLength(2));
      final g = r.cards.firstWhere((c) => c.key == 'mail:from:news@example.com');
      expect(g.threads, ['t1', 't2']);
      expect(g.title, 'Weekly digest');
      expect(g.why, 'From Example News, 2 mails in the inbox');
      expect(g.next, 'Make a Gmail filter so these skip the inbox.');
      expect(actionsFor(g, const DeckConfig()).take(2), [CardAction.filter, CardAction.archive]);
    });

    test('platform senders never become noise', () {
      final r = mergeMessages([], [mail('t1', 'noise', from: 'jira@acme.atlassian.net')], 'mail', now);
      expect(r.cards.single.kind, 'fyi');
    });

    test('noise seen before the last check does not come back', () {
      final r = mergeMessages([], [mail('t1', 'noise', ago: 2)], 'mail', now, since: daysAgo(1));
      expect(r.cards, isEmpty);
    });

    test('fyi can be archived, phishing cannot', () {
      final fyi = classifyMessage(mail('t1', 'fyi'), 'mail', now)!;
      expect(fyi.next, 'Nothing asked. Archive it once read.');
      expect(actionsFor(fyi, const DeckConfig()).first, CardAction.archive);
      final bad = classifyMessage(mail('t2', 'phishing'), 'mail', now)!;
      expect(bad.threads, isEmpty);
      expect(actionsFor(bad, const DeckConfig()), isNot(contains(CardAction.archive)));
    });

    test('a notification about a card on the board is found', () {
      final ticket = IssueRecord(
        key: 'AVPN-65',
        summary: 'Paywall',
        url: 'https://x.atlassian.net/browse/AVPN-65',
        status: 'To Do',
        statusCategory: 'new',
        type: 'Story',
        created: daysAgo(3),
        updated: daysAgo(1),
      );
      final cards = [classifyMr(mr(), 'sam.lee', now), classifyIssue(ticket, now)];
      expect(onBoard('vpn-ios!952', cards), isTrue);
      expect(onBoard('!952', cards), isTrue);
      expect(onBoard('vpn-android!952', cards), isFalse);
      expect(onBoard('vpn-ios!953', cards), isFalse);
      expect(onBoard(cards[1].ref, cards), isTrue);
      expect(onBoard('LT-1', cards), isFalse);
    });

    test('asks already tracked make no card of their own', () {
      final ticket = classifyIssue(
        IssueRecord(key: 'OM-7', summary: 'Purchase fails', url: 'https://x/browse/OM-7', status: 'To Do', statusCategory: 'new', type: 'Bug'),
        now,
      );
      MessageRecord msg(String id, {String? about, bool team = false}) => MessageRecord(
        id: id,
        url: 'https://slack/$id',
        from: 'Roman',
        where: '#vpn-apps',
        at: daysAgo(0),
        title: 'Cannot buy yearly',
        ask: true,
        task: true,
        need: 'Check the purchase error',
        about: about,
        team: team,
      );
      final f = foldTracked(
        [msg('a', about: 'OM-7'), msg('b', about: 'OM-9', team: true), msg('c', about: 'OM-9'), msg('d', team: true), msg('e', about: 'OM-7')],
        [ticket],
        {'slack:e'},
        'slack',
      );
      expect(f.keep.map((m) => m.id), ['c', 'd', 'e']);
      expect(f.notes, {
        ticket.key: ['From Roman in #vpn-apps: Check the purchase error https://slack/a'],
      });
      final team = classifyMessage(msg('d', team: true), 'slack', now)!;
      expect(team.lane, Lane.task);
      expect(team.tags.map((t) => t.label), contains('Team'));
    });

    test('a task from Slack offers a ticket on its project board', () {
      const cfg = DeckConfig(
        projects: [
          ProjectConfig(id: 'vpn', name: 'VPN', board: 'jira:OM', channels: ['#vpn-apps']),
          ProjectConfig(id: 'web', name: 'Web', board: 'gitlab:acme/web', channels: ['#web']),
        ],
      );
      final m = MessageRecord(
        id: 'x',
        url: 'https://slack/x',
        from: 'Roman',
        where: '#vpn-apps',
        at: daysAgo(0),
        title: 'Cannot buy yearly',
        ask: true,
        task: true,
        need: 'Check the purchase error',
      );
      final c = classifyMessage(m, 'slack', now)!;
      expect(ticketBoard(c, cfg.projects), (provider: 'jira', target: 'OM'));
      expect(actionsFor(c, cfg), contains(CardAction.ticket));
      expect(ticketDraft(c), (title: 'Cannot buy yearly', body: 'Check the purchase error\n\nRaised by Roman in #vpn-apps: https://slack/x'));
      // A reply is not work to track; no board, no ticket.
      expect(ticketBoard(classifyMessage(m.copyWith(task: false), 'slack', now)!, cfg.projects), isNull);
      expect(ticketBoard(classifyMessage(m.copyWith(where: '#random'), 'slack', now)!, cfg.projects), isNull);
    });

    test('Gmail filter link fills the sender', () {
      expect(gmailFilterUrl('a+b@x.com'), 'https://mail.google.com/mail/u/0/#create-filter/from=a%2Bb%40x.com');
    });
  });

  test('cards survive a JSON round trip', () {
    final c = classifyMr(mr(), 'sam.lee', now);
    expect(DeckCard.fromJson(c.toJson()), c);
  });
}
