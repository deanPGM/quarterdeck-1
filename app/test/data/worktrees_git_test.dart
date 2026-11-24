// New task worktrees: added on a new branch, listed past the main folder,
// kept out of the main checkout's status. Against a real temp repository.
import 'dart:io';

import 'package:deck/data/review_git.dart';
import 'package:deck/state/worktrees.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

late String root;

String git(List<String> args, [String? dir]) {
  final r = Process.runSync('git', [
    '-c',
    'user.name=t',
    '-c',
    'user.email=t@example.com',
    '-c',
    'commit.gpgsign=false',
    ...args,
  ], workingDirectory: dir ?? root);
  if (r.exitCode != 0) throw StateError('git ${args.join(' ')}: ${r.stderr}');
  return (r.stdout as String).trim();
}

void main() {
  setUp(() {
    root = Directory.systemTemp.createTempSync('deck-worktrees-').resolveSymbolicLinksSync();
    git(['init', '-q', '-b', 'main']);
    File(p.join(root, 'a.txt')).writeAsStringSync('one\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
  });

  tearDown(() => Directory(root).deleteSync(recursive: true));

  test('a task worktree is listed with its branch, the main folder is not', () async {
    final path = p.join(root, worktreesDir, 'feat-login');
    await excludeLocally(root, '/$worktreesDir/');
    await addWorktree(root, path, 'feat/login', 'main');
    expect(await linkedWorktrees(root), [(path: path, branch: 'feat/login')]);
    expect(git(['status', '--porcelain']), isEmpty);
  });

  test('the exclude line is written once', () async {
    await excludeLocally(root, '/$worktreesDir/');
    await excludeLocally(root, '/$worktreesDir/');
    final lines = File(p.join(root, '.git', 'info', 'exclude')).readAsLinesSync();
    expect(lines.where((l) => l == '/$worktreesDir/'), hasLength(1));
  });

  test('a folder removed by hand is left out', () async {
    final path = p.join(root, worktreesDir, 'gone');
    await addWorktree(root, path, 'gone', 'main');
    Directory(path).deleteSync(recursive: true);
    expect(await linkedWorktrees(root), isEmpty);
  });

  test('task names become branch names', () {
    expect(taskBranch('  fix login crash '), 'fix-login-crash');
    expect(taskBranch('feat/AVPN-123'), 'feat/AVPN-123');
    expect(taskBranch('../oops..x//y/'), 'oops-x-y');
    expect(taskBranch('?!'), isEmpty);
  });
}
