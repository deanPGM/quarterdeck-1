// The review store and the rules of every write, on a real git repository.
import 'dart:io';

import 'package:deck/core/review/publish_plan.dart';
import 'package:deck/core/review/review.dart';
import 'package:deck/data/deck_home.dart';
import 'package:deck/data/review_git.dart';
import 'package:deck/data/review_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

late Directory tmp;
late String root;

void git(List<String> args) {
  final r = Process.runSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@example.com', '-c', 'commit.gpgsign=false', ...args], workingDirectory: root);
  if (r.exitCode != 0) throw StateError('git ${args.join(' ')}: ${r.stderr}');
}

void write(String path, String text) => File(p.join(root, path))
  ..createSync(recursive: true)
  ..writeAsStringSync(text);

Matcher refused(String part) => throwsA(isA<ReviewError>().having((e) => e.message, 'message', contains(part)));

void main() {
  late ReviewService s;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('deck-review-');
    root = p.join(tmp.path, 'repo');
    Directory(root).createSync();
    git(['init', '-q', '-b', 'main']);
    write('lib/cache.dart', 'class Cache {}\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
    git(['checkout', '-q', '-b', 'feat/APP-12-cache']);
    write('lib/cache.dart', ['class Cache {', for (var i = 0; i < 14; i++) '  int f$i = $i;', '}', ''].join('\n'));
    write('pubspec.lock', 'packages: {}\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'Cache fields, APP-12']);
    final store = ReviewStore(DeckHome(p.join(tmp.path, 'deck')));
    const r = Review(id: 'gitlab-7', project: 'app', baseRef: 'main', headRef: 'feat/APP-12-cache');
    await store.save(r);
    s = ReviewService(store, store.load('app', 'gitlab-7')!, root);
  });

  tearDown(() => tmp.deleteSync(recursive: true));

  test('derives the diff from the merge base, noise tagged', () async {
    final snap = await s.snapshot();
    expect(snap.files.map((f) => f.path), containsAll(['lib/cache.dart', 'pubspec.lock']));
    expect(snap.files.firstWhere((f) => f.path == 'pubspec.lock').tags, contains('lockfile'));
    expect(snap.hiddenCount, 1);
  });

  test('finds the ticket in the branch and the commits', () async {
    expect((await s.ticketRefs()).map((t) => t.ref), ['APP-12']);
  });

  test('keeps notes by path and by hunk, and refuses what the diff does not have', () async {
    await s.setFileNotes([
      {
        'path': 'lib/cache.dart',
        'summary': 'Fourteen fields on the cache',
        'extra_tags': ['config'],
      },
    ]);
    expect(s.review.fileNotes.single.extraTags, ['config']);
    expect(
      s.setFileNotes([
        {'path': 'nope.dart', 'summary': 'x'},
      ]),
      refused('Path not in diff: nope.dart'),
    );
    expect(
      s.setFileNotes([
        {
          'path': 'lib/cache.dart',
          'summary': 'x',
          'extra_tags': ['test'],
        },
      ]),
      refused('classifier tag'),
    );
    final ref = (await s.snapshot()).files.firstWhere((f) => f.path == 'lib/cache.dart').hunks.first.ref;
    await s.setHunkNotes([
      {'hunk_ref': ref, 'summary': 'The fields'},
    ]);
    expect(s.review.hunkNotes.single.path, 'lib/cache.dart');
    expect(
      s.setHunkNotes([
        {'hunk_ref': 'abc', 'summary': 'x'},
      ]),
      refused('No hunk abc'),
    );
    // Written to disk, read back the same.
    expect(s.store.load('app', 'gitlab-7')!.fileNotes.single.summary, 'Fourteen fields on the cache');
  });

  test('replaces the chapters, the triage and the features whole', () async {
    await s.setGroups([
      {
        'title': 'The cache',
        'items': [
          {'path': 'lib/cache.dart'},
        ],
      },
    ]);
    expect(s.review.groups.single.items.single.path, 'lib/cache.dart');
    await s.setChecklist([
      {
        'text': 'tests for the cache',
        'state': 'concern',
        'evidence': 'none',
        'paths': ['lib/cache.dart'],
      },
    ]);
    expect(s.review.checklist.single.headSha, (await s.snapshot()).headSha);
    expect(
      s.setChecklist([
        {'text': 'x', 'state': 'maybe'},
      ]),
      refused('item state must be one of ok, concern, unclear'),
    );
    await s.setFeatures([
      {
        'title': 'Cache fields',
        'graph': {
          'nodes': [
            {'name': 'Cache', 'status': 'changed', 'path': 'lib/cache.dart', 'line': 1},
          ],
        },
        'sequence': {
          'mermaid': 'sequenceDiagram\n  A->>B: go',
          'steps': [
            {'title': 'go', 'mark': 'touched'},
          ],
        },
      },
    ]);
    expect(s.review.features.single.graph!.nodes.single.status, 'changed');
    expect(
      s.setFeatures([
        {
          'title': 'x',
          'graph': {
            'nodes': [
              {'name': 'A', 'status': 'context', 'path': 'gone.dart'},
            ],
          },
        },
      ]),
      refused('Path not in diff: gone.dart'),
    );
    expect(
      s.setFeatures([
        {
          'title': 'x',
          'sequence': {'mermaid': 'sequenceDiagram\n  participant Par as P\n  Par->>B: go'},
        },
      ]),
      refused('mermaid keyword'),
    );
  });

  test('stores the ticket text and checks it, only for the change\'s tickets', () async {
    await s.setTicket('APP-12', {'body': 'Add fields', 'title': 'Cache fields'});
    final check = await s.setTicketCheck('APP-12', {
      'verdict': 'partial',
      'summary': 'Fields are in, tests are not.',
      'items': [
        {
          'text': 'Fields',
          'state': 'done',
          'paths': ['lib/cache.dart'],
        },
        {'text': 'Tests', 'state': 'missing'},
      ],
    });
    expect(check.items.map((i) => i.state), ['done', 'missing']);
    expect(s.setTicket('APP-99', {'body': 'x'}), refused('APP-99 is not a ticket of this review'));
    expect(s.setTicketCheck('APP-12', {'verdict': 'great', 'summary': 'x'}), refused('verdict must be one of'));
  });

  test('marks a file viewed at the head', () async {
    await s.setViewed('lib/cache.dart', true);
    expect(s.review.viewed['lib/cache.dart'], (await s.snapshot()).headSha);
    await s.setViewed('lib/cache.dart', false);
    expect(s.review.viewed, isEmpty);
  });

  group('threads', () {
    Future<Thread> finding([int line = 2]) => s.addThread(path: 'lib/cache.dart', line: line, body: 'finding', severity: 'suggestion', author: 'agent');
    Future<Thread> mine() => s.addThread(path: 'lib/cache.dart', line: 5, body: 'mine', severity: 'nit', author: 'user');

    test('a finding is its answer, anchored to a diff line, kept on disk', () async {
      final t = await s.addThread(path: 'lib/cache.dart', line: 2, body: 'why?', severity: 'question', author: 'agent', suggestion: 'int f0 = 1;');
      expect((t.state, t.authorType, t.waiting, t.decision), ('open', 'agent', false, null));
      expect((t.anchor!.path, t.anchor!.side, t.anchor!.line, t.anchor!.endLine), ('lib/cache.dart', 'new', 2, 2));
      expect(t.messages, isEmpty);
      expect((t.answer!.body, t.answer!.suggestion), ('why?', 'int f0 = 1;'));
      expect(s.listThreads().map((x) => x.id), [t.id]);
      expect(s.listThreads(path: 'pubspec.lock'), isEmpty);
      expect(s.listThreads(state: 'open'), hasLength(1));
      expect(s.store.load('app', 'gitlab-7')!.threads.single, t);
    });

    test('refuses a thread on a line that is not in the diff', () async {
      expect(s.addThread(path: 'lib/cache.dart', line: 50, body: 'x', severity: 'nit', author: 'user'), refused('not in the diff'));
      expect(s.addThread(path: 'zzz', line: 1, body: 'x', severity: 'nit', author: 'user'), refused('Path not in diff'));
      expect(s.addThread(path: 'lib/cache.dart', line: 2, body: 'x', severity: 'big', author: 'user'), refused('severity must be one of'));
    });

    test('about the whole change: no anchor, and half a pair refused', () async {
      final t = await s.addThread(body: 'Wrong target branch', severity: 'question', author: 'user');
      expect(t.anchor, isNull);
      expect(s.addThread(path: 'lib/cache.dart', body: 'no line', severity: 'nit', author: 'user'), refused('both a path and a line'));
    });

    test('a question for Claude is talk: it waits, nothing goes out', () async {
      final t = await s.addThread(path: 'lib/cache.dart', line: 2, body: 'what is f0?', severity: 'question', author: 'user', askAgent: true);
      expect((t.waiting, t.answer, t.messages.single.body), (true, null, 'what is f0?'));
    });

    test('talk: the user waits on Claude, Claude hands it back, the answer stays', () async {
      final t = await finding();
      expect((await s.reply(t.id, body: 'can you explain?', author: 'user')).waiting, isTrue);
      final answered = await s.reply(t.id, body: 'sure', suggestion: 'int f0 = 1;', author: 'agent');
      expect((answered.waiting, answered.state, answered.answer!.body), (false, 'open', 'finding'));
      expect(answered.messages.map((m) => (m.author, m.suggestion)), [('user', null), ('agent', 'int f0 = 1;')]);
    });

    test('the answer is replaced whole, cleared when empty, and Claude writing it hands the thread back', () async {
      final t = await finding();
      await s.reply(t.id, body: 'is it?', author: 'user');
      final revised = await s.setAnswer(t.id, body: 'smaller finding', suggestion: 'new', author: 'agent');
      expect((revised.answer!.body, revised.answer!.suggestion, revised.waiting), ('smaller finding', 'new', false));
      expect((await s.setDecision(t.id, 'accept')).decision, 'accept');
      expect((await s.setAnswer(t.id, body: 'Claude again', author: 'agent')).decision, isNull);
      final mineNow = await s.setAnswer(t.id, body: 'my words', author: 'user');
      expect((mineNow.answer!.author, mineNow.decision), ('user', 'accept'));
      expect(s.setDecision(t.id, 'maybe'), refused('decision must be one of'));
      expect((await s.setAnswer(t.id, body: '  ', author: 'user')).answer, isNull);
    });

    test('a declined point waits on Claude, whose reply saying why stays accepted', () async {
      final t = await finding();
      final asked = await s.decline(t.id);
      expect((asked.waiting, asked.decision, asked.answer, asked.messages.last.body), (true, 'reject', null, declineNow));
      final reply = await s.setAnswer(t.id, body: 'We keep it: the cache is cleared on logout.', author: 'agent');
      expect((reply.waiting, reply.decision), (false, 'accept'));
      // Talk after the decline asks for your call again.
      await s.reply(t.id, body: 'shorter', author: 'user');
      expect((await s.setAnswer(t.id, body: 'Cleared on logout.', author: 'agent')).decision, isNull);
    });

    test('follows the allowed transitions and rejects the others', () async {
      final t = await finding();
      expect(s.setThreadState(t.id, 'published', 'user'), refused('by a publish'));
      expect(s.setThreadState(t.id, 'resolved', 'user'), refused('Cannot move'));
      expect((await s.setThreadState(t.id, 'dismissed', 'user')).state, 'dismissed');
      expect((await s.setThreadState(t.id, 'open', 'user')).state, 'open');
      expect(s.setThreadState('nope', 'open', 'user'), refused('Unknown thread'));
    });

    test('lets the agent only withdraw its own findings', () async {
      final own = await finding();
      expect((await s.setThreadState(own.id, 'dismissed', 'agent')).state, 'dismissed');
      expect(s.setThreadState(own.id, 'open', 'agent'), refused('Agent cannot move'));
      final users = await mine();
      expect(s.setThreadState(users.id, 'dismissed', 'agent'), refused('Agent cannot move'));
    });

    test('a posted answer joins the posted messages and the round publishes the thread', () async {
      final t = await finding();
      await s.reply(t.id, body: 'sure?', author: 'user');
      final round = await s.openRound();
      final posted = await s.setThreadRemoteId(t.id, 'd1', 'n1');
      expect((posted.answer, posted.messages.last.body, posted.messages.last.remoteId, posted.messages.last.author), (null, 'finding', 'n1', 'user'));
      await s.publishRound(round.id, verdict: 'comment');
      expect(s.thread(t.id).state, 'published');
      await s.setAnswer(t.id, body: 'Thanks.', author: 'agent');
      await s.setDecision(t.id, 'accept');
      final replied = await s.setAnswerPosted(t.id, 'n2');
      expect(replied.answer, isNull);
      expect(replied.messages.map(isPosted), [false, true, true]);
      expect((await s.setThreadState(t.id, 'resolved', 'user')).state, 'resolved');
      expect(s.setAnswer(t.id, body: 'late', author: 'user'), refused('resolved'));
    });

    test('mark fixed checks the commit is on the head, writes the answer, and tracks the push', () async {
      final t = await finding();
      await s.reply(t.id, body: 'Fix it now.', author: 'user');
      expect(s.markFixed(t.id, body: 'done', commit: 'nope'), refused('Unknown commit'));
      git(['checkout', '-q', '-b', 'elsewhere', 'main']);
      git(['commit', '-q', '--allow-empty', '-m', 'off branch']);
      expect(s.markFixed(t.id, body: 'done', commit: 'elsewhere'), refused('is not on feat/APP-12-cache'));
      git(['checkout', '-q', 'feat/APP-12-cache']);
      final head = await revParse(root, 'HEAD');
      git(['commit', '-q', '--allow-empty', '-m', 'fix one']);
      final sha = await revParse(root, 'HEAD');
      final fixed = await s.markFixed(t.id, body: 'Fixed in ${sha.substring(0, 7)}', commit: sha);
      expect((fixed.state, fixed.waiting, fixed.fix), ('open', false, sha));
      // Set aside: the branch is back where it was until Accept.
      expect(await revParse(root, 'HEAD'), head);
      expect((await s.fixStatuses())[t.id]?.state, 'pending');
      expect(await s.unpushedFixes(), isEmpty, reason: 'not accepted yet: it would not go out');
      await s.setDecision(t.id, 'accept');
      // The branch did not move since: a fast forward, same sha.
      expect(await revParse(root, 'HEAD'), sha);
      // No merge request source branch: nothing is on the forge.
      expect((await s.fixStatuses())[t.id]?.state, 'local');
      expect(await s.unpushedFixes(), {t.id: sha});
      expect(await s.unpushedFixes(pushing: true), isEmpty);
      // Taken back before a push: off the branch again.
      await s.setDecision(t.id, null);
      expect((await revParse(root, 'HEAD'), (await s.fixStatuses())[t.id]?.state), (head, 'pending'));
      final loose = await s.markFixed((await finding(3)).id, body: 'Changed, not committed');
      expect((loose.fix, (await s.fixStatuses())[loose.id]?.state), ('uncommitted', 'uncommitted'));
    });

    test('two fixes set aside: the second accepted is cherry picked, its answer names the new sha', () async {
      final a = await finding(), b = await finding(3);
      Future<String> fix(Thread t, String file) async {
        write(file, '$file\n');
        git(['add', file]);
        git(['commit', '-q', '-m', 'fix $file']);
        final sha = await revParse(root, 'HEAD');
        await s.markFixed(t.id, body: 'Fixed in ${sha.substring(0, 7)}.', commit: sha);
        return sha;
      }

      final c = await finding(5);
      final first = await fix(a, 'a.txt'), second = await fix(b, 'b.txt'), third = await fix(c, 'c.txt');
      await s.setDecision(a.id, 'accept');
      expect(await revParse(root, 'HEAD'), first);
      await s.setDecision(b.id, 'accept');
      final picked = s.thread(b.id);
      expect(picked.fix, isNot(second));
      expect(await revParse(root, 'HEAD'), picked.fix);
      expect(picked.answer!.body, 'Fixed in ${picked.fix!.substring(0, 7)}.');
      // Taken back under b's pick: b is replayed on the base, its answer follows.
      await s.setDecision(a.id, 'reject');
      final moved = s.thread(b.id);
      expect(moved.fix, isNot(picked.fix));
      expect(await revParse(root, 'HEAD'), moved.fix);
      expect(await revParse(root, 'HEAD^'), isNot(first));
      expect(moved.answer!.body, 'Fixed in ${moved.fix!.substring(0, 7)}.');
      expect(File(p.join(root, 'a.txt')).existsSync(), isFalse);
      // Rejected: never on the branch.
      await s.setDecision(c.id, 'reject');
      expect((await s.fixStatuses())[c.id], (state: 'dropped', sha: third));
      expect(File(p.join(root, 'c.txt')).existsSync(), isFalse);
    });

    Future<String> commit(String file, String text) async {
      write(file, text);
      git(['add', file]);
      git(['commit', '-q', '-m', 'fix $file']);
      return revParse(root, 'HEAD');
    }

    test('an Accept between a commit and its mark_fixed: the commit still leaves, the pick stays', () async {
      final a = await finding(), b = await finding(3);
      final base = await revParse(root, 'HEAD');
      final first = await commit('a.txt', 'a\n');
      await s.markFixed(a.id, body: 'Fixed in ${first.substring(0, 7)}.', commit: first);
      // Claude commits b; before its mark_fixed, the user accepts a.
      final second = await commit('b.txt', 'b\n');
      await s.setDecision(a.id, 'accept');
      expect(await revParse(root, 'HEAD^'), second, reason: 'a was cherry picked on top of b');
      final fixed = await s.markFixed(b.id, body: 'Fixed in ${second.substring(0, 7)}.', commit: second);
      expect(fixed.fix, second);
      // b is aside; a, replayed on the base, is all the branch has.
      final aNow = s.thread(a.id).fix!;
      expect(await revParse(root, 'HEAD'), aNow);
      expect(await revParse(root, 'HEAD^'), base);
      expect(s.thread(a.id).answer!.body, 'Fixed in ${aNow.substring(0, 7)}.');
      expect((await s.fixStatuses())[a.id]?.state, 'local');
      expect((await s.fixStatuses())[b.id]?.state, 'pending');
      expect(File(p.join(root, 'b.txt')).existsSync(), isFalse);
      await s.setDecision(b.id, 'accept');
      expect(File(p.join(root, 'b.txt')).readAsStringSync(), 'b\n');
    });

    test('mark_fixed with a commit the ones above need: recorded on the branch, never moved', () async {
      final t = await finding();
      final fix = await commit('a.txt', 'one\n');
      final later = await commit('a.txt', 'one\ntwo\n');
      await expectLater(s.markFixed(t.id, body: 'x', commit: 'main'), refused('part of main'));
      final fixed = await s.markFixed(t.id, body: 'Fixed in ${fix.substring(0, 7)}.', commit: fix);
      expect(fixed.fix, fix);
      expect(await revParse(root, 'HEAD'), later, reason: 'nothing moved');
      expect((await s.fixStatuses())[t.id], (state: 'local', sha: fix));
      await expectLater(s.markFixed((await finding(3)).id, body: 'x', commit: fix), refused('fix of thread ${t.id}'));
      await expectLater(s.setDecision(t.id, 'reject'), throwsA(isA<FixBuriedError>()));
      // The revert would conflict just the same: refused, the branch kept.
      await expectLater(s.setDecision(t.id, 'reject', revert: true), refused('cannot be reverted'));
      expect(await revParse(root, 'HEAD'), later);
    });

    test('a pushed fix attached after the fact: Reject offers a revert, Accept picks it again', () async {
      await s.store.save(
        s.review.copyWith(
          mr: const MrSource(provider: 'gitlab', url: 'u', iid: 7, projectPath: 'g/app', sourceBranch: 'feat/APP-12-cache'),
        ),
      );
      s = ReviewService(s.store, s.store.load('app', 'gitlab-7')!, root);
      final t = await finding();
      final fix = await commit('a.txt', 'a\n');
      final later = await commit('b.txt', 'b\n');
      git(['update-ref', 'refs/remotes/origin/feat/APP-12-cache', later]);
      final fixed = await s.markFixed(t.id, body: 'Fixed in ${fix.substring(0, 7)}.', commit: fix);
      expect(fixed.fix, fix);
      expect(await revParse(root, 'HEAD'), later, reason: 'pushed: never taken off');
      expect((await s.fixStatuses())[t.id]?.state, 'pushed');
      await expectLater(s.setDecision(t.id, 'reject'), throwsA(isA<FixBuriedError>().having((e) => e.message, 'm', contains('pushed already'))));
      final rejected = await s.setDecision(t.id, 'reject', revert: true);
      expect(rejected.fixRevert, await revParse(root, 'HEAD'));
      expect(await revParse(root, 'HEAD^'), later);
      expect(File(p.join(root, 'a.txt')).existsSync(), isFalse);
      expect((await s.fixStatuses())[t.id]?.state, 'dropped');
      // Accepted again: picked back on top of the revert.
      await s.setDecision(t.id, 'accept');
      expect(s.thread(t.id).fixRevert, isNull);
      expect(File(p.join(root, 'a.txt')).readAsStringSync(), 'a\n');
      expect((await s.fixStatuses())[t.id]?.state, 'local');
    });

    test('a local review with no merge request pushes its fixes to the same branch on origin', () async {
      final origin = p.join(tmp.path, 'origin.git');
      Process.runSync('git', ['init', '-q', '--bare', origin]);
      git(['remote', 'add', 'origin', origin]);
      git(['push', '-q', 'origin', 'feat/APP-12-cache']);
      await s.store.save(s.review.copyWith(local: true));
      s = ReviewService(s.store, s.store.load('app', 'gitlab-7')!, root);
      final t = await finding();
      final fix = await commit('a.txt', 'a\n');
      await s.markFixed(t.id, body: 'Fixed in ${fix.substring(0, 7)}.', commit: fix);
      await s.setDecision(t.id, 'accept');
      final head = await revParse(root, 'HEAD');
      expect((await s.fixStatuses())[t.id]?.state, 'local');
      await s.pushFixes(Platform.environment);
      expect((await s.fixStatuses())[t.id]?.state, 'pushed');
      expect(await revParse(origin, 'feat/APP-12-cache'), head);
    });

    test('in a worktree: the fix leaves and comes back where the branch is checked out', () async {
      final a = await finding(), b = await finding(3);
      git(['checkout', '-q', 'main']);
      final tree = p.join(root, '.claude', 'worktrees', 'feat');
      git(['worktree', 'add', '-q', tree, 'feat/APP-12-cache']);
      final head = await revParse(tree, 'HEAD');
      Future<String> commitIn(String file) async {
        File(p.join(tree, file)).writeAsStringSync('$file\n');
        git(['-C', tree, 'add', file]);
        git(['-C', tree, 'commit', '-q', '-m', 'fix $file']);
        return revParse(tree, 'HEAD');
      }

      final first = await commitIn('a.txt');
      await s.markFixed(a.id, body: 'Fixed.', commit: first);
      expect(await revParse(tree, 'HEAD'), head);
      expect(File(p.join(tree, 'a.txt')).existsSync(), isFalse);
      final second = await commitIn('b.txt');
      await s.setDecision(a.id, 'accept');
      await s.markFixed(b.id, body: 'Fixed.', commit: second);
      expect(await revParse(tree, 'HEAD'), s.thread(a.id).fix);
      expect((File(p.join(tree, 'a.txt')).existsSync(), File(p.join(tree, 'b.txt')).existsSync()), (true, false));
      expect(await revParse(root, 'HEAD'), await revParse(root, 'main'), reason: 'the main checkout never moved');
    });

    test('an Accept while Claude works waits in the queue, then goes on the branch', () async {
      final t = await finding();
      final head = await revParse(root, 'HEAD');
      final fix = await commit('a.txt', 'a\n');
      await s.markFixed(t.id, body: 'Fixed.', commit: fix);
      await s.setDecision(t.id, 'accept', defer: true);
      expect(await revParse(root, 'HEAD'), head);
      expect((await s.fixStatuses())[t.id]?.state, 'queued');
      await s.setDecision(t.id, null, defer: true);
      await s.setDecision(t.id, 'accept', defer: true);
      await s.applyQueued();
      expect(await revParse(root, 'HEAD'), fix);
      expect((await s.fixStatuses())[t.id]?.state, 'local');
      await expectLater(s.setDecision(t.id, 'reject', defer: true), refused('Claude is changing'));
    });

    test('an Accept and a mark_fixed at the same time take turns on the branch', () async {
      final a = await finding(), b = await finding(3);
      final first = await commit('a.txt', 'a\n');
      await s.markFixed(a.id, body: 'Fixed.', commit: first);
      final second = await commit('b.txt', 'b\n');
      await Future.wait([s.setDecision(a.id, 'accept'), s.markFixed(b.id, body: 'Fixed.', commit: second)]);
      expect((await s.fixStatuses())[a.id]?.state, 'local');
      expect((await s.fixStatuses())[b.id]?.state, 'pending');
      expect(await revParse(root, 'HEAD'), s.thread(a.id).fix);
      expect(File(p.join(root, 'b.txt')).existsSync(), isFalse);
    });

    test('every state in the transition table is a known state', () {
      for (final MapEntry(:key, :value) in threadTransitions.entries) {
        expect(threadStates, contains(key));
        for (final to in value) {
          expect(threadStates, contains(to));
        }
      }
    });
  });

  test('a fix goes where the head branch is checked out, else in a new worktree', () async {
    String real(String d) => Directory(d).resolveSymbolicLinksSync();
    final fallback = p.join(tmp.path, 'worktrees', 'gitlab-7');
    expect(real(await worktreeFor(root, 'feat/APP-12-cache', fallback)), real(root));
    expect(Directory(fallback).existsSync(), isFalse);
    expect(await worktreeFor(root, 'main', fallback), fallback);
    expect(real(await worktreeFor(root, 'main', fallback)), real(fallback));
    await removeWorktree(root, fallback);
    expect(Directory(fallback).existsSync(), isFalse);
  });
}
