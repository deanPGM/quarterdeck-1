// One project: its Overview (what changed, the Facts), its architecture and UI
// checked against their guidelines, its feature map (every feature drawn as a class graph,
// sequences and state machines, plus the data types that cross a boundary)
// and its open merge requests. Opened from the board's sidebar.
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/map/models.dart';
import '../../core/models/config.dart';
import '../../state/project_info.dart';
import '../../state/project_map.dart';
import '../../state/project_mrs.dart';
import '../../state/project_overview.dart';
import '../../state/project_talks.dart';
import '../../state/terminals.dart';
import '../../state/settings.dart';
import '../../core/classify/time.dart';
import '../../core/meetings.dart' show clockTime;
import '../common.dart';
import '../parts.dart';
import '../theme.dart';
import '../worktrees.dart';
import 'architecture_page.dart';
import 'feature_page.dart';
import 'map_overview.dart';
import 'mrs_pane.dart';
import 'overview_page.dart';
import 'project_logo.dart';
import 'ui_page.dart';

/// Where the project page is: the map overview, one feature, one data type,
/// or the merge requests.
sealed class ProjectPlace {
  const ProjectPlace();

  /// From the page URL: ?feature=, ?data= or ?tab=. Anything else is the
  /// Overview.
  factory ProjectPlace.of(Map<String, String> q) => switch (q) {
    {'tab': 'features'} => const FeaturesPlace(),
    {'feature': final id} => FeaturePlace(id),
    {'data': final id} => DataPlace(id),
    {'tab': 'mrs'} => const MrsPlace(),
    {'tab': 'architecture'} => const ArchitecturePlace(),
    {'tab': 'ui'} => const UiPlace(),
    _ => const OverviewPlace(),
  };

  Map<String, String> get query;
}

/// What changed and the Facts: the page a project opens on.
class OverviewPlace extends ProjectPlace {
  const OverviewPlace();
  // Not empty: a bare project link opens the last section instead.
  @override
  Map<String, String> get query => const {'tab': 'overview'};
}

class FeaturesPlace extends ProjectPlace {
  const FeaturesPlace();
  @override
  Map<String, String> get query => const {'tab': 'features'};
}

class FeaturePlace extends ProjectPlace {
  const FeaturePlace(this.id);
  final String id;
  @override
  Map<String, String> get query => {'feature': id};
}

class DataPlace extends ProjectPlace {
  const DataPlace(this.id);
  final String id;
  @override
  Map<String, String> get query => {'data': id};
}

class ArchitecturePlace extends ProjectPlace {
  const ArchitecturePlace();
  @override
  Map<String, String> get query => const {'tab': 'architecture'};
}

class UiPlace extends ProjectPlace {
  const UiPlace();
  @override
  Map<String, String> get query => const {'tab': 'ui'};
}

class MrsPlace extends ProjectPlace {
  const MrsPlace();
  @override
  Map<String, String> get query => const {'tab': 'mrs'};
}

/// Goes to [place] of project [id], or to the section you left it on.
void goProject(BuildContext context, String id, [ProjectPlace? place]) => context.go(Uri(path: '/project/$id', queryParameters: place?.query).toString());

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key, required this.id, required this.place});

  final String id;
  final ProjectPlace place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(settingsProvider).value;
    final project = cfg?.projects.where((p) => p.id == id).firstOrNull;
    if (cfg == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (project == null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.folder_off_outlined,
          title: 'No project "$id"',
          action: FilledButton(onPressed: () => context.go('/'), child: const Text('Back to Board')),
        ),
      );
    }
    final map = ref.watch(projectMapProvider(id));
    final run = ref.watch(projectMapsProvider)[id];
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Sidebar(project: project, place: place, map: map.value),
          Expanded(
            child: switch (place) {
              OverviewPlace() => OverviewPage(project: project),
              MrsPlace() => MrsPane(project: project),
              _ when project.dir == null => const _NoFolder(),
              _ when map.isLoading && !map.hasValue => const Center(child: CircularProgressIndicator()),
              _ when map.value == null => const _NoFolder(git: true),
              FeaturePlace(:final id) => FeaturePage(project: project, map: map.value!, featureId: id),
              DataPlace(:final id) => DataTypePage(project: project, map: map.value!, typeId: id),
              FeaturesPlace() => MapOverview(project: project, map: map.value!, run: run),
              ArchitecturePlace() => ArchitecturePage(project: project, map: map.value!, run: run),
              UiPlace() => UiPage(project: project, map: map.value!, run: run),
            },
          ),
        ],
      ),
    );
  }
}

