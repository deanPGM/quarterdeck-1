// Publishing a review to its merge request: Skim's gitlab/src/publish.ts and
// github/src/publish.ts. Every open thread's answer becomes a discussion on
// its line, the answers on discussions already there go out as replies, one summary,
// then the verdict. Outdated anchors are skipped and said, never posted blind.
// The forge is reached through glab or gh with the user's own login.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../core/review/diff.dart';
import '../core/review/positions.dart';
import '../core/review/publish_plan.dart';
import '../core/review/review.dart';
import '../data/review_store.dart';
import 'shell_env.dart';

/// The one door to a forge's REST API. Tests pass a fake.
abstract interface class ForgeClient {
  Future<Object?> get(String path);
  Future<Object?> post(String path, Map<String, Object?> body);
  Future<Object?> put(String path, Map<String, Object?> body);
}

/// `glab api` or `gh api`.
class CliForge implements ForgeClient {
  CliForge(this.cli);

  final String cli;

  Future<Object?> _call(List<String> args, [String? input]) async {
    final Process proc;
    try {
      proc = await Process.start(
        cli,
        ['api', ...args],
        environment: {...await shellEnvironment(), 'NO_COLOR': '1', 'GLAB_PROMPT_DISABLED': '1'},
        runInShell: Platform.isWindows,
      );
    } on ProcessException {
      throw StateError('$cli is not installed.');
    }
    if (input != null) proc.stdin.write(input);
    await proc.stdin.close();
    final out = proc.stdout.transform(utf8.decoder).join(), err = proc.stderr.transform(utf8.decoder).join();
    final code = await proc.exitCode.timeout(const Duration(minutes: 2));
    if (code != 0) throw StateError('$cli api ${args.first}: ${(await err).trim().isEmpty ? (await out).trim() : (await err).trim()}');
    final text = (await out).trim();
    return text.isEmpty ? null : jsonDecode(text);
  }

  @override
  Future<Object?> get(String path) => _call([path]);

  @override
  Future<Object?> post(String path, Map<String, Object?> body) =>
      _call([path, '--method', 'POST', '-H', 'Content-Type: application/json', '--input', '-'], jsonEncode(body));

  @override
  Future<Object?> put(String path, Map<String, Object?> body) =>
      _call([path, '--method', 'PUT', '-H', 'Content-Type: application/json', '--input', '-'], jsonEncode(body));
}

ForgeClient forgeFor(MrSource mr) => CliForge(mr.provider == 'github' ? 'gh' : 'glab');

Future<List<SummaryTicket>> _tickets(ReviewService s) async => [
  for (final t in await s.ticketRefs())
    (
      ref: t.ref,
      url: t.url ?? s.review.tickets.where((x) => x.ref == t.ref).firstOrNull?.url,
      title: s.review.tickets.where((x) => x.ref == t.ref).firstOrNull?.title,
      check: s.review.ticketChecks.where((c) => c.ref == t.ref).firstOrNull,
    ),
];

Future<String> _summary(
  ReviewService s,
  DiffSnapshot snap, {
  required int round,
  required String verdict,
  required List<Thread> published,
  required int skipped,
  required int replies,
}) async => renderSummary(
  roundNumber: round,
  verdict: verdict,
  notes: s.review.fileNotes,
  groups: s.review.groups,
  hiddenCount: snap.hiddenCount,
  publishedSeverities: [for (final t in published) t.severity],
  skipped: skipped,
  replies: replies,
  tickets: await _tickets(s),
  headSha: snap.headSha,
);

