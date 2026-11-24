// The Deck terminal as a tool window, like IntelliJ's: docked at the bottom
// or on the right of every screen, resized by dragging its edge.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm2/xterm.dart';

import '../../state/project_info.dart' show logoFile;
import '../../state/project_talks.dart';
import '../../state/terminals.dart';
import '../../core/models/config.dart';
import '../../state/settings.dart';
import '../notices/notice_layer.dart';
import '../project/project_logo.dart';
import '../common.dart';
import '../theme.dart';

/// Puts [child] next to the terminal panel when the panel is shown. Hidden,
/// a pill on the window edge brings it back, on every screen. ⌘J (Ctrl+J
/// elsewhere) shows or hides it.
class TerminalDock extends ConsumerStatefulWidget {
  const TerminalDock({super.key, required this.child, this.project});
  final Widget child;

  /// Id of the project the screen shows, so + starts a session there.
  final String? project;

  @override
  ConsumerState<TerminalDock> createState() => _TerminalDockState();
}

class _TerminalDockState extends ConsumerState<TerminalDock> {
  @override
  void initState() {
    super.initState();
    // A global handler: the focused terminal would take the key otherwise.
    HardwareKeyboard.instance.addHandler(_onKey);
    // The sessions that ran when Deck quit come back, in their tabs.
    Future.microtask(() => ref.read(terminalsProvider.notifier).restore());
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent e) {
    final k = HardwareKeyboard.instance;
    if (e is! KeyDownEvent || e.logicalKey != LogicalKeyboardKey.keyJ) return false;
    if (!(Platform.isMacOS ? k.isMetaPressed : k.isControlPressed) || k.isShiftPressed || k.isAltPressed) return false;
    ref.read(terminalsProvider.notifier).toggle();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cfg = ref.watch(settingsProvider).value ?? const DeckConfig();
    final right = cfg.actions.terminalDock == 'right';
    final terms = ref.watch(terminalsProvider);
    final notifier = ref.read(terminalsProvider.notifier);
    return LayoutBuilder(
      builder: (context, box) {
        final total = right ? box.maxWidth : box.maxHeight;
        final max = total - 200;
        final share = terms.dragged ?? (right ? cfg.actions.terminalRight : cfg.actions.terminalBottom);
        final size = terms.full ? total - _edge : (share * total).clamp(120.0, max < 120 ? 120.0 : max);
        final edge = MouseRegion(
          cursor: right ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (d) => notifier.resize((size - (right ? d.delta.dx : d.delta.dy)) / total),
            onPanEnd: (_) async {
              final s = size / total;
              await ref
                  .read(settingsProvider.notifier)
                  .change(
                    (c) => c.copyWith(
                      actions: right ? c.actions.copyWith(terminalRight: s) : c.actions.copyWith(terminalBottom: s),
                    ),
                  );
              notifier.resize(null);
            },
            child: SizedBox(
              width: right ? _edge : null,
              height: right ? null : _edge,
              child: const Center(child: Divider(height: 1, thickness: 1)),
            ),
          ),
        );
        final panel = SizedBox(
          width: right ? size : null,
          height: right ? null : size,
          child: _Panel(right: right, cfg: cfg, project: widget.project),
        );
        // The content stays first in the same Flex whether the panel shows,
        // hides or goes full size, so it keeps its state.
        final content = Expanded(
          child: Offstage(offstage: terms.shown && terms.full, child: widget.child),
        );
        final Widget pill;
        final double at;
        if (terms.shown) {
          // On the edge, centered across it, over both sides.
          at = (total - size - _edge / 2 - _EdgePill.thickness / 2).clamp(0.0, total - _EdgePill.thickness);
          pill = _EdgePill(right: right, full: terms.full, onFull: notifier.setFull, onHide: notifier.toggle);
        } else {
          at = total - _EdgePill.thickness - 4;
          pill = _ShowPill(right: right, tabs: terms.tabs.length, waiting: terms.waitingCount, onTap: notifier.toggle);
        }
        // The notification bell rides beside the pill, on every screen.
        final pills = Flex(
          direction: right ? Axis.vertical : Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            const NoticeBell(height: _EdgePill.thickness),
            const SizedBox(width: 6, height: 6),
            pill,
          ],
        );
        return Stack(
          children: [
            Flex(
              direction: right ? Axis.horizontal : Axis.vertical,
              children: [
                content,
                if (terms.shown) ...[edge, panel],
              ],
            ),
            if (right)
              Positioned(
                top: 0,
                bottom: 0,
                left: at,
                child: Center(child: pills),
              )
            else
              Positioned(
                left: 0,
                right: 0,
                top: at,
                child: Center(child: pills),
              ),
          ],
        );
      },
    );
  }
}

