// Golden screenshots of the review diff, drawn from made up samples.
// Update with: flutter test --update-goldens test/golden/review_diff_test.dart
@Tags(['golden'])
library;

import 'dart:async';

import 'package:deck/core/review/diff.dart';
import 'package:deck/dev/review_fixtures.dart';
import 'package:deck/dev/review_samples.dart';
import 'package:deck/core/review/publish_plan.dart';
import 'package:deck/core/review/review.dart';
import 'package:deck/ui/review/file_diff.dart';
import 'package:deck/ui/review/publish_dialog.dart';
import 'package:deck/ui/review/thread_card.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fonts.dart';

Widget _page(List<DiffFile> files, {bool split = false, Set<String> viewed = const {}}) => CustomScrollView(
  slivers: [
    SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverMainAxisGroup(
        slivers: [
          for (final f in files)
            FileDiffView(
              file: f,
              split: split,
              note: sampleFileNotes[f.path],
              hunkNotes: sampleHunkNotes,
              loadContext: sampleLoadContext,
              viewed: viewed.contains(f.path),
              onViewed: (_) {},
              onOpen: (_) {},
            ),
        ],
      ),
    ),
  ],
);

/// The schedule file with the sample threads under their lines, and a new
/// thread being written on a picked range.
Widget _threads({bool split = false}) {
  final snap = sampleReviewDiff();
  final file = snap.files.firstWhere((f) => f.path == 'lib/garden/schedule_repository.dart');
  final below = <(String, int), List<Widget>>{};
  for (final t in sampleThreads(snap)) {
    if (t.anchor case final a?) {
      (below[(a.side, a.endLine)] ??= []).add(
        ThreadCard(
          key: ValueKey(t.id),
          thread: t,
          thinking: t.id == 't2',
          fix: t.id == 't1' ? (state: 'local', sha: 'a1b2c3d4e5') : null,
          onState: (_) async {},
          onAsk: (_) async {},
          onAnswer: (_) async {},
          onDecide: (_) async {},
        ),
      );
    }
  }
  (below[('new', 47)] ??= []).add(NewThreadForm(label: 'New comment on new lines 45 to 47', onSubmit: (_, _, _) async {}, onCancel: () {}));
  return CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: FileDiffView(file: file, split: split, below: below, selected: (side: 'new', from: 45, to: 47), onLine: (_, _, {extend = false}) {}),
      ),
    ],
  );
}

/// [own]: your own merge request, so Fix all shows for the accepted threads.
Widget _inbox({bool own = false}) => Row(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    SizedBox(
      width: 360,
      child: ThreadInbox(
        threads: sampleThreads(sampleReviewDiff()),
        onOpen: (_) {},
        onClose: () {},
        onFixAll: own ? (_) async {} : null,
        publish: own ? FilledButton(onPressed: () {}, child: const Text('Send replies')) : null,
      ),
    ),
    const Spacer(),
  ],
);

Widget _publish() {
  final r = sampleReview();
  final posting = r.threads.where((t) => t.state == 'open' && goesOut(t)).toList();
  final preview = PublishPreview(
    roundNumber: 1,
    posting: posting,
    skipped: const [],
    replies: 0,
    summary: renderSummary(
      roundNumber: 1,
      verdict: 'comment',
      notes: r.fileNotes,
      groups: r.groups,
      hiddenCount: 2,
      publishedSeverities: [for (final t in posting) t.severity],
      skipped: 0,
      replies: 0,
      tickets: [(ref: 'GARDEN-31', url: null, title: 'Rain check', check: r.ticketChecks.single)],
      headSha: sampleHead,
    ),
  );
  return Builder(
    builder: (context) => PublishDialog(mr: r.mr!, preview: (_, _) async => preview, publish: (_, _) => Completer<PublishResult>().future),
  );
}

