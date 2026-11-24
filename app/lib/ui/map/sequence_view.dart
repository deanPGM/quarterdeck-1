// A feature's flow as a sequence diagram played step by step, drawn natively
// from the agent's mermaid source: numbered rows to click, Play, arrow keys,
// and beside the picture every step with the agent's comment, the current one
// open. Port of Skim's Diagram.tsx player. Pure widget: data and callbacks.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/map/mermaid.dart';
import '../../core/map/models.dart';
import '../theme.dart';
import 'diagram_paint.dart';

typedef OpenCode = void Function(String path, int? line);

/// What a mark on a step says, and its colour.
({String label, String legend, String mean, Color color}) markOf(BuildContext context, String mark) => mark == 'concern'
    ? (label: 'Look here', legend: 'Look here', mean: 'The agent thinks this step deserves a hard look.', color: context.c.orange)
    : (label: 'Touched', legend: 'Touched by this change', mean: 'This change added or changed this step.', color: context.c.green);

/// An onAccent glyph in a coloured disc: the mark of a step.
class MarkGlyph extends StatelessWidget {
  const MarkGlyph(this.mark, {super.key, this.size = 14});
  final String mark;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _GlyphPainter(mark, markOf(context, mark).color, context.c.onAccent));
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.mark, this.color, this.ink);
  final String mark;
  final Color color, ink;

  @override
  void paint(Canvas canvas, Size size) => paintGlyph(canvas, size.center(Offset.zero), size.width / 2, mark, color, ink);

  @override
  bool shouldRepaint(_GlyphPainter old) => old.mark != mark || old.color != color || old.ink != ink;
}

void paintGlyph(Canvas canvas, Offset c, double r, String mark, Color color, Color ink) {
  canvas.drawCircle(c, r, Paint()..color = color);
  final p = Paint()
    ..color = ink
    ..strokeWidth = r * .25
    ..strokeCap = StrokeCap.round;
  final s = r * .45;
  if (mark == 'concern') {
    canvas.drawLine(c + Offset(0, -s), c + Offset(0, s * .25), p);
    canvas.drawCircle(c + Offset(0, s * .85), r * .12, Paint()..color = ink);
  } else {
    canvas.drawLine(c + Offset(-s, 0), c + Offset(s, 0), p);
    canvas.drawLine(c + Offset(0, -s), c + Offset(0, s), p);
  }
}

class SequencePlayer extends StatefulWidget {
  const SequencePlayer({super.key, required this.sequence, this.onOpen});
  final MapSequence sequence;

  /// Opens a step's code. Without it the path shows as plain text.
  final OpenCode? onOpen;

  @override
  State<SequencePlayer> createState() => _SequencePlayerState();
}

class _SequencePlayerState extends State<SequencePlayer> {
  late SequenceDiagram _d = parseSequence(widget.sequence.mermaid);
  final _focus = FocusNode(debugLabel: 'sequence');
  final _keys = <GlobalKey>[];
  var _step = -1, _hover = -1, _speed = 1;
  var _playing = false, _copied = false;
  Timer? _timer, _copyTimer;

  List<SeqMessage> get _messages => _d.messages;
  int get _count => _messages.length;

