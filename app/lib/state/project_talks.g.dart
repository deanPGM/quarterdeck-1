// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_talks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The talks of project [id], newest first.

@ProviderFor(projectTalks)
final projectTalksProvider = ProjectTalksFamily._();

/// The talks of project [id], newest first.

final class ProjectTalksProvider extends $FunctionalProvider<AsyncValue<List<Talk>>, List<Talk>, FutureOr<List<Talk>>>
    with $FutureModifier<List<Talk>>, $FutureProvider<List<Talk>> {
  /// The talks of project [id], newest first.
  ProjectTalksProvider._({required ProjectTalksFamily super.from, required String super.argument})
    : super(retry: null, name: r'projectTalksProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectTalksHash();

  @override
  String toString() {
    return r'projectTalksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Talk>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Talk>> create(Ref ref) {
    final argument = this.argument as String;
    return projectTalks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectTalksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectTalksHash() => r'9bdf28661660727a7f62af88c1dd3925011e2934';

/// The talks of project [id], newest first.

final class ProjectTalksFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Talk>>, String> {
  ProjectTalksFamily._() : super(retry: null, name: r'projectTalksProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// The talks of project [id], newest first.

  ProjectTalksProvider call(String id) => ProjectTalksProvider._(argument: id, from: this);

  @override
  String toString() => r'projectTalksProvider';
}

@ProviderFor(ProjectTalker)
final projectTalkerProvider = ProjectTalkerProvider._();

final class ProjectTalkerProvider extends $NotifierProvider<ProjectTalker, void> {
  ProjectTalkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectTalkerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectTalkerHash();

  @$internal
  @override
  ProjectTalker create() => ProjectTalker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$projectTalkerHash() => r'f2beb65863a43b03584bc61dbb561ee352ce534d';

abstract class _$ProjectTalker extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
