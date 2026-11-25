// Slack message or mail, already judged by Claude → card. Returns null when
// the message needs nothing from the user. Mail noise is grouped per sender,
// so one card offers a Gmail filter for all of it.
import '../models/card.dart';
import '../models/records.dart';
import 'time.dart';

/// Gmail link that lists one sender's mail.
String senderSearchUrl(String email) => 'https://mail.google.com/mail/u/0/#search/${Uri.encodeComponent('from:$email')}';

/// Gmail's create filter form, with From filled in.
String gmailFilterUrl(String email) => 'https://mail.google.com/mail/u/0/#create-filter/from=${Uri.encodeComponent(email)}';

DeckCard? classifyMessage(MessageRecord m, String provider, DateTime now) {
  final mail = provider == 'mail';
  final kind = mail ? m.kind ?? (m.ask ? 'ask' : null) : null;
  final idle = daysSince(m.at, now);
  DeckCard card({required String next, required int score, List<CardTag> tags = const [], Bucket bucket = Bucket.action}) => DeckCard(
    key: '$provider:${m.id}',
    provider: provider,
    lane: m.task ? Lane.task : Lane.reply,
    ref: m.where ?? provider,
    url: m.url,
    title: m.title,
    next: next,
    why: m.from == null ? null : 'From ${m.from}',
    tags: tags,
    bucket: bucket,
    score: score,
    updatedAt: m.at,
    author: m.from,
    channel: m.where,
    project: m.project,
    kind: kind,
    // A phishing mail stays in the inbox until you report it.
    threads: mail && kind != 'phishing' ? [m.id] : const [],
    refs: [?m.about],
  );
  if (kind == 'phishing') {
    return card(next: 'Looks like phishing. Report it in Gmail, never click its links.', score: 95, tags: const [CardTag(TagTone.warn, 'Phishing?')]);
  }
  if (kind == 'fyi' && !m.done) return card(next: 'Nothing asked. Archive it once read.', score: 30, tags: const [CardTag(TagTone.neutral, 'FYI')]);
  // A reply is over once you answered; a task once you mark it done.
  if (!m.ask || (m.done && !m.task)) return null;
  return card(
    next: m.need ?? 'Answer it.',
    score: (m.urgent ? 90 : 70) + (idle < 10 ? idle : 10),
    tags: [
      if (m.urgent) const CardTag(TagTone.act, 'Urgent'),
      // Asked of the team in a project channel, not of you.
      if (m.team) const CardTag(TagTone.neutral, 'Team'),
      if (m.waiting) CardTag(TagTone.neutral, 'Waiting on ${m.from ?? 'them'}'),
      if (idle >= 3) CardTag(TagTone.warn, '${idle}d old'),
    ],
    bucket: m.waiting ? Bucket.blocked : Bucket.action,
  );
}

final _item = RegExp(r'^(.*?)([!#])(\d+)$');

/// True when a notification about [about] concerns a card already on the
/// board: same Jira key, or same merge request or issue number in a project
/// whose name matches.
bool onBoard(String about, Iterable<DeckCard> cards) => boardCard(about, cards) != null;

/// The card on the board [about] names, or null.
DeckCard? boardCard(String about, Iterable<DeckCard> cards) {
  final a = about.trim().toLowerCase();
  final m = _item.firstMatch(a);
  for (final c in cards) {
    if (c.ref.toLowerCase() == a) return c;
    if (m == null) continue;
    final n = int.parse(m[3]!);
    final number = c.iid == n || c.ref.endsWith('${m[2]}$n');
    final project = m[1]!.trim();
    if (number && (project.isEmpty || c.ref.toLowerCase().startsWith('$project${m[2]}') || (c.path?.toLowerCase().endsWith('/$project') ?? false))) {
      return c;
    }
  }
  return null;
}

/// Asks already tracked elsewhere make no card of their own. One about a
/// card on the [board] becomes a note line on it (in `notes`, by card key);
/// a team message about an existing ticket that is not on the board is
/// dropped. Messages that already have a card ([have]) are kept, so a
/// recheck still updates or closes them.
({List<MessageRecord> keep, Map<String, List<String>> notes}) foldTracked(
  List<MessageRecord> msgs,
  Iterable<DeckCard> board,
  Set<String> have,
  String provider,
) {
  final keep = <MessageRecord>[];
  final notes = <String, List<String>>{};
  for (final m in msgs) {
    final about = m.about;
    if (!m.ask || about == null || have.contains('$provider:${m.id}')) {
      keep.add(m);
      continue;
    }
    if (boardCard(about, board) case final c?) {
      final from = [?m.from, if (m.where != null && m.where != 'DM') 'in ${m.where}'].join(' ');
      (notes[c.key] ??= []).add('${from.isEmpty ? 'Message' : 'From $from'}: ${m.need ?? m.title} ${m.url}');
    } else if (!m.team) {
      keep.add(m);
    }
  }
  return (keep: keep, notes: notes);
}

