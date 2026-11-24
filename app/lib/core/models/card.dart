import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

/// Names of the places a todo can come from.
const sourceNames = {'slack': 'Slack', 'mail': 'Mail', 'gitlab': 'GitLab', 'github': 'GitHub', 'jira': 'Jira', 'meeting': 'Meeting'};

/// Which column a card sits in: your move, someone else's move, or nothing to do.
enum Bucket { action, blocked, clear }

/// Providers whose cards are messages (a reply or a task asked in a message).
const messageProviders = {'slack', 'mail'};

/// What a card asks of you: answer, review someone's code, move your own merge
/// request, or do the work.
enum Lane { reply, review, mine, task }

/// Reads the lane names stored before the four types (todos.json keeps them).
Object? readLane(Map<dynamic, dynamic> json, String key) => switch (json[key]) {
  'asks' => 'reply',
  'tickets' || 'todos' => 'task',
  final v => v,
};

enum TagTone { neutral, act, done, warn }

@freezed
abstract class CardTag with _$CardTag {
  const factory CardTag(TagTone tone, String label) = _CardTag;

  factory CardTag.fromJson(Map<String, Object?> json) => _$CardTagFromJson(json);
}

/// One thing on your plate, from any provider, after classification.
@freezed
abstract class DeckCard with _$DeckCard {
  const factory DeckCard({
    required String key,
    required String provider,
    @JsonKey(readValue: readLane) required Lane lane,
    required String ref,
    required String url,
    required String title,

    /// One line: what has to happen next.
    required String next,
    String? why,
    @Default([]) List<CardTag> tags,
    required Bucket bucket,
    required int score,
    DateTime? updatedAt,
    String? author,
    // Merge requests
    String? path,
    int? iid,

    /// A review from you is what it needs, first or again.
    @Default(false) bool reviewable,

    /// Your own merge request: reviewers left threads that wait on you.
    @Default(false) bool feedback,
    // Messages
    String? channel,
    String? project,

    /// Todos: where it came from (slack, mail, gitlab, github, jira, meeting, other).
    String? source,

    /// Mail: ask, fyi, noise or phishing.
    String? kind,

    /// Mail: the Gmail thread ids this card stands for, to archive them.
    @Default([]) List<String> threads,

    /// Other items this card mentions that its title and link do not show: a
    /// merge request's branch, the ticket or MR Claude read a message is
    /// about. Links to cards are found from them (core/links.dart).
    @Default([]) List<String> refs,
  }) = _DeckCard;

  factory DeckCard.fromJson(Map<String, Object?> json) => _$DeckCardFromJson(json);
}
