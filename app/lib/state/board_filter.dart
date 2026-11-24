// The board filter, shared by Flow, Focus and By type: switching views keeps it.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/models/board_filter.dart';

part 'board_filter.g.dart';

@Riverpod(keepAlive: true)
class BoardFilterState extends _$BoardFilterState {
  @override
  BoardFilter build() => const BoardFilter();

  void set(BoardFilter f) => state = f;
}

/// The card under the pointer, so its linked cards light up. Null when none.
@Riverpod(keepAlive: true)
class HoveredCard extends _$HoveredCard {
  @override
  String? build() => null;

  void set(String? key) => state = key;

  /// Clears it, unless the pointer already went on to card other than [key].
  void leave(String key) {
    if (state == key) state = null;
  }
}
