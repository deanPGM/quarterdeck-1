import 'package:flutter/material.dart';

import '../../actions/launcher.dart';
import '../../state/terminals.dart' show TermTab;
import '../../core/classify/time.dart';
import '../../core/models/card.dart';
import '../../core/models/session_progress.dart';
import '../parts.dart';
import '../theme.dart';
import 'board_model.dart';

enum CardMenu { open, reload, reopen, urgent, pin, up, down, snooze1, snooze3, snooze7, snoozeForever, unsnooze, note, done, notNow, start, delete }

Color accent(BuildContext context, String name) {
  final c = context.c;
  return switch (name) {
    'green' => c.green,
    'purple' => c.purple,
    'teal' => c.teal,
    'orange' => c.orange,
    'indigo' => c.indigo,
    'red' => c.red,
    'graphite' => c.graphite,
    _ => c.blue,
  };
}

/// "Open in Slack" for a todo from Slack, "Open Link" when the source is unknown.
String actionLabel(CardAction a, DeckCard e) => switch (a) {
  CardAction.open => sourceNames[e.source] == null || e.source == 'meeting' ? 'Open Link' : 'Open in ${sourceNames[e.source]}',
  _ => actionLabels[a]!,
};

const actionLabels = {
  CardAction.open: 'Open Link',
  CardAction.review: 'Start Review',
  CardAction.feedback: 'Address Feedback',
  CardAction.draft: 'Draft Reply',
  CardAction.ticket: 'Make Ticket',
  CardAction.filter: 'Make Gmail Filter',
  CardAction.archive: 'Archive',
  CardAction.claude: 'Claude',
  CardAction.ide: 'Open in IDE',
};
const actionIcons = {
  CardAction.open: Icons.open_in_new_rounded,
  CardAction.review: Icons.rate_review_outlined,
  CardAction.feedback: Icons.forum_outlined,
  CardAction.draft: Icons.edit_note_rounded,
  CardAction.ticket: Icons.confirmation_number_outlined,
  CardAction.filter: Icons.filter_alt_outlined,
  CardAction.archive: Icons.archive_outlined,
  CardAction.claude: Icons.auto_awesome_outlined,
  CardAction.ide: Icons.code_rounded,
};

