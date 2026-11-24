// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_overview.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(overviewStore)
final overviewStoreProvider = OverviewStoreProvider._();

final class OverviewStoreProvider extends $FunctionalProvider<OverviewStore, OverviewStore, OverviewStore> with $Provider<OverviewStore> {
  OverviewStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewStoreHash();

  @$internal
  @override
  $ProviderElement<OverviewStore> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  OverviewStore create(Ref ref) {
    return overviewStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverviewStore value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<OverviewStore>(value));
  }
}

String _$overviewStoreHash() => r'ae642ccc293dc88087b58f4b7b8156714dadfad4';

/// New updates since your last visit, for the sidebars.

@ProviderFor(projectNewCount)
final projectNewCountProvider = ProjectNewCountFamily._();

/// New updates since your last visit, for the sidebars.

final class ProjectNewCountProvider extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>> with $FutureModifier<int>, $FutureProvider<int> {
  /// New updates since your last visit, for the sidebars.
  ProjectNewCountProvider._({required ProjectNewCountFamily super.from, required String super.argument})
    : super(retry: null, name: r'projectNewCountProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectNewCountHash();

  @override
  String toString() {
    return r'projectNewCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return projectNewCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectNewCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectNewCountHash() => r'aed79c708da6ea2728efdea24dae6d4562bdc91e';

/// New updates since your last visit, for the sidebars.

final class ProjectNewCountFamily extends $Family with $FunctionalFamilyOverride<FutureOr<int>, String> {
  ProjectNewCountFamily._() : super(retry: null, name: r'projectNewCountProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// New updates since your last visit, for the sidebars.

  ProjectNewCountProvider call(String id) => ProjectNewCountProvider._(argument: id, from: this);

  @override
  String toString() => r'projectNewCountProvider';
}

@ProviderFor(ProjectOverviewState)
final projectOverviewStateProvider = ProjectOverviewStateFamily._();

final class ProjectOverviewStateProvider extends $AsyncNotifierProvider<ProjectOverviewState, OverviewView> {
  ProjectOverviewStateProvider._({required ProjectOverviewStateFamily super.from, required String super.argument})
    : super(retry: null, name: r'projectOverviewStateProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectOverviewStateHash();

  @override
  String toString() {
    return r'projectOverviewStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProjectOverviewState create() => ProjectOverviewState();

  @override
  bool operator ==(Object other) {
    return other is ProjectOverviewStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectOverviewStateHash() => r'46b98d454b2f4ec3b694611cc798d7f53c02c67c';

final class ProjectOverviewStateFamily extends $Family
    with $ClassFamilyOverride<ProjectOverviewState, AsyncValue<OverviewView>, OverviewView, FutureOr<OverviewView>, String> {
  ProjectOverviewStateFamily._()
    : super(retry: null, name: r'projectOverviewStateProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  ProjectOverviewStateProvider call(String id) => ProjectOverviewStateProvider._(argument: id, from: this);

  @override
  String toString() => r'projectOverviewStateProvider';
}

abstract class _$ProjectOverviewState extends $AsyncNotifier<OverviewView> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<OverviewView> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<OverviewView>, OverviewView>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<OverviewView>, OverviewView>, AsyncValue<OverviewView>, Object?, Object?>;
    return element.handleCreate(ref, () => build(_$args));
  }
}
