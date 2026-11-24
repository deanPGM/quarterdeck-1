// Merge request → card. Rules ported from the Work Queue artifact.
import '../models/card.dart';
import '../models/records.dart';
import 'time.dart';

String mrKey(String provider, String path, int iid) => '$provider:$path!$iid';

DeckCard classifyMr(MrRecord mr, String me, DateTime now, {String provider = 'gitlab'}) {
  final tags = <CardTag>[];
  late String next;
  String? why;
  late Bucket bucket;
  late int score;
  var reviewable = false, feedback = false;
  final mine = mr.role == MrRole.mine;
  final th = mr.threads;
  List<String> people(ThreadRecord t) => t.people.isEmpty ? [t.start, t.last] : t.people;
  final waitMe = th.where((t) => people(t).contains(me) && t.last != me).length;
  final forMe = th.where((t) => t.last != me).length;
  final mineOpen = th.where((t) => t.start == me).length;
  final approvedByMe = mr.approvers.contains(me);
  final pipe = mr.pipeline.toUpperCase();
  final idle = daysSince(mr.updatedAt, now), age = daysSince(mr.createdAt, now);
  final author = mr.author;

  if (mr.draft) tags.add(const CardTag(TagTone.neutral, 'Draft'));
  if (mr.conflicts) tags.add(const CardTag(TagTone.act, 'Conflicts'));
  if (pipe == 'FAILED') {
    tags.add(const CardTag(TagTone.act, 'Pipeline failed'));
  } else if (pipe == 'SUCCESS') {
    tags.add(const CardTag(TagTone.done, 'Pipeline passed'));
  } else if (pipe.isNotEmpty) {
    tags.add(CardTag(TagTone.neutral, 'Pipeline ${pipe.toLowerCase()}'));
  }
  if (mr.approvers.isNotEmpty) tags.add(CardTag(TagTone.done, 'Approved by ${mr.approvers.join(', ')}'));
  if (th.isNotEmpty) tags.add(CardTag(TagTone.neutral, plural(th.length, 'open thread')));
  if (idle >= 7) tags.add(CardTag(TagTone.warn, 'Idle ${idle}d'));

  if (mine) {
    if (mr.draft) {
      bucket = Bucket.action;
      score = mr.conflicts ? 30 : 25;
      next = mr.conflicts ? 'Rebase the draft and finish it.' : 'Finish the draft and mark it ready.';
      // Early feedback on a draft still waits on you.
      if (forMe > 0) {
        feedback = true;
        next = 'Answer ${plural(forMe, 'review thread')}, then finish the draft.';
      }
    } else if (forMe > 0) {
      feedback = true;
      bucket = Bucket.action;
      score = 82;
      next = 'Answer ${plural(forMe, 'review thread')}.';
      tags.insert(0, CardTag(TagTone.act, '$forMe wait on you'));
    } else if (mr.conflicts) {
      bucket = Bucket.action;
      score = 72;
      next = 'Rebase it.';
    } else if (pipe == 'FAILED') {
      bucket = Bucket.action;
      score = 74;
      next = 'Fix the pipeline.';
    } else if (mr.approved && pipe == 'SUCCESS') {
      bucket = Bucket.action;
      score = 92;
      next = 'Merge it (your decision).';
      tags.insert(0, const CardTag(TagTone.done, 'Ready to merge'));
    } else if (mr.approved) {
      bucket = Bucket.blocked;
      score = idle;
      next = 'Waits for the pipeline to finish.';
    } else if (mr.approvers.isEmpty) {
      bucket = Bucket.blocked;
      score = idle;
      next = 'Waits for a reviewer.';
      if (idle >= 3) tags.insert(0, CardTag(TagTone.warn, 'No review for ${idle}d'));
    } else {
      bucket = Bucket.blocked;
      score = idle;
      next = 'Waits for more approvals.';
    }
  } else {
    if (waitMe > 0) {
      reviewable = true;
      bucket = Bucket.action;
      score = 86;
      next = 'Answer $waitMe ${waitMe == 1 ? 'reply' : 'replies'} in your threads.';
      tags.insert(0, CardTag(TagTone.act, '$waitMe wait on you'));
    } else if (approvedByMe) {
      bucket = Bucket.clear;
      score = 0;
      next = 'You approved it. The author merges.';
    } else if (mineOpen > 0) {
      bucket = Bucket.blocked;
      score = 0;
      next = 'Your ${plural(mineOpen, 'thread')} wait on $author.';
    } else if (mr.conflicts || pipe == 'FAILED') {
      bucket = Bucket.clear;
      score = 0;
      next = '$author must fix the ${mr.conflicts ? 'conflicts' : 'pipeline'} first.';
    } else if (idle > 60) {
      reviewable = true;
      bucket = Bucket.action;
      score = 12;
      next = 'Review it, or ask to be removed as reviewer.';
      why = 'No activity for $idle days.';
    } else if (mr.draft) {
      bucket = Bucket.clear;
      score = 0;
      next = 'Draft. A review is optional.';
    } else {
      reviewable = true;
      bucket = Bucket.action;
      score = 68 + (age < 12 ? age : 12);
      next = 'Review it.';
      why = 'Waiting for your review since ${shortDate(mr.createdAt)}.';
    }
  }
  return DeckCard(
    key: mrKey(provider, mr.path, mr.iid),
    provider: provider,
    lane: mine ? Lane.mine : Lane.review,
    ref: '${mr.path.split('/').last}!${mr.iid}',
    url: mr.url,
    title: mr.title,
    next: next,
    why: why,
    tags: tags,
    bucket: bucket,
    score: score,
    updatedAt: mr.updatedAt,
    author: author,
    path: mr.path,
    iid: mr.iid,
    reviewable: reviewable,
    feedback: feedback,
    refs: [if (mr.branch.isNotEmpty) mr.branch],
  );
}