  @override
  void didUpdateWidget(SequencePlayer old) {
    super.didUpdateWidget(old);
    if (old.sequence.mermaid != widget.sequence.mermaid) {
      _d = parseSequence(widget.sequence.mermaid);
      _stop();
      _step = math.min(_step, _count - 1);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _copyTimer?.cancel();
    _focus.dispose();
    super.dispose();
  }

  void _stop() {
    _timer?.cancel();
    _playing = false;
  }

  void _go(int i) => setState(() {
    _stop();
    _step = i.clamp(-1, _count - 1);
    _reveal();
  });

  // Play: one step, a pause long enough to read the comment, the next.
  void _schedule() {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: _step < 0 ? 0 : 2200 ~/ _speed), () {
      if (!mounted) return;
      setState(() {
        _step++;
        _reveal();
        if (_step >= _count - 1) {
          _playing = false;
        } else {
          _schedule();
        }
      });
    });
  }

  void _play() => setState(() {
    if (_playing) return _stop();
    if (_step >= _count - 1) _step = -1;
    _playing = true;
    _schedule();
  });

  /// Keeps the current step in sight in the list beside the picture.
  void _reveal() => WidgetsBinding.instance.addPostFrameCallback((_) {
    final ctx = _step >= 0 && _step < _keys.length ? _keys[_step].currentContext : null;
    if (ctx == null || !ctx.mounted) return;
    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 200), alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd);
  });

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.sequence.mermaid));
    _copyTimer?.cancel();
    setState(() => _copied = true);
    _copyTimer = Timer(const Duration(milliseconds: 1500), () => mounted ? setState(() => _copied = false) : null);
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.arrowRight || k == LogicalKeyboardKey.arrowDown) {
      _go(_step + 1);
    } else if (k == LogicalKeyboardKey.arrowLeft || k == LogicalKeyboardKey.arrowUp) {
      _go(math.max(0, _step - 1));
    } else if (k == LogicalKeyboardKey.escape) {
      _go(-1);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = context.t;
    final steps = widget.sequence.steps;
    final small = t.bodySmall!;
    if (_d.participants.isEmpty) {
      return _Frame(
        caption: widget.sequence.caption,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('This diagram does not parse as a sequence.', style: small.copyWith(color: c.red)),
                const SizedBox(height: 4),
                SelectableText(widget.sequence.mermaid, style: mono(small)),
              ],
            ),
          ),
        ],
      );
    }
    while (_keys.length < _count) {
      _keys.add(GlobalKey());
    }
    final layout = _SeqLayout(context, _d, steps);
    final picture = Focus(
      focusNode: _focus,
      onKeyEvent: _key,
      child: FitWidth(
        size: layout.size,
        padding: 0,
        minScale: .8,
        button: Alignment.bottomLeft,
        child: MouseRegion(
          cursor: _hover >= 0 ? SystemMouseCursors.click : MouseCursor.defer,
          onHover: (e) {
            final h = layout.rowAt(e.localPosition.dy);
            if (h != _hover) setState(() => _hover = h);
          },
          onExit: (_) => setState(() => _hover = -1),
          child: GestureDetector(
            onTapUp: (e) {
              _focus.requestFocus();
              final i = layout.rowAt(e.localPosition.dy);
              if (i >= 0) _go(i == _step ? -1 : i);
            },
            child: CustomPaint(
              size: layout.size,
              painter: _SeqPainter(layout, c, step: _step, hover: _hover),
            ),
          ),
        ),
      ),
    );
    final list = [
      for (var i = 0; i < _count; i++)
        _StepItem(
          key: _keys[i],
          index: i,
          message: _messages[i],
          step: i < steps.length ? steps[i] : null,
          names: {for (final p in _d.participants) p.id: p.label},
          current: i == _step,
          future: _step >= 0 && i > _step,
          onTap: () => _go(i == _step ? -1 : i),
          onOpen: widget.onOpen,
        ),
    ];
    final marks = [
      for (final m in stepMarks)
        if (steps.any((s) => s.mark == m)) m,
    ];

    return _Frame(
      caption: widget.sequence.caption,
      children: [
        if (_count > 0) _toolbar(context, steps),
        LayoutBuilder(
          builder: (context, box) {
            final legend = _count == 0 ? const SizedBox() : _legend(context, marks);
            if (_count == 0) return picture;
            // Too many lifelines for the room beside the steps: the picture takes the whole width, the steps go under it.
            if (box.maxWidth < 760 || FitWidth.scaleIn(layout.size, box.maxWidth - 300, padding: 0, minScale: .5) < .85) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  picture,
                  legend,
                  Divider(height: 1, color: c.sep),
                  _listHeader(context),
                  Padding(padding: const EdgeInsets.all(6), child: columns(list, box.maxWidth - 12)),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [picture, legend]),
                ),
                Container(
                  width: 300,
                  height: (layout.size.height + 30).clamp(260, 640),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: c.sep)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _listHeader(context),
                      Expanded(
                        child: ListView(primary: false, padding: const EdgeInsets.all(6), children: list),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        if (_count > 0 && steps.isNotEmpty && steps.length != _count)
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.sep)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'The agent wrote ${steps.length} comments for $_count steps, so some comments may sit on the wrong arrow.',
              style: small.copyWith(fontSize: 11, color: c.orange),
            ),
          ),
      ],
    );
  }

  Widget _listHeader(BuildContext context) {
    final style = context.t.bodySmall!.copyWith(fontSize: 11);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.c.sep)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(_step >= 0 ? 'Step ${_step + 1} of $_count' : '$_count steps', style: style)),
          Text('Click a step to follow it', style: style),
        ],
      ),
    );
  }

  Widget _toolbar(BuildContext context, List<DiagramStep> steps) => LayoutBuilder(builder: (context, box) => _bar(context, steps, box.maxWidth < 620));

  Widget _bar(BuildContext context, List<DiagramStep> steps, bool compact) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.sep)),
      ),
      child: Row(
        children: [
          _Pill(label: _playing ? 'Pause' : 'Play', icon: _playing ? Icons.pause : Icons.play_arrow, filled: true, onTap: _play),
          const SizedBox(width: 6),
          _Pill(icon: Icons.chevron_left, tip: 'Previous step', onTap: () => _go(math.max(0, _step - 1))),
          const SizedBox(width: 4),
          _Pill(icon: Icons.chevron_right, tip: 'Next step', onTap: () => _go(_step + 1)),
          const SizedBox(width: 4),
          _Pill(icon: Icons.view_list, label: compact ? null : 'Overview', tip: 'Show all steps', onTap: () => _go(-1)),
          const SizedBox(width: 6),
          for (final s in [1, 2]) ...[
            _Pill(label: '$s×', tip: 'Speed', selected: _speed == s, onTap: () => setState(() => _speed = s)),
            const SizedBox(width: 2),
          ],
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < _count; i++)
                  Expanded(
                    child: Tooltip(
                      message: 'Step ${i + 1}: ${i < steps.length ? steps[i].title : _messages[i].text}',
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _go(i),
                          child: Container(
                            height: 22,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 1.5),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: i == _step ? 12 : 5,
                              decoration: BoxDecoration(
                                color: (i < steps.length && steps[i].mark != null ? markOf(context, steps[i].mark!).color : c.blue).withValues(
                                  alpha: _step >= 0 && i > _step ? .25 : 1,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Pill(
            icon: _copied ? Icons.check : Icons.copy,
            label: compact ? null : (_copied ? 'Copied' : 'Copy Mermaid'),
            tip: 'Copy the mermaid source',
            onTap: _copy,
          ),
        ],
      ),
    );
  }

  Widget _legend(BuildContext context, List<String> marks) {
    final c = context.c, style = context.t.bodySmall!.copyWith(fontSize: 11);
    Widget line(bool dashedLine) => CustomPaint(size: const Size(20, 8), painter: _LegendLine(dashedLine ? c.label2 : c.label, dashedLine));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.sep)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              line(false),
              const SizedBox(width: 5),
              Text('Call', style: style),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              line(true),
              const SizedBox(width: 5),
              Text('Reply', style: style),
            ],
          ),
          for (final m in marks)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MarkGlyph(m, size: 12),
                const SizedBox(width: 4),
                Text(markOf(context, m).legend, style: style),
              ],
            ),
          Text('Click a row or a step to read it.', style: style.copyWith(color: c.label3)),
        ],
      ),
    );
  }
}

