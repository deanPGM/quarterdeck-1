// The app's architecture: its layers top to bottom with how their classes are
// named, the dependencies allowed between them, the rules, and beside them
// every place the code does not follow. A class name says where it belongs;
// the list says where it does not behave like it.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/map/models.dart';
import '../../core/models/config.dart';
import '../../state/project_map.dart' show MapPart, projectMapsProvider;
import '../../state/session_run.dart';
import '../map/architecture_graph.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';
import 'map_parts.dart';

class ArchitecturePage extends ConsumerStatefulWidget {
  const ArchitecturePage({super.key, required this.project, required this.map, this.run});

  final ProjectConfig project;
  final FeatureMap map;
  final SessionRun? run;

  @override
  ConsumerState<ArchitecturePage> createState() => _ArchitecturePageState();
}

class _ArchitecturePageState extends ConsumerState<ArchitecturePage> {
  /// A class picked in the graph or the list: its arrows and its violations only.
  String? _class;

  late final OpenCode _open = codeOpener(ref, widget.project.id);

  void _pick(String? name) => setState(() => _class = _class == name ? null : name);

  @override
  Widget build(BuildContext context) {
    final a = widget.map.architecture;
    final head = MapPageHead(
      run: widget.run,
      onDraw: () => ref.read(projectMapsProvider.notifier).draw(widget.project.id, part: MapPart.architecture),
      onStop: () => ref.read(projectMapsProvider.notifier).stop(widget.project.id),
      title: 'Architecture',
      icon: Icons.account_tree_outlined,
      drawn: a != null,
      subtitle: a == null
          ? 'Not drawn yet. Claude reads the project\'s architecture docs and the code, then lists the layers and where the code breaks them.'
          : '${a.layers.length} layers · ${a.violations.where((v) => v.severity != 'accepted').length} violations${widget.map.staleArchitecture ? ' · code changed since' : ''}',
    );
    if (a == null) {
      return ListView(padding: pagePadding, children: [head]);
    }
    final c = context.c;
    final shown = [
      for (final v in a.violations)
        if (_class == null || v.from == _class || v.to.contains(_class)) v,
    ];
    final byId = {for (final l in a.layers) l.id: l.name};
    final skips = [
      for (final f in a.flows)
        if ((a.layers.indexWhere((l) => l.id == f.to) - a.layers.indexWhere((l) => l.id == f.from)).abs() != 1) f,
    ];
    final graph = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArchitectureGraph(arch: a, picked: _class, colors: [c.teal, c.blue, c.red, c.orange, c.graphite, c.purple, c.indigo, c.green], onPick: _pick),
        const SizedBox(height: 8),
        Text(
          _class == null ? 'Click a class to see what it reaches past the rules.' : 'Click the picture or Show all to see every layer again.',
          style: context.t.bodySmall,
        ),
        if (skips.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text('Also allowed', style: context.t.labelSmall),
          for (final f in skips) Text('${byId[f.from] ?? f.from} → ${byId[f.to] ?? f.to}${f.label.isEmpty ? '' : ': ${f.label}'}', style: context.t.bodySmall),
        ],
      ],
    );
    final side = _Violations(arch: a, shown: shown, picked: _class, onPick: _pick, onClear: () => _pick(null), open: _open);
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth > 1000;
        final top = Padding(
          padding: pagePadding.copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              head,
              MapRules(summary: a.summary, rules: a.rules, sources: a.sources, open: _open),
              const SizedBox(height: 18),
            ],
          ),
        );
        if (!wide) {
          return ListView(
            children: [
              top,
              Padding(padding: const EdgeInsets.symmetric(horizontal: 28), child: graph),
              Padding(padding: const EdgeInsets.fromLTRB(28, 18, 28, 28), child: side),
            ],
          );
        }
        return ListView(
          children: [
            top,
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: graph),
                  const SizedBox(width: 18),
                  SizedBox(width: 400, child: side),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Every place the code breaks a rule, worst first, or those of the picked
/// class. A click on one picks its class.
class _Violations extends StatelessWidget {
  const _Violations({required this.arch, required this.shown, required this.picked, required this.onPick, required this.onClear, required this.open});

  final MapArchitecture arch;
  final List<ArchViolation> shown;
  final String? picked;
  final ValueChanged<String> onPick;
  final VoidCallback onClear;
  final void Function(String path, int? line) open;

  @override
  Widget build(BuildContext context) {
    final byId = {for (final l in arch.layers) l.id: l.name};
    return MapCard(
      label: picked ?? 'Where the code does not follow',
      action: picked == null ? null : TextButton(onPressed: onClear, child: const Text('Show all')),
      children: [
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(picked == null ? 'No violation found.' : 'This class follows the rules.', style: context.t.bodySmall),
          ),
        ...bySeverity(
          context,
          shown,
          (v) => v.severity,
          (v) => FindingRow(
            severity: v.severity,
            title: v.from,
            tag: '${byId[v.fromLayer] ?? v.fromLayer} → ${byId[v.toLayer] ?? v.toLayer}',
            detail: v.to.isEmpty ? null : 'reaches ${v.to.join(', ')}',
            why: v.why,
            fix: v.fix,
            path: v.path,
            line: v.line,
            open: open,
            onTap: picked == v.from ? null : () => onPick(v.from),
          ),
        ),
      ],
    );
  }
}
