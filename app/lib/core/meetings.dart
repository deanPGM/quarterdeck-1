// Rules for calendar meetings: which ones ring, and which link joins them.
import 'models/records.dart';
import 'models/snapshot.dart';

String meetingKey(EventRecord e) => 'calendar:${e.id}';

/// The join link, only when it is a plain https link. It comes from calendar
/// text read by Claude, so other schemes are never opened.
Uri? joinUri(EventRecord e) {
  final u = Uri.tryParse(e.join ?? '');
  return u != null && u.scheme == 'https' && u.host.isNotEmpty ? u : null;
}

/// Meetings not over yet, by start time.
List<EventRecord> upcoming(List<EventRecord> events, DateTime now) => [
  for (final e in events)
    if (e.end.isAfter(now)) e,
];

/// Meetings that ring: you are going, it has not started, and you did not
/// silence it.
List<EventRecord> alarmsFor(List<EventRecord> events, Map<String, Triage> triage, DateTime now) => [
  for (final e in events)
    if (e.going && e.start.isAfter(now) && !(triage[meetingKey(e)]?.silent ?? false)) e,
];

/// "9:05", in local time. Calendar times arrive in UTC.
String clockTime(DateTime d) {
  final l = d.toLocal();
  return '${l.hour}:${l.minute.toString().padLeft(2, '0')}';
}

/// Minutes before the start, from the Calendar option. 2 when unset.
Duration alarmLead(String? option) => Duration(minutes: int.tryParse(option ?? '') ?? 2);

/// How long before an alarm the calendar is fetched again, so a meeting moved
/// or accepted since the last refresh rings on time.
const checkBefore = Duration(minutes: 10);

/// When to fetch the calendar again: before each alarm still to come. Not
/// only meetings you accepted, since you may accept one before it starts.
List<DateTime> checksFor(List<EventRecord> events, Map<String, Triage> triage, DateTime now, Duration lead) => {
  for (final e in events)
    if (!(triage[meetingKey(e)]?.silent ?? false)) e.start.subtract(lead + checkBefore),
}.where((t) => t.isAfter(now)).toList()..sort();
