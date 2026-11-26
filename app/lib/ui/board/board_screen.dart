import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../actions/launcher.dart';
import '../../sources/chrome.dart';
import '../../core/classify/message.dart';
import '../../core/classify/time.dart';
import '../../core/meetings.dart';
import '../../core/models/card.dart';
import '../../core/models/config.dart';
import '../../core/models/records.dart';
import '../../core/models/snapshot.dart';
import '../../core/projects.dart';
import '../../core/providers_catalog.dart';
import '../../core/tickets.dart';
import '../../state/alarms.dart';
import '../../state/board.dart';
import '../../state/board_filter.dart';
import '../../state/project_info.dart';
import '../../state/project_overview.dart';
import '../../state/reviews.dart';
import '../../state/sessions.dart';
import '../../state/settings.dart';
import '../../state/terminals.dart';
import '../activity/activity_pane.dart';
import '../project/project_logo.dart';
import '../project/project_screen.dart';
import '../review/review_screen.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';
import '../worktrees.dart';
import 'board_model.dart';
import 'card_tile.dart';
import 'filter_field.dart';
import 'meeting_strip.dart';

const _views = {
  BoardView.flow: ('Today', Icons.view_week_outlined, 'blue'),
  BoardView.focus: ('Focus', Icons.center_focus_strong_outlined, 'indigo'),
  BoardView.needs: ('Needs You', Icons.person_outline_rounded, 'blue'),
  BoardView.urgent: ('Urgent', Icons.priority_high_rounded, 'red'),
  BoardView.pinned: ('Pinned', Icons.push_pin_outlined, 'orange'),
  BoardView.snoozed: ('Snoozed', Icons.bedtime_outlined, 'indigo'),
  BoardView.done: ('Done', Icons.check_rounded, 'green'),
  BoardView.all: ('All', Icons.inbox_outlined, 'graphite'),
};

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen> {
  BoardView view = BoardView.flow;

  /// Redraws every minute, so "in 5 min" on meetings stays true.
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _toast(String msg) => showToast(context, msg);

  Future<void> _onAction(BoardItem i, CardAction a) async {
    if (boardActions.contains(a)) return _onMail(i.card, a);
    final cfg = await ref.read(settingsProvider.future);
    // A merge request of a project with its repository set is reviewed in Deck.
    final c = i.card, project = workProject(c, cfg.projects);
    if ((a == CardAction.review || a == CardAction.feedback) && project?.repo != null && c.iid != null) {
      final own = a == CardAction.feedback;
      _toast(own ? 'Opening the feedback on ${c.ref}' : 'Opening the review of ${c.ref}');
      unawaited(_start(c.key));
      try {
        if (mounted) await startReview(context, ref, project!.id, c.provider, c.iid!, own: own);
      } catch (e) {
        _toast('Could not open the review: $e');
      }
      return;
    }
    try {
      final (msg, session) = await runAction(i.card, a, cfg, ref.read(homeProvider), ref.read(terminalsProvider.notifier));
      _toast(msg);
      if (_starts.contains(a)) await _start(i.card.key, session: session);
    } catch (e) {
      _toast('Could not start: $e');
    }
  }

  /// Clicks that mean you work on the card now: it moves to Doing.
  static const _starts = {CardAction.claude, CardAction.ide, CardAction.review, CardAction.feedback};

  Future<void> _start(String key, {String? session}) {
    final t = ref.read(boardProvider).value?.triage[key] ?? const Triage();
    return ref.read(boardProvider.notifier).setTriage(key, t.copyWith(startedAt: t.startedAt ?? clock.now(), session: session ?? t.session));
  }

  Future<void> _onResume(BoardItem i, String id, String? cwd) async {
    final cfg = await ref.read(settingsProvider.future);
    try {
      _toast(await resumeSession(i.card, id, cwd, cfg, ref.read(homeProvider), ref.read(terminalsProvider.notifier)));
    } catch (e) {
      _toast('Could not resume: $e');
    }
  }

  /// Filter opens Gmail's filter form for the sender, then archives what is
  /// already in the inbox, like Archive.
  Future<void> _onMail(DeckCard c, CardAction a) async {
    if (a == CardAction.ticket) return _onTicket(c);
    if (a == CardAction.filter && c.channel != null) {
      await openLink(Uri.parse(gmailFilterUrl(c.channel!)), ref.read(settingsProvider).requireValue.actions.browserProfile);
      _toast('In Gmail: Create filter, then tick Skip the Inbox. Quarterdeck archives the ${c.threads.length} already there.');
    }
    final msg = await ref.read(boardProvider.notifier).archive(c);
    if (mounted) _toast(msg);
  }

  /// Shows the ticket Deck drafted from the card; on confirm it is made on
  /// the project's board and replaces the card.
  Future<void> _onTicket(DeckCard c) async {
    final board = ticketBoard(c, ref.read(settingsProvider).requireValue.projects);
    if (board == null) return;
    final draft = ticketDraft(c);
    final name = '${sourceNames[board.provider] ?? board.provider} ${board.target}';
    final t = await askTicket(context, board: name, title: draft.title, body: draft.body);
    if (t == null) return;
    final msg = await ref.read(boardProvider.notifier).makeTicket(c, t.title, t.body);
    if (mounted) _toast(msg);
  }

  Future<void> _onMenu(BoardItem i, CardMenu menu) async {
    final b = ref.read(boardProvider.notifier), t = i.triage, k = i.card.key;
    DateTime days(int n) => DateTime.now().add(Duration(days: n));
    switch (menu) {
      case CardMenu.open:
        if (sourceUri(i.card) case final u?) await openLink(u, browserProfile(i.card, ref.read(settingsProvider).requireValue));
      case CardMenu.reload:
        await b.reload(i.card);
      case CardMenu.urgent:
        await b.setTriage(k, t.copyWith(urgent: !t.urgent));
      case CardMenu.pin:
        await b.setTriage(k, t.copyWith(pin: !t.pin));
      case CardMenu.up:
        await b.setTriage(k, t.copyWith(boost: t.boost + 1));
      case CardMenu.down:
        await b.setTriage(k, t.copyWith(boost: t.boost - 1));
      case CardMenu.snooze1:
        await b.setTriage(k, t.copyWith(snoozeUntil: days(1)));
      case CardMenu.snooze3:
        await b.setTriage(k, t.copyWith(snoozeUntil: days(3)));
      case CardMenu.snooze7:
        await b.setTriage(k, t.copyWith(snoozeUntil: days(7)));
      case CardMenu.snoozeForever:
        await b.setTriage(k, t.copyWith(snoozeUntil: snoozeForever));
      case CardMenu.unsnooze:
        await b.setTriage(k, t.copyWith(snoozeUntil: null));
      case CardMenu.done:
        await b.setTriage(k, t.copyWith(done: true));
        _toast('${i.card.ref} marked done');
      case CardMenu.reopen:
        // Reopening what Deck closed keeps Deck from closing it again.
        await b.setTriage(k, t.copyWith(done: false, doneReason: null, doneAt: null, keepOpen: t.doneReason != null));
      case CardMenu.notNow:
        await b.setTriage(k, t.copyWith(startedAt: null));
      case CardMenu.start:
        await _start(k);
      case CardMenu.delete:
        if (await confirm(context, title: 'Delete Todo', text: i.card.title, action: 'Delete', destructive: true)) await b.deleteTodo(k);
      case CardMenu.note:
        final note = (await ask(context, title: t.note == null ? 'Add Note' : 'Edit Note', text: t.note, hint: 'A note for this card', lines: 4))?.trim();
        if (note != null) await b.setTriage(k, t.copyWith(note: note.isEmpty ? null : note));
    }
  }

  /// A card dropped on a Flow column: start it, put it back in Next, or mark it done.
  Future<void> _onDrop(BoardItem i, FlowDrop to) => _onMenu(i, switch (to) {
    FlowDrop.doing => CardMenu.start,
    FlowDrop.done => CardMenu.done,
    FlowDrop.next => i.slot == Slot.done ? CardMenu.reopen : CardMenu.notNow,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = ref.watch(settingsProvider).value ?? const DeckConfig();
    final async = ref.watch(boardProvider);
    final board = async.value ?? const BoardState();
    final now = clock.now();
    final meetings = cfg.providers['calendar']?.enabled == true ? upcoming(board.snapshots['calendar']?.events ?? const [], now) : const <EventRecord>[];
    final all = buildItems(board.snapshots, board.triage, board.busy, cfg, now, links: board.links);
    final filter = ref.watch(boardFilterStateProvider);
    final scoped = all.where((i) => matches(i, filter)).toList();
    final home = ref.watch(homeProvider);
    Widget? logoOf(BoardItem i) {
      final p = cfg.projects.where((p) => i.projects.contains(p.id)).firstOrNull;
      final f = p == null ? null : logoFile(home, p);
      return f == null ? null : ProjectLogo(file: f, platforms: p!.platforms, size: 16);
    }

    final activeLanes = [
      for (final l in lanes)
        if ((l.providers.any((p) => cfg.providers[p]?.enabled == true) || all.any((i) => i.card.lane == l.lane)) &&
            (filter.types.isEmpty || filter.types.contains(l.lane)))
          l,
    ];
    final options = _options(all, cfg, (p) => logoFile(home, p));
    // The ringing meeting and Claude's asks float over every screen (NoticeLayer).
    final banners = [
      if (meetings.isNotEmpty)
        MeetingStrip(
          events: meetings,
          silenced: {
            for (final e in meetings)
              if (board.triage[meetingKey(e)]?.silent ?? false) e.id,
          },
          now: now,
          onJoin: (e) => ref.read(ringingProvider.notifier).join(e),
          onAlarm: (e) {
            final t = board.triage[meetingKey(e)] ?? const Triage();
            ref.read(boardProvider.notifier).setTriage(meetingKey(e), t.copyWith(silent: !t.silent));
          },
        ),
    ];
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Sidebar(view: view, items: scoped, cfg: cfg, board: board, onView: (v) => setState(() => view = v)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (view == BoardView.activity)
                  Expanded(child: ActivityPane(banners: banners))
                else ...[
                  _Header(
                    title: switch (view) {
                      BoardView.flow => 'Today',
                      BoardView.focus => 'Focus',
                      _ => 'By Type',
                    },
                    subtitle: view == BoardView.flow || view == BoardView.focus
                        ? _flowSubtitle(flowOf(scoped, now), board, now)
                        : _subtitle(scoped.where((i) => inView(i, view)).length, board),
                    busy: board.busy.isNotEmpty,
                    onRefresh: () => ref.read(boardProvider.notifier).refresh(),
                  ),
                  Padding(
                    padding: stripPadding,
                    child: FilterField(filter: filter, options: options, onChanged: ref.read(boardFilterStateProvider.notifier).set),
                  ),
                  if (byTypeViews.contains(view))
                    _ViewChips(view: view, count: (v) => scoped.where((i) => inView(i, v)).length, onView: (v) => setState(() => view = v)),
                  ...banners,
                  if (cfg.providers.isEmpty)
                    const Expanded(
                      child: _Empty(title: 'Set Up Quarterdeck', text: 'Add your first provider and project in Settings.', settings: true),
                    )
                  else if (view == BoardView.focus)
                    Expanded(
                      child: _FocusBoard(
                        flow: flowOf(scoped, now),
                        now: now,
                        loading: async.isLoading,
                        logoOf: logoOf,
                        onAction: _onAction,
                        onMenu: _onMenu,
                        onResume: _onResume,
                        onBoard: () => setState(() => view = BoardView.flow),
                      ),
                    )
                  else if (view == BoardView.flow)
                    Expanded(
                      child: _FlowBoard(
                        flow: flowOf(scoped, now),
                        now: now,
                        loading: async.isLoading,
                        logoOf: logoOf,
                        onAction: _onAction,
                        onMenu: _onMenu,
                        onResume: _onResume,
                        onDrop: _onDrop,
                        onSnoozed: () => setState(() => view = BoardView.snoozed),
                      ),
                    )
                  else
                    Expanded(
                      child: _Columns(
                        logoOf: logoOf,
                        view: view,
                        items: scoped,
                        lanes: activeLanes,
                        lane: filter.types.length == 1 ? filter.types.first : null,
                        now: now,
                        loading: async.isLoading,
                        onAction: _onAction,
                        onMenu: _onMenu,
                        onResume: _onResume,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The filter menu: projects with logos, types with dots, providers, each
  /// with its count of open cards.
  List<FilterOption> _options(List<BoardItem> all, DeckConfig cfg, String? Function(ProjectConfig) logoOf) {
    final open = all.where((i) => i.slot != Slot.done).toList();
    int n(bool Function(BoardItem) f) => open.where(f).length;
    return [
      for (final p in cfg.projects)
        FilterOption(
          FilterKind.project,
          p.id,
          p.name,
          leading: ProjectLogo(
            file: logoOf(p),
            platforms: p.platforms,
            size: 18,
            fallback: Icon(Icons.folder_outlined, size: 18, color: context.c.label2),
          ),
          count: n((i) => i.projects.contains(p.id)),
        ),
      if (all.any((i) => i.projects.contains(otherProject)))
        FilterOption(FilterKind.project, otherProject, 'Other', count: n((i) => i.projects.contains(otherProject))),
      for (final l in lanes)
        FilterOption(
          FilterKind.type,
          l.lane.name,
          l.title,
          leading: Center(child: CircleAvatar(radius: 4, backgroundColor: accent(context, l.color))),
          count: n((i) => i.card.lane == l.lane),
        ),
      for (final e in providerLabels.entries)
        if (all.any((i) => i.card.provider == e.key)) FilterOption(FilterKind.provider, e.key, e.value, count: n((i) => i.card.provider == e.key)),
    ];
  }

  String _subtitle(int n, BoardState b) => '$n ${n == 1 ? 'card' : 'cards'}${_updated(b)}';

  /// "Tue 3 Nov · 7 next · 3 doing · 3 waiting · 4 done · Updated 9:30".
  String _flowSubtitle(FlowLists f, BoardState b, DateTime now) {
    return '${dayDate(now)} · ${f.next.length} next · ${f.doing.length} doing · ${f.waiting.length} waiting · ${f.done.length} done${_updated(b)}';
  }

  String _updated(BoardState b) {
    if (b.busy.isNotEmpty) return ' · Refreshing…';
    final ats = b.snapshots.entries.where((e) => e.key != 'todo').map((e) => e.value.at).whereType<DateTime>();
    final last = ats.isEmpty ? null : ats.reduce((a, x) => a.isBefore(x) ? a : x);
    return last == null ? '' : ' · Updated ${clockTime(last)}';
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle, required this.busy, required this.onRefresh});

  final String title, subtitle;
  final bool busy;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Padding(
    padding: headPadding,
    child: PageHead(
      title: title,
      subtitle: subtitle,
      trailing: IconButton(
        tooltip: 'Refresh now',
        onPressed: busy ? null : onRefresh,
        icon: busy ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh_rounded),
      ),
    ),
  );
}

/// The views inside By type: Needs You, All, Urgent, Pinned, Snoozed, Done.
class _ViewChips extends StatelessWidget {
  const _ViewChips({required this.view, required this.count, required this.onView});

  final BoardView view;
  final int Function(BoardView) count;
  final ValueChanged<BoardView> onView;

  @override
  Widget build(BuildContext context) => Padding(
    padding: stripPadding,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final v in byTypeViews)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                avatar: Icon(_views[v]!.$2, size: 15, color: accent(context, _views[v]!.$3)),
                label: Text('${_views[v]!.$1}  ${count(v)}'),
                selected: view == v,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                onSelected: (_) => onView(v),
              ),
            ),
        ],
      ),
    ),
  );
}

