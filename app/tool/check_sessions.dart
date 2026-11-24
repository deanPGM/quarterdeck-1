// Live check: your Claude Code sessions of the last [days] days, as Deck logs them.
// dart run tool/check_sessions.dart [days]
import 'dart:io';

import 'package:deck/sources/claude_sessions.dart';

Future<void> main(List<String> args) async {
  final days = int.tryParse(args.firstOrNull ?? '') ?? 1;
  final w = Stopwatch()..start();
  final all = await recentSessionDays(DateTime.now().subtract(Duration(days: days)));
  all.sort((a, b) => a.start.compareTo(b.start));
  for (final s in all) {
    stdout.writeln(
      '${s.start.toIso8601String().substring(0, 16)}–${s.end.toIso8601String().substring(11, 16)}  ${s.prompts.toString().padLeft(3)}  ${s.cwd.split('/').last.padRight(22)} ${s.title}',
    );
  }
  stdout.writeln('${all.length} session days in ${w.elapsedMilliseconds} ms');
}
