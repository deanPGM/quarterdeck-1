// One line of the activity log: something that happened in your day. Kept per
// month in state/activity/, read back for the day, month and year views and by
// any Claude session through deck_activity.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
abstract class Activity with _$Activity {
  // Freezed reads this annotation from the factory: no null fields in the log.
  // ignore: invalid_annotation_target
  @JsonSerializable(includeIfNull: false)
  const factory Activity({
    required DateTime at,

    /// done, todo, merged, approved, meeting, session or note.
    required String kind,
    required String title,

    /// Same id, same event: logged once.
    String? id,

    /// Where it happened: gitlab, jira, slack, mail, calendar, claude.
    String? source,

    /// Short reference: "backend!77", "VPN-120", "#vpn-team".
    String? ref,
    String? url,
    String? project,

    /// Extra: why Deck closed it, the session folder, how long.
    String? detail,
  }) = _Activity;

  factory Activity.fromJson(Map<String, Object?> json) => _$ActivityFromJson(json);
}

/// What Claude wrote about a period of the log.
class ActivitySummary {
  const ActivitySummary({required this.at, required this.lines, required this.text});

  final DateTime at;

  /// Log lines the summary was written from: fewer than now means it is behind.
  final int lines;
  final String text;

  Map<String, Object?> toJson() => {'at': at.toIso8601String(), 'lines': lines, 'text': text};

  factory ActivitySummary.fromJson(Map<String, Object?> j) =>
      ActivitySummary(at: DateTime.parse(j['at'] as String), lines: j['lines'] as int, text: j['text'] as String);
}
