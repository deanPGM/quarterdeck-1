// Gemini meeting notes: the next steps assigned to you become todos. Claude
// only copies the "Suggested next steps" text; who a step is for is read here.

/// Steps in [text] whose names include [name], full ("Ann Lee") or first name
/// only ("Ann"). Gemini writes one step per paragraph:
/// "[Ann Lee, Bob Ray] Title: what to do", wrapped over lines.
List<({String title, String need})> stepsFor(String text, String name) {
  final me = name.trim().toLowerCase();
  if (me.isEmpty) return const [];
  return [
    for (final p in text.split(RegExp(r'\n\s*\n')))
      if (RegExp(r'^\[([^\]]+)\]\s*([^:]+):\s*(.+)$', dotAll: true).firstMatch(p.trim()) case final m?
          when m[1]!.split(',').map((n) => n.trim().toLowerCase()).any((n) => n == me || n.startsWith('$me ')))
        (title: _flat(m[2]!), need: _flat(m[3]!)),
  ];
}

String _flat(String s) => s.trim().replaceAll(RegExp(r'\s+'), ' ');

/// An open card a meeting step may be about: a merge request, an issue, a todo.
typedef NoteTarget = ({String key, String ref, String title});

/// The card [step] is about, or null for a new todo. One it names wins
/// (vpn-ios!412, !412, #12, VPN-131) when only one card fits, else the card
/// Claude linked to the step's title in [links] (step title → card key).
String? stepCard(({String title, String need}) step, List<NoteTarget> targets, Map<String, String> links) {
  final text = '${step.title} ${step.need}';
  // A todo has no ref: only Claude links to it.
  final refs = targets.where((t) => t.ref.isNotEmpty);
  // The full ref first (vpn-ios!412), then the short one (!412).
  final full = [
    for (final t in refs)
      if (RegExp('(^|[^\\w-])${RegExp.escape(t.ref)}\\b').hasMatch(text)) t.key,
  ];
  if (full.length == 1) return full.single;
  final short = [
    for (final t in refs)
      if (RegExp(r'[!#]\d+$').firstMatch(t.ref) case final m? when RegExp('(^|[^\\w])${RegExp.escape(m[0]!)}\\b').hasMatch(text)) t.key,
  ];
  if (full.isEmpty && short.length == 1) return short.single;
  final linked = links[_flat(step.title).toLowerCase()];
  return targets.any((t) => t.key == linked) ? linked : null;
}

/// [links] as Claude sent them: [{step, card}], keyed by the step title.
Map<String, String> stepLinks(Object? links) => {
  for (final l in (links as List?)?.whereType<Map>() ?? const <Map>[])
    if ((l['step'], l['card']) case (final String s, final String c)) _flat(s).toLowerCase(): c,
};
