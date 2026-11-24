// GitLab through the glab CLI ("glab api", the REST API with the user's own
// login), called by Deck directly. Details are only fetched again for merge
// requests that changed since the last fetch.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../core/classify/jira.dart';
import '../core/models/records.dart';
import 'shell_env.dart';

const _finalPipelines = {'SUCCESS', 'FAILED', 'CANCELED', 'SKIPPED', 'MANUAL', ''};

class MrFetch {
  const MrFetch(this.me, this.records);

  final String me;
  final List<MrRecord> records;
}

String _enc(String path) => Uri.encodeComponent(path);

class GitlabSource {
  String? _me;
  final _cache = <String, MrRecord>{};

  /// One REST call. With [all], every page, read as one list. With [post],
  /// a POST whose JSON body is in that file (see [withJsonFile]).
  Future<Object?> _api(String endpoint, {bool all = false, String? post}) async {
    final ProcessResult r;
    try {
      r = await Process.run(
        'glab',
        [
          'api',
          if (all) ...['--paginate', '--output', 'ndjson'],
          if (post != null) ...['--method', 'POST', '--header', 'Content-Type: application/json', '--input', post],
          endpoint,
        ],
        environment: await shellEnvironment(),
        runInShell: Platform.isWindows,
      ).timeout(const Duration(seconds: 30));
    } on ProcessException {
      throw StateError('glab is not installed. Install it (brew install glab), then run glab auth login.');
    }
    if (r.exitCode != 0) {
      final err = '${r.stderr}'.trim();
      throw StateError('glab api $endpoint: ${err.length > 300 ? err.substring(0, 300) : err}');
    }
    final out = '${r.stdout}'.trim();
    if (!all) return jsonDecode(out);
    return [
      for (final l in const LineSplitter().convert(out))
        if (l.trim().isNotEmpty) jsonDecode(l),
    ];
  }

  Future<String> me() async => _me ??= ((await _api('user')) as Map)['username'] as String;

  /// True when project [path] tracks its work in GitLab issues: one, open
  /// or closed, changed in the last 6 months. Open ones alone miss a quiet
  /// sprint.
  Future<bool> usesIssues(String path) async {
    final last = (await _api('projects/${_enc(path)}/issues?per_page=1&order_by=updated_at')) as List;
    final at = last.isEmpty ? null : DateTime.tryParse('${(last.first as Map)['updated_at']}');
    return at != null && DateTime.now().difference(at) < const Duration(days: 183);
  }

  /// Every open merge request of project [path] ("group/project").
  Future<List<ProjectMr>> fetchProject(String path) async {
    final user = await me();
    final all = ((await _api('projects/${_enc(path)}/merge_requests?state=opened&per_page=100', all: true)) as List).cast<Map>();
    return [
      for (final mr in all)
        ProjectMr(
          iid: mr['iid'] as int,
          title: mr['title'] as String,
          url: mr['web_url'] as String,
          author: (mr['author'] as Map)['username'] as String,
          updatedAt: DateTime.parse(mr['updated_at'] as String),
          branch: '${mr['source_branch'] ?? ''}',
          draft: mr['draft'] == true,
          mine: (mr['author'] as Map)['username'] == user,
          reviewer: [for (final r in (mr['reviewers'] as List?) ?? const []) (r as Map)['username']].contains(user),
        ),
    ];
  }

  /// Merge requests of project [path] merged after [after], oldest first.
  Future<List<({int iid, String title, String url, String author, DateTime at})>> merged(String path, DateTime after) async {
    final all = ((await _api('projects/${_enc(path)}/merge_requests?state=merged&updated_after=${after.toUtc().toIso8601String()}&per_page=100')) as List)
        .cast<Map>();
    return [
      for (final mr in all)
        if (DateTime.tryParse('${mr['merged_at']}') case final at? when at.isAfter(after))
          (iid: mr['iid'] as int, title: mr['title'] as String, url: mr['web_url'] as String, author: (mr['author'] as Map)['name'] as String, at: at),
    ]..sort((a, b) => a.at.compareTo(b.at));
  }

  Future<List<ThreadRecord>> _threads(String p) async {
    final all = ((await _api('$p/discussions?per_page=100', all: true)) as List).cast<Map>();
    return [
      for (final d in all)
        if ((d['notes'] as List).any((n) => n['resolvable'] == true && n['resolved'] != true))
          () {
            final people = [
              for (final n in d['notes'] as List)
                if (n['system'] != true) (n['author'] as Map)['username'] as String,
            ];
            return ThreadRecord(start: people.first, last: people.last, people: people);
          }(),
    ];
  }

