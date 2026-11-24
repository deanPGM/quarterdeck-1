// Links between cards: a Slack ask about a Jira ticket, the merge request that
// fixes it. Found from what each card mentions (its title, link, branch, and
// the item Claude read a message is about), plus the links you made or cut by
// hand. Pure, so it is easy to test.
import 'models/card.dart';

/// One stored key per pair of cards, the same whichever comes first.
String pairKey(String a, String b) => a.compareTo(b) < 0 ? '$a|$b' : '$b|$a';

/// A Jira key ("AVPN-65", "feat/avpn-123-login"), any case.
final _jira = RegExp(r'(?<![A-Za-z0-9])([A-Za-z][A-Za-z0-9]{1,9}-\d+)(?![A-Za-z0-9])');

/// A merge request link, or "project!955" as Claude and GitLab write it.
final _mrUrl = RegExp(r'https://[^\s/]+/(\S+?)/-/merge_requests/(\d+)');
final _mrRef = RegExp(r'([A-Za-z0-9_.-]+)!(\d+)');

/// The ids a card is known by: a Jira key, a merge request "project!iid".
/// Lower case.
Set<String> idsOf(DeckCard c) => {
  if (c.provider == 'jira') c.ref.toLowerCase(),
  if (c.path != null && c.iid != null) '${c.path!.split('/').last}!${c.iid}'.toLowerCase(),
};

/// The ids a card mentions: in its title, its link and its [DeckCard.refs].
/// Most are words that look like ids but match no card; only ids of cards on
/// the board make a link, so "UTF-8" in a title links nothing.
Set<String> mentionsOf(DeckCard c) {
  final out = <String>{};
  for (final text in [c.title, c.url, ...c.refs]) {
    for (final m in _jira.allMatches(text)) {
      out.add(m[1]!.toLowerCase());
    }
    for (final m in _mrUrl.allMatches(text)) {
      out.add('${m[1]!.split('/').last}!${m[2]}'.toLowerCase());
    }
    for (final m in _mrRef.allMatches(text)) {
      out.add('${m[1]}!${m[2]}'.toLowerCase());
    }
  }
  return out..removeAll(idsOf(c));
}

/// A card [key] linked to another, and whether you made the link by hand.
typedef CardLink = ({String key, bool manual});

/// Each card's links, both ways. [manual] holds your choices per [pairKey]:
/// true is a link you made, false one you cut (it is not found again).
Map<String, List<CardLink>> linksOf(Iterable<DeckCard> cards, Map<String, bool> manual) {
  final keys = {for (final c in cards) c.key};
  final byId = <String, Set<String>>{};
  for (final c in cards) {
    for (final id in idsOf(c)) {
      (byId[id] ??= {}).add(c.key);
    }
  }
  final pairs = <String, (String, String, bool)>{};
  for (final c in cards) {
    for (final id in mentionsOf(c)) {
      for (final k in byId[id] ?? const <String>{}) {
        if (k != c.key) pairs[pairKey(c.key, k)] = (c.key, k, false);
      }
    }
  }
  for (final e in manual.entries) {
    if (e.key.split('|') case [final a, final b]) {
      if (!e.value) {
        pairs.remove(e.key);
      } else if (keys.contains(a) && keys.contains(b)) {
        pairs[e.key] = (a, b, true);
      }
    }
  }
  final out = <String, List<CardLink>>{};
  for (final (a, b, hand) in pairs.values) {
    (out[a] ??= []).add((key: b, manual: hand));
    (out[b] ??= []).add((key: a, manual: hand));
  }
  return out;
}
