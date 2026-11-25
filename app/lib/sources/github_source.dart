// GitHub through the gh CLI, with the user's own login, called by Deck
// directly. One GraphQL search per role brings every detail at once.
import 'dart:convert';
import 'dart:io';

import '../core/classify/jira.dart';
import '../core/models/records.dart';
import 'gitlab_source.dart' show MrFetch;
import 'shell_env.dart';

const _pr = '''
... on PullRequest {
  number title url isDraft mergeable reviewDecision createdAt updatedAt headRefOid headRefName
  author { login }
  repository { nameWithOwner }
  commits(last: 1) { nodes { commit { statusCheckRollup { state } } } }
  latestReviews(first: 50) { nodes { state author { login } } }
  reviewThreads(first: 50) { nodes { isResolved comments(first: 20) { nodes { author { login } } } } }
}''';

Future<String> _gh(List<String> args) async {
  final ProcessResult r;
  try {
    r = await Process.run('gh', args, environment: await shellEnvironment(), runInShell: Platform.isWindows).timeout(const Duration(seconds: 30));
  } on ProcessException {
    throw StateError('gh is not installed. Install it (brew install gh), then run gh auth login.');
  }
  if (r.exitCode != 0) throw StateError('gh: ${'${r.stderr}'.trim()}');
  return '${r.stdout}';
}

String _pipeline(String? s) => switch (s) {
  null => '',
  'SUCCESS' => 'SUCCESS',
  'FAILURE' || 'ERROR' => 'FAILED',
  _ => 'RUNNING',
};

MrRecord _record(Map p, MrRole role) {
  String login(Object? a) => a is Map ? '${a['login']}' : 'ghost';
  final check = ((p['commits'] as Map)['nodes'] as List).firstOrNull as Map?;
  return MrRecord(
    path: (p['repository'] as Map)['nameWithOwner'] as String,
    iid: p['number'] as int,
    title: p['title'] as String,
    url: p['url'] as String,
    author: login(p['author']),
    role: role,
    draft: p['isDraft'] == true,
    conflicts: p['mergeable'] == 'CONFLICTING',
    pipeline: _pipeline(((check?['commit'] as Map?)?['statusCheckRollup'] as Map?)?['state'] as String?),
    approvers: [
      for (final r in (p['latestReviews'] as Map)['nodes'] as List)
        if (r['state'] == 'APPROVED') login(r['author']),
    ],
    approved: p['reviewDecision'] == 'APPROVED',
    createdAt: DateTime.parse(p['createdAt'] as String),
    updatedAt: DateTime.parse(p['updatedAt'] as String),
    threads: [
      for (final t in (p['reviewThreads'] as Map)['nodes'] as List)
        if (t['isResolved'] != true)
          () {
            final people = [for (final c in (t['comments'] as Map)['nodes'] as List) login(c['author'])];
            return ThreadRecord(start: people.first, last: people.last, people: people);
          }(),
    ],
    sha: p['headRefOid'] as String?,
    branch: '${p['headRefName'] ?? ''}',
  );
}

class GithubSource {
  String? _me;

  Future<String> me() async => _me ??= (await _gh(['api', 'user', '--jq', '.login'])).trim();

  /// Every open pull request of [repo] ("owner/repo").
  Future<List<ProjectMr>> fetchProject(String repo) async {
    final user = await me();
    final out = await _gh([
      'pr', 'list', '-R', repo, '--state', 'open', '--limit', '100', //
      '--json', 'number,title,url,author,isDraft,updatedAt,headRefName,reviewRequests',
    ]);
    return [
      for (final p in (jsonDecode(out) as List).cast<Map>())
        ProjectMr(
          iid: p['number'] as int,
          title: p['title'] as String,
          url: p['url'] as String,
          author: '${(p['author'] as Map?)?['login'] ?? 'ghost'}',
          updatedAt: DateTime.parse(p['updatedAt'] as String),
          branch: '${p['headRefName'] ?? ''}',
          draft: p['isDraft'] == true,
          mine: (p['author'] as Map?)?['login'] == user,
          reviewer: [for (final r in (p['reviewRequests'] as List?) ?? const []) (r as Map)['login']].contains(user),
        ),
    ];
  }

