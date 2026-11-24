// A feature's state machine drawn natively from its mermaid stateDiagram-v2,
// with every transition listed beside it in source order. A click on a
// transition, in the list or on its label, lights up its arrow.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/map/mermaid.dart';
import '../../core/map/models.dart';
import '../theme.dart';
import 'diagram_paint.dart';
import 'layered_layout.dart';
import 'sequence_view.dart' show OpenCode;

class StateDiagramView extends StatefulWidget {
  const StateDiagramView({super.key, required this.state, this.onOpen});
  final MapState state;

  /// Opens a transition's code. Without it the path shows as plain text.
  final OpenCode? onOpen;

  @override
  State<StateDiagramView> createState() => _StateDiagramViewState();
}

class _StateDiagramViewState extends State<StateDiagramView> {
  late StateDiagram _d = parseState(widget.state.mermaid);
  var _picked = -1;

  @override
  void didUpdateWidget(StateDiagramView old) {
    super.didUpdateWidget(old);
    if (old.state.mermaid != widget.state.mermaid) {
      _d = parseState(widget.state.mermaid);
      _picked = -1;
    }
  }

  void _pick(int i) => setState(() => _picked = i == _picked ? -1 : i);

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = context.t;
    final small = t.bodySmall!.copyWith(fontSize: 11);
    final notes = widget.state.transitions;
    if (_d.states.isEmpty) {
      return _box(context, [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This diagram does not parse as a state machine.', style: small.copyWith(color: c.red)),
              const SizedBox(height: 4),
              SelectableText(widget.state.mermaid, style: mono(small)),
            ],
          ),
        ),
      ]);
    }
    final layout = _StateLayout(context, _d);
    final names = {for (final s in _d.states) s.id: s};
    String name(String id) => switch (names[id]?.kind) {
      StateKind.start => 'start',
      StateKind.end => 'end',
      _ => names[id]?.label ?? id,
    };
    final picture = FitWidth(
      size: layout.graph.size,
      padding: 18,
      child: GestureDetector(
        onTapUp: (e) {
          final i = layout.labelAt(e.localPosition);
          if (i >= 0) _pick(i);
        },
        child: CustomPaint(size: layout.graph.size, painter: _StatePainter(layout, c, _picked)),
      ),
    );
    final count = math.max(notes.length, _d.transitions.length);
    final list = [
      for (var i = 0; i < count; i++)
        _TransitionItem(
          index: i,
          note: i < notes.length ? notes[i] : null,
          edge: i < _d.transitions.length ? _d.transitions[i] : null,
          route: i < _d.transitions.length ? '${name(_d.transitions[i].from)} → ${name(_d.transitions[i].to)}' : null,
          current: i == _picked,
          onTap: () => _pick(i),
          onOpen: widget.onOpen,
        ),
    ];
    return _box(context, [
      LayoutBuilder(
        builder: (context, box) {
          // A machine too wide for the room beside the list gets the whole width, the list under it.
          if (box.maxWidth < 760 || FitWidth.scaleIn(layout.graph.size, box.maxWidth - 300, padding: 18, minScale: .5) < .9) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                picture,
                Divider(height: 1, color: c.sep),
                Padding(padding: const EdgeInsets.all(6), child: columns(list, box.maxWidth - 12)),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: picture),
              Container(
                width: 300,
                constraints: BoxConstraints(maxHeight: math.max(layout.graph.size.height + 36, 640)),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: c.sep)),
                ),
                child: ListView(primary: false, shrinkWrap: true, padding: const EdgeInsets.all(6), children: list),
              ),
            ],
          );
        },
      ),
      if (notes.isNotEmpty && notes.length != _d.transitions.length)
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: c.sep)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'The agent wrote ${notes.length} comments for ${_d.transitions.length} transitions, so some may sit on the wrong arrow.',
            style: small.copyWith(color: c.orange),
          ),
        ),
    ]);
  }

  Widget _box(BuildContext context, List<Widget> children) {
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
          if (widget.state.caption.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.sep)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(widget.state.caption, textAlign: TextAlign.center, style: context.t.bodySmall!.copyWith(fontSize: 11)),
            ),
        ],
      ),
    );
  }
}

