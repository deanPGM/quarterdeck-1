// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The info runs, by project id.

@ProviderFor(ProjectInfos)
final projectInfosProvider = ProjectInfosProvider._();

/// The info runs, by project id.
final class ProjectInfosProvider extends $NotifierProvider<ProjectInfos, Map<String, SessionRun>> {
  /// The info runs, by project id.
  ProjectInfosProvider._()
    : super(from: null, argument: null, retry: null, name: r'projectInfosProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectInfosHash();

  @$internal
  @override
  ProjectInfos create() => ProjectInfos();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, SessionRun> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Map<String, SessionRun>>(value));
  }
}

String _$projectInfosHash() => r'e7fd2bfcf433845fa4a9d99d120e2dd344c04bf9';

/// The info runs, by project id.

abstract class _$ProjectInfos extends $Notifier<Map<String, SessionRun>> {
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
