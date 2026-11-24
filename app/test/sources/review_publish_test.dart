// Publishing against a fake forge on a real repository. Port of Skim's
// gitlab/tests/publish.test.ts and the publish half of github's.
import 'dart:io';

import 'package:deck/core/review/review.dart';
import 'package:deck/core/review/publish_plan.dart';
import 'package:deck/data/deck_home.dart';
import 'package:deck/data/review_store.dart';
import 'package:deck/sources/review_publish.dart';
import 'package:deck/sources/review_pull.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

typedef Call = ({String method, String path, Map<String, Object?>? body});

class FakeForge implements ForgeClient {
  final calls = <Call>[];
  final _routes = <(String, bool Function(String), Object? Function(Map<String, Object?>?))>[];
  var _id = 100;

  int id() => ++_id;

  /// The last route added for a path wins, so a test can make one fail.
  void on(String method, Object path, Object? Function(Map<String, Object?>? body) answer) =>
      _routes.insert(0, (method, path is String ? (p) => p == path : path as bool Function(String), answer));

  Future<Object?> _call(String method, String path, Map<String, Object?>? body) async {
    calls.add((method: method, path: path, body: body));
    for (final (m, match, answer) in _routes) {
      if (m == method && match(path)) return answer(body);
    }
    throw StateError('no route for $method $path');
  }

  @override
  Future<Object?> get(String path) => _call('GET', path, null);

  @override
  Future<Object?> post(String path, Map<String, Object?> body) => _call('POST', path, body);

  @override
  Future<Object?> put(String path, Map<String, Object?> body) => _call('PUT', path, body);

  List<Map<String, Object?>> posts(String suffix) => [
    for (final c in calls)
      if (c.method == 'POST' && c.path.endsWith(suffix)) c.body!,
  ];
}

const mrPath = 'projects/group%2Fsub%2Fproject/merge_requests/9';

FakeForge gitlabAt(String head) {
  final f = FakeForge();
  f.on(
    'GET',
    mrPath,
    (_) => {
      'sha': head,
      'diff_refs': {'base_sha': 'BASE', 'start_sha': 'START', 'head_sha': head},
    },
  );
  f.on(
    'POST',
    '$mrPath/discussions',
    (_) => {
      'id': 'disc-${f.id()}',
      'notes': [
        {'id': f.id()},
      ],
    },
  );
  f.on('POST', (String p) => RegExp(r'/discussions/[^/]+/notes$').hasMatch(p), (_) => {'id': f.id()});
  f.on('POST', '$mrPath/notes', (_) => {'id': f.id()});
  f.on('POST', '$mrPath/approve', (_) => <String, Object?>{});
  f.on('PUT', (String p) => p.startsWith('$mrPath/discussions/'), (_) => <String, Object?>{});
  return f;
}

late Directory tmp;
late String root;

String git(List<String> args) {
  final r = Process.runSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@example.com', '-c', 'commit.gpgsign=false', ...args], workingDirectory: root);
  if (r.exitCode != 0) throw StateError('git ${args.join(' ')}: ${r.stderr}');
  return '${r.stdout}'.trim();
}

