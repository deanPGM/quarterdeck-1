// What the Architecture and UI pages share: the title with its run button,
// the rules with the docs they come from, and the card a list sits in.
import 'package:flutter/material.dart';

import '../../core/map/models.dart' show violationSeverities;
import '../../state/session_run.dart';
import '../severity.dart';
import '../parts.dart';
import '../theme.dart';

/// The page title, a line under it, and Draw, Update or Stop.
class MapPageHead extends StatelessWidget {
  const MapPageHead({
    super.key,
    required this.run,
    required this.title,
    required this.subtitle,
    required this.drawn,
    required this.icon,
    required this.onDraw,
    required this.onStop,
  });

  final SessionRun? run;
  final String title, subtitle;
  final bool drawn;
  final IconData icon;
  final VoidCallback onDraw, onStop;

  @override
  Widget build(BuildContext context) {
    final running = run?.running ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHead(
          title: title,
          subtitle: subtitle,
          trailing: running
              ? OutlinedButton.icon(onPressed: onStop, icon: const Icon(Icons.stop_rounded, size: 16), label: const Text('Stop'))
              : FilledButton.icon(
                  onPressed: onDraw,
                  icon: Icon(drawn ? Icons.update_rounded : icon, size: 16),
                  label: Text('${drawn ? 'Update' : 'Draw'} $title'),
                ),
        ),
        if (run != null && (running || !drawn)) ...[const SizedBox(height: 10), Text('Claude: ${run!.step}', style: context.t.bodySmall)],
      ],
    );
  }
}

/// A summary, the rules in plain words, and the docs they come from.
class MapRules extends StatelessWidget {
  const MapRules({super.key, required this.summary, required this.rules, required this.sources, required this.open});

  final String summary;
  final List<String> rules, sources;
  final void Function(String path, int? line) open;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (summary.isNotEmpty) ...[
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Text(summary, style: context.t.bodyMedium),
        ),
      ],
      if (rules.isNotEmpty) ...[
        const SizedBox(height: 10),
        for (final r in rules)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3, right: 6),
                  child: Icon(Icons.rule_rounded, size: 14, color: context.c.label2),
                ),
                Expanded(
                  child: Text(r, style: context.t.bodySmall?.copyWith(color: context.c.label)),
                ),
              ],
            ),
          ),
      ],
      if (sources.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('From', style: context.t.bodySmall),
            for (final s in sources) CodeChip(label: s, onTap: () => open(s, null)),
          ],
        ),
      ],
    ],
  );
}

/// A rounded card with a small caps [label], an optional [action], and a list.
class MapCard extends StatelessWidget {
  const MapCard({super.key, required this.label, this.action, required this.children});

  final String label;
  final Widget? action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ContentCard(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: SectionLabel(label)),
            ?action,
          ],
        ),
        ...children,
      ],
    ),
  );
}

/// A file path that opens in the IDE.
class CodeChip extends StatelessWidget {
  const CodeChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.c.fill,
    borderRadius: BorderRadius.circular(6),
    child: InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(label, style: mono(context.t.bodySmall!.copyWith(fontSize: 11.5, color: context.c.label2))),
      ),
    ),
  );
}

/// [items] grouped by severity, worst first, each group under a colored
/// `High · 3` header.
List<Widget> bySeverity<T>(BuildContext context, List<T> items, String Function(T) severity, Widget Function(T) row) => [
  for (final s in violationSeverities)
    if (items.where((i) => severity(i) == s).toList() case final group when group.isNotEmpty) ...[
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 2),
        child: Text(
          '${s[0].toUpperCase()}${s.substring(1)} · ${group.length}',
          style: context.t.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: findingColor(context.c, s)),
        ),
      ),
      for (final i in group) row(i),
    ],
];

/// One finding: a severity icon, what (code), a tag, a line of code under it,
/// why it matters, the fix and where it is. A tap runs [onTap].
class FindingRow extends StatelessWidget {
  const FindingRow({
    super.key,
    required this.severity,
    required this.title,
    this.code = true,
    this.tag,
    this.detail,
    required this.why,
    this.fix = '',
    this.path,
    this.line,
    required this.open,
    this.onTap,
    this.children = const [],
  });

  final String severity, title, why, fix;
  final bool code;
  final String? tag, detail, path;
  final int? line;
  final void Function(String path, int? line) open;
  final VoidCallback? onTap;

  /// Shown under the fix, like the copies of a duplicate.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Icon(severity == 'accepted' ? Icons.info_outline_rounded : Icons.warning_amber_rounded, size: 14, color: findingColor(c, severity)),
                  Text(
                    title,
                    style: code
                        ? mono(context.t.bodySmall!.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, color: c.label))
                        : context.t.bodyMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  if (tag != null) Text(tag!, style: context.t.bodySmall),
                ],
              ),
              if (detail != null) Text(detail!, style: mono(context.t.bodySmall!.copyWith(fontSize: 11.5, color: c.label2))),
              const SizedBox(height: 2),
              Text(why, style: context.t.bodyMedium?.copyWith(fontSize: 12.5)),
              if (fix.isNotEmpty) Text('Fix: $fix', style: context.t.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              if (path != null)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: CodeChip(label: line == null ? path! : '$path:$line', onTap: () => open(path!, line)),
                ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
