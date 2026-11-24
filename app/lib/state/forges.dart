// The GitLab and GitHub command line sources, one each for the whole app, so
// tests can swap them.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../sources/chrome.dart';
import '../sources/github_source.dart';
import '../sources/gitlab_source.dart';

part 'forges.g.dart';

@Riverpod(keepAlive: true)
GitlabSource gitlabSource(Ref ref) => GitlabSource();

@Riverpod(keepAlive: true)
GithubSource githubSource(Ref ref) => GithubSource();

/// Read once, so tests can give made up profiles.
@Riverpod(keepAlive: true)
List<ChromeProfile> chromeProfileList(Ref ref) => chromeProfiles();
