// The run ledger: one JSON line per Claude session Deck started, one file per
// month in cache/runs/, and the raw output of each run (stream JSON plus
// stderr) in cache/runs/logs/<id>.log, kept 30 days, and the problems sessions
// reported themselves (deck_report_issue) in cache/runs/issues.jsonl. Read by the
// deck-insights skill to find what fails, what is slow and what costs. Off by
// default: Settings › Claude › Keep a run log (collectRuns).
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/models/config.dart';
import 'deck_home.dart';

/// A run's id, sorted by time: 20261117-093812-map_all-1a2b3c4d. [tag] tells
/// apart runs of the same kind in the same second.
String runIdOf(DateTime at, String kind, String tag) {
  final stamp = at.toIso8601String().substring(0, 19).replaceAll(RegExp('[-:]'), '').replaceAll('T', '-');
  return '$stamp-$kind-$tag'.replaceAll(RegExp(r'[^\w.-]'), '_');
}

/// The end of stderr, enough to see why without the whole log. Claude's list
/// of every MCP tool after "Available MCP tools:" is cut: it says nothing.
String tailOf(String s, [int max = 2000]) {
  final t = s.replaceAll(RegExp(r'Available MCP tools: [^\n]*'), 'Available MCP tools: …').trim();
  return t.length <= max ? t : '…${t.substring(t.length - max)}';
}

/// How a run ended.
enum RunOutcome { ok, failed, timeout, stopped, noClaude }

class RunRecord {
  const RunRecord({
    required this.id,
    required this.kind,
    required this.at,
    required this.outcome,
    this.subject = '',
    this.model = '',
    this.dir = '',
    this.sessionId,
    this.resumed = false,
    this.seconds = 0,
    this.apiSeconds = 0,
    this.costUsd = 0,
    this.turns = 0,
    this.tokens = const {},
    this.exitCode,
    this.error,
    this.denials = const [],
    this.toolCalls = const {},
    this.toolErrors = const {},
    this.mcpFailed = const [],
    this.stderrTail = '',
  });

  /// Also the name of the raw log.
  final String id;

  /// worker, project-info, `map:<part>`, `review:<kind>`, summary, facts, rule-advice.
  final String kind;

  /// What it ran for: providers, a project id, a review key.
  final String subject;
  final DateTime at;
  final RunOutcome outcome;
  final String model;
  final String dir;
  final String? sessionId;
  final bool resumed;
  final int seconds;

  /// Time spent waiting on the model, from the result line.
  final int apiSeconds;
  final double costUsd;
  final int turns;

  /// input, output, cacheRead, cacheWrite.
  final Map<String, int> tokens;
  final int? exitCode;
  final String? error;

  /// Tools the session was refused.
  final List<String> denials;

  /// Calls per tool name, and those that came back with an error.
  final Map<String, int> toolCalls;
  final Map<String, int> toolErrors;

  /// MCP servers that did not connect.
  final List<String> mcpFailed;
  final String stderrTail;

  RunRecord copyWith({RunOutcome? outcome, String? error}) => RunRecord(
    id: id,
    kind: kind,
    at: at,
    outcome: outcome ?? this.outcome,
    subject: subject,
    model: model,
    dir: dir,
    sessionId: sessionId,
    resumed: resumed,
    seconds: seconds,
    apiSeconds: apiSeconds,
    costUsd: costUsd,
    turns: turns,
    tokens: tokens,
    exitCode: exitCode,
    error: error ?? this.error,
    denials: denials,
    toolCalls: toolCalls,
    toolErrors: toolErrors,
    mcpFailed: mcpFailed,
    stderrTail: stderrTail,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind,
    if (subject.isNotEmpty) 'subject': subject,
    'at': at.toIso8601String(),
    'outcome': outcome.name,
    if (model.isNotEmpty) 'model': model,
    if (dir.isNotEmpty) 'dir': dir,
    'sessionId': ?sessionId,
    if (resumed) 'resumed': true,
    'seconds': seconds,
    if (apiSeconds > 0) 'apiSeconds': apiSeconds,
    if (costUsd > 0) 'costUsd': costUsd,
    if (turns > 0) 'turns': turns,
    if (tokens.isNotEmpty) 'tokens': tokens,
    'exitCode': ?exitCode,
    'error': ?error,
    if (denials.isNotEmpty) 'denials': denials,
    if (toolCalls.isNotEmpty) 'toolCalls': toolCalls,
    if (toolErrors.isNotEmpty) 'toolErrors': toolErrors,
    if (mcpFailed.isNotEmpty) 'mcpFailed': mcpFailed,
    if (stderrTail.isNotEmpty) 'stderrTail': stderrTail,
  };

