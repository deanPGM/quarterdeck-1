// Pure view logic for the board: rank, filter and group cards. No widgets, so
// it is easy to test.
import 'package:flutter/material.dart';

import '../../actions/launcher.dart';
import '../../core/models/board_filter.dart';
import '../../core/models/card.dart';
import '../../core/models/config.dart';
import '../../core/models/snapshot.dart';
import '../../core/links.dart';
import '../../core/projects.dart';

/// Column a card shows in, after your triage.
enum Slot { action, blocked, clear, snoozed, done }

class BoardItem {
  BoardItem({
    required this.card,
    required this.triage,
    required this.projects,
    required this.actions,
    required this.slot,
    required this.rank,
    required this.busy,
  });

  final DeckCard card;
  final Triage triage;
  final List<String> projects;
  final List<CardAction> actions;
  final Slot slot;
  final int rank;
  final bool busy;

  /// The cards linked to this one, found or made by you ([buildItems] fills it).
  final links = <LinkedItem>[];
}

/// A card linked to another; [manual] when you made the link.
typedef LinkedItem = ({BoardItem item, bool manual});

enum BoardView { flow, focus, needs, all, urgent, pinned, snoozed, done, activity }

/// The views that make up By type: one column per type, the old board.
const byTypeViews = [BoardView.needs, BoardView.all, BoardView.urgent, BoardView.pinned, BoardView.snoozed, BoardView.done];

class LaneInfo {
  const LaneInfo(this.lane, this.title, this.one, this.icon, this.color, this.providers, this.hints);

  final Lane lane;
  final String title;

  /// The type name of one card, on its top line.
  final String one;
  final IconData icon;

  /// Index into the accent palette, resolved by the widget.
  final String color;
  final List<String> providers;

  /// Hint per column.
  final Map<Slot, String> hints;
}

const lanes = [
  LaneInfo(
    Lane.reply,
    'Replies',
    'Reply',
    Icons.forum_outlined,
    'orange',
    ['slack', 'mail'],
    {Slot.action: 'Messages that wait for your answer.', Slot.blocked: 'You answered. Waits on them.'},
  ),
  LaneInfo(
    Lane.review,
    'Reviews',
    'Review',
    Icons.rate_review_outlined,
    'purple',
    ['gitlab', 'github'],
    {
      Slot.action: 'New review requests and replies in your threads.',
      Slot.blocked: 'Your threads wait on the author.',
      Slot.clear: 'You approved, or the author has the next step.',
    },
  ),
  LaneInfo(
    Lane.mine,
    'My MRs',
    'My MR',
    Icons.call_split_rounded,
    'green',
    ['gitlab', 'github'],
    {Slot.action: 'Merge, rebase, fix the pipeline or answer review threads.', Slot.blocked: 'Waits for a reviewer, an approval or a pipeline.'},
  ),
  LaneInfo(
    Lane.task,
    'Tasks',
    'Task',
    Icons.check_circle_outline,
    'teal',
    ['jira', 'todo', 'slack', 'mail'],
    {Slot.action: 'Tickets, notes and asks that are work to do.', Slot.blocked: 'Waits for someone else.'},
  ),
];

LaneInfo laneInfo(Lane l) => lanes.firstWhere((x) => x.lane == l);

const columnTitles = {Slot.action: 'Needs You', Slot.blocked: 'Waiting on Others', Slot.clear: 'Nothing to Do', Slot.snoozed: 'Snoozed', Slot.done: 'Done'};

final _forever = DateTime(9999);
DateTime get snoozeForever => _forever;

/// [links] are the links you made or cut (BoardState.links).
List<BoardItem> buildItems(
  Map<String, Snapshot> snaps,
  Map<String, Triage> triage,
  Set<String> busy,
  DeckConfig cfg,
  DateTime now, {
  Map<String, bool> links = const {},
}) {
  final out = <BoardItem>[];
  for (final s in snaps.values) {
    for (final c in s.cards) {
      final t = triage[c.key] ?? const Triage();
      final snoozed = t.snoozeUntil != null && t.snoozeUntil!.isAfter(now);
      out.add(
        BoardItem(
          card: c,
          triage: t,
          projects: projectsOf(c, cfg.projects),
          actions: actionsFor(c, cfg),
          slot: t.done ? Slot.done : (snoozed ? Slot.snoozed : Slot.values[c.bucket.index]),
          rank: c.score + t.boost * 15 + (t.pin ? 1000 : 0) + (t.urgent ? 2000 : 0),
          busy: busy.contains(c.key),
        ),
      );
    }
  }
  out.sort((a, b) {
    // Snoozed cards sink to the bottom of their column.
    final z = (a.slot == Slot.snoozed ? 1 : 0).compareTo(b.slot == Slot.snoozed ? 1 : 0);
    if (z != 0) return z;
    final r = b.rank.compareTo(a.rank);
    return r != 0 ? r : (a.card.updatedAt ?? now).compareTo(b.card.updatedAt ?? now);
  });
  final byKey = {for (final i in out) i.card.key: i};
  final found = linksOf(out.map((i) => i.card), links);
  // In board order, so the linked card that matters most comes first.
  for (final i in out) {
    for (final l in found[i.card.key] ?? const <CardLink>[]) {
      byKey[l.key]!.links.add((item: i, manual: l.manual));
    }
  }
  return out;
}

