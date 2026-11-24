// One click update: runs the install script a first install uses, in app-only
// mode (no setup questions) and pinned to the version offered. The script
// downloads and checks the build, quits this app (QUARTERDECK_PID), replaces
// it and opens the new one. Its output goes to cache/update.log.
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../sources/releases.dart' show releasesRepo;
import '../state/settings.dart';
import '../state/updates.dart';

const _scripts = 'https://raw.githubusercontent.com/$releasesRepo/main';

/// Starts the update to [version] ("0.2.0") and completes with the script's
/// exit code. On success the script quits this app first, so a code that
/// comes back means it failed: [logOf] says why.
Future<int> runUpdate(String version, Directory cache) async {
  cache.createSync(recursive: true);
  final log = logOf(cache);
  final env = {'QUARTERDECK_APP_ONLY': '1', 'QUARTERDECK_VERSION': 'v$version', 'QUARTERDECK_PID': '$pid', 'QUARTERDECK_LOG': log};
  final Process proc;
  if (Platform.isWindows) {
    final quoted = log.replaceAll("'", "''");
    proc = await Process.start('powershell.exe', [
      '-NoProfile',
      '-ExecutionPolicy',
      'Bypass',
      '-WindowStyle',
      'Hidden',
      '-Command',
      "irm $_scripts/install.ps1 | iex *> '$quoted'",
    ], environment: env);
  } else {
    // Downloaded first, so a failed download is a failed exit code. Output
    // goes to the log, not to pipes this app holds: the script outlives it.
    proc = await Process.start('/bin/sh', [
      '-c',
      'exec > "\$QUARTERDECK_LOG" 2>&1 < /dev/null; f=\$(mktemp) && curl -fsSL "$_scripts/install.sh" -o "\$f" && sh "\$f"',
    ], environment: env);
  }
  return proc.exitCode;
}

String logOf(Directory cache) => p.join(cache.path, 'update.log');

/// The Update button: runs the script, and a failure shows in [updatesProvider].
Future<void> updateNow(WidgetRef ref) {
  final cache = ref.read(homeProvider).cache;
  return ref.read(updatesProvider.notifier).install((v) => runUpdate(v, cache), log: logOf(cache));
}
