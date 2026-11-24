// Port of Skim's packages/core/tests/parse.test.ts.
import 'dart:io';

import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/parse.dart';
import 'package:flutter_test/flutter_test.dart';

String fixture(String name) => File('test/core/review/fixtures/$name').readAsStringSync();

void main() {
  group('parseUnifiedDiff', () {
    final files = parseUnifiedDiff(fixture('safearea.diff'));

    test('finds both files with their paths', () {
      expect(files.map((f) => f.path), ['lib/src/features/framing/framing_screen.dart', 'lib/src/features/settings/parental_settings_screen.dart']);
      expect(files.every((f) => f.status == 'modified'), isTrue);
    });

    test('counts additions and deletions like git --stat', () {
      // git show --stat: 107 insertions(+), 104 deletions(-)
      expect(files.fold(0, (n, f) => n + f.additions), 107);
      expect(files.fold(0, (n, f) => n + f.deletions), 104);
    });

    test('numbers lines from the hunk header', () {
      final hunk = files[0].hunks[0];
      expect(hunk.oldStart, 75);
      expect(hunk.newStart, 75);
      expect(hunk.header, startsWith('@@ -75,35 +75,38 @@'));
      final firstAdd = hunk.lines.firstWhere((l) => l.type == lineAdd);
      expect(firstAdd.newLine, 78);
      expect(firstAdd.content, contains('body: SafeArea('));
    });

    test('gives hunks a stable ref that ignores line numbers and whitespace', () {
      final a = hunkRef('x.dart', [DiffLine(type: lineAdd, content: '  foo(  bar )', newLine: 1)]);
      final b = hunkRef('x.dart', [DiffLine(type: lineAdd, content: 'foo( bar )', newLine: 900)]);
      final c = hunkRef('y.dart', [DiffLine(type: lineAdd, content: 'foo( bar )', newLine: 1)]);
      expect(a, b);
      expect(a, isNot(c));
      expect(a, matches(RegExp(r'^[0-9a-f]{12}$')));
    });

    test('parses added, deleted and renamed headers', () {
      final text = [
        'diff --git a/new.txt b/new.txt',
        'new file mode 100644',
        'index 0000000..e69de29',
        '--- /dev/null',
        '+++ b/new.txt',
        '@@ -0,0 +1 @@',
        '+hello',
        'diff --git a/old.txt b/old.txt',
        'deleted file mode 100644',
        'index e69de29..0000000',
        '--- a/old.txt',
        '+++ /dev/null',
        '@@ -1 +0,0 @@',
        '-bye',
        'diff --git a/a.txt b/b.txt',
        'similarity index 100%',
        'rename from a.txt',
        'rename to b.txt',
        'diff --git a/img.png b/img.png',
        'index 111..222 100644',
        'Binary files a/img.png and b/img.png differ',
        '',
      ].join('\n');
      final f = parseUnifiedDiff(text);
      expect(f.map((x) => [x.path, x.status]), [
        ['new.txt', 'added'],
        ['old.txt', 'deleted'],
        ['b.txt', 'renamed'],
        ['img.png', 'modified'],
      ]);
      expect(f[3].isBinary, isTrue);
      expect(f[2].hunks, isEmpty);
    });

    test('marks the line before "No newline at end of file"', () {
      final f = parseUnifiedDiff('diff --git a/a b/a\n--- a/a\n+++ b/a\n@@ -1 +1 @@\n-x\n+y\n\\ No newline at end of file\n').single;
      expect(f.hunks.single.lines.last.noNewline, isTrue);
      expect(f.hunks.single.lines.first.noNewline, isFalse);
    });
  });

  group('splitting a long hunk at its declarations', () {
    final file = parseUnifiedDiff(fixture('four-functions.diff')).single;

    test('gives four methods added together four hunks', () {
      expect(file.hunks.map((h) => h.lines[0].content.trim()), [
        'class DnsRepository {',
        'Future<void> resume() async {',
        'Future<void> status() async {',
        'Future<void> refresh() async {',
      ]);
    });

    test('numbers each piece where it really starts', () {
      // Only the first piece holds old lines; the rest are pure additions after line 12.
      final h = file.hunks;
      expect([h[0].oldStart, h[0].oldCount, h[0].newStart, h[0].newCount], [10, 3, 10, 10]);
      for (final x in h.sublist(1, 3)) {
        expect([x.oldStart, x.oldCount, x.newCount], [12, 0, 7]);
      }
      expect(h[3].oldCount, 1);
      expect(h.fold(0, (n, x) => n + x.newCount), 32);
      expect(h[0].header, '@@ -10,3 +10,10 @@ class DnsRepository {');
      expect(h[1].header, '@@ -12,0 +20,7 @@');
    });

    test('gives every piece its own ref, so each takes its own note', () {
      expect(file.hunks.map((h) => h.ref).toSet(), hasLength(4));
    });

    test('keeps every line, in order', () {
      // Same lines, same order as the fixture, only the headers moved.
      final body = fixture('four-functions.diff').split('\n').where((l) => RegExp(r'^[+\- ]').hasMatch(l) && !l.startsWith('+++') && !l.startsWith('---'));
      expect(file.hunks.expand((h) => h.lines).map((l) => l.content), body.map((l) => l.substring(1)));
      expect(file.hunks.expand((h) => h.lines), hasLength(32));
    });

    test('leaves a short hunk alone', () {
      final short = parseUnifiedDiff('diff --git a/a.txt b/a.txt\n--- a/a.txt\n+++ b/a.txt\n@@ -1,3 +1,5 @@\n one\n+\n+two\n three\n four\n').single;
      expect(short.hunks, hasLength(1));
      expect(short.hunks.single.header, '@@ -1,3 +1,5 @@');
    });
  });
}
