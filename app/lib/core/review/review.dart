// What a review holds besides the diff: the merge request it is bound to, and
// what the review session wrote over the diff (a line per file and per hunk,
// the reading order, the pictures, the triage, the ticket check) plus what the
// reviewer marked viewed. One JSON file per review in state/reviews. Shapes
// and rules follow Skim's (packages/core/src/types.ts, review.ts).
import 'package:freezed_annotation/freezed_annotation.dart';

import '../map/models.dart';

part 'review.freezed.dart';
part 'review.g.dart';

const ticketVerdicts = ['fulfilled', 'partial', 'not_addressed', 'unclear'];
const ticketItemStates = ['done', 'missing', 'extra'];
const checkStates = ['ok', 'concern', 'unclear'];

const severities = ['must-fix', 'suggestion', 'nit', 'question'];

/// open: talked over with Claude, not on the forge yet. dismissed: closed
/// here, nothing goes out. published: on the forge, later answers go out as
/// replies. resolved: closed on the forge.
const threadStates = ['open', 'dismissed', 'published', 'resolved'];

/// user, agent, or remote (written on the forge, pulled in).
const authors = ['user', 'agent', 'remote'];
const verdicts = ['approve', 'comment', 'request_changes'];

/// Which state may follow which. The talk with Claude never changes the
/// state: a thread waits on Claude through [Thread.waiting], and what goes
/// out is its [Thread.answer]. published is set by a publish only.
const threadTransitions = <String, List<String>>{
  'open': ['dismissed', 'published'],
  'dismissed': ['open'],
  'published': ['resolved'],
  'resolved': [],
};

/// Thread states a next round looks at again.
const openThreadStates = ['published', 'open'];

/// Where a thread points into the diff: the hunk (stable across edits above
/// it) and a hash of the line (to find it again when the hunk changed).
/// Skim's JSON names, so agents read the anchors they know.
@freezed
abstract class Anchor with _$Anchor {
  const factory Anchor({
    required String path,

    /// new or old.
    @Default('new') String side,
    @JsonKey(name: 'hunk_ref') required String hunkRef,
    required int line,
    required int endLine,
    @JsonKey(name: 'content_hash') required String contentHash,
  }) = _Anchor;

  factory Anchor.fromJson(Map<String, Object?> json) => _$AnchorFromJson(json);
}

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String author,
    required String body,

    /// Replacement text for the anchored lines, posted as a suggestion.
    String? suggestion,
    String? remoteId,
    @Default('') String createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, Object?> json) => _$MessageFromJson(json);
}

@freezed
abstract class Thread with _$Thread {
  const factory Thread({
    required String id,

    /// Null for a thread about the whole change.
    Anchor? anchor,
    required String severity,
    required String state,
    required String authorType,
    String? remoteId,
    String? roundId,
    @Default('') String createdAt,
    @Default('') String updatedAt,

    /// What was posted (remote id set, or written on the forge) and the talk
    /// with Claude (never posted), oldest first.
    @Default([]) List<Message> messages,

    /// The one message the next publish posts: the opening note of a thread
    /// not on the forge yet, a reply on one that is. Claude writes it, the
    /// user may edit it. Null: nothing goes out.
    Message? answer,

    /// The user asked Claude something on it and Claude has not answered yet.
    @Default(false) bool waiting,

    /// The user's call on the answer: accept (it goes out on the next
    /// publish) or reject (nothing goes out). Null: not decided yet. A new
    /// answer from Claude clears it, so the user reads the new text.
    String? decision,

    /// The commit that fixes it, or `uncommitted` when the change is in the
    /// fix worktree but could not be committed.
    String? fix,

    /// The commit that undid [fix] on the branch: a Reject of a fix with
    /// commits on top that could not leave without them.
    String? fixRevert,
  }) = _Thread;

  factory Thread.fromJson(Map<String, Object?> json) => _$ThreadFromJson(json);
}

/// One publish to the forge. The head of the last published round is where
/// the next round's delta starts.
@freezed
abstract class Round with _$Round {
  const factory Round({
    required String id,
    required int number,
    required String baseSha,
    required String headSha,
    String? verdict,
    String? publishedAt,

    /// The summary note on the forge, once posted.
    String? remoteNoteId,
    @Default('') String createdAt,
  }) = _Round;

