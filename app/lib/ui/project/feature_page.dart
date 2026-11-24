// One feature of the map (class graph, flows, state machines, links, data,
// notes) and one data type (fields, who uses it, where it is declared).
// Every path:line opens the code in the project's IDE.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/map/models.dart';
import '../../core/models/config.dart';
import '../map/class_graph.dart';
import '../map/sequence_view.dart';
import '../map/state_view.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';
import 'map_parts.dart';
import 'project_screen.dart';

class FeaturePage extends ConsumerWidget {
  const FeaturePage({super.key, required this.project, required this.map, required this.featureId});

  final ProjectConfig project;
  final FeatureMap map;
  final String featureId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = map.features.where((x) => x.id == featureId).firstOrNull;
    if (f == null) return Center(child: Text('No feature "$featureId" in the map', style: context.t.titleMedium));
    final open = codeOpener(ref, project.id);
    final titles = {for (final x in map.features) x.id: x.title};
    final types = {for (final d in map.dataTypes) d.id: d};
    void goFeature(String id) => goProject(context, project.id, FeaturePlace(id));
    return ListView(
      key: PageStorageKey('feature-${f.id}'),
      padding: pagePadding,
      children: [
        _Head(
          title: f.title,
          summary: f.summary,
          stale: map.staleFeatures.contains(f.id),
          chips: [for (final p in f.paths) CodeChip(label: p, onTap: () => open(p, null))],
        ),
        if (f.graph != null && f.graph!.nodes.isNotEmpty)
          _Section(
            title: 'Classes',
            child: ClassGraphView(
              graph: f.graph!,
              featureTitles: titles,
              onFeature: (id) {
                if (titles.containsKey(id)) goFeature(id);
              },
              onOpen: open,
            ),
          ),
        if (f.sequences.isNotEmpty)
          _Section(
            title: f.sequences.length == 1 ? 'Flow' : 'Flows',
            child: _Tabs(
              labels: [for (final (i, s) in f.sequences.indexed) s.title.isEmpty ? (i == 0 ? 'Main flow' : 'Flow ${i + 1}') : s.title],
              builder: (i) => SequencePlayer(sequence: f.sequences[i], onOpen: open),
            ),
          ),
        if (f.states.isNotEmpty)
          _Section(
            title: f.states.length == 1 ? 'State Machine' : 'State Machines',
            child: _Tabs(
              labels: [for (final s in f.states) s.title],
              builder: (i) => StateDiagramView(state: f.states[i], onOpen: open),
            ),
          ),
        if (f.links.isNotEmpty)
          _Section(
            title: 'Other Features',
            child: Column(
              children: [
                for (final l in f.links)
                  _Line(
                    lead: l.kind == 'calls' ? 'Calls' : 'Called by',
                    title: titles[l.feature] ?? l.feature,
                    missing: !titles.containsKey(l.feature),
                    detail: l.detail,
                    onTap: titles.containsKey(l.feature) ? () => goFeature(l.feature) : null,
                    code: l.path == null ? null : CodeChip(label: _at(l.path!, l.line), onTap: () => open(l.path!, l.line)),
                  ),
              ],
            ),
          ),
        if (f.data.isNotEmpty)
          _Section(
            title: 'Data',
            child: Column(
              children: [
                for (final d in f.data)
                  _Line(
                    lead: _cap(d.use),
                    title: types[d.type]?.name ?? d.type,
                    missing: !types.containsKey(d.type),
                    detail: d.detail,
                    onTap: types.containsKey(d.type) ? () => goProject(context, project.id, DataPlace(d.type)) : null,
                  ),
              ],
            ),
          ),
        if (f.notes.isNotEmpty)
          _Section(
            title: 'Notes',
            child: Column(
              children: [for (final n in f.notes) _NoteLine(note: n, open: open)],
            ),
          ),
      ],
    );
  }
}

class DataTypePage extends ConsumerWidget {
  const DataTypePage({super.key, required this.project, required this.map, required this.typeId});

  final ProjectConfig project;
  final FeatureMap map;
  final String typeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = map.dataTypes.where((x) => x.id == typeId).firstOrNull;
    if (t == null) return Center(child: Text('No data type "$typeId" in the map', style: context.t.titleMedium));
    final c = context.c;
    final open = codeOpener(ref, project.id);
    final byName = {for (final d in map.dataTypes) d.name: d.id};
    final users = [
      for (final f in map.features)
        for (final d in f.data)
          if (d.type == t.id) (f, d),
    ];
    final versions = [if (t.since.isNotEmpty) 'since ${t.since}', if (t.until.isNotEmpty) 'until ${t.until}'].join(', ');
    return ListView(
      key: PageStorageKey('data-${t.id}'),
      padding: pagePadding,
      children: [
        _Head(
          title: t.name,
          summary: t.summary,
          stale: map.staleData.contains(t.id),
          chips: [StatusTag(_boundary[t.boundary] ?? t.boundary, context.c.graphite), if (versions.isNotEmpty) StatusTag(versions, context.c.graphite)],
        ),
        _Section(
          title: 'Fields',
          child: t.fields.isEmpty
              ? Text('No fields written.', style: context.t.bodySmall)
              : Table(
                  columnWidths: const {0: IntrinsicColumnWidth(), 1: IntrinsicColumnWidth(), 2: FlexColumnWidth()},
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    for (final field in t.fields)
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: c.sep, width: .5)),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 7, 20, 7),
                            child: Text('${field.name}${field.optional ? '?' : ''}', style: mono(context.t.bodyMedium!.copyWith(fontSize: 12.5))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: _TypeText(type: field.type, byName: byName, onType: (id) => goProject(context, project.id, DataPlace(id))),
                          ),
                          Text(
                            [field.note, if (field.since.isNotEmpty) 'since ${field.since}'].where((s) => s.isNotEmpty).join(' · '),
                            style: context.t.bodySmall,
                          ),
                        ],
                      ),
                  ],
                ),
        ),
        _Section(
          title: 'Used By',
          child: users.isEmpty
              ? Text('No feature says it uses this type.', style: context.t.bodySmall)
              : Column(
                  children: [
                    for (final (f, d) in users)
                      _Line(lead: _cap(d.use), title: f.title, detail: d.detail, onTap: () => goProject(context, project.id, FeaturePlace(f.id))),
                  ],
                ),
        ),
        _Section(
          title: 'Declared In',
          caption: t.definitions.length > 1 ? 'Declared in ${t.definitions.length} places: keep them in sync.' : '',
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final d in t.definitions) CodeChip(label: _at(d.path, d.line), onTap: () => open(d.path, d.line))],
          ),
        ),
      ],
    );
  }
}

