// Port of Skim's packages/core/src/parse.ts: `git diff` text to DiffFile,
// long hunks split at their declarations. Tags, moved flags and real counts
// are filled in later by classify.dart and moved.dart.
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'diff.dart';

/// A hunk this long is split at the declarations inside it, so four functions
/// added next to each other are four hunks with four notes instead of one wall
/// of green. Matches the fold threshold the page uses.
const _splitMinLines = 25;

/// Never leave a piece this short: its own header would cost more than it saves.
const _minPieceLines = 4;

/// How far to look inside a wrapper. Three levels reach a test inside a group inside main.
const _maxSplitDepth = 2;

final _ansi = RegExp(r'\x1B(?:\[[0-?]*[ -/]*[@-~]|\][^\x07\x1B]*(?:\x07|\x1B\\)|[@-Z\\-_])');

/// Git colour codes out of a --color=always diff.
String stripAnsi(String text) => text.replaceAll(_ansi, '');

final _fileStart = RegExp(r'^diff --git ', multiLine: true);
final _gitHeader = RegExp(r'^diff --git a/(.*) b/(.*)$');
final _hunkHeader = RegExp(r'^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@(.*)$');

/// Parses `git diff` output (plain, no ANSI) into files.
List<DiffFile> parseUnifiedDiff(String text) {
  final starts = [for (final m in _fileStart.allMatches(text)) m.start];
  return [for (var k = 0; k < starts.length; k++) _parseFile(text.substring(starts[k], k + 1 < starts.length ? starts[k + 1] : text.length))];
}

DiffFile _parseFile(String block) {
  final lines = (block.endsWith('\n') ? block.substring(0, block.length - 1) : block).split('\n');
  var oldPath = '', newPath = '', status = 'modified', isBinary = false;

  // Paths may contain spaces: the ---/+++ lines win when present.
  final m = _gitHeader.firstMatch(lines[0]);
  if (m != null) {
    oldPath = m[1]!;
    newPath = m[2]!;
  }

  var i = 1;
  for (; i < lines.length && !lines[i].startsWith('@@'); i++) {
    final l = lines[i];
    if (l.startsWith('new file mode')) {
      status = 'added';
    } else if (l.startsWith('deleted file mode')) {
      status = 'deleted';
    } else if (l.startsWith('rename from ')) {
      status = 'renamed';
      oldPath = l.substring('rename from '.length);
    } else if (l.startsWith('rename to ')) {
      newPath = l.substring('rename to '.length);
    } else if (l.startsWith('copy from ')) {
      status = 'copied';
      oldPath = l.substring('copy from '.length);
    } else if (l.startsWith('copy to ')) {
      newPath = l.substring('copy to '.length);
    } else if (l.startsWith('Binary files') || l.startsWith('GIT binary patch')) {
      isBinary = true;
    } else if (l.startsWith('--- ') && l != '--- /dev/null') {
      oldPath = _stripPrefix(l.substring(4));
    } else if (l.startsWith('+++ ') && l != '+++ /dev/null') {
      newPath = _stripPrefix(l.substring(4));
    }
  }

  final path = status == 'deleted' ? oldPath : newPath;
  final hunks = <Hunk>[];
  var additions = 0, deletions = 0;

  while (i < lines.length) {
    final hm = _hunkHeader.firstMatch(lines[i]);
    if (hm == null) {
      i++;
      continue;
    }
    final hunk = Hunk(
      header: lines[i],
      oldStart: int.parse(hm[1]!),
      oldCount: hm[2] == null ? 1 : int.parse(hm[2]!),
      newStart: int.parse(hm[3]!),
      newCount: hm[4] == null ? 1 : int.parse(hm[4]!),
      lines: [],
    );
    var oldLine = hunk.oldStart, newLine = hunk.newStart;
    i++;
    while (i < lines.length && !lines[i].startsWith('@@')) {
      final l = lines[i];
      final content = l.isEmpty ? '' : l.substring(1);
      if (l.startsWith(r'\ No newline')) {
        if (hunk.lines.isNotEmpty) hunk.lines.last.noNewline = true;
      } else if (l.startsWith('+')) {
        hunk.lines.add(DiffLine(type: lineAdd, content: content, newLine: newLine++));
        additions++;
      } else if (l.startsWith('-')) {
        hunk.lines.add(DiffLine(type: lineDelete, content: content, oldLine: oldLine++));
        deletions++;
      } else if (l.startsWith(' ') || l.isEmpty) {
        hunk.lines.add(DiffLine(type: lineContext, content: content, oldLine: oldLine++, newLine: newLine++));
      }
      i++;
    }
    hunk.ref = hunkRef(path, hunk.lines);
    hunks.addAll(_splitHunk(path, hunk));
  }

  return DiffFile(oldPath: oldPath, newPath: newPath, path: path, status: status, hunks: hunks, additions: additions, deletions: deletions, isBinary: isBinary);
}

