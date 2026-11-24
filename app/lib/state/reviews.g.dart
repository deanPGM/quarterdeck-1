// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The reviews Deck holds for a project, newest first.

@ProviderFor(projectReviews)
final projectReviewsProvider = ProjectReviewsFamily._();

/// The reviews Deck holds for a project, newest first.

final class ProjectReviewsProvider extends $FunctionalProvider<AsyncValue<List<Review>>, List<Review>, FutureOr<List<Review>>>
    with $FutureModifier<List<Review>>, $FutureProvider<List<Review>> {
  /// The reviews Deck holds for a project, newest first.
  ProjectReviewsProvider._({required ProjectReviewsFamily super.from, required String super.argument})
    : super(retry: null, name: r'projectReviewsProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$projectReviewsHash();

  @override
  String toString() {
    return r'projectReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Review>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Review>> create(Ref ref) {
    final argument = this.argument as String;
    return projectReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectReviewsHash() => r'26aaf28c7b7beb34a6776054f005d1fe56772f62';

/// The reviews Deck holds for a project, newest first.

final class ProjectReviewsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Review>>, String> {
  ProjectReviewsFamily._() : super(retry: null, name: r'projectReviewsProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// The reviews Deck holds for a project, newest first.

  ProjectReviewsProvider call(String project) => ProjectReviewsProvider._(argument: project, from: this);

  @override
  String toString() => r'projectReviewsProvider';
}

/// One review as stored: the MR and what the session wrote.

@ProviderFor(review)
final reviewProvider = ReviewFamily._();

/// One review as stored: the MR and what the session wrote.

final class ReviewProvider extends $FunctionalProvider<AsyncValue<Review?>, Review?, FutureOr<Review?>>
    with $FutureModifier<Review?>, $FutureProvider<Review?> {
  /// One review as stored: the MR and what the session wrote.
  ReviewProvider._({required ReviewFamily super.from, required ReviewKey super.argument})
    : super(retry: null, name: r'reviewProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$reviewHash();

  @override
  String toString() {
    return r'reviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Review?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Review?> create(Ref ref) {
    final argument = this.argument as ReviewKey;
    return review(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewHash() => r'c9dbe79c6299a9a80f14baea4a0ff690e23a9df4';

/// One review as stored: the MR and what the session wrote.

final class ReviewFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Review?>, ReviewKey> {
  ReviewFamily._() : super(retry: null, name: r'reviewProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// One review as stored: the MR and what the session wrote.

  ReviewProvider call(ReviewKey key) => ReviewProvider._(argument: key, from: this);

  @override
  String toString() => r'reviewProvider';
}

/// The diff of a review, derived from git at the head it is on now.

@ProviderFor(reviewDiff)
final reviewDiffProvider = ReviewDiffFamily._();

/// The diff of a review, derived from git at the head it is on now.

final class ReviewDiffProvider extends $FunctionalProvider<AsyncValue<DiffSnapshot>, DiffSnapshot, FutureOr<DiffSnapshot>>
    with $FutureModifier<DiffSnapshot>, $FutureProvider<DiffSnapshot> {
  /// The diff of a review, derived from git at the head it is on now.
  ReviewDiffProvider._({required ReviewDiffFamily super.from, required ReviewKey super.argument})
    : super(retry: null, name: r'reviewDiffProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$reviewDiffHash();

  @override
  String toString() {
    return r'reviewDiffProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DiffSnapshot> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<DiffSnapshot> create(Ref ref) {
    final argument = this.argument as ReviewKey;
    return reviewDiff(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewDiffProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewDiffHash() => r'73520612b9ffada782909c0ff7739bb127440ec3';

/// The diff of a review, derived from git at the head it is on now.

final class ReviewDiffFamily extends $Family with $FunctionalFamilyOverride<FutureOr<DiffSnapshot>, ReviewKey> {
  ReviewDiffFamily._() : super(retry: null, name: r'reviewDiffProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// The diff of a review, derived from git at the head it is on now.

  ReviewDiffProvider call(ReviewKey key) => ReviewDiffProvider._(argument: key, from: this);

  @override
  String toString() => r'reviewDiffProvider';
}

/// Where each thread's fix stands, read from git after every write.

@ProviderFor(reviewFixes)
final reviewFixesProvider = ReviewFixesFamily._();

/// Where each thread's fix stands, read from git after every write.

final class ReviewFixesProvider
    extends
        $FunctionalProvider<
          AsyncValue<({Map<String, FixStatus> fixes, List<String> uncommitted})>,
          ({Map<String, FixStatus> fixes, List<String> uncommitted}),
          FutureOr<({Map<String, FixStatus> fixes, List<String> uncommitted})>
        >
    with
        $FutureModifier<({Map<String, FixStatus> fixes, List<String> uncommitted})>,
        $FutureProvider<({Map<String, FixStatus> fixes, List<String> uncommitted})> {
  /// Where each thread's fix stands, read from git after every write.
  ReviewFixesProvider._({required ReviewFixesFamily super.from, required ReviewKey super.argument})
    : super(retry: null, name: r'reviewFixesProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$reviewFixesHash();

  @override
  String toString() {
    return r'reviewFixesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<({Map<String, FixStatus> fixes, List<String> uncommitted})> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<({Map<String, FixStatus> fixes, List<String> uncommitted})> create(Ref ref) {
    final argument = this.argument as ReviewKey;
    return reviewFixes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewFixesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewFixesHash() => r'20965e6c3e1f03ce8aa992397b2bffda02b76640';

/// Where each thread's fix stands, read from git after every write.

final class ReviewFixesFamily extends $Family with $FunctionalFamilyOverride<FutureOr<({Map<String, FixStatus> fixes, List<String> uncommitted})>, ReviewKey> {
  ReviewFixesFamily._() : super(retry: null, name: r'reviewFixesProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// Where each thread's fix stands, read from git after every write.

  ReviewFixesProvider call(ReviewKey key) => ReviewFixesProvider._(argument: key, from: this);

  @override
  String toString() => r'reviewFixesProvider';
}

/// The folder that has the review's branch checked out, where its fixes
/// go. Null: none yet, the first fix or Open in IDE makes a worktree.

@ProviderFor(reviewFolder)
final reviewFolderProvider = ReviewFolderFamily._();

/// The folder that has the review's branch checked out, where its fixes
/// go. Null: none yet, the first fix or Open in IDE makes a worktree.

final class ReviewFolderProvider extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The folder that has the review's branch checked out, where its fixes
  /// go. Null: none yet, the first fix or Open in IDE makes a worktree.
  ReviewFolderProvider._({required ReviewFolderFamily super.from, required ReviewKey super.argument})
    : super(retry: null, name: r'reviewFolderProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$reviewFolderHash();

  @override
  String toString() {
    return r'reviewFolderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as ReviewKey;
    return reviewFolder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewFolderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewFolderHash() => r'1db00b2e3566573411a341317e610b69dac0e754';

/// The folder that has the review's branch checked out, where its fixes
/// go. Null: none yet, the first fix or Open in IDE makes a worktree.

final class ReviewFolderFamily extends $Family with $FunctionalFamilyOverride<FutureOr<String?>, ReviewKey> {
  ReviewFolderFamily._() : super(retry: null, name: r'reviewFolderProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// The folder that has the review's branch checked out, where its fixes
  /// go. Null: none yet, the first fix or Open in IDE makes a worktree.

  ReviewFolderProvider call(ReviewKey key) => ReviewFolderProvider._(argument: key, from: this);

  @override
  String toString() => r'reviewFolderProvider';
}

/// Whether the forge would merge it now.

@ProviderFor(reviewStatus)
final reviewStatusProvider = ReviewStatusFamily._();

/// Whether the forge would merge it now.

final class ReviewStatusProvider extends $FunctionalProvider<AsyncValue<MrStatus?>, MrStatus?, FutureOr<MrStatus?>>
    with $FutureModifier<MrStatus?>, $FutureProvider<MrStatus?> {
  /// Whether the forge would merge it now.
  ReviewStatusProvider._({required ReviewStatusFamily super.from, required ReviewKey super.argument})
    : super(retry: null, name: r'reviewStatusProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$reviewStatusHash();

  @override
  String toString() {
    return r'reviewStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MrStatus?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<MrStatus?> create(Ref ref) {
    final argument = this.argument as ReviewKey;
    return reviewStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewStatusHash() => r'705fc13efd2f1010c768fac4a2226b4b7c6f0e83';

/// Whether the forge would merge it now.

final class ReviewStatusFamily extends $Family with $FunctionalFamilyOverride<FutureOr<MrStatus?>, ReviewKey> {
  ReviewStatusFamily._() : super(retry: null, name: r'reviewStatusProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// Whether the forge would merge it now.

  ReviewStatusProvider call(ReviewKey key) => ReviewStatusProvider._(argument: key, from: this);

  @override
  String toString() => r'reviewStatusProvider';
}

@ProviderFor(Reviews)
final reviewsProvider = ReviewsProvider._();

final class ReviewsProvider extends $NotifierProvider<Reviews, ReviewsState> {
  ReviewsProvider._()
    : super(from: null, argument: null, retry: null, name: r'reviewsProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$reviewsHash();

  @$internal
  @override
  Reviews create() => Reviews();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewsState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ReviewsState>(value));
  }
}

String _$reviewsHash() => r'35ba133d0159c3db1198f03cb0a246b3cd4b2298';

abstract class _$Reviews extends $Notifier<ReviewsState> {
  ReviewsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReviewsState, ReviewsState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<ReviewsState, ReviewsState>, ReviewsState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
