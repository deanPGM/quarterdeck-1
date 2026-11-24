import 'models/card.dart';
import 'models/config.dart';

const otherProject = 'other';

/// Projects a card belongs to: by repo, board or channel, or the project
/// Claude named for a message. "other" when none matches.
List<String> projectsOf(DeckCard c, List<ProjectConfig> projects) {
  final ids = [
    for (final p in projects)
      if ((c.path != null && p.repo == '${c.provider}:${c.path}') ||
          (c.provider == 'jira' && p.board == 'jira:${c.ref.split('-').first}') ||
          (c.path != null && p.board == '${c.provider}:${c.path}') ||
          (c.channel != null && p.channels.contains(c.channel)) ||
          c.project == p.id)
        p.id,
  ];
  return ids.isEmpty ? const [otherProject] : ids;
}

/// The project to work in for a card: the first matching project with a folder.
ProjectConfig? workProject(DeckCard c, List<ProjectConfig> projects) {
  final ids = projectsOf(c, projects);
  for (final p in projects) {
    if (ids.contains(p.id) && p.dir != null && p.dir!.isNotEmpty) return p;
  }
  return null;
}

/// The Chrome profile for a card's link: the first matching project that sets
/// one, else the one in Actions.
String? browserProfile(DeckCard c, DeckConfig cfg) {
  final ids = projectsOf(c, cfg.projects);
  return cfg.projects.where((p) => ids.contains(p.id) && p.browserProfile != null).firstOrNull?.browserProfile ?? cfg.actions.browserProfile;
}

/// The folder to work in for a card.
String? projectDir(DeckCard c, List<ProjectConfig> projects) => workProject(c, projects)?.dir;

/// Turns "Acme VPN" into "acme-vpn".
String slug(String name) {
  final s = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
  return s.isEmpty ? 'project' : s;
}
