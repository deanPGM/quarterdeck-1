import 'package:deck/core/updates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a higher version is newer, number by number', () {
    expect(isNewer('0.2.0', '0.1.0'), isTrue);
    expect(isNewer('1.10.0', '1.9.2'), isTrue);
    expect(isNewer('v2.0.0', '1.99.99'), isTrue);
    expect(isNewer('0.1.0', '0.1.0'), isFalse);
    expect(isNewer('0.1.0', '0.2.0'), isFalse);
  });

  test('a release is newer than its pre-release, not the other way', () {
    expect(isNewer('1.2.0', '1.2.0-beta.1'), isTrue);
    expect(isNewer('1.2.0-beta.1', '1.2.0'), isFalse);
    expect(isNewer('1.3.0-beta.1', '1.2.0'), isTrue);
  });

  test('a version that is not numbers is never newer', () {
    expect(isNewer('nightly', '0.1.0'), isFalse);
    expect(isNewer('0.2.0', 'dev'), isFalse);
  });

  test('a release reads the tag without its v, and skips drafts and pre-releases', () {
    final r = Release.fromJson({
      'tag_name': 'v0.2.0',
      'body': ' Faster board. \n',
      'html_url': 'https://github.com/acme/app/releases/tag/v0.2.0',
      'published_at': '2026-12-01T10:00:00Z',
    })!;
    expect(r.version, '0.2.0');
    expect(r.notes, 'Faster board.');
    expect(r.at, DateTime.utc(2026, 12, 1, 10));
    expect(Release.fromJson({'tag_name': 'v0.3.0', 'prerelease': true}), isNull);
    expect(Release.fromJson({'tag_name': 'v0.3.0', 'draft': true}), isNull);
    expect(Release.fromJson({}), isNull);
  });
}
