// A feature's classes as a graph drawn natively from the map's data: boxes in
// layers by their relations, one lane per side, UML arrows by kind. A click on
// a box opens what changed in it and what it is for. Port of Skim's
// featureGraph.ts and Features.tsx ClassGraph. Pure widget: data and callbacks.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/map/models.dart';
import '../theme.dart';
import 'diagram_paint.dart';
import 'layered_layout.dart';
import 'sequence_view.dart' show OpenCode;

/// How a relation reads from each end: "uses Db" on one, "used by Service" on the other.
const _relation = {
  'extends': ('extends', 'extended by'),
  'implements': ('implements', 'implemented by'),
  'owns': ('owns', 'owned by'),
  'uses': ('uses', 'used by'),
  'calls': ('calls', 'called by'),
  'creates': ('creates', 'created by'),
};

/// A status's name and colour, the diff's own: green added, amber changed, red removed.
(String, Color) statusOf(DeckColors c, String status) => switch (status) {
  'added' => ('Added', c.green),
  'changed' => ('Changed', c.orange),
  'removed' => ('Removed', c.red),
  _ => ('Context', c.label3),
};

class ClassGraphView extends StatefulWidget {
  const ClassGraphView({super.key, required this.graph, this.onNode, this.onFeature, this.onOpen, this.featureTitles = const {}});
  final FeatureGraph graph;

  /// A class was picked, in the picture or in the list.
  final ValueChanged<GraphNode>? onNode;

  /// A borrowed class was clicked: go to the feature it belongs to.
  final ValueChanged<String>? onFeature;

  /// Opens a class's code. Without it the path shows as plain text.
  final OpenCode? onOpen;

  /// Feature titles by id, so a borrowed class names its feature.
  final Map<String, String> featureTitles;

  @override
  State<ClassGraphView> createState() => _ClassGraphViewState();
}

class _ClassGraphViewState extends State<ClassGraphView> {
  var _picked = -1;

  @override
  void didUpdateWidget(ClassGraphView old) {
    super.didUpdateWidget(old);
    if (old.graph != widget.graph) _picked = -1;
  }

  void _pick(int i) {
    setState(() => _picked = i == _picked ? -1 : i);
    if (i >= 0 && _picked == i) widget.onNode?.call(widget.graph.nodes[i]);
  }

