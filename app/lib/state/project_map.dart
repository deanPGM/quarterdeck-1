// The feature map of each project: read from `.skim/map/` in the project
// folder, drawn by a background Claude session Deck starts there, and read
// again each time that session (or any other) writes through the map tools.
import 'dart:async';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../claude/map_task.dart';
import '../claude/worker.dart';
import '../core/map/models.dart';
import '../core/models/config.dart';
import '../data/deck_home.dart';
import '../data/map_store.dart';
import '../mcp/map_tools.dart';
import 'board.dart';
import 'notices.dart';
import 'session_run.dart';
import 'settings.dart';

part 'project_map.g.dart';

/// The map of one project. Null when the project has no folder, or the
/// folder is not a git repository.
@riverpod
Future<FeatureMap?> projectMap(Ref ref, String id) async {
  final cfg = await ref.watch(settingsProvider.future);
  final dir = _dirOf(cfg, id);
  if (dir == null || !Directory(dir).existsSync()) return null;
  try {
    return await MapStore(dir).readMap();
  } on ProcessException {
    return null;
  }
}

String? _dirOf(DeckConfig cfg, String id) {
  final dir = cfg.projects.where((p) => p.id == id).firstOrNull?.dir;
  return dir == null ? null : expandHome(dir);
}

const readOnlyGit = ['ls-files', 'diff', 'log', 'show', 'rev-parse', 'status', 'grep'];

const _mapTools = [
  'get_map',
  'get_map_feature',
  'set_map_feature',
  'confirm_map_feature',
  'remove_map_feature',
  'get_map_data',
  'set_map_data',
  'remove_map_data',
  'stamp_map',
  'plan_map',
  'get_map_architecture',
  'set_map_architecture',
  'get_map_ui',
  'set_map_ui',
];

/// What a map run draws: the whole map, or one page of a map already drawn.
enum MapPart { all, architecture, ui }

/// The map runs, by project id. Also what the map tools of the Deck MCP
/// server reach.
@Riverpod(keepAlive: true)
class ProjectMaps extends _$ProjectMaps implements MapBackend {
  final _stops = <String, Completer<void>>{};

  @override
  Map<String, SessionRun> build() => const {};

  DeckConfig? get _cfg => ref.read(settingsProvider).value;

  @override
  List<String> mapProjects() => [
    for (final p in _cfg?.projects ?? const <ProjectConfig>[])
      if (p.dir != null) p.id,
  ];

  @override
  MapStore? mapOf(String id) {
    final cfg = _cfg;
    final dir = cfg == null ? null : _dirOf(cfg, id);
    return dir == null ? null : MapStore(dir);
  }

  @override
  void mapChanged(String project) => ref.invalidate(projectMapProvider(project));

  @override
  void mapPlanned(String project, List<String> features) {
    final run = state[project];
    if (run == null || !run.running) return;
    _set(project, run.copyWith(total: features.length, countingSince: run.countingSince ?? DateTime.now()));
  }

  @override
  void mapFeatureDone(String project, String id) {
    final run = state[project];
    if (run == null || !run.running) return;
    _set(project, run.copyWith(done: {...run.done, id}));
  }

  /// Starts a session that creates or updates the map of [id]. One at a time
  /// per project.
  /// With [part], it writes only that page.
  Future<void> draw(String id, {MapPart part = MapPart.all}) async {
    if (state[id]?.running ?? false) return;
    final cfg = await ref.read(settingsProvider.future);
    final dir = _dirOf(cfg, id);
    if (dir == null) return;
    // A stopped pass left its plan: count from where it was.
    final before = await MapStore(dir).readMap().then<FeatureMap?>((m) => m, onError: (_) => null);
    final plan = before?.plan ?? const <String>[];
    final now = DateTime.now();
    _set(
      id,
      SessionRun(
        startedAt: now,
        step: switch (part) {
          MapPart.architecture => 'Reading the architecture docs',
          MapPart.ui => 'Reading the UI guidelines',
          MapPart.all => plan.isEmpty ? 'Starting' : 'Resuming',
        },
        total: plan.isEmpty ? null : plan.length,
        done: {...plan.where((f) => !before!.planLeft.contains(f))},
        countingSince: plan.isEmpty ? null : now,
      ),
    );
    final stop = _stops[id] = Completer<void>();
    final result = await runSession(
      home: ref.read(homeProvider),
      kind: 'map:${part.name}',
      subject: id,
      prompt: switch (part) {
        MapPart.architecture => architecturePrompt,
        MapPart.ui => uiPrompt,
        MapPart.all => mapPrompt,
      },
      providers: const ['map'],
      model: cfg.claude.codeModel,
      dir: dir,
      mcpUrl: 'http://127.0.0.1:$mcpPort/mcp?project=${Uri.encodeQueryComponent(id)}',
      // Files and sub agents to read the code; no edits, no web.
      flags: const ['--disable-slash-commands', '--tools', 'Read,Grep,Glob,Bash,Agent,ToolSearch', '--permission-mode', 'auto'],
      tools: {'Read', 'Grep', 'Glob', 'Agent', ...gitTools(readOnlyGit), for (final t in _mapTools) 'mcp__deck__$t', ...cfg.claude.allowedTools},
      // A pass longer than this resumes from its plan.
      timeout: const Duration(minutes: 120),
      stop: stop.future,
      onEvent: (ev) {
        final step = stepOf(ev);
        final run = state[id];
        if (step != null && run != null && run.running) _set(id, run.copyWith(step: step));
      },
    );
    _stops.remove(id);
    _set(id, state[id]!.copyWith(step: result.error ?? 'Done', result: result));
    mapChanged(id);
    if (result.error != 'Stopped.') {
      final name = cfg.projects.where((x) => x.id == id).firstOrNull?.name ?? id;
      ref
          .read(noticesProvider.notifier)
          .add(
            NoticeKind.session,
            result.error == null ? 'Project map done' : 'Project map failed',
            body: result.error == null ? name : '$name: ${result.error}',
            route: '/project/$id',
            error: result.error != null,
            toast: true,
          );
    }
  }

  /// Stops the map session of [id]. What it drew stays, and its plan says
  /// what is left for the next one.
  void stop(String id) {
    final c = _stops[id];
    if (c != null && !c.isCompleted) c.complete();
  }

  void _set(String id, SessionRun run) => state = {...state, id: run};
}
