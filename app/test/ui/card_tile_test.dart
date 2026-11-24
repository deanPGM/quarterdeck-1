import 'package:deck/actions/launcher.dart';
import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/snapshot.dart';
import 'package:deck/ui/board/board_model.dart';
import 'package:deck/ui/board/card_tile.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mail = DeckCard(
    key: 'mail:t1',
    provider: 'mail',
    lane: Lane.reply,
    ref: 'lee@acme.example',
    url: 'https://mail.google.com/mail/u/0/#all/t1',
    title: 'Office closed on Friday',
    next: 'Nothing asked. Archive it once read.',
    bucket: Bucket.action,
    score: 30,
    kind: 'fyi',
    threads: ['t1'],
  );

  Future<(List<CardMenu>, List<CardAction>)> pump(WidgetTester t) async {
    final menus = <CardMenu>[], actions = <CardAction>[];
    final item = BoardItem(
      card: mail,
      triage: const Triage(),
      projects: const [],
      actions: const [CardAction.archive],
      slot: Slot.action,
      rank: 0,
      busy: false,
    );
    await t.pumpWidget(
      MaterialApp(
        theme: deckTheme(Brightness.light),
        home: Material(
          child: CardTile(item: item, now: DateTime.now(), onMenu: menus.add, onAction: actions.add),
        ),
      ),
    );
    return (menus, actions);
  }

  testWidgets('a click on the card body opens it', (t) async {
    final (menus, actions) = await pump(t);
    await t.tap(find.text('Nothing asked. Archive it once read.'));
    expect(menus, [CardMenu.open]);
    expect(actions, isEmpty);
  });

  testWidgets('a button keeps its own click', (t) async {
    final (menus, actions) = await pump(t);
    await t.tap(find.text('Archive'));
    expect(actions, [CardAction.archive]);
    expect(menus, isEmpty);
  });
}