  /// A map draws every class as context: then the status is noise.
  bool get _onlyContext => widget.graph.nodes.every((n) => n.status == 'context');

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = context.t, g = widget.graph;
    final near = <int>{_picked};
    final index = {for (final (i, n) in g.nodes.indexed) n.name: i};
    for (final e in g.edges) {
      if (index[e.from] == _picked && index[e.to] != null) near.add(index[e.to]!);
      if (index[e.to] == _picked && index[e.from] != null) near.add(index[e.from]!);
    }
    final small = t.bodySmall!.copyWith(fontSize: 11);
    Widget pictureOf(_GraphLayout layout) => FitWidth(
      size: layout.size,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GraphPainter(layout, c, picked: _picked, near: near),
            ),
          ),
          for (final (i, n) in g.nodes.indexed)
            Positioned.fromRect(
              rect: layout.nodes[i],
              child: Tooltip(
                message: n.feature != null && widget.onFeature != null
                    ? 'Open ${widget.featureTitles[n.feature] ?? n.feature}'
                    : (n.role.isEmpty ? n.name : n.role),
                waitDuration: const Duration(milliseconds: 700),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => n.feature != null && widget.onFeature != null ? widget.onFeature!(n.feature!) : _pick(i),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    final statuses = _onlyContext
        ? <String>[]
        : [
            for (final s in nodeStatuses)
              if (g.nodes.any((n) => n.status == s)) s,
          ];
    final legend = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.sep)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final s in statuses) DiagramChip(statusOf(c, s).$1, color: statusOf(c, s).$2),
          Text(_onlyContext ? 'Click a class to see what it is for.' : 'Click a class to see what changed in it.', style: small.copyWith(color: c.label3)),
        ],
      ),
    );
    final list = [
      for (final (i, n) in g.nodes.indexed)
        _NodeRow(
          node: n,
          current: i == _picked,
          showStatus: !_onlyContext,
          onTap: () => _pick(i),
          detail: i == _picked
              ? _NodeDetail(
                  node: n,
                  graph: g,
                  showStatus: !_onlyContext,
                  featureTitle: n.feature == null ? null : widget.featureTitles[n.feature] ?? n.feature,
                  onFeature: widget.onFeature,
                  onOpen: widget.onOpen,
                  onPick: (name) => _pick(index[name] ?? -1),
                )
              : null,
        ),
    ];
    final header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.sep)),
      ),
      child: Text('${g.nodes.length} classes', style: small),
    );

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
          LayoutBuilder(
            builder: (context, box) {
              // Top to bottom beside the list when it fits there, else left to right
              // (boxes are wider than tall, so a wide flat graph folds better that way),
              // else whichever reads larger across the whole width, the list under it.
              final tb = _GraphLayout(context, g, horizontal: false);
              _GraphLayout? lr;
              _GraphLayout across() => lr ??= _GraphLayout(context, g, horizontal: true);
              bool fits(_GraphLayout l, double w, [double least = .95]) => FitWidth.scaleIn(l.size, w) >= least;
              final beside = box.maxWidth >= 760
                  ? (fits(tb, box.maxWidth - 300, .85) ? tb : (fits(across(), box.maxWidth - 300, .85) ? across() : null))
                  : null;
              if (beside == null) {
                final w = box.maxWidth;
                // Left to right only when it reads clearly larger: top to bottom is how a class graph is expected.
                double scale(_GraphLayout l) => math.min(1, (w - 32) / l.size.width);
                final layout = fits(tb, w) || scale(across()) < scale(tb) + .1 ? tb : across();
                final picture = pictureOf(layout);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    picture,
                    legend,
                    Divider(height: 1, color: c.sep),
                    header,
                    Padding(padding: const EdgeInsets.all(6), child: columns(list, box.maxWidth - 12)),
                  ],
                );
              }
              final layout = beside, picture = pictureOf(layout);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [picture, legend]),
                  ),
                  Container(
                    width: 300,
                    constraints: BoxConstraints(maxHeight: math.max(layout.size.height + 70, 640)),
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: c.sep)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        header,
                        Flexible(
                          child: ListView(primary: false, shrinkWrap: true, padding: const EdgeInsets.all(6), children: list),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          if (g.caption.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.sep)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(g.caption, textAlign: TextAlign.center, style: small),
            ),
        ],
      ),
    );
  }
}

class _NodeRow extends StatelessWidget {
  const _NodeRow({required this.node, required this.current, required this.showStatus, required this.onTap, this.detail});
  final GraphNode node;
  final bool current, showStatus;
  final VoidCallback onTap;
  final Widget? detail;

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = context.t;
    final (label, color) = statusOf(c, node.status);
    final row = DiagramListItem(
      current: current,
      joined: current,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${node.name}${node.feature != null ? ' ↗' : ''}',
              overflow: TextOverflow.ellipsis,
              style: mono(t.bodyMedium!.copyWith(fontSize: 12, fontWeight: current ? FontWeight.w600 : null)),
            ),
          ),
          if (showStatus) Text(label, style: t.bodySmall!.copyWith(fontSize: 10)),
        ],
      ),
    );
    return detail == null ? row : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [row, detail!]);
  }
}

