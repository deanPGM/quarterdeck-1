// Bringing a merge request's discussions into its review: Skim's
// gitlab/src/pull.ts and github/src/pull.ts. Notes on a discussion we know
// become remote messages, deduped by note id; discussions we do not know
// become published remote threads, anchored from their position.
import '../core/review/anchors.dart';
import '../core/review/diff.dart';
import '../core/review/positions.dart';
import '../core/review/review.dart';
import '../data/review_store.dart';
import 'review_publish.dart';

typedef PullResult = ({int threadsCreated, int threadsUpdated, int messagesAdded, int skipped});
typedef _Msg = ({String remoteId, String body, String? createdAt});

Future<PullResult> pullDiscussions(ReviewService s, {ForgeClient? client}) {
  final mr = s.review.mr;
  if (mr == null) throw ReviewError('This review has no merge request to pull from.');
  final c = client ?? forgeFor(mr);
  return mr.provider == 'github' ? _pullGithub(s, mr, c) : _pullGitlab(s, mr, c);
}

/// A forge line not in our diff (outside the hunks, an older head) still
/// gets a thread: an anchor reanchor reports as outdated.
Anchor _anchorOrPlaceholder(DiffSnapshot snap, ({String path, String side, int line}) at) {
  try {
    return anchorFor(snap, path: at.path, line: at.line, side: at.side);
  } on AnchorError {
    return Anchor(path: at.path, side: at.side, hunkRef: '', line: at.line, endLine: at.line, contentHash: '');
  }
}

Future<PullResult> _pullGitlab(ReviewService s, MrSource mr, ForgeClient c) async {
  final path = 'projects/${Uri.encodeComponent(mr.projectPath)}/merge_requests/${mr.iid}/discussions?per_page=100';
  final discussions = ((await c.get(path)) as List? ?? const []).cast<Map>();
  final snap = await s.snapshot();
  final byRemote = {
    for (final t in s.review.threads)
      if (t.remoteId != null) t.remoteId!: t,
  };
  var created = 0, updated = 0, added = 0, skipped = 0;
  for (final d in discussions) {
    final notes = [
      for (final n in (d['notes'] as List? ?? const []).cast<Map>())
        if (n['system'] != true) n,
    ];
    if (notes.isEmpty) continue;
    final messages = <_Msg>[
      for (final n in notes) (remoteId: '${n['id']}', body: '${_who((n['author'] as Map?)?['username'])}${n['body']}', createdAt: n['created_at'] as String?),
    ];
    final resolvable = notes.where((n) => n['resolvable'] == true);
    final resolved = resolvable.isNotEmpty && resolvable.every((n) => n['resolved'] == true);
    final local = byRemote['${d['id']}'];
    if (local != null) {
      final n = await s.importRemoteMessages(local.id, messages);
      added += n;
      if (n > 0) updated++;
      if (resolved && s.thread(local.id).state == 'published') await s.setThreadState(local.id, 'resolved', 'user');
      continue;
    }
    // A single note with no thread is a passing remark, not a thread.
    if (d['individual_note'] == true) {
      skipped++;
      continue;
    }
    final at = [
      for (final n in notes)
        if (n['position'] is Map) ?anchorInputFromPosition((n['position'] as Map).cast<String, Object?>()),
    ].firstOrNull;
    final t = await s.importRemoteThread(anchor: at == null ? null : _anchorOrPlaceholder(snap, at), remoteId: '${d['id']}', messages: messages);
    if (resolved) await s.setThreadState(t.id, 'resolved', 'user');
    created++;
    added += messages.length;
  }
  return (threadsCreated: created, threadsUpdated: updated, messagesAdded: added, skipped: skipped);
}

/// GitHub threads review comments by in_reply_to_id: the root is the thread,
/// its id is what publish stored. Issue comments are not threads. Resolved
/// state lives behind GraphQL, so it is not read.
Future<PullResult> _pullGithub(ReviewService s, MrSource mr, ForgeClient c) async {
  final comments = ((await c.get('repos/${mr.projectPath}/pulls/${mr.iid}/comments?per_page=100')) as List? ?? const []).cast<Map>();
  final snap = await s.snapshot();
  final byRemote = {
    for (final t in s.review.threads)
      if (t.remoteId != null) t.remoteId!: t,
  };
  final threads = <String, List<Map>>{};
  for (final cm in comments) {
    (threads['${cm['in_reply_to_id'] ?? cm['id']}'] ??= []).add(cm);
  }
  var created = 0, updated = 0, added = 0, skipped = 0;
  for (final MapEntry(key: root, value: list) in threads.entries) {
    list.sort((a, b) => '${a['created_at'] ?? ''}'.compareTo('${b['created_at'] ?? ''}'));
    final messages = <_Msg>[
      for (final cm in list) (remoteId: '${cm['id']}', body: '${_who((cm['user'] as Map?)?['login'])}${cm['body']}', createdAt: cm['created_at'] as String?),
    ];
    final local = byRemote[root];
    if (local != null) {
      final n = await s.importRemoteMessages(local.id, messages);
      added += n;
      if (n > 0) updated++;
      continue;
    }
    final first = list.first;
    final line = first['line'] ?? first['original_line'];
    if (line is! int) {
      skipped++;
      continue;
    }
    final at = (path: '${first['path']}', side: first['side'] == 'LEFT' ? 'old' : 'new', line: line);
    await s.importRemoteThread(anchor: _anchorOrPlaceholder(snap, at), remoteId: root, messages: messages);
    created++;
    added += messages.length;
  }
  return (threadsCreated: created, threadsUpdated: updated, messagesAdded: added, skipped: skipped);
}

/// The author is `remote`; the name goes on its own line in the body.
String _who(Object? name) => name is String && name.isNotEmpty ? '**@$name**\n\n' : '';