class _Columns extends StatelessWidget {
  const _Columns({
    required this.logoOf,
    required this.view,
    required this.lane,
    required this.items,
    required this.lanes,
    required this.now,
    required this.loading,
    required this.onAction,
    required this.onMenu,
    required this.onResume,
  });

  final Widget? Function(BoardItem) logoOf;
  final BoardView view;

  /// The one type the filter picked: its columns are the states.
  final Lane? lane;
  final List<BoardItem> items;
  final List<LaneInfo> lanes;
  final DateTime now;
  final bool loading;
  final void Function(BoardItem, CardAction) onAction;
  final void Function(BoardItem, CardMenu) onMenu;
  final void Function(BoardItem, String id, String? cwd) onResume;

  @override
  Widget build(BuildContext context) {
    final cols = <(String, String, IconData?, String?, List<BoardItem>)>[];
    if (lane case final lane?) {
      final info = laneInfo(lane);
      final inLane = items.where((i) => i.card.lane == lane);
      for (final s in Slot.values.where((s) => s != Slot.done)) {
        final list = inLane.where((i) => i.slot == s).toList();
        if (info.hints.containsKey(s) || list.isNotEmpty) cols.add((columnTitles[s]!, s == Slot.action ? 'blue' : 'graphite', null, info.hints[s], list));
      }
    } else {
      for (final l in lanes) {
        cols.add((l.title, l.color, l.icon, null, items.where((i) => i.card.lane == l.lane && inView(i, view)).toList()));
      }
    }
    // Done only grows: show just the lists that have something.
    if (view == BoardView.done) cols.removeWhere((c) => c.$5.isEmpty);
    if (view != BoardView.needs && view != BoardView.all && lane == null && cols.every((c) => c.$5.isEmpty)) {
      return _Empty(title: 'Nothing ${_views[view]!.$1}', text: 'Use a card\'s ••• menu to add one here.');
    }
    if (view == BoardView.needs && cols.every((c) => c.$5.isEmpty) && !loading) {
      return const _Empty(title: 'You\'re All Caught Up', text: 'Nothing waits on you right now.');
    }
    return _HScroll(
      minWidth: cols.length * 338 + 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final col in cols)
              Container(
                width: 330,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                      child: Row(
                        children: [
                          if (col.$3 != null)
                            AccentIcon(col.$3!, accent(context, col.$2), circle: true)
                          else
                            CircleAvatar(radius: 4, backgroundColor: accent(context, col.$2)),
                          const SizedBox(width: 8),
                          Text(col.$1, style: context.t.titleMedium),
                          const SizedBox(width: 6),
                          Text('${col.$5.length}', style: context.t.bodySmall),
                        ],
                      ),
                    ),
                    if (col.$4 != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                        child: Text(col.$4!, style: context.t.bodySmall),
                      ),
                    Expanded(
                      child: col.$5.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(loading ? 'Loading…' : 'Nothing here.', style: context.t.bodySmall),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 24, left: 2, right: 2, top: 2),
                              itemCount: col.$5.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 8),
                              itemBuilder: (_, n) {
                                return _LiveCard(item: col.$5[n], now: now, logo: logoOf(col.$5[n]), onAction: onAction, onMenu: onMenu, onResume: onResume);
                              },
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Lays [child] out at least [minWidth] wide; when the pane is narrower it
/// scrolls sideways, with a scrollbar along the bottom.
class _HScroll extends StatefulWidget {
  const _HScroll({required this.minWidth, required this.child});

