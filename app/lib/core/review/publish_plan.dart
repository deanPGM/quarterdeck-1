// Port of Skim's packages/core/src/publish-plan.ts and summary.ts: what a
// publish posts, what it skips and why, and the summary note. Pure, provider
// neutral: GitLab and GitHub both follow the same plan.
import 'anchors.dart';
import 'diff.dart';
import 'review.dart';

/// The open threads with an accepted answer a publish would post (with their anchor
/// on the current head), the ones an earlier failed attempt already posted,
/// and the ones it must skip. [unpushed]: thread id to the fix commit its
/// answer names that is not on the forge yet.
typedef PublishPlan = ({List<({Thread thread, Anchor? anchor})> post, List<Thread> alreadyPosted, List<({String threadId, String reason})> skipped});

/// [own]: your own merge request. A thread that never was on it (Claude's
/// finding, your own note) stays in Deck: you fix it, you do not comment on
/// your own merge request. Only replies to the reviewers go out.
PublishPlan planPublish(List<Thread> threads, DiffSnapshot snapshot, {Map<String, String> unpushed = const {}, bool own = false}) {
  final post = <({Thread thread, Anchor? anchor})>[], already = <Thread>[], skipped = <({String threadId, String reason})>[];
  for (final t in threads.where((t) => t.state == 'open')) {
    if (t.remoteId != null) {
      already.add(t);
      continue;
    }
    if (!goesOut(t) || own) continue;
    if (unpushed[t.id] case final sha?) {
      skipped.add((threadId: t.id, reason: _unpushed(sha)));
      continue;
    }
    // A thread about the whole change cannot go stale: no line under it moves.
    final a = t.anchor;
    if (a == null) {
      post.add((thread: t, anchor: null));
      continue;
    }
    final placed = reanchor(a, snapshot);
    if (placed.status == 'outdated') {
      skipped.add((threadId: t.id, reason: 'outdated: ${a.path}:${a.line} is no longer in the diff'));
      continue;
    }
    post.add((thread: t, anchor: placed.anchor));
  }
  return (post: post, alreadyPosted: already, skipped: skipped);
}

String _unpushed(String sha) => sha == 'uncommitted' ? 'its fix is not committed yet' : 'its fix ${sha.substring(0, sha.length.clamp(0, 8))} is not pushed yet';

/// A reviewer thread on your own merge request whose last word is a
/// reviewer's, not yours ([me], the author): it waits on you. Pulled notes
/// start with their author's name.
bool waitsOnYou(Thread t, {required String me}) {
  final last = t.messages.lastWhere(
    isPosted,
    orElse: () => const Message(id: '', author: 'user', body: ''),
  );
  return t.authorType == 'remote' && t.state == 'published' && last.author == 'remote' && !last.body.startsWith('**@$me**');
}

/// A thread on the merge request that asks nothing of you now, so its card
/// starts folded. It needs you while Claude works on it, while it has an
/// answer to decide or to send, or when the other side spoke last: a reviewer
/// on your own merge request ([own], [author] is you), the author otherwise.
bool quietOnForge(Thread t, {required bool own, required String author}) {
  if (t.state != 'published' || t.waiting) return false;
  if (t.answer != null && (t.decision == null || goesOut(t))) return false;
  if (own) return !waitsOnYou(t, me: author);
  final last = t.messages.lastWhere(
    isPosted,
    orElse: () => const Message(id: '', author: 'user', body: ''),
  );
  return !(last.author == 'remote' && last.body.startsWith('**@$author**'));
}

/// Accepted answers going out as replies on discussions already on the forge, except
/// on [exclude] (posted in this round) and the ones whose fix is [unpushed].
List<Thread> plannedReplies(List<Thread> threads, Set<String> exclude, {Map<String, String> unpushed = const {}}) => [
  for (final t in threads)
    if (t.remoteId != null && goesOut(t) && !exclude.contains(t.id) && !unpushed.containsKey(t.id)) t,
];

