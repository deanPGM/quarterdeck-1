// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_mrs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every open merge request of a project, newest change first. Empty when
/// the project has no repo.

@ProviderFor(projectMrs)
final projectMrsProvider = ProjectMrsFamily._();

/// Every open merge request of a project, newest change first. Empty when
/// the project has no repo.

final class ProjectMrsProvider extends $FunctionalProvider<AsyncValue<List<ProjectMr>>, List<ProjectMr>, FutureOr<List<ProjectMr>>>
    with $FutureModifier<List<ProjectMr>>, $FutureProvider<List<ProjectMr>> {
  /// Every open merge request of a project, newest change first. Empty when
  /// the project has no repo.
  ProjectMrsProvider._({required ProjectMrsFamily super.from, required String super.argument})
    : super(retry: null, name: r'projectMrsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectMrsHash();

  @override
  String toString() {
    return r'projectMrsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProjectMr>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProjectMr>> create(Ref ref) {
    final argument = this.argument as String;
    return projectMrs(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectMrsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectMrsHash() => r'07547cfdde722bcfd54f8e2495fabd38ed1d6b51';

/// Every open merge request of a project, newest change first. Empty when
/// the project has no repo.

final class ProjectMrsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<ProjectMr>>, String> {
  ProjectMrsFamily._() : super(retry: null, name: r'projectMrsProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// Every open merge request of a project, newest change first. Empty when
  /// the project has no repo.

  ProjectMrsProvider call(String id) => ProjectMrsProvider._(argument: id, from: this);

  @override
  String toString() => r'projectMrsProvider';
}

/// Every checkout of the project that has something to review. Empty when
/// the project has no folder or it is not a git repo.

@ProviderFor(projectCheckouts)
final projectCheckoutsProvider = ProjectCheckoutsFamily._();

/// Every checkout of the project that has something to review. Empty when
/// the project has no folder or it is not a git repo.

final class ProjectCheckoutsProvider extends $FunctionalProvider<AsyncValue<List<LocalCheckout>>, List<LocalCheckout>, FutureOr<List<LocalCheckout>>>
    with $FutureModifier<List<LocalCheckout>>, $FutureProvider<List<LocalCheckout>> {
  /// Every checkout of the project that has something to review. Empty when
  /// the project has no folder or it is not a git repo.
  ProjectCheckoutsProvider._({required ProjectCheckoutsFamily super.from, required String super.argument})
    : super(retry: null, name: r'projectCheckoutsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectCheckoutsHash();

  @override
  String toString() {
    return r'projectCheckoutsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LocalCheckout>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LocalCheckout>> create(Ref ref) {
    final argument = this.argument as String;
    return projectCheckouts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectCheckoutsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectCheckoutsHash() => r'c582306554782e28029fa547305fd9521c2a14ab';

/// Every checkout of the project that has something to review. Empty when
/// the project has no folder or it is not a git repo.

final class ProjectCheckoutsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<LocalCheckout>>, String> {
  ProjectCheckoutsFamily._() : super(retry: null, name: r'projectCheckoutsProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// Every checkout of the project that has something to review. Empty when
  /// the project has no folder or it is not a git repo.

  ProjectCheckoutsProvider call(String id) => ProjectCheckoutsProvider._(argument: id, from: this);

  @override
  String toString() => r'projectCheckoutsProvider';
}
