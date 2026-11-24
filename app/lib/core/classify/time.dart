/// Whole days between [at] and [now], never negative.
int daysSince(DateTime? at, DateTime now) {
  if (at == null) return 0;
  final d = now.difference(at).inDays;
  return d < 0 ? 0 : d;
}

String plural(int n, String one, [String? many]) => '$n ${n == 1 ? one : many ?? '${one}s'}';

/// How long ago, the one wording of the app: "5 min ago", "3 h ago",
/// "yesterday", "4 days ago", "2 months ago".
String ago(DateTime? at, DateTime now) {
  if (at == null) return '';
  final m = now.difference(at).inMinutes;
  if (m < 60) return '${m.clamp(1, 59)} min ago';
  if (m < 24 * 60) return '${m ~/ 60} h ago';
  final d = daysSince(at, now);
  if (d == 1) return 'yesterday';
  if (d < 60) return '$d days ago';
  return '${d ~/ 30} months ago';
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// "Nov 3".
String shortDate(DateTime at) => '${_months[at.month - 1]} ${at.day}';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// "Tue 3 Nov".
String dayDate(DateTime at) => '${_weekdays[at.weekday - 1]} ${at.day} ${_months[at.month - 1]}';
