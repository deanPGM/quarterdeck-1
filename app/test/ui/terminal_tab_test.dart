// A tab keeps its size when its session goes from working to waiting to done.
import 'package:deck/state/terminals.dart';
import 'package:deck/ui/terminals/terminal_panel.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('working, waiting and done tabs are the same size', (t) async {
    final sizes = <Size>[];
    for (final (working, waiting) in [(true, false), (false, true), (false, false)]) {
      await t.pumpWidget(
        MaterialApp(
          theme: deckTheme(Brightness.dark),
          home: Scaffold(
            body: TerminalTabStrip(
              tabs: [
                (info: const TermInfo(title: '!952', action: 'Claude', detail: 'Paywall'), dir: '/tmp', exited: false, waiting: waiting, working: working),
              ],
              current: 0,
              onSelect: (_) {},
              onClose: (_) {},
            ),
          ),
        ),
      );
      await t.pump(const Duration(milliseconds: 100));
      sizes.add(t.getSize(find.byType(InkWell).first));
    }
    expect(sizes.toSet(), hasLength(1), reason: '$sizes');
  });
}
