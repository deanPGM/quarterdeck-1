// What sources hand to the classifiers. GitLab records come from the app's own
// MCP calls; Jira and message records come from the background Claude session,
// so their JSON shape is part of the Deck MCP contract.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'records.freezed.dart';
part 'records.g.dart';

enum MrRole { mine, review }

/// An unresolved, resolvable review thread: who started it, who spoke last,
/// and everyone who wrote in it, in order.
@freezed
abstract class ThreadRecord with _$ThreadRecord {
  const factory ThreadRecord({required String start, required String last, @Default([]) List<String> people}) = _ThreadRecord;

  factory ThreadRecord.fromJson(Map<String, Object?> json) => _$ThreadRecordFromJson(json);
}

@freezed
abstract class MrRecord with _$MrRecord {
  const factory MrRecord({
    required String path,
    required int iid,
    required String title,
    required String url,
    required String author,
    required MrRole role,
    @Default(false) bool draft,
    @Default(false) bool conflicts,

    /// Head pipeline status, upper case. Empty when there is none.
    @Default('') String pipeline,
    @Default([]) List<String> approvers,
    @Default(false) bool approved,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<ThreadRecord> threads,
    String? sha,

    /// Source branch: often names the ticket ("feat/AVPN-123").
    @Default('') String branch,
  }) = _MrRecord;

  factory MrRecord.fromJson(Map<String, Object?> json) => _$MrRecordFromJson(json);
}

@freezed
abstract class CommentRecord with _$CommentRecord {
  const factory CommentRecord({String? author, @Default(false) bool mine, required DateTime at}) = _CommentRecord;

  factory CommentRecord.fromJson(Map<String, Object?> json) => _$CommentRecordFromJson(json);
}

@freezed
abstract class IssueRecord with _$IssueRecord {
  const factory IssueRecord({
    required String key,
    required String summary,
    required String url,
    required String status,

    /// Jira status category: new, indeterminate or done.
    required String statusCategory,
    required String type,
    // Optional while the Atlassian connector leaves out created, updated and
    // comment (seen 2026-11-04).
    DateTime? created,
    DateTime? updated,
    CommentRecord? lastComment,
  }) = _IssueRecord;

  factory IssueRecord.fromJson(Map<String, Object?> json) => _$IssueRecordFromJson(json);
}

/// A link to a document, as Claude read it in a message.
@freezed
abstract class DocLink with _$DocLink {
  const factory DocLink({required String url, required String title}) = _DocLink;

  factory DocLink.fromJson(Map<String, Object?> json) => _$DocLinkFromJson(json);
}

/// A Slack message or a mail, already judged by Claude.
@freezed
abstract class MessageRecord with _$MessageRecord {
  const factory MessageRecord({
    required String id,
    required String url,
    String? from,

    /// "#channel", "DM", or the mail subject's sender.
    String? where,
    required DateTime at,
    required String title,

    /// True when it asks the user to do, answer, review or decide something.
    @Default(false) bool ask,

    /// One imperative line, only when ask is true.
    String? need,

    /// True when the ask is work to do (fix, write, check), not only an answer.
    /// A task stays open after the user replied.
    @Default(false) bool task,

    /// True when the user already answered.
    @Default(false) bool done,
    @Default(false) bool urgent,

    /// The user answered and waits on the other side.
    @Default(false) bool waiting,
    String? project,

    /// Mail only: ask, fyi, noise or phishing. Null means ask decides.
    String? kind,

    /// Only with project: one line of news about the project worth keeping
    /// beyond this message (a date, a decision, who owns what, an open
    /// question). It goes to the project's Overview.
    String? lasting,

    /// Only with project: documents the message links to about the project
    /// (a doc, a sheet, a dashboard, a design). They go to the project's
    /// Overview, under Documents.
    @Default([]) List<DocLink> docs,

    /// The item the message is about: "AVPN-65" (Jira), "vpn-ios!955"
    /// (merge request), "vpn-android#12" (issue). An ask about a card already on
    /// the board goes on that card instead of making one.
    String? about,

    /// Slack only: a message in a project channel not aimed at the user, kept
    /// because it is a bug report, request or question to the team. With an
    /// [about] (an existing ticket tracks it), it makes no card.
    @Default(false) bool team,
  }) = _MessageRecord;

  factory MessageRecord.fromJson(Map<String, Object?> json) => _$MessageRecordFromJson(json);
}

/// A calendar event, from the background Claude session.
@freezed
abstract class EventRecord with _$EventRecord {
  const factory EventRecord({
    required String id,
    required String title,
    required DateTime start,
    required DateTime end,

    /// The event in the calendar.
    @Default('') String url,

    /// Video call link (Meet, Zoom, Teams), when there is one.
    String? join,

    /// True when the user accepted it or organizes it.
    @Default(false) bool going,
    @Default(0) int attendees,
  }) = _EventRecord;

  factory EventRecord.fromJson(Map<String, Object?> json) => _$EventRecordFromJson(json);
}

/// One open merge request of a project, for the project page: every one,
/// not only those that need you.
class ProjectMr {
  const ProjectMr({
    required this.iid,
    required this.title,
    required this.url,
    required this.author,
    required this.updatedAt,
    this.branch = '',
    this.draft = false,
    this.mine = false,
    this.reviewer = false,
  });

  final int iid;
  final String title;
  final String url;
  final String author;
  final DateTime updatedAt;
  final String branch;
  final bool draft;

  /// You wrote it.
  final bool mine;

  /// Your review is asked.
  final bool reviewer;
}
