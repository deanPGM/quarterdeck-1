// Runs one background Claude session over a batch of tasks. The session talks
// back to the app through the Deck MCP server; this class only starts it and
// reads the final result line (time, cost, errors).
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../core/models/claude_run.dart';
import '../data/deck_home.dart';
import '../data/run_log.dart';
import '../sources/shell_env.dart';
import 'tasks.dart';

/// Only tool search built in: no shell, no files. Tool search keeps the
/// connector tool list small (see SPIKE.md). Also used to read a run again.
const workerFlags = ['--disable-slash-commands', '--tools', 'ToolSearch', '--permission-mode', 'default'];

/// [run] goes in the MCP URL, so the session only sees its own tasks.
/// [allowed]: your allowed tool rules. [check] says which tasks failed.
Future<ClaudeRun> runClaude({
  required List<TaskSpec> specs,
  required String run,
  required int mcpPort,
  required String model,
  required DeckHome home,
  List<String> allowed = const [],
  Future<String?> Function(ClaudeRun run)? check,
}) {
  final work = Directory('${home.cache.path}/worker')..createSync(recursive: true);
  final providers = [for (final s in specs) s.task.id.split('-').first];
  return runSession(
    home: home,
    kind: 'worker',
    subject: providers.join(','),
    prompt: 'Call deck_tasks and do every task. Then stop.',
    providers: providers,
    model: model,
    dir: work.path,
    mcpUrl: 'http://127.0.0.1:$mcpPort/mcp?run=$run',
    flags: workerFlags,
    tools: {'mcp__deck__deck_tasks', 'mcp__deck__deck_submit', for (final s in specs) ...s.tools, ...allowed},
    timeout: const Duration(minutes: 5),
    check: check,
  );
}

/// Added to every session's prompt, so the problems it hits reach the
/// deck-insights report instead of dying in its transcript.
const reportNote =
    'If something in Deck gets in your way (a Deck tool fails or returns wrong data, the instructions are unclear so you '
    'have to guess, you lack a tool or a permission), call deck_report_issue once for that problem, then carry on.';