class _NoFolder extends StatelessWidget {
  const _NoFolder({this.git = false});

  final bool git;

  @override
  Widget build(BuildContext context) => EmptyState(
    icon: Icons.folder_off_outlined,
    title: git ? 'The project folder is not a git repository' : 'This project has no folder',
    text: 'The map is drawn from the code in the project folder.',
    action: FilledButton(onPressed: () => context.go('/settings'), child: const Text('Open Settings')),
  );
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.project, required this.place, required this.map});

  final ProjectConfig project;
  final ProjectPlace place;
  final FeatureMap? map;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    final mrs = ref.watch(projectMrsProvider(project.id)).value;
    final stale = {...?map?.staleFeatures, ...?map?.staleData.map((d) => 'data/$d')};

    Widget row(ProjectPlace to, String label, {IconData? icon, String? trailing, bool dim = false, bool warn = false}) {
      final on = switch ((place, to)) {
        (FeaturePlace(:final id), FeaturePlace(id: final other)) => id == other,
        (DataPlace(:final id), DataPlace(id: final other)) => id == other,
        (OverviewPlace(), OverviewPlace()) ||
        (FeaturesPlace(), FeaturesPlace()) ||
        (MrsPlace(), MrsPlace()) ||
        (ArchitecturePlace(), ArchitecturePlace()) ||
        (UiPlace(), UiPlace()) => true,
        _ => false,
      };
      return SidebarRow(
        label: label,
        selected: on,
        dim: dim,
        leading: icon == null ? null : Icon(icon, size: 16, color: c.label2),
        trailing: warn
            ? Tooltip(
                message: 'Changed since it was drawn',
                child: Icon(Icons.history_toggle_off_rounded, size: 14, color: c.orange),
              )
            : trailing == null
            ? null
            : Text(trailing, style: context.t.bodySmall),
        onTap: () => goProject(context, project.id, to),
      );
    }

    return Material(
      color: c.sidebar,
      child: SizedBox(
        width: 252,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
          children: [
            SidebarBack(label: const Text('Board'), onPressed: () => context.go('/')),
            _Switcher(project: project),
            if (project.repo != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: Text(project.repo!.split(':').last, style: context.t.bodySmall, overflow: TextOverflow.ellipsis),
              ),
            _Talks(project: project),
            if (project.dir != null) WorktreeList(project: project),
            const SizedBox(height: 8),
            row(
              const OverviewPlace(),
              'Overview',
              icon: Icons.article_outlined,
              trailing: switch (ref.watch(projectNewCountProvider(project.id)).value) {
                final n? when n > 0 => '$n new',
                _ => null,
              },
            ),
            row(
              const ArchitecturePlace(),
              'Architecture',
              icon: Icons.account_tree_outlined,
              warn: map?.staleArchitecture ?? false,
              trailing: map?.architecture == null ? null : '${map!.architecture!.violations.where((v) => v.severity != 'accepted').length} ⚠',
            ),
            row(const UiPlace(), 'UI', icon: Icons.palette_outlined, warn: map?.staleUi ?? false, trailing: map?.ui == null ? null : '${uiIssues(map!.ui!)} ⚠'),
            row(const FeaturesPlace(), 'Features', icon: Icons.map_outlined, trailing: map == null ? null : '${map!.features.length}'),
            row(const MrsPlace(), 'Merge Requests', icon: Icons.merge_type_rounded, trailing: mrs == null ? null : '${mrs.length}'),
            if (map != null && map!.features.isNotEmpty) ...[
              const SidebarSection('Features'),
              for (final f in map!.features) row(FeaturePlace(f.id), f.title, warn: stale.contains(f.id)),
            ],
            if (map != null && map!.dataTypes.isNotEmpty) ...[
              const SidebarSection('Data types'),
              for (final d in map!.dataTypes) row(DataPlace(d.id), d.name, dim: true, warn: stale.contains('data/${d.id}')),
            ],
          ],
        ),
      ),
    );
  }
}

