// The line model of a review: what git says changed, parsed, split at
// declarations, moved lines marked and every file tagged. Derived from git
// each time, never stored. Same shape as Skim's (packages/core/src/types.ts),
// so the tools hand agents the JSON they already know.

const lineAdd = 'add', lineDelete = 'delete', lineContext = 'context';

/// Every tag the classifier gives a file.
const fileTags = ['generated', 'lockfile', 'formatting-only', 'moved-only', 'test', 'ci', 'docs', 'binary', 'rename-only', 'large'];

/// Hidden until the reviewer asks. The page always says how many files they hide.
const hiddenByDefault = ['generated', 'lockfile', 'formatting-only', 'moved-only'];

class DiffLine {
  DiffLine({required this.type, required this.content, this.oldLine, this.newLine, this.moved = false, this.noNewline = false});

  /// add, delete or context.
  final String type;
  final String content;
  final int? oldLine;
  final int? newLine;

  /// git's --color-moved matched it as part of a moved block.
  bool moved;
  bool noNewline;

  Map<String, Object?> toJson() => {
    'type': type,
    'content': content,
    'oldLine': oldLine,
    'newLine': newLine,
    if (moved) 'moved': true,
    if (noNewline) 'noNewline': true,
  };
}

class Hunk {
  Hunk({
    required this.header,
    required this.oldStart,
    required this.oldCount,
    required this.newStart,
    required this.newCount,
    required this.lines,
    this.ref = '',
  });

  final String header;
  final int oldStart, oldCount, newStart, newCount;
  final List<DiffLine> lines;

  /// Stable id: path plus the changed lines, whitespace collapsed. Notes and
  /// anchors point here, and it survives edits above the hunk.
  String ref;

  Map<String, Object?> toJson() => {
    'header': header,
    'ref': ref,
    'oldStart': oldStart,
    'oldCount': oldCount,
    'newStart': newStart,
    'newCount': newCount,
    'lines': [for (final l in lines) l.toJson()],
  };
}

class DiffFile {
  DiffFile({
    required this.oldPath,
    required this.newPath,
    required this.path,
    required this.status,
    required this.hunks,
    required this.additions,
    required this.deletions,
    this.isBinary = false,
  }) : realAdditions = additions,
       realDeletions = deletions;

  final String oldPath, newPath;

  /// newPath, or oldPath for a deleted file. Display and anchors use it.
  final String path;

  /// added, deleted, modified, renamed or copied.
  final String status;
  final List<Hunk> hunks;
  final int additions, deletions;

  /// Additions and deletions that are not moved lines.
  int realAdditions, realDeletions;
  final bool isBinary;
  List<String> tags = [];

  Map<String, Object?> toJson({bool lines = true}) => {
    'path': path,
    if (oldPath != newPath) 'oldPath': oldPath,
    'status': status,
    'additions': additions,
    'deletions': deletions,
    'realAdditions': realAdditions,
    'realDeletions': realDeletions,
    if (isBinary) 'isBinary': true,
    'tags': tags,
    if (lines) 'hunks': [for (final h in hunks) h.toJson()] else 'hunks': hunks.length,
  };
}

class DiffSnapshot {
  DiffSnapshot({
    required this.baseSha,
    required this.headSha,
    required this.baseRef,
    required this.headRef,
    required this.files,
    this.hidden = hiddenByDefault,
  });

  final String baseSha, headSha, baseRef, headRef;
  final List<DiffFile> files;

  /// The tags hidden by default for this repository (`.skim.yml` may change them).
  final List<String> hidden;

  int get additions => files.fold(0, (n, f) => n + f.additions);
  int get deletions => files.fold(0, (n, f) => n + f.deletions);
  int get hiddenCount => files.where((f) => f.tags.any(hidden.contains)).length;
}
