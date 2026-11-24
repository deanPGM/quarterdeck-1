// Port of Skim's packages/core/tests/anchors.test.ts.
import 'dart:io';

import 'package:deck/core/review/anchors.dart';
import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/parse.dart';
import 'package:flutter_test/flutter_test.dart';

const framing = 'lib/src/features/framing/framing_screen.dart';

List<DiffFile> files() => parseUnifiedDiff(File('test/core/review/fixtures/safearea.diff').readAsStringSync());

DiffSnapshot snapshotOf(List<DiffFile> files) => DiffSnapshot(baseSha: 'a', headSha: 'b', baseRef: 'main', headRef: 'HEAD', files: files);

DiffLine shifted(DiffLine l, int by) =>
    DiffLine(type: l.type, content: l.content, oldLine: l.oldLine == null ? null : l.oldLine! + by, newLine: l.newLine == null ? null : l.newLine! + by);

Matcher refused(Pattern part) => throwsA(isA<AnchorError>().having((e) => e.message, 'message', matches(part)));

void main() {
  group('anchorFor', () {
    final snap = snapshotOf(files());

    test('anchors an added line on the new side to its hunk', () {
      final a = anchorFor(snap, path: framing, line: 78);
      expect(a.side, 'new');
      expect(a.hunkRef, snap.files[0].hunks[0].ref);
      expect((a.line, a.endLine), (78, 78));
      expect(a.contentHash, contentHash('body: SafeArea('));
    });

    test('anchors a deleted line on the old side', () {
      final a = anchorFor(snap, path: framing, side: 'old', line: 78);
      expect(a.side, 'old');
      expect(a.contentHash, contentHash('body: framingFuture.when('));
    });

    test('accepts a range inside one hunk', () {
      expect(anchorFor(snap, path: framing, line: 78, endLine: 80).endLine, 80);
    });

    test('rejects lines that are not in the diff', () {
      expect(() => anchorFor(snap, path: framing, line: 10), refused(RegExp('Line 10 .* not in the diff')));
      expect(() => anchorFor(snap, path: 'nope.dart', line: 78), refused('Path not in diff'));
      expect(() => anchorFor(snap, path: framing, side: 'old', line: 300), refused('not in the diff'));
      // A range that spills into another hunk.
      expect(() => anchorFor(snap, path: framing, line: 78, endLine: 140), refused('same hunk'));
    });
  });

  group('reanchor', () {
    final original = snapshotOf(files());
    final anchor = anchorFor(original, path: framing, line: 78, endLine: 79);

    test('is exact on the same snapshot', () {
      final r = reanchor(anchor, original);
      expect((r.status, r.anchor), ('exact', anchor));
    });

    test('is exact and refreshes line numbers when the hunk only shifted', () {
      final fs = files();
      final hunk = fs[0].hunks[0];
      for (var i = 0; i < hunk.lines.length; i++) {
        hunk.lines[i] = shifted(hunk.lines[i], 5);
      }
      final r = reanchor(anchor, snapshotOf(fs));
      expect(r.status, 'exact');
      expect((r.anchor.line, r.anchor.endLine), (83, 84));
      expect(r.anchor.hunkRef, anchor.hunkRef);
    });

    test('is moved when the hunk changed but the line content is still in the file', () {
      final fs = files();
      final hunk = fs[0].hunks[0];
      // Another line of the hunk changed, so the ref changes; our line survives.
      final i = hunk.lines.indexWhere((l) => l.type == lineAdd && l.newLine == 80);
      final other = hunk.lines[i];
      hunk.lines[i] = DiffLine(type: other.type, content: '${other.content} // edited', newLine: other.newLine);
      hunk.ref = hunkRef(framing, hunk.lines);
      expect(hunk.ref, isNot(anchor.hunkRef));
      final r = reanchor(anchor, snapshotOf(fs));
      expect(r.status, 'moved');
      expect(r.anchor.hunkRef, hunk.ref);
      expect(r.anchor.line, 78);
      expect(r.anchor.contentHash, anchor.contentHash);
    });

    test('is outdated when the line is gone or the file is gone', () {
      final fs = files();
      final hunk = fs[0].hunks[0];
      hunk.lines.removeWhere((l) => l.newLine == 78);
      hunk.ref = hunkRef(framing, hunk.lines);
      final r = reanchor(anchor, snapshotOf(fs));
      expect((r.status, r.anchor), ('outdated', anchor));
      expect(reanchor(anchor, snapshotOf([])).status, 'outdated');
    });
  });
}