void main() {
  late ReviewService s;
  late String head;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('deck-publish-');
    root = p.join(tmp.path, 'repo');
    Directory(root).createSync();
    git(['init', '-q', '-b', 'main']);
    File(p.join(root, 'a.txt')).writeAsStringSync('one\ntwo\nthree\nfour\n');
    File(p.join(root, 'b.txt')).writeAsStringSync('bee\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
    git(['checkout', '-q', '-b', 'feat']);
    File(p.join(root, 'a.txt')).writeAsStringSync('one\ntwo changed\nthree\nfour\nfive\n');
    File(p.join(root, 'b.txt')).writeAsStringSync('bee changed\n');
    git(['commit', '-qam', 'change']);
    head = git(['rev-parse', 'HEAD']);
    final store = ReviewStore(DeckHome(p.join(tmp.path, 'deck')));
    await store.save(
      const Review(
        id: 'gitlab-9',
        project: 'app',
        baseRef: 'main',
        headRef: 'feat',
        local: true,
        mr: MrSource(
          provider: 'gitlab',
          url: 'https://gitlab.com/group/sub/project/-/merge_requests/9',
          iid: 9,
          projectPath: 'group/sub/project',
          sourceBranch: 'feat',
        ),
      ),
    );
    s = ReviewService(store, store.load('app', 'gitlab-9')!, root);
  });

  tearDown(() => tmp.deleteSync(recursive: true));

  Future<Thread> accepted({
    String path = 'a.txt',
    int line = 2,
    String side = 'new',
    String body = 'x',
    String severity = 'nit',
    String author = 'agent',
  }) async {
    final t = await s.addThread(path: path, line: line, side: side, body: body, severity: severity, author: author);
    return s.setDecision(t.id, 'accept');
  }

  List<String> traffic(FakeForge f) => [for (final c in f.calls) '${c.method} ${c.path.substring(c.path.startsWith(mrPath) ? mrPath.length : 0)}'];

  group('GitLab', () {
    test('refuses when the merge request head moved, before writing anything', () async {
      final f = gitlabAt('0000000other');
      await expectLater(publishReview(s, verdict: 'comment', client: f), throwsA(isA<ReviewError>().having((e) => e.message, 'm', contains('Push feat'))));
      expect(f.calls, hasLength(1));
      expect(s.review.rounds, isEmpty);
    });

    test('right after a push, waits for GitLab to see the new head', () async {
      final f = gitlabAt(head);
      var reads = 0;
      f.on('GET', mrPath, (_) {
        final h = ++reads == 1 ? '0000000old' : head;
        return {
          'sha': h,
          'diff_refs': {'base_sha': 'BASE', 'start_sha': 'START', 'head_sha': h},
        };
      });
      await accepted();
      final r = await publishReview(s, verdict: 'comment', summary: false, client: f, headWait: const Duration(seconds: 10));
      expect(reads, 2);
      expect(r.published, 1);
    });

    test('round 1: answers become positioned discussions, then a summary; the talk stays here', () async {
      final mustFix = await s.addThread(path: 'a.txt', line: 2, body: 'two changed is wrong', severity: 'must-fix', author: 'agent');
      await s.reply(mustFix.id, body: 'why?', author: 'user');
      await s.reply(mustFix.id, body: 'because', author: 'agent');
      await s.setAnswer(mustFix.id, body: 'two changed is wrong', suggestion: '-two changed\n+two fixed', author: 'agent');
      await s.setDecision(mustFix.id, 'accept');
      final onOld = await accepted(side: 'old', body: 'old two', author: 'user');
      final ctx = await accepted(line: 3, body: 'context line', severity: 'suggestion', author: 'user');
      final draft = await s.addThread(path: 'b.txt', line: 1, body: 'rejected', severity: 'nit', author: 'agent');
      await s.setThreadState(draft.id, 'dismissed', 'user');
      await s.setFileNotes([
        {'path': 'a.txt', 'summary': 'Second line changed, fifth added'},
      ]);

      final f = gitlabAt(head);
      final r = await publishReview(s, verdict: 'request_changes', client: f);
      expect((r.round.number, r.round.verdict, r.round.headSha, r.published, r.skipped.length, r.replies), (1, 'request_changes', head, 3, 0, 0));
      expect(traffic(f), ['GET ', 'POST /discussions', 'POST /discussions', 'POST /discussions', 'POST /notes']);
      final [d1, d2, d3] = f.posts('/discussions');
      expect(d1['body'], 'two changed is wrong\n\n```suggestion:-0+0\ntwo fixed\n```');
      expect(d1['position'], {
        'position_type': 'text',
        'base_sha': 'BASE',
        'start_sha': 'START',
        'head_sha': head,
        'old_path': 'a.txt',
        'new_path': 'a.txt',
        'new_line': 2,
      });
      expect(d2['position'], allOf(containsPair('old_line', 2), isNot(contains('new_line'))));
      expect(d3['position'], allOf(containsPair('old_line', 3), containsPair('new_line', 3)));
      final summary = f.posts('/notes').single['body']! as String;
      expect(summary, contains('**Changes requested**'));
      expect(summary, contains('`a.txt`: Second line changed, fifth added'));
      expect(summary, contains('3 inline threads: 1 must-fix, 1 suggestion, 1 nit.'));

      final t = s.thread(mustFix.id);
      expect((t.state, t.roundId), ('published', r.round.id));
      expect(t.remoteId, startsWith('disc-'));
      expect(t.messages.map((m) => m.remoteId != null), [false, false, true]);
      expect(t.answer, isNull);
      expect(s.thread(draft.id).state, 'dismissed');
      expect(s.thread(onOld.id).state, 'published');
      expect(s.thread(ctx.id).state, 'published');
      expect(s.review.mr!.diffRefs, DiffRefs(baseSha: 'BASE', startSha: 'START', headSha: head));
      // Written to disk.
      expect(s.store.load('app', 'gitlab-9')!.rounds.single.publishedAt, isNotNull);
    });

    test('round 2: outdated threads skipped, replies on their discussion, approve hits its endpoint', () async {
      final first = await accepted(body: 'finding');
      await publishReview(s, verdict: 'comment', client: gitlabAt(head));
      final doomed = await accepted(line: 5, body: 'five is odd');
      final survivor = await accepted(path: 'b.txt', line: 1, body: 'bee');
      await s.reply(first.id, body: 'Still open?', author: 'user');
      await s.setAnswer(first.id, body: 'Still open.', author: 'agent');
      await s.setDecision(first.id, 'accept');

      File(p.join(root, 'a.txt')).writeAsStringSync('one\ntwo changed\nthree\nfour\n');
      git(['commit', '-qam', 'drop five']);
      final head2 = git(['rev-parse', 'HEAD']);
      final f = gitlabAt(head2);
      final r = await publishReview(s, verdict: 'approve', summary: false, client: f);
      final remote = s.thread(first.id).remoteId;
      expect(r.round.number, 2);
      expect(r.skipped.single.threadId, doomed.id);
      expect(r.skipped.single.reason, contains('outdated: a.txt:5'));
      expect(r.replies, 1);
      expect(traffic(f), ['GET ', 'POST /discussions', 'POST /discussions/$remote/notes', 'POST /approve']);
      expect(f.posts('/discussions/$remote/notes').single, {'body': 'Still open.'});
      expect(f.posts('/approve').single, {'sha': head2});
      expect(s.thread(first.id).messages.map((m) => m.remoteId != null), [true, false, true]);
      expect((s.thread(doomed.id).state, s.thread(doomed.id).remoteId, s.thread(doomed.id).answer?.body), ('open', null, 'five is odd'));
      expect(s.thread(survivor.id).state, 'published');
      expect(s.review.rounds.map((r) => (r.number, r.verdict)), [(1, 'comment'), (2, 'approve')]);
    });

    test('a reply approving the fix resolves the discussion; partially fixed and own reviews do not', () async {
      final fixed = await accepted(body: 'finding');
      final partial = await accepted(path: 'b.txt', line: 1, body: 'bee');
      await publishReview(s, verdict: 'comment', client: gitlabAt(head));
      await s.setAnswer(fixed.id, body: 'Fixed in abc1234. a.txt:2 checks it now.', author: 'agent');
      await s.setDecision(fixed.id, 'accept');
      await s.setAnswer(partial.id, body: 'Partially fixed. The test is missing.', author: 'agent');
      await s.setDecision(partial.id, 'accept');
      final f = gitlabAt(head);
      await publishReview(s, verdict: 'comment', summary: false, client: f);
      final remote = s.thread(fixed.id).remoteId;
      expect([for (final c in f.calls.where((c) => c.method == 'PUT')) '${c.path} ${c.body}'], ['$mrPath/discussions/$remote {resolved: true}']);
      expect((s.thread(fixed.id).state, s.thread(partial.id).state), ('resolved', 'published'));

      final t = s.review.threads.first;
      expect(
        resolvesThread(
          t.copyWith(
            state: 'published',
            answer: const Message(id: 'm', author: 'user', body: 'Fixed.'),
          ),
          own: true,
        ),
        isFalse,
      );
      expect(
        resolvesThread(
          t.copyWith(
            state: 'published',
            answer: const Message(id: 'm', author: 'user', body: 'Agreed, not an issue.'),
          ),
          own: false,
        ),
        isTrue,
      );
    });

    test('a retry after a failure posts neither a thread nor the summary twice', () async {
      final t = await accepted(body: 'posted before the crash');
      final failing = gitlabAt(head)..on('POST', '$mrPath/approve', (_) => throw StateError('500 from GitLab'));
      await expectLater(publishReview(s, verdict: 'approve', client: failing), throwsA(isA<StateError>()));
      final remote = s.thread(t.id).remoteId!;
      final open = s.review.rounds.single;
      expect((s.thread(t.id).state, open.publishedAt), ('open', null));
      expect(open.remoteNoteId, isNotNull);

      final f = gitlabAt(head);
      final r = await publishReview(s, verdict: 'approve', client: f);
      expect(traffic(f), ['GET ', 'POST /approve']);
      expect((r.round.id, r.round.remoteNoteId), (open.id, open.remoteNoteId));
      expect((s.thread(t.id).state, s.thread(t.id).remoteId), ('published', remote));
    });

    test('a thread about the whole change posts with no position', () async {
      await s.setDecision((await s.addThread(body: 'No test for five', severity: 'question', author: 'agent')).id, 'accept');
      final f = gitlabAt(head);
      await publishReview(s, verdict: 'comment', summary: false, client: f);
      expect(f.posts('/discussions').single, {'body': 'No test for five'});
    });

    test('the preview says what would go out and touches nothing', () async {
      await accepted(body: 'finding');
      await accepted(line: 5, body: 'on five');
      final preview = await previewReview(s, verdict: 'comment');
      expect((preview.roundNumber, preview.posting.length, preview.skipped.length, preview.replies), (1, 2, 0, 0));
      expect(preview.summary, contains('2 inline threads: 2 nit.'));
      expect(s.review.rounds, isEmpty);
      expect((await previewReview(s, verdict: 'comment', summary: false)).summary, isNull);
    });
  });

  group('GitHub', () {
    test('one review carries the inline comments, the summary and the verdict; ids read back', () async {
      s.review = s.review.copyWith(
        mr: s.review.mr!.copyWith(provider: 'github', projectPath: 'o/r'),
      );
      const pr = 'repos/o/r/pulls/9';
      final line = await accepted(body: 'inline');
      final general = await s.addThread(body: 'whole change', severity: 'question', author: 'user');
      final f = FakeForge();
      f.on(
        'GET',
        pr,
        (_) => {
          'head': {'sha': head},
        },
      );
      f.on('POST', 'repos/o/r/issues/9/comments', (_) => {'id': 7});
      f.on('POST', '$pr/reviews', (_) => {'id': 55});
      f.on(
        'GET',
        (String p) => p.startsWith('$pr/comments'),
        (_) => [
          {'id': 88, 'pull_request_review_id': 55, 'path': 'a.txt', 'line': 2, 'side': 'RIGHT', 'body': 'inline'},
        ],
      );
      final r = await publishReview(s, verdict: 'request_changes', client: f, readBackDelay: Duration.zero);
      final review = f.posts('/reviews').single;
      expect((review['commit_id'], review['event']), (head, 'REQUEST_CHANGES'));
      expect(review['comments'], [
        {'path': 'a.txt', 'body': 'inline', 'line': 2, 'side': 'RIGHT'},
      ]);
      expect((r.published, r.skipped.length), (2, 0));
      expect(s.thread(line.id).remoteId, '88');
      expect(s.thread(general.id).remoteId, 'issue:7');
      expect(s.review.rounds.single.remoteNoteId, '55');
    });
  });

  group('GitHub resolve', () {
    test('a fixed reply resolves its review thread through GraphQL', () async {
      s.review = s.review.copyWith(
        mr: s.review.mr!.copyWith(provider: 'github', projectPath: 'o/r'),
      );
      const pr = 'repos/o/r/pulls/9';
      final t = await accepted(body: 'inline');
      final f = FakeForge();
      f.on(
        'GET',
        pr,
        (_) => {
          'head': {'sha': head},
        },
      );
      f.on('POST', '$pr/reviews', (_) => {'id': 55});
      f.on(
        'GET',
        (String p) => p.startsWith('$pr/comments'),
        (_) => [
          {'id': 88, 'pull_request_review_id': 55, 'path': 'a.txt', 'line': 2, 'side': 'RIGHT', 'body': 'inline'},
        ],
      );
      await publishReview(s, verdict: 'comment', client: f, readBackDelay: Duration.zero);
      await s.setAnswer(t.id, body: 'Fixed in abc1234.', author: 'agent');
      await s.setDecision(t.id, 'accept');
      f.on('POST', '$pr/comments/88/replies', (_) => {'id': 89});
      f.on(
        'POST',
        'graphql',
        (b) => '${b!['query']}'.startsWith('mutation')
            ? <String, Object?>{}
            : {
                'data': {
                  'repository': {
                    'pullRequest': {
                      'reviewThreads': {
                        'nodes': [
                          {
                            'id': 'PRRT_1',
                            'isResolved': false,
                            'comments': {
                              'nodes': [
                                {'databaseId': 88},
                              ],
                            },
                          },
                        ],
                      },
                    },
                  },
                },
              },
      );
      await publishReview(s, verdict: 'comment', client: f, readBackDelay: Duration.zero);
      expect(f.posts('graphql').last['variables'], {'id': 'PRRT_1'});
      expect(s.thread(t.id).state, 'resolved');
    });
  });

  group('next round', () {
    test('GitLab pull: replies land on our thread, a new discussion becomes a remote thread, remarks are skipped', () async {
      final mine = await accepted(body: 'finding');
      await publishReview(s, verdict: 'comment', summary: false, client: gitlabAt(head));
      final remote = s.thread(mine.id).remoteId!;
      final first = s.thread(mine.id).messages.first.remoteId!;
      final f = FakeForge();
      f.on(
        'GET',
        '$mrPath/discussions?per_page=100',
        (_) => [
          {
            'id': remote,
            'notes': [
              {'id': int.parse(first), 'body': 'finding'},
              {
                'id': 900,
                'body': 'Done in the last push.',
                'author': {'username': 'robin'},
                'resolvable': true,
                'resolved': true,
              },
              {'id': 901, 'body': 'changed the description', 'system': true},
            ],
          },
          {
            'id': 'other',
            'notes': [
              {
                'id': 910,
                'body': 'Why five?',
                'author': {'username': 'sam'},
                'position': {'new_path': 'a.txt', 'new_line': 5},
              },
            ],
          },
          {
            'id': 'remark',
            'individual_note': true,
            'notes': [
              {'id': 920, 'body': 'LGTM'},
            ],
          },
        ],
      );
      final r = await pullDiscussions(s, client: f);
      expect((r.threadsCreated, r.threadsUpdated, r.messagesAdded, r.skipped), (1, 1, 2, 1));
      final t = s.thread(mine.id);
      expect(t.state, 'resolved');
      expect(t.messages.last.body, '**@robin**\n\nDone in the last push.');
      final theirs = s.review.threads.firstWhere((t) => t.remoteId == 'other');
      expect((theirs.authorType, theirs.state, theirs.anchor!.line), ('remote', 'published', 5));
      // Pulling again adds nothing.
      expect((await pullDiscussions(s, client: f)).messagesAdded, 0);
    });

    test('GitHub pull threads comments by their root', () async {
      s.review = s.review.copyWith(
        mr: s.review.mr!.copyWith(provider: 'github', projectPath: 'o/r'),
      );
      final f = FakeForge();
      f.on(
        'GET',
        'repos/o/r/pulls/9/comments?per_page=100',
        (_) => [
          {
            'id': 1,
            'body': 'root',
            'path': 'a.txt',
            'line': 2,
            'side': 'RIGHT',
            'user': {'login': 'sam'},
            'created_at': '2026-10-01T10:00:00Z',
          },
          {'id': 2, 'body': 'reply', 'path': 'a.txt', 'in_reply_to_id': 1, 'created_at': '2026-10-01T11:00:00Z'},
          {'id': 3, 'body': 'gone', 'path': 'a.txt', 'line': null},
        ],
      );
      final r = await pullDiscussions(s, client: f);
      expect((r.threadsCreated, r.messagesAdded, r.skipped), (1, 2, 1));
      expect(s.review.threads.single.messages.map((m) => m.body), ['**@sam**\n\nroot', 'reply']);
    });

    test('the round delta is the code pushed since the last publish, threads re-anchored', () async {
      expect((await s.roundDelta()).delta, isNull);
      final onFive = await accepted(line: 5, body: 'five');
      final onTwo = await accepted(body: 'two');
      await publishReview(s, verdict: 'comment', summary: false, client: gitlabAt(head));
      File(p.join(root, 'a.txt')).writeAsStringSync('one\ntwo changed\nthree\nfour\n');
      git(['commit', '-qam', 'drop five']);
      final d = await s.roundDelta();
      expect(d.since!.number, 1);
      expect(d.delta!.files.single.path, 'a.txt');
      expect({for (final (t, status, _) in d.threads) t.id: status}, {onFive.id: 'outdated', onTwo.id: 'moved'});
    });
  });
}