class _NodeDetail extends StatelessWidget {
  const _NodeDetail({
    required this.node,
    required this.graph,
    required this.showStatus,
    required this.featureTitle,
    required this.onPick,
    this.onFeature,
    this.onOpen,
  });
  final GraphNode node;
  final FeatureGraph graph;
  final bool showStatus;
  final String? featureTitle;
  final ValueChanged<String> onPick;
  final ValueChanged<String>? onFeature;
  final OpenCode? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = context.t, n = node;
    final small = t.bodySmall!.copyWith(fontSize: 11);
    final relations = [
      for (final e in graph.edges.where((e) => e.from == n.name)) (_relation[e.kind]?.$1 ?? e.kind, e.to, e.label),
      for (final e in graph.edges.where((e) => e.to == n.name && e.from != n.name)) (_relation[e.kind]?.$2 ?? e.kind, e.from, e.label),
    ];
    final (status, color) = statusOf(c, n.status);
    Widget gapped(List<Widget> items) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, w) in items.indexed) ...[if (i > 0) const SizedBox(height: 8), w],
      ],
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        border: Border.all(color: c.sep),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
      ),
      child: gapped([
        if (showStatus) DiagramChip(status, color: color),
        if (featureTitle != null)
          MouseRegion(
            cursor: onFeature == null ? MouseCursor.defer : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onFeature == null ? null : () => onFeature!(n.feature!),
              child: Text(
                'Part of $featureTitle ↗',
                style: t.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: c.blue),
              ),
            ),
          ),
        if (n.edited.isNotEmpty) Labeled('What changed', n.edited),
        if (n.role.isNotEmpty) Labeled('What it is for', n.role),
        if (relations.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (verb, other, label) in relations)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(verb, style: small),
                      DiagramChip(other, code: true, onTap: () => onPick(other)),
                      if (label.isNotEmpty) Text(label, style: mono(small)),
                    ],
                  ),
                ),
            ],
          ),
        if (n.path != null) CodeLink(path: n.path!, line: n.line, onOpen: onOpen),
      ]),
    );
  }
}

const _laneHead = 24.0;

