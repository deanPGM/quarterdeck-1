// Port of Skim's core/tests/summary.test.ts and gitlab/tests/positions.test.ts,
// plus GitHub's comment placing and matching.
import 'package:deck/core/review/anchors.dart';
import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/parse.dart';
import 'package:deck/core/review/positions.dart';
import 'package:deck/core/review/publish_plan.dart';
import 'package:deck/core/review/review.dart';
import 'package:flutter_test/flutter_test.dart';

const _diff = '''diff --git a/x.txt b/x.txt
--- a/x.txt
+++ b/x.txt
@@ -1,4 +1,5 @@
 one
-two
+two changed
 three
 four
+five
''';

DiffSnapshot snap() => DiffSnapshot(baseSha: 'b', headSha: 'h', baseRef: 'main', headRef: 'HEAD', files: parseUnifiedDiff(_diff));

Message msg(String body, [String? suggestion, String author = 'agent', String at = '']) =>
    Message(id: body, author: author, body: body, suggestion: suggestion, createdAt: at);

const refs = DiffRefs(baseSha: 'base', startSha: 'start', headSha: 'head');

void main() {
  group('renderSummary', () {
    test('opens with the ticket verdict, what is missing and what nobody asked for', () {
      final body = renderSummary(
        roundNumber: 1,
        verdict: 'comment',
        notes: [],
        groups: [],
        hiddenCount: 0,
        publishedSeverities: [],
        skipped: 0,
        replies: 0,
        tickets: [
          (
            ref: 'APP-231',
            url: 'https://jira/browse/APP-231',
            title: 'Disk cache',
            check: const TicketCheck(
              ref: 'APP-231',
              headSha: 'h',
              verdict: 'partial',
              summary: 'Cache is in, the retry is not.',
              items: [
                TicketCheckItem(text: 'cache on disk', state: 'done', paths: ['lib/cache.dart']),
                TicketCheckItem(text: 'retry on 429', state: 'missing'),
                TicketCheckItem(text: 'renames the logger', state: 'extra', paths: ['lib/log.dart']),
              ],
            ),
          ),
          (ref: '#12', url: null, title: null, check: null),
        ],
      );
      expect(
        body,
        contains(
          '### Ticket [APP-231](https://jira/browse/APP-231), Disk cache\n\n**Partly done.** Cache is in, the retry is not.\n\nMissing:\n\n- retry on 429\n\nNot in the ticket:\n\n- renames the logger (`lib/log.dart`)',
        ),
      );
      expect(body, isNot(contains('cache on disk')));
      expect(body, isNot(contains('#12')));
    });

    test('renders verdict, reading order with notes, loose files, thread counts and noise', () {
      final body = renderSummary(
        roundNumber: 2,
        verdict: 'request_changes',
        notes: const [
          FileNote(path: 'lib/cache.dart', summary: 'New LRU cache'),
          FileNote(path: 'lib/api.dart', summary: 'Reads the cache first'),
          FileNote(path: 'test/cache_test.dart', summary: 'Covers eviction'),
        ],
        groups: const [
          ReviewGroup(
            title: 'Core',
            overview: 'The cache.',
            items: [
              GroupItem(path: 'lib/cache.dart'),
              GroupItem(path: 'lib/cache.dart', hunkRef: 'h2'),
            ],
          ),
          ReviewGroup(
            title: 'Call sites',
            items: [GroupItem(path: 'lib/api.dart')],
          ),
        ],
        hiddenCount: 4,
        publishedSeverities: ['must-fix', 'nit', 'must-fix'],
        skipped: 1,
        replies: 2,
      );
      expect(body, contains('## Review, round 2'));
      expect(body, contains('**Changes requested**'));
      expect(body, contains('1. **Core**: The cache.\n   - `lib/cache.dart`: New LRU cache\n2. **Call sites**\n   - `lib/api.dart`: Reads the cache first'));
      expect(RegExp(r'lib/cache\.dart').allMatches(body), hasLength(1));
      expect(body, contains('### Other files\n\n- `test/cache_test.dart`: Covers eviction'));
      expect(body, contains('3 inline threads: 2 must-fix, 1 nit.'));
      expect(body, contains('2 replies on earlier threads.'));
      expect(body, contains('1 finding not posted'));
      expect(body, contains('4 files hidden from the review'));
    });

    test('stays short when there is nothing to say', () {
      final body = renderSummary(roundNumber: 1, verdict: 'approve', notes: [], groups: [], hiddenCount: 0, publishedSeverities: [], skipped: 0, replies: 0);
      expect(body, contains('**Approved**'));
      expect(body, contains('No inline threads in this round.'));
      expect(body, isNot(contains('### Reading order')));
      expect(body, isNot(contains('replies')));
    });
  });

  group('suggestions and bodies', () {
    test('a patch becomes a suggestion over the anchored span, plain text is used as is', () {
      expect(suggestionBlock('-  final x = a;\n+  final x = b;\n+  use(x);\n', 0), '```suggestion:-0+0\n  final x = b;\n  use(x);\n```');
      expect(suggestionBlock('-a\n-b\n+c', 1), '```suggestion:-0+1\nc\n```');
      expect(suggestionBlock('reason: err.message.slice(0, 200),', 0), '```suggestion:-0+0\nreason: err.message.slice(0, 200),\n```');
    });

    test('the opening note is the answer, with its suggestion', () {
      const a = Anchor(path: 'a', hunkRef: 'h', line: 4, endLine: 5, contentHash: 'c');
      Thread t(Message? answer) =>
          Thread(id: 't', anchor: a, severity: 'suggestion', state: 'open', authorType: 'agent', messages: [msg('talk', '-q\n+r')], answer: answer);
      expect(threadBody(t(msg('finding'))), 'finding');
      expect(threadBody(t(msg('finding', '-x\n+y'))), 'finding\n\n```suggestion:-0+1\ny\n```');
      expect(threadBody(t(msg('finding', '-x\n+y')), gitHubSuggestion), 'finding\n\n```suggestion\ny\n```');
      expect(threadBody(t(null)), '');
    });
  });

  group('planPublish', () {
    test('posts open threads with an accepted answer, skips outdated and unpushed ones, keeps what an earlier attempt posted', () {
      final s = snap();
      final on2 = anchorFor(s, path: 'x.txt', line: 2);
      final gone = on2.copyWith(hunkRef: 'zz', contentHash: 'nothing');
      Thread t(String id, {Anchor? anchor, String state = 'open', String? remoteId, bool answer = true}) => Thread(
        id: id,
        anchor: anchor,
        severity: 'nit',
        state: state,
        authorType: 'agent',
        remoteId: remoteId,
        answer: answer ? msg(id) : null,
        decision: answer ? 'accept' : null,
      );
      final plan = planPublish(
        [
          t('a', anchor: on2),
          t('b'),
          t('c', anchor: gone),
          t('d', anchor: on2, state: 'dismissed'),
          t('e', anchor: on2, remoteId: '9', answer: false),
          t('f', anchor: on2, answer: false),
          t('g', anchor: on2),
          t('h', anchor: on2).copyWith(decision: null),
          t('i', anchor: on2).copyWith(decision: 'reject'),
        ],
        s,
        unpushed: {'g': 'abcdef1234'},
      );
      expect(plan.post.map((p) => p.thread.id), ['a', 'b']);
      expect(plan.skipped.map((k) => k.threadId), ['c', 'g']);
      expect(plan.skipped.last.reason, 'its fix abcdef12 is not pushed yet');
      expect(plan.alreadyPosted.single.id, 'e');
      // Your own merge request: a thread born in Deck stays there.
      expect(planPublish([t('a', anchor: on2), t('b')], s, own: true).post, isEmpty);
    });

    test('an answer on a thread already on the forge goes out as a reply, never the talk', () {
      Thread t(String id, {String state = 'published', Message? answer, String? decision = 'accept'}) => Thread(
        id: id,
        severity: 'nit',
        state: state,
        authorType: 'remote',
        remoteId: 'd$id',
        messages: [msg('**@alex**\n\nWhy?', null, 'remote'), msg('talk', null, 'agent')],
        answer: answer,
        decision: decision,
      );
      final threads = [
        t('1', answer: msg('Because.', null, 'agent')),
        t('2'),
        t('3', state: 'resolved', answer: msg('late')),
        t('4', answer: msg('x')),
        t('5', answer: msg('not decided'), decision: null),
      ];
      expect(plannedReplies(threads, {}).map((t) => t.id), ['1', '4']);
      expect(plannedReplies(threads, {'1'}, unpushed: {'4': 'abc'}), isEmpty);
    });

    test('a reviewer thread waits on you until the last word on the forge is yours', () {
      Thread th(List<Message> m, {String state = 'published'}) =>
          Thread(id: 't', severity: 'question', state: state, authorType: 'remote', remoteId: 'd', messages: m);
      final asked = msg('**@alex**\n\nWhy?', null, 'remote');
      expect(waitsOnYou(th([asked]), me: 'sam'), isTrue);
      expect(waitsOnYou(th([asked, msg('chat', null, 'agent')]), me: 'sam'), isTrue);
      expect(waitsOnYou(th([asked, msg('**@sam**\n\nBecause.', null, 'remote')]), me: 'sam'), isFalse);
      expect(
        waitsOnYou(
          th([asked, const Message(id: 'p', author: 'user', body: 'Because.', remoteId: 'n')]),
          me: 'sam',
        ),
        isFalse,
      );
      expect(waitsOnYou(th([asked], state: 'resolved'), me: 'sam'), isFalse);
    });

    test('a thread on the merge request is quiet only when it asks nothing of you', () {
      Thread th(List<Message> m, {String authorType = 'remote', bool waiting = false, Message? answer, String? decision}) => Thread(
        id: 't',
        severity: 'question',
        state: 'published',
        authorType: authorType,
        remoteId: 'd',
        messages: m,
        waiting: waiting,
        answer: answer,
        decision: decision,
      );
      final asked = msg('**@alex**\n\nWhy?', null, 'remote');
      final mine = msg('**@sam**\n\nBecause.', null, 'remote');
      // Your own merge request: the reviewer spoke last, or you did.
      expect(quietOnForge(th([asked]), own: true, author: 'sam'), isFalse);
      expect(quietOnForge(th([asked, mine]), own: true, author: 'sam'), isTrue);
      // Reviewing: the author answered your thread, or did not yet.
      expect(quietOnForge(th([asked], authorType: 'user'), own: false, author: 'alex'), isFalse);
      expect(quietOnForge(th([mine], authorType: 'user'), own: false, author: 'alex'), isTrue);
      // Claude at work, or an answer to decide.
      expect(quietOnForge(th([asked, mine], waiting: true), own: true, author: 'sam'), isFalse);
      expect(quietOnForge(th([asked, mine], answer: msg('Ok', null, 'agent')), own: true, author: 'sam'), isFalse);
    });
  });

  group('migration', () {
    test('old states become open, dismissed or resolved, and the text that went out becomes the answer', () {
      Map<String, Object?> m(String id, String author, String body, {String? suggestion, String? remoteId}) => {
        'id': id,
        'author': author,
        'body': body,
        'suggestion': suggestion,
        'remoteId': remoteId,
        'createdAt': '',
      };
      Map<String, Object?> th(String id, String state, List<Map<String, Object?>> ms, {String? remoteId, String author = 'agent'}) => {
        'id': id,
        'severity': 'nit',
        'state': state,
        'authorType': author,
        'remoteId': remoteId,
        'messages': ms,
      };
      final json = migrateReviewJson({
        'threads': [
          th('a', 'accepted', [m('1', 'agent', 'finding'), m('2', 'user', 'why?'), m('3', 'agent', 'because', suggestion: '+x')]),
          th('b', 'dismissed', [m('4', 'agent', 'meh')]),
          th('c', 'fixed', [m('5', 'agent', 'bug'), m('6', 'user', 'Fix it now.')]),
          th(
            'd',
            'published',
            [m('7', 'remote', 'why?', remoteId: 'n1'), m('8', 'agent', 'draft reply')],
            remoteId: 'd1',
            author: 'remote',
          ),
          th('e', 'published', [m('9', 'agent', 'posted', remoteId: 'n2')], remoteId: 'd2'),
        ],
      });
      final ts = [for (final t in json['threads']! as List) Thread.fromJson((t as Map).cast())];
      expect(ts.map((t) => t.state), ['open', 'dismissed', 'resolved', 'published', 'published']);
      expect((ts[0].answer?.body, ts[0].answer?.suggestion, ts[0].messages.map((m) => m.body).join(',')), ('finding', '+x', 'why?,because'));
      expect(ts.map((t) => t.decision), ['accept', null, null, null, null]);
      expect(ts[1].answer?.body, 'meh');
      expect(ts[2].answer, isNull);
      expect((ts[3].answer?.body, ts[3].messages.length), ('draft reply', 1));
      expect(ts[4].answer, isNull);
      expect(migrateReviewJson({'threads': json['threads']}), {'threads': json['threads']});
    });
  });

  group('GitLab positions', () {
    Anchor anchor(String side, int line) => Anchor(path: 'lib/a.dart', side: side, hunkRef: 'h', line: line, endLine: line, contentHash: 'c');

    test('new_line only for an added line, old_line only for a deleted one, both for context', () {
      expect(positionFor(anchor('new', 12), refs, 'lib/a.dart', 'lib/a.dart', DiffLine(type: lineAdd, content: '', newLine: 12)), {
        'position_type': 'text',
        'base_sha': 'base',
        'start_sha': 'start',
        'head_sha': 'head',
        'old_path': 'lib/a.dart',
        'new_path': 'lib/a.dart',
        'new_line': 12,
      });
      final del = positionFor(anchor('old', 7), refs, 'a', 'a', DiffLine(type: lineDelete, content: '', oldLine: 7));
      expect((del['old_line'], del.containsKey('new_line')), (7, false));
      final ctx = DiffLine(type: lineContext, content: '', oldLine: 7, newLine: 9);
      expect(positionFor(anchor('new', 9), refs, 'a', 'a', ctx), allOf(containsPair('old_line', 7), containsPair('new_line', 9)));
      expect(positionFor(anchor('old', 7), refs, 'a', 'a', ctx), allOf(containsPair('old_line', 7), containsPair('new_line', 9)));
    });

    test('finds the diff line behind the anchor, throws when it is gone', () {
      final s = snap();
      final added = anchorFor(s, path: 'x.txt', line: 2);
      expect(positionForAnchor(added, s, refs), allOf(containsPair('new_line', 2), isNot(contains('old_line'))));
      expect(positionForAnchor(anchorFor(s, path: 'x.txt', line: 3), s, refs), allOf(containsPair('old_line', 3), containsPair('new_line', 3)));
      expect(positionForAnchor(anchorFor(s, path: 'x.txt', side: 'old', line: 2), s, refs), allOf(containsPair('old_line', 2), isNot(contains('new_line'))));
      expect(() => positionForAnchor(added.copyWith(path: 'nope'), s, refs), throwsA(isA<StateError>()));
      expect(() => positionForAnchor(added.copyWith(line: 40, hunkRef: 'zz'), s, refs), throwsA(isA<StateError>()));
    });

    test('a forge position in our terms: new side first, old side, null without a line', () {
      expect(anchorInputFromPosition({'old_path': 'a', 'new_path': 'b', 'old_line': 3, 'new_line': 5}), (path: 'b', side: 'new', line: 5));
      expect(anchorInputFromPosition({'old_path': 'a', 'new_path': 'b', 'old_line': 3, 'new_line': null}), (path: 'a', side: 'old', line: 3));
      expect(anchorInputFromPosition({'old_path': 'a', 'new_path': 'b'}), isNull);
    });
  });

  group('GitHub comments', () {
    test('a range on one side, matched back by body first, each posted comment taken once', () {
      const a = Anchor(path: 'p', hunkRef: 'h', line: 4, endLine: 6, contentHash: 'c');
      final t = Thread(id: 't', anchor: a, severity: 'nit', state: 'open', authorType: 'agent', answer: msg('x'));
      expect(commentFor(t, a), {'path': 'p', 'body': 'x', 'line': 6, 'side': 'RIGHT', 'start_line': 4, 'start_side': 'RIGHT'});
      final sent = [
        {'path': 'p', 'line': 6, 'side': 'RIGHT', 'body': 'same'},
        {'path': 'p', 'line': 6, 'side': 'RIGHT', 'body': 'same'},
        {'path': 'q', 'line': 1, 'side': 'RIGHT', 'body': 'lost'},
      ];
      final posted = <Map<String, Object?>>[
        {'id': 2, 'path': 'p', 'line': 6, 'side': 'RIGHT', 'body': 'same'},
        {'id': 1, 'path': 'p', 'line': 6, 'side': 'RIGHT', 'body': 'same'},
      ];
      expect(matchPosted(posted, sent).map((m) => m?['id']), [2, 1, null]);
    });
  });
}
