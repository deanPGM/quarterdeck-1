// Worktrees of every project: start a new task in one (a branch of its own,
// a Claude session, no IDE), and get back to the ones already there. Claude
// keeps its sessions per folder, so `claude --continue` in a worktree picks
// up where its last session stopped. Deck stores nothing: git lists them.
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../claude/worker.dart' show newSessionId;
import '../core/models/config.dart';
import '../data/deck_home.dart';
import '../data/review_git.dart';
import 'project_info.dart' show logoFile;
import 'settings.dart';
import 'terminals.dart';

part 'worktrees.g.dart';

/// One worktree past a project's main folder. [branch] is null on a
/// detached head.
typedef Worktree = ({String project, String root, String path, String? branch, int uncommitted});

/// Where Deck and `claude -w` put a project's worktrees.
const worktreesDir = '.claude/worktrees';

/// The worktrees of every project with a folder, by project then path.
/// Deck's own review worktrees (in its cache) are left out.
@riverpod
Future<List<Worktree>> worktrees(Ref ref) async {
  final cfg = await ref.watch(settingsProvider.future);
  final cache = ref.watch(homeProvider).cache.path;
  // `claude -w` and git outside Deck add and drop worktrees: looked at again
  // each minute while shown.
  final again = Timer(const Duration(minutes: 1), ref.invalidateSelf);
  ref.onDispose(again.cancel);
  final found = <Worktree>[];
  for (final pr in cfg.projects) {
    if (pr.dir == null) continue;
    final root = expandHome(pr.dir!);
    if (FileSystemEntity.typeSync(p.join(root, '.git')) == FileSystemEntityType.notFound) continue;
    try {
      for (final w in await linkedWorktrees(root)) {
        if (p.isWithin(cache, w.path)) continue;
        found.add((project: pr.id, root: root, path: w.path, branch: w.branch, uncommitted: (await uncommittedFiles(w.path)).length));
      }
    } on ProcessException {
      continue;
    }
  }
  return found;
}

/// What a worktree is called on screen: its branch, else its folder.
String worktreeName(Worktree w) => w.branch ?? p.basename(w.path);

/// The terminal tab key of a task started in a worktree.
String worktreeKey(String path) => 'tree:$path';

/// The running tab working in [w], if any: started here, or a ticket session
/// (`claude -w <key>` from the project folder, its tab titled with the key).
TermTab? worktreeTab(TermState terms, Worktree w) => terms.tabs
    .where((t) => !t.exited && (t.dir == w.path || t.info.cardKey == worktreeKey(w.path) || (t.dir == w.root && t.info.title == p.basename(w.path))))
    .firstOrNull;

String _q(String s) => "'${s.replaceAll("'", r"'\''")}'";

/// A branch name typed by hand, made safe for git: spaces become dashes,
/// anything else odd is dropped.
String taskBranch(String name) => name
    .trim()
    .replaceAll(RegExp(r'\s+'), '-')
    .replaceAll(RegExp(r'[^A-Za-z0-9/._-]'), '')
    .replaceAll(RegExp(r'\.\.+|/{2,}'), '-')
    .replaceAll(RegExp(r'^[-/.]+|[-/.]+$'), '');

@Riverpod(keepAlive: true)
class WorktreeTasks extends _$WorktreeTasks {
  @override
  void build() {}

  /// Starts task [name] in [project]: a new branch from origin's default
  /// branch, in a worktree under `.claude/worktrees/`, and a Claude session
  /// in it. The main checkout never moves.
  Future<void> start(ProjectConfig project, String name) async {
    final branch = taskBranch(name);
    if (branch.isEmpty) throw StateError('Give the task a name.');
    final root = project.dir == null ? null : expandHome(project.dir!);
    if (root == null || !Directory(root).existsSync()) throw StateError('Set the folder of ${project.name} in Settings.');
    final path = p.join(root, worktreesDir, branch.replaceAll('/', '-'));
    if (Directory(path).existsSync()) throw StateError('$branch has a worktree already: resume it from Worktrees.');
    final base = await defaultBase(root);
    if (base.startsWith('origin/')) await fetchQuietly(root, base.substring(7));
    await excludeLocally(root, '/$worktreesDir/');
    await addWorktree(root, path, branch, base);
    ref.invalidate(worktreesProvider);
    final id = newSessionId();
    await ref
        .read(terminalsProvider.notifier)
        .open(_info(project, branch, path), ['claude', '-n', branch, '--session-id', id].map(_q).join(' '), path, restore: 'claude --resume $id');
  }

  /// Back to [w]: its running tab, else its last Claude session.
  Future<void> resume(Worktree w) async {
    final terms = ref.read(terminalsProvider.notifier);
    if (worktreeTab(ref.read(terminalsProvider), w) case final tab?) return terms.focus(tab);
    final cfg = await ref.read(settingsProvider.future);
    final project = cfg.projects.firstWhere((x) => x.id == w.project);
    await terms.open(_info(project, worktreeName(w), w.path), 'claude --continue', w.path, restore: 'claude --continue');
  }

  /// Removes [w]'s folder. The branch stays, with its commits. Git refuses
  /// when edits are not committed.
  Future<void> remove(Worktree w) async {
    await removeWorktree(w.root, w.path);
    ref.invalidate(worktreesProvider);
  }

  TermInfo _info(ProjectConfig project, String name, String path) => TermInfo(
    title: name,
    action: 'Claude',
    detail: 'Worktree of ${project.name}',
    cardKey: worktreeKey(path),
    logo: logoFile(ref.read(homeProvider), project),
    platforms: project.platforms,
  );
}
