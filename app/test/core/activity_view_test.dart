import 'package:deck/core/activity_view.dart';
import 'package:deck/core/models/activity.dart';
import 'package:deck/core/models/config.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _a(DateTime at, String kind) => Activity(at: at, kind: kind, title: kind);

void main() {
  final thu = DateTime(2026, 10, 15, 9, 30);

  test('bounds: week starts on Monday, month and year are whole', () {
    expect(bounds(Period.day, thu), (DateTime(2026, 10, 15), DateTime(2026, 10, 15)));
    expect(bounds(Period.week, thu), (DateTime(2026, 10, 12), DateTime(2026, 10, 18)));
    expect(bounds(Period.week, DateTime(2026, 10, 12)), (DateTime(2026, 10, 12), DateTime(2026, 10, 18)));
    expect(bounds(Period.week, DateTime(2026, 10, 18)), (DateTime(2026, 10, 12), DateTime(2026, 10, 18)));
    expect(bounds(Period.month, DateTime(2026, 2, 10)), (DateTime(2026, 2), DateTime(2026, 2, 28)));
    expect(bounds(Period.year, thu), (DateTime(2026), DateTime(2026, 12, 31)));
  });

  test('shift crosses month and year ends, and DST', () {
    expect(shift(Period.day, DateTime(2026, 10, 31), 1), DateTime(2026, 11, 1));
    expect(shift(Period.week, DateTime(2026, 10, 19), -1), DateTime(2026, 10, 12));
    expect(shift(Period.month, DateTime(2026, 12), 1), DateTime(2027));
    expect(shift(Period.year, DateTime(2026), -1), DateTime(2025));
    // Summer time ends on 2026-10-25 in Europe: still midnight the next day.
    expect(shift(Period.day, DateTime(2026, 10, 25), 1), DateTime(2026, 10, 26));
  });

  test('labels', () {
    expect(dayLabel(thu, thu), 'Today, Thursday 15 October');
    expect(dayLabel(DateTime(2026, 10, 14), thu), 'Yesterday, Wednesday 14 October');
    expect(dayLabel(DateTime(2025, 10, 14), thu), 'Tuesday 14 October 2025');
    expect(periodLabel(Period.week, thu, thu), '12 Oct to 18 Oct 2026');
    expect(periodLabel(Period.month, thu, thu), 'October 2026');
  });

  test('groups newest day first, lines in time order', () {
    final lines = [_a(DateTime(2026, 10, 14, 15), 'merged'), _a(DateTime(2026, 10, 15, 9), 'session'), _a(DateTime(2026, 10, 14, 9), 'meeting')];
    final g = groupActivity(lines, Period.week);
    expect(g.map((x) => x.$1), [DateTime(2026, 10, 15), DateTime(2026, 10, 14)]);
    expect(g[1].$2.map((e) => e.kind), ['meeting', 'merged']);
    expect(groupActivity(lines, Period.year).single.$1, DateTime(2026, 10));
  });

  test('counts kinds', () {
    final lines = [_a(thu, 'session'), _a(thu, 'merged'), _a(thu, 'session')];
    expect(countKinds(lines), {'session': 2, 'merged': 1});
  });

  test('text for the summary keeps project, ref and detail, and says what I did', () {
    final e = Activity(at: DateTime(2026, 10, 14, 14, 2), kind: 'merged', title: 'Fix', project: 'VPN', ref: 'vpn!3', detail: 'Merged');
    expect(activityText([e]), 'WORK\n2026-10-14 14:02 my MR merged [VPN] Fix (vpn!3): Merged');
  });

  test('text for the summary: archived mail dropped, personal and waiting apart', () {
    const projects = [ProjectConfig(id: 'apple', name: 'Acme VPN', dir: '~/projects/acme/vpn-ios')];
    Activity s(String project) => Activity(at: thu, kind: 'session', title: project, source: 'claude', project: project);
    final lines = [
      Activity(at: thu, kind: 'done', title: 'App passed review', source: 'mail', detail: 'Archived in Gmail'),
      Activity(at: thu, kind: 'done', title: 'Answer Jordan', source: 'mail', detail: 'You replied'),
      s('Acme VPN'),
      s('acme'),
      s('ha'),
    ];
    expect(
      activityText(lines, projects: projects, waiting: ['Fix login (apple!9): waits on Jordan']),
      'WORK\n'
      '2026-10-15 09:30 closed on my board Answer Jordan: You replied\n'
      '2026-10-15 09:30 I worked with Claude on [Acme VPN] Acme VPN\n'
      '2026-10-15 09:30 I worked with Claude on [acme] acme\n'
      '\n'
      'PERSONAL\n'
      '2026-10-15 09:30 I worked with Claude on [ha] ha\n'
      '\n'
      'WAITING ON OTHERS\n'
      'Fix login (apple!9): waits on Jordan',
    );
  });
}
