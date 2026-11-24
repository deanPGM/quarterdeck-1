// Port of Skim's packages/core/tests/classify.test.ts.
import 'package:deck/core/review/classify.dart';
import 'package:deck/core/review/diff.dart';
import 'package:flutter_test/flutter_test.dart';

DiffFile file(String path, {String status = 'modified', bool isBinary = false, bool noHunks = false, int additions = 3, int deletions = 1, int? real}) {
  final f = DiffFile(
    oldPath: path,
    newPath: path,
    path: path,
    status: status,
    isBinary: isBinary,
    additions: additions,
    deletions: deletions,
    hunks: noHunks
        ? []
        : [
            Hunk(
              header: '@@',
              oldStart: 1,
              oldCount: 1,
              newStart: 1,
              newCount: 1,
              ref: 'r',
              lines: [DiffLine(type: lineAdd, content: 'x', newLine: 1)],
            ),
          ],
  );
  if (real != null) f.realAdditions = f.realDeletions = real;
  return f;
}

void main() {
  test('tags Flutter codegen and lock files', () {
    expect(classifyFile(file('lib/models/track.freezed.dart')), contains('generated'));
    expect(classifyFile(file('lib/models/track.g.dart')), contains('generated'));
    expect(classifyFile(file('shared/src/commonMain/kotlin/Api.g.kt')), contains('generated'));
    expect(classifyFile(file('lib/l10n/app_localizations_en.dart')), contains('generated'));
    expect(classifyFile(file('pubspec.lock')), contains('lockfile'));
    expect(classifyFile(file('ios/Podfile.lock')), contains('lockfile'));
    expect(classifyFile(file('lib/ui/track_row.dart')), isEmpty);
  });

  test('honours .gitattributes generated markers', () {
    expect(classifyFile(file('schema/api.json'), const ClassifyContext(generatedByAttributes: {'schema/api.json'})), contains('generated'));
  });

  test('tags a file whose first added line says it is generated', () {
    final f = DiffFile(
      oldPath: 'a.dart',
      newPath: 'a.dart',
      path: 'a.dart',
      status: 'added',
      additions: 1,
      deletions: 0,
      hunks: [
        Hunk(
          header: '@@',
          oldStart: 0,
          oldCount: 0,
          newStart: 1,
          newCount: 1,
          lines: [DiffLine(type: lineAdd, content: '// GENERATED CODE - DO NOT MODIFY', newLine: 1)],
        ),
      ],
    );
    expect(classifyFile(f), contains('generated'));
  });

  test('applies .skim.yml generated globs and tag rules', () {
    final ctx = ClassifyContext(
      extraGenerated: [RegExp(r'^lib/gen/').hasMatch],
      extraTags: [
        (match: (String p) => p.startsWith('assets/translations/'), tags: ['docs']),
      ],
    );
    expect(classifyFile(file('lib/gen/schema.dart'), ctx), contains('generated'));
    expect(classifyFile(file('assets/translations/fr.json'), ctx), ['docs']);
    expect(classifyFile(file('lib/ui/track_row.dart'), ctx), isEmpty);
  });

  test('tags tests, ci and docs', () {
    expect(classifyFile(file('test/offline_cache_test.dart')), contains('test'));
    expect(classifyFile(file('.gitlab-ci.yml')), contains('ci'));
    expect(classifyFile(file('docs/adr/0001.md')), contains('docs'));
  });

  test('tags moved-only when no real line remains', () {
    expect(classifyFile(file('lib/a.dart', real: 0)), contains('moved-only'));
  });

  test('tags formatting-only from the whitespace insensitive diff', () {
    final all = [file('a.dart'), file('b.dart')];
    final fo = formattingOnlyPaths(all, [file('b.dart')]);
    expect(fo, {'a.dart'});
    expect(classifyFile(all[0], ClassifyContext(formattingOnly: fo)), contains('formatting-only'));
    expect(classifyFile(all[1], ClassifyContext(formattingOnly: fo)), isNot(contains('formatting-only')));
  });

  test('tags rename-only, binary and large', () {
    expect(classifyFile(file('b.dart', status: 'renamed', noHunks: true, additions: 0, deletions: 0)), contains('rename-only'));
    expect(classifyFile(file('a.png', isBinary: true, noHunks: true)), contains('binary'));
    expect(classifyFile(file('a.dart', additions: 1500, deletions: 0)), contains('large'));
  });
}
