// A merge request as a review needs it: its text and branches, the refs to
// diff (without touching the working tree), and whether the forge would
// merge it now. Through glab and gh with the user's own login. Ports of
// Skim's packages/gitlab (glab.ts, checkout.ts, status.ts) and
// packages/github (gh.ts, status.ts).
import 'dart:convert';
import 'dart:io';

import '../core/review/review.dart';
import 'shell_env.dart';

Future<String> _run(String cli, List<String> args, {String? dir}) async {
  final ProcessResult r;
  try {
    r = await Process.run(
      cli,
      args,
      workingDirectory: dir,
      environment: {...await shellEnvironment(), 'NO_COLOR': '1', 'GLAB_PROMPT_DISABLED': '1'},
      runInShell: Platform.isWindows,
    ).timeout(const Duration(minutes: 2));
  } on ProcessException {
    throw StateError('$cli is not installed.');
  }
  if (r.exitCode != 0) throw StateError('$cli ${args.take(3).join(' ')}: ${'${r.stderr}'.trim()}');
  return '${r.stdout}';
}

/// Refuses anything git could read as an option.
String _ref(String ref) {
  if (ref.isEmpty || ref.startsWith('-') || RegExp(r'[\s\x00]').hasMatch(ref)) throw StateError('Invalid git ref: $ref');
  return ref;
}

/// The merge request [iid] of [repo] ("gitlab:group/project" or "github:owner/repo").
Future<MrSource> fetchMr(String repo, int iid) async {
  final (provider, path) = _split(repo);
  if (provider == 'gitlab') {
    final m = jsonDecode(await _run('glab', ['api', 'projects/${Uri.encodeComponent(path)}/merge_requests/$iid'])) as Map<String, Object?>;
    final refs = (m['diff_refs'] as Map?) ?? const {};
    return MrSource(
      provider: 'gitlab',
      url: m['web_url'] as String,
      iid: iid,
      projectPath: path,
      title: '${m['title'] ?? ''}',
      description: '${m['description'] ?? ''}',
      author: '${(m['author'] as Map?)?['username'] ?? ''}',
      sourceBranch: '${m['source_branch'] ?? ''}',
      targetBranch: '${m['target_branch'] ?? ''}',
      diffRefs: DiffRefs(baseSha: '${refs['base_sha'] ?? ''}', startSha: '${refs['start_sha'] ?? ''}', headSha: '${refs['head_sha'] ?? ''}'),
    );
  }
  final p = jsonDecode(
    await _run('gh', ['pr', 'view', '$iid', '-R', path, '--json', 'number,title,body,url,author,baseRefName,baseRefOid,headRefName,headRefOid']),
  ) as Map<String, Object?>;
  return MrSource(
    provider: 'github',
    url: p['url'] as String,
    iid: iid,
    projectPath: path,
    title: '${p['title'] ?? ''}',
    description: '${p['body'] ?? ''}',
    author: '${(p['author'] as Map?)?['login'] ?? ''}',
    sourceBranch: '${p['headRefName'] ?? ''}',
    targetBranch: '${p['baseRefName'] ?? ''}',
    diffRefs: DiffRefs(baseSha: '${p['baseRefOid'] ?? ''}', startSha: '${p['baseRefOid'] ?? ''}', headSha: '${p['headRefOid'] ?? ''}'),
  );
}

(String, String) _split(String repo) {
  final i = repo.indexOf(':');
  if (i < 0 || !{'gitlab', 'github'}.contains(repo.substring(0, i))) throw StateError('Not a GitLab or GitHub repo: $repo');
  return (repo.substring(0, i), repo.substring(i + 1));
}

/// The refs to review [mr] on, in project folder [dir], working tree left
/// alone. The local source branch when there is one (a commit on it shows on
/// the next refresh), else the request's head fetched into `skim/mr-<iid>`
/// (`skim/pr-<n>` on GitHub). The `+` lets a force push replace it.
Future<({String baseRef, String headRef, bool local})> checkoutMr(String dir, MrSource mr, {String remote = 'origin'}) async {
  final target = _ref(mr.targetBranch);
  final baseRef = '$remote/$target';
  final source = mr.sourceBranch;
  if (source.isNotEmpty && (await Process.run('git', ['-C', dir, 'rev-parse', '--verify', '--quiet', 'refs/heads/${_ref(source)}'])).exitCode == 0) {
    await _run('git', ['-C', dir, 'fetch', '--no-tags', remote, target]);
    return (baseRef: baseRef, headRef: source, local: true);
  }
  final github = mr.provider == 'github';
  final headRef = 'skim/${github ? 'pr' : 'mr'}-${mr.iid}';
  final pull = github ? 'refs/pull/${mr.iid}/head' : 'refs/merge-requests/${mr.iid}/head';
  await _run('git', ['-C', dir, 'fetch', '--no-tags', remote, target, '+$pull:refs/heads/$headRef']);
  return (baseRef: baseRef, headRef: headRef, local: false);
}