void main() {
  late bool fonts;
  setUpAll(() async => fonts = await loadFonts());

  Future<void> shot(
    WidgetTester t,
    String name,
    Widget child, {
    Brightness brightness = Brightness.light,
    Size size = const Size(1100, 1500),
    Future<void> Function(WidgetTester)? go,
  }) async {
    if (!fonts) return markTestSkipped('macOS fonts not found');
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: deckTheme(brightness),
        home: Scaffold(body: child),
      ),
    );
    await t.pump(const Duration(milliseconds: 100));
    if (go != null) await go(t);
    await t.pump(const Duration(milliseconds: 400));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));
  }

  testWidgets('threads', (t) => shot(t, 'review_threads', _threads(), size: const Size(1100, 2000)));
  testWidgets(
    'threads, split, dark',
    (t) => shot(t, 'review_threads_split_dark', _threads(split: true), brightness: Brightness.dark, size: const Size(1300, 2000)),
  );
  testWidgets(
    'thread chat open, own merge request',
    (t) => shot(
      t,
      'review_thread_chat',
      Builder(
        builder: (_) {
          final ts = {for (final x in sampleThreads(sampleReviewDiff())) x.id: x};
          Widget card(Thread th, {bool own = false}) => Padding(
            padding: const EdgeInsets.all(12),
            child: ThreadCard(
              thread: th,
              own: own,
              thinking: th.waiting,
              onAsk: (_) async {},
              onAnswer: (_) async {},
              onState: (_) async {},
              onDecide: (_) async {},
            ),
          );
          return ListView(
            children: [
              card(ts['t2']!),
              card(ts['t6']!.copyWith(authorType: 'remote'), own: true),
            ],
          );
        },
      ),
      size: const Size(900, 1000),
      go: (t) async {
        // Opening the chat opens the box to Claude too.
        await t.tap(find.text('Show the chat (2)'));
        await t.pump();
        expect(find.text('Ask Claude…'), findsNothing);
      },
    ),
  );
  testWidgets('publish dialog', (t) => shot(t, 'review_publish', _publish(), size: const Size(900, 1000)));
  testWidgets('thread inbox', (t) => shot(t, 'review_inbox', _inbox(), size: const Size(800, 1000)));
  testWidgets('thread inbox, own merge request', (t) => shot(t, 'review_inbox_own', _inbox(own: true), size: const Size(800, 1000)));
  testWidgets('unified', (t) => shot(t, 'review_unified', _page(sampleDiffFiles)));
  testWidgets('split', (t) => shot(t, 'review_split', _page(sampleDiffFiles, split: true), size: const Size(1300, 1500)));
  testWidgets('dark', (t) => shot(t, 'review_dark', _page(sampleDiffFiles), brightness: Brightness.dark));
  testWidgets(
    'split, dark',
    (t) => shot(t, 'review_split_dark', _page(sampleDiffFiles, split: true), brightness: Brightness.dark, size: const Size(1300, 1500)),
  );

  testWidgets(
    'tiny edit, binary, renamed, a viewed file collapsed',
    (t) => shot(t, 'review_small_files', _page([sampleTiny, sampleBinary, sampleRenamed, sampleWrap], viewed: {sampleWrap.path}), size: const Size(1100, 520)),
  );

  testWidgets(
    'a hunk folded under its note, context expanded',
    (t) => shot(
      t,
      'review_folded',
      _page([sampleSplitHunk, sampleMoved]),
      size: const Size(1100, 900),
      go: (t) async {
        await t.tap(find.text('remove() deletes the bed links first, no foreign key cascade in SQLite here'));
        await t.tap(find.byIcon(Icons.unfold_more).first);
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets('a 3,000 line diff builds only the rows on screen', (t) async {
    t.view.physicalSize = const Size(1100, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Scaffold(body: _page([sampleBigFile()])),
      ),
    );
    await t.tap(find.text('Load diff'));
    final watch = Stopwatch()..start();
    await t.pump();
    watch.stop();
    expect(find.textContaining('Plant(id: 3', findRichText: true), findsWidgets);
    expect(find.textContaining('Plant(id: 1400', findRichText: true), findsNothing);
    expect(watch.elapsedMilliseconds, lessThan(1500));
  });
}