class _LegendLine extends CustomPainter {
  _LegendLine(this.color, this.dash);
  final Color color;
  final bool dash;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2);
    canvas.drawPath(
      dash ? dashed(p, dash: 3, gap: 2.5) : p,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_LegendLine old) => old.color != color;
}

/// The bordered box the player sits in, with its caption under it.
class _Frame extends StatelessWidget {
  const _Frame({required this.children, required this.caption});
  final List<Widget> children;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.card,
        border: Border.all(color: c.sep),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...children,
          if (caption.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.sep)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(caption, textAlign: TextAlign.center, style: context.t.bodySmall!.copyWith(fontSize: 11)),
            ),
        ],
      ),
    );
  }
}

/// A small rounded button of the toolbar.
class _Pill extends StatelessWidget {
  const _Pill({this.label, this.icon, this.tip, this.filled = false, this.selected = false, required this.onTap});
  final String? label, tip;
  final IconData? icon;
  final bool filled, selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final fg = filled ? c.onAccent : (selected ? c.label : c.blue);
    final pill = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 24,
          constraints: BoxConstraints(minWidth: filled ? 72 : 24),
          padding: EdgeInsets.symmetric(horizontal: label == null ? 2 : 9),
          decoration: BoxDecoration(
            color: filled ? c.blue : (selected ? c.card : c.fill),
            border: selected ? Border.all(color: c.sep) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, size: 15, color: fg),
              if (icon != null && label != null) const SizedBox(width: 3),
              if (label != null) Text(label!, style: context.t.labelSmall!.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
    return tip == null ? pill : Tooltip(message: tip!, child: pill);
  }
}

