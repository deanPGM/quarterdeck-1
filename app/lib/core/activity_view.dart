// Pure logic for the activity view: the period on screen, its label, and the
// log grouped by day or month. No widgets, so it is easy to test.
import 'package:path/path.dart' as p;

import 'models/activity.dart';
import 'models/config.dart';

enum Period { day, week, month, year }

const _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

/// First and last day of the [period] that holds [day]. Weeks start on Monday.
(DateTime, DateTime) bounds(Period period, DateTime day) => switch (period) {
  Period.day => (DateTime(day.year, day.month, day.day), DateTime(day.year, day.month, day.day)),
  Period.week => (DateTime(day.year, day.month, day.day - day.weekday + 1), DateTime(day.year, day.month, day.day - day.weekday + 7)),
  Period.month => (DateTime(day.year, day.month), DateTime(day.year, day.month + 1, 0)),
  Period.year => (DateTime(day.year), DateTime(day.year, 12, 31)),
};

/// The day [n] periods after [day] (before, when negative).
DateTime shift(Period period, DateTime day, int n) => switch (period) {
  Period.day => DateTime(day.year, day.month, day.day + n),
  Period.week => DateTime(day.year, day.month, day.day + 7 * n),
  Period.month => DateTime(day.year, day.month + n),
  Period.year => DateTime(day.year + n),
};

String dayLabel(DateTime d, DateTime today) {
  final days = DateTime(today.year, today.month, today.day).difference(DateTime(d.year, d.month, d.day)).inHours ~/ 24;
  final name = '${_days[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}';
  return switch (days) {
    0 => 'Today, $name',
    1 => 'Yesterday, $name',
    _ => d.year == today.year ? name : '$name ${d.year}',
  };
}

String monthLabel(DateTime d) => '${_months[d.month - 1]} ${d.year}';

String periodLabel(Period period, DateTime day, DateTime today) {
  final (from, to) = bounds(period, day);
  return switch (period) {
    Period.day => dayLabel(from, today),
    Period.week => '${from.day} ${_months[from.month - 1].substring(0, 3)} to ${to.day} ${_months[to.month - 1].substring(0, 3)} ${to.year}',
    Period.month => monthLabel(from),
    Period.year => '${from.year}',
  };
}

/// Lines grouped by day (by month for a year), newest group first, lines in
/// time order inside a group.
List<(DateTime, List<Activity>)> groupActivity(List<Activity> lines, Period period) {
  final groups = <DateTime, List<Activity>>{};
  for (final e in lines) {
    final k = period == Period.year ? DateTime(e.at.year, e.at.month) : DateTime(e.at.year, e.at.month, e.at.day);
    groups.putIfAbsent(k, () => []).add(e);
  }
  return [for (final k in groups.keys.toList()..sort((a, b) => b.compareTo(a))) (k, groups[k]!..sort((a, b) => a.at.compareTo(b.at)))];
}

/// How many lines of each kind.
Map<String, int> countKinds(List<Activity> lines) {
  final n = <String, int>{};
  for (final e in lines) {
    n[e.kind] = (n[e.kind] ?? 0) + 1;
  }
  return n;
}

/// Claude sessions and notes in a folder that is not a Deck project are
/// personal. A folder that holds projects (~/projects/acme) is work, and so is
/// everything from the work accounts (GitLab, mail, calendar...).
bool personal(Activity e, List<ProjectConfig> projects) {
  if (e.source != 'claude' || e.project == null) return false;
  final work = {
    for (final x in projects) ...[x.name, if (x.dir != null) p.basename(p.dirname(x.dir!))],
  };
  return !work.contains(e.project);
}

/// What the user did in each kind of line, so Claude does not claim the
/// content of a mail or a todo as their work.
const _did = {
  'merged': 'my MR merged',
  'approved': 'I approved',
  'meeting': 'I attended',
  'session': 'I worked with Claude on',
  'note': 'I did',
  'todo': 'new todo for me, not done yet',
  'done': 'closed on my board',
};

/// Mail archived is inbox cleanup: its subject is someone else's news.
bool _cleanup(Activity e) => e.kind == 'done' && e.source == 'mail' && (e.detail?.startsWith('Archived') ?? false);

String _line(Activity e) =>
    [
      e.at.toIso8601String().substring(0, 16).replaceFirst('T', ' '),
      _did[e.kind] ?? e.kind,
      if (e.project != null) '[${e.project}]',
      e.title,
      if (e.ref != null) '(${e.ref})',
    ].join(' ') +
    (e.detail == null ? '' : ': ${e.detail}');

/// The input of the Claude summary: the log split into work and personal, then
/// [waiting], the cards that wait on someone else.
String activityText(List<Activity> lines, {List<ProjectConfig> projects = const [], List<String> waiting = const []}) {
  final kept = lines.where((e) => !_cleanup(e));
  final perso = kept.where((e) => personal(e, projects)).map(_line).toList();
  return [
    'WORK',
    ...kept.where((e) => !personal(e, projects)).map(_line),
    if (perso.isNotEmpty) ...['', 'PERSONAL', ...perso],
    if (waiting.isNotEmpty) ...['', 'WAITING ON OTHERS', ...waiting],
  ].join('\n');
}