/// The hidden panel, on the window edge where it docks: the tabs it holds,
/// orange when one waits for you. A click shows it.
class _ShowPill extends StatelessWidget {
  const _ShowPill({required this.right, required this.tabs, required this.waiting, required this.onTap});
  final bool right;
  final int tabs, waiting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final label = ['Terminals', if (waiting > 0) '$waiting waiting' else if (tabs > 0) '$tabs'].join(' · ');
    final pill = Material(
      color: waiting > 0 ? c.waitingTint(c.card) : c.card,
      shape: StadiumBorder(side: BorderSide(color: waiting > 0 ? c.orange : c.sep)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: _EdgePill.thickness,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.keyboard_arrow_up_rounded, size: 16, color: c.label2),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: context.t.bodySmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: waiting > 0 ? c.orange : c.label2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return Tooltip(
      message: Platform.isMacOS ? 'Show terminals (⌘J)' : 'Show terminals (Ctrl+J)',
      waitDuration: const Duration(milliseconds: 500),
      // Docked on the right it stands on the right edge, read bottom to top.
      child: right ? RotatedBox(quarterTurns: 3, child: pill) : pill,
    );
  }
}

/// Thickness of the drag edge between the content and the panel.
const _edge = 5.0;

/// On the edge: an arrow toward the content gives the panel the whole window,
/// an arrow toward the terminal hides it. At full size the first one restores.
/// Its arrows are faint until the mouse is over it.
class _EdgePill extends StatefulWidget {
  const _EdgePill({required this.right, required this.full, required this.onFull, required this.onHide});
  final bool right, full;
  final void Function(bool) onFull;
  final VoidCallback onHide;

  static const thickness = 22.0;

  @override
  State<_EdgePill> createState() => _EdgePillState();
}

class _EdgePillState extends State<_EdgePill> {
  var _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.c, right = widget.right, full = widget.full;
    // Toward the content: up, or left when docked on the right.
    final toContent = right ? Icons.keyboard_arrow_left_rounded : Icons.keyboard_arrow_up_rounded;
    final toTerminal = right ? Icons.keyboard_arrow_right_rounded : Icons.keyboard_arrow_down_rounded;
    final hideAll = right ? Icons.keyboard_double_arrow_right_rounded : Icons.keyboard_double_arrow_down_rounded;
    Widget button(IconData icon, String tip, VoidCallback onTap) => Tooltip(
      message: tip,
      waitDuration: const Duration(milliseconds: 500),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: SizedBox.square(
          dimension: _EdgePill.thickness,
          child: Icon(icon, size: 16, color: _hover ? c.label : c.label3),
        ),
      ),
    );
    final buttons = [
      if (full) button(toTerminal, 'Restore', () => widget.onFull(false)) else button(toContent, 'Full size', () => widget.onFull(true)),
      button(full ? hideAll : toTerminal, 'Hide', widget.onHide),
    ];
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: c.card,
        shape: StadiumBorder(side: BorderSide(color: _hover ? c.label3 : c.sep)),
        clipBehavior: Clip.antiAlias,
        child: Flex(direction: right ? Axis.vertical : Axis.horizontal, mainAxisSize: MainAxisSize.min, children: buttons),
      ),
    );
  }
}