/// The same plan a publish follows, the summary rendered, nothing sent and
/// no round opened: the reviewer reads what would go out before deciding.
Future<PublishPreview> previewReview(ReviewService s, {required String verdict, bool summary = true}) async {
  if (s.review.mr == null) throw ReviewError('This review has no merge request to publish to.');
  final snap = await s.snapshot();
  final unpushed = await s.unpushedFixes(pushing: true);
  final plan = planPublish(s.review.threads, snap, unpushed: unpushed, own: s.review.own);
  final posting = [...plan.alreadyPosted, for (final p in plan.post) p.thread];
  final replies = plannedReplies(s.review.threads, {for (final p in plan.post) p.thread.id}, unpushed: unpushed).length;
  final last = s.review.rounds.lastOrNull;
  final number = last != null && last.publishedAt == null ? last.number : (last?.number ?? 0) + 1;
  return PublishPreview(
    roundNumber: number,
    posting: posting,
    skipped: plan.skipped,
    replies: replies,
    pushes: (await s.fixStatuses()).values.where((f) => f.state == 'local').length,
    summary: summary ? await _summary(s, snap, round: number, verdict: verdict, published: posting, skipped: plan.skipped.length, replies: replies) : null,
  );
}

/// [readBackDelay]: GitHub lists a new review's comments a moment after it answers.
/// [headWait]: how long the forge may take to see a push made just before,
/// zero when nothing was pushed.
Future<PublishResult> publishReview(
  ReviewService s, {
  required String verdict,
  bool summary = true,
  ForgeClient? client,
  Duration readBackDelay = const Duration(seconds: 1),
  Duration headWait = Duration.zero,
}) {
  final mr = s.review.mr;
  if (mr == null) throw ReviewError('This review has no merge request to publish to.');
  final c = client ?? forgeFor(mr);
  return mr.provider == 'github' ? _publishGithub(s, mr, c, verdict, summary, readBackDelay, headWait) : _publishGitlab(s, mr, c, verdict, summary, headWait);
}

