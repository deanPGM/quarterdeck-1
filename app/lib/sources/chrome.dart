// Opens links in a chosen Chrome profile. Chrome lists its profiles in its
// "Local State" file; launching it with --profile-directory sends the link to
// that profile's window. macOS and Linux only; elsewhere links use the default
// browser.
import 'dart:convert';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

typedef ChromeProfile = ({String dir, String name});

String? get _localState {
  final home = Platform.environment['HOME'];
  if (home == null) return null;
  if (Platform.isMacOS) return '$home/Library/Application Support/Google/Chrome/Local State';
  if (Platform.isLinux) return '$home/.config/google-chrome/Local State';
  return null;
}

/// The Chrome profiles on this machine: folder ("Profile 2") and the name you
/// gave it. Empty when Chrome is not installed.
List<ChromeProfile> chromeProfiles() {
  final path = _localState;
  if (path == null) return const [];
  try {
    final cache = (jsonDecode(File(path).readAsStringSync()) as Map)['profile']['info_cache'] as Map;
    return [for (final MapEntry(:key, :value) in cache.entries) (dir: key as String, name: (value as Map)['name'] as String? ?? key)];
  } catch (_) {
    return const [];
  }
}

/// Opens [u] in Chrome [profile], or in the default browser when it is null
/// or no longer exists (Chrome would make a new empty profile).
Future<void> openLink(Uri u, [String? profile]) async {
  if (profile != null && chromeProfiles().any((p) => p.dir == profile)) {
    final (cmd, args) = Platform.isMacOS
        ? ('open', ['-na', 'Google Chrome', '--args', '--profile-directory=$profile', '$u'])
        : ('google-chrome', ['--profile-directory=$profile', '$u']);
    try {
      await Process.start(cmd, args, mode: ProcessStartMode.detached);
      return;
    } on ProcessException {
      // Not on PATH: fall back to the default browser.
    }
  }
  await launchUrl(u);
}
