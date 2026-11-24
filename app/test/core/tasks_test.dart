import 'package:deck/claude/tasks.dart';
import 'package:deck/core/models/config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 3);
  const projects = [
    ProjectConfig(id: 'vpn', name: 'Acme VPN', aliases: ['com.acme.vpn', 'AVPN']),
    ProjectConfig(id: 'web', name: 'Website'),
  ];

  for (final provider in ['slack', 'mail']) {
    test('$provider asks Claude to tag each record with a project', () {
      final t = taskFor(provider, const ProviderConfig(), null, now, projects: projects)!.task;
      expect(t.input['projects'], [
        {
          'id': 'vpn',
          'name': 'Acme VPN',
          'aliases': ['com.acme.vpn', 'AVPN'],
        },
        {'id': 'web', 'name': 'Website'},
      ]);
      expect(t.instructions, contains('project (the id of the entry in input.projects'));
    });

    test('$provider without projects says nothing about them', () {
      final t = taskFor(provider, const ProviderConfig(), null, now)!.task;
      expect(t.input.containsKey('projects'), isFalse);
      expect(t.instructions, isNot(contains('input.projects')));
    });
  }

  test('slack searches project channels for team asks, and Jira for an existing ticket', () {
    const ps = [
      ProjectConfig(id: 'vpn', name: 'VPN', board: 'jira:OM', channels: ['#vpn-apps', 'abp-vpn']),
      ProjectConfig(id: 'ios', name: 'iOS', channels: ['#vpn-apps']),
    ];
    final s = taskFor('slack', const ProviderConfig(), null, now, projects: ps, cards: const [(key: 'jira:OM-7', ref: 'OM-7', title: 'Purchase fails')]);
    final t = s!.task;
    expect(t.input['queries'], ['to:me after:2026-10-30', 'in:#vpn-apps after:2026-10-30', 'in:#abp-vpn after:2026-10-30']);
    expect(t.input['cards'], [
      {'ref': 'OM-7', 'title': 'Purchase fails'},
    ]);
    expect((t.input['projects']! as List).first, containsPair('board', 'jira:OM'));
    expect(t.instructions, contains('team (true'));
    expect(t.instructions, contains('searchJiraIssuesUsingJql'));
    expect(s.tools, contains('mcp__claude_ai_Atlassian__searchJiraIssuesUsingJql'));
    // No channels: only asks aimed at you, no Jira search.
    final plain = taskFor('slack', const ProviderConfig(), null, now)!;
    expect(plain.task.instructions, isNot(contains('team (true')));
    expect(plain.tools, hasLength(2));
  });

  test('slack with a workspace leaves url to Deck, which builds it from the id', () {
    final t = taskFor('slack', const ProviderConfig(options: {'workspace': 'https://acme.slack.com/'}), null, now)!.task;
    expect(t.input['workspace'], 'acme');
    expect(t.instructions, isNot(contains('url (')));
    final r = withSlackUrls([
      {'id': 'D1/1795178168.800749', 'title': 'Hi'},
      {'id': 'C1/1.2', 'url': 'https://kept'},
    ], t.input);
    expect(r.first['url'], 'https://acme.slack.com/archives/D1/p1795178168800749');
    expect(r.last['url'], 'https://kept');
    expect(taskFor('slack', const ProviderConfig(), null, now)!.task.instructions, contains('url (the permalink'));
  });

  group('recordProblems', () {
    const good = {'id': 'a1', 'url': 'https://x', 'at': '2026-10-30T18:29:26Z', 'title': 'Workload review'};

    test('accepts complete mail records', () {
      expect(recordProblems('mail', [good]), isNull);
    });

    test('refuses mail records without at or url, naming them', () {
      final p = recordProblems('mail', [
        good,
        {'id': 'b2', 'title': 'Workload review', 'kind': 'fyi'},
      ]);
      expect(p, contains('1 of 2 records'));
      expect(p, contains('record 1 (id b2): no url, at'));
    });

    test('names the missing end of a calendar event', () {
      final p = recordProblems('calendar', [
        {'id': 'e1', 'title': 'Guild', 'start': '2026-11-23T14:00:00+01:00'},
      ]);
      expect(p, contains('record 0 (id e1): no end'));
    });

    test('does not check notes or archive runs', () {
      expect(recordProblems('notes', [{}]), isNull);
      expect(recordProblems(archiveProvider, [{}]), isNull);
    });
  });
}
