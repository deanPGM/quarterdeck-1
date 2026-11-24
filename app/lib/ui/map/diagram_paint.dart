// Drawing bits the map's three diagrams share: dashes, arrow heads, text and
// the small chips and links around the pictures.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

enum Head { none, filled, open, hollow, diamond, cross }

/// [path] cut into dashes. [dash] and [gap] in pixels.
Path dashed(Path path, {double dash = 5, double gap = 4}) {
  final out = Path();
  for (final m in path.computeMetrics()) {
    for (var d = 0.0; d < m.length; d += dash + gap) {
      out.addPath(m.extractPath(d, (d + dash).clamp(0, m.length)), Offset.zero);
    }
  }
  return out;
}

/// An arrow head with its tip at [tip], pointing along the unit vector [dir].
void drawHead(Canvas canvas, Offset tip, Offset dir, Head head, Color color, {double size = 9, Color? fill}) {
  if (head == Head.none) return;
  final n = Offset(-dir.dy, dir.dx);
  final back = tip - dir * size;
  final stroke = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.3
    ..strokeJoin = StrokeJoin.round;
  switch (head) {
    case Head.filled || Head.hollow:
      final p = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((back + n * size * .5).dx, (back + n * size * .5).dy)
        ..lineTo((back - n * size * .5).dx, (back - n * size * .5).dy)
        ..close();
      canvas.drawPath(p, Paint()..color = head == Head.filled ? color : (fill ?? Colors.transparent));
      canvas.drawPath(p, stroke);
    case Head.open:
      canvas.drawPath(
        Path()
          ..moveTo((back + n * size * .45).dx, (back + n * size * .45).dy)
          ..lineTo(tip.dx, tip.dy)
          ..lineTo((back - n * size * .45).dx, (back - n * size * .45).dy),
        stroke,
      );
    case Head.diamond:
      final mid = tip - dir * size * .75, end = tip - dir * size * 1.5;
      final p = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((mid + n * size * .45).dx, (mid + n * size * .45).dy)
        ..lineTo(end.dx, end.dy)
        ..lineTo((mid - n * size * .45).dx, (mid - n * size * .45).dy)
        ..close();
      canvas.drawPath(p, Paint()..color = color);
    case Head.cross:
      final c = tip - dir * size * .5, s = size * .4;
      canvas.drawLine(c + Offset(-s, -s), c + Offset(s, s), stroke);
      canvas.drawLine(c + Offset(-s, s), c + Offset(s, -s), stroke);
    case Head.none:
  }
}

/// Laid out text, at most [maxWidth] wide and [maxLines] long.
TextPainter textPainter(String text, TextStyle style, {double maxWidth = double.infinity, int? maxLines, TextAlign align = TextAlign.left}) => TextPainter(
  text: TextSpan(text: text, style: style),
  textDirection: TextDirection.ltr,
  textAlign: align,
  maxLines: maxLines,
  ellipsis: maxLines == null ? null : '…',
)..layout(maxWidth: maxWidth);

/// A label with a plate behind it, so a line under it does not cross the words.
void paintPlate(Canvas canvas, TextPainter tp, Offset center, Color plate) {
  final r = Rect.fromCenter(center: center, width: tp.width + 8, height: tp.height + 2);
  canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), Paint()..color = plate);
  tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
}

/// A picture of [size] drawn at its own size when it fits, shrunk to the
/// width it gets down to [minScale], then scrolled sideways past that: a wide
/// diagram shows whole instead of cut at the right edge. A button switches to
/// the whole picture at once when it still scrolls, or to full size when it
/// was shrunk. Taps land in the picture's own
/// coordinates. [padding] goes around it, outside the scale.
class FitWidth extends StatefulWidget {
  const FitWidth({super.key, required this.size, required this.child, this.padding = 16, this.minScale = .8, this.button = Alignment.topRight});
  final Size size;
  final Widget child;
  final double padding, minScale;

  /// The corner of the zoom button, one the picture leaves empty.
  final Alignment button;

  /// The scale [size] gets in [width], padding included.
  static double scaleIn(Size size, double width, {double padding = 16, double minScale = .8}) =>
      size.width <= 0 || !width.isFinite ? 1 : ((width - 2 * padding) / size.width).clamp(minScale, 1.0);

  @override
  State<FitWidth> createState() => _FitWidthState();
}

