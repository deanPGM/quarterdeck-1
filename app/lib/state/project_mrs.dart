import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/models/records.dart';
import '../data/deck_home.dart';
import '../data/review_git.dart';
import 'forges.dart';
import 'settings.dart';

part 'project_mrs.g.dart';

/// Every open merge request of a project, newest change first. Empty when
/// the project has no repo.
@riverpod
Future<List<ProjectMr>> projectMrs(Ref ref, String id) async {
  final cfg = await ref.watch(settingsProvider.future);
  final repo = cfg.projects.where((p) => p.id == id).firstOrNull?.repo;
  final List<ProjectMr> mrs;
  if (repo == null) {
    mrs = [];
  } else if (repo.startsWith('gitlab:')) {
    mrs = await ref.read(gitlabSourceProvider).fetchProject(repo.substring(7));
  } else if (repo.startsWith('github:')) {
    mrs = await ref.read(githubSourceProvider).fetchProject(repo.substring(7));
  } else {
    mrs = [];
  }
  return mrs..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
}

/// A local branch worth a review: checked out in the project folder or a
/// worktree, with commits past the default branch or edits not committed.
typedef LocalCheckout = ({String path, String branch, int ahead, int uncommitted});

/// Every checkout of the project that has something to review. Empty when
/// the project has no folder or it is not a git repo.
@riverpod
Future<List<LocalCheckout>> projectCheckouts(Ref ref, String id) async {
  final cfg = await ref.watch(settingsProvider.future);
  final dir = cfg.projects.where((p) => p.id == id).firstOrNull?.dir;
  if (dir == null) return [];
  final root = expandHome(dir);
  if (!Directory(root).existsSync()) return [];
  try {
    final base = await defaultBase(root);
    return [
      for (final c in await checkouts(root))
        if ((ahead: await commitsAhead(root, base, c.branch), uncommitted: (await uncommittedFiles(c.path)).length) case final n
            when n.ahead > 0 || n.uncommitted > 0)
          (path: c.path, branch: c.branch, ahead: n.ahead, uncommitted: n.uncommitted),
    ];
  } on ProcessException {
    return [];
  }
}