/// A reply that approves the author's answer (the round's `Fixed in <sha>.`
/// or `Agreed, not an issue.`) also resolves the thread once posted: only on
/// someone else's merge request, on a thread of ours already published.
bool resolvesThread(Thread t, {required bool own}) =>
    !own &&
    t.state == 'published' &&
    t.authorType != 'remote' &&
    t.remoteId != null &&
    RegExp(r'^(fixed\b|agreed, not an issue)', caseSensitive: false).hasMatch(t.answer?.body.trimLeft() ?? '');

/// How a forge spells a suggestion replacing the anchored line and [span] lines below it.
typedef SuggestionSyntax = String Function(String suggestion, int span);

/// The lines a suggestion replaces the anchored ones with: a patch gives its
/// added lines, any other text is used as is.
List<String> suggestionLines(String suggestion) {
  final lines = suggestion.replaceFirst(RegExp(r'\n$'), '').split('\n');
  final isPatch = lines.any((l) => RegExp(r'^[+-]').hasMatch(l)) && lines.every((l) => RegExp(r'^[+\- @\\]').hasMatch(l) || l.isEmpty);
  return isPatch
      ? [
          for (final l in lines)
            if (l.startsWith('+') && !l.startsWith('+++')) l.substring(1),
        ]
      : lines;
}

/// GitLab's suggestion: `-0+N` covers the commented line and N below it.
String suggestionBlock(String suggestion, int span) => ['```suggestion:-0+$span', ...suggestionLines(suggestion), '```'].join('\n');

/// GitHub's: no range, the comment's own start_line..line is what it replaces.
String gitHubSuggestion(String suggestion, int span) => ['```suggestion', ...suggestionLines(suggestion), '```'].join('\n');

/// The opening note: the answer, plus its suggestion block. A thread about
/// the whole change carries none.
String threadBody(Thread t, [SuggestionSyntax block = suggestionBlock]) => t.answer == null ? '' : messageBody(t.answer!, t, block);

String messageBody(Message m, Thread t, [SuggestionSyntax block = suggestionBlock]) {
  final s = m.suggestion, a = t.anchor;
  return s != null && s.isNotEmpty && a != null ? '${m.body}\n\n${block(s, a.endLine - a.line)}' : m.body;
}

typedef SummaryTicket = ({String ref, String? url, String? title, TicketCheck? check});

const _ticketVerdicts = {
  'fulfilled': 'Does what the ticket asks',
  'partial': 'Partly done',
  'not_addressed': 'Does not address the ticket',
  'unclear': 'Ticket too thin to judge',
};

const _verdicts = {'approve': 'Approved', 'comment': 'Comments, no verdict', 'request_changes': 'Changes requested'};

