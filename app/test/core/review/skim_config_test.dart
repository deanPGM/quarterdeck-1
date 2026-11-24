// Port of Skim's packages/core/tests/config.test.ts (loadSkimConfig is in test/data/review_git_test.dart).
import 'package:deck/core/review/classify.dart';
import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/skim_config.dart';
import 'package:flutter_test/flutter_test.dart';

DiffFile file(String path) => DiffFile(
  oldPath: path,
  newPath: path,
  path: path,
  status: 'modified',
  additions: 3,
  deletions: 1,
  hunks: [
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

Matcher refused(String part) => throwsA(isA<SkimConfigError>().having((e) => e.message, 'message', contains(part)));

void expectDefaults(SkimConfig c) {
  expect(c.generated, isEmpty);
  expect(c.tags, isEmpty);
  expect(c.hiddenByDefault, hiddenByDefault);
  expect(c.ticketPattern, isNull);
  expect(c.ticketUrl, isNull);
}

void main() {
  group('parseConfig', () {
    test('parses every key', () {
      final c = parseConfig('''
generated:
  - "lib/gen/**"
  - "*.pb.dart"
tags:
  "assets/translations/*.json": [docs]
  "tool/**": [ci, test]
hidden_by_default: [generated]
''');
      expect(c.generated, ['lib/gen/**', '*.pb.dart']);
      expect(c.tags, {
        'assets/translations/*.json': ['docs'],
        'tool/**': ['ci', 'test'],
      });
      expect(c.hiddenByDefault, ['generated']);
    });

    test('falls back to defaults for an empty file or missing keys', () {
      expectDefaults(parseConfig(''));
      expect(parseConfig('generated: ["a/**"]').hiddenByDefault, hiddenByDefault);
      expect(parseConfig('hidden_by_default: []').hiddenByDefault, isEmpty);
    });

    test('rejects invalid YAML with the file name and the parser message', () {
      expect(() => parseConfig('tags: [a, b'), throwsA(isA<SkimConfigError>()));
      expect(() => parseConfig('tags: [a, b'), throwsA(isA<SkimConfigError>().having((e) => e.message, 'message', startsWith('.skim.yml: invalid YAML, '))));
    });

    test('rejects wrong shapes and unknown tags', () {
      expect(() => parseConfig('- a\n- b'), refused('top level must be a mapping'));
      expect(() => parseConfig('ignore: ["x"]'), refused('unknown key "ignore"'));
      expect(() => parseConfig('generated: "lib/gen/**"'), refused('generated must be a list of strings'));
      expect(() => parseConfig('tags: ["a"]'), refused('tags must be a mapping'));
      expect(() => parseConfig('tags:\n  "a/**": docs'), refused('tags["a/**"] must be a list of strings'));
      expect(() => parseConfig('tags:\n  "a/**": [noise]'), refused('unknown tag "noise"'));
      expect(() => parseConfig('hidden_by_default: [huge]'), refused('hidden_by_default: unknown tag "huge"'));
      expect(() => parseConfig('generated: [""]'), refused('generated: empty glob'));
    });

    test('parses and validates the ticket key', () {
      final c = parseConfig('ticket:\n  pattern: "APP-\\\\d+"\n  url: "https://jira.example.com/browse/{id}"');
      expect(c.ticketPattern?.pattern, r'APP-\d+');
      expect(c.ticketUrl, 'https://jira.example.com/browse/{id}');
      expect(parseConfig('ticket:\n  url: "https://x/{id}"').ticketPattern, isNull);
      expect(() => parseConfig('ticket: "APP-1"'), refused('ticket must be a mapping'));
      expect(() => parseConfig('ticket:\n  host: x'), refused('ticket: unknown key "host"'));
      expect(
        () => parseConfig('ticket:\n  pattern: "("'),
        throwsA(isA<SkimConfigError>().having((e) => e.message, 'message', startsWith('.skim.yml: ticket.pattern: '))),
      );
      expect(() => parseConfig('ticket:\n  url: "https://x/"'), refused('ticket.url must be a string containing {id}'));
    });

    test('refuses fetchers, which are shell commands and this file is committed', () {
      expect(() => parseConfig('tickets:\n  "#*": glab issue view {id}'), refused('tickets: is not read from a committed file'));
    });
  });

  group('classifyContextFor', () {
    final ctx = classifyContextFor(
      parseConfig('''
generated: ["lib/gen/**", "**/*.pb.dart", ".dart_tool_extra/*"]
tags:
  "assets/translations/*.json": [docs]
  "tool/**": [ci]
'''),
    );

    test('matches globs against the repo relative path', () {
      expect(classifyFile(file('lib/gen/schema.dart'), ctx), contains('generated'));
      expect(classifyFile(file('lib/gen/deep/er/schema.dart'), ctx), contains('generated'));
      expect(classifyFile(file('lib/src/api.pb.dart'), ctx), contains('generated'));
      expect(classifyFile(file('api.pb.dart'), ctx), contains('generated'));
      expect(classifyFile(file('.dart_tool_extra/x.dart'), ctx), contains('generated'));
      expect(classifyFile(file('lib/generic/schema.dart'), ctx), isNot(contains('generated')));
      expect(classifyFile(file('lib/gen.dart'), ctx), isNot(contains('generated')));
    });

    test('adds tags from rules on top of the built in ones', () {
      expect(classifyFile(file('assets/translations/fr.json'), ctx), ['docs']);
      expect(classifyFile(file('assets/translations/nested/fr.json'), ctx), isEmpty);
      expect(classifyFile(file('tool/build.md'), ctx), containsAll(['docs', 'ci']));
    });

    test('matches dot files and folders like picomatch with dot: true', () {
      final dots = classifyContextFor(parseConfig('generated: ["gen/**", "*.cfg"]'));
      expect(classifyFile(file('gen/.hidden/x.dart'), dots), contains('generated'));
      expect(classifyFile(file('.env.cfg'), dots), contains('generated'));
    });

    test('is empty for the default config', () {
      final empty = classifyContextFor(parseConfig(''));
      expect(empty.extraGenerated, isEmpty);
      expect(empty.extraTags, isEmpty);
    });
  });
}
