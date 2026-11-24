// Port of Skim's packages/core/src/{git,snapshot}.ts: the git side of a
// review. Derives the line model from git each time, nothing is stored.
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/review/classify.dart';
import '../core/review/diff.dart';
import '../core/review/moved.dart';
import '../core/review/parse.dart';
import '../core/review/skim_config.dart';

/// Runs git with an argument list, never a shell string: refs and paths come
/// from MCP calls. LC_ALL=C because git messages are matched, they must not
/// follow the user's locale.
Future<String> _git(String root, List<String> args, {Map<String, String> env = const {}}) async {
  final r = await Process.run(
    'git',
    args,
    workingDirectory: root,
    environment: {'LC_ALL': 'C', 'GIT_OPTIONAL_LOCKS': '0', ...env},
    // A file in latin1 must not fail the whole diff.
    stdoutEncoding: const Utf8Codec(allowMalformed: true),
    stderrEncoding: const Utf8Codec(allowMalformed: true),
  );
  if (r.exitCode != 0) throw ProcessException('git', args, '${r.stderr}'.trim(), r.exitCode);
  return r.stdout as String;
}

/// Refuses anything git could read as an option.
String assertSafeRef(String ref) {
  if (ref.isEmpty || ref.startsWith('-') || RegExp(r'[\s\x00]').hasMatch(ref)) throw ArgumentError('Invalid git ref: ${jsonEncode(ref)}');
  return ref;
}

String assertSafePath(String path) {
  if (path.isEmpty || path.startsWith('-') || path.contains('\x00') || path.split('/').contains('..')) {
    throw ArgumentError('Invalid path: ${jsonEncode(path)}');
  }
  return path;
}

Future<String> revParse(String root, String ref) async => (await _git(root, ['rev-parse', '--verify', '${assertSafeRef(ref)}^{commit}'])).trim();

Future<bool> isAncestor(String root, String a, String b) async {
  try {
    await _git(root, ['merge-base', '--is-ancestor', assertSafeRef(a), assertSafeRef(b)]);
    return true;
  } on ProcessException catch (e) {
    if (e.errorCode == 1) return false;
    rethrow;
  }
}

/// Moves [ref] to [to] only if it still points at [from].
Future<void> updateRef(String root, String ref, String to, String from) =>
    _git(root, ['update-ref', assertSafeRef(ref), assertSafeRef(to), assertSafeRef(from)]);

/// Points [ref] at [to], whatever it held.
Future<void> setRef(String root, String ref, String to) => _git(root, ['update-ref', assertSafeRef(ref), assertSafeRef(to)]);

/// Moves [branch] from [from] to [to]. Where it is checked out, `reset
/// --keep` carries the uncommitted edits along, and refuses when one is in
/// the way.
Future<void> moveBranch(String root, String branch, String to, String from) async {
  final dir = await checkoutOf(root, branch);
  if (dir == null) return updateRef(root, 'refs/heads/${assertSafeRef(branch)}', to, from);
  if (await revParse(dir, 'HEAD') != from) throw ProcessException('git', ['reset'], '$branch moved', 1);
  await _git(dir, ['reset', '--quiet', '--keep', assertSafeRef(to)]);
}

/// Cherry picks [sha] onto [branch] where it is checked out, and returns the
/// new commit. A conflict is aborted, the branch left as it was.
Future<String> cherryPick(String root, String branch, String sha) async {
  final dir = await checkoutOf(root, branch);
  if (dir == null) throw ProcessException('git', ['cherry-pick'], '$branch is not checked out anywhere', 1);
  try {
    await _git(dir, ['cherry-pick', assertSafeRef(sha)]);
  } on ProcessException {
    await _git(dir, ['cherry-pick', '--abort']).catchError((_) => '');
    rethrow;
  }
  return revParse(dir, 'HEAD');
}

/// The commits after [from] up to [to], oldest first.
Future<List<String>> commitsBetween(String root, String from, String to) async => [
  for (final l in (await _git(root, ['rev-list', '--reverse', '${assertSafeRef(from)}..${assertSafeRef(to)}'])).split('\n'))
    if (l.trim().isNotEmpty) l.trim(),
];

