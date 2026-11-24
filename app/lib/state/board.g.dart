// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Board)
final boardProvider = BoardProvider._();

final class BoardProvider extends $AsyncNotifierProvider<Board, BoardState> {
  BoardProvider._()
    : super(from: null, argument: null, retry: null, name: r'boardProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$boardHash();

  @$internal
  @override
  Board create() => Board();
}

String _$boardHash() => r'1103d20f63bea1727bd187a2c5c554abdb685c56';

abstract class _$Board extends $AsyncNotifier<BoardState> {
  FutureOr<BoardState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BoardState>, BoardState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<BoardState>, BoardState>, AsyncValue<BoardState>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
