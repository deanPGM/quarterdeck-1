// A local review's head: the working tree as a commit, the checkouts listed
// for review, against a real temp repository.
import 'dart:io';

import 'package:deck/data/review_git.dart';
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

void write(String dir, String path, String text) => (File(p.join(dir, path))..parent.createSync(recursive: true)).writeAsStringSync(text);

void main() {
  late String tree;

  setUp(() {
    root = Directory.systemTemp.createTempSync('deck-local-review-').resolveSymbolicLinksSync();
    git(['init', '-q', '-b', 'main']);
    write(root, 'a.txt', 'one\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
    tree = p.join(root, '.claude', 'worktrees', 'copy');
    git(['worktree', 'add', '-q', '-b', 'claude/copy', tree]);
    write(tree, 'a.txt', 'one\ntwo\n');
    git(['commit', '-q', '-am', 'two'], tree);
  });

  tearDown(() => Directory(root).deleteSync(recursive: true));

  test('a clean checkout is its HEAD', () async {
    expect(await worktreeHead(tree), git(['rev-parse', 'HEAD'], tree));
  });

  test('edits and new files go in a commit on HEAD, the index left alone', () async {
    write(tree, 'a.txt', 'one\ntwo\nthree\n');
    write(tree, 'new.txt', 'new\n');
    final status = git(['status', '--porcelain'], tree);
    final head = await worktreeHead(tree);
    expect(git(['rev-parse', '$head^'], tree), git(['rev-parse', 'HEAD'], tree));
    expect(git(['diff', '--name-only', 'HEAD', head], tree).split('\n'), ['a.txt', 'new.txt']);
    expect(git(['show', '$head:a.txt'], tree), 'one\ntwo\nthree');
    expect(git(['status', '--porcelain'], tree), status);
    // Same content, same sha: the diff is not derived again.
    expect(await worktreeHead(tree), head);
  });

  test('checkouts lists the folder and its worktrees, with commits ahead', () async {
    final all = await checkouts(root);
    expect(all, [(path: root, branch: 'main'), (path: tree, branch: 'claude/copy')]);
    expect(await commitsAhead(root, 'main', 'claude/copy'), 1);
    expect(await branches(root), ['claude/copy', 'main']);
    // A local copy of an origin branch gives way to origin's.
    git(['update-ref', 'refs/remotes/origin/main', 'main']);
    expect(await branches(root), ['origin/main', 'claude/copy']);
  });
}
