// The project info run: a background Claude session in the project folder
// that finds the product name, aliases, icon, platforms, task board, Slack
// channels and IDE, once when the project is
// added and again on demand. What it saves stays editable in Settings.
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../claude/project_info_task.dart';
import '../claude/worker.dart';
import '../core/models/config.dart';
import '../data/deck_home.dart';
import '../mcp/project_tools.dart';
import '../sources/git.dart';
import '../sources/shell_env.dart';
import 'board.dart' show mcpPort;
import 'forges.dart';
import 'session_run.dart';
import 'settings.dart';

part 'project_info.g.dart';

const _logoTypes = {'.png', '.jpg', '.jpeg', '.webp', '.svg'};

/// The info runs, by project id.
@Riverpod(keepAlive: true)
class ProjectInfos extends _$ProjectInfos implements ProjectInfoBackend {
  @override
  Map<String, SessionRun> build() => const {};

  /// Starts a session that reads project [id] and saves its info. One at a
  /// time per project.
  Future<void> analyze(String id) async {
    if (state[id]?.running ?? false) return;
    final cfg = await ref.read(settingsProvider.future);
    final dir = cfg.projects.where((x) => x.id == id).firstOrNull?.dir;
    if (dir == null || !Directory(expandHome(dir)).existsSync()) return;
    _set(id, SessionRun(startedAt: DateTime.now(), step: 'Starting'));
    // The repo comes from the origin remote, and the board is the repo when
    // its issues are in use: no model needed. Commit prefixes can name a
    // company wide Jira board that is not this project's.
    final repo = await detectRepo(expandHome(dir));
    final board = repo == null ? null : await _forgeBoard(repo);
    if (repo != null) {
      await ref
          .read(settingsProvider.notifier)
          .change(
            (c) => c.copyWith(
              projects: [for (final x in c.projects) x.id == id ? x.copyWith(repo: repo, board: board ?? x.board) : x],
            ),
          );
    }
    if (board != null) _boardSet.add(id);
    final result = await runSession(
      home: ref.read(homeProvider),
      kind: 'project-info',
      subject: id,
      prompt: projectInfoPrompt(p.basename(expandHome(dir)), board: board),
      providers: const ['project'],
      model: cfg.claude.model,
      dir: expandHome(dir),
      mcpUrl: 'http://127.0.0.1:$mcpPort/mcp?project=${Uri.encodeQueryComponent(id)}',
      flags: const ['--disable-slash-commands', '--tools', 'Read,Grep,Glob,Bash,Agent,ToolSearch', '--permission-mode', 'auto'],
      tools: {
        'Read',
        'Grep',
        'Glob',
        'Agent',
        ...gitTools(readOnlyGit),
        // To find the project's channels, by name and by what is said in them.
        'mcp__claude_ai_Slack__slack_search_channels',
        'mcp__claude_ai_Slack__slack_search_public_and_private',
        'mcp__deck__set_project_info',
        ...cfg.claude.allowedTools,
      },
      timeout: const Duration(minutes: 10),
      onEvent: (ev) {
        final step = stepOf(ev);
        final run = state[id];
        if (step != null && run != null && run.running) _set(id, run.copyWith(step: step));
      },
    );
    _boardSet.remove(id);
    _set(id, state[id]!.copyWith(step: result.error ?? 'Done', result: result));
  }

  /// Projects whose board Deck set from the forge in the run now going.
  final _boardSet = <String>{};

  /// "gitlab:group/project" when [repo]'s issues are in use, else null.
  Future<String?> _forgeBoard(String repo) async {
    final (provider, path) = (repo.split(':').first, repo.substring(repo.indexOf(':') + 1));
    try {
      final used = provider == 'gitlab' ? await ref.read(gitlabSourceProvider).usesIssues(path) : await ref.read(githubSourceProvider).usesIssues(path);
      return used ? repo : null;
    } catch (_) {
      // No CLI or no access: Claude looks for a Jira key instead.
      return null;
    }
  }

  @override
  Future<String?> setProjectInfo(String id, ProjectInfo info) async {
    final cfg = await ref.read(settingsProvider.future);
    final pr = cfg.projects.where((x) => x.id == id).firstOrNull;
    if (pr == null) return 'No project "$id" in Deck.';
    String? logo;
    if (info.logo case final path?) {
      final src = File(p.isAbsolute(path) ? path : p.join(expandHome(pr.dir ?? ''), path));
      final ext = p.extension(src.path).toLowerCase();
      if (!_logoTypes.contains(ext)) return 'The logo must be a PNG, JPEG, WebP or SVG file, not $ext.';
      if (!src.existsSync()) return 'No file at ${src.path}.';
      logo = await importLogo(id, src.path);
    }
    final board = !_boardSet.contains(id) && info.board != null && RegExp(r'^(jira|gitlab|github):\S+$').hasMatch(info.board!) ? info.board : null;
    // An IDE that is not installed would fail on the first click.
    final ide = info.ide != null && await onPath(info.ide!) ? info.ide : null;
    // What the run found replaces what was there; what it did not find stays.
    ProjectConfig merge(ProjectConfig x) => x.copyWith(
      name: info.name,
      description: info.description ?? x.description,
      aliases: info.aliases.isEmpty ? x.aliases : info.aliases,
      logo: logo ?? x.logo,
      platforms: info.platforms.isEmpty ? x.platforms : info.platforms,
      tech: info.tech ?? x.tech,
      board: board ?? x.board,
      channels: info.channels.isEmpty ? x.channels : [for (final c in info.channels) c.startsWith('#') ? c : '#$c'],
      ide: ide ?? x.ide,
    );
    await ref.read(settingsProvider.notifier).change((c) => c.copyWith(projects: [for (final x in c.projects) x.id == id ? merge(x) : x]));
    return null;
  }

  /// Copies image [path] into the state folder as the logo of project [id],
  /// removes the one before, and returns the new file, relative to state/.
  /// A new name each time, so the image cache never shows the old one.
  Future<String> importLogo(String id, String path) async {
    final home = ref.read(homeProvider);
    final cfg = await ref.read(settingsProvider.future);
    final old = cfg.projects.where((x) => x.id == id).firstOrNull?.logo;
    final name = p.join('projects', '$id-${DateTime.now().millisecondsSinceEpoch}${p.extension(path).toLowerCase()}');
    final dest = File(p.join(home.state.path, name));
    await dest.parent.create(recursive: true);
    await File(path).copy(dest.path);
    if (old != null) {
      final f = File(p.join(home.state.path, old));
      if (f.existsSync()) await f.delete();
    }
    return name;
  }

  void _set(String id, SessionRun run) => state = {...state, id: run};
}

/// The absolute path of [project]'s logo, or null when it has none.
String? logoFile(DeckHome home, ProjectConfig project) => project.logo == null ? null : home.inState(project.logo!);
