// A project's Overview: what changed (updates by day, new since your last
// visit marked) and the Facts Claude keeps from them, with one search over
// both, and the Documents linked to the project (found in Slack and mail, or
// added by you). The text comes from Slack and mail: shown as plain text,
// never run.
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sources/chrome.dart';

import '../../core/classify/time.dart';
import '../../core/meetings.dart' show clockTime;
import '../../core/models/config.dart';
import '../../core/models/overview.dart';
import '../../state/project_overview.dart';
import '../../state/settings.dart';
import '../board/board_model.dart' show providerLabels;
import '../common.dart';
import '../parts.dart';
import '../theme.dart';

class OverviewPage extends ConsumerStatefulWidget {
  const OverviewPage({super.key, required this.project});

  final ProjectConfig project;

  @override
  ConsumerState<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends ConsumerState<OverviewPage> {
  var _q = '';

  @override
  void initState() {
    super.initState();
    // Reads merged merge requests and rewrites Facts once per visit.
    Future.microtask(() => ref.read(projectOverviewStateProvider(widget.project.id).notifier).visit());
  }

  bool _hit(String text) => _q.isEmpty || text.toLowerCase().contains(_q.toLowerCase());

  Future<void> _edit(int i, Fact f) async {
    final text = await ask(context, title: 'Edit Fact', text: f.text, hint: 'Empty removes it');
    if (text != null) await ref.read(projectOverviewStateProvider(widget.project.id).notifier).editFact(i, text);
  }

  Future<void> _addDoc() async {
    final url = TextEditingController(), title = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Document'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: url,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'https://…'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: title,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
        ],
      ),
    );
    final u = url.text.trim();
    if (ok != true || !u.startsWith('https://')) return;
    final t = title.text.trim();
    await ref.read(projectOverviewStateProvider(widget.project.id).notifier).addDoc(u, t.isEmpty ? Uri.parse(u).host : t);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project, c = context.c;
    final view = ref.watch(projectOverviewStateProvider(p.id)).value;
    final updates = [
      for (final u in view?.updates ?? const <ProjectUpdate>[])
        if (_hit('${u.text} ${u.source}')) u,
    ];
    final facts = [
      for (final (i, f) in (view?.overview.facts ?? const <Fact>[]).indexed)
        if (_hit('${f.text} ${f.source ?? ''} ${f.was ?? ''}')) (i, f),
    ];
    final docs = [
      for (final d in view?.docs ?? const <ProjectDoc>[])
        if (_hit('${d.title} ${d.url} ${d.source ?? ''}')) d,
    ];
    final fresh = newSince(view?.updates ?? const [], view?.lastSeen);
    return ListView(
      padding: pagePadding,
      children: [
        PageHead(
          title: 'Overview',
          trailing: (view?.writing ?? false)
              ? Row(
                  children: [
                    const SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 8),
                    Text('Updating facts…', style: context.t.bodySmall),
                  ],
                )
              : null,
        ),
        if (p.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(p.description!, style: context.t.bodyMedium),
          ),
        if (p.aliases.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text('Also called ${p.aliases.join(', ')}', style: context.t.bodySmall),
          ),
        if (view?.error case final e?)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(e, style: context.t.bodySmall?.copyWith(color: c.red)),
          ),
        const SizedBox(height: 14),
        TextField(
          onChanged: (v) => setState(() => _q = v.trim()),
          decoration: const InputDecoration(hintText: 'Search this project', prefixIcon: Icon(Icons.search, size: 18)),
        ),
        if (_q.isNotEmpty && updates.isEmpty && facts.isEmpty && docs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text('Nothing matches "$_q" in updates, documents or facts.', style: context.t.bodySmall),
          ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, box) {
            void open(String url) => openLink(Uri.parse(url), p.browserProfile ?? ref.read(settingsProvider).value?.actions.browserProfile);
            final changed = _Changed(updates: updates, lastSeen: view?.lastSeen, fresh: fresh, loading: view == null, onOpen: open);
            final kept = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Docs(
                  docs: docs,
                  loading: view == null,
                  onAdd: _addDoc,
                  onOpen: open,
                  onRemove: (d) => ref.read(projectOverviewStateProvider(p.id).notifier).removeDoc(d.url),
                ),
                const SizedBox(height: 24),
                _Facts(
                  facts: facts,
                  onEdit: _edit,
                  loading: view == null,
                  urls: {
                    for (final u in view?.updates ?? const <ProjectUpdate>[])
                      if (u.url case final url? when url.startsWith('https://')) u.id: url,
                  },
                  onOpen: open,
                ),
              ],
            );
            if (box.maxWidth < 760) return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [changed, const SizedBox(height: 24), kept]);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: changed),
                const SizedBox(width: 28),
                Expanded(flex: 2, child: kept),
              ],
            );
          },
        ),
      ],
    );
  }
}

Widget _heading(BuildContext context, String title, String sub) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Text(title, style: context.t.titleMedium),
      const SizedBox(width: 8),
      Expanded(child: Text(sub, style: context.t.bodySmall)),
    ],
  ),
);

/// Updates by day, newest first.
class _Changed extends StatelessWidget {
  const _Changed({required this.updates, required this.lastSeen, required this.fresh, required this.loading, required this.onOpen});

