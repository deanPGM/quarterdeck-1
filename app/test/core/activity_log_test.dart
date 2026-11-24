import 'package:deck/core/activity_log.dart';
import 'package:deck/core/classify/todo.dart';
import 'package:deck/core/models/config.dart';
import 'package:deck/core/models/records.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 10, 15, 15);

MrRecord _mr(int iid, List<String> approvers, {MrRole role = MrRole.review}) => MrRecord(
  path: 'acme/backend',
  iid: iid,
  title: 'MR $iid',
  url: 'https://gitlab.com/acme/backend/-/merge_requests/$iid',
  author: 'jo',
  role: role,
  approvers: approvers,
  createdAt: _now,
  updatedAt: _now,
);

void main() {
  test('a card line names its project and keeps one id per card and kind', () {
    final c = classifyTodo({'title': 'Answer Mo', 'need': 'n', 'source': 'slack', 'from': '#vpn-team'}, _now).copyWith(key: 'todo:1');
    final a = cardActivity(
      c,
      'done',
      const [
        ProjectConfig(id: 'vpn', name: 'VPN iOS', channels: ['#vpn-team']),
      ],
      _now,
      detail: 'You replied',
    );
    expect(a.id, 'done:todo:1');
    expect(a.project, 'VPN iOS');
    expect(a.source, 'slack');
    expect(a.detail, 'You replied');
    expect(a.url, isNull);
  });

  test('only meetings you went to that are over are logged, at their start', () {
    DateTime at(int m) => _now.add(Duration(minutes: m));
    final got = meetingsAttended([
      EventRecord(id: 'a', title: 'Daily', start: at(-30), end: at(-15), going: true, attendees: 6),
      EventRecord(id: 'b', title: 'Declined', start: at(-60), end: at(-30)),
      EventRecord(id: 'c', title: 'Later', start: at(10), end: at(40), going: true),
    ], _now);
    expect(got.single.title, 'Daily');
    expect(got.single.at, at(-30));
    expect(got.single.detail, '15 min, 6 people');
  });

  test('approvals are logged only when new since the last fetch', () {
    final records = [
      _mr(1, ['sam']),
      _mr(2, ['sam']),
      _mr(3, ['jo']),
      _mr(4, ['sam'], role: MrRole.mine),
    ];
    expect(newApprovals(records, 'sam', null, _now), isEmpty);
    final got = newApprovals(records, 'sam', {'acme/backend!1'}, _now);
    expect(got.map((a) => a.ref), ['backend!2']);
  });
}
