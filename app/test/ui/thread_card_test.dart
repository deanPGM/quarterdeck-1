import 'dart:math' as math;

import 'package:deck/core/review/publish_plan.dart';
import 'package:deck/core/review/review.dart';
import 'package:deck/dev/review_fixtures.dart';
import 'package:deck/ui/review/thread_card.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final threads = {for (final x in sampleThreads(sampleReviewDiff())) x.id: x};

  Future<List<String>> pump(WidgetTester t, Thread th, {bool outdated = false}) async {
    final asked = <String>[];
    t.view.physicalSize = const Size(900, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Scaffold(
          body: SingleChildScrollView(
            child: ThreadCard(
              thread: th,
              outdated: outdated,
              onAsk: (b) async => asked.add(b),
              onAnswer: (_) async {},
              onState: (_) async {},
              onDecide: (_) async {},
            ),
          ),
        ),
      ),
    );
    return asked;
  }

  testWidgets('the whole card folds to one line and opens again', (t) async {
    await pump(t, threads['t6']!.copyWith(authorType: 'remote'));
    expect(find.text('Accept'), findsOneWidget);
    await t.tap(find.byTooltip('Fold to one line'));
    await t.pump();
    expect(find.text('Accept'), findsNothing);
    await t.tap(find.text('Show'));
    await t.pump();
    expect(find.text('Accept'), findsOneWidget);
  });

  testWidgets('a resolved or outdated thread starts folded, on its opening comment', (t) async {
    final th = threads['t6']!.copyWith(authorType: 'remote', answer: null, decision: null);
    for (final (thread, outdated) in [(th.copyWith(state: 'resolved'), false), (th, true)]) {
      await pump(t, thread, outdated: outdated);
      expect(find.text('Show'), findsOneWidget);
      expect(find.text(th.messages.first.body.split('\n').first), findsOneWidget);
    }
  });

  testWidgets('a card that shrinks after Accept, its top above the screen, stays in sight', (t) async {
    t.view.physicalSize = const Size(900, 500);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    var th = threads['t6']!.copyWith(authorType: 'remote');
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => CustomScrollView(
              controller: scroll,
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 300)),
                SliverToBoxAdapter(
                  child: ThreadCard(
                    thread: th,
                    onAsk: (_) async {},
                    onAnswer: (_) async {},
                    onState: (_) async {},
                    // Resolved: the card folds to one line, as it shrinks after a real Accept.
                    onDecide: (_) async => setState(() => th = th.copyWith(state: 'resolved', decision: 'accept')),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 2000)),
              ],
            ),
          ),
        ),
      ),
    );
    final height = t.getSize(find.byType(ThreadCard)).height;
    expect(height, lessThan(500));
    // Scrolled down to the buttons: the card's top is off the screen.
    scroll.jumpTo(300 + math.min(40, height / 3));
    await t.pump();
    expect(t.getRect(find.byType(ThreadCard)).top, lessThan(0));
    await t.tap(find.text('Accept'));
    for (var i = 0; i < 5; i++) {
      await t.pump();
    }
    expect(find.text('Show'), findsOneWidget);
    final card = t.getRect(find.byType(ThreadCard));
    expect(card.top, greaterThanOrEqualTo(0));
    expect(card.bottom, lessThanOrEqualTo(500));
  });

  testWidgets('a folded card still shows its fix, and a click opens it', (t) async {
    final opened = <String>[];
    t.view.physicalSize = const Size(900, 600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Scaffold(
          body: ThreadCard(
            thread: threads['t6']!.copyWith(authorType: 'remote', state: 'resolved', answer: null, decision: null),
            fix: (state: 'pushed', sha: 'abc1234def'),
            onShowFix: opened.add,
            onAsk: (_) async {},
            onAnswer: (_) async {},
            onState: (_) async {},
            onDecide: (_) async {},
          ),
        ),
      ),
    );
    expect(find.text('Show'), findsOneWidget);
    await t.tap(find.text('fix abc1234 pushed'));
    expect(opened, ['abc1234def']);
  });

  testWidgets('the chat box stays open after sending', (t) async {
    final asked = await pump(t, threads['t6']!.copyWith(authorType: 'remote'));
    await t.tap(find.text('Ask Claude…'));
    await t.pump();
    await t.enterText(find.byType(TextField), 'Why?');
    await t.tap(find.text('Send'));
    await t.pump();
    expect(asked, ['Why?']);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Enter sends, Shift+Enter adds a line', (t) async {
    final asked = await pump(t, threads['t6']!.copyWith(authorType: 'remote'));
    await t.tap(find.text('Ask Claude…'));
    await t.pump();
    await t.enterText(find.byType(TextField), 'Why');
    await t.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await t.pump();
    expect(asked, isEmpty);
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.pump();
    expect(asked, hasLength(1));
  });

  testWidgets('the answer comes before the chat, and the box to write in is last', (t) async {
    await pump(t, threads['t1']!);
    await t.tap(find.text('Show the chat (2)'));
    await t.pump();
    final answer = t.getTopLeft(find.textContaining('not in a transaction')).dy;
    final talk = t.getTopLeft(find.textContaining('Is a crash between')).dy;
    final box = t.getTopLeft(find.byType(TextField)).dy;
    expect(answer, lessThan(talk));
    expect(talk, lessThan(box));
    expect(find.text('Fix'), findsNothing);
  });

  testWidgets('a task list in a message builds (MR 932 failed on it)', (t) async {
    await pump(t, threads['t1']!.copyWith(answer: threads['t1']!.answer!.copyWith(body: '## How to test\n\n- [x] Unit tests\n- [ ] On a device')));
    expect(t.takeException(), isNull);
    expect(find.textContaining('On a device'), findsOneWidget);
  });

  testWidgets('Fix all takes the accepted threads with no fix yet, once', (t) async {
    final fixed = <List<String>>[];
    final ts = [
      threads['t3']!,
      threads['t4']!.copyWith(fix: 'abc1234'),
      threads['t1']!.copyWith(
        decision: 'accept',
        messages: [
          ...threads['t1']!.messages,
          const Message(id: 'x', author: 'user', body: fixNow),
        ],
      ),
      threads['t1']!.copyWith(id: 't7'),
    ];
    t.view.physicalSize = const Size(400, 900);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Scaffold(
          body: ThreadInbox(threads: ts, onOpen: (_) {}, onClose: () {}, onFixAll: (ids) async => fixed.add(ids)),
        ),
      ),
    );
    expect(find.text('TO FIX'), findsOneWidget);
    expect(find.text('TO DECIDE'), findsOneWidget);
    await t.tap(find.text('Fix 1 accepted'));
    await t.pump();
    expect(fixed, [
      ['t3'],
    ]);
  });

  testWidgets('without Fix all (not your branch) an accepted thread will post', (t) async {
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Scaffold(
          body: ThreadInbox(threads: [threads['t3']!], onOpen: (_) {}, onClose: () {}),
        ),
      ),
    );
    expect(find.text('WILL POST'), findsOneWidget);
    expect(find.textContaining('accepted'), findsNothing);
  });
}