/// The project's name, and a menu of the others: picking one opens it on the
/// section you left it on.
class _Switcher extends ConsumerWidget {
  const _Switcher({required this.project});

  final ProjectConfig project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final projects = ref.watch(settingsProvider).value?.projects ?? const [];
    Widget logo(ProjectConfig p, double size) => ProjectLogo(
      file: logoFile(home, p),
      platforms: p.platforms,
      size: size,
      fallback: Icon(Icons.folder_outlined, size: size * .8, color: context.c.label2),
    );
    return PopupMenuButton<String>(
      tooltip: 'Switch project',
      position: PopupMenuPosition.under,
      onSelected: (id) => goProject(context, id),
      itemBuilder: (_) => [
        for (final p in projects)
          PopupMenuItem(
            value: p.id,
            enabled: p.id != project.id,
            child: Row(
              children: [
                logo(p, 20),
                const SizedBox(width: 10),
                Expanded(child: Text(p.name, overflow: TextOverflow.ellipsis)),
                if (p.id == project.id) Icon(Icons.check_rounded, size: 16, color: context.c.label2),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
        child: Row(
          children: [
            if (logoFile(home, project) != null) ...[logo(project, 24), const SizedBox(width: 8)],
            Flexible(
              child: Text(
                project.name,
                overflow: TextOverflow.ellipsis,
                style: context.t.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.unfold_more_rounded, size: 16, color: context.c.label2),
          ],
        ),
      ),
    );
  }
}

/// `Talk about <project>` and the talks so far: Show the running ones, Resume
/// the others.
class _Talks extends ConsumerWidget {
  const _Talks({required this.project});

  final ProjectConfig project;

  Future<void> _open(BuildContext context, WidgetRef ref, {String? resume}) async {
    try {
      await ref.read(projectTalkerProvider.notifier).open(project, resume: resume);
    } catch (e) {
      if (context.mounted) {
        showToast(context, 'Could not start the talk: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.c;
    final talks = ref.watch(projectTalksProvider(project.id)).value ?? const [];
    final terms = ref.watch(terminalsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.tonalIcon(
            onPressed: project.dir == null ? null : () => _open(context, ref),
            icon: const Icon(Icons.forum_outlined, size: 16),
            label: Text('Talk about ${project.name}', overflow: TextOverflow.ellipsis),
          ),
          for (final t in talks.take(4))
            Builder(
              builder: (context) {
                final tab = terms.running(talkKey(project.id, t.id));
                return Padding(
                  padding: const EdgeInsets.only(left: 6, top: 2),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 3.5, backgroundColor: tab == null ? c.label3 : (tab.waiting ? c.orange : c.green)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${ago(t.at, clock.now())} ${clockTime(t.at)}',
                          overflow: TextOverflow.ellipsis,
                          style: context.t.bodySmall?.copyWith(color: c.label),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact, textStyle: context.t.labelMedium),
                        onPressed: tab != null ? () => ref.read(terminalsProvider.notifier).focus(tab) : () => _open(context, ref, resume: t.id),
                        child: Text(tab != null ? 'Show' : 'Resume'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
