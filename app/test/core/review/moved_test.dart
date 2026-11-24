// Port of Skim's packages/core/tests/moved.test.ts.
import 'dart:io';

import 'package:deck/core/review/classify.dart';
import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/moved.dart';
import 'package:deck/core/review/parse.dart';
import 'package:flutter_test/flutter_test.dart';

String fixture(String name) => File('test/core/review/fixtures/$name').readAsStringSync();

void main() {
  final moved = movedKeysFromColored(fixture('safearea.colored.diff'));
  final files = parseUnifiedDiff(fixture('safearea.diff'));
  applyMoved(files, moved);

  test('marks the re-indented SafeArea children as moved', () {
    // 211 changed lines, git marks 168 as moved (allow-indentation-change)
    expect(moved, hasLength(168));
    expect(files.fold(0, (n, f) => n + f.realAdditions + f.realDeletions), 211 - 168);
  });

  test('keeps the wrapper line itself as a real change', () {
    final lines = files[0].hunks[0].lines;
    expect(lines.firstWhere((l) => l.type == lineAdd && l.content.contains('body: SafeArea(')).moved, isFalse);
    expect(lines.firstWhere((l) => l.type == lineAdd && l.content.contains('loading: () =>')).moved, isTrue);
  });

  test('does not tag these files moved-only because real lines remain', () {
    for (final f in files) {
      expect(classifyFile(f), isNot(contains('moved-only')));
    }
  });

  test('strips the colour codes back to the plain diff', () {
    expect(parseUnifiedDiff(stripAnsi(fixture('safearea.colored.diff'))).fold(0, (n, f) => n + f.additions), 107);
  });
}
