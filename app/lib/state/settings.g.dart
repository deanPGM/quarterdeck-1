// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Home)
final homeProvider = HomeProvider._();

final class HomeProvider extends $NotifierProvider<Home, DeckHome> {
  HomeProvider._()
    : super(from: null, argument: null, retry: null, name: r'homeProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$homeHash();

  @$internal
  @override
  Home create() => Home();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeckHome value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DeckHome>(value));
  }
}

String _$homeHash() => r'6c7ec46653591603cb2b3918dbded540b2cca468';

abstract class _$Home extends $Notifier<DeckHome> {
  DeckHome build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeckHome, DeckHome>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<DeckHome, DeckHome>, DeckHome, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(Settings)
final settingsProvider = SettingsProvider._();

final class SettingsProvider extends $AsyncNotifierProvider<Settings, DeckConfig> {
  SettingsProvider._()
    : super(from: null, argument: null, retry: null, name: r'settingsProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  Settings create() => Settings();
}

String _$settingsHash() => r'800f29974f726532be02f832bdd69a2fbaa4da23';

abstract class _$Settings extends $AsyncNotifier<DeckConfig> {
  FutureOr<DeckConfig> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DeckConfig>, DeckConfig>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<DeckConfig>, DeckConfig>, AsyncValue<DeckConfig>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
