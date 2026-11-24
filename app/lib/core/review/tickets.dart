// Port of the derived half of Skim's packages/core/src/tickets.ts: which
// tickets a change names, and where they point. The stored text and the
// agent's checks are not here.
import 'skim_config.dart';

/// An issue number. Named on its own because the default drops it on GitHub, see [ticketRefsFor].
final issueNumberPattern = RegExp(r'(?<![\w#])#\d+\b');

/// What a ticket reference looks like when `.skim.yml` does not say: a Jira
/// style key (`APP-231`) or a GitLab / GitHub issue number (`#42`).
final defaultTicketPatterns = [RegExp(r'\b[A-Z][A-Z0-9]+-\d+\b'), issueNumberPattern];

/// Jira looking tokens that are never a ticket. A repository that hits another one narrows `ticket.pattern`.
final _notATicket = RegExp(r'^(SHA|MD|UTF|ISO|RFC|AES|RSA|IEEE)-');

class TicketRef {
  const TicketRef(this.ref, this.url);

  final String ref;
  final String? url;

  Map<String, Object?> toJson() => {'ref': ref, 'url': url};
}

/// Every reference found in the texts (branch name, MR title and description,
/// commit messages), first seen first, no repeats.
List<String> findTicketRefs(List<String> sources, [List<RegExp>? patterns]) {
  final refs = <String>[];
  for (final text in sources) {
    // Sorted by where each matched: the order the reader sees, not the order of the patterns.
    final found = [
      for (final pattern in patterns ?? defaultTicketPatterns)
        for (final m in pattern.allMatches(text))
          if (!_notATicket.hasMatch(m[0]!)) (at: m.start, ref: m[0]!),
    ]..sort((a, b) => a.at.compareTo(b.at));
    for (final f in found) {
      if (!refs.contains(f.ref)) refs.add(f.ref);
    }
  }
  return refs;
}

/// Where the reference points. `ticket.url` of `.skim.yml` wins, every `{id}`
/// being the reference without a leading `#`. Without it, `#42` on a merge or
/// pull request is that project's issue; anything else has no link. [webUrl]
/// is the request's web url, [provider] gitlab or github, [projectPath]
/// `group/project`.
String? ticketUrl(String ref, SkimConfig config, {String? provider, String? webUrl, String? projectPath}) {
  final id = ref.startsWith('#') ? ref.substring(1) : ref;
  final template = config.ticketUrl;
  if (template != null) return template.replaceAll('{id}', Uri.encodeComponent(id));
  // Both forges put the issue under the project, only the path differs.
  if (ref.startsWith('#') && webUrl != null && projectPath != null) {
    return '${Uri.parse(webUrl).origin}/$projectPath/${provider == 'gitlab' ? '-/issues' : 'issues'}/$id';
  }
  return null;
}

/// The references with their links. On a pull request the issue number is not
/// part of the default: GitHub writes `(#1234)` into every squashed merge
/// subject, so `#\d+` would find the merges of base..head rather than the
/// tickets. `ticket.pattern` of `.skim.yml` is always taken as written.
List<TicketRef> ticketRefsFor(List<String> sources, SkimConfig config, {String? provider, String? webUrl, String? projectPath}) {
  final pattern = config.ticketPattern;
  final patterns = pattern != null
      ? [pattern]
      : [
          for (final p in defaultTicketPatterns)
            if (!identical(p, issueNumberPattern) || provider != 'github') p,
        ];
  return [
    for (final ref in findTicketRefs(sources, patterns)) TicketRef(ref, ticketUrl(ref, config, provider: provider, webUrl: webUrl, projectPath: projectPath)),
  ];
}
