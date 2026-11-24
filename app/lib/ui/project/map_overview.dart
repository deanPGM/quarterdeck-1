// The map of a project at a glance: how fresh it is, the button that draws
// or updates it, what the running session is doing, and one card per feature.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/classify/time.dart';
import '../../core/map/models.dart';
import '../../core/models/config.dart';
import '../../state/project_map.dart';
import '../../state/session_run.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';
import 'project_screen.dart';

class MapOverview extends ConsumerWidget {
  const MapOverview({super.key, required this.project, required this.map, this.run});

  final ProjectConfig project;
  final FeatureMap map;
  final SessionRun? run;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    final running = run?.running ?? false;
    final fresh = map.commit != null && map.commit == map.head && map.staleFeatures.isEmpty && map.staleData.isEmpty;
    final changes = [
      if (map.commitMissing) 'the stamped commit is gone, every feature needs a look',
      if (map.staleFeatures.isNotEmpty) '${map.staleFeatures.length} ${map.staleFeatures.length == 1 ? 'feature' : 'features'} changed',
      if (map.staleData.isNotEmpty) '${map.staleData.length} data ${map.staleData.length == 1 ? 'type' : 'types'} changed',
      if (map.uncoveredFiles.isNotEmpty) '${map.uncoveredFiles.length} changed ${map.uncoveredFiles.length == 1 ? 'file' : 'files'} in no feature',
      if (map.brokenLinks.isNotEmpty) '${map.brokenLinks.length} broken ${map.brokenLinks.length == 1 ? 'link' : 'links'}',
    ];
    final String subtitle;
    if (map.features.isEmpty) {
      subtitle = 'Not drawn yet. Claude reads the code and draws every feature: its classes, flows and states.';
    } else if (map.commit == null) {
      subtitle = '${map.features.length} features, first pass not finished';
    } else {
      subtitle = '${map.features.length} features · drawn at ${map.commit!.substring(0, 7)}${map.updatedAt == null ? '' : ' on ${_day(map.updatedAt!)}'}';
    }
    return ListView(
      padding: pagePadding,
      children: [
        PageHead(
          title: 'Features',
          subtitle: subtitle,
          trailing: running
              ? OutlinedButton.icon(
                  onPressed: () => ref.read(projectMapsProvider.notifier).stop(project.id),
                  icon: const Icon(Icons.stop_rounded, size: 16),
                  label: const Text('Stop'),
                )
              : FilledButton.icon(
                  onPressed: fresh && map.features.isNotEmpty && map.planLeft.isEmpty
                      ? null
                      : () async {
                          // The first pass reads everything: say so before it starts.
                          if (map.features.isEmpty && map.plan.isEmpty && !await _confirmFirst(context)) return;
                          await ref.read(projectMapsProvider.notifier).draw(project.id);
                        },
                  icon: Icon(
                    map.features.isEmpty ? Icons.draw_outlined : (map.planLeft.isNotEmpty ? Icons.play_arrow_rounded : Icons.update_rounded),
                    size: 16,
                  ),
                  label: Text(
                    map.planLeft.isNotEmpty
                        ? 'Resume Map'
                        : map.features.isEmpty
                        ? 'Draw Map'
                        : (map.commit == null ? 'Finish Map' : 'Update Map'),
                  ),
                ),
        ),
        if (map.planLeft.isNotEmpty && !running) ...[
          const SizedBox(height: 12),
          InfoBanner(
            icon: Icons.pause_circle_outline_rounded,
            color: c.indigo,
            text: 'The last pass stopped with ${map.planLeft.length} of ${map.plan.length} features left to draw. Resume Map carries on from there.',
          ),
        ],
        if (changes.isNotEmpty && map.commit != null) ...[
          const SizedBox(height: 12),
          InfoBanner(icon: Icons.history_toggle_off_rounded, color: c.orange, text: 'Since the map was drawn: ${changes.join(', ')}.'),
        ],
        if (run != null) ...[const SizedBox(height: 12), _RunLine(run: run!)],
        const SizedBox(height: 20),
        if (map.features.isNotEmpty) _FeatureGrid(project: project, map: map),
      ],
    );
  }
}

Future<bool> _confirmFirst(BuildContext context) => confirm(
  context,
  title: 'Draw the map?',
  text:
      'Claude reads the whole project and draws every feature, with the model set for code in Settings. '
      'On a big app this takes from 30 minutes to over an hour, and uses a good amount of tokens.\n\n'
      'You can keep using Deck meanwhile. The map fills in as each feature is drawn. You can stop at any '
      'time and resume later from where it was.',
  action: 'Draw Map',
);