/// The tip [branch] would have without commit [sha]: the commits above it
/// replayed on its parent, in memory (`git replay`), nothing checked out or
/// moved. Null when one of them does not apply there, or one ends up empty.
Future<String?> tipWithout(String root, String branch, String sha) async {
  final tip = await revParse(root, branch);
  final parent = await revParse(root, '$sha^');
  final above = await commitsBetween(root, sha, tip);
  if (above.isEmpty) return parent;
  final ref = 'refs/heads/${assertSafeRef(branch)}';
  final String out;
  try {
    out = await _git(root, ['replay', '--onto', parent, '$sha..$ref']);
  } on ProcessException {
    return null;
  }
  // `update <ref> <new> <old>`: the move it would make, not made.
  final parts = out.split('\n').firstWhere((l) => l.startsWith('update $ref '), orElse: () => '').split(' ');
  if (parts.length != 4 || parts[3] != tip) return null;
  final next = parts[2];
  return (await commitsBetween(root, parent, next)).length == above.length ? next : null;
}

/// Reverts [sha] on [branch] where it is checked out, and returns the
/// revert commit. A conflict is aborted, the branch left as it was.
Future<String> revertOn(String root, String branch, String sha) async {
  final dir = await checkoutOf(root, branch);
  if (dir == null) throw ProcessException('git', ['revert'], '$branch is not checked out anywhere', 1);
  try {
    await _git(dir, ['revert', '--no-edit', assertSafeRef(sha)]);
  } on ProcessException {
    await _git(dir, ['revert', '--abort']).catchError((_) => '');
    rethrow;
  }
  return revParse(dir, 'HEAD');
}

/// The folder that has [branch] checked out (the project folder itself, or
/// any worktree), or null. Creates nothing.
Future<String?> checkoutOf(String root, String branch) async {
  final out = await _git(root, ['worktree', 'list', '--porcelain']);
  String? path;
  for (final line in out.split('\n')) {
    if (line.startsWith('worktree ')) path = line.substring(9);
    if (line == 'branch refs/heads/$branch' && path != null) return path;
  }
  return null;
}

/// Every folder with a branch checked out: the project folder and each of
/// its worktrees. A detached head is left out.
Future<List<({String path, String branch})>> checkouts(String root) async {
  final out = await _git(root, ['worktree', 'list', '--porcelain']);
  final found = <({String path, String branch})>[];
  String? path;
  for (final line in out.split('\n')) {
    if (line.startsWith('worktree ')) path = line.substring(9);
    if (line.startsWith('branch refs/heads/') && path != null && Directory(path).existsSync()) found.add((path: path, branch: line.substring(18)));
  }
  return found;
}

/// The branch a local review diffs from: origin's default branch, as
/// `origin/main`.
Future<String> defaultBase(String root) async {
  try {
    return (await _git(root, ['symbolic-ref', '--short', 'refs/remotes/origin/HEAD'])).trim();
  } on ProcessException {
    for (final ref in ['origin/main', 'origin/master', 'origin/develop', 'main', 'master']) {
      if ((await Process.run('git', ['rev-parse', '--verify', '--quiet', '$ref^{commit}'], workingDirectory: root)).exitCode == 0) return ref;
    }
    throw ProcessException('git', ['symbolic-ref'], 'No default branch found on origin', 1);
  }
}

/// Every branch a review may diff from: origin's, then the local ones
/// origin does not have. A local copy of an origin branch is left out: it
/// is often behind, and the merge request would target origin's.
Future<List<String>> branches(String root) async {
  final refs = (await _git(root, ['for-each-ref', '--format=%(refname)', 'refs/remotes', 'refs/heads'])).split('\n');
  final remote = [
    for (final r in refs)
      if (r.startsWith('refs/remotes/') && !r.endsWith('/HEAD')) r.substring(13),
  ];
  return [
    ...remote,
    for (final r in refs)
      if (r.startsWith('refs/heads/') && !remote.contains('origin/${r.substring(11)}')) r.substring(11),
  ];
}

/// The commits on [head] since its merge base with [base].
Future<int> commitsAhead(String root, String base, String head) async =>
    int.parse((await _git(root, ['rev-list', '--count', '${assertSafeRef(base)}..${assertSafeRef(head)}'])).trim());

