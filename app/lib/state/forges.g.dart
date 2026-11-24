// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forges.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gitlabSource)
final gitlabSourceProvider = GitlabSourceProvider._();

final class GitlabSourceProvider extends $FunctionalProvider<GitlabSource, GitlabSource, GitlabSource> with $Provider<GitlabSource> {
  GitlabSourceProvider._()
    : super(from: null, argument: null, retry: null, name: r'gitlabSourceProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$gitlabSourceHash();

  @$internal
  @override
  $ProviderElement<GitlabSource> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GitlabSource create(Ref ref) {
    return gitlabSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GitlabSource value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GitlabSource>(value));
  }
}

String _$gitlabSourceHash() => r'c9312340728e1c8fed87a9b7c9a8cf019c660645';

@ProviderFor(githubSource)
final githubSourceProvider = GithubSourceProvider._();

final class GithubSourceProvider extends $FunctionalProvider<GithubSource, GithubSource, GithubSource> with $Provider<GithubSource> {
  GithubSourceProvider._()
    : super(from: null, argument: null, retry: null, name: r'githubSourceProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$githubSourceHash();

  @$internal
  @override
  $ProviderElement<GithubSource> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GithubSource create(Ref ref) {
    return githubSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GithubSource value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GithubSource>(value));
  }
}

String _$githubSourceHash() => r'2af6ec1aa977b69f86bda505406c2b17bec238a8';

/// Read once, so tests can give made up profiles.

@ProviderFor(chromeProfileList)
final chromeProfileListProvider = ChromeProfileListProvider._();

/// Read once, so tests can give made up profiles.

final class ChromeProfileListProvider extends $FunctionalProvider<List<ChromeProfile>, List<ChromeProfile>, List<ChromeProfile>>
    with $Provider<List<ChromeProfile>> {
  /// Read once, so tests can give made up profiles.
  ChromeProfileListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chromeProfileListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chromeProfileListHash();

  @$internal
  @override
  $ProviderElement<List<ChromeProfile>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<ChromeProfile> create(Ref ref) {
    return chromeProfileList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChromeProfile> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<ChromeProfile>>(value));
  }
}

String _$chromeProfileListHash() => r'ceb80b0a24248a9b20276d842dc4921bd4601390';
