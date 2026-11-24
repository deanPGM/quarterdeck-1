import 'package:freezed_annotation/freezed_annotation.dart';

import 'card.dart';
import 'records.dart';

part 'snapshot.freezed.dart';
part 'snapshot.g.dart';

enum SourceState { empty, loading, ok, error }

/// The last fetch of one provider. Kept on disk so the board shows at once on
/// start, and kept on error so a provider that is down still shows old cards.
@freezed
abstract class Snapshot with _$Snapshot {
  const factory Snapshot({
    @Default(SourceState.empty) SourceState state,
    String? message,
    DateTime? at,

    /// Your user name on that provider.
    String? me,
    @Default([]) List<DeckCard> cards,

    /// Calendar only: the meetings of the next 24 hours, by start time.
    @Default([]) List<EventRecord> events,
  }) = _Snapshot;

  factory Snapshot.fromJson(Map<String, Object?> json) => _$SnapshotFromJson(json);
}

/// What you decided about a card. A fetch only ever sets done (see auto_close.dart).
@freezed
abstract class Triage with _$Triage {
  const factory Triage({
    @Default(false) bool pin,
    @Default(false) bool urgent,

    /// -3..3, moves the card up or down.
    @Default(0) int boost,

    /// Hidden until this day. Far future means until you unsnooze.
    DateTime? snoozeUntil,
    String? note,
    @Default(false) bool done,

    /// When it was marked done, by you or by Deck: Flow shows today's.
    DateTime? doneAt,

    /// You started it (Claude, IDE or review clicked): it sits in Doing until
    /// done or "Not now".
    DateTime? startedAt,

    /// Why Deck closed it itself (MR merged, you replied). Null when you did.
    String? doneReason,

    /// You reopened a card Deck closed: Deck does not close it again.
    @Default(false) bool keepOpen,

    /// The last Claude session started from this card (its id), to show its progress.
    String? session,

    /// Meetings only: no alarm for this one.
    @Default(false) bool silent,
  }) = _Triage;

  factory Triage.fromJson(Map<String, Object?> json) => _$TriageFromJson(json);
}
