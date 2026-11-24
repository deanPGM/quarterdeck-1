// Port of Skim's packages/core/src/moved.ts: which changed lines git matched
// as moved, read from `git diff --color-moved` output.
import 'diff.dart';

final _sgr = RegExp(r'\x1b\[([0-9;]*)m');
final _hunkHeader = RegExp(r'@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@');

/// Keys `path:side:line` of the moved lines. A `+` or `-` line whose first SGR
/// code is the plain add or delete colour (32 or 31) is a real change; any
/// other (dim 2, bright 1;3x, the zebra alternates) is a line git matched as
/// moved, including the indentation only moves a Flutter wrap produces.
Set<String> movedKeysFromColored(String colored) {
  final moved = <String>{};
  var file = '';
  var oldLine = 0, newLine = 0;
  var inHunk = false;
  for (final raw in colored.split('\n')) {
    final codes = [for (final m in _sgr.allMatches(raw)) m[1]!];
    final plain = raw.replaceAll(_sgr, '');
    if (plain.startsWith('diff --git')) {
      inHunk = false;
      file = '';
      continue;
    }
    if (!inHunk) {
      if (plain.startsWith('+++ ') && plain != '+++ /dev/null') file = _path(plain, 'b/');
      if (plain.startsWith('--- ') && plain != '--- /dev/null' && file.isEmpty) file = _path(plain, 'a/');
    }
    if (plain.startsWith('@@')) {
      final m = _hunkHeader.firstMatch(plain);
      if (m != null) {
        oldLine = int.parse(m[1]!);
        newLine = int.parse(m[2]!);
        inHunk = true;
      }
      continue;
    }
    if (!inHunk) continue;
    final first = codes.isEmpty ? '' : codes.first;
    if (plain.startsWith('+')) {
      if (first != '32') moved.add('$file:new:$newLine');
      newLine++;
    } else if (plain.startsWith('-')) {
      if (first != '31') moved.add('$file:old:$oldLine');
      oldLine++;
    } else if (plain.startsWith(' ') || plain.isEmpty) {
      oldLine++;
      newLine++;
    }
  }
  return moved;
}

String _path(String line, String prefix) {
  var p = line.substring(4);
  if (p.startsWith(prefix)) p = p.substring(prefix.length);
  return p.replaceFirst(RegExp(r'\t.*$'), '');
}

/// Marks the moved lines on parsed files and recomputes the real change counts.
void applyMoved(List<DiffFile> files, Set<String> moved) {
  for (final file in files) {
    var realAdd = 0, realDel = 0;
    for (final hunk in file.hunks) {
      for (final line in hunk.lines) {
        if (line.type == lineAdd) {
          line.moved = moved.contains('${file.newPath}:new:${line.newLine}');
          if (!line.moved) realAdd++;
        } else if (line.type == lineDelete) {
          line.moved = moved.contains('${file.oldPath}:old:${line.oldLine}');
          if (!line.moved) realDel++;
        }
      }
    }
    file.realAdditions = realAdd;
    file.realDeletions = realDel;
  }
}