  factory RunRecord.fromJson(Map<String, Object?> j) {
    Map<String, int> counts(Object? x) => {for (final e in ((x as Map?) ?? const {}).entries) '${e.key}': (e.value as num).toInt()};
    return RunRecord(
      id: j['id']! as String,
      kind: j['kind']! as String,
      subject: (j['subject'] as String?) ?? '',
      at: DateTime.parse(j['at']! as String),
      outcome: RunOutcome.values.asNameMap()[j['outcome']] ?? RunOutcome.failed,
      model: (j['model'] as String?) ?? '',
      dir: (j['dir'] as String?) ?? '',
      sessionId: j['sessionId'] as String?,
      resumed: j['resumed'] == true,
      seconds: (j['seconds'] as num?)?.toInt() ?? 0,
      apiSeconds: (j['apiSeconds'] as num?)?.toInt() ?? 0,
      costUsd: (j['costUsd'] as num?)?.toDouble() ?? 0,
      turns: (j['turns'] as num?)?.toInt() ?? 0,
      tokens: counts(j['tokens']),
      exitCode: (j['exitCode'] as num?)?.toInt(),
      error: j['error'] as String?,
      denials: [...((j['denials'] as List?) ?? const []).cast<String>()],
      toolCalls: counts(j['toolCalls']),
      toolErrors: counts(j['toolErrors']),
      mcpFailed: [...((j['mcpFailed'] as List?) ?? const []).cast<String>()],
      stderrTail: (j['stderrTail'] as String?) ?? '',
    );
  }
}

/// Reads a run's stream JSON as it comes, and keeps what the ledger needs.
class RunWatch {
  final _toolOf = <String, String>{};
  final toolCalls = <String, int>{};
  final toolErrors = <String, int>{};
  final mcpFailed = <String>[];
  Map<String, Object?>? result;

  void add(Map<String, Object?> ev) {
    switch (ev['type']) {
      case 'system' when ev['subtype'] == 'init':
        for (final s in ((ev['mcp_servers'] as List?) ?? const []).whereType<Map>()) {
          if (s['status'] != 'connected') mcpFailed.add('${s['name']}: ${s['status']}');
        }
      case 'assistant':
        for (final c in _content(ev)) {
          if (c['type'] == 'tool_use' && c['name'] is String) {
            final name = c['name'] as String;
            _toolOf['${c['id']}'] = name;
            toolCalls[name] = (toolCalls[name] ?? 0) + 1;
          }
        }
      case 'user':
        for (final c in _content(ev)) {
          if (c['type'] == 'tool_result' && c['is_error'] == true) {
            final name = _toolOf['${c['tool_use_id']}'] ?? '?';
            toolErrors[name] = (toolErrors[name] ?? 0) + 1;
          }
        }
      case 'result':
        result = ev;
    }
  }

  static Iterable<Map> _content(Map<String, Object?> ev) => switch (ev['message']) {
    {'content': final List c} => c.whereType<Map>(),
    _ => const [],
  };

  /// The result line's numbers and refusals, for [RunRecord].
  ({double cost, int turns, int apiSeconds, Map<String, int> tokens, List<String> denials}) get totals {
    final r = result ?? const {};
    final u = (r['usage'] as Map?) ?? const {};
    int n(Object? x) => (x as num?)?.toInt() ?? 0;
    return (
      cost: (r['total_cost_usd'] as num?)?.toDouble() ?? 0,
      turns: n(r['num_turns']),
      apiSeconds: n(r['duration_api_ms']) ~/ 1000,
      tokens: {
        if (n(u['input_tokens']) > 0) 'input': n(u['input_tokens']),
        if (n(u['output_tokens']) > 0) 'output': n(u['output_tokens']),
        if (n(u['cache_read_input_tokens']) > 0) 'cacheRead': n(u['cache_read_input_tokens']),
        if (n(u['cache_creation_input_tokens']) > 0) 'cacheWrite': n(u['cache_creation_input_tokens']),
      },
      denials: [for (final d in ((r['permission_denials'] as List?) ?? const []).whereType<Map>()) '${d['tool_name']}'],
    );
  }
}

