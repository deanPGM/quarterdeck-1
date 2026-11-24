// Jira issue → card. Rules ported from the Work Queue artifact. GitLab and
// GitHub issues from a project's task board use the same rules, with
// "group/project#12" as their key.
import '../models/card.dart';
import '../models/records.dart';
import 'time.dart';

DeckCard classifyIssue(IssueRecord i, DateTime now, {String escalationType = 'Customer Escalation', String provider = 'jira'}) {
  final st = i.status;
  final idle = i.updated == null ? 0 : daysSince(i.updated!, now);
  final tags = <CardTag>[CardTag(TagTone.neutral, st)];
  late String next;
  String? why;
  var bucket = Bucket.action;
  late int score;
  final esc = i.type == escalationType;
  final c = i.lastComment;
  if (esc) tags.insert(0, CardTag(TagTone.act, escalationType));
  if (idle >= 14) tags.add(CardTag(TagTone.warn, 'Idle ${idle}d'));

  if (esc) {
    if (c == null && i.created == null) {
      // Jira sent no dates and no comments: we cannot tell who waits.
      score = 60;
      next = 'Check the last comment on the ticket.';
    } else if (c == null) {
      final age = daysSince(i.created!, now);
      score = 80 + (age < 10 ? age : 10);
      next = 'Post a first reply on the ticket.';
      tags.add(const CardTag(TagTone.warn, 'No comments'));
    } else if (c.mine) {
      final d = daysSince(c.at, now);
      if (d >= 7) {
        score = 48;
        next = 'Post a status update. Your last reply was $d days ago.';
      } else {
        bucket = Bucket.blocked;
        score = d;
        next = 'Waits for CS or the customer. You replied ${ago(c.at, now)}.';
      }
    } else {
      score = 84;
      next = 'Answer ${c.author ?? 'the last comment'}.';
      tags.add(const CardTag(TagTone.act, 'Comment waits on you'));
      why = 'Last comment ${ago(c.at, now)}.';
    }
  } else if (st == 'Implementation Done') {
    score = 30;
    next = 'Move it to the next status.';
  } else if (st == 'In Review') {
    if (idle > 21) {
      score = 18;
      next = 'Check that its MR merged. Close it or ask for a review.';
    } else {
      bucket = Bucket.blocked;
      score = idle;
      next = 'Waits for review.';
    }
  } else if (st == 'Blocked') {
    bucket = Bucket.blocked;
    score = idle;
    next = 'Blocked. Check that the blocker still holds.';
  } else if (i.statusCategory == 'new') {
    score = st == 'Backlog' ? 8 : 14;
    next = st == 'Backlog' ? 'Close it or give it to another person.' : 'Plan it.';
  } else {
    score = idle > 21 ? 20 : 40;
    next = idle > 21 ? 'Confirm that you still work on it.' : 'Continue the work.';
  }
  return DeckCard(
    key: '$provider:${i.key}',
    provider: provider,
    lane: Lane.task,
    ref: i.key.split('/').last,
    path: i.key.contains('#') ? i.key.split('#').first : null,
    url: i.url,
    title: i.summary,
    next: next,
    why: why,
    tags: tags,
    bucket: bucket,
    score: score,
    updatedAt: i.updated,
  );
}

/// A GitLab or GitHub issue has labels, not a status: read one from them.
(String status, String category) statusFromLabels(List<String> labels) {
  bool has(String re) => labels.any((l) => RegExp(re, caseSensitive: false).hasMatch(l));
  if (has('block')) return ('Blocked', 'indeterminate');
  if (has('review')) return ('In Review', 'indeterminate');
  if (has('progress|doing')) return ('In Progress', 'indeterminate');
  return ('Open', 'new');
}

IssueRecord boardIssue({
  required String key,
  required String title,
  required String url,
  required List<String> labels,
  required String createdAt,
  required String updatedAt,
}) {
  final (status, category) = statusFromLabels(labels);
  return IssueRecord(
    key: key,
    summary: title,
    url: url,
    status: status,
    statusCategory: category,
    type: 'Issue',
    created: DateTime.parse(createdAt),
    updated: DateTime.parse(updatedAt),
  );
}
