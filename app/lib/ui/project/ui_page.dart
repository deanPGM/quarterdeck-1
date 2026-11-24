// The app's UI checked against its own UI guidelines: a graph of which screen
// uses which shared piece, then the pieces built twice and the places that
// break the rules on the left, what the UI is built from (tokens, shared
// components) and every screen with what it uses on the right.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/map/models.dart';
import '../../core/models/config.dart';
import '../../state/project_map.dart' show MapPart, projectMapsProvider;
import '../../state/session_run.dart';
import '../map/diagram_paint.dart' show CodeLink, DiagramChip;
import '../map/ui_graph.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';
import 'map_parts.dart';

class UiPage extends ConsumerStatefulWidget {
  const UiPage({super.key, required this.project, required this.map, this.run});

  final ProjectConfig project;
  final FeatureMap map;
  final SessionRun? run;

  @override
  ConsumerState<UiPage> createState() => _UiPageState();
}

class _UiPageState extends ConsumerState<UiPage> {
  /// A box picked in the graph or a component in the list: its lines, and
  /// only the screens that use it.
  String? _component;

  late final OpenCode _open = codeOpener(ref, widget.project.id);

  void _pick(String? name) => setState(() => _component = _component == name ? null : name);

  @override
  Widget build(BuildContext context) {
    final ui = widget.map.ui;
    final head = MapPageHead(
      run: widget.run,
      onDraw: () => ref.read(projectMapsProvider.notifier).draw(widget.project.id, part: MapPart.ui),
      onStop: () => ref.read(projectMapsProvider.notifier).stop(widget.project.id),
      title: 'UI',
      icon: Icons.palette_outlined,
      drawn: ui != null,
      subtitle: ui == null
          ? 'Not drawn yet. Claude reads the project\'s UI guidelines and skills and the code, then lists what is built twice and where the UI breaks the rules.'
          : '${ui.components.length} components · ${ui.screens.length} screens · ${uiIssues(ui)} issues${widget.map.staleUi ? ' · code changed since' : ''}',
    );
    if (ui == null) return ListView(padding: pagePadding, children: [head]);
    final issues = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MapCard(
          label: 'Built twice',
          children: [
            if (ui.duplicates.isEmpty) _empty(context, 'No duplicate found.'),
            ...bySeverity(
              context,
              ui.duplicates,
              (d) => d.severity,
              (d) => FindingRow(
                severity: d.severity,
                title: d.title,
                code: false,
                tag: '${d.copies.length} copies',
                why: d.why,
                fix: d.use.isEmpty ? '' : 'use ${d.use}',
                open: _open,
                children: [
                  for (final copy in d.copies)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(copy.name, style: mono(context.t.bodySmall!.copyWith(fontSize: 11.5, color: context.c.label))),
                          if (copy.path != null) CodeLink(path: copy.path!, line: copy.line, onOpen: _open),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        MapCard(
          label: 'Where the UI does not follow',
          children: [
            if (ui.breaks.isEmpty) _empty(context, 'No break found.'),
            ...bySeverity(
              context,
              ui.breaks,
              (b) => b.severity,
              (b) => FindingRow(
                severity: b.severity,
                title: b.rule,
                code: false,
                tag: b.count > 1 ? '${b.count} places' : null,
                detail: b.where.isEmpty ? null : b.where,
                why: b.why,
                fix: b.fix,
                path: b.path,
                line: b.line,
                open: _open,
              ),
            ),
          ],
        ),
      ],
    );
    final builtFrom = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Components(ui: ui, picked: _component, onPick: _pick, open: _open),
        const SizedBox(height: 18),
        _Screens(ui: ui, picked: _component, onClear: () => setState(() => _component = null), onPick: _pick, open: _open),
      ],
    );
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth > 1000;
        return ListView(
          padding: pagePadding,
          children: [
            head,
            MapRules(summary: ui.summary, rules: ui.rules, sources: ui.sources, open: _open),
            const SizedBox(height: 18),
            UiGraph(ui: ui, picked: _component, onPick: _pick),
            const SizedBox(height: 8),
            Text(
              _component == null
                  ? 'Click a box to see only its lines. Dashed: a copy and the shared piece it should use.'
                  : 'Click the picture or Show all to see every line again.',
              style: context.t.bodySmall,
            ),
            const SizedBox(height: 18),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: issues),
                  const SizedBox(width: 18),
                  Expanded(child: builtFrom),
                ],
              )
            else ...[
              issues,
              const SizedBox(height: 18),
              builtFrom,
            ],
          ],
        );
      },
    );
  }
}

