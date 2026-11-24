// Which Quarterdeck this is, and whether a GitHub release is newer.

/// The version this build was made from. The release workflow sets it from
/// the tag (`--dart-define=DECK_VERSION=1.2.0`); a local build says 'dev' and
/// never looks for updates.
const appVersion = String.fromEnvironment('DECK_VERSION', defaultValue: 'dev');

bool get isDevBuild => appVersion == 'dev';

/// A published release, from the GitHub API.
class Release {
  const Release({required this.version, required this.notes, required this.url, this.at});

  /// "1.2.0", from tag "v1.2.0".
  final String version;

  /// The release notes, markdown.
  final String notes;

  /// Its page on GitHub.
  final String url;
  final DateTime? at;

  /// From `GET /repos/{owner}/{repo}/releases/latest`, or null when it is
  /// a draft, a pre-release or has no tag.
  static Release? fromJson(Map<String, Object?> j) {
    final tag = j['tag_name'];
    if (tag is! String || tag.isEmpty || j['draft'] == true || j['prerelease'] == true) return null;
    return Release(
      version: tag.replaceFirst(RegExp('^v'), ''),
      notes: (j['body'] as String? ?? '').trim(),
      url: j['html_url'] as String? ?? '',
      at: DateTime.tryParse(j['published_at'] as String? ?? ''),
    );
  }
}

/// [candidate] is a later version than [current]: "1.10.0" after "1.9.2",
/// "1.2.0" after "1.2.0-beta.1". A leading "v" is ignored. A version that is
/// not numbers is never newer, so a bad tag offers no update.
bool isNewer(String candidate, String current) {
  final a = _parse(candidate), b = _parse(current);
  if (a == null || b == null) return false;
  for (var i = 0; i < 3; i++) {
    if (a.$1[i] != b.$1[i]) return a.$1[i] > b.$1[i];
  }
  // Same numbers: a release is newer than its pre-release.
  return a.$2 == null && b.$2 != null;
}

(List<int>, String?)? _parse(String v) {
  final m = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z.-]+))?$').firstMatch(v.trim());
  if (m == null) return null;
  return ([int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!)], m[4]);
}