/// One step in the list beside the picture: number, title and a short line.
/// The current one opens to the whole comment, the route and the code link.
class _StepItem extends StatelessWidget {
  const _StepItem({
    super.key,
    required this.index,
    required this.message,
    required this.step,
    required this.names,
    required this.current,
    required this.future,
    required this.onTap,
    this.onOpen,
  });
  final int index;
  final SeqMessage message;
  final DiagramStep? step;
  final Map<String, String> names;
  final bool current, future;
  final VoidCallback onTap;
  final OpenCode? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = context.t, s = step;
    final mark = s?.mark == null ? null : markOf(context, s!.mark!);
    final small = t.bodySmall!.copyWith(fontSize: 11);
    final head = AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: future ? .5 : 1,
      child: DiagramListItem(
        current: current,
        joined: current,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepNumber(index, current: current, ring: mark?.color ?? Colors.transparent),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          s?.title ?? message.text,
                          style: t.bodyMedium!.copyWith(fontSize: 12, height: 1.3, fontWeight: current ? FontWeight.w600 : FontWeight.w500),
                        ),
                      ),
                      if (s?.mark != null) ...[const SizedBox(width: 4), MarkGlyph(s!.mark!)],
                    ],
                  ),
                  if (!current && (s?.detail ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(s!.detail, maxLines: 2, overflow: TextOverflow.ellipsis, style: small),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (!current) return head;
    final from = names[message.from] ?? message.from, to = names[message.to] ?? message.to;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        head,
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          decoration: BoxDecoration(
            border: Border.all(color: c.sep),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mark != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: mark.color.withValues(alpha: .1),
                    border: Border.all(color: mark.color.withValues(alpha: .4)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarkGlyph(s!.mark!),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${mark.label}${s.severity == null ? '' : ' · ${s.severity}'}',
                              style: t.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            Text(mark.mean, style: small),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Wrap(
                spacing: 4,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: message.self
                    ? [Text('Inside', style: small), DiagramChip(from)]
                    : [DiagramChip(from), Text('→', style: small), DiagramChip(to), Text(message.dashed ? '  Reply' : '  Call', style: small)],
              ),
              if ((s?.detail ?? '').isNotEmpty) ...[const SizedBox(height: 8), Text(s!.detail, style: t.bodyMedium!.copyWith(fontSize: 12.5))],
              if ((s?.why ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Divider(height: 1, color: c.sep),
                const SizedBox(height: 6),
                Labeled('Why it matters', s!.why),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (message.text.isNotEmpty) DiagramChip(message.text.replaceAll('\n', ' '), code: true),
                  if (s?.path != null) CodeLink(path: s!.path!, line: s.line, onOpen: onOpen),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Layout constants, in logical pixels.
const _gutter = 40.0, _pad = 16.0, _labelMax = 180.0, _noteMax = 200.0, _loop = 30.0;

class _Row {
  _Row(this.top, this.bottom, this.y);
  final double top, bottom;

  /// The arrow's height, or the top of a self loop.
  final double y;
}

class _Block {
  _Block(this.start, this.top);
  final SeqBlockStart start;
  final double top;
  double bottom = 0, left = double.infinity, right = -double.infinity;
  int depth = 0;
  final splits = <(double, TextPainter)>[];
  final children = <_Block>[];
  TextPainter? tab;
}

class _NoteBox {
  _NoteBox(this.rect, this.text, this.item);
  final Rect rect;
  final TextPainter text;
  final int item;
}

/// Where everything goes, measured once per build with the theme's text styles.
class _SeqLayout {
  _SeqLayout(BuildContext context, this.d, this.steps) {
    final c = context.c, t = context.t;
    final label = t.bodySmall!.copyWith(fontSize: 11.5, color: c.label, height: 1.25);
    final name = t.bodyMedium!.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.2);
    final idx = {for (final (i, p) in d.participants.indexed) p.id: i};
    final n = d.participants.length;
    names = [for (final p in d.participants) textPainter(breakable(p.label), name, maxWidth: 140, maxLines: 3, align: TextAlign.center)];
    final bw = [for (final p in names) math.max(p.width + 24, 84.0)];
    headH = names.map((p) => p.height + 16).fold(34.0, math.max) + (d.participants.any((p) => p.actor) ? 22 : 0);

    // Lifelines: far enough apart for every label between them.
    final need = <(int, int, double)>[for (var i = 0; i + 1 < n; i++) (i, i + 1, bw[i] / 2 + bw[i + 1] / 2 + 24)];
    var leftNeed = 0.0, rightNeed = 0.0;
    for (final it in d.items) {
      switch (it) {
        case SeqMessage m:
          final w = textPainter(breakable(m.text), label, maxWidth: _labelMax).width;
          final a = idx[m.from]!, b = idx[m.to]!;
          if (a == b) {
            if (a + 1 < n) need.add((a, a + 1, _loop + w + 22));
            if (a == n - 1) rightNeed = math.max(rightNeed, _loop + w + 16);
          } else {
            need.add((math.min(a, b), math.max(a, b), w + 36));
          }
        case SeqNote note:
          final w = textPainter(note.text, label, maxWidth: _noteMax).width + 16;
          final a = idx[note.over.first]!;
          if (note.side == 'right') {
            a + 1 < n ? need.add((a, a + 1, w + 20)) : rightNeed = math.max(rightNeed, w + 14);
          } else if (note.side == 'left') {
            a > 0 ? need.add((a - 1, a, w + 20)) : leftNeed = math.max(leftNeed, w + 14);
          } else if (note.over.length == 1) {
            if (a + 1 < n) need.add((a, a + 1, w / 2 + bw[a + 1] / 2 + 12));
            if (a > 0) need.add((a - 1, a, w / 2 + bw[a - 1] / 2 + 12));
          }
        default:
      }
    }
    final x0 = _gutter + _pad + math.max(bw.isEmpty ? 0 : bw[0] / 2, leftNeed);
    x = List.generate(n, (i) => x0);
    need.sort((a, b) => a.$2 - b.$2);
    for (var i = 1; i < n; i++) {
      x[i] = x[i - 1];
      for (final (a, b, w) in need) {
        if (b == i) x[i] = math.max(x[i], x[a] + w);
      }
    }
    this.bw = bw;

    // Rows top to bottom.
    var y = _pad + headH + 18;
    final open = <_Block>[];
    void widen(double l, double r) {
      for (final b in open) {
        b.left = math.min(b.left, l);
        b.right = math.max(b.right, r);
      }
    }

    var right = n == 0 ? 0.0 : x.last + bw.last / 2 + rightNeed;
    for (final (i, it) in d.items.indexed) {
      switch (it) {
        case SeqMessage m:
          final a = x[idx[m.from]!], b = x[idx[m.to]!];
          final tp = textPainter(breakable(m.text), label, maxWidth: _labelMax, align: m.self ? TextAlign.left : TextAlign.center);
          messageText.add(tp);
          messageItem.add(i);
          if (m.self) {
            final h = math.max(20.0, tp.height + 6);
            rows.add(_Row(y, y + h + 8, y + 4));
            widen(a, a + _loop + tp.width + 8);
            right = math.max(right, a + _loop + tp.width + 16);
            y += h + 18;
          } else {
            final arrow = y + tp.height + 5;
            rows.add(_Row(y - 2, arrow + 6, arrow));
            widen(math.min(a, b), math.max(a, b));
            y = arrow + 18;
          }
        case SeqNote note:
          final tp = textPainter(note.text, label, maxWidth: _noteMax);
          final w = tp.width + 16, h = tp.height + 10;
          final a = x[idx[note.over.first]!], b = x[idx[note.over.last]!];
          final r = switch (note.side) {
            'right' => Rect.fromLTWH(a + 10, y, w, h),
            'left' => Rect.fromLTWH(a - 10 - w, y, w, h),
            _ => () {
              final l = math.min(a, b), rr = math.max(a, b);
              final width = math.max(w, rr - l + 40);
              return Rect.fromLTWH((l + rr) / 2 - width / 2, y, width, h);
            }(),
          };
          notes.add(_NoteBox(r, tp, i));
          widen(r.left + 6, r.right - 6);
          right = math.max(right, r.right);
          y += h + 12;
        case SeqBlockStart s:
          final b = _Block(s, y)..depth = open.length;
          if (open.isNotEmpty) open.last.children.add(b);
          if (s.kind != 'rect') {
            b.tab = textPainter(s.kind, label.copyWith(fontWeight: FontWeight.w700, fontSize: 10.5));
          }
          blocks.add(b);
          open.add(b);
          y += s.kind == 'rect' ? 8 : 26;
        case SeqBlockSplit s:
          if (open.isEmpty) break;
          open.last.splits.add((y + 4, textPainter(s.label.isEmpty ? '' : '[${s.label}]', label.copyWith(color: c.label2))));
          y += 26;
        case SeqBlockEnd _:
          if (open.isEmpty) break;
          final b = open.removeLast()..bottom = y + 2;
          y += b.start.kind == 'rect' ? 10 : 14;
      }
    }
    // A frame wraps what it holds, a little wider than the frames inside it.
    int height(_Block b) => b.children.isEmpty ? 0 : 1 + b.children.map(height).reduce(math.max);
    for (final b in blocks) {
      if (b.left == double.infinity) {
        b.left = x.first;
        b.right = x.last;
      }
      final grow = 18.0 + 8 * height(b);
      final labelW = b.tab == null ? 0.0 : b.tab!.width + 30 + textPainter(b.start.label, label).width;
      b.left -= grow;
      b.right = math.max(b.right + grow, b.left + labelW);
      right = math.max(right, b.right);
    }
    tall = rows.length > 6 || y > 420;
    footTop = y + 6;
    size = Size(right + _pad, (tall ? footTop + headH : y) + _pad);
    this.label = label;
  }

  final SequenceDiagram d;
  final List<DiagramStep> steps;
  late final List<TextPainter> names;
  late final List<double> x, bw;
  late final double headH, footTop;
  late final bool tall;
  late final Size size;
  late final TextStyle label;
  final rows = <_Row>[];
  final messageText = <TextPainter>[];
  final messageItem = <int>[];
  final notes = <_NoteBox>[];
  final blocks = <_Block>[];

  int rowAt(double y) => rows.indexWhere((r) => y >= r.top - 4 && y <= r.bottom + 4);
}

class _SeqPainter extends CustomPainter {
  _SeqPainter(this.l, this.c, {required this.step, required this.hover});
  final _SeqLayout l;
  final DeckColors c;
  final int step, hover;

  @override
  void paint(Canvas canvas, Size size) {
    final d = l.d;
    final idx = {for (final (i, p) in d.participants.indexed) p.id: i};
    final cur = step >= 0 ? d.messages[step] : null;
    final active = {
      if (cur != null) ...[idx[cur.from], idx[cur.to]],
    };
    final dark = c.card.computeLuminance() < .2;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Shaded rects first, under everything.
    for (final b in l.blocks.where((b) => b.start.kind == 'rect')) {
      final base = Color(b.start.color ?? 0xFFDAFBE1);
      // The skill's light green reads as glare on a dark card: tint with the theme's green instead.
      final fill = dark ? (b.start.color == null || b.start.color == 0xFFDAFBE1 ? c.green : base).withValues(alpha: .13) : base;
      canvas.drawRRect(RRect.fromLTRBR(b.left, b.top, b.right, b.bottom, const Radius.circular(4)), Paint()..color = fill);
    }

    // The current and hovered rows' bands across the whole width.
    for (final (i, a) in [(hover, .05), (step, .1)]) {
      if (i < 0) continue;
      final r = l.rows[i];
      canvas.drawRect(Rect.fromLTRB(0, r.top - 3, size.width, r.bottom + 3), Paint()..color = c.blue.withValues(alpha: a));
    }

    // Lifelines.
    final lifeTop = _pad + l.headH, lifeBottom = l.tall ? l.footTop : size.height - _pad;
    for (final (i, x) in l.x.indexed) {
      final on = active.contains(i);
      canvas.drawLine(
        Offset(x, lifeTop),
        Offset(x, lifeBottom),
        stroke
          ..color = on ? c.blue : c.label3
          ..strokeWidth = on ? 1.6 : 1,
      );
    }

    // Frames: loop, alt, opt... with their tab and splits.
    for (final b in l.blocks.where((b) => b.tab != null)) {
      final r = Rect.fromLTRB(b.left, b.top, b.right, b.bottom);
      canvas.drawRect(
        r,
        stroke
          ..color = c.label3
          ..strokeWidth = 1,
      );
      final tab = b.tab!;
      final tabRect = Rect.fromLTWH(r.left, r.top, tab.width + 14, tab.height + 6);
      canvas.drawPath(
        Path()
          ..moveTo(tabRect.left, tabRect.top)
          ..lineTo(tabRect.right, tabRect.top)
          ..lineTo(tabRect.right, tabRect.bottom - 4)
          ..lineTo(tabRect.right - 5, tabRect.bottom)
          ..lineTo(tabRect.left, tabRect.bottom)
          ..close(),
        Paint()..color = Color.alphaBlend(c.fill, c.card),
      );
      tab.paint(canvas, tabRect.topLeft + const Offset(7, 3));
      if (b.start.label.isNotEmpty) {
        textPainter('[${b.start.label}]', l.label.copyWith(color: c.label2)).paint(canvas, Offset(tabRect.right + 8, tabRect.top + 3));
      }
      for (final (y, tp) in b.splits) {
        canvas.drawPath(
          dashed(
            Path()
              ..moveTo(r.left, y)
              ..lineTo(r.right, y),
          ),
          stroke..color = c.label3,
        );
        tp.paint(canvas, Offset(r.left + 10, y + 4));
      }
    }

    // Participant boxes, top and, when tall, again at the bottom.
    final actors = d.participants.any((q) => q.actor) ? 22.0 : 0.0;
    for (final top in [_pad, if (l.tall) l.footTop]) {
      // The bottom row has the figures under the boxes, clear of the lifelines.
      final foot = top != _pad;
      for (final (i, p) in d.participants.indexed) {
        final on = active.contains(i), name = l.names[i];
        final x = l.x[i];
        if (p.actor) {
          // A stick figure by the name.
          final fig = Paint()
            ..color = on ? c.blue : c.label2
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4;
          final cx = x, ty = foot ? top + l.headH - actors + 2 : top + 2;
          canvas.drawCircle(Offset(cx, ty + 5), 4.5, fig);
          canvas.drawLine(Offset(cx, ty + 9.5), Offset(cx, ty + 17), fig);
          canvas.drawLine(Offset(cx - 6, ty + 12), Offset(cx + 6, ty + 12), fig);
          canvas.drawLine(Offset(cx, ty + 17), Offset(cx - 5, ty + 22), fig);
          canvas.drawLine(Offset(cx, ty + 17), Offset(cx + 5, ty + 22), fig);
        }
        final r = Rect.fromLTWH(x - l.bw[i] / 2, foot ? top : top + actors, l.bw[i], l.headH - actors);
        final rr = RRect.fromRectAndRadius(r, const Radius.circular(6));
        canvas.drawRRect(rr, Paint()..color = on ? Color.alphaBlend(c.blue.withValues(alpha: .14), c.card) : Color.alphaBlend(c.fill, c.card));
        canvas.drawRRect(
          rr,
          stroke
            ..color = on ? c.blue : c.label3
            ..strokeWidth = on ? 1.6 : 1,
        );
        name.paint(canvas, Offset(x - name.width / 2, r.center.dy - name.height / 2));
      }
    }

    // Notes.
    final curItem = cur == null ? -1 : l.messageItem[step];
    for (final note in l.notes) {
      final fade = step >= 0 && note.item > curItem;
      final rr = RRect.fromRectAndRadius(note.rect, const Radius.circular(3));
      canvas.drawRRect(rr, Paint()..color = Color.alphaBlend(c.orange.withValues(alpha: fade ? .04 : .12), c.card));
      canvas.drawRRect(
        rr,
        stroke
          ..color = c.orange.withValues(alpha: fade ? .15 : .45)
          ..strokeWidth = 1,
      );
      canvas.saveLayer(note.rect.inflate(2), Paint()..color = Colors.black.withValues(alpha: fade ? .3 : 1));
      note.text.paint(canvas, note.rect.topLeft + const Offset(8, 5));
      canvas.restore();
    }

    // Messages, numbered in the gutter.
    for (final (i, m) in d.messages.indexed) {
      final row = l.rows[i], tp = l.messageText[i];
      final st = i < l.steps.length ? l.steps[i] : null;
      final markColor = st?.mark == null ? null : (st!.mark == 'concern' ? c.orange : c.green);
      final fade = step >= 0 && i > step;
      final base = markColor ?? (m.dashed ? c.label2 : c.label);
      final color = i == step ? (markColor ?? c.blue) : base;
      final alpha = fade ? .22 : 1.0;
      final line = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == step ? 2 : 1.3;
      final a = l.x[idx[m.from]!], b = l.x[idx[m.to]!];
      final head = switch (m.arrow) {
        SeqArrow.filled || SeqArrow.both => Head.filled,
        SeqArrow.open => Head.none,
        SeqArrow.cross => Head.cross,
        SeqArrow.async => Head.open,
      };
      Offset tip;
      if (m.self) {
        final top = row.y, bottom = row.bottom - 8;
        final p = Path()
          ..moveTo(a, top)
          ..lineTo(a + _loop, top)
          ..lineTo(a + _loop, bottom)
          ..lineTo(a + 2, bottom);
        canvas.drawPath(m.dashed ? dashed(p) : p, line);
        tip = Offset(a + 1, bottom);
        drawHead(canvas, tip, const Offset(-1, 0), head, color.withValues(alpha: alpha), size: 8);
        _text(canvas, tp, Offset(a + _loop + 6, (top + bottom) / 2 - tp.height / 2), alpha, markColor);
      } else {
        final dir = b > a ? 1.0 : -1.0;
        final p = Path()
          ..moveTo(a, row.y)
          ..lineTo(b - dir * 1, row.y);
        canvas.drawPath(m.dashed ? dashed(p) : p, line);
        tip = Offset(b - dir * 1, row.y);
        drawHead(canvas, tip, Offset(dir, 0), head, color.withValues(alpha: alpha), size: 8);
        if (m.arrow == SeqArrow.both) drawHead(canvas, Offset(a + dir, row.y), Offset(-dir, 0), head, color.withValues(alpha: alpha), size: 8);
        _text(canvas, tp, Offset((a + b) / 2 - tp.width / 2, row.y - 4 - tp.height), alpha, markColor);
      }
      if (st?.mark != null) {
        final at = m.self ? Offset(a + _loop + tp.width + 16, (row.y + row.bottom - 8) / 2) : tip + Offset((b > a ? 1 : -1) * 13.0, 0);
        canvas.saveLayer(Rect.fromCircle(center: at, radius: 8), Paint()..color = Colors.black.withValues(alpha: alpha));
        paintGlyph(canvas, at, 6.5, st!.mark!, markColor!, c.onAccent);
        canvas.restore();
      }
      // The number in the gutter.
      final cy = m.self ? (row.y + row.bottom - 8) / 2 : row.y;
      final center = Offset(_gutter / 2 + 4, cy);
      final on = i == step;
      canvas.drawCircle(center, 10, Paint()..color = on ? c.blue : Color.alphaBlend(c.fill, c.card).withValues(alpha: fade ? .4 : 1));
      if (markColor != null && !on) {
        canvas.drawCircle(
          center,
          10,
          stroke
            ..color = markColor.withValues(alpha: alpha)
            ..strokeWidth = 1.5,
        );
      }
      final num = textPainter(
        '${i + 1}',
        l.label.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: on ? c.onAccent : c.label2.withValues(alpha: fade ? .4 : null),
        ),
      );
      num.paint(canvas, center - Offset(num.width / 2, num.height / 2));
    }
  }

  void _text(Canvas canvas, TextPainter tp, Offset at, double alpha, Color? color) {
    if (alpha >= 1 && color == null) return tp.paint(canvas, at);
    canvas.saveLayer(
      at & tp.size,
      Paint()
        ..color = Colors.black.withValues(alpha: alpha)
        ..colorFilter = color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
    );
    tp.paint(canvas, at);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SeqPainter old) => old.l != l || old.step != step || old.hover != hover || old.c != c;
}