class RunLog {
  RunLog(this.home);

  final DeckHome home;

  static const keepLogs = Duration(days: 30);

  /// Whether to keep anything, read from deck.json when a run starts: off
  /// unless turned on in Settings.
  bool get on {
    try {
      final j = jsonDecode(home.config.readAsStringSync());
      return j is Map<String, Object?> && DeckConfig.fromJson(j).claude.collectRuns;
    } on Object {
      return false;
    }
  }

  Directory get _dir => Directory(p.join(home.cache.path, 'runs'));

  File _month(DateTime d) => File(p.join(_dir.path, '${d.year}-${'${d.month}'.padLeft(2, '0')}.jsonl'));

  /// Where the run's raw output goes.
  File logOf(String id) => File(p.join(_dir.path, 'logs', '$id.log'));

  /// Opens the raw log of a new run, after dropping logs older than [keepLogs].
  IOSink openLog(String id) {
    final f = logOf(id)..parent.createSync(recursive: true);
    _prune(f.parent);
    return f.openWrite();
  }

  void _prune(Directory logs) {
    final old = DateTime.now().subtract(keepLogs);
    try {
      for (final f in logs.listSync().whereType<File>()) {
        if (f.lastModifiedSync().isBefore(old)) f.deleteSync();
      }
    } on FileSystemException {
      // Another run pruned it first.
    }
  }

  /// Sync writes: runs often end in the same second, and async appends of
  /// two lines got mixed in the file.
  Future<void> add(RunRecord r) async {
    if (!on) return;
    final f = _month(r.at);
    f.parent.createSync(recursive: true);
    f.writeAsStringSync('${jsonEncode(r.toJson())}\n', mode: FileMode.append, flush: true);
  }

  /// What the earlier runs of [session] in the ledger cost, summed. Claude's
  /// result adds up over --resume: a resumed run's own share is the rest.
  Future<({double cost, int apiSeconds})> spentBy(String session) async {
    var cost = 0.0, api = 0;
    final now = DateTime.now();
    for (final r in await read(DateTime(now.year, now.month - 1), now)) {
      if (r.sessionId != session) continue;
      cost += r.costUsd;
      api += r.apiSeconds;
    }
    return (cost: cost, apiSeconds: api);
  }

  File get _issues => File(p.join(_dir.path, 'issues.jsonl'));

  /// One problem a session reported with deck_report_issue.
  Future<void> addIssue(Map<String, Object?> issue) async {
    if (!on) return;
    _dir.createSync(recursive: true);
    _issues.writeAsStringSync('${jsonEncode(issue)}\n', mode: FileMode.append, flush: true);
  }

  /// Reported issues since [since], oldest first.
  Future<List<Map<String, Object?>>> issues({DateTime? since}) async {
    if (!_issues.existsSync()) return [];
    Map<String, Object?>? parse(String l) {
      try {
        return jsonDecode(l) as Map<String, Object?>;
      } on FormatException {
        return null; // A line mixed with another before writes were sync.
      }
    }

    return [
      for (final l in await _issues.readAsLines())
        if (l.trim().isNotEmpty)
          if (parse(l) case final i? when since == null || !DateTime.parse('${i['at']}').isBefore(since)) i,
    ];
  }

  /// Runs from [from] to [to], both days included, oldest first.
  Future<List<RunRecord>> read(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day), end = DateTime(to.year, to.month, to.day + 1);
    final out = <RunRecord>[];
    for (var m = DateTime(start.year, start.month); m.isBefore(end); m = DateTime(m.year, m.month + 1)) {
      final f = _month(m);
      if (!f.existsSync()) continue;
      for (final l in await f.readAsLines()) {
        if (l.trim().isEmpty) continue;
        final RunRecord r;
        try {
          r = RunRecord.fromJson(jsonDecode(l) as Map<String, Object?>);
        } on FormatException {
          continue; // A line mixed with another before writes were sync.
        } on TypeError {
          continue;
        }
        if (!r.at.isBefore(start) && r.at.isBefore(end)) out.add(r);
      }
    }
    return out..sort((a, b) => a.at.compareTo(b.at));
  }
}
