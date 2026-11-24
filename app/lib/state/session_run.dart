// A background Claude session Deck started for a project (a map pass, a
// review), while it runs and once it is done.
import 'dart:convert';

import '../core/models/claude_run.dart';

class SessionRun {
  const SessionRun({required this.startedAt, this.step = '', this.result, this.total, this.done = const {}, this.countingSince, this.kind = ''});

  final DateTime startedAt;

  /// What the session is for, when its owner runs more than one kind (a
  /// review: prepare or answer).
  final String kind;

  /// The last thing the session did, in a few words.
  final String step;
  final ClaudeRun? result;

  /// How many pieces the session said it will write (features, files), once known.
  final int? total;

  /// The pieces written since then.
  final Set<String> done;

  /// When the session said how much it will write: the estimate counts from
  /// here, so the survey before it does not slow the rate.
  final DateTime? countingSince;

  bool get running => result == null;

  SessionRun copyWith({String? step, ClaudeRun? result, int? total, Set<String>? done, DateTime? countingSince}) => SessionRun(
    startedAt: startedAt,
    step: step ?? this.step,
    result: result ?? this.result,
    total: total ?? this.total,
    done: done ?? this.done,
    countingSince: countingSince ?? this.countingSince,
    kind: kind,
  );

  /// The time left at the pace so far, once a few pieces are written. Null
  /// before that: two points make no pace.
  Duration? remaining(DateTime now) {
    final t = total, since = countingSince;
    if (!running || t == null || since == null || done.length < 2) return null;
    final left = t - done.length;
    if (left <= 0) return Duration.zero;
    return now.difference(since) * left ~/ done.length;
  }

  /// "6 of 18 features · about 25 min left", or null before anything is counted.
  String? progress(String unit, DateTime now) {
    final t = total;
    if (t == null) return null;
    final left = remaining(now);
    final eta = left == null
        ? ''
        : left.inMinutes < 1
        ? ' · under a minute left'
        : ' · about ${left.inMinutes} min left';
    return '${done.length.clamp(0, t)} of $t $unit$eta';
  }
}

/// Read only git commands every code session may run without asking.
const readOnlyGit = ['ls-files', 'diff', 'log', 'show', 'rev-parse', 'status', 'grep'];

/// The allowed tool rules for git [commands], also with the rtk prefix: an
/// rtk hook turns `git diff` into `rtk git diff`, which `Bash(git diff:*)`
/// does not match, so every call asked. [args] go before the command.
List<String> gitTools(Iterable<String> commands, {String args = ''}) => [
  for (final c in commands) ...['Bash(git $args$c:*)', 'Bash(rtk git $args$c:*)'],
];

/// What a stream-json event says the session is doing, or null.
String? stepOf(Map<String, Object?> ev) {
  if (ev['type'] != 'assistant') return null;
  final content = (ev['message'] as Map?)?['content'];
  if (content is! List) return null;
  for (final c in content.reversed) {
    if (c is! Map || c['type'] != 'tool_use') continue;
    final input = (c['input'] as Map?) ?? const {};
    final name = '${c['name']}'.replaceFirst('mcp__deck__', '');
    return switch (name) {
      'set_map_feature' => 'Drew ${input['feature'] is Map ? (input['feature'] as Map)['title'] : input['id']}',
      'set_map_data' => 'Wrote data type ${input['name']}',
      'confirm_map_feature' => 'Confirmed ${input['id']}',
      'stamp_map' => 'Stamping the map',
      'set_map_architecture' => 'Wrote the architecture',
      'set_map_ui' => 'Wrote the UI analysis',
      'get_diff' => 'Reading the diff',
      'set_file_note' => 'Writing file notes',
      'set_hunk_note' => 'Writing hunk notes',
      'set_groups' => 'Ordering the chapters',
      'set_features' => 'Drawing the features',
      'set_checklist' => 'Writing the triage',
      'set_ticket_check' => 'Checking the ticket',
      'list_threads' => 'Reading the threads',
      'add_thread' => 'Writing a finding',
      'reply' => 'Answering a thread',
      'set_answer' => 'Writing an answer',
      'mark_fixed' => 'Marking a fix done',
      'Read' => 'Reading ${'${input['file_path']}'.split('/').last}',
      'Grep' => 'Searching the code for ${jsonEncode(input['pattern'])}',
      'Glob' => 'Looking for files named ${input['pattern']}',
      'Agent' => 'A helper is ${_lower('${input['description'] ?? 'working'}')}',
      'Bash' => _shell(input),
      'ToolSearch' => 'Looking up its tools',
      _ => name.replaceAll('_', ' '),
    };
  }
  return null;
}

String _lower(String s) => s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

/// A shell command in words: the description Claude gives it, else what
/// the command is for, never the command line itself.
String _shell(Map input) {
  final d = '${input['description'] ?? ''}'.trim();
  if (d.isNotEmpty) return d;
  final cmd = '${input['command'] ?? ''}'.replaceFirst(RegExp(r"^bash -c '"), '').trim();
  final m = RegExp(r'^git\s+(\S+)(?:\s+(\S+))?').firstMatch(cmd);
  if (m != null) {
    final where = m[2] != null && !m[2]!.startsWith('-') ? ' in ${m[2]}' : '';
    return switch (m[1]) {
      'ls-files' => 'Listing the files$where',
      'log' => 'Reading the history$where',
      'diff' => 'Reading what changed$where',
      'show' => 'Reading an older version$where',
      'grep' => 'Searching the code',
      _ => 'Asking git',
    };
  }
  return 'Running a command';
}