/// The Deck review of a merge request card: whether one exists, and the
/// Claude session on it. [step] is what it does now or how it ended.
typedef CardReview = ({bool exists, bool running, String kind, String step, String? progress, bool failed});

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.item,
    required this.now,
    this.session,
    this.term,
    this.termSelected = false,
    this.onTerm,
    this.onAction,
    this.onMenu,
    this.onResume,
    this.review,
    this.onOpenReview,
    this.logo,
    this.onFold,
    this.onOpenLinked,
    this.onUnlink,
  });

  final BoardItem item;

  /// Opens a linked card (its MR, ticket or message).
  final ValueChanged<BoardItem>? onOpenLinked;

  /// Cuts the link to a linked card.
  final ValueChanged<BoardItem>? onUnlink;

  /// The project's logo, first on the top line.
  final Widget? logo;

  /// Folds the card back to a row (Flow's long lists), from an icon by the menu.
  final VoidCallback? onFold;

  /// The card's review in Deck: Start Review and Address Feedback become
  /// Open Review once it exists, and its session shows under the card.
  final CardReview? review;
  final VoidCallback? onOpenReview;
  final DateTime now;
  final ValueChanged<CardAction>? onAction;
  final ValueChanged<CardMenu>? onMenu;

  /// Reopens the card's ended Claude session.
  final VoidCallback? onResume;

  /// The Claude session this card started, while it is on screen.
  final SessionProgress? session;

  /// The Deck terminal tab this card started, while it runs.
  final TermTab? term;

  /// [term] is the tab shown in the terminal panel.
  final bool termSelected;

  /// Shows [term] in the terminal panel.
  final VoidCallback? onTerm;

  @override
  Widget build(BuildContext context) {
    final c = context.c, e = item.card, t = item.triage;
    Color tone(TagTone x) => switch (x) {
      TagTone.act => c.red,
      TagTone.done => c.green,
      TagTone.warn => c.orange,
      TagTone.neutral => c.label2,
    };
    final tags = [
      if (item.slot == Slot.done) StatusTag(t.doneReason == null ? 'Done' : 'Done: ${t.doneReason}', c.green),
      if (item.slot == Slot.snoozed) StatusTag(t.snoozeUntil!.year >= 9999 ? 'Snoozed indefinitely' : 'Snoozed until ${shortDate(t.snoozeUntil!)}', c.indigo),
      for (final g in e.tags) StatusTag(g.label, tone(g.tone)),
    ];
    // A click anywhere on the card opens it (the mail, the MR, the ticket);
    // buttons, the menu and the note keep their own click.
    final card = Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(10),
        border: term != null
            ? Border.all(color: term!.waiting ? c.orange : c.blue, width: termSelected ? 2.5 : 1.5)
            : t.urgent
            ? Border.all(color: c.red.withValues(alpha: .6))
            : null,
        boxShadow: context.c.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(12, 9, 6, 11),
      child: Opacity(
        opacity: item.slot == Slot.clear || item.slot == Slot.snoozed || item.slot == Slot.done ? .72 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CardTopLine(item: item, now: now, logo: logo),
                ),
                if (t.boost != 0) Text('${t.boost > 0 ? '↑' : '↓'}${t.boost.abs()} ', style: context.t.bodySmall!.copyWith(fontSize: 11, color: c.label2)),
                if (t.urgent) Icon(Icons.priority_high_rounded, size: 14, color: c.red),
                if (t.pin) Icon(Icons.push_pin, size: 13, color: c.orange),
                if (onFold != null)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      tooltip: 'Fold',
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: onFold,
                      icon: Icon(Icons.unfold_less_rounded, color: c.label2),
                    ),
                  ),
                CardMenuButton(item: item, onMenu: onMenu),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                e.title.isEmpty ? e.ref : e.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.t.titleMedium?.copyWith(fontSize: 14, height: 1.3),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, right: 7),
                  child: CircleAvatar(radius: 3, backgroundColor: item.slot == Slot.action ? c.blue : c.label3),
                ),
                Expanded(child: Text(e.next, style: context.t.bodyMedium)),
              ],
            ),
            if ([e.why, ago(e.updatedAt, now)].where((x) => x != null && x.isNotEmpty) case final w when w.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 13, top: 2),
                child: Text(w.join('  ·  '), style: context.t.bodySmall),
              ),
            if (tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(spacing: 5, runSpacing: 5, children: tags),
              ),
            if (item.links.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 6),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final l in item.links)
                      LinkChip(
                        link: l,
                        onTap: onOpenLinked == null ? null : () => onOpenLinked!(l.item),
                        onUnlink: onUnlink == null ? null : () => onUnlink!(l.item),
                      ),
                  ],
                ),
              ),
            if (term case final tab?) _Term(tab, last: session?.last, onTap: onTerm) else if (session case final s?) _Session(s, onResume: onResume),
            if (review case final r? when r.kind.isNotEmpty) _ReviewRun(r, onOpen: onOpenReview),
            if (t.note != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 6),
                child: InkWell(
                  onTap: () => onMenu?.call(CardMenu.note),
                  child: TintBox(
                    dense: true,
                    color: c.orange,
                    child: Text(t.note!, style: context.t.bodySmall?.copyWith(color: c.label)),
                  ),
                ),
              ),
            if (item.actions.isNotEmpty && item.slot != Slot.clear && item.slot != Slot.done)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final (i, a) in item.actions.indexed)
                      if ((a == CardAction.review || a == CardAction.feedback) && (review?.exists ?? false))
                        _ActionButton(label: 'Open Review', icon: Icons.article_outlined, primary: i == 0, onTap: onAction == null ? null : () => onAction!(a))
                      else
                        _ActionButton(label: actionLabel(a, e), icon: actionIcons[a]!, primary: i == 0, onTap: onAction == null ? null : () => onAction!(a)),
                    if (t.startedAt != null)
                      canMarkDone(e)
                          ? _ActionButton(label: 'Done', icon: Icons.check_rounded, primary: false, onTap: () => onMenu?.call(CardMenu.done))
                          : _ActionButton(label: 'Not now', icon: Icons.pause_rounded, primary: false, onTap: () => onMenu?.call(CardMenu.notNow)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    if (e.url.isEmpty) return card;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: () => onMenu?.call(CardMenu.open), child: card),
    );
  }
}

/// A card's top line: project logo, type dot and name, ref, provider. The age
/// sits under the next step, so the ref keeps the room.
class CardTopLine extends StatelessWidget {
  const CardTopLine({super.key, required this.item, required this.now, this.logo});