/// Reads the merge request until [head] of it is [want], for at most
/// [wait]: after a push, GitLab and GitHub move the request's head a few
/// seconds later, so the first read still names the old one.
Future<Map> _readAtHead(ForgeClient c, String path, String want, String Function(Map) head, Duration wait) async {
  final end = DateTime.now().add(wait);
  while (true) {
    final m = (await c.get(path))! as Map;
    if (head(m) == want || !DateTime.now().isBefore(end)) return m;
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}

String _staleHead(ReviewService s, String remote, String local) {
  final fix = s.review.headRef.startsWith('skim/')
      ? 'Open the review again from Merge Requests to fetch the latest push.'
      : 'Push ${s.review.headRef} (or pull it when the merge request moved ahead), then publish again.';
  return 'The merge request head is ${remote.substring(0, 8)} but the local head is ${local.substring(0, 8)}. $fix';
}

Future<PublishResult> _publishGitlab(ReviewService s, MrSource mr, ForgeClient c, String verdict, bool withSummary, Duration headWait) async {
  final path = 'projects/${Uri.encodeComponent(mr.projectPath)}/merge_requests/${mr.iid}';
  final snap = await s.snapshot();
  // Positions must name the shas GitLab knows for the request, fresh, and match our head.
  final remote = await _readAtHead(c, path, snap.headSha, (m) => '${(m['diff_refs'] as Map?)?['head_sha']}', headWait);
  final dr = remote['diff_refs'] as Map?;
  if (dr == null) throw ReviewError('Merge request !${mr.iid} has no diff refs');
  final refs = DiffRefs(baseSha: '${dr['base_sha']}', startSha: '${dr['start_sha']}', headSha: '${dr['head_sha']}');
  if (refs.headSha != snap.headSha) throw ReviewError(_staleHead(s, refs.headSha, snap.headSha));
  await s.setDiffRefs(refs);

  final round = await s.openRound();
  final unpushed = await s.unpushedFixes();
  final plan = planPublish(s.review.threads, snap, unpushed: unpushed, own: s.review.own);
  final published = {for (final t in plan.alreadyPosted) t.id};
  for (final (:thread, :anchor) in plan.post) {
    // No anchor: a discussion on the merge request itself.
    final body = {'body': threadBody(thread), if (anchor != null) 'position': positionForAnchor(anchor, snap, refs)};
    final d = (await c.post('$path/discussions', body))! as Map;
    final first = (d['notes'] as List?)?.firstOrNull as Map?;
    await s.setThreadRemoteId(thread.id, '${d['id']}', first == null ? null : '${first['id']}');
    published.add(thread.id);
  }

  var replies = 0;
  for (final t in plannedReplies(s.review.threads, published, unpushed: unpushed)) {
    final discussion = '$path/discussions/${Uri.encodeComponent(t.remoteId!)}';
    final note = (await c.post('$discussion/notes', {'body': messageBody(t.answer!, t)}))! as Map;
    await s.setAnswerPosted(t.id, '${note['id']}');
    replies++;
    if (resolvesThread(t, own: s.review.own)) {
      await c.put(discussion, {'resolved': true});
      await s.setThreadState(t.id, 'resolved', 'user');
    }
  }

  // A retry after a failed verdict finds the note already posted and named on the round.
  var noteId = round.remoteNoteId;
  if (withSummary && noteId == null) {
    final body = await _summary(
      s,
      snap,
      round: round.number,
      verdict: verdict,
      published: [for (final id in published) s.thread(id)],
      skipped: plan.skipped.length,
      replies: replies,
    );
    noteId = '${((await c.post('$path/notes', {'body': body}))! as Map)['id']}';
    await s.setRoundSummaryNote(round.id, noteId);
  }
  // Approval has its own endpoint; comment and request changes are the note itself.
  if (verdict == 'approve') await c.post('$path/approve', {'sha': snap.headSha});

  final closed = await s.publishRound(round.id, verdict: verdict, remoteNoteId: noteId, exclude: {for (final k in plan.skipped) k.threadId});
  return PublishResult(round: closed, published: published.length, skipped: plan.skipped, replies: replies);
}

const _issue = 'issue:';

const _reviewThreads = r'''
query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) { pullRequest(number: $number) {
    reviewThreads(first: 100) { nodes { id isResolved comments(first: 1) { nodes { databaseId } } } }
  } }
}''';

/// Resolves the review thread whose first comment is [commentId]: GitHub
/// resolves threads by their GraphQL id only. False when it is not found.
Future<bool> _resolveGithub(ForgeClient c, MrSource mr, String commentId) async {
  final [owner, name] = mr.projectPath.split('/');
  final r =
      (await c.post('graphql', {
            'query': _reviewThreads,
            'variables': {'owner': owner, 'name': name, 'number': mr.iid},
          }))!
          as Map;
  final nodes = (((((r['data'] as Map)['repository'] as Map)['pullRequest'] as Map)['reviewThreads'] as Map)['nodes'] as List).cast<Map>();
  final thread = nodes.where((n) => '${((n['comments'] as Map)['nodes'] as List).firstOrNull?['databaseId']}' == commentId).firstOrNull;
  if (thread == null) return false;
  if (thread['isResolved'] != true) {
    await c.post('graphql', {
      'query': r'mutation($id: ID!) { resolveReviewThread(input: {threadId: $id}) { thread { id } } }',
      'variables': {'id': thread['id']},
    });
  }
  return true;
}

const _events = {'approve': 'APPROVE', 'request_changes': 'REQUEST_CHANGES', 'comment': 'COMMENT'};

Future<PublishResult> _publishGithub(
  ReviewService s,
  MrSource mr,
  ForgeClient c,
  String verdict,
  bool withSummary,
  Duration readBackDelay,
  Duration headWait,
) async {
  final path = 'repos/${mr.projectPath}/pulls/${mr.iid}';
  final snap = await s.snapshot();
  String headOf(Map m) => '${(m['head'] as Map)['sha']}';
  final head = headOf(await _readAtHead(c, path, snap.headSha, headOf, headWait));
  if (head != snap.headSha) throw ReviewError(_staleHead(s, head, snap.headSha));

  final round = await s.openRound();
  final unpushed = await s.unpushedFixes();
  final plan = planPublish(s.review.threads, snap, unpushed: unpushed, own: s.review.own);
  final skipped = [...plan.skipped];
  final published = {for (final t in plan.alreadyPosted) t.id};

  // A review comment needs a line: a thread on the whole change is an issue comment.
  for (final p in plan.post.where((p) => p.anchor == null)) {
    final note = (await c.post('repos/${mr.projectPath}/issues/${mr.iid}/comments', {'body': threadBody(p.thread, gitHubSuggestion)}))! as Map;
    await s.setThreadRemoteId(p.thread.id, '$_issue${note['id']}', '$_issue${note['id']}');
    published.add(p.thread.id);
  }
  final inline = [
    for (final p in plan.post)
      if (p.anchor != null) (thread: p.thread, anchor: p.anchor!),
  ];
  final comments = [for (final i in inline) commentFor(i.thread, i.anchor)];
  final roundThreads = {...published, for (final i in inline) i.thread.id};

  // A retry after the read back failed finds the review already posted: never post it twice.
  var reviewId = round.remoteNoteId;
  if (reviewId == null) {
    final body = withSummary
        ? await _summary(
            s,
            snap,
            round: round.number,
            verdict: verdict,
            published: [for (final id in roundThreads) s.thread(id)],
            skipped: skipped.length,
            replies: plannedReplies(s.review.threads, roundThreads, unpushed: unpushed).length,
          )
        // GitHub refuses a review with no body unless it approves.
        : {'request_changes': 'Changes requested.', 'comment': 'Comments, no verdict.'}[verdict] ?? '';
    // One call: body, verdict and every inline comment land as one review.
    final r = (await c.post('$path/reviews', {'commit_id': snap.headSha, 'body': body, 'event': _events[verdict], 'comments': comments}))! as Map;
    reviewId = '${r['id']}';
    await s.setRoundSummaryNote(round.id, reviewId);
  }

  if (inline.isNotEmpty) {
    // The answer has no comment ids: read them back, GitHub lists them a moment later.
    var found = <Map<String, Object?>?>[];
    for (var attempt = 0; attempt < 5; attempt++) {
      if (attempt > 0) await Future<void>.delayed(readBackDelay * attempt);
      final all = ((await c.get('$path/comments?sort=created&direction=desc&per_page=100'))! as List).cast<Map>().map((m) => m.cast<String, Object?>());
      found = matchPosted([
        for (final p in all)
          if ('${p['pull_request_review_id']}' == reviewId) p,
      ], comments);
      if (found.every((f) => f != null)) break;
    }
    for (final (i, (:thread, anchor: _)) in inline.indexed) {
      final f = found[i];
      if (f == null) {
        // Not kept by GitHub, a position it refused. The thread keeps its answer for the next round.
        skipped.add((threadId: thread.id, reason: 'not in the posted review: ${comments[i]['path']}:${comments[i]['line']} came back with no comment'));
        continue;
      }
      await s.setThreadRemoteId(thread.id, '${f['id']}', '${f['id']}');
      published.add(thread.id);
    }
  }

  var replies = 0;
  for (final t in plannedReplies(s.review.threads, roundThreads, unpushed: unpushed)) {
    final body = {'body': messageBody(t.answer!, t, gitHubSuggestion)};
    final note =
        (t.remoteId!.startsWith(_issue)
                ? await c.post('repos/${mr.projectPath}/issues/${mr.iid}/comments', body)
                : await c.post('$path/comments/${t.remoteId}/replies', body))!
            as Map;
    await s.setAnswerPosted(t.id, '${note['id']}');
    replies++;
    if (resolvesThread(t, own: s.review.own) && !t.remoteId!.startsWith(_issue) && await _resolveGithub(c, mr, t.remoteId!)) {
      await s.setThreadState(t.id, 'resolved', 'user');
    }
  }

  final closed = await s.publishRound(round.id, verdict: verdict, remoteNoteId: reviewId, exclude: {for (final k in skipped) k.threadId});
  return PublishResult(round: closed, published: published.length, skipped: skipped, replies: replies);
}
