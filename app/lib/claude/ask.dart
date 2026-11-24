// One Claude call with no tools and no MCP servers: the input is untrusted
// text (Slack, mail, commands), and the answer needs nothing else. Saved in
// the run ledger like every session Deck starts.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../data/deck_home.dart';
import '../data/run_log.dart';
import '../sources/shell_env.dart';

/// Claude's answer to [prompt] about [input]. Throws with a short message
/// when Claude fails.
Future<String> askClaude(
  DeckHome home, {
  required String kind,
  String subject = '',
  required String prompt,
  required String input,
  required String model,
  Duration timeout = const Duration(minutes: 3),
}) async {
  final work = Directory(p.join(home.cache.path, 'worker'))..createSync(recursive: true);
  final ledger = RunLog(home);
  final at = DateTime.now();
  final watch = Stopwatch()..start();
  final id = runIdOf(at, kind, '${at.millisecond}${at.microsecond}');
  final w = RunWatch();
  final err = StringBuffer();
  int? code;
  String? error;
  try {
    final Process proc;
    try {
      proc = await Process.start(
        'claude',
        [
          '-p',
          prompt,
          '--model',
          model,
          '--output-format',
          'stream-json',
          '--verbose',
          '--tools',
          '',
          '--strict-mcp-config',
          '--disable-slash-commands',
          '--no-session-persistence',
        ],
        workingDirectory: work.path,
        environment: await shellEnvironment(),
        runInShell: Platform.isWindows,
      );
    } on ProcessException catch (e) {
      throw 'Could not start claude: ${e.message}. Is Claude Code installed?';
    }
    proc.stdin.write(input);
    await proc.stdin.close();
    final raw = ledger.on ? ledger.openLog(id) : null;
    final out = proc.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
      raw?.writeln(line);
      try {
        w.add(jsonDecode(line) as Map<String, Object?>);
      } on FormatException {
        // Ignore non JSON lines.
      }
    }).asFuture<void>();
    final errDone = proc.stderr.transform(utf8.decoder).listen((s) {
      err.write(s);
      raw?.write('[stderr] $s');
    }).asFuture<void>();
    code = await proc.exitCode.timeout(
      timeout,
      onTimeout: () {
        proc.kill();
        return -1;
      },
    );
    await out;
    await errDone.catchError((_) {});
    await raw?.close();
    if (code == -1) throw 'Timed out after ${timeout.inMinutes} minutes.';
    final r = w.result;
    if (r == null) throw err.toString().trim().split('\n').first;
    if (code != 0 || r['is_error'] == true) throw '${r['result']}'.split('\n').first;
    return '${r['result']}';
  } catch (e) {
    error = '$e';
    rethrow;
  } finally {
    final t = w.totals;
    await ledger.add(
      RunRecord(
        id: id,
        kind: kind,
        subject: subject,
        at: at,
        outcome: code == null && error != null
            ? RunOutcome.noClaude
            : code == -1
            ? RunOutcome.timeout
            : error != null
            ? RunOutcome.failed
            : RunOutcome.ok,
        model: model,
        dir: work.path,
        seconds: watch.elapsed.inSeconds,
        apiSeconds: t.apiSeconds,
        costUsd: t.cost,
        turns: t.turns,
        tokens: t.tokens,
        exitCode: code,
        error: error,
        stderrTail: tailOf('$err'),
      ),
    );
  }
}
