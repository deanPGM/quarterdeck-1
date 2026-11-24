// Closing cards from evidence: a merged MR, a reply you sent. Deck only marks
// them done with a reason, so you can reopen them from the Done view.
import 'models/card.dart';
import 'models/snapshot.dart';

/// The project path and iid of a GitLab merge request link, or null.
(String, int)? mrOfUrl(String url) {
  final m = RegExp(r'^https://[^/]+/(.+?)/-/merge_requests/(\d+)').firstMatch(url);
  return m == null ? null : (m[1]!, int.parse(m[2]!));
}

/// Todos that point at a GitLab merge request and are still open.
Iterable<(DeckCard, String, int)> openMrTodos(Snapshot todos, Map<String, Triage> triage) sync* {
  for (final c in todos.cards) {
    final t = triage[c.key] ?? const Triage();
    if (t.done || t.keepOpen) continue;
    if (mrOfUrl(c.url) case (final path, final iid)) yield (c, path, iid);
  }
}

/// Triage after Deck closes [keys] for [reason]. Skips cards already done or
/// reopened by you.
Map<String, Triage> closeCards(Map<String, Triage> triage, Iterable<String> keys, String reason, {DateTime? at}) => {
  ...triage,
  for (final k in keys)
    if (!(triage[k]?.done ?? false) && !(triage[k]?.keepOpen ?? false))
      k: (triage[k] ?? const Triage()).copyWith(done: true, doneReason: reason, doneAt: at, startedAt: null),
};