class _TransitionItem extends StatelessWidget {
  const _TransitionItem({
    required this.index,
    required this.note,
    required this.edge,
    required this.route,
    required this.current,
    required this.onTap,
    this.onOpen,
  });
  final int index;
  final MapTransition? note;
  final StateTransition? edge;
  final String? route;
  final bool current;
  final VoidCallback onTap;
  final OpenCode? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = context.t, n = note;
    final small = t.bodySmall!.copyWith(fontSize: 11);
    final title = n?.title ?? (edge!.label.isEmpty ? route! : edge!.label);
    return DiagramListItem(
      current: current,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepNumber(index, current: current),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.bodyMedium!.copyWith(fontSize: 12, height: 1.3, fontWeight: current ? FontWeight.w600 : FontWeight.w500)),
                if (route != null && (current || n == null)) Text(route!, style: small.copyWith(color: c.label3)),
                if ((n?.detail ?? '').isNotEmpty) Text(n!.detail, style: small),
                if (n?.path != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: CodeLink(path: n!.path!, line: n.line, onOpen: onOpen),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _loopRoom = 30.0;

class _StateLayout {
  _StateLayout(BuildContext context, this.d) {
    final c = context.c, t = context.t;
    final title = t.bodyMedium!.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.25);
    final desc = t.bodySmall!.copyWith(fontSize: 11, height: 1.25);
    labelStyle = t.bodySmall!.copyWith(fontSize: 11, color: c.label2, height: 1.2);
    horizontal = d.direction == 'LR';
    final idx = {for (final (i, s) in d.states.indexed) s.id: i};
    final sizes = <Size>[];
    for (final s in d.states) {
      switch (s.kind) {
        case StateKind.start:
          sizes.add(const Size(16, 16));
        case StateKind.end:
          sizes.add(const Size(20, 20));
        case StateKind.choice:
          sizes.add(const Size(26, 26));
        case StateKind.fork || StateKind.join:
          sizes.add(horizontal ? const Size(7, 64) : const Size(64, 7));
        case StateKind.normal:
          final a = textPainter(breakable(s.label), title, maxWidth: 180, maxLines: 2, align: TextAlign.center);
          final b = s.description.isEmpty ? null : textPainter(s.description.join('\n'), desc, maxWidth: 180, maxLines: 4, align: TextAlign.center);
          texts[sizes.length] = (a, b);
          sizes.add(Size(math.max(math.max(a.width, b?.width ?? 0) + 28, 96), a.height + (b == null ? 0 : b.height + 7) + 18));
      }
    }
    final edges = <LayoutEdge>[];
    var loop = 0.0;
    for (final tr in d.transitions) {
      final tp = tr.label.isEmpty ? null : textPainter(breakable(tr.label), labelStyle, maxWidth: 150, maxLines: 2, align: TextAlign.center);
      labels.add(tp);
      final size = tp == null ? Size.zero : Size(tp.width + 10, tp.height + 4);
      if (tr.from == tr.to) loop = math.max(loop, _loopRoom + (horizontal ? size.height : size.width));
      edges.add(LayoutEdge(idx[tr.from]!, idx[tr.to]!, label: size));
    }
    // A composite state leads to its own start, dotted.
    for (final s in d.states.where((s) => s.kind == StateKind.start && s.parent != null)) {
      if (idx[s.parent] case final p?) edges.add(LayoutEdge(p, idx[s.id]!));
    }
    final start = d.states.indexWhere((s) => s.kind == StateKind.start && s.parent == null);
    graph = layeredLayout(sizes, edges, first: [if (start >= 0) start], horizontal: horizontal, gap: 30, layerGap: 12, selfLoop: loop + 6, backAside: true);
  }

  final StateDiagram d;
  late final bool horizontal;
  late final LayeredGraph graph;
  late final TextStyle labelStyle;
  final texts = <int, (TextPainter, TextPainter?)>{};
  final labels = <TextPainter?>[];

  /// Where the label of transition i sits, for taps.
  Rect? labelRect(int i) {
    final tp = labels[i];
    if (tp == null) return null;
    final r = graph.edges[i];
    if (!r.self) return r.label;
    final n = graph.nodes[d.states.indexWhere((s) => s.id == d.transitions[i].from)];
    if (horizontal) return Rect.fromLTWH(n.center.dx - tp.width / 2 - 5, n.bottom + _loopRoom - 6, tp.width + 10, tp.height + 4);
    return Rect.fromLTWH(n.right + _loopRoom - 2, n.center.dy - tp.height / 2 - 2, tp.width + 10, tp.height + 4);
  }

  int labelAt(Offset p) {
    for (var i = 0; i < labels.length; i++) {
      if (labelRect(i)?.inflate(4).contains(p) ?? false) return i;
    }
    return -1;
  }
}

class _StatePainter extends CustomPainter {
  _StatePainter(this.l, this.c, this.picked);
  final _StateLayout l;
  final DeckColors c;
  final int picked;