/// A commit of the working tree of [dir] as it is now, new files included,
/// on top of HEAD; HEAD itself when nothing is changed. Touches nothing:
/// the files go through a copy of the index. Same content gives the same
/// sha (fixed author and dates), so the diff is only derived again when a
/// file changes.
Future<String> worktreeHead(String dir) async {
  final head = (await _git(dir, ['rev-parse', 'HEAD'])).trim();
  if ((await _git(dir, ['status', '--porcelain'])).trim().isEmpty) return head;
  final index = File(p.join(dir, (await _git(dir, ['rev-parse', '--git-path', 'index'])).trim()));
  final tmp = Directory.systemTemp.createTempSync('deck-index');
  try {
    final env = {'GIT_INDEX_FILE': p.join(tmp.path, 'index')};
    // The real index keeps the file stats, so add only reads changed files.
    if (index.existsSync()) index.copySync(env['GIT_INDEX_FILE']!);
    await _git(dir, ['add', '-A'], env: env);
    final tree = (await _git(dir, ['write-tree'], env: env)).trim();
    final date = (await _git(dir, ['log', '-1', '--format=%cI', 'HEAD'])).trim();
    const who = 'Deck';
    return (await _git(
      dir,
      ['commit-tree', '--no-gpg-sign', tree, '-p', head, '-m', 'Not committed yet'],
      env: {
        'GIT_AUTHOR_NAME': who,
        'GIT_AUTHOR_EMAIL': 'deck@localhost',
        'GIT_AUTHOR_DATE': date,
        'GIT_COMMITTER_NAME': who,
        'GIT_COMMITTER_EMAIL': 'deck@localhost',
        'GIT_COMMITTER_DATE': date,
      },
    )).trim();
  } finally {
    tmp.deleteSync(recursive: true);
  }
}

/// A working tree on [branch] to commit a fix in: the one that already has
/// it checked out (the project folder itself, or any worktree), else a new
/// worktree at [fallback]. Never a checkout in the reviewer's folder.
Future<String> worktreeFor(String root, String branch, String fallback) async {
  if (await checkoutOf(root, branch) case final path?) return path;
  if (Directory(fallback).existsSync()) throw StateError('$fallback exists but is not a worktree on $branch');
  Directory(p.dirname(fallback)).createSync(recursive: true);
  await _git(root, ['worktree', 'add', '--quiet', fallback, assertSafeRef(branch)]);
  return fallback;
}

/// Every worktree of [root] past the main folder, with its branch (null on a
/// detached head). Folders gone from disk are left out.
Future<List<({String path, String? branch})>> linkedWorktrees(String root) async {
  final out = await _git(root, ['worktree', 'list', '--porcelain']);
  final found = <({String path, String? branch})>[];
  for (final block in out.split('\n\n').skip(1)) {
    final lines = block.split('\n');
    final path = lines.firstWhere((l) => l.startsWith('worktree '), orElse: () => '').replaceFirst('worktree ', '');
    if (path.isEmpty || !Directory(path).existsSync()) continue;
    final branch = lines.where((l) => l.startsWith('branch refs/heads/')).firstOrNull?.substring(18);
    found.add((path: path, branch: branch));
  }
  return found;
}

/// A new worktree at [path] on new branch [branch], started from [base].
Future<void> addWorktree(String root, String path, String branch, String base) async {
  Directory(p.dirname(path)).createSync(recursive: true);
  await _git(root, ['worktree', 'add', '--quiet', '-b', assertSafeRef(branch), path, assertSafeRef(base)]);
}

/// Fetches [ref] from origin so a new branch starts from the latest. Never
/// asks for a password: offline or refused, the local copy is used.
Future<void> fetchQuietly(String root, String ref) async {
  try {
    await _git(root, ['fetch', '--quiet', 'origin', assertSafeRef(ref)], env: {'GIT_TERMINAL_PROMPT': '0'}).timeout(const Duration(seconds: 20));
  } catch (_) {}
}

/// Adds [pattern] to the repo's own ignore list (`.git/info/exclude`), so
/// worktrees inside the project folder never show as untracked files.
Future<void> excludeLocally(String root, String pattern) async {
  final common = (await _git(root, ['rev-parse', '--git-common-dir'])).trim();
  final f = File(p.join(p.isAbsolute(common) ? common : p.join(root, common), 'info', 'exclude'));
  final now = f.existsSync() ? await f.readAsString() : '';
  if (now.split('\n').contains(pattern)) return;
  await f.parent.create(recursive: true);
  await f.writeAsString('${now.isEmpty || now.endsWith('\n') ? now : '$now\n'}$pattern\n');
}

/// Removes the worktree at [path] if it is there. Refused by git when it has
/// uncommitted edits: they are the reviewer's to keep.
Future<void> removeWorktree(String root, String path) async {
  if (!Directory(path).existsSync()) return;
  await _git(root, ['worktree', 'remove', path]);
}

/// Deletes local [branch] if it is there. Git refuses one checked out in
/// any worktree.
Future<void> deleteBranch(String root, String branch) async {
  final there = await Process.run('git', ['rev-parse', '--verify', '--quiet', 'refs/heads/${assertSafeRef(branch)}'], workingDirectory: root);
  if (there.exitCode != 0) return;
  await _git(root, ['branch', '-D', branch]);
}

