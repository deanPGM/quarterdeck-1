import 'dart:io';

/// "gitlab:group/project" or "github:owner/repo" from a folder's origin remote.
Future<String?> detectRepo(String dir) async {
  try {
    final r = await Process.run('git', ['-C', dir, 'remote', 'get-url', 'origin']);
    if (r.exitCode != 0) return null;
    final m = RegExp(r'(gitlab|github)\.com[:/](.+?)(?:\.git)?$').firstMatch((r.stdout as String).trim());
    return m == null ? null : '${m[1]}:${m[2]}';
  } on ProcessException {
    return null;
  }
}
