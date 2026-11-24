// The terminal tab strip: the selected tab runs into the terminal below it,
// the others sit on a darker strip. One tab works, one waits for you, one has
// ended, one is done (idle).
import 'package:deck/state/terminals.dart';
import 'package:deck/ui/terminals/terminal_panel.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fonts.dart';

void main() {
  late bool fonts;
  setUpAll(() async => fonts = await loadFonts());

  for (final b in Brightness.values) {
    testWidgets('terminal tabs, ${b.name}', (t) async {
      if (!fonts) return markTestSkipped('macOS fonts not found');
      const tabs = <TabData>[
        (info: TermInfo(title: '!952', action: 'Claude', detail: 'Paywall: restore purchases'), dir: '/tmp/a', exited: false, waiting: false, working: true),
        (info: TermInfo(title: 'jira', action: 'Run', detail: 'Fetch at 18:49'), dir: '/tmp/b', exited: false, waiting: true, working: false),
        (info: TermInfo(title: 'AVPN-65', action: 'Draft', detail: 'Onboarding copy'), dir: '/tmp/c', exited: true, waiting: false, working: false),
        (info: TermInfo(title: 'vpn-ios', action: 'Talk', detail: 'Talk about Acme VPN'), dir: '/tmp/d', exited: false, waiting: false, working: false),
      ];
      t.view.physicalSize = const Size(1200, 160);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: deckTheme(b),
          home: Scaffold(
            body: Column(
              children: [
                TerminalTabStrip(
                  tabs: tabs,
                  current: 0,
                  onSelect: (_) {},
                  onClose: (_) {},
                  add: IconButton(onPressed: () {}, icon: const Icon(Icons.add_rounded, size: 18)),
                  trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, size: 18))],
                ),
                Expanded(
                  child: ColoredBox(color: terminalBackground, child: const SizedBox.expand()),
                ),
              ],
            ),
          ),
        ),
      );
      await t.pump(const Duration(milliseconds: 400));
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/terminal_tabs_${b.name}.png'));
    });
  }
}