  final double minWidth;
  final Widget child;

  @override
  State<_HScroll> createState() => _HScrollState();
}

class _HScrollState extends State<_HScroll> {
  final _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => Scrollbar(
      controller: _ctrl,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        child: SizedBox(width: math.max(box.maxWidth, widget.minWidth), height: box.maxHeight, child: widget.child),
      ),
    ),
  );
}

/// A full card with its live state: terminal tab, Claude session, review run.
class _LiveCard extends ConsumerWidget {
  const _LiveCard({required this.item, required this.now, required this.onAction, required this.onMenu, required this.onResume, this.logo, this.onFold});

  final BoardItem item;
  final DateTime now;
  final Widget? logo;
  final VoidCallback? onFold;
  final void Function(BoardItem, CardAction) onAction;
  final void Function(BoardItem, CardMenu) onMenu;
  final void Function(BoardItem, String id, String? cwd) onResume;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i = item, id = i.triage.session;
    // Redraws when its terminal tab starts, waits or ends.
    final terms = ref.watch(terminalsProvider);
    final term = terms.running(i.card.key);
    final (review, key) = _cardReview(ref, i.card);
    final s = id == null ? null : withHook(ref.watch(sessionProgressProvider(id)).value, ref.watch(sessionHooksProvider.select((m) => m[id])));
    return LinkTarget(
      item: i,
      child: CardTile(
        item: i,
        now: now,
        logo: logo,
        onFold: onFold,
        onOpenLinked: (o) async {
          if (sourceUri(o.card) case final u?) await openLink(u, browserProfile(o.card, ref.read(settingsProvider).requireValue));
        },
        onUnlink: (o) {
          ref.read(boardProvider.notifier).setLink(i.card.key, o.card.key, false);
          showToast(context, 'Unlinked ${linkLabel(i.card)} and ${linkLabel(o.card)}');
        },
        session: s,
        term: term,
        termSelected: term != null && term == terms.selected && terms.shown,
        onTerm: term == null ? null : () => ref.read(terminalsProvider.notifier).focus(term),
        review: review,
        onOpenReview: key == null ? null : () => goReview(context, key.project, key.id),
        onAction: (a) => onAction(i, a),
        onMenu: (mm) => onMenu(i, mm),
        onResume: id == null ? null : () => onResume(i, id, s?.cwd),
      ),
    );
  }
}