const _boundary = {'wire': 'On the wire', 'storage': 'Stored', 'url': 'URL format', 'file': 'File'};

String _at(String path, int? line) => line == null ? path : '$path:$line';

String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// A field type, with the names of other data types as links.
class _TypeText extends StatelessWidget {
  const _TypeText({required this.type, required this.byName, required this.onType});

  final String type;
  final Map<String, String> byName;
  final ValueChanged<String> onType;

  @override
  Widget build(BuildContext context) {
    final code = mono(context.t.bodyMedium!.copyWith(fontSize: 12.5));
    final parts = RegExp(r'[A-Za-z_][A-Za-z0-9_]*|[^A-Za-z_]+').allMatches(type).map((m) => m[0]!);
    return Wrap(
      children: [
        for (final p in parts)
          byName.containsKey(p)
              ? InkWell(
                  onTap: () => onType(byName[p]!),
                  child: Text(p, style: code.copyWith(color: context.c.blue)),
                )
              : Text(p, style: code.copyWith(color: context.c.label2)),
      ],
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({required this.title, required this.summary, required this.stale, required this.chips});

  final String title, summary;
  final bool stale;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Flexible(child: Text(title, style: context.t.headlineSmall)),
          if (stale) ...[const SizedBox(width: 10), StatusTag('Changed since drawn', context.c.orange)],
        ],
      ),
      if (summary.isNotEmpty) ...[
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(summary, style: context.t.bodyMedium?.copyWith(color: context.c.label2)),
        ),
      ],
      if (chips.isNotEmpty) ...[const SizedBox(height: 10), Wrap(spacing: 6, runSpacing: 6, children: chips)],
    ],
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.caption = ''});

  final String title, caption;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 26),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [SectionLabel(title), if (caption.isNotEmpty) _Caption(caption), const SizedBox(height: 8), child],
    ),
  );
}

class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 6),
    child: Text(text, style: context.t.bodySmall),
  );
}

/// One row of a list: what kind, what, and a few words.
class _Line extends StatelessWidget {
  const _Line({required this.lead, required this.title, this.detail = '', this.missing = false, this.onTap, this.code});

  final String lead, title, detail;
  final bool missing;
  final VoidCallback? onTap;
  final Widget? code;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: Row(
          children: [
            SizedBox(width: 110, child: Text(lead, style: context.t.bodySmall)),
            Text(
              title,
              style: context.t.bodyMedium!.copyWith(fontSize: 13.5, fontWeight: FontWeight.w600, color: missing ? c.red : (onTap == null ? c.label : c.blue)),
            ),
            if (missing) Text('  not in the map', style: context.t.bodySmall?.copyWith(color: c.red)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(detail, overflow: TextOverflow.ellipsis, style: context.t.bodySmall),
            ),
            ?code,
          ],
        ),
      ),
    );
  }
}

class _NoteLine extends StatelessWidget {
  const _NoteLine({required this.note, required this.open});

  final MapNote note;
  final OpenCode open;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (label, icon, color) = switch (note.kind) {
      'dead-code' => ('Dead code', Icons.delete_outline_rounded, c.graphite),
      'platform' => ('Platform', Icons.devices_other_rounded, c.teal),
      'config' => ('Config', Icons.tune_rounded, c.indigo),
      _ => ('Finding', Icons.report_gmailerrorred_rounded, c.red),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: context.t.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ),
          Expanded(child: Text(note.text, style: context.t.bodyMedium)),
          if (note.path != null) ...[const SizedBox(width: 8), CodeChip(label: _at(note.path!, note.line), onTap: () => open(note.path!, note.line))],
        ],
      ),
    );
  }
}

/// Tabs only when there are several; one view shows on its own.
class _Tabs extends StatefulWidget {
  const _Tabs({required this.labels, required this.builder});

  final List<String> labels;
  final Widget Function(int index) builder;

  @override
  State<_Tabs> createState() => _TabsState();
}

class _TabsState extends State<_Tabs> {
  var _i = 0;

  @override
  Widget build(BuildContext context) {
    final i = _i.clamp(0, widget.labels.length - 1);
    if (widget.labels.length == 1) return widget.builder(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          children: [
            for (final (j, l) in widget.labels.indexed)
              ChoiceChip(
                label: Text(l),
                selected: i == j,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                onSelected: (_) => setState(() => _i = j),
              ),
          ],
        ),
        const SizedBox(height: 10),
        KeyedSubtree(key: ValueKey(i), child: widget.builder(i)),
      ],
    );
  }
}