String _stripPrefix(String p) => p.replaceFirst(RegExp(r'^[ab]/'), '').replaceFirst(RegExp(r'\t.*$'), '');

/// Leading whitespace width. A tab counts as one: only the relative depth matters.
int _indentOf(String content) => content.length - content.trimLeft().length;

bool _isBlank(DiffLine l) => l.content.trim().isEmpty;

/// A line that only closes what came before. Never a declaration, and it must
/// not set the depth either: the `});` ending a Dart group sits at the group's
/// own indentation and would keep every test inside it out of reach.
bool _isCloser(DiffLine l) => RegExp(r'^[)\]}]').hasMatch(l.content.trim());

/// Where a long hunk breaks: a blank line followed by a line at the outermost
/// indentation of the change. Reads the shape, not the syntax, so it works in
/// any language. The depth comes from the changed lines: methods added inside
/// a class sit two spaces in, and the class line opening the hunk would
/// otherwise set the depth to zero and split nothing.
List<int> _declarationCuts(List<DiffLine> lines) {
  final open = lines.where((l) => !_isBlank(l) && !_isCloser(l)).toList();
  final changed = open.where((l) => l.type != lineContext).toList();
  final measured = (changed.isNotEmpty ? changed : open).map((l) => _indentOf(l.content));
  if (measured.isEmpty) return [];
  final base = measured.reduce(min);
  return [
    for (var i = 1; i < lines.length; i++)
      if (_isBlank(lines[i - 1]) && !_isBlank(lines[i]) && !_isCloser(lines[i]) && _indentOf(lines[i].content) == base) i,
  ];
}

List<List<DiffLine>> _cutAt(List<DiffLine> lines, List<int> cuts) {
  final pieces = <List<DiffLine>>[];
  final bounds = [0, ...cuts, lines.length];
  for (var k = 0; k < bounds.length - 1; k++) {
    final piece = lines.sublist(bounds[k], bounds[k + 1]);
    // A runt on either side goes back into the piece before it.
    if (pieces.isNotEmpty && (piece.length < _minPieceLines || pieces.last.length < _minPieceLines)) {
      pieces.last.addAll(piece);
    } else {
      pieces.add(piece);
    }
  }
  return pieces;
}

/// Cuts a run of lines into declaration sized pieces. A piece still long is cut
/// again, and a run that is one declaration wrapping everything else (a class
/// body, a Dart `group`, a `main`) is opened one level so what it holds becomes
/// pieces of their own.
List<List<DiffLine>> _splitLines(List<DiffLine> lines, int depth) {
  if (lines.length < _splitMinLines || depth > _maxSplitDepth) return [lines];
  final pieces = _cutAt(lines, _declarationCuts(lines));
  if (pieces.length > 1) return [for (final p in pieces) ..._splitLines(p, depth + 1)];
  if (lines.length <= _minPieceLines) return [lines];
  final inner = _splitLines(lines.sublist(1), depth + 1);
  if (inner.length < 2) return [lines];
  return [
    [lines[0], ...inner[0]],
    ...inner.skip(1),
  ];
}

/// One hunk per declaration, with the line numbers each piece really covers.
List<Hunk> _splitHunk(String path, Hunk hunk) {
  final pieces = _splitLines(hunk.lines, 0);
  if (pieces.length < 2) return [hunk];

  final suffix = hunk.header.substring(hunk.header.indexOf('@@', 2) + 2);
  var oldLine = hunk.oldStart, newLine = hunk.newStart;
  final out = <Hunk>[];
  for (final lines in pieces) {
    final oldCount = lines.where((l) => l.type != lineAdd).length;
    final newCount = lines.where((l) => l.type != lineDelete).length;
    // git's convention for an empty side: the line the insertion follows.
    final oldStart = oldCount == 0 ? max(0, oldLine - 1) : oldLine;
    final newStart = newCount == 0 ? max(0, newLine - 1) : newLine;
    out.add(
      Hunk(
        header: '@@ -$oldStart,$oldCount +$newStart,$newCount @@${out.isEmpty ? suffix : ''}',
        oldStart: oldStart,
        oldCount: oldCount,
        newStart: newStart,
        newCount: newCount,
        lines: lines,
        ref: hunkRef(path, lines),
      ),
    );
    oldLine += oldCount;
    newLine += newCount;
  }
  return out;
}

/// Stable hunk id: sha1 of the path plus the changed lines, whitespace
/// collapsed, first 12 hex. No line numbers, so it survives edits above.
String hunkRef(String path, List<DiffLine> lines) {
  final body = lines
      .where((l) => l.type != lineContext)
      .map((l) => (l.type == lineAdd ? '+' : '-') + l.content.replaceAll(RegExp(r'\s+'), ' ').trim())
      .join('\n');
  return sha1.convert(utf8.encode('$path\n$body')).toString().substring(0, 12);
}