class _Panel extends ConsumerWidget {
  const _Panel({required this.right, required this.cfg, this.project});
  final bool right;
  final DeckConfig cfg;
  final String? project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terms = ref.watch(terminalsProvider);
    final notifier = ref.read(terminalsProvider.notifier);
    final tabs = terms.tabs;
    void move(String dock) => ref.read(settingsProvider.notifier).save(cfg.copyWith(actions: cfg.actions.copyWith(terminalDock: dock)));
    return Material(
      child: Column(
        children: [
          TerminalTabStrip(
            tabs: [for (final t in tabs) (info: t.info, dir: t.dir, exited: t.exited, waiting: t.waiting, working: t.working)],
            current: terms.current,
            onSelect: notifier.select,
            onClose: notifier.close,
            add: _NewSession(cfg: cfg, project: project),
            trailing: [
              PopupMenuButton<String>(
                tooltip: 'Move to',
                icon: const Icon(Icons.more_vert_rounded, size: 18),
                onSelected: move,
                itemBuilder: (_) => [
                  CheckedPopupMenuItem(value: 'bottom', checked: !right, child: const Text('Dock at the bottom')),
                  CheckedPopupMenuItem(value: 'right', checked: right, child: const Text('Dock on the right')),
                ],
              ),
            ],
          ),
          Expanded(
            child: tabs.isEmpty
                ? ColoredBox(
                    color: terminalBackground,
                    child: Center(
                      child: Text('No session running. Start one with +.', style: context.t.bodyMedium!.copyWith(color: DeckColors.dark.label2)),
                    ),
                  )
                : IndexedStack(
                    index: terms.current,
                    children: [for (final t in tabs) _View(key: ObjectKey(t), tab: t)],
                  ),
          ),
        ],
      ),
    );
  }
}

/// The + after the tabs: a new Claude session in the Deck folder or in a
/// project's folder, as a talk about that project.
class _NewSession extends ConsumerWidget {
  const _NewSession({required this.cfg, this.project});
  final DeckConfig cfg;

  /// Id of the project on screen, if any.
  final String? project;

  /// Menu value of the Deck folder. A null value would read as cancelled.
  static const _deck = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final talker = ref.read(projectTalkerProvider.notifier);
    final projects = [
      for (final p in cfg.projects)
        if (p.dir != null) p,
    ];
    final here = projects.where((p) => p.id == project).firstOrNull;
    Future<void> start(String? id) async {
      if (id == null) return;
      try {
        if (id == _deck) return await talker.openDeck();
        await talker.open(projects.firstWhere((p) => p.id == id));
      } catch (e) {
        if (context.mounted) {
          showToast(context, 'Could not start the session: $e');
        }
      }
    }

    // The menu opens under the button, wherever it was clicked.
    Future<void> menu() async {
      final box = context.findRenderObject()! as RenderBox;
      final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
      final at = RelativeRect.fromRect(
        Rect.fromPoints(
          box.localToGlobal(box.size.bottomLeft(Offset.zero), ancestor: overlay),
          box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );
      final id = await showMenu<String>(
        context: context,
        position: at,
        items: [
          const PopupMenuItem(
            value: _deck,
            child: Row(children: [Icon(Icons.folder_outlined, size: 18), SizedBox(width: 10), Text('Quarterdeck')]),
          ),
          if (projects.isNotEmpty) const PopupMenuDivider(),
          for (final p in projects)
            PopupMenuItem(
              value: p.id,
              child: Row(
                children: [
                  ProjectLogo(file: logoFile(home, p), platforms: p.platforms, size: 18),
                  const SizedBox(width: 10),
                  Text(p.name),
                ],
              ),
            ),
        ],
      );
      await start(id);
    }

    // On a project's screens a click starts a talk about it; elsewhere it
    // asks where. A right click always asks.
    return GestureDetector(
      onSecondaryTap: menu,
      child: IconButton(
        tooltip: here == null ? 'New session' : 'New session in ${here.name}. Right click to choose another.',
        icon: const Icon(Icons.add_rounded, size: 18),
        onPressed: here == null ? menu : () => start(here.id),
      ),
    );
  }
}

/// What a tab shows of its session.
typedef TabData = ({TermInfo info, String dir, bool exited, bool waiting, bool working});

/// Background of the terminal, which the selected tab shares.
final terminalBackground = TerminalThemes.defaultTheme.background;

/// The tab strip, darker than the terminal so the selected tab stands out.
const _stripBackground = Color(0xFF111111);

/// The tab row, like Chrome's: a strip darker than the terminal, the selected
/// tab in the terminal's color and open at the bottom, so it runs into it.
/// Always dark, like the terminal, in both app themes.
class TerminalTabStrip extends StatelessWidget {
  const TerminalTabStrip({
    super.key,
    required this.tabs,
    required this.current,
    required this.onSelect,
    required this.onClose,
    this.add,
    this.trailing = const [],
  });
  final List<TabData> tabs;
  final int current;
  final void Function(int) onSelect, onClose;