  final BoardItem item;
  final DateTime now;
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    final c = context.c, e = item.card, info = laneInfo(e.lane);
    final small = context.t.bodySmall!.copyWith(fontSize: 11.5, color: c.label2);
    return Row(
      children: [
        // Takes the free space, so the provider label sits at the right edge.
        Expanded(
          child: Row(
            children: [
              if (logo != null) ...[logo!, const SizedBox(width: 7)],
              CircleAvatar(radius: 4, backgroundColor: accent(context, info.color)),
              const SizedBox(width: 5),
              Text(info.one, style: small),
              const SizedBox(width: 6),
              Flexible(
                child: Text(e.ref, overflow: TextOverflow.ellipsis, style: mono(small)),
              ),
            ],
          ),
        ),
        if (item.busy)
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: SizedBox.square(dimension: 12, child: CircularProgressIndicator(strokeWidth: 1.6)),
          ),
        if (providerLabels[e.provider] case final p?)
          Container(
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: c.fill, borderRadius: BorderRadius.circular(5)),
            child: Text(
              p,
              style: context.t.bodySmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: c.label2),
            ),
          ),
      ],
    );
  }
}

/// A card folded to a few lines, for the long lists of Flow: rank, top line,
/// title, next step, first tag. A click opens it into the full card.
class CardRow extends StatelessWidget {
  const CardRow({super.key, required this.item, required this.now, this.rank, this.logo, this.onTap, this.onMenu});

  final BoardItem item;
  final DateTime now;
  final int? rank;
  final Widget? logo;
  final VoidCallback? onTap;
  final ValueChanged<CardMenu>? onMenu;