/// Files changed and not committed in [dir], as `git status --porcelain` lists them.
Future<List<String>> uncommittedFiles(String dir) async => [
  for (final l in (await _git(dir, ['status', '--porcelain'])).split('\n'))
    if (l.length > 3) l.substring(3),
];

/// Pushes local branch [branch] to [remoteBranch] on origin, fast forward
/// only. [env] carries the user's login (ssh agent, credential helper).
Future<void> pushBranch(String root, String branch, String remoteBranch, Map<String, String> env) async {
  final args = ['push', 'origin', 'refs/heads/${assertSafeRef(branch)}:refs/heads/${assertSafeRef(remoteBranch)}'];
  final r = await Process.run('git', args, workingDirectory: root, environment: {...env, 'LC_ALL': 'C', 'GIT_TERMINAL_PROMPT': '0'});
  if (r.exitCode != 0) throw ProcessException('git', args, '${r.stderr}'.trim(), r.exitCode);
}

Future<String> mergeBase(String root, String a, String b) async => (await _git(root, ['merge-base', assertSafeRef(a), assertSafeRef(b)])).trim();

/// Full messages of the commits in base..head, newest first. Where ticket references live.
Future<List<String>> commitMessages(String root, String base, String head) async {
  final out = await _git(root, ['log', '--format=%B%x00', '${assertSafeRef(base)}..${assertSafeRef(head)}']);
  return [
    for (final m in out.split('\x00'))
      if (m.trim().isNotEmpty) m.trim(),
  ];
}

/// Unified diff between two commits. With [colorMoved] the output carries the
/// ANSI codes moved.dart reads.
Future<String> gitDiff(String root, String base, String head, {bool colorMoved = false, bool ignoreWhitespace = false}) {
  return _git(root, [
    '-c',
    'core.quotepath=false',
    'diff',
    '--no-ext-diff',
    '--find-renames',
    '--find-copies',
    if (colorMoved) ...['--color=always', '--color-moved=dimmed-zebra', '--color-moved-ws=allow-indentation-change'] else '--no-color',
    if (ignoreWhitespace) ...['-w', '--ignore-blank-lines'],
    assertSafeRef(base),
    assertSafeRef(head),
  ]);
}

Future<String> showFile(String root, String sha, String path) => _git(root, ['show', '${assertSafeRef(sha)}:${assertSafePath(path)}']);

final _attrLine = RegExp(r'^(.*): (linguist-generated|gitlab-generated): (.*)$');

/// Paths .gitattributes marks linguist-generated or gitlab-generated.
Future<Set<String>> generatedAttributes(String root, List<String> paths) async {
  if (paths.isEmpty) return {};
  final out = await _git(root, ['check-attr', 'linguist-generated', 'gitlab-generated', '--', ...paths.map(assertSafePath)]);
  return {
    for (final line in out.split('\n'))
      if (_attrLine.firstMatch(line) case final m? when m[3] == 'set' || m[3] == 'true') m[1]!,
  };
}

/// Reads `<root>/.skim.yml`. Missing gives the defaults, broken throws [SkimConfigError].
SkimConfig loadSkimConfig(String root) {
  final file = File(p.join(root, configFile));
  if (!file.existsSync()) return SkimConfig();
  final String text;
  try {
    text = file.readAsStringSync();
  } on FileSystemException catch (e) {
    throw SkimConfigError(e.message);
  }
  return parseConfig(text);
}

/// The diff pipeline in one place: git three ways, parse, mark the moved
/// blocks, tag every file. The caller caches the result.
Future<DiffSnapshot> deriveSnapshot(String root, String baseSha, String headSha, String baseRef, String headRef) async {
  final [plain, colored, wsInsensitive] = await Future.wait([
    gitDiff(root, baseSha, headSha),
    gitDiff(root, baseSha, headSha, colorMoved: true),
    gitDiff(root, baseSha, headSha, ignoreWhitespace: true),
  ]);
  final files = parseUnifiedDiff(plain);
  applyMoved(files, movedKeysFromColored(colored));
  final formattingOnly = formattingOnlyPaths(files, parseUnifiedDiff(stripAnsi(wsInsensitive)));
  final generated = await generatedAttributes(root, [for (final f in files) f.path]).catchError((_) => <String>{});
  final config = loadSkimConfig(root);
  final ctx = classifyContextFor(config, formattingOnly: formattingOnly, generatedByAttributes: generated);
  for (final f in files) {
    f.tags = classifyFile(f, ctx);
  }
  return DiffSnapshot(baseSha: baseSha, headSha: headSha, baseRef: baseRef, headRef: headRef, files: files, hidden: config.hiddenByDefault);
}
