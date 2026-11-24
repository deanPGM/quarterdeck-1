// Port of Skim's gitlab/src/positions.ts and the placing half of
// github/src/publish.ts: where a thread lands on each forge.
import 'diff.dart';
import 'publish_plan.dart';
import 'review.dart';

/// A GitLab text position. Added line: new_line only. Deleted line: old_line
/// only. Unchanged context line: both, or GitLab answers "line_code can't be blank".
Map<String, Object?> positionFor(Anchor anchor, DiffRefs refs, String oldPath, String newPath, [DiffLine? line]) {
  final ctx = line?.type == lineContext;
  return {
    'position_type': 'text',
    'base_sha': refs.baseSha,
    'start_sha': refs.startSha,
    'head_sha': refs.headSha,
    'old_path': oldPath,
    'new_path': newPath,
    if (anchor.side == 'new') ...{'new_line': anchor.line, if (ctx && line?.oldLine != null) 'old_line': line!.oldLine},
    if (anchor.side == 'old') ...{'old_line': anchor.line, if (ctx && line?.newLine != null) 'new_line': line!.newLine},
  };
}

int? _on(DiffLine l, Anchor a) => a.side == 'new' ? l.newLine : l.oldLine;

/// [positionFor] with the paths and the diff line looked up in [snapshot].
Map<String, Object?> positionForAnchor(Anchor anchor, DiffSnapshot snapshot, DiffRefs refs) {
  final file = snapshot.files.where((f) => f.path == anchor.path).firstOrNull;
  if (file == null) throw StateError('Path not in diff: ${anchor.path}');
  final hunk =
      file.hunks.where((h) => h.ref == anchor.hunkRef).firstOrNull ?? file.hunks.where((h) => h.lines.any((l) => _on(l, anchor) == anchor.line)).firstOrNull;
  final line = hunk?.lines.where((l) => _on(l, anchor) == anchor.line).firstOrNull;
  if (line == null) throw StateError('Line ${anchor.line} (${anchor.side} side) of ${anchor.path} is not in the diff');
  return positionFor(anchor, refs, file.oldPath, file.newPath, line);
}

/// Where a forge note sits in our terms: the new side when it has a new line,
/// the old side otherwise. Null without a line.
({String path, String side, int line})? anchorInputFromPosition(Map<String, Object?> pos) {
  final newLine = pos['new_line'], oldLine = pos['old_line'], newPath = pos['new_path'], oldPath = pos['old_path'];
  if (newLine is int && newLine > 0 && newPath is String) return (path: newPath, side: 'new', line: newLine);
  if (oldLine is int && oldLine > 0 && oldPath is String) return (path: oldPath, side: 'old', line: oldLine);
  return null;
}

/// A GitHub review comment: a line on one side, as a range when it spans several.
Map<String, Object?> commentFor(Thread thread, Anchor anchor) {
  final side = anchor.side == 'new' ? 'RIGHT' : 'LEFT';
  return {
    'path': anchor.path,
    'body': threadBody(thread, gitHubSuggestion),
    'line': anchor.endLine,
    'side': side,
    if (anchor.endLine > anchor.line) ...{'start_line': anchor.line, 'start_side': side},
  };
}

/// Each comment we sent to the one GitHub kept for it, in order, null where
/// none was found: an exact body match first, then path, line and side. A
/// posted comment is taken once, so two threads with the same text on the
/// same line pair with two comments.
List<Map<String, Object?>?> matchPosted(List<Map<String, Object?>> posted, List<Map<String, Object?>> comments) {
  final free = [...posted];
  final out = List<Map<String, Object?>?>.filled(comments.length, null);
  bool at(Map<String, Object?> p, Map<String, Object?> c) => p['path'] == c['path'] && (p['line'] ?? p['original_line']) == c['line'] && p['side'] == c['side'];
  void take(int i, bool Function(Map<String, Object?>) ok) {
    if (out[i] != null) return;
    final k = free.indexWhere(ok);
    if (k >= 0) out[i] = free.removeAt(k);
  }

  for (var i = 0; i < comments.length; i++) {
    take(i, (p) => at(p, comments[i]) && p['body'] == comments[i]['body']);
  }
  for (var i = 0; i < comments.length; i++) {
    take(i, (p) => at(p, comments[i]));
  }
  return out;
}