/// One headless Claude session in [dir], tied to the Deck MCP at [mcpUrl].
/// [tools] run without asking; anything else asks in Deck. Every run lands
/// in the run ledger as [kind] for [subject] (see RunLog).
Future<ClaudeRun> runSession({
  required DeckHome home,
  required String kind,
  String subject = '',
  required String prompt,
  required List<String> providers,
  required String model,
  required String dir,
  required String mcpUrl,
  required List<String> flags,
  required Set<String> tools,
  required Duration timeout,
  void Function(Map<String, Object?> event)? onEvent,

  /// Completes when the user stops the session: it is killed, and what it
  /// already wrote through the tools stays.
  Future<void>? stop,

  /// Carries on this session instead of starting one: what it read is still
  /// in its context. It must have run in [dir].
  String? resume,

  /// Run once the session ended: an error here (tasks it never sent) fails
  /// a run that ended well, in the ledger too.
  Future<String?> Function(ClaudeRun run)? check,
}) async {
  final at = DateTime.now();
  final watch = Stopwatch()..start();
  final session = resume ?? newSessionId();
  final ledger = RunLog(home);
  final collect = ledger.on;
  final id = runIdOf(at, kind, session.substring(0, 8));
  // Claude's cost and API time add up over --resume: keep this run's share.
  final before = resume == null || !collect ? (cost: 0.0, apiSeconds: 0) : await ledger.spentBy(session);
  RunRecord record(RunOutcome outcome, {String? error, int? code, RunWatch? w, String stderr = ''}) {
    final t = w?.totals;
    return RunRecord(
      id: id,
      kind: kind,
      subject: subject,
      at: at,
      outcome: outcome,
      model: model,
      dir: dir,
      sessionId: session,
      resumed: resume != null,
      seconds: watch.elapsed.inSeconds,
      apiSeconds: max(0, (t?.apiSeconds ?? 0) - before.apiSeconds),
      costUsd: max(0.0, (t?.cost ?? 0) - before.cost),
      turns: t?.turns ?? 0,
      tokens: t?.tokens ?? const {},
      exitCode: code,
      error: error,
      denials: t?.denials ?? const [],
      toolCalls: w?.toolCalls ?? const {},
      toolErrors: w?.toolErrors ?? const {},
      mcpFailed: w?.mcpFailed ?? const [],
      stderrTail: tailOf(stderr),
    );
  }

  final Process proc;
  try {
    proc = await Process.start(
      'claude',
      [
        '-p', collect ? '$prompt\n\n$reportNote' : prompt,
        '--model', model,
        '--output-format', 'stream-json', '--verbose',
        if (resume != null) ...['--resume', resume] else ...['--session-id', session],
        ...flags,
        '--mcp-config',
        jsonEncode({
          'mcpServers': {
            // The ledger id ties what the session reports to its run; without
            // it the session gets no deck_report_issue.
            'deck': {'type': 'http', 'url': collect ? '$mcpUrl${mcpUrl.contains('?') ? '&' : '?'}ledger=$id' : mcpUrl},
          },
        }),
        '--allowedTools', {...tools, if (collect) 'mcp__deck__deck_report_issue'}.join(','),
        // flags always set --permission-mode: the user's own default must
        // not decide for Deck. Workers use default, code sessions auto.
        '--permission-prompt-tool', 'mcp__deck__deck_permission',
      ],
      workingDirectory: dir,
      // The full environment, minus a parent Claude session's markers.
      environment: await shellEnvironment(),
      includeParentEnvironment: false,
      runInShell: Platform.isWindows,
    );
  } on ProcessException catch (e) {
    final error = 'Could not start claude: ${e.message}. Is Claude Code installed?';
    await ledger.add(record(RunOutcome.noClaude, error: error));
    return ClaudeRun(at: at, providers: providers, seconds: 0, error: error);
  }
  await proc.stdin.close();
  final raw = collect ? ledger.openLog(id) : null;
  final w = RunWatch();
  final err = StringBuffer();
  final out = proc.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
    raw?.writeln(line);
    try {
      final ev = jsonDecode(line) as Map<String, Object?>;
      w.add(ev);
      onEvent?.call(ev);
    } on FormatException {
      // Ignore non JSON lines.
    }
  }).asFuture<void>();
  // Without Deck's MCP server the session cannot ask or submit, and claude
  // then hangs until the timeout: stop it at once.
  var unreachable = false;
  final errDone = proc.stderr.transform(utf8.decoder).listen((s) {
    err.write(s);
    raw?.write('[stderr] $s');
    if (!unreachable && s.contains('(passed via --permission-prompt-tool) not found')) {
      unreachable = true;
      proc.kill();
    }
  }).asFuture<void>();
  var stopped = false;
  stop?.then((_) {
    stopped = true;
    proc.kill();
  });
  final code = await proc.exitCode.timeout(
    timeout,
    onTimeout: () {
      proc.kill();
      return -1;
    },
  );
  await out;
  await errDone.catchError((_) {});
  await raw?.close();
  final result = w.result;
  final failed = code != 0 || result?['is_error'] == true;
  var error = stopped
      ? 'Stopped.'
      : unreachable
      ? "Deck's MCP server did not answer: Deck restarted, or the Mac was asleep."
      : failed
      ? (code == -1 ? 'Timed out after ${timeout.inMinutes} minutes.' : '${result?['result'] ?? err.toString().trim()}'.split('\n').first)
      : null;
  var run = ClaudeRun(
    at: at,
    providers: providers,
    seconds: watch.elapsed.inSeconds,
    sessionId: session,
    costUsd: max(0.0, w.totals.cost - before.cost),
    error: error,
  );
  // Always run: it also clears what the caller waits on. Its error counts
  // only when the session itself ended well.
  final checked = check == null ? null : await check(run);
  if (error == null && checked != null) {
    error = checked;
    run = ClaudeRun(at: at, providers: providers, seconds: run.seconds, sessionId: session, costUsd: run.costUsd, error: error);
  }
  final outcome = stopped
      ? RunOutcome.stopped
      : code == -1
      ? RunOutcome.timeout
      : error != null
      ? RunOutcome.failed
      : RunOutcome.ok;
  await ledger.add(record(outcome, error: error, code: code, w: w, stderr: err.toString()));
  return run;
}

/// A random session id (UUID v4), so Deck knows which transcript is this card's.
String newSessionId() {
  final r = Random.secure();
  final b = List.generate(16, (_) => r.nextInt(256));
  b[6] = b[6] & 0x0f | 0x40;
  b[8] = b[8] & 0x3f | 0x80;
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
}
