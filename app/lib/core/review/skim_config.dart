// Port of Skim's packages/core/src/config.ts: per repository overrides read
// from `<root>/.skim.yml`, same keys and same error messages. Reading the file
// is in data/review_git.dart; this side stays pure.
//
// ```yaml
// generated:                 # extra globs tagged generated
//   - "lib/gen/**"
// tags:                      # glob to tags
//   "assets/translations/*.json": [docs]
// hidden_by_default: [generated, lockfile]   # replaces the built in list
// ticket:                    # how this repository names its tickets
//   pattern: "APP-\\d+"   # replaces the default (Jira keys and #123)
//   url: "https://jira.example.com/browse/{id}"   # {id} is the ref without a leading #
// ```
//
// There is deliberately no `tickets:` key. Fetchers are shell commands and this
// file is committed, so a clone would run whatever it says.
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'classify.dart';
import 'diff.dart' as diff;

const configFile = '.skim.yml';

class SkimConfig {
  SkimConfig({this.generated = const [], this.tags = const {}, List<String>? hiddenByDefault, this.ticketPattern, this.ticketUrl})
    : hiddenByDefault = hiddenByDefault ?? [...diff.hiddenByDefault];

  final List<String> generated;

  /// Glob to the tags it adds.
  final Map<String, List<String>> tags;
  final List<String> hiddenByDefault;

  /// Replaces the default ticket patterns when set.
  final RegExp? ticketPattern;

  /// Link template, `{id}` being the ref without a leading `#`.
  final String? ticketUrl;
}

class SkimConfigError implements Exception {
  SkimConfigError(String message) : message = '$configFile: $message';

  final String message;

  @override
  String toString() => message;
}

/// Parses the text of a `.skim.yml`. Empty gives the defaults, anything wrong throws [SkimConfigError].
SkimConfig parseConfig(String text) {
  Object? doc;
  try {
    doc = loadYaml(text);
  } on YamlException catch (e) {
    // The message carries a multi line excerpt, keep the first line with the position.
    throw SkimConfigError('invalid YAML, ${e.toString().split('\n').first.replaceFirst(RegExp(r':$'), '')}');
  }
  if (doc == null) return SkimConfig();
  if (doc is! Map) throw SkimConfigError('top level must be a mapping');
  for (final key in doc.keys) {
    // Named rather than merely unknown: a repository that has one needs to be told where it moved, and why.
    if (key == 'tickets') {
      throw SkimConfigError('tickets: is not read from a committed file, because a fetcher is a shell command. Move it to ~/.skim/config.yml.');
    }
    if (!const ['generated', 'tags', 'hidden_by_default', 'ticket'].contains(key)) throw SkimConfigError('unknown key "$key"');
  }

  final generated = _stringList(doc['generated'], 'generated');
  for (final g in generated) {
    _assertGlob(g, 'generated');
  }

  final tags = <String, List<String>>{};
  final rawTags = doc['tags'];
  if (rawTags != null) {
    if (rawTags is! Map) throw SkimConfigError('tags must be a mapping of glob to tag list');
    for (final MapEntry(:key, :value) in rawTags.entries) {
      final glob = '$key';
      _assertGlob(glob, 'tags');
      tags[glob] = _tagList(value, 'tags["$glob"]');
    }
  }

  final hidden = doc['hidden_by_default'] == null ? null : _tagList(doc['hidden_by_default'], 'hidden_by_default');
  final (pattern, url) = _ticket(doc['ticket']);
  return SkimConfig(generated: generated, tags: tags, hiddenByDefault: hidden, ticketPattern: pattern, ticketUrl: url);
}

(RegExp?, String?) _ticket(Object? v) {
  if (v == null) return (null, null);
  if (v is! Map) throw SkimConfigError('ticket must be a mapping with pattern and/or url');
  for (final key in v.keys) {
    if (key != 'pattern' && key != 'url') throw SkimConfigError('ticket: unknown key "$key"');
  }
  final url = v['url'], pattern = v['pattern'];
  if (url != null && (url is! String || !url.contains('{id}'))) throw SkimConfigError('ticket.url must be a string containing {id}');
  if (pattern != null && (pattern is! String || pattern.trim().isEmpty)) throw SkimConfigError('ticket.pattern must be a regular expression');
  try {
    return (pattern == null ? null : RegExp(pattern as String), url as String?);
  } on FormatException catch (e) {
    throw SkimConfigError('ticket.pattern: ${e.message}');
  }
}

/// The classifier inputs for a config, globs compiled against repo relative paths.
ClassifyContext classifyContextFor(SkimConfig config, {Set<String> formattingOnly = const {}, Set<String> generatedByAttributes = const {}}) {
  bool Function(String) matcher(String glob) => Glob(glob, context: p.posix).matches;
  return ClassifyContext(
    formattingOnly: formattingOnly,
    generatedByAttributes: generatedByAttributes,
    extraGenerated: [for (final g in config.generated) matcher(g)],
    extraTags: [for (final e in config.tags.entries) (match: matcher(e.key), tags: e.value)],
  );
}

List<String> _stringList(Object? v, String key) {
  if (v == null) return [];
  if (v is! List || !v.every((x) => x is String)) throw SkimConfigError('$key must be a list of strings');
  return v.cast<String>().toList();
}

List<String> _tagList(Object? v, String key) {
  final list = _stringList(v, key);
  for (final t in list) {
    if (!diff.fileTags.contains(t)) throw SkimConfigError('$key: unknown tag "$t", expected one of ${diff.fileTags.join(', ')}');
  }
  return list;
}

void _assertGlob(String glob, String key) {
  if (glob.trim().isEmpty) throw SkimConfigError('$key: empty glob');
  // Checked here so a bad glob is a config error, not a crash in the pipeline.
  try {
    Glob(glob, context: p.posix);
  } on FormatException catch (e) {
    throw SkimConfigError('$key: invalid glob "$glob", ${e.message}');
  }
}