  factory Round.fromJson(Map<String, Object?> json) => _$RoundFromJson(json);
}

/// The three shas GitLab positions a discussion with.
@freezed
abstract class DiffRefs with _$DiffRefs {
  const factory DiffRefs({@Default('') String baseSha, @Default('') String startSha, @Default('') String headSha}) = _DiffRefs;

  factory DiffRefs.fromJson(Map<String, Object?> json) => _$DiffRefsFromJson(json);
}

/// The merge request (or GitHub pull request) a review is bound to.
@freezed
abstract class MrSource with _$MrSource {
  const factory MrSource({
    /// gitlab or github.
    required String provider,
    required String url,
    required int iid,

    /// "group/project" or "owner/repo".
    required String projectPath,
    @Default('') String title,
    @Default('') String description,
    @Default('') String author,
    @Default('') String sourceBranch,
    @Default('') String targetBranch,
    @Default(DiffRefs()) DiffRefs diffRefs,
  }) = _MrSource;

  factory MrSource.fromJson(Map<String, Object?> json) => _$MrSourceFromJson(json);
}

@freezed
abstract class FileNote with _$FileNote {
  const factory FileNote({required String path, required String summary, @Default([]) List<String> extraTags}) = _FileNote;

  factory FileNote.fromJson(Map<String, Object?> json) => _$FileNoteFromJson(json);
}

@freezed
abstract class HunkNote with _$HunkNote {
  const factory HunkNote({required String path, required String hunkRef, required String summary}) = _HunkNote;

  factory HunkNote.fromJson(Map<String, Object?> json) => _$HunkNoteFromJson(json);
}

@freezed
abstract class GroupItem with _$GroupItem {
  const factory GroupItem({required String path, String? hunkRef}) = _GroupItem;

  factory GroupItem.fromJson(Map<String, Object?> json) => _$GroupItemFromJson(json);
}

/// One chapter of the reading order.
@freezed
abstract class ReviewGroup with _$ReviewGroup {
  const factory ReviewGroup({required String title, @Default('') String overview, @Default([]) List<GroupItem> items}) = _ReviewGroup;

  factory ReviewGroup.fromJson(Map<String, Object?> json) => _$ReviewGroupFromJson(json);
}

/// One tab of pictures above the chapters: the classes the change touches
/// and the sequence it runs, with what changed marked.
@freezed
abstract class ReviewFeature with _$ReviewFeature {
  const factory ReviewFeature({required String title, @Default('') String summary, FeatureGraph? graph, MapSequence? sequence}) = _ReviewFeature;

  factory ReviewFeature.fromJson(Map<String, Object?> json) => _$ReviewFeatureFromJson(json);
}

/// A question a reviewer asks before reading, and what the session found.
@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String text,
    @Default('') String evidence,
    @Default([]) List<String> paths,

    /// ok, concern or unclear.
    required String state,

    /// The head judged, so a list written before a push shows as stale.
    @Default('') String headSha,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, Object?> json) => _$ChecklistItemFromJson(json);
}

/// The ticket text the session fetched with its own tools.
@freezed
abstract class StoredTicket with _$StoredTicket {
  const factory StoredTicket({required String ref, String? url, String? title, @Default('') String body}) = _StoredTicket;

  factory StoredTicket.fromJson(Map<String, Object?> json) => _$StoredTicketFromJson(json);
}

@freezed
abstract class TicketCheckItem with _$TicketCheckItem {
  const factory TicketCheckItem({required String text, required String state, @Default([]) List<String> paths}) = _TicketCheckItem;

  factory TicketCheckItem.fromJson(Map<String, Object?> json) => _$TicketCheckItemFromJson(json);
}

/// Does the change do what the ticket asks? Written once per head.
@freezed
abstract class TicketCheck with _$TicketCheck {
  const factory TicketCheck({
    required String ref,
    @Default('') String headSha,
    required String verdict,
    @Default('') String summary,
    @Default([]) List<TicketCheckItem> items,
  }) = _TicketCheck;

  factory TicketCheck.fromJson(Map<String, Object?> json) => _$TicketCheckFromJson(json);
}