  @override
  Widget build(BuildContext context) {
    final c = context.c, e = item.card;
    final done = item.slot == Slot.done;
    final tag = e.tags.firstOrNull;
    return Material(
      color: c.card,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 6, 10),
          child: Opacity(
            opacity: done ? .72 : 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rank != null)
                  SizedBox(
                    width: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        '$rank',
                        style: context.t.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: c.label2),
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CardTopLine(item: item, now: now, logo: logo),
                          ),
                          CardMenuButton(item: item, onMenu: onMenu),
                        ],
                      ),
                      Text(
                        e.title.isEmpty ? e.ref : e.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.t.titleMedium?.copyWith(fontSize: 13.5, height: 1.3),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          done ? item.triage.doneReason ?? 'You marked it done.' : e.next,
                          ago(done ? item.triage.doneAt : e.updatedAt, now),
                        ].where((x) => x.isNotEmpty).join('  ·  '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.t.bodySmall?.copyWith(color: c.label),
                      ),
                      if (item.links.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Row(
                            children: [
                              Icon(Icons.link_rounded, size: 13, color: c.label2),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.links.map((l) => linkLabel(l.item.card)).join(', '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodySmall?.copyWith(fontSize: 11.5, color: c.label2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (tag != null && !done)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: StatusTag(tag.label, switch (tag.tone) {
                            TagTone.act => c.red,
                            TagTone.done => c.green,
                            TagTone.warn => c.orange,
                            TagTone.neutral => c.label2,
                          }),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// How a linked card is named: the ref of a ticket or merge request, the
/// title of a message or note (their ref is only a channel or a sender).
String linkLabel(DeckCard c) => messageProviders.contains(c.provider) || c.provider == 'todo' ? c.title : c.ref;

/// A card linked to this one: its type dot, provider and name. A click opens
/// it; the cross cuts the link.
class LinkChip extends StatelessWidget {
  const LinkChip({super.key, required this.link, this.onTap, this.onUnlink});

  final LinkedItem link;
  final VoidCallback? onTap;
  final VoidCallback? onUnlink;

  @override
  Widget build(BuildContext context) {
    final c = context.c, e = link.item.card, done = link.item.slot == Slot.done;
    final small = context.t.bodySmall!.copyWith(fontSize: 11.5, color: c.label);
    return Tooltip(
      message: [e.title, e.next, if (!link.manual) 'Found by Deck'].where((x) => x.isNotEmpty).join('\n'),
      waitDuration: const Duration(milliseconds: 500),
      child: Material(
        color: c.fill,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(7, 3, onUnlink == null ? 8 : 2, 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(done ? Icons.check_rounded : Icons.link_rounded, size: 13, color: done ? c.green : c.label2),
                const SizedBox(width: 4),
                CircleAvatar(radius: 3.5, backgroundColor: accent(context, laneInfo(e.lane).color)),
                const SizedBox(width: 5),
                if (providerLabels[e.provider] case final p?)
                  Text(
                    '$p ',
                    style: small.copyWith(fontWeight: FontWeight.w600, color: c.label2),
                  ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 170),
                  child: Text(
                    linkLabel(e),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (e.provider == 'jira' || e.iid != null ? mono(small) : small).copyWith(decoration: done ? TextDecoration.lineThrough : null),
                  ),
                ),
                if (onUnlink != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(99),
                    onTap: onUnlink,
                    child: Tooltip(
                      message: 'Unlink',
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(Icons.close_rounded, size: 12, color: c.label2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// What a card shows while you drag it: its type, ref and title.
class DragGhost extends StatelessWidget {
  const DragGhost({super.key, required this.item});

  final BoardItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.c, e = item.card;
    return Material(
      color: c.card,
      elevation: 8,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 260,
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.blue, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: accent(context, laneInfo(e.lane).color)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    e.ref,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: mono(context.t.bodySmall!.copyWith(fontSize: 11.5, color: c.label2)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(e.title.isEmpty ? e.ref : e.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.t.titleMedium?.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

/// One line under a card: a state icon, a bold [label] in [color], then
/// [more] in plain text. [onTap] makes the whole line a button.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.icon, required this.label, required this.color, this.more, this.trailing, this.onTap});

  final Widget icon;
  final String label;
  final Color color;
  final String? more;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        // One fixed slot for every state, so the text does not move.
        SizedBox.square(dimension: 15, child: Center(child: icon)),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: context.t.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: color),
                ),
                if (more case final line?) TextSpan(text: '  ·  $line'),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.t.bodySmall?.copyWith(color: context.c.label),
          ),
        ),
        ?trailing,
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 6),
      child: Material(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.fromLTRB(8, 6, 4, 6), child: row),
        ),
      ),
    );
  }
}

/// The "Show >" or "Open >" end of a tappable status line.
Widget _go(BuildContext context, String text, Color color) => Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      text,
      style: context.t.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: color),
    ),
    Icon(Icons.chevron_right_rounded, size: 16, color: color),
  ],
);

Widget _spinner(Color color) => Padding(
  padding: const EdgeInsets.all(2),
  child: CircularProgressIndicator(strokeWidth: 1.8, color: color),
);

/// One line under the card: its Deck terminal tab, and a way back to it.
class _Term extends StatelessWidget {
  const _Term(this.tab, {this.last, this.onTap});

  final TermTab tab;
  final VoidCallback? onTap;

  /// Claude's last line, from the transcript.
  final String? last;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final what = tab.info.action ?? 'Session';
    final (label, color) = tab.waiting
        ? ('$what waits for you', c.orange)
        : tab.working
        ? ('$what working', c.blue)
        : tab.hooked
        ? ('$what done', c.blue)
        : ('$what running', c.blue);
    return _StatusLine(
      icon: tab.working && !tab.waiting ? _spinner(color) : Icon(tab.waiting ? Icons.keyboard_alt_outlined : Icons.terminal_rounded, size: 15, color: color),
      label: label,
      color: color,
      more: last,
      trailing: _go(context, 'Show', color),
      onTap: onTap,
    );
  }
}

/// One line under the card: what Claude does on its review, or that it is
/// done. A click opens the review.
class _ReviewRun extends StatelessWidget {
  const _ReviewRun(this.r, {this.onOpen});

  final CardReview r;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (label, color) = r.running
        ? (
            switch (r.kind) {
              'feedback' => 'Claude is writing your replies',
              'answer' => 'Claude is answering',
              _ => 'Claude is preparing the review',
            },
            c.blue,
          )
        : r.failed
        ? ('Review session stopped', c.orange)
        : (
            switch (r.kind) {
              'feedback' => 'Replies ready',
              'answer' => 'Claude answered',
              _ => 'Review ready',
            },
            c.green,
          );
    final more = [?r.progress, if (r.step.isNotEmpty) r.step].join(' · ');
    return _StatusLine(
      icon: r.running ? _spinner(color) : Icon(r.failed ? Icons.error_outline_rounded : Icons.check_circle_rounded, size: 15, color: color),
      label: label,
      color: color,
      more: more.isEmpty ? null : more,
      trailing: _go(context, 'Open', color),
      onTap: onOpen,
    );
  }
}