  final List<ProjectUpdate> updates;
  final DateTime? lastSeen;
  final int fresh;
  final bool loading;
  final void Function(String url) onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c, now = clock.now();
    final days = <String, List<ProjectUpdate>>{};
    for (final u in updates) {
      final d = daysSince(u.at, now);
      (days[d == 0 ? 'Today' : (d == 1 ? 'Yesterday' : shortDate(u.at))] ??= []).add(u);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(context, 'What changed', fresh == 0 ? 'nothing new since you last looked' : '$fresh new since you last looked'),
        if (updates.isEmpty)
          Text(
            loading ? 'Loading…' : 'Nothing yet. Slack and mail news about this project, and its merged merge requests, land here.',
            style: context.t.bodySmall,
          ),
        for (final e in days.entries)
          ...[
            SectionLabel(e.key, padding: const EdgeInsets.fromLTRB(2, 8, 2, 6)),
            for (final u in e.value)
              Material(
                color: c.card,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: u.url == null || !u.url!.startsWith('https://') ? null : () => onOpen(u.url!),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: lastSeen == null || (u.added ?? u.at).isAfter(lastSeen!) ? c.blue : Colors.transparent,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.text, style: context.t.bodyMedium),
                              Text('${providerLabels[u.provider] ?? u.provider} · ${u.source} · ${clockTime(u.at)}', style: context.t.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ].expand((w) => [w, const SizedBox(height: 4)]),
      ],
    );
  }
}

/// Documents linked to the project, newest first. A click opens one.
class _Docs extends StatelessWidget {
  const _Docs({required this.docs, required this.loading, required this.onAdd, required this.onRemove, required this.onOpen});

  final List<ProjectDoc> docs;
  final bool loading;
  final VoidCallback onAdd;
  final void Function(ProjectDoc) onRemove;
  final void Function(String url) onOpen;

  static IconData _icon(String url) {
    final host = Uri.tryParse(url)?.host ?? '';
    if (url.contains('docs.google.com/spreadsheets')) return Icons.table_chart_outlined;
    if (url.contains('docs.google.com/presentation')) return Icons.slideshow_outlined;
    if (host.contains('figma.com')) return Icons.draw_outlined;
    if (host.contains('grafana') || host.contains('lookerstudio') || host.contains('datadog') || url.contains('dashboard')) {
      return Icons.insert_chart_outlined;
    }
    return Icons.description_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _heading(context, 'Documents', 'docs and dashboards shared about it')),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: IconButton(
                tooltip: 'Add Document',
                iconSize: 16,
                visualDensity: VisualDensity.compact,
                onPressed: onAdd,
                icon: Icon(Icons.add, color: c.label2),
              ),
            ),
          ],
        ),
        if (docs.isEmpty) Text(loading ? 'Loading…' : 'None yet. Links shared in Slack and mail about this project land here.', style: context.t.bodySmall),
        if (docs.isNotEmpty)
          ContentCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (n, d) in docs.indexed) ...[
                  if (n > 0) Divider(height: 1, color: c.sep),
                  InkWell(
                    onTap: () => onOpen(d.url),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
                      child: Row(
                        children: [
                          Icon(_icon(d.url), size: 16, color: c.label2),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.title, style: context.t.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(
                                  [d.source ?? 'Added by you', shortDate(d.at)].join(' · '),
                                  style: context.t.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove',
                            iconSize: 15,
                            visualDensity: VisualDensity.compact,
                            onPressed: () => onRemove(d),
                            icon: Icon(Icons.close, color: c.label2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Facts by section, each line with where it came from. A click opens the
/// message the fact came from, when it has a link.
class _Facts extends StatelessWidget {
  const _Facts({required this.facts, required this.onEdit, required this.loading, required this.urls, required this.onOpen});

  final List<(int, Fact)> facts;
  final void Function(int, Fact) onEdit;
  final bool loading;

  /// Update id to its link.
  final Map<String, String> urls;
  final void Function(String url) onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(context, 'Facts', 'kept current by Claude, edit any line'),
        if (facts.isEmpty) Text(loading ? 'Loading…' : 'No facts yet. Claude writes them from the updates.', style: context.t.bodySmall),
        for (final e in factSections.entries)
          if (facts.where((f) => f.$2.section == e.key).toList() case final list when list.isNotEmpty) ...[
            SectionLabel(e.value, padding: const EdgeInsets.fromLTRB(2, 8, 2, 6)),
            ContentCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (n, (i, f)) in list.indexed) ...[
                    if (n > 0) Divider(height: 1, color: c.sep),
                    InkWell(
                      onTap: switch (urls[f.ref]) {
                        final url? => () => onOpen(url),
                        null => null,
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(f.text, style: context.t.bodyMedium),
                                  if ([f.source, if (f.was != null) '(was ${f.was})', if (f.edited) 'edited by you'].whereType<String>().join(' · ')
                                      case final meta when meta.isNotEmpty)
                                    Text(meta, style: context.t.bodySmall),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit',
                              iconSize: 15,
                              visualDensity: VisualDensity.compact,
                              onPressed: () => onEdit(i, f),
                              icon: Icon(Icons.edit_outlined, color: c.label2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
      ],
    );
  }
}