  /// Every open PR you wrote, are assigned to, or review; only in the repos
  /// [only] ("owner/repo") when given.
  Future<MrFetch> fetchAll({List<String>? only}) async {
    final user = await me();
    if (only != null && only.isEmpty) return MrFetch(user, const []);
    // Several repo: qualifiers match any of them.
    final base = ['is:pr is:open archived:false', for (final r in only ?? const []) 'repo:$r'].join(' ');
    final q = {
      'mine': '$base author:$user',
      'assigned': '$base assignee:$user',
      'review': '$base review-requested:$user',
      'reviewed': '$base reviewed-by:$user -author:$user',
    };
    final query = [for (final e in q.entries) '${e.key}: search(query: "${e.value}", type: ISSUE, first: 30) { nodes { $_pr } }'].join('\n');
    final data = (jsonDecode(await _gh(['api', 'graphql', '-f', 'query={ $query }'])) as Map)['data'] as Map;
    final byUrl = <String, MrRecord>{};
    for (final k in ['review', 'reviewed', 'assigned', 'mine']) {
      for (final p in ((data[k] as Map)['nodes'] as List).cast<Map>()) {
        if (p.isEmpty) continue;
        byUrl[p['url'] as String] = _record(p, k == 'review' || k == 'reviewed' ? MrRole.review : MrRole.mine);
      }
    }
    return MrFetch(user, byUrl.values.toList());
  }

  /// True when [repo] ("owner/repo") tracks its work in GitHub issues: one,
  /// open or closed, changed in the last 6 months (pull requests not counted).
  Future<bool> usesIssues(String repo) async {
    final since = DateTime.now().subtract(const Duration(days: 183)).toIso8601String().substring(0, 10);
    final found = jsonDecode(await _gh(['issue', 'list', '-R', repo, '--state', 'all', '--limit', '1', '--search', 'updated:>=$since', '--json', 'number']));
    return (found as List).isNotEmpty;
  }

  /// For Settings: who you are and how many open PRs, or a readable error.
  Future<String> test() async {
    final w = Stopwatch()..start();
    final f = await fetchAll();
    return 'Signed in as ${f.me}. ${f.records.length} open pull requests in ${(w.elapsedMilliseconds / 1000).toStringAsFixed(1)} s.';
  }
}

/// Makes an issue in [repo] ("owner/repo"), assigned to you. Returns its
/// reference ("owner/repo#12") and link.
Future<({String ref, String url})> createGithubIssue(String repo, String title, String body) async {
  final me = (await _gh(['api', 'user', '--jq', '.login'])).trim();
  final i = jsonDecode(
    await withJsonFile({
      'title': title,
      'body': body,
      'assignees': [me],
    }, (f) => _gh(['api', '--method', 'POST', 'repos/$repo/issues', '--input', f])),
  ) as Map;
  return (ref: '$repo#${i['number']}', url: i['html_url'] as String);
}

/// Open issues assigned to you in these repos ("owner/repo").
Future<List<IssueRecord>> fetchGithubIssues(List<String> repos) async {
  final lists = await Future.wait([
    for (final repo in repos)
      _gh([
        'issue', 'list', '-R', repo, '--assignee', '@me', '--state', 'open', '--limit', '100', //
        '--json', 'number,title,url,labels,createdAt,updatedAt',
      ]).then((out) => (repo, (jsonDecode(out) as List).cast<Map>())),
  ]);
  return [
    for (final (repo, l) in lists)
      for (final i in l)
        boardIssue(
          key: '$repo#${i['number']}',
          title: i['title'] as String,
          url: i['url'] as String,
          labels: [for (final x in i['labels'] as List) (x as Map)['name'] as String],
          createdAt: i['createdAt'] as String,
          updatedAt: i['updatedAt'] as String,
        ),
  ];
}
