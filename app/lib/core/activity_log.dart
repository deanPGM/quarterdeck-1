// Turns what Deck sees into activity log lines. Pure, so it is easy to test.
import 'models/activity.dart';
import 'models/card.dart';
import 'models/config.dart';
import 'models/records.dart';
import 'projects.dart';

/// A line about card [c]: done, todo or merged. One per card and kind.
Activity cardActivity(DeckCard c, String kind, List<ProjectConfig> projects, DateTime at, {String? detail}) {
  final ids = projectsOf(c, projects);
  return Activity(
    at: at,
    kind: kind,
    title: c.title,
    id: '$kind:${c.key}',
    source: c.source ?? c.provider,
    ref: c.ref,
    url: c.url.isEmpty ? null : c.url,
    project: projects.where((p) => ids.contains(p.id)).map((p) => p.name).firstOrNull,
    detail: detail,
  );
}

/// Meetings you went to that are over, from the last calendar fetch.
List<Activity> meetingsAttended(List<EventRecord> events, DateTime now) => [
  for (final e in events)
    if (e.going && !e.end.isAfter(now))
      Activity(
        at: e.start,
        kind: 'meeting',
        title: e.title,
        id: 'meeting:${e.id}:${e.start.toIso8601String().substring(0, 10)}',
        source: 'calendar',
        detail: '${e.end.difference(e.start).inMinutes} min, ${e.attendees} people',
      ),
];

/// Review MRs you approved that were not approved by you at the last fetch.
/// [before] is null on the first fetch after start: nothing is logged then,
/// so old approvals do not show up as today.
List<Activity> newApprovals(List<MrRecord> records, String me, Set<String>? before, DateTime now) => [
  if (before != null)
    for (final m in records)
      if (m.role == MrRole.review && m.approvers.contains(me) && !before.contains('${m.path}!${m.iid}'))
        Activity(
          at: now,
          kind: 'approved',
          title: m.title,
          id: 'approved:${m.path}!${m.iid}',
          source: 'gitlab',
          ref: '${m.path.split('/').last}!${m.iid}',
          url: m.url,
        ),
];

Set<String> approvedBy(List<MrRecord> records, String me) => {
  for (final m in records)
    if (m.approvers.contains(me)) '${m.path}!${m.iid}',
};