  @override
  void paint(Canvas canvas, Size size) {
    final g = l.graph, d = l.d;
    final on = <String>{
      if (picked >= 0 && picked < d.transitions.length) ...[d.transitions[picked].from, d.transitions[picked].to],
    };

    // Edges under the boxes, the picked one last so it stays on top.
    final order = [
      for (var i = 0; i < g.edges.length; i++)
        if (i != picked) i,
      if (picked >= 0 && picked < g.edges.length) picked,
    ];
    final labels = <int>[];
    for (final i in order) {
      final r = g.edges[i];
      final real = i < d.transitions.length;
      final hot = i == picked;
      final color = hot ? c.blue : c.label2.withValues(alpha: picked >= 0 ? .35 : 1);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = hot ? 2.2 : 1.3;
      if (r.self) {
        final n = g.nodes[d.states.indexWhere((s) => s.id == d.transitions[i].from)];
        // Beside the box, on the side no other edge uses.
        final h = l.horizontal;
        final a = h ? Offset(n.center.dx - 8, n.bottom) : Offset(n.right, n.center.dy - 7);
        final b = h ? Offset(n.center.dx + 8, n.bottom) : Offset(n.right, n.center.dy + 7);
        final out = h ? const Offset(0, _loopRoom - 4) : const Offset(_loopRoom, 0);
        final spread = h ? const Offset(14, 0) : const Offset(0, 14);
        final c1 = a + out - spread, c2 = b + out + spread;
        canvas.drawPath(
          Path()
            ..moveTo(a.dx, a.dy)
            ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, b.dx, b.dy),
          paint,
        );
        drawHead(canvas, b, h ? const Offset(0, -1) : const Offset(-1, 0), Head.filled, color, size: 8);
      } else {
        final path = routePath(r.points, horizontal: l.horizontal);
        canvas.drawPath(real ? path : dashed(path, dash: 2, gap: 3), paint);
        if (real) drawHead(canvas, r.points.last, routeDirection(r.points, horizontal: l.horizontal), Head.filled, color, size: 8);
      }
      if (real && l.labels[i] != null) labels.add(i);
    }
    // Labels over every line, so no other arrow runs through the words.
    for (final i in labels) {
      final hot = i == picked, tp = l.labels[i]!, at = l.labelRect(i);
      if (at != null) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(at, const Radius.circular(4)),
          Paint()..color = hot ? Color.alphaBlend(c.blue.withValues(alpha: .15), c.card) : c.card,
        );
        canvas.saveLayer(at, Paint()..color = Colors.black.withValues(alpha: picked >= 0 && !hot ? .45 : 1));
        tp.paint(canvas, Offset(at.center.dx - tp.width / 2, at.center.dy - tp.height / 2));
        canvas.restore();
      }
    }

    // States.
    for (final (i, s) in d.states.indexed) {
      final r = g.nodes[i];
      final hot = on.contains(s.id);
      final ink = hot ? c.blue : c.label;
      switch (s.kind) {
        case StateKind.start:
          canvas.drawCircle(r.center, r.width / 2, Paint()..color = ink);
        case StateKind.end:
          canvas.drawCircle(
            r.center,
            r.width / 2 - .7,
            Paint()
              ..color = ink
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.4,
          );
          canvas.drawCircle(r.center, r.width / 2 - 4.5, Paint()..color = ink);
        case StateKind.choice:
          final p = Path()
            ..moveTo(r.center.dx, r.top)
            ..lineTo(r.right, r.center.dy)
            ..lineTo(r.center.dx, r.bottom)
            ..lineTo(r.left, r.center.dy)
            ..close();
          canvas.drawPath(p, Paint()..color = Color.alphaBlend(c.fill, c.card));
          canvas.drawPath(
            p,
            Paint()
              ..color = hot ? c.blue : c.label3
              ..style = PaintingStyle.stroke,
          );
        case StateKind.fork || StateKind.join:
          canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(2)), Paint()..color = ink);
        case StateKind.normal:
          final rr = RRect.fromRectAndRadius(r, const Radius.circular(10));
          canvas.drawRRect(rr, Paint()..color = hot ? Color.alphaBlend(c.blue.withValues(alpha: .12), c.card) : Color.alphaBlend(c.fill, c.card));
          canvas.drawRRect(
            rr,
            Paint()
              ..color = hot ? c.blue : c.label3
              ..style = PaintingStyle.stroke
              ..strokeWidth = hot || s.composite ? 1.8 : 1,
          );
          final (a, b) = l.texts[i]!;
          final top = r.top + 9;
          a.paint(canvas, Offset(r.center.dx - a.width / 2, top));
          if (b != null) {
            final y = top + a.height + 3;
            canvas.drawLine(Offset(r.left + 8, y), Offset(r.right - 8, y), Paint()..color = c.sep);
            b.paint(canvas, Offset(r.center.dx - b.width / 2, y + 4));
          }
      }
    }
  }

  @override
  bool shouldRepaint(_StatePainter old) => old.l != l || old.picked != picked || old.c != c;
}
