// Every open merge request of a project, yours and the ones waiting on your
// review marked. One reviewed in Deck opens its review; the others start one.

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sources/chrome.dart';

import '../../core/classify/time.dart';
import '../../core/models/config.dart';
import '../../core/models/records.dart';
import '../../core/review/review.dart';
import '../../state/project_mrs.dart';
import '../../state/reviews.dart';
import '../../state/session_run.dart';
import '../../state/settings.dart';
import '../review/review_screen.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';

class MrsPane extends ConsumerWidget {
  const MrsPane({super.key, required this.project});

  final ProjectConfig project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mrs = ref.watch(projectMrsProvider(project.id));
    final list = mrs.value ?? const <ProjectMr>[];
    final local = ref.watch(projectCheckoutsProvider(project.id)).value ?? const <LocalCheckout>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: headPadding,
          child: PageHead(
            title: 'Merge Requests',
            subtitle: project.repo == null ? 'Set the repository of this project in Settings.' : '${list.length} open in ${project.repo!.split(':').last}',
            trailing: IconButton(
              tooltip: 'Refresh now',
              onPressed: mrs.isLoading
                  ? null
                  : () {
                      ref.invalidate(projectMrsProvider(project.id));
                      ref.invalidate(projectCheckoutsProvider(project.id));
                    },
              icon: mrs.isLoading ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh_rounded),
            ),
          ),
        ),
        if (mrs.hasError)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text('${mrs.error}', style: context.t.bodySmall?.copyWith(color: context.c.red)),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              if (local.isNotEmpty) ...[
                _Section('Local branches'),
                for (final c in local) ...[_CheckoutTile(checkout: c, project: project), const SizedBox(height: 8)],
                if (list.isNotEmpty) _Section('Merge requests'),
              ],
              for (final (i, mr) in list.indexed) ...[if (i > 0) const SizedBox(height: 8), _MrTile(mr: mr, project: project)],
            ],
          ),
        ),
      ],
    );
  }
}

/// One merge request. Reviewed in Deck already: the row opens that review,
/// the button the merge request on the forge. Not yet: the row does
/// nothing, and two buttons start the review or open the forge.
class _MrTile extends ConsumerStatefulWidget {
  const _MrTile({required this.mr, required this.project});

  final ProjectMr mr;
  final ProjectConfig project;

  @override
  ConsumerState<_MrTile> createState() => _MrTileState();
}

class _MrTileState extends ConsumerState<_MrTile> {
  var _starting = false;

