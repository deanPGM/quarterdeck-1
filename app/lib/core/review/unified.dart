// How a hunk's lines become rows. Git hands us a run of deleted lines then a
// run of added lines. Zipping them (deleted, added, deleted, added) reads well
// when each pair is one line being edited, and badly when the two runs have
// nothing to do with each other. So the unified view pairs them itself: a pair
// stays adjacent only when the two lines really are versions of each other,
// and the smallest edits collapse onto one row that remembers the old line.
// Port of Skim's packages/ui/src/unified.ts. Split view still zips: that is
// how it puts two changes on the same row.

import 'diff.dart';

/// Longest stretch of changed characters that still counts as a tweak rather than a rewrite.
const tweakChars = 12;

/// Share of the longer line the two must have in common to stay next to each other.
const pairSimilarity = .5;

enum Verdict { collapse, pair, apart }

enum RowKind { context, delete, add, tweak }

/// One row of the unified view. A tweak row shows [line] (the added line) and
/// carries the deleted one in [partner], for the hover and the old line number.
/// The two rows of a kept pair point at each other, so word edits can be marked.
class UnifiedRow {
  const UnifiedRow(this.kind, this.line, [this.partner]);
  final RowKind kind;
  final DiffLine line;
  final DiffLine? partner;

  /// The line a tweak row replaced.
  DiffLine? get was => kind == RowKind.tweak ? partner : null;
  int? get oldLine => kind == RowKind.tweak ? partner!.oldLine : line.oldLine;
  int? get newLine => line.newLine;
}

/// One row of the split view: old on the left, new on the right. [similar]
/// says the two are versions of each other, so word edits are worth marking.
class SplitRow {
  const SplitRow(this.old, this.neu, {this.similar = false});
  final DiffLine? old, neu;
  final bool similar;
}

/// The one stretch where two lines differ, found from both ends.
({int prefix, int suffix}) _ends(String a, String b) {
  final shortest = a.length < b.length ? a.length : b.length;
  var prefix = 0;
  while (prefix < shortest && a.codeUnitAt(prefix) == b.codeUnitAt(prefix)) {
    prefix++;
  }
  var suffix = 0;
  while (suffix < shortest - prefix && a.codeUnitAt(a.length - 1 - suffix) == b.codeUnitAt(b.length - 1 - suffix)) {
    suffix++;
  }
  return (prefix: prefix, suffix: suffix);
}

Verdict classify(String oldContent, String newContent) {
  // Same content on both sides is a move, not an edit. Leave it as two rows.
  if (oldContent == newContent) return Verdict.apart;
  final (:prefix, :suffix) = _ends(oldContent, newContent);
  final common = prefix + suffix;
  final oldMid = oldContent.length - common, newMid = newContent.length - common;
  final changed = oldMid > newMid ? oldMid : newMid;
  // A typo or a renamed identifier: short, in one place, and most of the line survived.
  if (changed <= tweakChars && common >= changed) return Verdict.collapse;
  final longest = oldContent.length > newContent.length ? oldContent.length : newContent.length;
  return longest > 0 && common / longest >= pairSimilarity ? Verdict.pair : Verdict.apart;
}

/// A moved line is the same code somewhere else: never pair it with an edit.
Verdict _verdict(DiffLine del, DiffLine ins) => del.moved || ins.moved ? Verdict.apart : classify(del.content, ins.content);

/// One run of changes with no context line in it.
List<UnifiedRow> _regroupBlock(List<DiffLine> block) {
  final deletes = [
    for (final l in block)
      if (l.type == lineDelete) l,
  ];
  final inserts = [
    for (final l in block)
      if (l.type == lineAdd) l,
  ];
  if (deletes.isEmpty || inserts.isEmpty) return [for (final l in block) UnifiedRow(l.type == lineAdd ? RowKind.add : RowKind.delete, l)];

  final out = <UnifiedRow>[];
  var apartDeletes = <DiffLine>[], apartInserts = <DiffLine>[];
  // Lines we could not pair go out in git's own order: everything removed, then everything added.
  void flush() {
    out.addAll([for (final l in apartDeletes) UnifiedRow(RowKind.delete, l), for (final l in apartInserts) UnifiedRow(RowKind.add, l)]);
    apartDeletes = [];
    apartInserts = [];
  }

  final n = deletes.length > inserts.length ? deletes.length : inserts.length;
  for (var i = 0; i < n; i++) {
    final del = i < deletes.length ? deletes[i] : null, ins = i < inserts.length ? inserts[i] : null;
    if (del == null) {
      apartInserts.add(ins!);
      continue;
    }
    if (ins == null) {
      apartDeletes.add(del);
      continue;
    }
    final verdict = _verdict(del, ins);
    if (verdict == Verdict.apart) {
      apartDeletes.add(del);
      apartInserts.add(ins);
      continue;
    }
    flush();
    out.addAll(verdict == Verdict.pair ? [UnifiedRow(RowKind.delete, del, ins), UnifiedRow(RowKind.add, ins, del)] : [UnifiedRow(RowKind.tweak, ins, del)]);
  }
  flush();
  return out;
}

