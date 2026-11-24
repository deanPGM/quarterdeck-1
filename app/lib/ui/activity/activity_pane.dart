// The Activity view: what you did in a day, week, month or year, from the
// activity log, with a summary Claude writes on demand (standup for a day,
// review for longer periods).
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sources/chrome.dart';

import '../../core/meetings.dart' show clockTime;
import '../../core/activity_view.dart';
import '../../core/models/activity.dart';
import '../../core/models/config.dart';
import '../../state/activity.dart';
import '../../state/board.dart';
import '../../state/settings.dart';
import '../board/board_model.dart';
import '../board/card_tile.dart' show accent;
import '../common.dart';
import '../parts.dart';
import '../theme.dart';

/// Label (one, many), icon and color per kind of line, in the order counts show.
const activityKinds = {
  'merged': ('merged', 'merged', Icons.call_merge_rounded, 'teal'),
  'approved': ('approved', 'approved', Icons.thumb_up_alt_outlined, 'purple'),
  'done': ('done', 'done', Icons.check_rounded, 'green'),
  'session': ('Claude session', 'Claude sessions', Icons.terminal_rounded, 'orange'),
  'meeting': ('meeting', 'meetings', Icons.event_outlined, 'blue'),
  'todo': ('todo added', 'todos added', Icons.add_task_rounded, 'indigo'),
  'note': ('note', 'notes', Icons.notes_rounded, 'graphite'),
};

(String, String, IconData, String) _kind(String k) => activityKinds[k] ?? (k, k, Icons.circle_outlined, 'graphite');

/// Counts per kind, known kinds first in a fixed order.
List<Widget> _counts(List<Activity> lines) {
  final n = countKinds(lines);
  return [
    for (final k in {...activityKinds.keys.where(n.containsKey), ...n.keys}) _KindCount(kind: k, n: n[k]!),
  ];
}

class ActivityPane extends ConsumerStatefulWidget {
  const ActivityPane({super.key, this.banners = const []});

  /// Alarm, meetings and permission banners, shown under the header.
  final List<Widget> banners;

  @override
  ConsumerState<ActivityPane> createState() => _ActivityPaneState();
}

class _ActivityPaneState extends ConsumerState<ActivityPane> {
  Period period = Period.day;
  DateTime day = clock.now();

  /// The period a summary is being written for, and the last error.
  (Period, DateTime)? writing;
  ((Period, DateTime), String)? error;

  /// Today's standup: the board's Waiting cards, to ask about at the daily.
  /// The board only knows now, so older days and longer periods get none.
  List<String> _waiting((Period, DateTime) key) {
    final now = clock.now();
    if (key.$1 != Period.day || !DateUtils.isSameDay(key.$2, now)) return const [];
    final board = ref.read(boardProvider).value ?? const BoardState();
    final cfg = ref.read(settingsProvider).value ?? const DeckConfig();
    return [
      for (final i in flowOf(buildItems(board.snapshots, board.triage, board.busy, cfg, now), now).waiting) '${i.card.title} (${i.card.ref}): ${i.card.next}',
    ];
  }

  Future<void> _write(List<Activity> lines, (Period, DateTime) key, String label) async {
    setState(() {
      writing = key;
      error = null;
    });
    try {
      await ref.read(activitySummaryProvider(key).notifier).write(lines, label, waiting: _waiting(key));
    } catch (e) {
      error = (key, '$e');
    }
    if (mounted) setState(() => writing = null);
  }

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final (from, to) = bounds(period, day);
    final key = (period, from);
    final async = ref.watch(activityProvider((from, to)));
    final lines = async.value ?? const <Activity>[];
    final label = periodLabel(period, day, now);
    final canNext = !shift(period, from, 1).isAfter(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: headPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activity', style: context.t.headlineSmall),
                    const SizedBox(height: 2),
                    Text('$label · ${lines.length} ${lines.length == 1 ? 'event' : 'events'}', style: context.t.bodySmall),
                  ],
                ),
              ),
              SegmentedButton<Period>(
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: const [
                  ButtonSegment(value: Period.day, label: Text('Day')),
                  ButtonSegment(value: Period.week, label: Text('Week')),
                  ButtonSegment(value: Period.month, label: Text('Month')),
                  ButtonSegment(value: Period.year, label: Text('Year')),
                ],
                selected: {period},
                onSelectionChanged: (s) => setState(() => period = s.first),
              ),
              const SizedBox(width: 12),
              IconButton(tooltip: 'Previous', onPressed: () => setState(() => day = shift(period, from, -1)), icon: const Icon(Icons.chevron_left_rounded)),
              TextButton(onPressed: () => setState(() => day = now), child: const Text('Today')),
              IconButton(
                tooltip: 'Next',
                onPressed: canNext ? () => setState(() => day = shift(period, from, 1)) : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
        ...widget.banners,
        if (lines.isNotEmpty)
          Padding(
            padding: stripPadding,
            child: Wrap(spacing: 16, runSpacing: 6, children: _counts(lines)),
          ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: lines.isEmpty
                    ? Center(child: Text(async.isLoading ? 'Loading…' : 'Nothing logged in this period.', style: context.t.bodySmall))
                    : ActivityList(
                        groups: groupActivity(lines, period),
                        byMonth: period == Period.year,
                        now: now,
                        onMonth: (m) => setState(() {
                          period = Period.month;
                          day = m;
                        }),
                      ),
              ),
              SizedBox(
                width: 380,
                child: SummaryPanel(
                  summary: ref.watch(activitySummaryProvider(key)).value,
                  lines: lines.length,
                  writing: writing == key,
                  error: error?.$1 == key ? error!.$2 : null,
                  standup: period == Period.day,
                  onWrite: lines.isEmpty || writing != null ? null : () => _write(lines, key, label),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KindCount extends StatelessWidget {
  const _KindCount({required this.kind, required this.n});

  final String kind;
  final int n;

  @override
  Widget build(BuildContext context) {
    final (one, many, icon, color) = _kind(kind);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: accent(context, color)),
        const SizedBox(width: 5),
        Text('$n ${n == 1 ? one : many}', style: context.t.bodySmall?.copyWith(color: context.c.label2)),
      ],
    );
  }
}