/// Wraps a card: drag it, drop another card on it to link the two. While the
/// pointer is on a card, or its terminal tab is shown, its linked cards light
/// up in indigo.
class LinkTarget extends ConsumerWidget {
  const LinkTarget({super.key, required this.item, required this.child});

  final BoardItem item;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    bool linkedTo(String? key) => key != null && item.links.any((l) => l.item.card.key == key);
    // Selects, so moving the pointer redraws only the cards that light up or go dark.
    final lit =
        ref.watch(hoveredCardProvider.select(linkedTo)) || ref.watch(terminalsProvider.select((t) => linkedTo(t.shown ? t.selected?.info.cardKey : null)));
    final hover = ref.read(hoveredCardProvider.notifier);
    return MouseRegion(
      onEnter: (_) => hover.set(item.card.key),
      onExit: (_) => hover.leave(item.card.key),
      child: DragTarget<BoardItem>(
        onWillAcceptWithDetails: (d) => d.data.card.key != item.card.key && !linked(d.data, item),
        onAcceptWithDetails: (d) {
          ref.read(boardProvider.notifier).setLink(d.data.card.key, item.card.key, true);
          showToast(context, 'Linked ${linkLabel(d.data.card)} and ${linkLabel(item.card)}');
        },
        builder: (context, over, _) => Draggable<BoardItem>(
          data: item,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: DragGhost(item: item),
          childWhenDragging: Opacity(opacity: .35, child: child),
          child: Stack(
            children: [
              child,
              // Kept in the tree while nothing hovers, so the card keeps its state.
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: over.isNotEmpty
                          ? Border.all(color: c.blue, width: 2)
                          : lit
                          ? Border.all(color: c.indigo, width: 1.5)
                          : null,
                      color: over.isNotEmpty
                          ? c.blue.withValues(alpha: .06)
                          : lit
                          ? c.indigo.withValues(alpha: .07)
                          : null,
                    ),
                    child: over.isEmpty
                        ? (lit ? _linkedMark(context) : null)
                        : Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: c.blue, borderRadius: BorderRadius.circular(99)),
                              child: Text(
                                'Link',
                                style: context.t.bodySmall!.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The link icon on a card linked to the one you point at.
  Widget _linkedMark(BuildContext context) => Align(
    alignment: Alignment.bottomRight,
    child: Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: context.c.indigo, shape: BoxShape.circle),
      child: const Icon(Icons.link_rounded, size: 12, color: Colors.white),
    ),
  );
}

/// Flow: Next (ranked across types, the first one to do now), Doing, Waiting
/// and Done today. Long lists fold each card to a row; a click opens it.
class _FlowBoard extends StatefulWidget {
  const _FlowBoard({
    required this.flow,
    required this.now,
    required this.loading,
    required this.logoOf,
    required this.onAction,
    required this.onMenu,
    required this.onResume,
    required this.onDrop,
    required this.onSnoozed,
  });

  final FlowLists flow;
  final DateTime now;
  final bool loading;
  final Widget? Function(BoardItem) logoOf;
  final void Function(BoardItem, CardAction) onAction;
  final void Function(BoardItem, CardMenu) onMenu;
  final void Function(BoardItem, String id, String? cwd) onResume;
  final void Function(BoardItem, FlowDrop) onDrop;
  final VoidCallback onSnoozed;

  @override
  State<_FlowBoard> createState() => _FlowBoardState();
}

class _FlowBoardState extends State<_FlowBoard> {
  /// Keys of the folded cards you opened.
  final _open = <String>{};
  var _sweep = false;

  Widget _full(BoardItem i, {VoidCallback? onFold}) =>
      _LiveCard(item: i, now: widget.now, logo: widget.logoOf(i), onFold: onFold, onAction: widget.onAction, onMenu: widget.onMenu, onResume: widget.onResume);

  Widget _row(BoardItem i, {int? rank}) {
    if (_open.contains(i.card.key)) {
      return _full(i, onFold: () => setState(() => _open.remove(i.card.key)));
    }
    return LinkTarget(
      item: i,
      child: CardRow(
        item: i,
        now: widget.now,
        rank: rank,
        logo: widget.logoOf(i),
        onTap: () => setState(() => _open.add(i.card.key)),
        onMenu: (m) => widget.onMenu(i, m),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.flow, c = context.c;
    // Dropping a card on a column (not on a card) moves it there.
    Widget column(String title, String sub, List<Widget> children, {String? empty, FlowDrop? drop, String? dropLabel}) => Expanded(
      child: DragTarget<BoardItem>(
        onWillAcceptWithDetails: (d) => drop != null && canDrop(d.data, drop),
        onAcceptWithDetails: (d) => widget.onDrop(d.data, drop!),
        builder: (context, over, _) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(color: over.isEmpty ? Colors.transparent : c.blue.withValues(alpha: .07), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(title, style: context.t.titleMedium),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        over.isEmpty ? sub : dropLabel ?? sub,
                        overflow: TextOverflow.ellipsis,
                        style: over.isEmpty ? context.t.bodySmall : context.t.bodySmall!.copyWith(color: c.blue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24, left: 2, right: 2, top: 2),
                  children: [
                    if (children.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(widget.loading ? 'Loading…' : empty ?? 'Nothing here.', style: context.t.bodySmall),
                      ),
                    for (final (n, w) in children.indexed) ...[if (n > 0) const SizedBox(height: 8), w],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return _HScroll(
      minWidth: 4 * 280 + 44,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            column('Next', '${f.next.length} · ranked', drop: FlowDrop.next, dropLabel: 'Drop: back to Next', empty: 'Nothing next. You\'re all caught up.', [
              if (f.next.isNotEmpty) _full(f.next.first),
              for (final (n, i) in f.next.skip(1).indexed) _row(i, rank: n + 2),
              if (f.sweep.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: c.sep),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quick sweep', style: context.t.titleMedium?.copyWith(fontSize: 13.5)),
                            Text(sweepSummary(f.sweep), style: context.t.bodySmall),
                          ],
                        ),
                      ),
                      TextButton(onPressed: () => setState(() => _sweep = !_sweep), child: Text(_sweep ? 'Hide' : 'Sweep')),
                    ],
                  ),
                ),
                if (_sweep)
                  for (final i in f.sweep) _full(i),
              ],
            ]),
            column(
              'Doing',
              '${f.doing.length} of $doingMax',
              drop: FlowDrop.doing,
              dropLabel: 'Drop: start it',
              empty: 'Nothing started. Claude, IDE or Review on a card puts it here.',
              [
                for (final i in f.doing) _full(i),
                if (f.doing.length >= doingMax)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text('Full. Finish one before you start the next.', style: context.t.bodySmall?.copyWith(color: c.orange)),
                  ),
              ],
            ),
            column('Waiting', '${f.waiting.length} · on others', [
              for (final i in f.waiting) _row(i),
              if (f.snoozed > 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(onPressed: widget.onSnoozed, child: Text('${f.snoozed} snoozed')),
                ),
            ]),
            column('Done today', '${f.done.length}', drop: FlowDrop.done, dropLabel: 'Drop: mark done', empty: 'Nothing closed yet today.', [
              for (final i in f.done) _row(i),
            ]),
          ],
        ),
      ),
    );
  }
}

