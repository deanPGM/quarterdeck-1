// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_map.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The map of one project. Null when the project has no folder, or the
/// folder is not a git repository.

@ProviderFor(projectMap)
final projectMapProvider = ProjectMapFamily._();

/// The map of one project. Null when the project has no folder, or the
/// folder is not a git repository.

final class ProjectMapProvider extends $FunctionalProvider<AsyncValue<FeatureMap?>, FeatureMap?, FutureOr<FeatureMap?>>
    with $FutureModifier<FeatureMap?>, $FutureProvider<FeatureMap?> {
  /// The map of one project. Null when the project has no folder, or the
  /// folder is not a git repository.
  ProjectMapProvider._({required ProjectMapFamily super.from, required String super.argument})
    : super(retry: null, name: r'projectMapProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectMapHash();

  @override
  String toString() {
    return r'projectMapProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FeatureMap?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<FeatureMap?> create(Ref ref) {
    final argument = this.argument as String;
    return projectMap(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectMapProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectMapHash() => r'707e5879616656a0039eac9cd621d802692584a9';

/// The map of one project. Null when the project has no folder, or the
/// folder is not a git repository.

final class ProjectMapFamily extends $Family with $FunctionalFamilyOverride<FutureOr<FeatureMap?>, String> {
  ProjectMapFamily._() : super(retry: null, name: r'projectMapProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// The map of one project. Null when the project has no folder, or the
  /// folder is not a git repository.

  ProjectMapProvider call(String id) => ProjectMapProvider._(argument: id, from: this);

  @override
  String toString() => r'projectMapProvider';
}

/// The map runs, by project id. Also what the map tools of the Deck MCP
/// server reach.

@ProviderFor(ProjectMaps)
final projectMapsProvider = ProjectMapsProvider._();

/// The map runs, by project id. Also what the map tools of the Deck MCP
/// server reach.
final class ProjectMapsProvider extends $NotifierProvider<ProjectMaps, Map<String, SessionRun>> {
  /// The map runs, by project id. Also what the map tools of the Deck MCP
  /// server reach.
  ProjectMapsProvider._()
    : super(from: null, argument: null, retry: null, name: r'projectMapsProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectMapsHash();

  @$internal
  @override
  ProjectMaps create() => ProjectMaps();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, SessionRun> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Map<String, SessionRun>>(value));
  }
}

String _$projectMapsHash() => r'2f1e51c2fd90ccd52039b897557b403b92594788';

/// The map runs, by project id. Also what the map tools of the Deck MCP
/// server reach.

abstract class _$ProjectMaps extends $Notifier<Map<String, SessionRun>> {
  Map<String, SessionRun> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, SessionRun>, Map<String, SessionRun>>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<Map<String, SessionRun>, Map<String, SessionRun>>, Map<String, SessionRun>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