  Future<void> _review({bool own = false}) async {
    final provider = widget.project.repo?.split(':').first ?? 'gitlab';
    setState(() => _starting = true);
    try {
      await startReview(context, ref, widget.project.id, provider, widget.mr.iid, own: own);
    } catch (e) {
      if (mounted) showToast(context, '$e');
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c, mr = widget.mr, project = widget.project;
    Widget badge(String label, Color color) => Padding(padding: const EdgeInsets.only(right: 6), child: StatusTag(label, color));
    final github = project.repo?.startsWith('github:') ?? false;
    final sep = github ? '#' : '!';
    final id = '${project.repo?.split(':').first ?? 'gitlab'}-${mr.iid}';
    final review = project.dir == null ? null : ref.watch(projectReviewsProvider(project.id)).value?.where((r) => r.id == id).firstOrNull;
    final exists = review != null;
    final run = ref.watch(reviewsProvider).runs[(project: project.id, id: id)];
    // Claude working on its review: a spinner says so.
    final working = _starting || (run?.running ?? false);
    final status = review == null ? null : reviewState(review, run);
    final forge = OutlinedButton.icon(
      onPressed: () => openLink(Uri.parse(mr.url), project.browserProfile ?? ref.read(settingsProvider).value?.actions.browserProfile),
      icon: const Icon(Icons.open_in_new_rounded, size: 16),
      label: Text(github ? 'Open in GitHub' : 'Open in GitLab'),
    );
    return ContentCard(
      mouseCursor: exists ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onTap: exists ? _review : null,
      padding: const EdgeInsets.fromLTRB(14, 11, 10, 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (mr.reviewer) badge('Review Asked', c.blue),
                    if (mr.mine) badge('Yours', c.purple),
                    if (mr.draft) badge('Draft', c.graphite),

                    Expanded(
                      child: Text(mr.title, overflow: TextOverflow.ellipsis, style: context.t.titleMedium?.copyWith(fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '$sep${mr.iid} · ${mr.author} · ${mr.branch.isEmpty ? '' : '${mr.branch} · '}updated ${ago(mr.updatedAt, clock.now())}',
                  overflow: TextOverflow.ellipsis,
                  style: context.t.bodySmall,
                ),
                if (status != null) ...[const SizedBox(height: 5), _ReviewState(status)],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (_starting) ...[const SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)), const SizedBox(width: 10)],
          if (exists && !working) ...[
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(backgroundColor: c.red.withValues(alpha: .14), foregroundColor: c.red),
              onPressed: () => deleteReview(context, ref, (project: project.id, id: id)),
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('Delete Review'),
            ),
            const SizedBox(width: 6),
          ],
          if (!exists && project.dir != null) ...[
            FilledButton.tonalIcon(
              onPressed: working ? null : () => _review(own: mr.mine),
              icon: Icon(mr.mine ? Icons.forum_outlined : Icons.rate_review_outlined, size: 16),
              label: Text(mr.mine ? 'Address Feedback' : 'Start Review'),
            ),
            const SizedBox(width: 6),
          ],
          forge,
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
    child: Text(title, style: context.t.titleSmall?.copyWith(color: context.c.label2)),
  );
}

/// A branch checked out in the project folder or a worktree, often where a
/// Claude session worked. Its review diffs the working tree, edits not
/// committed yet included. Reviewed already: the row opens that review.
class _CheckoutTile extends ConsumerStatefulWidget {
  const _CheckoutTile({required this.checkout, required this.project});

  final LocalCheckout checkout;
  final ProjectConfig project;

  @override
  ConsumerState<_CheckoutTile> createState() => _CheckoutTileState();
}

class _CheckoutTileState extends ConsumerState<_CheckoutTile> {
  var _starting = false;

  Future<void> _review() async {
    setState(() => _starting = true);
    try {
      await startLocalReview(context, ref, widget.project.id, widget.checkout.path, widget.checkout.branch);
    } catch (e) {
      if (mounted) showToast(context, '$e');
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c, co = widget.checkout, project = widget.project;
    final id = Reviews.localReviewId(co.branch);
    final review = ref.watch(projectReviewsProvider(project.id)).value?.where((r) => r.id == id).firstOrNull;
    final run = ref.watch(reviewsProvider).runs[(project: project.id, id: id)];
    final working = _starting || (run?.running ?? false);
    final status = review == null ? null : reviewState(review, run);
    String n(int k, String one) => '$k $one${k == 1 ? '' : 's'}';
    return ContentCard(
      mouseCursor: review != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onTap: review != null ? _review : null,
      padding: const EdgeInsets.fromLTRB(14, 11, 10, 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (co.uncommitted > 0) Padding(padding: const EdgeInsets.only(right: 6), child: StatusTag('Not committed', c.orange)),
                    Expanded(
                      child: Text(co.branch, overflow: TextOverflow.ellipsis, style: mono(context.t.titleMedium!.copyWith(fontSize: 13.5))),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  [
                    tildeHome(co.path),
                    if (co.ahead > 0) n(co.ahead, 'commit'),
                    if (co.uncommitted > 0) '${n(co.uncommitted, 'file')} not committed',
                  ].join(' · '),
                  overflow: TextOverflow.ellipsis,
                  style: context.t.bodySmall,
                ),
                if (status != null) ...[const SizedBox(height: 5), _ReviewState(status)],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (_starting) ...[const SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)), const SizedBox(width: 10)],
          if (review != null && !working)
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(backgroundColor: c.red.withValues(alpha: .14), foregroundColor: c.red),
              onPressed: () => deleteReview(context, ref, (project: project.id, id: id)),
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('Delete Review'),
            ),
          if (review == null)
            FilledButton.tonalIcon(
              onPressed: working ? null : _review,
              icon: const Icon(Icons.rate_review_outlined, size: 16),
              label: const Text('Start Review'),
            ),
        ],
      ),
    );
  }
}

