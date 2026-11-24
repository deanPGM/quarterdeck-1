// Notifications over every screen: the meeting ringing, the tools background
// sessions ask for, and sessions that just ended float top right; the bell
// next to the Terminals pill opens the list of all of them.
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/meetings.dart';
import '../../core/tool_rules.dart';
import '../../state/alarms.dart';
import '../../state/board.dart';
import '../../state/notices.dart';
import '../../state/settings.dart';
import '../board/meeting_strip.dart';
import '../theme.dart';

class NoticeLayer extends ConsumerWidget {
  const NoticeLayer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mounted on every screen: meetings ring whatever screen shows.
    ref.watch(alarmsProvider);
    final ringing = ref.watch(ringingProvider);
    final asks = ref.watch(boardProvider.select((b) => b.value?.asks ?? const <PermissionAsk>[]));
    final notices = ref.watch(noticesProvider);
    final n = ref.read(noticesProvider.notifier);
    void go(String? route) {
      n.setOpen(false);
      if (route != null) GoRouter.of(context).go(route);
    }

    final toasts = [
      if (ringing != null)
        _Toast(
          child: AlarmBanner(
            event: ringing,
            now: clock.now(),
            margin: EdgeInsets.zero,
            onJoin: () => ref.read(ringingProvider.notifier).join(ringing),
            onStop: () => ref.read(ringingProvider.notifier).stop(),
          ),
        ),
      for (final a in asks.take(3))
        _Toast(
          child: PermissionToast(
            key: ObjectKey(a),
            tool: a.tool,
            input: a.input,
            onAnswer: (ok) => a.answer.isCompleted ? null : a.answer.complete(ok),
            onAlways: (rule) async {
              if (a.answer.isCompleted) return;
              a.rule = rule;
              await ref
                  .read(settingsProvider.notifier)
                  .change((c) => c.copyWith(claude: c.claude.copyWith(allowedTools: {...c.claude.allowedTools, rule}.toList())));
              if (!a.answer.isCompleted) a.answer.complete(true);
            },
          ),
        ),
      if (asks.length > 3)
        _Toast(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            child: Row(
              children: [
                Expanded(child: Text('${asks.length - 3} more asks from Claude', style: context.t.bodySmall)),
                TextButton(
                  onPressed: () {
                    for (final a in asks) {
                      if (!a.answer.isCompleted) a.answer.complete(false);
                    }
                  },
                  child: const Text('Deny All'),
                ),
              ],
            ),
          ),
        ),
      for (final x in notices.all.where((x) => notices.toasts.contains(x.id)))
        _Toast(
          child: NoticeTile(notice: x, onTap: () => go(x.route), onClose: () => n.dismiss(x.id)),
        ),
    ];
    return Stack(
      children: [
        child,
        if (notices.open) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () => n.setOpen(false),
              child: ColoredBox(color: context.c.shadow.withValues(alpha: .12)),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: 380,
            child: NoticePanel(notices: notices.all, onOpen: (x) => go(x.route), onClear: n.clear, onClose: () => n.setOpen(false)),
          ),
        ],
        if (toasts.isNotEmpty)
          Positioned(
            top: 12,
            right: 16,
            width: 420,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: toasts),
          ),
      ],
    );
  }
}

/// A card floating over the screen.
class _Toast extends StatelessWidget {
  const _Toast({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(
      color: context.c.card,
      elevation: 8,
      shadowColor: context.c.shadow.withValues(alpha: .38),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: child,
    ),
  );
}

/// A background session asks for a tool: Deny, Allow once, or Always allow
/// with a rule you can edit first.
class PermissionToast extends StatefulWidget {
  const PermissionToast({super.key, required this.tool, required this.input, required this.onAnswer, required this.onAlways});

  final String tool;
  final Map<String, Object?> input;
  final ValueChanged<bool> onAnswer;
  final ValueChanged<String> onAlways;

  @override
  State<PermissionToast> createState() => _PermissionToastState();
}

class _PermissionToastState extends State<PermissionToast> {
  TextEditingController? _rule;

