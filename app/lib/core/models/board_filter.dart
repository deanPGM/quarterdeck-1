import 'package:freezed_annotation/freezed_annotation.dart';

import 'card.dart';

part 'board_filter.freezed.dart';

/// The filter field above Flow, Focus and By type: tokens per kind (any of
/// them matches inside a kind, every kind must match) and free text.
@freezed
abstract class BoardFilter with _$BoardFilter {
  const factory BoardFilter({
    /// Project ids, or `other`.
    @Default({}) Set<String> projects,
    @Default({}) Set<Lane> types,

    /// Provider ids (gitlab, slack, todo...).
    @Default({}) Set<String> providers,

    /// Searches titles, refs, next steps and notes.
    @Default('') String text,
  }) = _BoardFilter;

  const BoardFilter._();

  bool get isEmpty => projects.isEmpty && types.isEmpty && providers.isEmpty && text.isEmpty;
}