/// The class's box, its edges and lanes, measured with the theme's text.
class _GraphLayout {
  _GraphLayout(BuildContext context, this.graph, {required this.horizontal}) {
    final c = context.c, t = context.t;
    final nameStyle = t.bodyMedium!.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.25);
    final roleStyle = t.bodySmall!.copyWith(fontSize: 10.5, height: 1.25, color: c.label2);
    labelStyle = mono(t.bodySmall!.copyWith(fontSize: 10.5, color: c.label2, height: 1.2));
    final nodes = graph.nodes;
    final sizes = <Size>[];
    for (final n in nodes) {
      // A long name wraps between its words, two lines at most, so a box stays narrow.
      final name = textPainter('${breakable(n.name)}${n.feature != null ? ' ↗' : ''}', nameStyle, maxWidth: 172, maxLines: 2, align: TextAlign.center);
      final width = (name.width + 28).clamp(130.0, 200.0);
      final role = n.role.isEmpty ? null : textPainter(breakable(n.role), roleStyle, maxWidth: width - 20, maxLines: 2, align: TextAlign.center);
      texts.add((name, role));
      sizes.add(Size(width, name.height + (role == null ? 0 : role.height + 4) + 18));
    }
    final index = {for (final (i, n) in nodes.indexed) n.name: i};
    final edges = <LayoutEdge>[];
    for (final e in graph.edges) {
      final a = index[e.from], b = index[e.to];
      if (a == null || b == null) continue;
      final text = e.label.isNotEmpty ? e.label : (e.kind == 'calls' || e.kind == 'creates' ? e.kind : '');
      final tp = text.isEmpty ? null : textPainter(breakable(text), labelStyle, maxWidth: 150, maxLines: 2, align: TextAlign.center);
      // The parent sits above its children: an inheritance edge ranks from the parent.
      final up = e.kind == 'extends' || e.kind == 'implements';
      kept.add((e, tp, up));
      edges.add(LayoutEdge(up ? b : a, up ? a : b, label: tp == null ? Size.zero : Size(tp.width + 10, tp.height + 4)));
    }
    sides = {
      for (final n in nodes)
        if (n.side != null) n.side!,
    }.toList();
    // A class without a side runs where the classes it talks to run: it joins the lane
    // most of its edges lead to, instead of a nameless lane of its own beside the others.
    final side = [for (final n in nodes) n.side];
    for (var pass = 0; pass < 3 && sides.isNotEmpty; pass++) {
      for (final (i, n) in nodes.indexed) {
        if (side[i] != null || n.side != null) continue;
        final votes = <String, int>{};
        for (final (e, _, _) in kept) {
          final other = e.from == n.name ? index[e.to] : (e.to == n.name ? index[e.from] : null);
          if (other != null && side[other] != null) votes[side[other]!] = (votes[side[other]!] ?? 0) + 1;
        }
        if (votes.isNotEmpty) side[i] = votes.entries.reduce((a, b) => b.value > a.value ? b : a).key;
      }
    }
    if (sides.isNotEmpty && side.any((s) => s == null)) sides.add('');
    final lanes = sides.isEmpty ? null : [for (final s in side) sides.indexOf(s ?? '')];
    final g = layeredLayout(sizes, edges, lanes: lanes, horizontal: horizontal, gap: 26, layerGap: 14, laneGap: 36, selfLoop: 34, fanRow: horizontal ? 0 : 4);
    // With lanes, room for their names on top and a margin around them.
    final o = sides.isEmpty ? Offset.zero : const Offset(10, _laneHead);
    this.nodes = [for (final r in g.nodes) r.shift(o)];
    routes = [
      for (final (i, r) in g.edges.indexed)
        (points: [for (final p in kept[i].$3 ? r.points.reversed : r.points) p + o], label: r.label?.shift(o), self: r.self),
    ];
    // Columns top to bottom, rows left to right, each with its name in its top left corner.
    laneRects = [
      for (final r in g.lanes)
        horizontal
            ? Rect.fromLTRB(0, r.top + _laneHead - 22, g.size.width + 20, r.bottom + _laneHead + 8)
            : Rect.fromLTRB(r.left, 0, r.right + 20, g.size.height + _laneHead + 8),
    ];
    size = sides.isEmpty ? g.size : Size(g.size.width + 20, g.size.height + _laneHead + 8);
    laneNames = [for (final s in sides) textPainter(s.toUpperCase(), t.labelSmall!.copyWith(fontSize: 10, color: c.label3, letterSpacing: .8))];
  }

  final FeatureGraph graph;
  final bool horizontal;
  late final TextStyle labelStyle;
  final texts = <(TextPainter, TextPainter?)>[];

  /// The edges that join two drawn classes, with their label and whether the layout ran them reversed.
  final kept = <(GraphEdge, TextPainter?, bool)>[];
  late final List<String> sides;
  late List<Rect> nodes, laneRects;
  late List<({List<Offset> points, Rect? label, bool self})> routes;
  late Size size;
  late final List<TextPainter> laneNames;
}

class _GraphPainter extends CustomPainter {
  _GraphPainter(this.l, this.c, {required this.picked, required this.near});
  final _GraphLayout l;
  final DeckColors c;
  final int picked;
  final Set<int> near;