  Future<MrRecord> _detail(Map mr, MrRole role) async {
    final id = '${mr['project_id']}!${mr['iid']}';
    final old = _cache[id];
    final updatedAt = DateTime.parse(mr['updated_at'] as String);
    if (old != null && old.updatedAt == updatedAt && old.sha == mr['sha'] && _finalPipelines.contains(old.pipeline)) {
      return old.copyWith(role: role);
    }
    final p = 'projects/${mr['project_id']}/merge_requests/${mr['iid']}';
    final r = await Future.wait([
      _api('$p/approval_state'),
      mr['sha'] == null ? Future.value(null) : _api('projects/${mr['project_id']}/pipelines?sha=${mr['sha']}&per_page=1'),
      _threads(p),
    ]);
    final rules = (((r[0] as Map?)?['rules'] as List?) ?? const []).cast<Map>();
    final pipes = (r[1] as List?) ?? const [];
    final url = mr['web_url'] as String;
    final rec = MrRecord(
      path: Uri.parse(url).path.substring(1).split('/-/').first,
      iid: int.parse('${mr['iid']}'),
      title: mr['title'] as String,
      url: url,
      author: (mr['author'] as Map)['username'] as String,
      role: role,
      draft: mr['draft'] == true,
      conflicts: mr['detailed_merge_status'] == 'conflict',
      pipeline: pipes.isEmpty ? '' : '${(pipes.first as Map)['status']}'.toUpperCase(),
      approvers: {
        for (final x in rules)
          for (final u in (x['approved_by'] as List?) ?? const []) (u as Map)['username'] as String,
      }.toList(),
      approved: rules.every((x) => x['approved'] == true),
      createdAt: DateTime.parse(mr['created_at'] as String),
      updatedAt: updatedAt,
      threads: r[2] as List<ThreadRecord>,
      sha: mr['sha'] as String?,
      branch: '${mr['source_branch'] ?? ''}',
    );
    _cache[id] = rec;
    return rec;
  }

  /// Every open MR you wrote, are assigned to, or review.
  Future<MrFetch> fetchAll() async {
    final user = await me();
    final lists = await Future.wait([
      for (final role in ['reviewer_username', 'author_username', 'assignee_username'])
        _api('merge_requests?state=opened&scope=all&per_page=100&$role=$user', all: true),
    ]);
    final byId = <String, (Map, MrRole)>{};
    for (final m in (lists[0] as List).cast<Map>()) {
      byId['${m['project_id']}!${m['iid']}'] = (m, MrRole.review);
    }
    for (final m in [...(lists[1] as List), ...(lists[2] as List)].cast<Map>()) {
      byId['${m['project_id']}!${m['iid']}'] = (m, MrRole.mine);
    }
    final records = <MrRecord>[];
    // A few at a time: each MR is three glab calls.
    final queue = byId.values.toList();
    await Future.wait(
      List.generate(4, (_) async {
        while (queue.isNotEmpty) {
          final (m, role) = queue.removeLast();
          records.add(await _detail(m, role));
        }
      }),
    );
    _cache.removeWhere((id, _) => !byId.containsKey(id));
    return MrFetch(user, records);
  }

  /// Makes an issue in project [path], assigned to you. Returns its full
  /// reference ("group/project#12") and link.
  Future<({String ref, String url})> createIssue(String path, String title, String body) async {
    final id = ((await _api('user')) as Map)['id'];
    final i = (await withJsonFile({
      'title': title,
      'description': body,
      'assignee_ids': [id],
    }, (f) => _api('projects/${_enc(path)}/issues', post: f))) as Map;
    return (ref: (i['references'] as Map)['full'] as String, url: i['web_url'] as String);
  }

  /// Open issues assigned to you in these projects ("group/project").
  Future<List<IssueRecord>> fetchIssues(List<String> paths) async {
    final lists = await Future.wait([
      for (final path in paths) _api('projects/${_enc(path)}/issues?scope=assigned_to_me&state=opened&per_page=100', all: true),
    ]);
    return [
      for (final l in lists)
        for (final i in (l as List).cast<Map>())
          boardIssue(
            key: (i['references'] as Map)['full'] as String,
            title: i['title'] as String,
            url: i['web_url'] as String,
            labels: (i['labels'] as List).cast<String>(),
            createdAt: i['created_at'] as String,
            updatedAt: i['updated_at'] as String,
          ),
    ];
  }

  /// One MR, always fresh. Null when it is no longer open.
  Future<MrRecord?> fetchOne(String path, int iid, MrRole role) async {
    final m = await _api('projects/${_enc(path)}/merge_requests/$iid') as Map;
    if (m['state'] != 'opened') return null;
    _cache.remove('${m['project_id']}!${m['iid']}');
    return _detail(m, role);
  }

  /// When the MR was merged, or null if it is not. Uses state and merged_at, never commits.
  Future<DateTime?> mergedAt(String path, int iid) async {
    final m = await _api('projects/${_enc(path)}/merge_requests/$iid') as Map;
    return m['state'] == 'merged' ? DateTime.tryParse('${m['merged_at']}')?.toLocal() : null;
  }

  /// For Settings: who you are and how many open MRs, or a readable error.
  Future<String> test() async {
    final w = Stopwatch()..start();
    final f = await fetchAll();
    return 'Signed in as ${f.me}. ${f.records.length} open merge requests in ${(w.elapsedMilliseconds / 1000).toStringAsFixed(1)} s.';
  }
}
