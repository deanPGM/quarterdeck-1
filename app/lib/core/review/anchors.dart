// Port of Skim's packages/core/src/anchors.ts: anchors tie a thread to the
// diff. A line is found by its hunk (stable across unrelated edits above it)
// and by a hash of its content (to find it again when the hunk changed).
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'diff.dart';
import 'review.dart';

class AnchorError implements Exception {
  AnchorError(this.message);

  final String message;

  @override
  String toString() => message;
}

String contentHash(String content) => sha1.convert(utf8.encode(content.trim())).toString().substring(0, 12);

int? _lineNumber(DiffLine l, String side) => side == 'new' ? l.newLine : l.oldLine;

/// An anchor for a line (or a range in one hunk) of the diff. Throws when the
/// path or the line is not in the diff, so nothing unshowable is stored.
Anchor anchorFor(DiffSnapshot snapshot, {required String path, required int line, String side = 'new', int? endLine}) {
  final end = endLine ?? line;
  if (line < 1) throw AnchorError('Invalid line: $line');
  if (end < line) throw AnchorError('Invalid endLine: $end (line is $line)');
  final file = snapshot.files.where((f) => f.path == path).firstOrNull;
  if (file == null) throw AnchorError('Path not in diff: $path');
  for (final hunk in file.hunks) {
    final hit = hunk.lines.where((l) => _lineNumber(l, side) == line).firstOrNull;
    if (hit == null) continue;
    for (var n = line + 1; n <= end; n++) {
      if (!hunk.lines.any((l) => _lineNumber(l, side) == n)) throw AnchorError('Line $n ($side side) of $path is not in the same hunk as line $line');
    }
    return Anchor(path: path, side: side, hunkRef: hunk.ref, line: line, endLine: end, contentHash: contentHash(hit.content));
  }
  throw AnchorError('Line $line ($side side) of $path is not in the diff');
}

/// exact, moved or outdated.
typedef Reanchored = ({String status, Anchor anchor});

/// An anchor mapped onto a new snapshot. Same hunk: exact, line numbers
/// refreshed. Same content elsewhere in the file: moved. Nothing: outdated,
/// the anchor unchanged so the page can still show it.
Reanchored reanchor(Anchor anchor, DiffSnapshot snapshot) {
  final file = snapshot.files.where((f) => f.path == anchor.path).firstOrNull;
  if (file == null) return (status: 'outdated', anchor: anchor);
  final span = anchor.endLine - anchor.line;
  DiffLine? hitIn(Hunk h) => h.lines.where((l) => _lineNumber(l, anchor.side) != null && contentHash(l.content) == anchor.contentHash).firstOrNull;

  final same = file.hunks.where((h) => h.ref == anchor.hunkRef).firstOrNull;
  if (same != null) {
    final hit = hitIn(same);
    final line = hit == null ? anchor.line : _lineNumber(hit, anchor.side)!;
    return (status: 'exact', anchor: anchor.copyWith(line: line, endLine: line + span));
  }
  for (final hunk in file.hunks) {
    final hit = hitIn(hunk);
    if (hit != null) {
      final line = _lineNumber(hit, anchor.side)!;
      return (status: 'moved', anchor: anchor.copyWith(hunkRef: hunk.ref, line: line, endLine: line + span));
    }
  }
  return (status: 'outdated', anchor: anchor);
}
