// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_memory.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(uiMemory)
final uiMemoryProvider = UiMemoryProvider._();

final class UiMemoryProvider extends $FunctionalProvider<UiMemory, UiMemory, UiMemory> with $Provider<UiMemory> {
  UiMemoryProvider._()
    : super(from: null, argument: null, retry: null, name: r'uiMemoryProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$uiMemoryHash();

  @$internal
  @override
  $ProviderElement<UiMemory> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  UiMemory create(Ref ref) {
    return uiMemory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UiMemory value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<UiMemory>(value));
  }
}

String _$uiMemoryHash() => r'8766fc7efe8bc15df98932c1bfe04568b0e5489f';
