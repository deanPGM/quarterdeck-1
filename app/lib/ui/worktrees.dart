// The worktrees in a sidebar: every project's on the board, one project's on
// its page. A row gets you back to its Claude session; New Task starts one in
// a fresh worktree, without opening the IDE.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../actions/launcher.dart';
import '../core/models/config.dart';
import '../data/deck_home.dart';
import '../state/project_info.dart' show logoFile;
import '../state/settings.dart';
import '../state/terminals.dart';
import '../state/worktrees.dart';
import 'common.dart';
import 'parts.dart';
import 'project/project_logo.dart';
import 'theme.dart';

/// Asks for a task name (and the project, when [project] is null), then
/// starts it in a new worktree.
Future<void> newTask(BuildContext context, WidgetRef ref, {ProjectConfig? project}) async {
  final cfg = await ref.read(settingsProvider.future);
  if (!context.mounted) return;
  final projects = [
    for (final p in cfg.projects)
      if (p.dir != null) p,
  ];
  if (projects.isEmpty) return showToast(context, 'Set a project folder in Settings first.');
  final picked = await showDialog<(ProjectConfig, String)>(
    context: context,
    builder: (_) => _NewTaskDialog(projects: projects, project: project ?? projects.first, choose: project == null),
  );
  if (picked == null) return;
  try {
    await ref.read(worktreeTasksProvider.notifier).start(picked.$1, picked.$2);
  } catch (e) {
    if (context.mounted) showToast(context, 'Could not start the task: $e');
  }
}

class _NewTaskDialog extends StatefulWidget {
  const _NewTaskDialog({required this.projects, required this.project, required this.choose});

  final List<ProjectConfig> projects;
  final ProjectConfig project;

  /// Show the project picker.
  final bool choose;

  @override
  State<_NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<_NewTaskDialog> {
  late var _project = widget.project;
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _start() {
    if (taskBranch(_name.text).isNotEmpty) Navigator.pop(context, (_project, _name.text));
  }

  @override
  Widget build(BuildContext context) {
    final branch = taskBranch(_name.text);
    return AlertDialog(
      title: const Text('New Task'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.choose) ...[
              DropdownButtonFormField<ProjectConfig>(
                initialValue: _project,
                decoration: const InputDecoration(labelText: 'Project'),
                items: [for (final p in widget.projects) DropdownMenuItem(value: p, child: Text(p.name))],
                onChanged: (p) => setState(() => _project = p ?? _project),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _name,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Branch', hintText: 'feat/AVPN-123 or a few words'),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _start(),
            ),
            const SizedBox(height: 10),
            Text(
              branch.isEmpty
                  ? 'A new branch from origin\'s default branch, in its own worktree, with a Claude session in it.'
                  : 'Branch $branch in ${tildeHome(_project.dir!)}/$worktreesDir/${branch.replaceAll('/', '-')}',
              style: context.t.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: branch.isEmpty ? null : _start, child: const Text('Start')),
      ],
    );
  }
}

/// The worktrees as sidebar rows, under a Worktrees section: every project's,
/// with their logos, or only [project]'s. Ends with New Task.
class WorktreeList extends ConsumerWidget {
  const WorktreeList({super.key, this.project});

  final ProjectConfig? project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    final home = ref.watch(homeProvider);
    final cfg = ref.watch(settingsProvider).value;
    final terms = ref.watch(terminalsProvider);
    final all = ref.watch(worktreesProvider).value ?? const <Worktree>[];
    final list = [
      for (final w in all)
        if (project == null || w.project == project!.id) w,
    ];
    ProjectConfig? of(Worktree w) => cfg?.projects.where((p) => p.id == w.project).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SidebarSection('Worktrees'),
        for (final w in list)
          Builder(
            builder: (context) {
              final tab = worktreeTab(terms, w);
              final pr = of(w);
              return Tooltip(
                message: [tildeHome(w.path), if (w.uncommitted > 0) '${w.uncommitted} files not committed'].join('\n'),
                waitDuration: const Duration(milliseconds: 600),
                child: SidebarRow(
                  label: worktreeName(w),
                  selected: false,
                  leading: project != null || pr == null
                      ? Icon(Icons.call_split_rounded, size: 16, color: c.label2)
                      : ProjectLogo(
                          file: logoFile(home, pr),
                          platforms: pr.platforms,
                          fallback: Icon(Icons.folder_outlined, size: 18, color: c.label2),
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (w.uncommitted > 0) Icon(Icons.edit_outlined, size: 12, color: c.orange),
                      if (tab != null) ...[const SizedBox(width: 6), CircleAvatar(radius: 3.5, backgroundColor: tab.waiting ? c.orange : c.green)],
                      _Menu(worktree: w, project: pr, running: tab != null),
                    ],
                  ),
                  onTap: () => _resume(context, ref, w),
                ),
              );
            },
          ),
        SidebarRow(
          label: 'New Task…',
          selected: false,
          color: c.blue,
          leading: Icon(Icons.add_rounded, size: 16, color: c.blue),
          onTap: () => newTask(context, ref, project: project),
        ),
      ],
    );
  }
}

Future<void> _resume(BuildContext context, WidgetRef ref, Worktree w) async {
  try {
    await ref.read(worktreeTasksProvider.notifier).resume(w);
  } catch (e) {
    if (context.mounted) showToast(context, 'Could not resume ${worktreeName(w)}: $e');
  }
}

class _Menu extends ConsumerWidget {
  const _Menu({required this.worktree, required this.project, required this.running});

  final Worktree worktree;
  final ProjectConfig? project;
  final bool running;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = worktree;
    return PopupMenuButton<String>(
      tooltip: 'More',
      iconSize: 16,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(Icons.more_horiz_rounded, color: context.c.label2),
      onSelected: (v) async {
        switch (v) {
          case 'resume':
            await _resume(context, ref, w);
          case 'ide':
            final cfg = await ref.read(settingsProvider.future);
            await openInIde(project?.ide ?? cfg.actions.ide, w.path, '', null);
          case 'remove':
            final ok = await confirm(
              context,
              title: 'Remove Worktree',
              text: 'Deletes the folder ${tildeHome(w.path)}. The branch ${w.branch ?? ''} and its commits stay.',
              action: 'Remove',
              destructive: true,
            );
            if (!ok) return;
            try {
              await ref.read(worktreeTasksProvider.notifier).remove(w);
            } catch (e) {
              if (context.mounted) showToast(context, w.uncommitted > 0 ? 'It has edits not committed: commit or drop them first.' : '$e');
            }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'resume', child: Text(running ? 'Show Session' : 'Resume Claude')),
        const PopupMenuItem(value: 'ide', child: Text('Open in IDE')),
        PopupMenuItem(value: 'remove', enabled: !running, child: const Text('Remove Worktree…')),
      ],
    );
  }
}