/// Focus: one thing now, large, with why it comes first; what you started in
/// a small row; then the queue. For when you do not want to choose at all.
class _FocusBoard extends StatelessWidget {
  const _FocusBoard({
    required this.flow,
    required this.now,
    required this.loading,
    required this.logoOf,
    required this.onAction,
    required this.onMenu,
    required this.onResume,
    required this.onBoard,
  });

  final FlowLists flow;
  final DateTime now;
  final bool loading;
  final Widget? Function(BoardItem) logoOf;
  final void Function(BoardItem, CardAction) onAction;
  final void Function(BoardItem, CardMenu) onMenu;
  final void Function(BoardItem, String id, String? cwd) onResume;
  final VoidCallback onBoard;

  @override
  Widget build(BuildContext context) {
    final f = flow, c = context.c;
    Widget label(String text, [String? sub]) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(text, style: context.t.titleMedium),
          if (sub != null) ...[const SizedBox(width: 8), Text(sub, style: context.t.bodySmall)],
        ],
      ),
    );
    final rest = [
      if (f.sweep.isNotEmpty) 'Quick sweep: ${plural(f.sweep.length, 'mail')}',
      if (f.waiting.isNotEmpty) '${f.waiting.length} waiting on others',
      if (f.snoozed > 0) '${f.snoozed} snoozed',
    ];
    if (f.next.isEmpty && f.doing.isEmpty && !loading) {
      return const _Empty(title: 'You\'re All Caught Up', text: 'Nothing waits on you right now.');
    }
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          children: [
            if (f.next.isNotEmpty) ...[
              label('Now', '1 of ${f.next.length} · ranked'),
              _LiveCard(item: f.next.first, now: now, logo: logoOf(f.next.first), onAction: onAction, onMenu: onMenu, onResume: onResume),
            ],
            if (f.doing.isNotEmpty) ...[
              label('Doing', '${f.doing.length} of $doingMax'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final i in f.doing)
                    ActionChip(
                      avatar: CircleAvatar(radius: 4, backgroundColor: accent(context, laneInfo(i.card.lane).color)),
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 260),
                        child: Text(i.card.title.isEmpty ? i.card.ref : i.card.title, overflow: TextOverflow.ellipsis),
                      ),
                      tooltip: i.card.next,
                      onPressed: () => onMenu(i, CardMenu.open),
                    ),
                ],
              ),
            ],
            if (f.next.length > 1) ...[
              label('Then'),
              for (final (n, i) in f.next.skip(1).indexed) ...[
                if (n > 0) const SizedBox(height: 8),
                LinkTarget(
                  item: i,
                  child: CardRow(item: i, now: now, rank: n + 2, logo: logoOf(i), onMenu: (m) => onMenu(i, m)),
                ),
              ],
            ],
            if (rest.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(rest.join(' · '), style: context.t.bodySmall?.copyWith(color: c.label2)),
                    ),
                    TextButton(onPressed: onBoard, child: const Text('See the board')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.title, required this.text, this.settings = false});

  final String title, text;
  final bool settings;

  @override
  Widget build(BuildContext context) => EmptyState(
    icon: settings ? Icons.tune_rounded : Icons.check_circle_outline_rounded,
    title: title,
    text: text,
    action: settings ? FilledButton(onPressed: () => context.go('/settings'), child: const Text('Open Settings')) : null,
  );
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.view, required this.items, required this.cfg, required this.board, required this.onView});

  final BoardView view;

  /// The cards that pass the filter, for the counts.
  final List<BoardItem> items;
  final DeckConfig cfg;
  final BoardState board;
  final ValueChanged<BoardView> onView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    Widget row(BoardView v, String label, IconData icon, String color, int? n, {bool? on}) => SidebarRow(
      label: label,
      selected: on ?? view == v,
      leading: AccentIcon(icon, accent(context, color), circle: true),
      trailing: n == null ? null : Text('$n', style: context.t.bodySmall),
      onTap: () => onView(v),
    );

    final status = [
      for (final id in cfg.providers.keys)
        if (cfg.providers[id]!.enabled && providerCatalog.any((p) => p.id == id))
          (id, providerInfo(id).name, board.snapshots[id] ?? const Snapshot(), board.busy.contains(id)),
    ];
    return Material(
      color: c.sidebar,
      child: Container(
        width: 252,
        padding: const EdgeInsets.fromLTRB(12, 26, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quarterdeck', style: context.t.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w700)),
                          Text('Everything on your plate', style: context.t.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SidebarSection('Views'),
                    row(BoardView.flow, 'Flow', Icons.view_week_outlined, 'blue', flowOf(items, clock.now()).next.length),
                    row(BoardView.focus, 'Focus', Icons.center_focus_strong_outlined, 'indigo', null),
                    row(BoardView.needs, 'By Type', Icons.view_column_outlined, 'purple', null, on: byTypeViews.contains(view)),
                    row(BoardView.activity, 'Activity', Icons.history_rounded, 'teal', null),
                    if (cfg.projects.isNotEmpty) ...[
                      const SidebarSection('Projects'),
                      for (final p in cfg.projects)
                        SidebarRow(
                          label: p.name,
                          selected: false,
                          leading: ProjectLogo(
                            file: logoFile(ref.watch(homeProvider), p),
                            platforms: p.platforms,
                            fallback: Icon(Icons.folder_outlined, size: 18, color: c.label2),
                          ),
                          trailing: switch (ref.watch(projectNewCountProvider(p.id)).value) {
                            final n? when n > 0 => Text('$n new', style: context.t.bodySmall?.copyWith(color: c.blue)),
                            _ => null,
                          },
                          onTap: () => goProject(context, p.id),
                        ),
                      const WorktreeList(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            for (final (id, name, snap, busy) in status)
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => context.go(Uri(path: '/settings', queryParameters: {'section': 'provider:$id'}).toString()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Tooltip(
                    message: snap.message ?? '',
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: busy
                              ? c.blue
                              : switch (snap.state) {
                                  SourceState.ok => c.green,
                                  SourceState.error => c.red,
                                  _ => c.label3,
                                },
                        ),
                        const SizedBox(width: 8),
                        Text(name, style: context.t.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(busy ? 'Fetching…' : snap.message ?? 'Not loaded yet', overflow: TextOverflow.ellipsis, style: context.t.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            TextButton.icon(
              style: TextButton.styleFrom(alignment: Alignment.centerLeft, foregroundColor: c.label2),
              onPressed: ref.read(terminalsProvider.notifier).toggle,
              icon: const Icon(Icons.terminal_rounded, size: 16),
              label: Consumer(
                builder: (context, ref, _) {
                  final terms = ref.watch(terminalsProvider);
                  return Row(
                    children: [
                      const Text('Terminals'),
                      const SizedBox(width: 6),
                      if (terms.waitingCount > 0)
                        Badge(label: Text('${terms.waitingCount} waiting'), backgroundColor: c.orange)
                      else if (terms.tabs.isNotEmpty)
                        Text('${terms.tabs.length}', style: context.t.bodySmall),
                    ],
                  );
                },
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(alignment: Alignment.centerLeft, foregroundColor: c.label2),
              onPressed: () => context.go('/settings'),
              icon: const Icon(Icons.settings_outlined, size: 16),
              label: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Deck review of a merge request card, and its key: null when the card
/// is not a merge request of a project whose repository is set.
(CardReview?, ReviewKey?) _cardReview(WidgetRef ref, DeckCard c) {
  if (c.iid == null) return (null, null);
  final p = workProject(c, ref.watch(settingsProvider).value?.projects ?? const []);
  if (p?.repo == null) return (null, null);
  final key = (project: p!.id, id: '${c.provider}-${c.iid}');
  final exists = ref.watch(projectReviewsProvider(p.id)).value?.any((r) => r.id == key.id) ?? false;
  final run = ref.watch(reviewsProvider).runs[key];
  final res = run?.result;
  final review = (
    exists: exists,
    running: run?.running ?? false,
    kind: run?.kind ?? '',
    step: res == null ? run?.step ?? '' : res.error ?? '',
    progress: run?.running ?? false ? run!.progress('steps', clock.now()) : null,
    failed: res?.error != null,
  );
  return (review, key);
}
