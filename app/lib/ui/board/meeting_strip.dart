// Today's meetings above the board, one line each: when, what, a bell for
// the alarm and a join button. Pure widget: data and callbacks only.
import 'package:flutter/material.dart';

import '../../core/meetings.dart';
import '../../core/models/records.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';

/// "Now", "in 25 min", "in 2 h 10".
String startsIn(EventRecord e, DateTime now) {
  if (!e.start.isAfter(now)) return 'Now';
  // Partial minutes round up: 24 min 30 s shows "in 25 min".
  final m = (e.start.difference(now).inSeconds + 59) ~/ 60;
  return m < 60 ? 'in $m min' : 'in ${m ~/ 60} h${m % 60 == 0 ? '' : ' ${(m % 60).toString().padLeft(2, '0')}'}';
}

class MeetingStrip extends StatelessWidget {
  const MeetingStrip({super.key, required this.events, required this.silenced, required this.now, this.onJoin, this.onAlarm});

  final List<EventRecord> events;

  /// Ids of meetings whose alarm you turned off.
  final Set<String> silenced;
  final DateTime now;
  final ValueChanged<EventRecord>? onJoin;
  final ValueChanged<EventRecord>? onAlarm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: stripPadding,
      child: Row(
        children: [
          for (final (i, e) in events.indexed) ...[
            if (i > 0) const SizedBox(width: 8),
            _Meeting(event: e, silenced: silenced.contains(e.id), now: now, onJoin: onJoin, onAlarm: onAlarm),
          ],
        ],
      ),
    );
  }
}

/// One meeting on one line: when, what, its alarm bell, and Join once it is
/// close. One you did not accept is dimmed, with no bell (it never rings).
class _Meeting extends StatelessWidget {
  const _Meeting({required this.event, required this.silenced, required this.now, this.onJoin, this.onAlarm});

  final EventRecord event;
  final bool silenced;
  final DateTime now;
  final ValueChanged<EventRecord>? onJoin;
  final ValueChanged<EventRecord>? onAlarm;

  @override
  Widget build(BuildContext context) {
    final c = context.c, e = event, live = !e.start.isAfter(now);
    final soon = live || e.start.difference(now).inMinutes < 15;
    final small = context.t.bodySmall!;
    final row = Container(
      height: 38,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(10),
        border: live ? Border.all(color: c.red.withValues(alpha: .6)) : null,
        boxShadow: context.c.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            live ? 'Now' : (soon ? startsIn(e, now) : clockTime(e.start)),
            style: small.copyWith(color: soon ? c.red : c.label2, fontWeight: soon ? FontWeight.w600 : null),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.t.titleMedium?.copyWith(fontSize: 13)),
          ),
          if (live) ...[const SizedBox(width: 8), Text('${clockTime(e.start)}–${clockTime(e.end)}', style: small)],
          if (!e.going)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text('Not accepted', style: small),
            )
          else
            IconButton(
              tooltip: silenced ? 'Turn the alarm on' : 'Turn the alarm off',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              iconSize: 15,
              onPressed: onAlarm == null ? null : () => onAlarm!(e),
              icon: Icon(silenced ? Icons.notifications_off_outlined : Icons.notifications_active_outlined, color: silenced ? c.label3 : c.orange),
            ),
          if (soon && joinUri(e) != null)
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: FilledButton(style: smallButton(context), onPressed: onJoin == null ? null : () => onJoin!(e), child: const Text('Join')),
            ),
        ],
      ),
    );
    return e.going ? row : Opacity(opacity: .6, child: row);
  }
}

/// Shown while a meeting rings: what, when, and the buttons that stop it.
class AlarmBanner extends StatelessWidget {
  const AlarmBanner({super.key, required this.event, required this.now, this.onJoin, this.onStop, this.margin = stripPadding});

  final EdgeInsets margin;
  final EventRecord event;
  final DateTime now;
  final VoidCallback? onJoin;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final c = context.c, e = event;
    return TintBox(
      color: c.red,
      margin: margin,
      child: Row(
        children: [
          Icon(Icons.alarm_rounded, color: c.red),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.t.titleMedium),
                Text(
                  e.start.isAfter(now) ? 'Starts at ${clockTime(e.start)}, ${startsIn(e, now)}' : 'Started at ${clockTime(e.start)}',
                  style: context.t.bodySmall,
                ),
              ],
            ),
          ),
          TextButton.icon(onPressed: onStop, icon: const Icon(Icons.alarm_off_rounded, size: 18), label: const Text('Stop')),
          if (joinUri(e) != null) ...[
            const SizedBox(width: 6),
            FilledButton.icon(onPressed: onJoin, icon: const Icon(Icons.videocam_outlined, size: 18), label: const Text('Join')),
          ],
        ],
      ),
    );
  }
}
