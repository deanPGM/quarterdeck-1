import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/config.dart';
import 'package:deck/core/projects.dart';
import 'package:flutter_test/flutter_test.dart';

DeckCard _mr(String path) => DeckCard(
  key: 'gitlab:$path!1',
  provider: 'gitlab',
  lane: Lane.review,
  ref: '!1',
  url: 'https://gitlab.com/$path/-/merge_requests/1',
  title: 'Fix it',
  path: path,
  next: 'Review',
  bucket: Bucket.action,
  score: 1,
);

void main() {
  const projects = [
    ProjectConfig(id: 'ios', name: 'iOS', dir: '/w/ios', repo: 'gitlab:acme/ios', ide: 'xed'),
    ProjectConfig(id: 'api', name: 'API', dir: '/w/api', repo: 'gitlab:acme/api'),
  ];

  test('a card works in its project, with that project IDE', () {
    expect(workProject(_mr('acme/ios'), projects)?.ide, 'xed');
    expect(workProject(_mr('acme/api'), projects)?.ide, isNull);
    expect(projectDir(_mr('acme/api'), projects), '/w/api');
    expect(workProject(_mr('acme/web'), projects), isNull);
  });
}