/// One line under the card: what its Claude session is doing.
class _Session extends StatelessWidget {
  const _Session(this.s, {this.onResume});

  final SessionProgress s;
  final VoidCallback? onResume;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (label, color) = switch (s.status) {
      SessionStatus.working => ('Claude working', c.blue),
      SessionStatus.waiting => ('Claude waits for you', c.orange),
      SessionStatus.done => ('Claude done', c.label3),
      SessionStatus.idle => ('Claude idle', c.label3),
      SessionStatus.closed => ('Claude session ended', c.label2),
    };
    final closed = s.status == SessionStatus.closed;
    return _StatusLine(
      icon: s.status == SessionStatus.working ? _spinner(color) : Icon(Icons.circle, size: 7, color: color),
      label: label,
      color: color,
      // Ended: what it was about. Running: what it said last.
      more: closed ? s.title ?? s.last : s.last ?? s.title,
      trailing: closed && onResume != null
          ? TextButton.icon(
              onPressed: onResume,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              icon: const Icon(Icons.replay_rounded, size: 15),
              label: const Text('Resume'),
            )
          : null,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, required this.primary, this.onTap});

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final fg = primary ? c.blue : c.label;
    return Material(
      color: primary ? c.blue.withValues(alpha: .12) : c.fill,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 5),
              Text(
                label,
                style: context.t.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardMenuButton extends StatelessWidget {
  const CardMenuButton({super.key, required this.item, this.onMenu});

  final BoardItem item;
  final ValueChanged<CardMenu>? onMenu;

  @override
  Widget build(BuildContext context) {
    final t = item.triage;
    PopupMenuItem<CardMenu> mi(CardMenu v, IconData i, String label, {bool enabled = true}) => PopupMenuItem(
      value: v,
      enabled: enabled,
      height: 34,
      child: Row(
        children: [
          Icon(i, size: 16),
          const SizedBox(width: 10),
          Text(label, style: context.t.bodyMedium!.copyWith(fontSize: 13)),
        ],
      ),
    );
    final canDone = canMarkDone(item.card);
    return SizedBox(
      width: 28,
      height: 24,
      child: PopupMenuButton<CardMenu>(
        tooltip: 'Actions',
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(Icons.more_horiz, color: context.c.label2),
        onSelected: onMenu,
        itemBuilder: (_) => [
          if (item.card.url.isNotEmpty) mi(CardMenu.open, Icons.open_in_new_rounded, 'Open'),
          mi(CardMenu.reload, Icons.refresh_rounded, 'Reload Card'),
          if (t.done) mi(CardMenu.reopen, Icons.undo_rounded, 'Mark Not Done') else if (canDone) mi(CardMenu.done, Icons.check_rounded, 'Mark Done'),
          if (t.startedAt != null && !t.done) mi(CardMenu.notNow, Icons.pause_rounded, 'Not Now'),
          if (t.startedAt == null && !t.done) mi(CardMenu.start, Icons.play_arrow_rounded, 'Start'),
          const PopupMenuDivider(),
          mi(CardMenu.urgent, Icons.priority_high_rounded, t.urgent ? 'Remove Urgent' : 'Mark as Urgent'),
          mi(CardMenu.pin, Icons.push_pin_outlined, t.pin ? 'Unpin' : 'Pin'),
          mi(CardMenu.up, Icons.arrow_upward_rounded, 'Move Up', enabled: t.boost < 3),
          mi(CardMenu.down, Icons.arrow_downward_rounded, 'Move Down', enabled: t.boost > -3),
          const PopupMenuDivider(),
          mi(CardMenu.snooze1, Icons.bedtime_outlined, 'Snooze Until Tomorrow'),
          mi(CardMenu.snooze3, Icons.bedtime_outlined, 'Snooze 3 Days'),
          mi(CardMenu.snooze7, Icons.bedtime_outlined, 'Snooze a Week'),
          mi(CardMenu.snoozeForever, Icons.bedtime_outlined, 'Snooze Indefinitely'),
          if (t.snoozeUntil != null) mi(CardMenu.unsnooze, Icons.wb_sunny_outlined, 'Unsnooze'),
          const PopupMenuDivider(),
          mi(CardMenu.note, Icons.edit_outlined, t.note == null ? 'Add Note…' : 'Edit Note…'),
          if (item.card.provider == 'todo') mi(CardMenu.delete, Icons.delete_outline_rounded, 'Delete'),
        ],
      ),
    );
  }
}
