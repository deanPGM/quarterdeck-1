// The architecture as a class graph: one band per layer, top first, with what
// the layer is for on the left and its classes as boxes. A class that breaks a
// rule wears a warning. With nothing picked, one arrow per pair of layers says
// how many classes reach past their rules; a picked class shows its own arrows.
// Pure widget: data and a callback.
import 'package:flutter/material.dart';

import '../../core/map/models.dart';
import '../severity.dart';
import '../theme.dart';
import 'diagram_paint.dart';

const _head = 220.0, _boxH = 30.0, _gapX = 10.0, _gapY = 10.0, _pad = 12.0, _bandGap = 34.0, _lane = 34.0, _icon = 15.0;

class ArchitectureGraph extends StatelessWidget {
  const ArchitectureGraph({super.key, required this.arch, this.picked, this.onPick, this.colors = const []});
  final MapArchitecture arch;

  /// The class shown with its arrows, null for the summary of every layer.
  final String? picked;

  /// A class was clicked, or null when the empty picture was.
  final ValueChanged<String?>? onPick;

  /// One colour per layer, in layer order.
  final List<Color> colors;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final l = _ArchLayout(context, arch, box.maxWidth);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: picked == null ? null : () => onPick?.call(null),
        child: SizedBox(
          width: box.maxWidth,
          height: l.size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _ArchPainter(l, context.c, picked: picked, colors: colors),
                ),
              ),
              for (final (i, n) in l.names.indexed)
                Positioned.fromRect(
                  rect: l.boxes[i],
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => onPick?.call(n)),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _ArchLayout {
  _ArchLayout(BuildContext context, this.arch, double width) {
    final c = context.c, t = context.t;
    final style = mono(t.bodySmall!.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600, color: c.label));
    small = t.bodySmall!.copyWith(fontSize: 10.5, color: c.label3);
    final layerIds = [for (final l in arch.layers) l.id];
    // Every class once, in the layer it is first named in: examples, then who breaks a rule, then what they reach.
    final layerOf = <String, int>{};
    void add(String name, String layer) {
      final i = layerIds.indexOf(layer);
      if (name.isNotEmpty && i >= 0) layerOf.putIfAbsent(name, () => i);
    }

    for (final l in arch.layers) {
      for (final e in l.examples) {
        add(e, l.id);
      }
    }
    for (final v in arch.violations) {
      add(v.from, v.fromLayer);
    }
    for (final v in arch.violations) {
      for (final to in v.to) {
        add(to, v.toLayer);
      }
    }
    for (final v in arch.violations) {
      final k = violationSeverities.indexOf(v.severity);
      if (k >= 0 && (!worst.containsKey(v.from) || k < worst[v.from]!)) worst[v.from] = k;
    }
    // The pairs of layers some class reaches across, one lane each on the right.
    for (final v in arch.violations) {
      final i = layerIds.indexOf(v.fromLayer), j = layerIds.indexOf(v.toLayer);
      if (i < 0 || j < 0 || i == j) continue;
      (pairs[(i, j)] ??= []).add(v);
    }
    final right = width - _pad - (pairs.isEmpty ? 0 : _lane * pairs.length + 8);
    var y = 0.0;
    for (final (i, l) in arch.layers.indexed) {
      if (i > 0) y += _bandGap;
      final top = y;
      var x = _head, rowTop = top + _pad;
      for (final name in [
        for (final MapEntry(:key, :value) in layerOf.entries)
          if (value == i) key,
      ]) {
        final tp = textPainter(name, style, maxWidth: 220, maxLines: 1);
        final w = tp.width + 20 + (worst.containsKey(name) ? _icon + 4 : 0);
        if (x + w > right && x > _head) {
          x = _head;
          rowTop += _boxH + _gapY;
        }
        names.add(name);
        texts.add(tp);
        boxes.add(Rect.fromLTWH(x, rowTop, w, _boxH));
        x += w + _gapX;
      }
      final text = _head - 32;
      final name = textPainter(l.name, t.titleSmall!.copyWith(fontSize: 13, color: c.label), maxWidth: text, maxLines: 2);
      final role = textPainter(l.role, t.bodySmall!.copyWith(fontSize: 11, height: 1.3, color: c.label2), maxWidth: text, maxLines: 4);
      final naming = textPainter(l.naming.join('  '), mono(t.bodySmall!.copyWith(fontSize: 10.5, color: c.label2)), maxWidth: text, maxLines: 2);
      final labelBottom = top + _pad + name.height + (l.role.isEmpty ? 0 : 3 + role.height) + (l.naming.isEmpty ? 0 : 5 + naming.height) + _pad;
      y = [rowTop + _boxH + _pad, labelBottom].reduce((a, b) => a > b ? a : b);
      bands.add(Rect.fromLTRB(0, top, width, y));
      labels.add((name, l.role.isEmpty ? null : role, l.naming.isEmpty ? null : naming));
    }
    size = Size(width, y);
  }

  final MapArchitecture arch;
  late final TextStyle small;
  final names = <String>[];
  final texts = <TextPainter>[];
  final boxes = <Rect>[];
  final bands = <Rect>[];
  final labels = <(TextPainter, TextPainter?, TextPainter?)>[];

  /// The worst severity index of each class that breaks a rule.
  final worst = <String, int>{};

  /// Violations by the pair of layer indexes they cross.
  final pairs = <(int, int), List<ArchViolation>>{};
  late final Size size;
}

