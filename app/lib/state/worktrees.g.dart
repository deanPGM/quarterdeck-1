// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worktrees.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The worktrees of every project with a folder, by project then path.
/// Deck's own review worktrees (in its cache) are left out.

@ProviderFor(worktrees)
final worktreesProvider = WorktreesProvider._();

/// The worktrees of every project with a folder, by project then path.
/// Deck's own review worktrees (in its cache) are left out.

final class WorktreesProvider extends $FunctionalProvider<AsyncValue<List<Worktree>>, List<Worktree>, FutureOr<List<Worktree>>>
    with $FutureModifier<List<Worktree>>, $FutureProvider<List<Worktree>> {
  /// The worktrees of every project with a folder, by project then path.
  /// Deck's own review worktrees (in its cache) are left out.
  WorktreesProvider._()
    : super(from: null, argument: null, retry: null, name: r'worktreesProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$worktreesHash();

  @$internal
  @override
  $FutureProviderElement<List<Worktree>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Worktree>> create(Ref ref) {
    return worktrees(ref);
  }
}

String _$worktreesHash() => r'aaa118ad18805e1041b996446f6f1edd64ef30f7';

@ProviderFor(WorktreeTasks)
final worktreeTasksProvider = WorktreeTasksProvider._();

final class WorktreeTasksProvider extends $NotifierProvider<WorktreeTasks, void> {
  WorktreeTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'worktreeTasksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$worktreeTasksHash();

  @$internal
  @override
  WorktreeTasks create() => WorktreeTasks();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$worktreeTasksHash() => r'84c3744bddcc25f758c02e6d0c9dd606471a12d0';

abstract class _$WorktreeTasks extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
