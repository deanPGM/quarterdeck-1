// The status line of a review on the Merge Requests page, most urgent first.
import 'package:deck/core/models/claude_run.dart';
import 'package:deck/core/review/review.dart';
import 'package:deck/state/session_run.dart';
import 'package:deck/ui/project/mrs_pane.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const m = Message(id: 'm', author: 'agent', body: 'x');
  Thread t(String id, {String? decision, bool waiting = false, String state = 'open'}) =>
      Thread(id: id, severity: 'nit', state: state, authorType: 'agent', answer: m, decision: decision, waiting: waiting);
  const base = Review(
    id: 'gitlab-1',
    project: 'p',
    baseRef: 'main',
    headRef: 'feat',
    fileNotes: [FileNote(path: 'a', summary: 's')],
  );
  final at = DateTime(2026, 11, 2);

  test('most urgent first', () {
    final running = SessionRun(startedAt: at, step: 'Reading the diff', kind: 'prepare');
    expect(reviewState(base, running).label, 'Claude is preparing the review');
    final failed = running.copyWith(
      result: ClaudeRun(at: at, providers: const [], seconds: 1, error: 'Timed out'),
    );
    expect((reviewState(base, failed).label, reviewState(base, failed).tone), ('Session stopped', ReviewTone.failed));
    final r = base.copyWith(
      threads: [
        t('a'),
        t('b', decision: 'accept'),
        t('c', waiting: true),
        t('d', decision: 'reject'),
      ],
    );
    expect((reviewState(r, null).label, reviewState(r, null).detail), ('1 answer to accept or reject', '1 answer ready to publish'));
    expect(reviewState(base.copyWith(threads: [t('c', waiting: true)]), null).label, '1 question waiting on Claude');
    expect(reviewState(base.copyWith(threads: [t('b', decision: 'accept')]), null).label, '1 answer ready to publish');
    expect(reviewState(base, null).label, 'Prepared');
    expect(reviewState(base.copyWith(fileNotes: []), null).label, 'Not prepared yet');
    final published = base.copyWith(
      rounds: [const Round(id: 'r', number: 2, baseSha: 'b', headSha: 'h', publishedAt: '2026-11-01')],
    );
    expect(reviewState(published, null).label, 'Round 2 published');
  });
}