  @override
  void dispose() {
    _rule?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final code = mono(context.t.bodySmall!);
    final rule = _rule;
    return Container(
      padding: const EdgeInsets.all(12),
      color: c.orange.withValues(alpha: .12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: c.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text('Claude wants to use ${widget.tool}', style: context.t.titleSmall)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.tool == 'Bash' ? callSummary(widget.tool, widget.input) : const JsonEncoder.withIndent(' ').convert(widget.input),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: code,
          ),
          const SizedBox(height: 8),
          if (rule == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => widget.onAnswer(false), child: const Text('Deny')),
                TextButton(
                  onPressed: () => setState(() => _rule = TextEditingController(text: suggestRule(widget.tool, widget.input))),
                  child: const Text('Always Allow…'),
                ),
                const SizedBox(width: 4),
                FilledButton(onPressed: () => widget.onAnswer(true), child: const Text('Allow')),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: rule,
                    autofocus: true,
                    style: code,
                    decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(), helperText: 'Every background session may use this'),
                    onSubmitted: (v) => v.trim().isEmpty ? null : widget.onAlways(v.trim()),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(onPressed: () => setState(() => _rule = null), child: const Text('Cancel')),
                FilledButton(onPressed: () => rule.text.trim().isEmpty ? null : widget.onAlways(rule.text.trim()), child: const Text('Save')),
              ],
            ),
        ],
      ),
    );
  }
}

/// One notification: icon, title, one line or two, the time.
class NoticeTile extends StatelessWidget {
  const NoticeTile({super.key, required this.notice, this.onTap, this.onClose});

  final Notice notice;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.c, x = notice;
    final (icon, color) = switch (x.kind) {
      _ when x.error => (Icons.error_outline_rounded, c.red),
      NoticeKind.meeting => (Icons.alarm_rounded, c.red),
      NoticeKind.permission => (Icons.shield_outlined, c.orange),
      NoticeKind.session => (Icons.auto_awesome_outlined, c.purple),
    };
    return InkWell(
      onTap: x.route == null ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    x.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (x.body.isNotEmpty)
                    Text(
                      x.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.t.bodySmall?.copyWith(color: c.label2),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(clockTime(x.at), style: context.t.bodySmall?.copyWith(color: c.label3)),
            if (onClose != null)
              IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded, size: 16), visualDensity: VisualDensity.compact, tooltip: 'Dismiss'),
          ],
        ),
      ),
    );
  }
}

/// Every notification since Deck started, newest first.
class NoticePanel extends StatelessWidget {
  const NoticePanel({super.key, required this.notices, required this.onOpen, required this.onClear, required this.onClose});

  final List<Notice> notices;
  final ValueChanged<Notice> onOpen;
  final VoidCallback onClear;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Material(
      color: c.card,
      elevation: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
            child: Row(
              children: [
                Expanded(child: Text('Notifications', style: context.t.titleMedium)),
                if (notices.isNotEmpty) TextButton(onPressed: onClear, child: const Text('Clear')),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded, size: 18), tooltip: 'Close'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: notices.isEmpty
                ? Center(
                    child: Text('Nothing yet.', style: context.t.bodySmall?.copyWith(color: c.label2)),
                  )
                : ListView.separated(
                    itemCount: notices.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) => NoticeTile(notice: notices[i], onTap: () => onOpen(notices[i])),
                  ),
          ),
        ],
      ),
    );
  }
}

/// The bell beside the Terminals pill: how many notices you have not seen,
/// orange while something waits for you.
class NoticeBell extends ConsumerWidget {
  const NoticeBell({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    final notices = ref.watch(noticesProvider);
    final live = ref.watch(boardProvider.select((b) => b.value?.asks.length ?? 0)) + (ref.watch(ringingProvider) == null ? 0 : 1);
    final hot = live > 0;
    final count = live + notices.unread;
    return Material(
      color: hot ? c.waitingTint(c.card) : c.card,
      shape: StadiumBorder(side: BorderSide(color: hot ? c.orange : c.sep)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ref.read(noticesProvider.notifier).setOpen(!notices.open),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(count > 0 ? Icons.notifications_rounded : Icons.notifications_none_rounded, size: 14, color: hot ? c.orange : c.label2),
                if (count > 0) ...[
                  const SizedBox(width: 3),
                  Text(
                    '$count',
                    style: context.t.bodySmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: hot ? c.orange : c.label2),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
