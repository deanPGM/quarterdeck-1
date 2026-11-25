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

  test('projectsOnly keeps a provider to the repos and boards set up in Deck', () {
    const ps = [
      ProjectConfig(id: 'ios', name: 'iOS', repo: 'gitlab:acme/ios', board: 'jira:AVPN'),
      ProjectConfig(id: 'web', name: 'Web', repo: 'github:acme/web', board: 'gitlab:acme/tasks'),
      ProjectConfig(id: 'api', name: 'API', repo: 'gitlab:acme/ios'),
    ];
    const on = ProviderConfig(projectsOnly: true);
    expect(projectScope('gitlab', const ProviderConfig(), ps), isNull);
    expect(projectScope('gitlab', on, ps), ['acme/ios', 'acme/tasks']);
    expect(projectScope('github', on, ps), ['acme/web']);
    expect(projectScope('jira', on, ps), ['AVPN']);
    expect(projectScope('jira', on, const []), isEmpty);
  });
}