/// The log grouped by day, newest first. For a year: one row per month with
/// its counts, tap to open that month.
class ActivityList extends StatelessWidget {
  const ActivityList({super.key, required this.groups, required this.byMonth, required this.now, required this.onMonth});

  final List<(DateTime, List<Activity>)> groups;
  final bool byMonth;
  final DateTime now;
  final ValueChanged<DateTime> onMonth;

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: groups.length,
      itemBuilder: (_, n) {
        final (at, lines) = groups[n];
        if (byMonth) {
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onMonth(at),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(monthLabel(at), style: context.t.titleMedium),
                  const SizedBox(height: 6),
                  Wrap(spacing: 16, runSpacing: 6, children: _counts(lines)),
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, n == 0 ? 0 : 16, 12, 6),
              child: Text(dayLabel(at, now), style: context.t.titleMedium),
            ),
            for (final e in lines) _Line(e: e),
          ],
        );
      },
    ),
  );
}

class _Line extends ConsumerWidget {
  const _Line({required this.e});

  final Activity e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (_, _, icon, color) = _kind(e.kind);
    final sub = [?e.ref, ?e.project, ?e.detail].join(' · ');
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: e.url == null ? null : () => openLink(Uri.parse(e.url!), ref.read(settingsProvider).value?.actions.browserProfile),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(clockTime(e.at), style: context.t.bodySmall),
              ),
            ),
            AccentIcon(icon, accent(context, color), size: 20, circle: true),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (sub.isNotEmpty) Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.t.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({
    super.key,
    required this.summary,
    required this.lines,
    required this.writing,
    required this.error,
    required this.standup,
    required this.onWrite,
  });

  final ActivitySummary? summary;

  /// Lines in the log now, to tell when the summary is behind.
  final int lines;
  final bool writing, standup;
  final String? error;
  final VoidCallback? onWrite;

  @override
  Widget build(BuildContext context) {
    final c = context.c, s = summary;
    final behind = s == null ? 0 : lines - s.lines;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
      child: ContentCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(standup ? 'Standup' : 'Review', style: context.t.titleMedium)),
                if (s != null)
                  IconButton(
                    tooltip: 'Copy',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: s.text));
                      showToast(context, 'Copied');
                    },
                  ),
                const SizedBox(width: 4),
                if (s == null)
                  FilledButton(onPressed: writing ? null : onWrite, child: const Text('Write'))
                else
                  TextButton(onPressed: writing ? null : onWrite, child: const Text('Rewrite')),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              s == null
                  ? 'Claude writes it from this log, with no tools. About 1 cent.'
                  : 'Written ${DateUtils.isSameDay(s.at, clock.now()) ? 'today' : '${s.at.day} ${monthLabel(s.at)}'} at ${clockTime(s.at)}'
                        '${behind > 0 ? ' · $behind new ${behind == 1 ? 'event' : 'events'} since' : ''}',
              style: context.t.bodySmall?.copyWith(color: behind > 0 ? c.orange : null),
            ),
            const SizedBox(height: 12),
            if (error != null) Text(error!, style: context.t.bodySmall?.copyWith(color: c.red)),
            Expanded(
              child: writing
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                        const SizedBox(width: 8),
                        Text('Claude is writing…', style: context.t.bodySmall),
                      ],
                    )
                  : s == null
                  ? const SizedBox()
                  : SingleChildScrollView(child: SelectableText(s.text, style: context.t.bodyMedium?.copyWith(height: 1.45))),
            ),
          ],
        ),
      ),
    );
  }
}