  /// Right after the last tab, like Chrome's +.
  final Widget? add;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) => Theme(
    data: deckTheme(Brightness.dark),
    child: ColoredBox(
      color: _stripBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 6, top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final (i, t) in tabs.indexed)
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: _Tab(tab: t, selected: i == current, onTap: () => onSelect(i), onClose: () => onClose(i)),
                    ),
                  if (add case final a?) Padding(padding: const EdgeInsets.only(left: 2, bottom: 4), child: a),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(children: trailing),
          ),
        ],
      ),
    ),
  );
}

/// One tab: the card ref and what was started, the card title under it.
/// Orange and pulsing while the session waits for you.
class _Tab extends StatelessWidget {
  const _Tab({required this.tab, required this.selected, required this.onTap, required this.onClose});
  final TabData tab;
  final bool selected;
  final VoidCallback onTap, onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.c, info = tab.info;
    final color = tab.exited
        ? c.label3
        : tab.waiting
        ? c.orange
        : c.green;
    final status = tab.exited
        ? 'Ended'
        : tab.waiting
        ? 'Waits for you'
        : tab.working
        ? 'Working'
        : 'Running';
    const radius = BorderRadius.vertical(top: Radius.circular(8));
    final base = selected ? terminalBackground : Colors.transparent;
    final body = Material(
      color: tab.waiting ? c.waitingTint(base) : base,
      shape: const RoundedRectangleBorder(borderRadius: radius),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 4, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // One fixed slot for every state, so the tab keeps its size.
              SizedBox.square(
                dimension: 15,
                child: Center(
                  child: tab.working && !tab.waiting && !tab.exited
                      ? SizedBox.square(dimension: 11, child: CircularProgressIndicator(strokeWidth: 1.8, color: color))
                      : Icon(
                          tab.waiting
                              ? Icons.keyboard_alt_outlined
                              : tab.exited
                              ? Icons.stop_circle_outlined
                              : Icons.circle,
                          size: tab.waiting ? 15 : 9,
                          color: color,
                        ),
                ),
              ),
              const SizedBox(width: 7),
              if (info.logo case final logo?) ...[ProjectLogo(file: logo, platforms: info.platforms, size: 18), const SizedBox(width: 6)],
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      [info.title, ?info.action].join(' · '),
                      overflow: TextOverflow.ellipsis,
                      style: context.t.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? c.label : c.label2),
                    ),
                    if (info.detail case final d?) Text(d, overflow: TextOverflow.ellipsis, style: context.t.bodySmall?.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 14),
                tooltip: tab.exited ? 'Close' : 'Stop and close',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
    return Tooltip(
      message: [status, ?info.detail, tab.dir].join('\n'),
      waitDuration: const Duration(milliseconds: 500),
      child: tab.waiting ? _Pulse(child: body) : body,
    );
  }
}

/// Fades [child] in and out, to catch the eye.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});
  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900), lowerBound: .45)..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _c, child: widget.child);
}

class _View extends StatefulWidget {
  const _View({super.key, required this.tab});
  final TermTab tab;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _controller = TerminalController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Right click copies the selection, or pastes when there is none.
  Future<void> _copyPaste() async {
    final t = widget.tab.terminal;
    if (_controller.selection case final s?) {
      await Clipboard.setData(ClipboardData(text: t.buffer.getText(s)));
      _controller.clearSelection();
    } else if ((await Clipboard.getData('text/plain'))?.text case final text?) {
      t.paste(text);
    }
  }

  @override
  Widget build(BuildContext context) => TerminalView(
    widget.tab.terminal,
    controller: _controller,
    autofocus: true,
    padding: const EdgeInsets.all(8),
    textStyle: const TerminalStyle(fontFamily: 'Menlo', fontSize: 13),
    // Claude Code tracks the mouse: without these a drag goes to it and
    // selects nothing. Clicks and the wheel still reach it.
    dragOverridesMouseReporting: true,
    shiftOverridesMouseReporting: true,
    onSecondaryTapDown: (_, _) => _copyPaste(),
  );
}
