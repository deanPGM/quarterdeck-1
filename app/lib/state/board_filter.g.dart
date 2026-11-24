// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BoardFilterState)
final boardFilterStateProvider = BoardFilterStateProvider._();

final class BoardFilterStateProvider extends $NotifierProvider<BoardFilterState, BoardFilter> {
  BoardFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'boardFilterStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$boardFilterStateHash();

  @$internal
  @override
  BoardFilterState create() => BoardFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BoardFilter value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<BoardFilter>(value));
  }
}

String _$boardFilterStateHash() => r'a08540ebb826b549bfb05f387ef0d592a42c076e';

abstract class _$BoardFilterState extends $Notifier<BoardFilter> {
  BoardFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BoardFilter, BoardFilter>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<BoardFilter, BoardFilter>, BoardFilter, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// The card under the pointer, so its linked cards light up. Null when none.

@ProviderFor(HoveredCard)
final hoveredCardProvider = HoveredCardProvider._();

/// The card under the pointer, so its linked cards light up. Null when none.
final class HoveredCardProvider extends $NotifierProvider<HoveredCard, String?> {
  /// The card under the pointer, so its linked cards light up. Null when none.
  HoveredCardProvider._()
    : super(from: null, argument: null, retry: null, name: r'hoveredCardProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$hoveredCardHash();

  @$internal
  @override
  HoveredCard create() => HoveredCard();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }
}

String _$hoveredCardHash() => r'3f4afcbfe382e079f234b7431bdd090aa1f9086a';

/// The card under the pointer, so its linked cards light up. Null when none.

abstract class _$HoveredCard extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<String?, String?>, String?, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