String _day(String iso) {
  final d = DateTime.tryParse(iso)?.toLocal();
  if (d == null) return iso;
  return shortDate(d);
}

class _RunLine extends StatelessWidget {
  const _RunLine({required this.run});

  final SessionRun run;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final r = run.result;
    if (r == null) {
      return InfoBanner(
        icon: Icons.auto_awesome_outlined,
        color: c.blue,
        text: [run.progress('features', DateTime.now()), 'Claude is drawing the map: ${run.step}'].whereType<String>().join(' · '),
        trailing: const SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final took = r.seconds < 60 ? '${r.seconds} s' : '${(r.seconds / 60).round()} min';
    final cost = '\$${r.costUsd.toStringAsFixed(2)}';
    return r.error == null
        ? InfoBanner(icon: Icons.check_circle_outline_rounded, color: c.green, text: 'Map drawn in $took for $cost.')
        : InfoBanner(icon: Icons.error_outline_rounded, color: c.red, text: 'The map run stopped after $took ($cost): ${r.error}');
  }
}

/// The feature cards, with a search over what each feature is made of.
class _FeatureGrid extends StatefulWidget {
  const _FeatureGrid({required this.project, required this.map});

  final ProjectConfig project;
  final FeatureMap map;

  @override
  State<_FeatureGrid> createState() => _FeatureGridState();
}

class _FeatureGridState extends State<_FeatureGrid> {
  var _query = '';

  /// Title, summary, id, paths, classes and data types: what someone looking
  /// for "where is the token refreshed" may type.
  bool _matches(MapFeature f, List<String> words) {
    final text = [
      f.id,
      f.title,
      f.summary,
      ...f.paths,
      ...?f.graph?.nodes.expand((n) => [n.name, n.role]),
      ...f.data.map((d) => d.type),
      ...f.sequences.map((q) => q.title),
      ...f.states.map((q) => q.title),
    ].join(' ').toLowerCase();
    return words.every(text.contains);
  }

  @override
  Widget build(BuildContext context) {
    final map = widget.map;
    final words = _query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final shown = [
      for (final f in map.features)
        if (_matches(f, words)) f,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 280,
              child: TextField(
                onChanged: (q) => setState(() => _query = q),
                decoration: const InputDecoration(hintText: 'Search features, classes, files', prefixIcon: Icon(Icons.search, size: 18)),
              ),
            ),
            const SizedBox(width: 12),
            if (words.isNotEmpty) Text('${shown.length} of ${map.features.length}', style: context.t.bodySmall),
          ],
        ),
        const SizedBox(height: 14),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text('No feature matches "$_query".', style: context.t.bodySmall),
          )
        else
          LayoutBuilder(
            builder: (context, box) {
              final cols = (box.maxWidth / 300).floor().clamp(1, 4);
              final w = (box.maxWidth - (cols - 1) * 12) / cols;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final f in shown)
                    SizedBox(
                      width: w,
                      child: _FeatureCard(
                        feature: f,
                        stale: map.staleFeatures.contains(f.id),
                        onTap: () => goProject(context, widget.project.id, FeaturePlace(f.id)),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature, required this.stale, required this.onTap});

  final MapFeature feature;
  final bool stale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final f = feature;
    final views = [
      if (f.graph != null) '${f.graph!.nodes.length} classes',
      if (f.sequences.isNotEmpty) '${f.sequences.length} ${f.sequences.length == 1 ? 'flow' : 'flows'}',
      if (f.states.isNotEmpty) '${f.states.length} ${f.states.length == 1 ? 'state machine' : 'state machines'}',
    ];
    return ContentCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(f.title, style: context.t.titleMedium, overflow: TextOverflow.ellipsis),
              ),
              if (stale)
                Tooltip(
                  message: 'Changed since it was drawn',
                  child: Icon(Icons.history_toggle_off_rounded, size: 16, color: c.orange),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 54,
            child: Text(f.summary, maxLines: 3, overflow: TextOverflow.ellipsis, style: context.t.bodySmall),
          ),
          const SizedBox(height: 8),
          Text(views.join(' · '), style: context.t.labelSmall),
        ],
      ),
    );
  }
}