/// Where a review stands, most urgent first: Claude working on it, its
/// session stopped, answers waiting for your call, questions waiting on
/// Claude, answers ready to publish, then done.
typedef ReviewState = ({String label, String? detail, ReviewTone tone});

enum ReviewTone { working, you, failed, ready, done }

ReviewState reviewState(Review r, SessionRun? run) {
  final res = run?.result;
  if (run != null && res == null) {
    final what = switch (run.kind) {
      'feedback' => 'Claude is writing your replies',
      'answer' => 'Claude is answering',
      _ => 'Claude is preparing the review',
    };
    return (label: what, detail: [?run.progress('steps', clock.now()), if (run.step.isNotEmpty) run.step].join(' · '), tone: ReviewTone.working);
  }
  if (res?.error case final e? when e != 'Stopped.') return (label: 'Session stopped', detail: e, tone: ReviewTone.failed);
  final live = r.threads.where((t) => t.state == 'open' || t.state == 'published');
  final decide = live.where((t) => t.answer != null && t.decision == null && !t.waiting).length;
  final waiting = live.where((t) => t.waiting).length;
  final out = live.where(goesOut).length;
  final published = r.rounds.where((x) => x.publishedAt != null).lastOrNull;
  final empty = r.fileNotes.isEmpty && r.groups.isEmpty && r.threads.isEmpty;
  String n(int k, String one, [String? many]) => '$k ${k == 1 ? one : many ?? '${one}s'}';
  if (decide > 0) {
    return (label: '${n(decide, 'answer')} to accept or reject', detail: out > 0 ? '${n(out, 'answer')} ready to publish' : null, tone: ReviewTone.you);
  }
  if (waiting > 0) return (label: '${n(waiting, 'question')} waiting on Claude', detail: null, tone: ReviewTone.working);
  if (out > 0) return (label: '${n(out, 'answer')} ready to publish', detail: null, tone: ReviewTone.ready);
  if (empty) return (label: 'Not prepared yet', detail: null, tone: ReviewTone.you);
  if (published != null) return (label: 'Round ${published.number} published', detail: 'nothing left to send', tone: ReviewTone.done);
  return (label: 'Prepared', detail: 'ready to read', tone: ReviewTone.ready);
}

class _ReviewState extends StatelessWidget {
  const _ReviewState(this.s);

  final ReviewState s;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final color = switch (s.tone) {
      ReviewTone.working => c.blue,
      ReviewTone.you => c.orange,
      ReviewTone.failed => c.red,
      ReviewTone.ready => c.green,
      ReviewTone.done => c.label3,
    };
    return Row(
      children: [
        if (s.tone == ReviewTone.working)
          SizedBox.square(dimension: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: color))
        else
          Icon(
            switch (s.tone) {
              ReviewTone.you => Icons.person_rounded,
              ReviewTone.failed => Icons.error_outline_rounded,
              ReviewTone.ready => Icons.check_circle_rounded,
              _ => Icons.done_all_rounded,
            },
            size: 13,
            color: color,
          ),
        const SizedBox(width: 6),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: s.label,
                  style: context.t.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: color),
                ),
                if (s.detail case final d? when d.isNotEmpty) TextSpan(text: '  ·  $d'),
              ],
            ),
            overflow: TextOverflow.ellipsis,
            style: context.t.bodySmall,
          ),
        ),
      ],
    );
  }
}
