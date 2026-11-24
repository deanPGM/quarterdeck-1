// Deck's look: a calm macOS style split view (grey sidebar, white cards,
// tinted accents), in light and dark. Every color comes from DeckColors.
import 'package:flutter/material.dart';

@immutable
class DeckColors extends ThemeExtension<DeckColors> {
  const DeckColors({
    required this.bg,
    required this.sidebar,
    required this.card,
    required this.label,
    required this.label2,
    required this.label3,
    required this.sep,
    required this.fill,
    required this.blue,
    required this.green,
    required this.orange,
    required this.red,
    required this.indigo,
    required this.purple,
    required this.teal,
    required this.graphite,
    this.onAccent = const Color(0xFFFFFFFF),
    this.shadow = const Color(0xFF000000),
  });

  final Color bg, sidebar, card, label, label2, label3, sep, fill;
  final Color blue, green, orange, red, indigo, purple, teal, graphite;

  /// Icons and text on an accent fill.
  final Color onAccent;

  /// Base of every drop shadow, tinted with an alpha at each use.
  final Color shadow;

  /// The light lift under a card.
  List<BoxShadow> get cardShadow => [BoxShadow(color: shadow.withValues(alpha: .06), blurRadius: 3, offset: const Offset(0, 1))];

  /// [base] tinted orange: something waits on the user.
  Color waitingTint(Color base) => Color.alphaBlend(orange.withValues(alpha: .18), base);

  static const light = DeckColors(
    bg: Color(0xFFF2F2F7),
    sidebar: Color(0xFFE9E9EE),
    card: Color(0xFFFFFFFF),
    label: Color(0xFF1D1D1F),
    label2: Color(0xA33C3C43),
    label3: Color(0x573C3C43),
    sep: Color(0x293C3C43),
    fill: Color(0x1C787880),
    blue: Color(0xFF007AFF),
    green: Color(0xFF34C759),
    orange: Color(0xFFFF9500),
    red: Color(0xFFFF3B30),
    indigo: Color(0xFF5856D6),
    purple: Color(0xFFAF52DE),
    teal: Color(0xFF30B0C7),
    graphite: Color(0xFF48484A),
  );

  static const dark = DeckColors(
    bg: Color(0xFF0F0F11),
    sidebar: Color(0xFF19191B),
    card: Color(0xFF1C1C1E),
    label: Color(0xFFF5F5F7),
    label2: Color(0x99EBEBF5),
    label3: Color(0x4DEBEBF5),
    sep: Color(0x33EBEBF5),
    fill: Color(0x2E787880),
    blue: Color(0xFF0A84FF),
    green: Color(0xFF30D158),
    orange: Color(0xFFFF9F0A),
    red: Color(0xFFFF453A),
    indigo: Color(0xFF5E5CE6),
    purple: Color(0xFFBF5AF2),
    teal: Color(0xFF40C8E0),
    graphite: Color(0xFF8E8E93),
  );

  @override
  DeckColors copyWith() => this;

  @override
  DeckColors lerp(ThemeExtension<DeckColors>? other, double t) => t < .5 ? this : (other as DeckColors? ?? this);
}

extension DeckTheme on BuildContext {
  DeckColors get c => Theme.of(this).extension<DeckColors>()!;
  TextTheme get t => Theme.of(this).textTheme;
}

ThemeData deckTheme(Brightness b) {
  final c = b == Brightness.dark ? DeckColors.dark : DeckColors.light;
  final base = ThemeData(brightness: b, useMaterial3: true, colorSchemeSeed: c.blue, visualDensity: VisualDensity.compact);
  return base.copyWith(
    scaffoldBackgroundColor: c.bg,
    extensions: [c],
    dividerTheme: DividerThemeData(color: c.sep, thickness: .5, space: 1),
    // Start from the platform styles so each OS keeps its own system font.
    textTheme: () {
      final t = base.textTheme.apply(bodyColor: c.label, displayColor: c.label);
      return t.copyWith(
        headlineSmall: t.headlineSmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -.5),
        titleMedium: t.titleMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0),
        bodyMedium: t.bodyMedium!.copyWith(fontSize: 13.5, height: 1.35, letterSpacing: 0),
        bodySmall: t.bodySmall!.copyWith(fontSize: 12, height: 1.3, color: c.label2, letterSpacing: 0),
        labelSmall: t.labelSmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: c.label2, letterSpacing: .2),
      );
    }(),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: c.fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      hintStyle: base.textTheme.bodyMedium!.copyWith(color: c.label3, fontSize: 13),
    ),
    tooltipTheme: const TooltipThemeData(waitDuration: Duration(milliseconds: 500)),
  );
}

/// The mono font of the theme: code names read as code, with fallbacks for
/// Linux and Windows where Menlo is missing.
TextStyle mono(TextStyle s) => s.copyWith(fontFamily: 'Menlo', fontFamilyFallback: const ['Menlo', 'Consolas', 'monospace']);
