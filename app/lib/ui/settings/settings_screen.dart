import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import '../../actions/launcher.dart';
import '../../actions/updater.dart';
import '../../core/models/claude_run.dart';
import '../../core/models/config.dart';
import '../../core/meetings.dart' show clockTime;
import '../../core/models/snapshot.dart';
import '../../core/projects.dart';
import '../../core/platforms.dart';
import '../../core/providers_catalog.dart';
import '../../state/board.dart';
import '../../state/forges.dart';
import '../../state/project_info.dart';
import '../../state/settings.dart';
import '../../state/terminals.dart';
import '../../state/updates.dart';
import '../project/project_logo.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';
import 'form.dart';
import 'tool_rules_groups.dart';

const _codeModels = {'claude-opus-5-5': 'Opus 5.5', 'claude-sonnet-5-5': 'Sonnet 5.5', 'claude-fable-5-1': 'Fable 5.1'};

final _providerIcons = <String, (IconData, Color Function(DeckColors))>{
  'gitlab': (Icons.call_split_rounded, (c) => c.orange),
  'github': (Icons.code_rounded, (c) => c.graphite),
  'jira': (Icons.confirmation_number_outlined, (c) => c.blue),
  'slack': (Icons.tag_rounded, (c) => c.purple),
  'mail': (Icons.mail_outline_rounded, (c) => c.red),
  'calendar': (Icons.event_outlined, (c) => c.indigo),
};

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.section});

  /// The pane to open: `provider:slack`, `project:<id>`, `claude`…
  final String? section;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late String section = widget.section ?? 'general';

  @override
  Widget build(BuildContext context) {
    final cfg = ref.watch(settingsProvider).value;
    if (cfg == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final c = context.c;
    final home = ref.watch(homeProvider);
    Widget item(String id, String label, Widget icon, {String? status}) => SidebarRow(
      label: label,
      selected: section == id,
      leading: icon,
      trailing: status == null ? null : Text(status, style: context.t.bodySmall!.copyWith(color: c.label3)),
      onTap: () => setState(() => section = id),
    );

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: c.sidebar,
            child: Container(
              width: 240,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: ListView(
                children: [
                  SidebarBack(label: const Text('Board'), onPressed: () => context.go('/')),
                  const SizedBox(height: 6),
                  item('general', 'General', AccentIcon(Icons.tune_rounded, c.graphite)),
                  item('claude', 'Claude', AccentIcon(Icons.auto_awesome_outlined, c.orange)),
                  item('actions', 'Actions', AccentIcon(Icons.play_arrow_rounded, c.green)),
                  const SidebarSection('Providers'),
                  for (final info in providerCatalog)
                    item(
                      'provider:${info.id}',
                      info.name,
                      AccentIcon(_providerIcons[info.id]!.$1, _providerIcons[info.id]!.$2(context.c)),
                      status: cfg.providers[info.id]?.enabled == true ? 'On' : 'Off',
                    ),
                  const SidebarSection('Projects'),
                  for (final pr in cfg.projects)
                    item(
                      'project:${pr.id}',
                      pr.name,
                      ProjectLogo(file: logoFile(home, pr), platforms: pr.platforms, size: 22, fallback: AccentIcon(Icons.folder_outlined, c.blue)),
                    ),
                  SidebarRow(
                    label: 'Add Project…',
                    selected: false,
                    color: c.blue,
                    leading: SizedBox(width: 22, child: Icon(Icons.add_rounded, size: 20, color: c.blue)),
                    onTap: _addProject,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(36, 30, 36, 30),
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 640), child: _pane(cfg)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pane(DeckConfig cfg) {
    if (section.startsWith('provider:')) return ProviderPane(id: section.substring(9), key: ValueKey(section));
    if (section.startsWith('project:')) {
      final pr = cfg.projects.where((x) => x.id == section.substring(8)).firstOrNull;
      if (pr != null) return ProjectPane(project: pr, key: ValueKey(section), onDeleted: () => setState(() => section = 'general'));
    }
    return switch (section) {
      'claude' => const ClaudePane(),
      'actions' => const ActionsPane(),
      _ => const GeneralPane(),
    };
  }

  Future<void> _addProject() async {
    final dir = await getDirectoryPath(confirmButtonText: 'Add Project');
    if (dir == null) return;
    final cfg = await ref.read(settingsProvider.future);
    final name = p.basename(dir);
    var id = slug(name);
    while (cfg.projects.any((x) => x.id == id)) {
      id = '$id-2';
    }
    final project = ProjectConfig(id: id, name: name, dir: dir, repo: await ref.read(settingsProvider.notifier).repoOf(dir));
    await ref.read(settingsProvider.notifier).save(cfg.copyWith(projects: [...cfg.projects, project]));
    setState(() => section = 'project:$id');
    // Finds the product name, aliases and icon in the background.
    unawaited(ref.read(projectInfosProvider.notifier).analyze(id));
  }
}

Widget _title(BuildContext context, String title, String text, {Widget? icon, Widget? trailing}) => Padding(
  padding: const EdgeInsets.only(bottom: 22),
  child: PageHead(title: title, subtitle: text, leading: icon, trailing: trailing),
);

class GeneralPane extends ConsumerWidget {
  const GeneralPane({super.key});

  static const mcpCommand = 'claude mcp add --scope user --transport http deck http://127.0.0.1:$mcpPort/mcp';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(settingsProvider).requireValue;
    final home = ref.watch(homeProvider);
    final save = ref.read(settingsProvider.notifier).save;
    final update = ref.watch(updatesProvider);
    final next = update.available;
    final updates = ref.read(updatesProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context, 'General', 'Where Quarterdeck keeps its data, how your Claude sessions reach it, and updates.'),
        SettingsGroup(
          title: 'Storage',
          footer: 'deck.json holds these settings. state/ holds your pins, snoozes, notes and todos. cache/ holds fetched data and can be deleted.',
          children: [
            SettingsRow(
              label: 'Deck folder',
              description: home.dir,
              trailing: OutlinedButton(
                onPressed: () async {
                  final dir = await getDirectoryPath(confirmButtonText: 'Use This Folder');
                  if (dir == null) return;
                  await ref.read(homeProvider.notifier).select(dir);
                },
                child: const Text('Change…'),
              ),
            ),
            SettingsRow(
              label: 'Back up state with git',
              description: 'Commit every change to state/ in the Deck folder\'s git repo.',
              trailing: Switch(
                value: cfg.gitBackup,
                onChanged: (v) => save(cfg.copyWith(gitBackup: v)),
              ),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Claude sessions',
          footer: 'Run this once. Then every Claude Code session can add todos to Quarterdeck and see your board.',
          children: [
            SettingsRow(
              label: 'Deck MCP server',
              description: 'Running on http://127.0.0.1:$mcpPort/mcp',
              below: Row(
                children: [
                  Expanded(
                    child: SelectableText(mcpCommand, style: mono(context.t.bodySmall!.copyWith(fontSize: 12, color: context.c.label2))),
                  ),
                  IconButton(
                    tooltip: 'Copy',
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: mcpCommand));
                      showToast(context, 'Copied');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Updates',
          footer:
              'Updates come from github.com/paillardf/quarterdeck releases. Update runs the install script, which quits Quarterdeck and opens the new version.',
          children: [
            SettingsRow(
              label: update.dev ? 'Version: built from source' : 'Version ${update.current}',
              description: switch (update) {
                _ when update.dev => 'This build does not update itself: pull and rebuild.',
                UpdateState(step: UpdateStep.checking) => 'Checking…',
                UpdateState(step: UpdateStep.installing) => 'Updating to ${next?.version}…',
                UpdateState(:final error?) => error,
                _ when next != null => 'Quarterdeck ${next.version} is available.',
                UpdateState(:final checkedAt?) => 'Up to date. Checked at ${clockTime(checkedAt)}.',
                _ => 'Not checked yet.',
              },
              trailing: next != null
                  ? FilledButton(onPressed: update.step == UpdateStep.installing ? null : () => updateNow(ref), child: Text('Update to ${next.version}'))
                  : OutlinedButton(onPressed: update.dev || update.step == UpdateStep.checking ? null : updates.check, child: const Text('Check Now')),
            ),
            SettingsRow(
              label: 'Check for updates',
              description: 'Look for a new release at start and once a day.',
              trailing: Switch(
                value: cfg.checkUpdates,
                onChanged: (v) => save(cfg.copyWith(checkUpdates: v)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProviderPane extends ConsumerStatefulWidget {
  const ProviderPane({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ProviderPane> createState() => _ProviderPaneState();
}

class _ProviderPaneState extends ConsumerState<ProviderPane> {
  String? testResult;
  bool testing = false, testOk = false;

  Future<void> _test() async {
    setState(() => testing = true);
    try {
      testResult = await (widget.id == 'github' ? ref.read(githubSourceProvider).test() : ref.read(gitlabSourceProvider).test());
      testOk = true;
    } catch (e) {
      testResult = '$e'.replaceFirst(RegExp(r'^\w+Error: '), '');
      testOk = false;
    } finally {
      if (mounted) setState(() => testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = providerInfo(widget.id);
    final cfg = ref.watch(settingsProvider).requireValue;
    final pc = cfg.providers[info.id];
    final board = ref.watch(boardProvider).value;
    final snap = board?.snapshots[info.id];
    final busy = board?.busy.contains(info.id) ?? false;
    final notes = board?.snapshots['notes'];
    final c = context.c;
    Future<void> set(ProviderConfig? v) => ref
        .read(settingsProvider.notifier)
        .save(
          cfg.copyWith(
            providers: {
              for (final e in cfg.providers.entries)
                if (e.key != info.id) e.key: e.value,
              info.id: ?v,
            },
          ),
        );
    final (icon, tint) = _providerIcons[info.id]!;
    final color = tint(context.c);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(
          context,
          info.name,
          info.description,
          icon: AccentIcon(icon, color, size: 40),
          trailing: Switch(
            value: pc?.enabled ?? false,
            onChanged: (v) => set(v ? (pc ?? ProviderConfig(access: info.access.first)).copyWith(enabled: true) : pc?.copyWith(enabled: false)),
          ),
        ),
        if (pc != null && pc.enabled) ...[
          SettingsGroup(
            title: 'Connection',
            footer: pc.access == Access.cli
                ? 'Quarterdeck runs ${info.cli} itself, with the login from ${info.cli} auth login. No model reads the data, so a refresh costs no tokens.'
                : 'The background Claude session fetches it with your Claude connectors, and judges what needs you. Costs a few cents per refresh.',
            children: [
              SettingsRow(
                label: 'Fetched by',
                trailing: SegmentedButton<Access>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  segments: [
                    if (info.access.contains(Access.cli)) ButtonSegment(value: Access.cli, label: Text('${info.cli} CLI')),
                    const ButtonSegment(value: Access.claude, label: Text('Claude session')),
                  ],
                  selected: {pc.access},
                  onSelectionChanged: (s) => set(pc.copyWith(access: s.first)),
                ),
              ),
              if (pc.access == Access.cli) ...[
                SettingsRow(
                  label: 'Test connection',
                  description: testResult,
                  trailing: testing
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (testResult != null) Icon(testOk ? Icons.check_circle : Icons.error, color: testOk ? c.green : c.red, size: 18),
                            const SizedBox(width: 8),
                            OutlinedButton(onPressed: _test, child: const Text('Test')),
                          ],
                        ),
                ),
              ],
            ],
          ),
          if (info.options.isNotEmpty)
            SettingsGroup(
              title: 'Options',
              children: [
                for (final o in info.options.entries)
                  SettingsRow(
                    label: o.value,
                    below: CommitField(
                      value: pc.options[o.key] ?? '',
                      onCommit: (v) => set(pc.copyWith(options: {...pc.options, o.key: v}..removeWhere((_, x) => x.isEmpty))),
                    ),
                  ),
              ],
            ),
          SettingsGroup(
            title: 'Status',
            children: [
              SettingsRow(
                label: switch (snap?.state) {
                  SourceState.ok => 'Loaded',
                  SourceState.error => 'Failed',
                  _ => 'Not loaded yet',
                },
                description: [if (snap?.at != null) 'Last fetch ${clockTime(snap!.at!)}', ?snap?.message].join(' · '),
                trailing: busy
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 8),
                          Text('Fetching…'),
                        ],
                      )
                    : OutlinedButton(onPressed: () => ref.read(boardProvider.notifier).refreshOne(info.id), child: const Text('Fetch Now')),
              ),
              if (info.id == 'mail' && (pc.options['notesName'] ?? '').isNotEmpty)
                SettingsRow(
                  label: 'Meeting notes',
                  description: (board?.busy.contains('notes') ?? false)
                      ? 'Fetching…'
                      : [if (notes?.at != null) 'Last fetch ${clockTime(notes!.at!)}', notes?.message ?? 'Not loaded yet'].join(' · '),
                ),
            ],
          ),
          if (pc.access == Access.claude) RunsGroup(provider: info.id),
        ],
      ],
    );
  }
}

class ProjectPane extends ConsumerWidget {
  const ProjectPane({super.key, required this.project, required this.onDeleted});

  final ProjectConfig project;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(settingsProvider).requireValue;
    final pr = cfg.projects.firstWhere((x) => x.id == project.id, orElse: () => project);
    Future<void> set(ProjectConfig v) =>
        ref.read(settingsProvider.notifier).save(cfg.copyWith(projects: [for (final x in cfg.projects) x.id == pr.id ? v : x]));
    final c = context.c;
    final home = ref.watch(homeProvider);
    final run = ref.watch(projectInfosProvider)[pr.id];
    final infos = ref.read(projectInfosProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(
          context,
          pr.name,
          pr.description ?? 'Cards from this repo, board and channels are tagged with this project. Work on them starts in its folder.',
          icon: ProjectLogo(file: logoFile(home, pr), platforms: pr.platforms, size: 40, fallback: AccentIcon(Icons.folder_outlined, c.blue, size: 40)),
        ),
        SettingsGroup(
          title: 'Project',
          footer: 'Claude tags Slack and mail with this project when they use its name or one of its other names.',
          children: [
            SettingsRow(
              label: 'Read from the folder',
              description: run == null
                  ? 'Claude finds the product name, other names, icon, platforms, task board, channels and IDE.'
                  : run.running
                  ? '${run.step}…'
                  : run.result?.error ?? 'Done.',
              trailing: OutlinedButton(
                onPressed: pr.dir == null || (run?.running ?? false) ? null : () => analyzeProject(context, ref, pr.id),
                child: Text(run?.running ?? false ? 'Reading…' : 'Analyze'),
              ),
            ),
            SettingsRow(
              label: 'Name',
              trailing: CommitField(
                width: 260,
                value: pr.name,
                onCommit: (v) => v.isEmpty ? null : set(pr.copyWith(name: v)),
              ),
            ),
            SettingsRow(
              label: 'Description',
              trailing: CommitField(
                width: 300,
                value: pr.description ?? '',
                onCommit: (v) => set(pr.copyWith(description: v.isEmpty ? null : v)),
              ),
            ),
            SettingsRow(
              label: 'Other names',
              description: 'App names, bundle ids, ticket prefixes. Comma separated.',
              trailing: CommitField(
                width: 300,
                value: pr.aliases.join(', '),
                hint: 'Acme VPN, AVPN',
                onCommit: (v) => set(
                  pr.copyWith(
                    aliases: [
                      for (final x in v.split(','))
                        if (x.trim().isNotEmpty) x.trim(),
                    ],
                  ),
                ),
              ),
            ),
            SettingsRow(
              label: 'Platforms',
              description: 'A badge on the logo, so two apps of one product tell apart.',
              below: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final MapEntry(key: id, value: label) in platforms.entries)
                    FilterChip(
                      avatar: Icon(platformIcons[id], size: 16),
                      label: Text(label),
                      showCheckmark: false,
                      visualDensity: VisualDensity.compact,
                      selected: pr.platforms.contains(id),
                      onSelected: (on) => set(
                        pr.copyWith(
                          platforms: [
                            for (final x in platforms.keys)
                              if (x == id ? on : pr.platforms.contains(x)) x,
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SettingsRow(
              label: 'Tech',
              trailing: CommitField(
                width: 300,
                value: pr.tech ?? '',
                hint: 'Swift, SwiftUI, Xcode',
                onCommit: (v) => set(pr.copyWith(tech: v.isEmpty ? null : v)),
              ),
            ),
            SettingsRow(
              label: 'Logo',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProjectLogo(file: logoFile(home, pr), size: 28),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () async {
                      final f = await openFile(
                        initialDirectory: pr.dir,
                        acceptedTypeGroups: const [
                          XTypeGroup(label: 'Images', extensions: ['png', 'jpg', 'jpeg', 'webp', 'svg']),
                        ],
                      );
                      if (f == null) return;
                      final logo = await infos.importLogo(pr.id, f.path);
                      await ref
                          .read(settingsProvider.notifier)
                          .change((cfg) => cfg.copyWith(projects: [for (final x in cfg.projects) x.id == pr.id ? x.copyWith(logo: logo) : x]));
                    },
                    child: const Text('Choose…'),
                  ),
                ],
              ),
            ),
            SettingsRow(
              label: 'Folder',
              description: pr.dir ?? 'None',
              trailing: OutlinedButton(
                onPressed: () async {
                  final dir = await getDirectoryPath(initialDirectory: pr.dir, confirmButtonText: 'Use This Folder');
                  if (dir != null) await set(pr.copyWith(dir: dir, repo: pr.repo ?? await ref.read(settingsProvider.notifier).repoOf(dir)));
                },
                child: const Text('Choose…'),
              ),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Where its work comes from',
          footer:
              'Repo: gitlab:group/project or github:owner/repo. Board: jira:KEY, gitlab:group/project or github:owner/repo. Channels: #name, comma separated.',
          children: [
            SettingsRow(
              label: 'Git repo',
              trailing: CommitField(
                width: 300,
                mono: true,
                value: pr.repo ?? '',
                hint: 'gitlab:group/project',
                onCommit: (v) => set(pr.copyWith(repo: v.isEmpty ? null : v)),
              ),
            ),
            SettingsRow(
              label: 'Task board',
              trailing: CommitField(
                width: 300,
                mono: true,
                value: pr.board ?? '',
                hint: 'jira:KEY',
                onCommit: (v) => set(
                  pr.copyWith(
                    board: v.isEmpty
                        ? null
                        : RegExp('^(jira|gitlab|github):').hasMatch(v)
                        ? v
                        : 'jira:${v.toUpperCase()}',
                  ),
                ),
              ),
            ),
            SettingsRow(
              label: 'Slack channels',
              trailing: CommitField(
                width: 300,
                value: pr.channels.join(', '),
                hint: '#team-channel',
                onCommit: (v) => set(
                  pr.copyWith(
                    channels: [
                      for (final x in v.split(','))
                        if (x.trim().isNotEmpty) x.trim().startsWith('#') ? x.trim() : '#${x.trim()}',
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Work',
          children: [
            SettingsRow(
              label: 'Start tickets in a worktree',
              description: 'Claude opens a git worktree named after the ticket, so the main checkout stays clean.',
              trailing: Switch(
                value: pr.worktree,
                onChanged: (v) => set(pr.copyWith(worktree: v)),
              ),
            ),
            SettingsRow(
              label: 'IDE command',
              description: 'Leave empty to use the one in Actions.',
              trailing: CommitField(
                width: 160,
                mono: true,
                value: pr.ide ?? '',
                hint: cfg.actions.ide,
                onCommit: (v) => set(pr.copyWith(ide: v.isEmpty ? null : v)),
              ),
            ),
            if (ref.watch(chromeProfileListProvider) case final profiles when profiles.isNotEmpty)
              SettingsRow(
                label: 'Open links in',
                description: 'Chrome profile for this project\'s merge requests, tickets and documents.',
                trailing: DropdownButton<String?>(
                  value: profiles.any((x) => x.dir == pr.browserProfile) ? pr.browserProfile : null,
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(child: Text('Same as Actions')),
                    for (final x in profiles) DropdownMenuItem(value: x.dir, child: Text('Chrome: ${x.name}')),
                  ],
                  onChanged: (v) => set(pr.copyWith(browserProfile: v)),
                ),
              ),
          ],
        ),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: c.red),
          onPressed: () async {
            await ref
                .read(settingsProvider.notifier)
                .save(
                  cfg.copyWith(
                    projects: [
                      for (final x in cfg.projects)
                        if (x.id != pr.id) x,
                    ],
                  ),
                );
            onDeleted();
          },
          icon: const Icon(Icons.delete_outline_rounded, size: 18),
          label: const Text('Remove Project'),
        ),
      ],
    );
  }
}

class ClaudePane extends ConsumerWidget {
  const ClaudePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(settingsProvider).requireValue;
    final cl = cfg.claude;
    final save = ref.read(settingsProvider.notifier).save;
    final spent = ref.watch(boardProvider).hasValue ? ref.read(boardProvider.notifier).spentToday : 0.0;
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(
          context,
          'Claude',
          'The background sessions: one fetches Slack, mail and other connector sources and judges what needs you, '
              'the other reads a project\'s code to draw its map.',
          icon: AccentIcon(Icons.auto_awesome_outlined, c.orange, size: 40),
        ),
        SettingsGroup(
          title: 'Background session',
          children: [
            SettingsRow(
              label: 'Model for pulling data',
              description: 'Haiku is enough to judge messages, and costs least.',
              trailing: DropdownButton<String>(
                value: cl.model,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'haiku', child: Text('Haiku')),
                  DropdownMenuItem(value: 'sonnet', child: Text('Sonnet')),
                  DropdownMenuItem(value: 'opus', child: Text('Opus')),
                ],
                onChanged: (v) => save(cfg.copyWith(claude: cl.copyWith(model: v!))),
              ),
            ),
            SettingsRow(
              label: 'Model for code',
              description: 'Reads the whole repository to draw the project map. A strong model draws a better map.',
              trailing: DropdownButton<String>(
                value: cl.codeModel,
                underline: const SizedBox(),
                items: [
                  for (final MapEntry(key: id, value: name) in _codeModels.entries) DropdownMenuItem(value: id, child: Text(name)),
                  // A model set by hand in deck.json still shows.
                  if (!_codeModels.containsKey(cl.codeModel)) DropdownMenuItem(value: cl.codeModel, child: Text(cl.codeModel)),
                ],
                onChanged: (v) => save(cfg.copyWith(claude: cl.copyWith(codeModel: v!))),
              ),
            ),
            SettingsRow(
              label: 'Review skills',
              description: 'Run to find issues in a merge request, comma separated, each with its arguments. Empty: Deck\'s own method.',
              trailing: CommitField(
                width: 260,
                mono: true,
                value: cl.reviewSkills.join(', '),
                hint: 'code-review high, ponytail:ponytail-review',
                onCommit: (v) => save(
                  cfg.copyWith(
                    claude: cl.copyWith(
                      reviewSkills: [
                        for (final s in v.split(','))
                          if (s.trim().replaceFirst('/', '') case final t when t.isNotEmpty) t,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SettingsRow(
              label: 'Refresh every',
              trailing: DropdownButton<int>(
                value: cl.refreshMinutes,
                underline: const SizedBox(),
                items: [
                  for (final m in const [15, 30, 60, 120])
                    DropdownMenuItem(value: m, child: Text(m < 60 ? '$m minutes' : '${m ~/ 60} hour${m > 60 ? 's' : ''}')),
                ],
                onChanged: (v) => save(cfg.copyWith(claude: cl.copyWith(refreshMinutes: v!))),
              ),
            ),
            SettingsRow(
              label: 'Daily budget',
              description: 'Spent today: \$${spent.toStringAsFixed(3)}. Background runs stop once the budget is spent.',
              trailing: CommitField(
                width: 90,
                value: cl.dailyBudgetUsd.toStringAsFixed(2),
                onCommit: (v) {
                  final d = double.tryParse(v.replaceAll('\$', ''));
                  if (d != null && d >= 0) save(cfg.copyWith(claude: cl.copyWith(dailyBudgetUsd: d)));
                },
              ),
            ),
            SettingsRow(
              label: 'Ask before other tools',
              description: 'When a background session wants a tool it was not given, Quarterdeck asks you. Off: always deny.',
              trailing: Switch(
                value: cl.askPermission,
                onChanged: (v) => save(cfg.copyWith(claude: cl.copyWith(askPermission: v))),
              ),
            ),
            SettingsRow(
              label: 'Keep a run log',
              description:
                  'Every background session\'s time, cost, errors and output, and the problems it reports, go to cache/runs/ '
                  'for the deck-insights skill.',
              trailing: Switch(
                value: cl.collectRuns,
                onChanged: (v) => save(cfg.copyWith(claude: cl.copyWith(collectRuns: v))),
              ),
            ),
          ],
        ),
        const ToolRulesGroups(),
        const RunsGroup(),
      ],
    );
  }
}

/// Background Claude runs, newest first; only those that fetched [provider]
/// when set. Open resumes a run's session to read what it did.
class RunsGroup extends ConsumerWidget {
  const RunsGroup({super.key, this.provider});

  final String? provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(settingsProvider).requireValue.actions;
    final runs = [
      for (final r in ref.watch(boardProvider).value?.runs ?? const <ClaudeRun>[])
        if (provider == null || r.providers.contains(provider)) r,
    ];
    final c = context.c;
    return SettingsGroup(
      title: 'Recent runs',
      children: [
        if (runs.isEmpty) const SettingsRow(label: 'No run yet'),
        for (final r in runs.reversed.take(8))
          SettingsRow(
            label: '${clockTime(r.at)}  ·  ${r.providers.join(', ')}',
            description: r.error ?? '${r.seconds} s  ·  \$${r.costUsd.toStringAsFixed(3)}',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (r.sessionId case final id?)
                  TextButton(
                    // Same locked flags as the run: it read Slack and mail text.
                    onPressed: () => resumeWorker(
                      id,
                      ref.read(homeProvider),
                      actions,
                      ref.read(terminalsProvider.notifier),
                      info: TermInfo(title: r.providers.join(', '), action: 'Run', detail: 'Fetch at ${clockTime(r.at)}'),
                    ),
                    child: const Text('Open'),
                  ),
                Icon(r.error == null ? Icons.check_circle : Icons.error, size: 16, color: r.error == null ? c.green : c.red),
              ],
            ),
          ),
      ],
    );
  }
}

class ActionsPane extends ConsumerWidget {
  const ActionsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(settingsProvider).requireValue;
    final a = cfg.actions;
    final save = ref.read(settingsProvider.notifier).save;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context, 'Actions', 'What the buttons on a card start.', icon: AccentIcon(Icons.play_arrow_rounded, context.c.green, size: 40)),
        SettingsGroup(
          title: 'Apps',
          children: [
            SettingsRow(
              label: 'IDE command',
              description: 'Opens the project folder: idea, code, cursor… A project can set its own.',
              trailing: CommitField(
                width: 160,
                mono: true,
                value: a.ide,
                onCommit: (v) => v.isEmpty ? null : save(cfg.copyWith(actions: a.copyWith(ide: v))),
              ),
            ),
            if (ref.watch(chromeProfileListProvider) case final profiles when profiles.isNotEmpty)
              SettingsRow(
                label: 'Open links in',
                description: 'For every link. A project can set its own.',
                trailing: DropdownButton<String?>(
                  value: profiles.any((x) => x.dir == a.browserProfile) ? a.browserProfile : null,
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(child: Text('Default browser')),
                    for (final x in profiles) DropdownMenuItem(value: x.dir, child: Text('Chrome: ${x.name}')),
                  ],
                  onChanged: (v) => save(cfg.copyWith(actions: a.copyWith(browserProfile: v))),
                ),
              ),
            if (Platform.isMacOS)
              SettingsRow(
                label: 'Terminal',
                trailing: DropdownButton<String>(
                  value: a.terminal,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'Terminal', child: Text('Terminal')),
                    DropdownMenuItem(value: 'iTerm', child: Text('iTerm')),
                    DropdownMenuItem(value: 'Deck', child: Text('Inside Deck')),
                  ],
                  onChanged: (v) => save(cfg.copyWith(actions: a.copyWith(terminal: v!))),
                ),
              ),
            if (a.terminal == 'Deck')
              SettingsRow(
                label: 'Panel',
                description: 'Also in the menu of the panel itself.',
                trailing: DropdownButton<String>(
                  value: a.terminalDock,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'bottom', child: Text('Bottom')),
                    DropdownMenuItem(value: 'right', child: Text('Right')),
                  ],
                  onChanged: (v) => save(cfg.copyWith(actions: a.copyWith(terminalDock: v!))),
                ),
              ),
            if ((Platform.isMacOS || Platform.isWindows) && a.terminal != 'Deck')
              SettingsRow(
                label: 'Open in',
                description: 'A new tab works in iTerm and Windows Terminal. Terminal.app always opens a new window.',
                trailing: DropdownButton<bool>(
                  value: a.newTab,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: false, child: Text('New window')),
                    DropdownMenuItem(value: true, child: Text('New tab')),
                  ],
                  onChanged: (v) => save(cfg.copyWith(actions: a.copyWith(newTab: v!))),
                ),
              ),
          ],
        ),
        SettingsGroup(
          title: 'Review',
          footer: 'Review runs only for a project with no repository set: the others review in Quarterdeck. {url} is the merge request link, {iid} its number. Runs in the project folder.',
          children: [
            SettingsRow(
              label: 'Review',
              below: CommitField(
                mono: true,
                value: a.review,
                onCommit: (v) => save(cfg.copyWith(actions: a.copyWith(review: v))),
              ),
            ),
            SettingsRow(
              label: 'Feedback on my MR',
              below: CommitField(
                mono: true,
                value: a.feedback,
                onCommit: (v) => save(cfg.copyWith(actions: a.copyWith(feedback: v))),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
