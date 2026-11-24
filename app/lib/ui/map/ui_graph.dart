// The UI as a usage graph: screens on top, the shared components they use
// below, and under them the pieces built twice. A line per use; a dashed line
// from a copy to the component it should use. A class that breaks a UI rule
// or is copied wears a warning. A picked box shows its own lines only.
// Pure widget: data and a callback.
import 'package:flutter/material.dart';

import '../../core/map/models.dart';
import '../theme.dart';
import '../severity.dart';
import 'diagram_paint.dart';

const _head = 170.0, _boxH = 30.0, _gapX = 10.0, _gapY = 10.0, _pad = 12.0, _bandGap = 40.0, _icon = 15.0;

class UiGraph extends StatelessWidget {
  const UiGraph({super.key, required this.ui, this.picked, this.onPick});
  final MapUi ui;

  /// The box shown with its lines, null for every line.
  final String? picked;

  /// A box was clicked, or null when the empty picture was.
  final ValueChanged<String?>? onPick;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final l = _UiLayout(context, ui, box.maxWidth);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: picked == null ? null : () => onPick?.call(null),
        child: SizedBox(
          width: box.maxWidth,
          height: l.size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _UiPainter(l, context.c, picked: picked)),
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

class _UiLayout {
  _UiLayout(BuildContext context, this.ui, double width) {
    final c = context.c, t = context.t;
    final style = mono(t.bodySmall!.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600, color: c.label));
    final components = {for (final x in ui.components) x.name};
    // The copies that are not a shared component themselves, each once.
    final copies = <String>{
      for (final d in ui.duplicates)
        for (final x in d.copies)
          if (!components.contains(x.name)) x.name,
    };
    final bandsOf = [
      ('Screens', 'What the user sees.', [for (final s in ui.screens) s.name]),
      ('Shared', 'Built once, used by screens.', components.toList()),
      if (copies.isNotEmpty) ('Built twice', 'Copies of a shared piece.', copies.toList()),
    ];
    void flag(String name, String severity) {
      final k = violationSeverities.indexOf(severity);
      if (name.isNotEmpty && k >= 0 && (!worst.containsKey(name) || k < worst[name]!)) worst[name] = k;
    }

    for (final d in ui.duplicates) {
      for (final x in d.copies) {
        if (!components.contains(x.name)) flag(x.name, d.severity);
      }
    }
    for (final b in ui.breaks) {
      flag(b.where, b.severity);
    }
    for (final s in ui.screens) {
      for (final u in s.uses) {
        if (components.contains(u)) uses.add((s.name, u));
      }
    }
    for (final d in ui.duplicates) {
      for (final x in d.copies) {
        if (x.name != d.use && components.contains(d.use) && !components.contains(x.name)) shouldUse.add((x.name, d.use, d.severity));
      }
    }
    final right = width - _pad;
    var y = 0.0;
    for (final (i, (title, role, items)) in bandsOf.indexed) {
      if (i > 0) y += _bandGap;
      final top = y;
      var x = _head, rowTop = top + _pad;
      for (final name in items) {
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
      final name = textPainter(title, t.titleSmall!.copyWith(fontSize: 13, color: c.label), maxWidth: text, maxLines: 1);
      final sub = textPainter(role, t.bodySmall!.copyWith(fontSize: 11, height: 1.3, color: c.label2), maxWidth: text, maxLines: 3);
      y = [rowTop + _boxH + _pad, top + _pad + name.height + 3 + sub.height + _pad].reduce((a, b) => a > b ? a : b);
      bands.add(Rect.fromLTRB(0, top, width, y));
      labels.add((name, sub));
    }
    size = Size(width, y);
  }

  final MapUi ui;
  final names = <String>[];
  final texts = <TextPainter>[];
  final boxes = <Rect>[];
  final bands = <Rect>[];
  final labels = <(TextPainter, TextPainter)>[];

  /// The worst severity index of each class copied or breaking a rule.
  final worst = <String, int>{};

  /// Screen uses component.
  final uses = <(String, String)>[];

  /// Copy should use component, with the duplicate's severity.
  final shouldUse = <(String, String, String)>[];
  late final Size size;
}

class _UiPainter extends CustomPainter {
  _UiPainter(this.l, this.c, {required this.picked});
  final _UiLayout l;
  final DeckColors c;
  final String? picked;

  Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;

  /// A line from the bottom of [from] to the top of [to], or the other way up.
  Path _route(Rect from, Rect to) {
    final down = to.center.dy > from.center.dy;
    final p0 = down ? from.bottomCenter : from.topCenter, p1 = down ? to.topCenter : to.bottomCenter;
    final bend = (p1.dy - p0.dy) * .5;
    return Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(p0.dx, p0.dy + bend, p1.dx, p1.dy - bend, p1.dx, p1.dy);
  }

  void _line(Canvas canvas, Rect from, Rect to, Color color, double width, {bool dash = false}) {
    final path = _route(from, to);
    canvas.drawPath(dash ? dashed(path) : path, _stroke(color, width));
    final m = path.computeMetrics().last;
    final tan = m.getTangentForOffset(m.length - .5);
    drawHead(
      canvas,
      m.getTangentForOffset(m.length)!.position,
      tan == null ? const Offset(0, 1) : tan.vector / tan.vector.distance,
      Head.filled,
      color,
      size: 7,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final (i, r) in l.bands.indexed) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(10)), Paint()..color = c.card);
      final (name, sub) = l.labels[i];
      name.paint(canvas, Offset(r.left + 16, r.top + _pad));
      sub.paint(canvas, Offset(r.left + 16, r.top + _pad + name.height + 3));
    }
    final index = {for (final (i, n) in l.names.indexed) n: i};
    final involved = <int>{};
    for (final (from, to) in l.uses) {
      final s = index[from], e = index[to];
      if (s == null || e == null) continue;
      final on = picked == from || picked == to;
      if (picked != null && !on) continue;
      if (on) involved.addAll([s, e]);
      _line(canvas, l.boxes[s], l.boxes[e], on ? c.blue : c.label3.withValues(alpha: .6), on ? 1.8 : 1);
    }
    for (final (from, to, severity) in l.shouldUse) {
      final s = index[from], e = index[to];
      if (s == null || e == null) continue;
      final on = picked == from || picked == to;
      if (picked != null && !on) continue;
      if (on) involved.addAll([s, e]);
      _line(canvas, l.boxes[s], l.boxes[e], findingColor(c, severity), 1.6, dash: true);
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
      var x = r.left + 10;
      if (tint != null) {
        final icon = w == violationSeverities.indexOf('accepted') ? Icons.info_outline_rounded : Icons.warning_amber_rounded;
        final ip = textPainter(
          String.fromCharCode(icon.codePoint),
          TextStyle(fontFamily: icon.fontFamily, package: icon.fontPackage, fontSize: _icon, height: 1, color: tint),
        );
        ip.paint(canvas, Offset(x, r.center.dy - ip.height / 2));
        x += _icon + 4;
      }
      l.texts[i].paint(canvas, Offset(x, r.center.dy - l.texts[i].height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_UiPainter old) => old.l != l || old.picked != picked || old.c != c;
}