final _platform = RegExp(r'^(gitlab@mg\.gitlab\.com|notifications@github\.com|.+@.+\.atlassian\.net)$');

String _sender(MessageRecord m) => (m.where ?? m.from ?? 'unknown').trim().toLowerCase();

/// Card key of a sender's noise group.
String noiseKey(MessageRecord m) => 'mail:from:${_sender(m)}';

/// Adds noise mail [m] to its sender's [group] card, or starts one.
DeckCard noiseCard(MessageRecord m, DeckCard? group) {
  final email = _sender(m);
  final threads = {...?group?.threads, m.id}.toList();
  final n = threads.length;
  final last = group?.updatedAt;
  final newest = last == null || !last.isAfter(m.at);
  final from = m.from ?? email;
  return DeckCard(
    key: noiseKey(m),
    provider: 'mail',
    lane: Lane.reply,
    ref: email,
    url: senderSearchUrl(email),
    // The subject says what it is about; the sender goes in why.
    title: newest || group == null ? m.title : group.title,
    next: 'Make a Gmail filter so these skip the inbox.',
    why: n == 1 ? 'From $from' : 'From $from, $n mails in the inbox',
    tags: const [CardTag(TagTone.neutral, 'Noise')],
    bucket: Bucket.action,
    score: 40 + (n < 10 ? n : 10),
    updatedAt: newest ? m.at : last,
    author: m.from,
    channel: email,
    kind: 'noise',
    threads: threads,
  );
}

/// The sender email of a FYI or noise mail card, whose inbox Deck checks to
/// close it once archived. Null for other cards, or with no email.
String? inboxSender(DeckCard c) {
  if (c.provider != 'mail' || (c.kind != 'fyi' && c.kind != 'noise') || c.threads.isEmpty) return null;
  final email = c.channel?.trim().toLowerCase();
  // It goes into a Gmail query: a sender a mail made up could not change it.
  return email != null && _email.hasMatch(email) ? email : null;
}

final _email = RegExp(r'^[a-z0-9._%+\-]+@[a-z0-9.\-]+$');

/// Keys of the FYI and noise mail cards whose threads all left the inbox
/// (you archived them in Gmail), from the thread ids still in it [bySender].
/// Asks stay: archiving does not answer them. A card whose sender was not
/// listed stays too. Only cards last updated before [listedAt], so mail that
/// came in after the inbox was listed is not closed.
List<String> leftInbox(Iterable<DeckCard> cards, Map<String, Set<String>> bySender, DateTime listedAt) => [
  for (final c in cards)
    if (bySender[inboxSender(c)] case final inbox? when !c.threads.any(inbox.contains) && (c.updatedAt?.isBefore(listedAt) ?? true)) c.key,
];

/// Merges fresh message records into the open cards. A card whose record now
/// says done is kept and returned in `replied`, so the caller closes it. A
/// record that is no longer an ask leaves the old card as it was. A new
/// message older than [since] (the last check) was already seen: skipped, so a
/// card you closed never comes back under another id.
({List<DeckCard> cards, List<String> replied}) mergeMessages(List<DeckCard> old, List<MessageRecord> msgs, String provider, DateTime now, {DateTime? since}) {
  final byKey = {for (final c in old) c.key: c};
  final replied = <String>[];
  for (var m in msgs) {
    final key = '$provider:${m.id}';
    // A filter on these senders would also hide mentions and assignments.
    if (m.kind == 'noise' && _platform.hasMatch(_sender(m))) m = m.copyWith(kind: 'fyi');
    if (provider == 'mail' && m.kind == 'noise' && !byKey.containsKey(key)) {
      final group = byKey[noiseKey(m)];
      if (since != null && m.at.isBefore(since) && !(group?.threads.contains(m.id) ?? false)) continue;
      byKey[noiseKey(m)] = noiseCard(m, group);
      continue;
    }
    if (since != null && m.at.isBefore(since) && !byKey.containsKey(key)) continue;
    final card = classifyMessage(m, provider, now);
    if (card != null) {
      byKey[key] = card;
    } else if (m.done && byKey.containsKey(key)) {
      replied.add(key);
    }
  }
  return (cards: byKey.values.toList(), replied: replied);
}
