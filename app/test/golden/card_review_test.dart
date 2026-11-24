// A merge request card whose review exists in Deck: Open Review, and the
// review session's line under it, running, done and stopped.
import 'package:clock/clock.dart';
import 'package:deck/actions/launcher.dart';
import 'package:deck/dev/fixtures.dart';
import 'package:deck/ui/board/board_model.dart';
import 'package:deck/ui/board/card_tile.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fonts.dart';

void main() {
  late bool fonts;
  setUpAll(() async => fonts = await loadFonts());

  testWidgets('merge request card with its review', (t) async {
    if (!fonts) return markTestSkipped('macOS fonts not found');
    final now = clock.now(), board = sampleBoard();
    final items = buildItems(board.snapshots, board.triage, const {}, sampleConfig, now);
    final review = items.where((i) => i.actions.contains(CardAction.review)).first;
    final feedback = items.where((i) => i.actions.contains(CardAction.feedback)).firstOrNull ?? review;
    const reviews = <CardReview>[
      (exists: true, running: true, kind: 'prepare', step: 'Writing file notes', progress: '6 of 14 steps', failed: false),
      (exists: true, running: false, kind: 'feedback', step: '', progress: null, failed: false),
      (exists: true, running: false, kind: 'prepare', step: 'Timed out after 30 min', progress: null, failed: true),
    ];
    t.view.physicalSize = const Size(1100, 420);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: deckTheme(Brightness.light),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (n, r) in reviews.indexed)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 330,
                      child: CardTile(item: n == 1 ? feedback : review, now: now, review: r, onOpenReview: () {}, onAction: (_) {}),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await t.pump(const Duration(milliseconds: 100));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/card_review.png'));
  });
}
