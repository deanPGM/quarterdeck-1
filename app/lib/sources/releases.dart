// The latest Quarterdeck release on GitHub. Public repo: no token, and the
// unauthenticated limit (60 calls an hour) is far above one check a day.
import 'dart:convert';
import 'dart:io';

import '../core/updates.dart';

const releasesRepo = 'paillardf/quarterdeck';

/// The latest release, or null when there is none yet. Throws on a network
/// or API error.
Future<Release?> latestRelease({HttpClient? client}) async {
  final http = client ?? HttpClient();
  http.connectionTimeout = const Duration(seconds: 10);
  try {
    final req = await http.getUrl(Uri.https('api.github.com', '/repos/$releasesRepo/releases/latest'));
    req.headers
      ..set(HttpHeaders.acceptHeader, 'application/vnd.github+json')
      ..set(HttpHeaders.userAgentHeader, 'Quarterdeck/$appVersion');
    final res = await req.close().timeout(const Duration(seconds: 20));
    final body = await res.transform(utf8.decoder).join();
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) throw HttpException('GitHub answered ${res.statusCode}');
    return Release.fromJson(jsonDecode(body) as Map<String, Object?>);
  } finally {
    if (client == null) http.close();
  }
}
