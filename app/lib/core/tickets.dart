// A task found in Slack, mail or a meeting becomes a ticket on its project's
// board (Jira, GitLab or GitHub issues), so the work is tracked where the team
// sees it. The ticket card then replaces the todo.
import 'models/card.dart';
import 'models/config.dart';
import 'projects.dart';

final _board = RegExp(r'^(jira|gitlab|github):(\S+)$');

/// The board a ticket for [c] goes to ("jira:OM", "gitlab:group/project"),
/// or null when [c] is not a task from a message or a meeting, or its
/// project has no board.
({String provider, String target})? ticketBoard(DeckCard c, List<ProjectConfig> projects) {
  final fromMessage = messageProviders.contains(c.provider) || (c.provider == 'todo' && c.source != null && c.source != 'deck');
  if (c.lane != Lane.task || !fromMessage) return null;
  final ids = projectsOf(c, projects);
  for (final p in projects) {
    if (!ids.contains(p.id)) continue;
    if (_board.firstMatch(p.board ?? '') case final m?) return (provider: m[1]!, target: m[2]!);
  }
  return null;
}

/// The ticket Deck proposes for [c], edited by you before it is made.
({String title, String body}) ticketDraft(DeckCard c) {
  final who = [?c.author, if (c.channel != null && c.channel != c.author && c.channel != 'DM' && !c.channel!.contains('@')) 'in ${c.channel}'].join(' ');
  return (
    title: c.title,
    body: [c.next, if (who.isNotEmpty || c.url.isNotEmpty) 'Raised${who.isEmpty ? '' : ' by $who'}${c.url.isEmpty ? '' : ': ${c.url}'}'].join('\n\n'),
  );
}