/// The summary note of a round, in the markdown both forges render.
String renderSummary({
  required int roundNumber,
  required String verdict,
  required List<FileNote> notes,
  required List<ReviewGroup> groups,
  required int hiddenCount,
  required List<String> publishedSeverities,
  required int skipped,
  required int replies,
  List<SummaryTicket> tickets = const [],
  String? headSha,
}) {
  final out = ['## Review, round $roundNumber', '', '**${_verdicts[verdict]}**', ''];
  // What is missing and what nobody asked for is what the author needs; done items they know.
  for (final t in tickets) {
    final c = t.check;
    if (c == null) continue;
    final name = t.url == null ? t.ref : '[${t.ref}](${t.url})';
    out.addAll(['### Ticket $name${t.title == null || t.title!.isEmpty ? '' : ', ${t.title}'}', '']);
    if (headSha != null && c.headSha != headSha)
      out.addAll(['_Written against ${c.headSha.substring(0, c.headSha.length.clamp(0, 8))}, not the head of this round._', '']);
    out.addAll(['**${_ticketVerdicts[c.verdict]}.** ${c.summary}', '']);
    final missing = c.items.where((i) => i.state == 'missing'), extra = c.items.where((i) => i.state == 'extra');
    if (missing.isNotEmpty) out.addAll(['Missing:', '', for (final i in missing) '- ${i.text}', '']);
    if (extra.isNotEmpty) {
      out.addAll(['Not in the ticket:', '', for (final i in extra) '- ${i.text}${i.paths.isEmpty ? '' : ' (${i.paths.map((p) => '`$p`').join(', ')})'}', '']);
    }
  }
  final noteOf = {for (final n in notes) n.path: n};
  final placed = <String>{};
  if (groups.isNotEmpty) {
    out.addAll(['### Reading order', '']);
    for (final (i, g) in groups.indexed) {
      out.add('${i + 1}. **${g.title}**${g.overview.isEmpty ? '' : ': ${g.overview}'}');
      for (final path in {for (final it in g.items) it.path}) {
        placed.add(path);
        final n = noteOf[path];
        out.add('   - `$path`${n == null ? '' : ': ${n.summary}'}');
      }
    }
    out.add('');
  }
  final loose = notes.where((n) => !placed.contains(n.path));
  if (loose.isNotEmpty) out.addAll([groups.isEmpty ? '### Files' : '### Other files', '', for (final n in loose) '- `${n.path}`: ${n.summary}', '']);
  out.addAll(['### Findings', '']);
  if (publishedSeverities.isEmpty) {
    out.add('No inline threads in this round.');
  } else {
    final by = [
      for (final s in severities)
        if (publishedSeverities.where((x) => x == s).length case final n when n > 0) '$n $s',
    ];
    out.add('${_count(publishedSeverities.length, 'inline thread')}: ${by.join(', ')}.');
  }
  if (replies > 0) out.add('${_count(replies, 'reply', 'replies')} on earlier threads.');
  if (skipped > 0) out.add('${_count(skipped, 'finding')} not posted: the lines moved since the finding was written.');
  out.add('');
  if (hiddenCount > 0)
    out.addAll(['### Noise', '', '${_count(hiddenCount, 'file')} hidden from the review: generated, lock files, formatting only or moved only.', '']);
  return out.join('\n').trimRight();
}

String _count(int n, String one, [String? many]) => '$n ${n == 1 ? one : many ?? '${one}s'}';

typedef PublishSkip = ({String threadId, String reason});

/// What a publish posted, or would post.
class PublishPreview {
  const PublishPreview({
    required this.roundNumber,
    required this.posting,
    required this.skipped,
    required this.replies,
    required this.summary,
    this.pushes = 0,
  });

  final int roundNumber;

  /// Accepted fix commits pushed to the merge request branch first.
  final int pushes;
  final List<Thread> posting;
  final List<PublishSkip> skipped;
  final int replies;

  /// The summary note as posted, or null when turned off.
  final String? summary;
}

class PublishResult {
  const PublishResult({required this.round, required this.published, required this.skipped, required this.replies});

  final Round round;
  final int published;
  final List<PublishSkip> skipped;
  final int replies;
}

/// The message that asks Claude to fix a thread. The answer prompt keys on it.
const fixNow = 'Fix it now.';

/// The message sent when you reject a reviewer's point on your own merge
/// request: Claude writes the reply that says why, and it goes out on the
/// next publish.
const declineNow = 'Decline it.';

/// The user's last word on [t] is [declineNow].
bool declined(Thread t) =>
    t.messages
        .lastWhere(
          (m) => m.author == 'user',
          orElse: () => const Message(id: '', author: '', body: ''),
        )
        .body ==
    declineNow;

/// [t]'s answer goes to the merge request once accepted: always on someone
/// else's, only as a reply to a reviewer on your own.
bool postsOnForge(Thread t, {required bool own}) => !own || t.remoteId != null;

/// Accepted, still open, and no fix made or asked for yet: Fix all takes it.
/// Only on a branch that is yours (your own merge request, a local branch).
bool needsFix(Thread t) =>
    t.decision == 'accept' &&
    t.fix == null &&
    !t.waiting &&
    (t.state == 'open' || t.state == 'published') &&
    !t.messages.any((m) => m.author == 'user' && m.body.startsWith(fixNow));