class _FitWidthState extends State<FitWidth> {
  final _scroll = ScrollController();
  var _full = false;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final size = widget.size, pad = widget.padding;
      final fit = FitWidth.scaleIn(size, box.maxWidth, padding: pad, minScale: widget.minScale);
      // Still wider than the room at the smallest readable scale: the other view is the whole of it.
      final clipped = size.width * fit + 2 * pad > box.maxWidth + .5;
      final whole = FitWidth.scaleIn(size, box.maxWidth, padding: pad, minScale: .3);
      final s = !_full ? fit : (clipped ? whole : 1.0);
      final picture = Scrollbar(
        controller: _scroll,
        thumbVisibility: size.width * s + 2 * pad > box.maxWidth,
        child: SingleChildScrollView(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          primary: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: box.maxWidth.isFinite ? box.maxWidth : 0),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(pad),
                child: SizedBox(
                  width: size.width * s,
                  height: size.height * s,
                  child: FittedBox(
                    alignment: Alignment.topLeft,
                    child: SizedBox.fromSize(size: size, child: widget.child),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      if (fit >= 1) return picture;
      final c = context.c;
      return Stack(
        children: [
          picture,
          Positioned.fill(
            child: Align(
              alignment: widget.button,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Tooltip(
                  message: _full ? 'Back to the readable size' : (clipped ? 'Show the whole diagram' : 'Full size'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => setState(() => _full = !_full),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: c.card,
                          border: Border.all(color: c.sep),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(clipped != _full ? Icons.zoom_out_map : Icons.zoom_in, size: 16, color: c.label2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// [name] with a break chance inside each CamelCase or snake_case word, so a
/// long code name wraps between its words instead of mid word.
String breakable(String name) => name.replaceAllMapped(RegExp(r'(?<=[a-z0-9])(?=[A-Z])|(?<=[_./(])(?=\w)'), (_) => '\u200B');

/// A rounded chip: a participant, a class name, a status.
class DiagramChip extends StatelessWidget {
  const DiagramChip(this.text, {super.key, this.color, this.code = false, this.onTap});
  final String text;
  final Color? color;
  final bool code;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c, tint = color ?? c.label2;
    final style = context.t.labelSmall!.copyWith(color: color ?? c.label);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: .1),
        border: Border.all(color: tint.withValues(alpha: .35)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: code ? mono(style) : style),
    );
    return onTap == null
        ? chip
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(onTap: onTap, child: chip),
          );
  }
}

/// Where a step or a class lives: `file.dart:12`, a link when [onOpen] is set.
class CodeLink extends StatelessWidget {
  const CodeLink({super.key, required this.path, this.line, this.onOpen});
  final String path;
  final int? line;
  final void Function(String path, int? line)? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final text = '${onOpen == null ? path : path.split('/').last}${line == null ? '' : ':$line'}';
    final style = mono(context.t.bodySmall!.copyWith(fontSize: 11, color: onOpen == null ? c.label2 : c.blue));
    if (onOpen == null) return Text(text, style: style);
    return Tooltip(
      message: path,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onOpen!(path, line),
          child: Text(text, style: style),
        ),
      ),
    );
  }
}

/// A small heading and its text, as in "What changed".
class Labeled extends StatelessWidget {
  const Labeled(this.label, this.text, {super.key});
  final String label, text;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: context.t.labelSmall),
      const SizedBox(height: 2),
      Text(text, style: context.t.bodyMedium!.copyWith(fontSize: 12.5)),
    ],
  );
}

/// [items] in as many columns of at least 280 pixels as [width] holds, read
/// down the first column, then the next: a long list under a wide picture.
Widget columns(List<Widget> items, double width) {
  final n = width.isFinite ? (width / 280).floor().clamp(1, 4) : 1;
  if (n == 1 || items.length < 6) return Column(children: items);
  final per = (items.length / n).ceil();
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var k = 0; k < n; k++) Expanded(child: Column(children: items.sublist(math.min(k * per, items.length), math.min((k + 1) * per, items.length)))),
    ],
  );
}

/// A clickable row in the list beside a diagram, blue when [current]. [joined]
/// squares its bottom corners for the detail box drawn under it.
class DiagramListItem extends StatelessWidget {
  const DiagramListItem({super.key, required this.current, required this.onTap, required this.child, this.joined = false});
  final bool current, joined;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: current ? context.c.blue.withValues(alpha: .12) : null,
          borderRadius: joined ? const BorderRadius.vertical(top: Radius.circular(6)) : BorderRadius.circular(6),
        ),
        child: child,
      ),
    ),
  );
}

/// The numbered circle of a step or a transition, filled blue when
/// [current]. [ring] outlines it, for a step with a mark.
class StepNumber extends StatelessWidget {
  const StepNumber(this.index, {super.key, required this.current, this.ring});
  final int index;
  final bool current;
  final Color? ring;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: current ? c.blue : c.fill,
        border: ring == null && !current ? null : Border.all(color: current ? c.blue : ring!, width: 1.5),
      ),
      child: Text('${index + 1}', style: context.t.labelSmall!.copyWith(fontSize: 10, color: current ? c.onAccent : c.label2)),
    );
  }
}