@freezed
abstract class Review with _$Review {
  const factory Review({
    /// "gitlab-412": provider and number, unique in its project.
    required String id,
    required String project,
    MrSource? mr,

    /// What the diff runs between: `origin/<target>` and the local source
    /// branch, or the MR head fetched into `skim/mr-<iid>`.
    required String baseRef,
    required String headRef,

    /// The head is the reviewer's own branch, nothing was fetched into it.
    @Default(false) bool local,

    /// A review of a local checkout, no merge request: the folder that has
    /// [headRef] checked out. The diff runs to its working tree, edits not
    /// committed yet included, and the review session runs there.
    String? folder,

    /// Your own merge request: the threads are your reviewers', and only
    /// replies you wrote yourself go out, never Claude's drafts.
    @Default(false) bool own,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default([]) List<FileNote> fileNotes,
    @Default([]) List<HunkNote> hunkNotes,
    @Default([]) List<ReviewGroup> groups,
    @Default([]) List<ReviewFeature> features,
    @Default([]) List<ChecklistItem> checklist,
    @Default([]) List<StoredTicket> tickets,
    @Default([]) List<TicketCheck> ticketChecks,

    /// Path to the head sha it was viewed at: a later change to it shows.
    @Default({}) Map<String, String> viewed,

    /// Null keeps the repository's default.
    List<String>? hiddenTags,
    @Default([]) List<Thread> threads,
    @Default([]) List<Round> rounds,

    /// The last Claude session on this review: answering a thread resumes
    /// it, so the diff it read is still in its context.
    String? sessionId,
  }) = _Review;

  factory Review.fromJson(Map<String, Object?> json) => _$ReviewFromJson(json);
}

/// On the forge: written there, or posted by a publish.
bool isPosted(Message m) => m.author == 'remote' || m.remoteId != null;

/// The user's two calls on an answer.
const decisions = ['accept', 'reject'];

/// What the next publish posts on [t]: its answer, once accepted.
bool goesOut(Thread t) => t.answer != null && t.decision == 'accept' && (t.state == 'open' || t.state == 'published');

/// A review saved before threads had an answer (its threads have no
/// `waiting` key): draft, accepted and awaiting_agent become open, fixed
/// becomes resolved. A thread not on the forge yet moves its opening message
/// into the answer. On a published thread, our last message not posted yet
/// (a reply waiting for the publish, or Claude's draft of one) becomes the
/// answer.
Map<String, Object?> migrateReviewJson(Map<String, Object?> json) {
  final threads = json['threads'];
  if (threads is! List || threads.every((t) => t is! Map || t.containsKey('waiting'))) return json;
  return {
    ...json,
    'threads': [
      for (final t in threads)
        if (t is Map && !t.containsKey('waiting')) _migrateThread(t.cast<String, Object?>()) else t,
    ],
  };
}

Map<String, Object?> _migrateThread(Map<String, Object?> t) {
  final state = t['state'];
  final messages = [for (final m in (t['messages'] as List? ?? const [])) (m as Map).cast<String, Object?>()];
  final out = <String, Object?>{
    ...t,
    'waiting': false,
    if (state == 'accepted') 'decision': 'accept',
    'state': switch (state) {
      'fixed' => 'resolved',
      'dismissed' || 'published' || 'resolved' => state,
      _ => 'open',
    },
  };
  if (state == 'fixed' || state == 'resolved') return out;
  if (t['remoteId'] == null) {
    if (messages.isEmpty || messages.first['author'] == 'remote') return out;
    // The suggestion that would have gone out was the latest one.
    final suggestion = [
      for (final m in messages)
        if (m['suggestion'] is String) m['suggestion'],
    ].lastOrNull;
    return {
      ...out,
      'answer': {...messages.first, 'suggestion': ?suggestion},
      'messages': messages.skip(1).toList(),
    };
  }
  final last = messages.lastOrNull;
  if (last == null || last['author'] == 'remote' || last['remoteId'] != null) return out;
  return {...out, 'answer': last, 'messages': messages.take(messages.length - 1).toList()};
}

/// uncommitted, pending (committed aside, waits for Accept to go on the
/// branch), dropped (rejected, kept aside), local (on the branch, not
/// pushed), pushed, or gone (accepted but no longer on the reviewed branch:
/// amended or rebased away).
typedef FixStatus = ({String state, String? sha});