/// The duplicates and breaks that are not agreed exceptions.
int uiIssues(MapUi ui) => [...ui.duplicates.map((d) => d.severity), ...ui.breaks.map((b) => b.severity)].where((s) => s != 'accepted').length;

Widget _empty(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.only(top: 6),
  child: Text(text, style: context.t.bodySmall),
);

/// The tokens by kind, then each shared component with how many screens use
/// it. A click on a component shows only its screens.
class _Components extends StatelessWidget {
  const _Components({required this.ui, required this.picked, required this.onPick, required this.open});

  final MapUi ui;
  final String? picked;
  final ValueChanged<String> onPick;
  final void Function(String path, int? line) open;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return MapCard(
      label: 'Built from',
      children: [
        for (final kind in uiTokenKinds)
          if (ui.tokens.where((t) => t.kind == kind).toList() case final tokens when tokens.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 64, child: Text(kind, style: context.t.bodySmall)),
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (final t in tokens)
                          Tooltip(
                            message: [if (t.note.isNotEmpty) t.note, if (t.path != null) t.line == null ? t.path! : '${t.path}:${t.line}'].join('\n'),
                            child: DiagramChip(t.name, code: true, onTap: t.path == null ? null : () => open(t.path!, t.line)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        if (ui.components.isNotEmpty) const SizedBox(height: 10),
        for (final comp in ui.components)
          Material(
            color: picked == comp.name ? c.fill : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onPick(comp.name),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                comp.name,
                                style: mono(context.t.bodySmall!.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, color: c.label)),
                              ),
                              if (comp.path != null) CodeLink(path: comp.path!, line: comp.line, onOpen: open),
                            ],
                          ),
                          if (comp.role.isNotEmpty) Text(comp.role, style: context.t.bodySmall),
                        ],
                      ),
                    ),
                    Text(switch (ui.screens.where((s) => s.uses.contains(comp.name)).length) {
                      0 => 'unused',
                      1 => '1 screen',
                      final n => '$n screens',
                    }, style: context.t.bodySmall),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Every screen and the shared components it uses, or those that use the
/// picked component.
class _Screens extends StatelessWidget {
  const _Screens({required this.ui, required this.picked, required this.onClear, required this.onPick, required this.open});

  final MapUi ui;
  final String? picked;
  final VoidCallback onClear;
  final ValueChanged<String> onPick;
  final void Function(String path, int? line) open;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final shown = [
      for (final s in ui.screens)
        if (picked == null || s.name == picked || s.uses.contains(picked)) s,
    ];
    return MapCard(
      label: picked == null ? 'Screens' : 'Screens with $picked',
      action: picked == null ? null : TextButton(onPressed: onClear, child: const Text('Show all')),
      children: [
        if (shown.isEmpty) _empty(context, picked == null ? 'No screen listed.' : 'No screen uses it.'),
        for (final s in shown)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      s.name,
                      style: mono(context.t.bodySmall!.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, color: c.label)),
                    ),
                    if (s.path != null) CodeLink(path: s.path!, line: s.line, onOpen: open),
                  ],
                ),
                if (s.role.isNotEmpty) Text(s.role, style: context.t.bodySmall),
                if (s.uses.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [for (final u in s.uses) DiagramChip(u, code: true, color: u == picked ? c.blue : null, onTap: () => onPick(u))],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
