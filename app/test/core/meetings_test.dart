import 'package:deck/core/meetings.dart';
import 'package:deck/core/models/records.dart';
import 'package:deck/core/models/snapshot.dart';
import 'package:deck/ui/board/meeting_strip.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 10, 15, 9, 30);

EventRecord _e(String id, int startMin, {int length = 30, bool going = true, String? join}) => EventRecord(
  id: id,
  title: id,
  start: _now.add(Duration(minutes: startMin)),
  end: _now.add(Duration(minutes: startMin + length)),
  going: going,
  join: join,
);

void main() {
  test('only accepted meetings that have not started ring, unless silenced', () {
    final events = [_e('live', -5), _e('soon', 20), _e('maybe', 40, going: false), _e('quiet', 60)];
    final rings = alarmsFor(events, {'calendar:quiet': const Triage(silent: true)}, _now);
    expect(rings.map((e) => e.id), ['soon']);
  });

  test('the calendar is checked 10 minutes before each alarm still to come', () {
    final events = [_e('soon', 5), _e('later', 30), _e('maybe', 60, going: false), _e('quiet', 90), _e('twin', 30)];
    final checks = checksFor(events, {'calendar:quiet': const Triage(silent: true)}, _now, const Duration(minutes: 2));
    expect(checks.map((t) => t.difference(_now).inMinutes), [18, 48]);
  });

  test('meetings that ended leave the strip', () {
    expect(upcoming([_e('done', -40), _e('live', -5), _e('next', 20)], _now).map((e) => e.id), ['live', 'next']);
  });

  test('only https join links open', () {
    expect(joinUri(_e('a', 0, join: 'https://meet.google.com/abc-defg-hij')), Uri.parse('https://meet.google.com/abc-defg-hij'));
    expect(joinUri(_e('b', 0, join: 'file:///etc/passwd')), isNull);
    expect(joinUri(_e('c', 0, join: 'zoommtg://zoom.us/join?confno=1')), isNull);
    expect(joinUri(_e('d', 0)), isNull);
  });

  test('times show in local time', () {
    final utc = DateTime.utc(2026, 10, 15, 12);
    final l = utc.toLocal();
    expect(clockTime(utc), '${l.hour}:00');
  });

  test('alarm lead defaults to 2 minutes', () {
    expect(alarmLead(null), const Duration(minutes: 2));
    expect(alarmLead('5'), const Duration(minutes: 5));
    expect(alarmLead('soon'), const Duration(minutes: 2));
  });

  test('start text', () {
    expect(startsIn(_e('a', -1), _now), 'Now');
    expect(startsIn(_e('b', 25), _now), 'in 25 min');
    expect(startsIn(_e('c', 130), _now), 'in 2 h 10');
    expect(startsIn(_e('d', 120), _now), 'in 2 h');
  });
}
