// A todo added by any Claude session through deck_add_todo.
import '../models/card.dart';

/// [key] is set when the same todo can arrive again, so it is added once.
DeckCard classifyTodo(Map<String, Object?> todo, DateTime now, {String? key}) {
  final source = (todo['source'] as String?)?.toLowerCase();
  final from = todo['from'] as String?;
  final label = sourceNames[source] ?? 'Deck';
  return DeckCard(
    key: key ?? 'todo:${now.microsecondsSinceEpoch}',
    provider: 'todo',
    lane: Lane.task,
    ref: from == null || from.isEmpty ? label : '$label · $from',
    url: (todo['url'] as String?) ?? '',
    source: source,
    author: from,
    // A Slack channel ties the todo to its project.
    channel: source == 'slack' && (from?.startsWith('#') ?? false) ? from : null,
    title: '${todo['title']}',
    next: '${todo['need']}',
    bucket: Bucket.action,
    score: 60,
    updatedAt: now,
  );
}
