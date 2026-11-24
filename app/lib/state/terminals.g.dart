// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminals.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One set for the whole app: the tabs own processes, so it never disposes
/// while the app runs.

@ProviderFor(Terminals)
final terminalsProvider = TerminalsProvider._();

/// One set for the whole app: the tabs own processes, so it never disposes
/// while the app runs.
final class TerminalsProvider extends $NotifierProvider<Terminals, TermState> {
  /// One set for the whole app: the tabs own processes, so it never disposes
  /// while the app runs.
  TerminalsProvider._()
    : super(from: null, argument: null, retry: null, name: r'terminalsProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$terminalsHash();

  @$internal
  @override
  Terminals create() => Terminals();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TermState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<TermState>(value));
  }
}

String _$terminalsHash() => r'7f5c5b7ba11ad114f22a9724c717ff08f9aee5f1';

/// One set for the whole app: the tabs own processes, so it never disposes
/// while the app runs.

abstract class _$Terminals extends $Notifier<TermState> {
  TermState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TermState, TermState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<TermState, TermState>, TermState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