/// Whether the forge would merge it now, and what stands in the way.
class MrStatus {
  const MrStatus({required this.state, this.blockers = const [], this.pipeline = ''});

  /// open, draft, merged or closed.
  final String state;

  /// In plain words: "ci must pass", "conflicts with main". Empty when it would merge.
  final List<String> blockers;

  /// success, failed, running or empty when there is none.
  final String pipeline;
}

const _notBlocking = {'mergeable', 'checking', 'unchecked', 'preparing', 'approvals_syncing'};
const _mergeStatus = {
  'conflict': 'conflicts with the target branch',
  'discussions_not_resolved': 'unresolved discussions',
  'draft_status': 'still a draft',
  'jira_association_missing': 'no Jira issue linked',
  'need_rebase': 'needs a rebase',
  'commits_status': 'no commits to merge',
  'merge_time': 'merge scheduled for later',
};

Future<MrStatus> fetchMrStatus(MrSource mr) async {
  if (mr.provider == 'gitlab') {
    final m = jsonDecode(await _run('glab', ['api', 'projects/${Uri.encodeComponent(mr.projectPath)}/merge_requests/${mr.iid}'])) as Map<String, Object?>;
    return gitlabStatus(m);
  }
  final p = jsonDecode(
    await _run('gh', [
      'pr',
      'view',
      '${mr.iid}',
      '-R',
      mr.projectPath,
      '--json',
      'state,isDraft,mergeable,mergeStateStatus,reviewDecision,baseRefName,statusCheckRollup',
    ]),
  ) as Map<String, Object?>;
  return githubStatus(p);
}

/// GitLab's merge box in Deck's words. Pure, for tests.
MrStatus gitlabStatus(Map<String, Object?> m) {
  final target = '${m['target_branch']}';
  final state = switch (m['state']) {
    'merged' => 'merged',
    'closed' => 'closed',
    _ => m['draft'] == true ? 'draft' : 'open',
  };
  final detailed = '${m['detailed_merge_status'] ?? 'unchecked'}';
  final blockers = <String>[
    if (!_notBlocking.contains(detailed)) (_mergeStatus[detailed] ?? detailed.replaceAll('_', ' ')).replaceAll('the target branch', target),
    if (m['has_conflicts'] == true && detailed != 'conflict') 'conflicts with $target',
  ];
  final pipe = '${(m['head_pipeline'] as Map?)?['status'] ?? ''}';
  return MrStatus(
    state: state,
    blockers: blockers,
    pipeline: switch (pipe) {
      'success' => 'success',
      'failed' || 'canceled' => 'failed',
      '' || 'skipped' || 'manual' => '',
      _ => 'running',
    },
  );
}

/// GitHub's merge box in Deck's words. Pure, for tests.
MrStatus githubStatus(Map<String, Object?> p) {
  final base = '${p['baseRefName']}';
  final state = switch (p['state']) {
    'MERGED' => 'merged',
    'CLOSED' => 'closed',
    _ => p['isDraft'] == true ? 'draft' : 'open',
  };
  const failed = {'FAILURE', 'TIMED_OUT', 'ACTION_REQUIRED', 'STARTUP_FAILURE', 'ERROR', 'CANCELLED'};
  var fail = 0, pending = 0;
  for (final c in (p['statusCheckRollup'] as List?) ?? const []) {
    final m = c as Map;
    final s = m['__typename'] == 'StatusContext' ? '${m['state']}' : (m['status'] != 'COMPLETED' ? 'PENDING' : '${m['conclusion'] ?? ''}');
    if (failed.contains(s)) fail++;
    if (s == 'PENDING' || s == 'EXPECTED') pending++;
  }
  final blockers = [
    if (state == 'draft') 'still a draft',
    if (p['mergeable'] == 'CONFLICTING') 'conflicts with $base',
    if (p['mergeStateStatus'] == 'BEHIND') 'behind $base',
    if (p['reviewDecision'] == 'REVIEW_REQUIRED') 'review required',
    if (p['reviewDecision'] == 'CHANGES_REQUESTED') 'changes requested',
    if (fail > 0) '$fail ${fail == 1 ? 'check' : 'checks'} failed',
    if (pending > 0) '$pending ${pending == 1 ? 'check' : 'checks'} running',
  ];
  if (p['mergeStateStatus'] == 'BLOCKED' && blockers.isEmpty) blockers.add('blocked by a branch rule');
  return MrStatus(
    state: state,
    blockers: blockers,
    pipeline: fail > 0 ? 'failed' : (pending > 0 ? 'running' : ((p['statusCheckRollup'] as List?)?.isEmpty ?? true ? '' : 'success')),
  );
}