  @override
  void paint(Canvas canvas, Size size) {
    final g = l.graph;
    final index = {for (final (i, n) in g.nodes.indexed) n.name: i};

    for (final (i, r) in l.laneRects.indexed) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), Paint()..color = c.bg);
      final name = l.laneNames[i];
      name.paint(canvas, Offset(r.left + 10, r.top + 7));
    }

    // Labels go on top of every line, so no other edge runs through the words.
    final labels = <(TextPainter, Offset, bool)>[];
    for (final (i, (e, tp, _)) in l.kept.indexed) {
      final r = l.routes[i];
      final far = picked >= 0 && index[e.from] != picked && index[e.to] != picked;
      final hot = picked >= 0 && !far;
      final color = (hot ? c.blue : c.label2).withValues(alpha: far ? .25 : 1);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = hot ? 1.8 : 1.2;
      final dash = e.kind == 'implements' || e.kind == 'uses';
      if (r.self) {
        final n = l.nodes[index[e.from]!];
        // Beside the box across the flow, in the room the layout kept: right of it, or under it left to right.
        if (l.horizontal) {
          final a = Offset(n.center.dx - 8, n.bottom), b = Offset(n.center.dx + 8, n.bottom);
          final p = Path()
            ..moveTo(a.dx, a.dy)
            ..cubicTo(a.dx - 14, a.dy + 30, b.dx + 14, b.dy + 30, b.dx, b.dy);
          canvas.drawPath(dash ? dashed(p) : p, paint);
          drawHead(canvas, b, const Offset(0, -1), Head.filled, color, size: 8);
          if (tp != null) labels.add((tp, Offset(n.center.dx, n.bottom + 32 + tp.height / 2), far));
          continue;
        }
        final a = Offset(n.right, n.center.dy - 8), b = Offset(n.right, n.center.dy + 8);
        final p = Path()
          ..moveTo(a.dx, a.dy)
          ..cubicTo(a.dx + 30, a.dy - 14, b.dx + 30, b.dy + 14, b.dx, b.dy);
        canvas.drawPath(dash ? dashed(p) : p, paint);
        drawHead(canvas, b, const Offset(-1, 0), Head.filled, color, size: 8);
        if (tp != null) labels.add((tp, Offset(n.right + 32 + tp.width / 2, n.center.dy), far));
        continue;
      }
      final path = routePath(r.points, horizontal: l.horizontal);
      canvas.drawPath(dash ? dashed(path) : path, paint);
      final end = routeDirection(r.points, horizontal: l.horizontal);
      switch (e.kind) {
        case 'extends' || 'implements':
          drawHead(canvas, r.points.last, end, Head.hollow, color, size: 11, fill: c.card);
        case 'owns':
          drawHead(canvas, r.points.first, routeDirection(r.points, horizontal: l.horizontal, start: true), Head.diamond, color, size: 9);
        case 'uses':
          drawHead(canvas, r.points.last, end, Head.open, color, size: 9);
        default:
          drawHead(canvas, r.points.last, end, Head.filled, color, size: 8);
      }
      if (tp != null && r.label != null) labels.add((tp, r.label!.center, far));
    }
    for (final (tp, at, far) in labels) {
      _label(canvas, tp, at, far);
    }

    for (final (i, n) in g.nodes.indexed) {
      final r = l.nodes[i];
      final far = picked >= 0 && !near.contains(i);
      final (_, tint) = statusOf(c, n.status);
      final borrowed = n.feature != null;
      final plain = n.status == 'context';
      canvas.saveLayer(r.inflate(4), Paint()..color = Colors.black.withValues(alpha: far ? .35 : 1));
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(6));
      // On a lane's grey band a plain box stays white.
      final fill = plain ? (l.laneRects.isEmpty ? Color.alphaBlend(c.fill, c.card) : c.card) : Color.alphaBlend(tint.withValues(alpha: .14), c.card);
      canvas.drawRRect(rr, Paint()..color = fill);
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == picked ? 2.2 : 1.2
        ..color = i == picked ? c.blue : (borrowed && plain ? c.blue : (plain ? c.label3 : tint));
      final border = Path()..addRRect(rr);
      canvas.drawPath(
        n.status == 'removed'
            ? dashed(border, dash: 4, gap: 3)
            : borrowed
            ? dashed(border, dash: 2, gap: 3)
            : border,
        stroke,
      );
      final (name, role) = l.texts[i];
      final top = r.top + 9;
      name.paint(canvas, Offset(r.center.dx - name.width / 2, top));
      role?.paint(canvas, Offset(r.center.dx - role.width / 2, top + name.height + 4));
      canvas.restore();
    }
  }

  void _label(Canvas canvas, TextPainter tp, Offset center, bool far) {
    canvas.saveLayer(
      Rect.fromCenter(center: center, width: tp.width + 12, height: tp.height + 6),
      Paint()..color = Colors.black.withValues(alpha: far ? .3 : 1),
    );
    paintPlate(canvas, tp, center, c.card);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GraphPainter old) => old.l != l || old.picked != picked || old.c != c;
}
