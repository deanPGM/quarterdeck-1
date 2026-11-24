import 'package:deck/dev/review_fixtures.dart';
import 'package:deck/ui/review/file_diff.dart';
import 'package:deck/ui/review/fix_diff_dialog.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the fix dialog draws each file of the commit', (t) async {
    t.view.physicalSize = const Size(1200, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final files = sampleReviewDiff().files.take(2).toList();
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Scaffold(
          body: FixDiffDialog(sha: 'abc1234def', files: Future.value(files)),
        ),
      ),
    );
    await t.pump();
    expect(t.takeException(), isNull);
    expect(find.text('Fix abc1234d'), findsOneWidget);
    expect(find.byType(FileDiffView), findsWidgets);
  });
}