/// Cards Deck cannot close itself: messages and your notes.
bool canMarkDone(DeckCard c) => messageProviders.contains(c.provider) || c.provider == 'todo';

/// Flow columns a card can be dropped on, and what that does.
enum FlowDrop {
  /// Back to Next: not now, or reopened from Done today.
  next,

  /// Start it.
  doing,

  /// Mark it done.
  done,
}

/// True when dropping [i] on column [to] does something.
bool canDrop(BoardItem i, FlowDrop to) => switch (to) {
  FlowDrop.next => i.slot == Slot.done || (i.triage.startedAt != null && i.slot == Slot.action),
  FlowDrop.doing => i.slot == Slot.action && i.triage.startedAt == null,
  FlowDrop.done => i.slot != Slot.done && canMarkDone(i.card),
};

/// True when [a] and [b] are already linked.
bool linked(BoardItem a, BoardItem b) => a.links.any((l) => l.item.card.key == b.card.key);

/// True when [i] passes every kind of token in [f] and its text.
bool matches(BoardItem i, BoardFilter f) {
  if (f.projects.isNotEmpty && !i.projects.any(f.projects.contains)) return false;
  if (f.types.isNotEmpty && !f.types.contains(i.card.lane)) return false;
  if (f.providers.isNotEmpty && !f.providers.contains(i.card.provider)) return false;
  if (f.text.isEmpty) return true;
  final q = f.text.toLowerCase();
  return '${i.card.title} ${i.card.ref} ${i.card.next} ${i.triage.note ?? ''}'.toLowerCase().contains(q);
}

/// Done cards only show in the Done view.
bool inView(BoardItem i, BoardView v) =>
    (v == BoardView.done) == (i.slot == Slot.done) &&
    switch (v) {
      BoardView.flow || BoardView.focus || BoardView.needs => i.slot == Slot.action,
      BoardView.all || BoardView.done => true,
      BoardView.urgent => i.triage.urgent,
      BoardView.pinned => i.triage.pin,
      BoardView.snoozed => i.slot == Slot.snoozed,
      BoardView.activity => false,
    };

/// Provider names on a card's top line. Your own notes are Deck's.
const providerLabels = {'gitlab': 'GitLab', 'github': 'GitHub', 'jira': 'Jira', 'slack': 'Slack', 'mail': 'Mail', 'todo': 'Deck'};

/// Mail that wants a glance, not work: Flow sweeps it in one card.
bool sweepable(DeckCard c) => c.provider == 'mail' && const {'noise', 'fyi', 'phishing'}.contains(c.kind);

/// Most cards in Doing before the column says it is full.
const doingMax = 3;

/// The Flow board: one ranked Next list across types, what you started, what
/// waits on others, and what closed today.
typedef FlowLists = ({List<BoardItem> next, List<BoardItem> doing, List<BoardItem> waiting, List<BoardItem> sweep, List<BoardItem> done, int snoozed});

/// [items] come ranked from [buildItems].
FlowLists flowOf(List<BoardItem> items, DateTime now) {
  // A started card that now waits on others, or needs nothing, leaves Doing;
  // it keeps its start, so it is back in Doing once it needs you again.
  bool started(BoardItem i) => i.triage.startedAt != null && (i.slot == Slot.action || i.slot == Slot.snoozed);
  bool today(DateTime? at) => at != null && at.year == now.year && at.month == now.month && at.day == now.day;
  return (
    next: [
      for (final i in items)
        if (i.slot == Slot.action && !started(i) && !sweepable(i.card)) i,
    ],
    doing: [
      for (final i in items)
        if (started(i)) i,
    ]..sort((a, b) => a.triage.startedAt!.compareTo(b.triage.startedAt!)),
    waiting: [
      for (final i in items)
        if (i.slot == Slot.blocked) i,
    ],
    sweep: [
      for (final i in items)
        if (i.slot == Slot.action && !started(i) && sweepable(i.card)) i,
    ],
    done: [
      for (final i in items)
        if (i.slot == Slot.done && today(i.triage.doneAt)) i,
    ]..sort((a, b) => b.triage.doneAt!.compareTo(a.triage.doneAt!)),
    snoozed: items.where((i) => i.slot == Slot.snoozed).length,
  );
}

/// "3 mails: 1 phishing, 1 noise, 1 FYI."
String sweepSummary(List<BoardItem> sweep) {
  final n = {
    for (final k in const ['phishing', 'noise', 'fyi']) k: sweep.where((i) => i.card.kind == k).length,
  };
  final parts = [
    for (final e in n.entries)
      if (e.value > 0) '${e.value} ${e.key == 'fyi' ? 'FYI' : e.key}',
  ];
  return '${sweep.length} ${sweep.length == 1 ? 'mail' : 'mails'}: ${parts.join(', ')}.';
}
