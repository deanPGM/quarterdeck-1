// Port of Skim's unified.test.ts, plus the split pairing and the word edits.
import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/unified.dart';
import 'package:flutter_test/flutter_test.dart';

DiffLine del(int n, String content, {bool moved = false}) => DiffLine(type: lineDelete, content: content, oldLine: n, moved: moved);
DiffLine ins(int n, String content, {bool moved = false}) => DiffLine(type: lineAdd, content: content, newLine: n, moved: moved);
DiffLine ctx(int n, String content) => DiffLine(type: lineContext, content: content, oldLine: n, newLine: n);

/// One letter per row: D, I, or N for context and collapsed rows.
String shape(List<UnifiedRow> rows) => rows
    .map(
      (r) => switch (r.kind) {
        RowKind.delete => 'D',
        RowKind.add => 'I',
        _ => 'N',
      },
    )
    .join();

String marked(String s, List<(int, int)> ranges) => ranges.map((r) => s.substring(r.$1, r.$2)).join('|');

void main() {
  group('regroupUnified', () {
    test('keeps unrelated removals and additions apart', () {
      final rows = regroupUnified([
        del(10, 'const cache = new Map();'),
        del(11, 'let hits = 0;'),
        del(12, 'let misses = 0;'),
        ins(10, 'export type Level = "off" | "warn";'),
        ins(11, 'import { readFile } from "node:fs/promises";'),
        ins(12, 'await start({ port, host });'),
      ]);
      expect(shape(rows), 'DDDIII');
    });

    test('keeps a pair adjacent when the line was rewritten around a shared skeleton', () {
      final rows = regroupUnified([
        del(4, '  const result = fetchAll(client, { retries: 3 });'),
        del(5, '  const total = countRows(result, options);'),
        ins(4, '  const result = fetchAll(client, { retries: 5, timeout: 100 });'),
        ins(5, '  const total = countRows(await result.all(), options);'),
      ]);
      expect(shape(rows), 'DIDI');
    });

    test('collapses a typo onto one row that remembers the old line', () {
      final rows = regroupUnified([del(7, '  return user.recieve(id);'), ins(7, '  return user.receive(id);')]);
      expect(rows, hasLength(1));
      expect(rows.single.kind, RowKind.tweak);
      expect(rows.single.line.content, '  return user.receive(id);');
      expect(rows.single.was!.content, '  return user.recieve(id);');
      expect((rows.single.oldLine, rows.single.newLine), (7, 7));
    });

    test('leaves a whole rewritten line as two rows', () {
      final rows = regroupUnified([del(3, 'let a = 1;'), ins(3, 'throw new Error("nope");')]);
      expect(shape(rows), 'DI');
      expect(rows.any((r) => r.kind == RowKind.tweak), isFalse);
    });

    test('does not collapse a moved line onto itself', () {
      expect(shape(regroupUnified([del(3, '  logger.info("up");'), ins(9, '  logger.info("up");')])), 'DI');
    });

    test('never pairs a line git marked as moved', () {
      expect(shape(regroupUnified([del(3, '  logger.info("up");', moved: true), ins(3, '  logger.info("down");')])), 'DI');
    });

    test('flushes the unpaired rows before an edit pair, keeping context lines in place', () {
      final rows = regroupUnified([
        ctx(1, 'function run() {'),
        del(2, 'const legacy = buildTheOldWay();'),
        del(3, '  if (a) { return 1; }'),
        ins(2, 'await sleep(25);'),
        ins(3, '  if (b) { return 1; }'),
        ctx(4, '}'),
      ]);
      expect(shape(rows), 'NDINN');
    });

    test('leaves a delete only block alone', () {
      expect(shape(regroupUnified([del(2, 'a'), del(3, 'b'), del(4, 'c')])), 'DDD');
    });

    test('sends the extra additions after the paired rows', () {
      expect(shape(regroupUnified([del(2, '  if (a) { return 1; }'), ins(2, '  if (b) { return 1; }'), ins(3, '  flush();'), ins(4, '  done();')])), 'NII');
    });

    test('collapses a re-indent onto one row', () {
      final rows = regroupUnified([del(5, '    child: Text(name),'), ins(6, '      child: Text(name),')]);
      expect(rows.single.kind, RowKind.tweak);
    });
  });

  group('pairSplit', () {
    test('zips deletes and adds side by side, context on both sides', () {
      final rows = pairSplit([ctx(1, 'a'), del(2, 'let x = 1;'), del(3, 'gone'), ins(2, 'let x = 2;'), ctx(4, 'b')]);
      expect(rows.map((r) => '${r.old?.content ?? '-'}/${r.neu?.content ?? '-'}'), ['a/a', 'let x = 1;/let x = 2;', 'gone/-', 'b/b']);
      expect(rows[1].similar, isTrue);
      expect(rows[2].similar, isFalse);
    });

    test('marks unrelated neighbours as not similar', () {
      expect(pairSplit([del(1, 'let a = 1;'), ins(1, 'throw new Error("nope");')]).single.similar, isFalse);
    });
  });

  group('lineEdits', () {
    test('marks the changed word on each side', () {
      final e = lineEdits('  return user.recieve(id);', '  return user.receive(id);');
      expect(marked('  return user.recieve(id);', e.old), 'recieve');
      expect(marked('  return user.receive(id);', e.neu), 'receive');
    });

    test('marks every changed stretch, merged when they touch', () {
      const a = 'fetchAll(client, { retries: 3 });', b = 'fetchAll(client, { retries: 5, timeout: 100 });';
      final e = lineEdits(a, b);
      expect(marked(a, e.old), '3');
      expect(marked(b, e.neu), '5, timeout: 100');
    });

    test('ignores a change of indentation alone', () {
      final e = lineEdits('    child: Text(name),', '      child: Text(name),');
      expect(e.old, isEmpty);
      expect(e.neu, isEmpty);
    });
  });
}