/// Splits [lines] into context lines and runs of changes, and hands each run to [block].
List<T> _byBlock<T>(List<DiffLine> lines, T Function(DiffLine) context, List<T> Function(List<DiffLine>) block) {
  final out = <T>[];
  for (var i = 0; i < lines.length;) {
    if (lines[i].type == lineContext) {
      out.add(context(lines[i++]));
      continue;
    }
    var end = i;
    while (end < lines.length && lines[end].type != lineContext) {
      end++;
    }
    out.addAll(block(lines.sublist(i, end)));
    i = end;
  }
  return out;
}

/// The unified rows of one hunk.
List<UnifiedRow> regroupUnified(List<DiffLine> lines) => _byBlock(lines, (l) => UnifiedRow(RowKind.context, l), _regroupBlock);

/// The split rows of one hunk: each run's deletes and adds zipped side by side.
List<SplitRow> pairSplit(List<DiffLine> lines) => _byBlock(lines, (l) => SplitRow(l, l), (block) {
  final deletes = [
    for (final l in block)
      if (l.type == lineDelete) l,
  ];
  final inserts = [
    for (final l in block)
      if (l.type == lineAdd) l,
  ];
  final n = deletes.length > inserts.length ? deletes.length : inserts.length;
  return [
    for (var i = 0; i < n; i++)
      () {
        final del = i < deletes.length ? deletes[i] : null, ins = i < inserts.length ? inserts[i] : null;
        return SplitRow(del, ins, similar: del != null && ins != null && _verdict(del, ins) != Verdict.apart);
      }(),
  ];
});

/// Character ranges [start, end) that changed within a line pair, on each side.
typedef Edits = ({List<(int, int)> old, List<(int, int)> neu});

/// Past this many tokens per side the LCS gets slow: fall back to the one middle stretch.
const _maxTokens = 400;

final _token = RegExp(r'\w+|\s+|[^\w\s]');

/// What changed between two versions of a line, word by word like
/// react-diff-view's markEdits: tokens outside the longest common subsequence
/// are edits, and neighbouring edits merge into one range.
Edits lineEdits(String a, String b) {
  final ta = _token.allMatches(a).toList(), tb = _token.allMatches(b).toList();
  if (ta.length > _maxTokens || tb.length > _maxTokens) {
    final (:prefix, :suffix) = _ends(a, b);
    return (old: _range(prefix, a.length - suffix), neu: _range(prefix, b.length - suffix));
  }
  // Classic LCS table from the end, so the walk below goes forward.
  final n = ta.length, m = tb.length;
  final dp = List.generate(n + 1, (_) => List.filled(m + 1, 0));
  for (var i = n - 1; i >= 0; i--) {
    for (var j = m - 1; j >= 0; j--) {
      dp[i][j] = ta[i][0] == tb[j][0] ? dp[i + 1][j + 1] + 1 : (dp[i + 1][j] >= dp[i][j + 1] ? dp[i + 1][j] : dp[i][j + 1]);
    }
  }
  final old = <(int, int)>[], neu = <(int, int)>[];
  void mark(List<(int, int)> to, RegExpMatch t) {
    // Merge with the previous range when they touch, so "foo.bar" stays one highlight.
    if (to.isNotEmpty && to.last.$2 == t.start) {
      to.last = (to.last.$1, t.end);
    } else {
      to.add((t.start, t.end));
    }
  }

  var i = 0, j = 0;
  while (i < n || j < m) {
    if (i < n && j < m && ta[i][0] == tb[j][0]) {
      i++;
      j++;
    } else if (j >= m || (i < n && dp[i + 1][j] >= dp[i][j + 1])) {
      mark(old, ta[i++]);
    } else {
      mark(neu, tb[j++]);
    }
  }
  return (old: _trimSpace(old, a), neu: _trimSpace(neu, b));
}

List<(int, int)> _range(int start, int end) => start < end ? [(start, end)] : [];

/// Whitespace alone at the edge of an edit is noise in the highlight, and
/// two edits split by a lone space read better as one.
List<(int, int)> _trimSpace(List<(int, int)> ranges, String s) {
  final out = <(int, int)>[];
  for (final (start, end) in ranges) {
    final part = s.substring(start, end);
    if (part.trim().isEmpty) continue;
    final r = (start + part.length - part.trimLeft().length, end - (part.length - part.trimRight().length));
    if (out.isNotEmpty && s.substring(out.last.$2, r.$1).trim().isEmpty) {
      out.last = (out.last.$1, r.$2);
    } else {
      out.add(r);
    }
  }
  return out;
}