class _ArchPainter extends CustomPainter {
  _ArchPainter(this.l, this.c, {required this.picked, required this.colors});
  final _ArchLayout l;
  final DeckColors c;
  final String? picked;
  final List<Color> colors;

  Color _worst(Iterable<ArchViolation> vs) =>
      findingColor(c, violationSeverities[vs.map((v) => violationSeverities.indexOf(v.severity)).reduce((a, b) => a < b ? a : b).clamp(0, 3)]);

  Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;

  /// An arrow from box [from] to box [to], bending between rows, arcing over one row.
  Path _route(Rect from, Rect to) {
    if ((from.center.dy - to.center.dy).abs() < 1) {
      final p0 = from.topCenter, p1 = to.topCenter, lift = 18 + (p1.dx - p0.dx).abs() * .08;
      return Path()
        ..moveTo(p0.dx, p0.dy)
        ..cubicTo(p0.dx, p0.dy - lift, p1.dx, p1.dy - lift, p1.dx, p1.dy);
    }
    final down = to.center.dy > from.center.dy;
    final p0 = down ? from.bottomCenter : from.topCenter, p1 = down ? to.topCenter : to.bottomCenter;
    final bend = (p1.dy - p0.dy) * .5;
    return Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(p0.dx, p0.dy + bend, p1.dx, p1.dy - bend, p1.dx, p1.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final a = l.arch;
    final ids = [for (final x in a.layers) x.id];
    for (final (i, r) in l.bands.indexed) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(10)), Paint()..color = c.card);
      final color = colors.isEmpty ? c.label3 : colors[i % colors.length];
      canvas.drawRRect(
        RRect.fromRectAndCorners(Rect.fromLTWH(r.left, r.top, 4, r.height), topLeft: const Radius.circular(10), bottomLeft: const Radius.circular(10)),
        Paint()..color = color,
      );
      final (name, role, naming) = l.labels[i];
      var y = r.top + _pad;
      name.paint(canvas, Offset(r.left + 16, y));
      y += name.height;
      if (role != null) {
        role.paint(canvas, Offset(r.left + 16, y + 3));
        y += 3 + role.height;
      }
      naming?.paint(canvas, Offset(r.left + 16, y + 5));
    }
    // Allowed flows between neighbour layers, in the gap under the label column. The page lists the others.
    for (final f in a.flows) {
      final i = ids.indexOf(f.from), j = ids.indexOf(f.to);
      if (i < 0 || j < 0 || (j - i).abs() != 1) continue;
      final down = j > i, x = 40.0 + (down ? 0 : 14);
      final to = down ? l.bands[j].top : l.bands[j].bottom;
      canvas.drawLine(Offset(x, down ? l.bands[i].bottom : l.bands[i].top), Offset(x, to), _stroke(c.label3, 1.3));
      drawHead(canvas, Offset(x, to), Offset(0, down ? 1 : -1), Head.open, c.label3, size: 8);
      if (f.label.isNotEmpty) {
        final tp = textPainter(f.label, l.small);
        tp.paint(canvas, Offset(x + 10, (down ? l.bands[i].bottom : l.bands[j].bottom) + (_bandGap - tp.height) / 2));
      }
    }
    final index = {for (final (i, n) in l.names.indexed) n: i};
    final involved = <int>{};
    if (picked == null) {
      // One arrow per pair of layers, in its lane on the right: how many classes cross, the worst colour.
      for (final (k, MapEntry(key: (i, j), value: vs)) in l.pairs.entries.indexed) {
        final x = size.width - _pad - _lane * (k + .5);
        final down = j > i;
        final from = l.bands[i].center.dy, to = down ? l.bands[j].top + 14 : l.bands[j].bottom - 14;
        final color = _worst(vs);
        final path = Path()
          ..moveTo(x, from)
          ..lineTo(x, to);
        canvas.drawPath(vs.every((v) => v.severity == 'accepted') ? dashed(path) : path, _stroke(color, 2.2));
        canvas.drawCircle(Offset(x, from), 3.5, Paint()..color = color);
        drawHead(canvas, Offset(x, to), Offset(0, down ? 1 : -1), Head.filled, color, size: 10);
        final count = textPainter('${vs.length}', l.small.copyWith(color: c.card, fontWeight: FontWeight.w700, fontSize: 11));
        final mid = Offset(x, down ? l.bands[i].bottom + _bandGap / 2 : l.bands[i].top - _bandGap / 2);
        final plate = Rect.fromCenter(center: mid, width: count.width + 12, height: count.height + 4);
        canvas.drawRRect(RRect.fromRectAndRadius(plate, const Radius.circular(9)), Paint()..color = color);
        count.paint(canvas, Offset(mid.dx - count.width / 2, mid.dy - count.height / 2));
      }
    } else {
      // The picked class: what it reaches, and who reaches it.
      for (final v in a.violations) {
        if (v.from != picked && !v.to.contains(picked)) continue;
        final s = index[v.from];
        if (s == null) continue;
        involved.add(s);
        final color = findingColor(c, v.severity);
        for (final t in v.to) {
          final e = index[t];
          if (e == null || e == s || (v.from != picked && t != picked)) continue;
          involved.add(e);
          final path = _route(l.boxes[s], l.boxes[e]);
          canvas.drawPath(v.severity == 'accepted' ? dashed(path) : path, _stroke(color, 2));
          final m = path.computeMetrics().last;
          final tan = m.getTangentForOffset(m.length - .5);
          final tip = m.getTangentForOffset(m.length)!.position;
          drawHead(canvas, tip, tan == null ? const Offset(0, 1) : tan.vector / tan.vector.distance, Head.filled, color, size: 9);
        }
      }
    }
    for (final (i, n) in l.names.indexed) {
      final r = l.boxes[i];
      final far = picked != null && picked != n && !involved.contains(i);
      canvas.saveLayer(r.inflate(3), Paint()..color = Colors.black.withValues(alpha: far ? .3 : 1));
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(6));
      final w = l.worst[n];
      final tint = w == null ? null : findingColor(c, violationSeverities[w.clamp(0, 3)]);
      canvas.drawRRect(rr, Paint()..color = tint == null ? Color.alphaBlend(c.fill, c.card) : Color.alphaBlend(tint.withValues(alpha: .12), c.card));
      canvas.drawRRect(rr, _stroke(picked == n ? c.blue : (tint ?? c.label3), picked == n ? 2.2 : 1.2));
      final tp = l.texts[i];
      var x = r.left + 10;
      if (tint != null) {
        final icon = w == violationSeverities.indexOf('accepted') ? Icons.info_outline_rounded : Icons.warning_amber_rounded;
        final ip = textPainter(
          String.fromCharCode(icon.codePoint),
          l.small.copyWith(fontFamily: icon.fontFamily, package: icon.fontPackage, fontSize: _icon, height: 1, color: tint),
        );
        ip.paint(canvas, Offset(x, r.center.dy - ip.height / 2));
        x += _icon + 4;
      }
      tp.paint(canvas, Offset(x, r.center.dy - tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ArchPainter old) => old.l != l || old.picked != picked || old.c != c;
}
