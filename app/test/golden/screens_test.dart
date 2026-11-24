// Golden screenshots of the main screens. Needs the macOS system fonts, so it
// skips elsewhere. Update with: flutter test --update-goldens test/golden
@Tags(['golden'])
library;

import 'package:clock/clock.dart';
import 'package:deck/main.dart';
import 'package:deck/state/board.dart';
import 'package:deck/state/notices.dart';
import 'package:deck/state/terminals.dart';
import 'package:deck/state/updates.dart';
import 'package:deck/ui/terminals/terminal_panel.dart';
import 'package:deck/ui/board/filter_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:deck/dev/fixtures.dart';

import 'fonts.dart';

void main() {
  late bool fonts;
  setUpAll(() async => fonts = await loadFonts());

  // A fixed clock, so dates and times on screen are the same on every run.
  Future<void> shot(
    WidgetTester t,
    String name, {
    Brightness brightness = Brightness.light,
    Future<void> Function(WidgetTester)? go,
    bool ringing = false,
    Size size = const Size(1440, 900),
    BoardState Function(BoardState)? board,
    NoticesState Function()? notices,
    UpdateState? update,
    double ratio = 1,
    String dir = 'goldens',
  }) => withClock(Clock.fixed(DateTime(2026, 10, 15, 9, 30)), () async {
    if (!fonts) return markTestSkipped('macOS fonts not found');
    t.view.physicalSize = size * ratio;
    t.view.devicePixelRatio = ratio;
    t.platformDispatcher.platformBrightnessTestValue = brightness;
    addTearDown(t.view.reset);
    addTearDown(t.platformDispatcher.clearPlatformBrightnessTestValue);
    await t.pumpWidget(
      ProviderScope(
        overrides: overrides(
          sampleConfig,
          board == null ? sampleBoard() : board(sampleBoard()),
          ringing: ringing ? sampleBoard().snapshots['calendar']!.events[1] : null,
          notices: notices == null ? const NoticesState() : notices(),
          update: update,
        ),
        child: const DeckApp(),
      ),
    );
    await t.pump(const Duration(milliseconds: 100));
    await t.pump(const Duration(milliseconds: 100));
    if (go != null) await go(t);
    // Let selection highlights finish animating.
    await t.pump(const Duration(milliseconds: 400));
    await expectLater(find.byType(DeckApp), matchesGoldenFile('$dir/$name.png'));
  });

  Future<void> byType(WidgetTester t) async {
    await t.tap(find.text('By Type'));
    await t.pump(const Duration(milliseconds: 100));
  }

  // Opens the filter menu and picks [label] in it.
  Future<void> pick(WidgetTester t, String label) async {
    await t.tap(find.byType(FilterField));
    await t.pump(const Duration(milliseconds: 100));
    await t.tap(find.descendant(of: find.byKey(const Key('filter-menu')), matching: find.text(label)));
    await t.pump(const Duration(milliseconds: 100));
    await t.sendKeyEvent(LogicalKeyboardKey.escape);
    await t.pump(const Duration(milliseconds: 100));
  }

  testWidgets('board, flow', (t) => shot(t, 'board_flow'));
  testWidgets('board, flow, narrow window scrolls sideways', (t) => shot(t, 'board_flow_narrow', size: const Size(1100, 800)));
  testWidgets(
    'board, by type, narrow window scrolls sideways',
    (t) => shot(
      t,
      'board_needs_narrow',
      size: const Size(1100, 800),
      go: (t) async {
        await byType(t);
        // Let the scrollbar fade in.
        await t.pump(const Duration(seconds: 1));
      },
    ),
  );
  testWidgets(
    'board, focus',
    (t) => shot(
      t,
      'board_focus',
      go: (t) async {
        await t.tap(find.text('Focus'));
        await t.pump(const Duration(milliseconds: 100));
      },
    ),
  );
  testWidgets(
    'board, filter menu open',
    (t) => shot(
      t,
      'board_filter_menu',
      go: (t) async {
        await t.tap(find.byType(FilterField));
        await t.pump(const Duration(milliseconds: 100));
      },
    ),
  );
  testWidgets(
    'board, flow, a row opened and the sweep',
    (t) => shot(
      t,
      'board_flow_open',
      size: const Size(1440, 1900),
      go: (t) async {
        await t.tap(find.text('Sweep'));
        await t.pump();
        await t.tap(find.text('Draft: new onboarding'));
        await t.pump();
      },
    ),
  );
  testWidgets(
    'board, needs you',
    (t) => shot(
      t,
      'board_needs',
      go: (t) async {
        await byType(t);
      },
    ),
  );
  testWidgets(
    'board, pointer on a card lights up its linked cards',
    (t) => shot(
      t,
      'board_linked_hover',
      go: (t) async {
        final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: t.getCenter(find.text('Fix cold launch sync of the tunnel state')));
        addTearDown(mouse.removePointer);
        await t.pump(const Duration(milliseconds: 100));
      },
    ),
  );
  testWidgets('board, dark', (t) => shot(t, 'board_dark', brightness: Brightness.dark));
  testWidgets('board, alarm ringing', (t) => shot(t, 'board_alarm', ringing: true));
  testWidgets(
    'notices, a tool ask and a toast over the review',
    (t) => shot(
      t,
      'notices_toasts',
      notices: sampleNotices,
      board: (b) => b.copyWith(
        asks: [
          PermissionAsk('Bash', {'command': 'rtk git diff --no-compact 375e625...5071665 -- SharedKit'}),
        ],
      ),
    ),
  );
  testWidgets('notices, update available', (t) => shot(t, 'notices_update', update: sampleUpdate(latest: '0.2.0')));
  testWidgets(
    'notices, update failed, dark',
    (t) => shot(
      t,
      'notices_update_failed_dark',
      brightness: Brightness.dark,
      update: sampleUpdate(latest: '0.2.0', step: UpdateStep.failed, error: 'Could not download the release. Details in ~/.deck/cache/update.log'),
    ),
  );
  testWidgets('notices, the panel', (t) => shot(t, 'notices_panel', notices: () => sampleNotices(open: true)));
  testWidgets('notices, dark', (t) => shot(t, 'notices_panel_dark', brightness: Brightness.dark, notices: () => sampleNotices(open: true)));
  testWidgets(
    'board, reviews lane',
    (t) => shot(
      t,
      'board_reviews',
      go: (t) async {
        await byType(t);
        await pick(t, 'Reviews');
      },
    ),
  );
  testWidgets(
    'board, replies lane',
    (t) => shot(
      t,
      'board_replies',
      // Tall enough to show the mail cards under the Slack replies.
      size: const Size(1440, 1500),
      go: (t) async {
        await byType(t);
        await pick(t, 'Replies');
      },
    ),
  );
  testWidgets(
    'board, tasks lane',
    (t) => shot(
      t,
      'board_tasks',
      go: (t) async {
        await byType(t);
        await pick(t, 'Tasks');
      },
    ),
  );
  testWidgets(
    'board, done',
    (t) => shot(
      t,
      'board_done',
      go: (t) async {
        await byType(t);
        await t.tap(find.textContaining('Done ').first);
        await t.pump(const Duration(milliseconds: 100));
      },
    ),
  );
  testWidgets(
    'board, one project',
    (t) => shot(
      t,
      'board_project',
      go: (t) async {
        await pick(t, 'VPN iOS');
        await t.pump(const Duration(milliseconds: 100));
      },
    ),
  );

  testWidgets(
    'project overview',
    (t) => shot(
      t,
      'project_overview',
      go: (t) async {
        await t.tap(find.text('VPN iOS').first);
        await t.pump(const Duration(milliseconds: 100));
        await t.pump(const Duration(milliseconds: 100));
        // The terminal's + starts sessions in the project on screen.
        expect(t.widget<TerminalDock>(find.byType(TerminalDock)).project, sampleConfig.projects.firstWhere((p) => p.name == 'VPN iOS').id);
      },
    ),
  );

  Future<void> openActivity(WidgetTester t, [String? period]) async {
    await t.tap(find.text('Activity'));
    await t.pump(const Duration(milliseconds: 100));
    if (period != null) {
      await t.tap(find.text(period));
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('activity, week', (t) => shot(t, 'activity_week', go: (t) => openActivity(t, 'Week')));
  testWidgets('activity, week, dark', (t) => shot(t, 'activity_week_dark', brightness: Brightness.dark, go: (t) => openActivity(t, 'Week')));
  testWidgets('activity, year', (t) => shot(t, 'activity_year', go: (t) => openActivity(t, 'Year')));

  // The terminal panel, empty, docked at the bottom, at its size or full size.
  Future<void> terminal(WidgetTester t, {bool full = false}) async {
    final terms = ProviderScope.containerOf(t.element(find.byType(DeckApp))).read(terminalsProvider.notifier);
    terms.toggle();
    if (full) terms.setFull(true);
    await t.pump(const Duration(milliseconds: 100));
  }

  testWidgets('terminal panel', (t) => shot(t, 'terminal_panel', go: (t) => terminal(t)));
  testWidgets('terminal panel, full size', (t) => shot(t, 'terminal_panel_full', go: (t) => terminal(t, full: true)));

  Future<void> openSettings(WidgetTester t, [String? item]) async {
    await t.tap(find.text('Settings'));
    await t.pump(const Duration(milliseconds: 100));
    if (item != null) {
      await t.tap(find.text(item).first);
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('settings, general', (t) => shot(t, 'settings_general', go: (t) => openSettings(t)));
  testWidgets(
    'settings, general, update available',
    (t) => shot(
      t,
      'settings_general_update',
      update: sampleUpdate(latest: '0.2.0'),
      go: (t) => openSettings(t),
    ),
  );
  testWidgets('settings, gitlab', (t) => shot(t, 'settings_gitlab', go: (t) => openSettings(t, 'GitLab')));
  testWidgets('settings, slack', (t) => shot(t, 'settings_slack', go: (t) => openSettings(t, 'Slack')));
  testWidgets('settings, project', (t) => shot(t, 'settings_project', size: const Size(1440, 1200), go: (t) => openSettings(t, 'VPN iOS')));
  testWidgets('settings, mail', (t) => shot(t, 'settings_mail', go: (t) => openSettings(t, 'Mail')));
  testWidgets('settings, actions', (t) => shot(t, 'settings_actions', go: (t) => openSettings(t, 'Actions')));
  testWidgets('settings, claude', (t) => shot(t, 'settings_claude', size: const Size(1440, 1700), go: (t) => openSettings(t, 'Claude')));

  Future<void> openProject(WidgetTester t, [String? item]) async {
    await t.tap(find.widgetWithText(ListTile, 'VPN iOS'));
    await t.pump(const Duration(milliseconds: 100));
    await t.pump(const Duration(milliseconds: 100));
    if (item != null) {
      await t.tap(find.widgetWithText(ListTile, item).first);
      await t.pump(const Duration(milliseconds: 100));
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('project, map', (t) => shot(t, 'project_map', go: (t) => openProject(t)));
  testWidgets('project, map, dark', (t) => shot(t, 'project_map_dark', brightness: Brightness.dark, go: (t) => openProject(t)));
  testWidgets(
    'project, map search',
    (t) => shot(
      t,
      'project_map_search',
      go: (t) async {
        await openProject(t);
        await t.enterText(find.byType(TextField), 'token');
        await t.pump(const Duration(milliseconds: 100));
      },
    ),
  );
  testWidgets('project, feature', (t) => shot(t, 'project_feature', size: const Size(1440, 2200), go: (t) => openProject(t, 'Tunnel connect')));
  testWidgets(
    'project, feature, dark',
    (t) => shot(t, 'project_feature_dark', brightness: Brightness.dark, size: const Size(1440, 2200), go: (t) => openProject(t, 'Tunnel connect')),
  );
  testWidgets(
    'project, switcher',
    (t) => shot(
      t,
      'project_switcher',
      go: (t) async {
        await openProject(t);
        await t.tap(find.byTooltip('Switch project'));
        await t.pump(const Duration(milliseconds: 400));
      },
    ),
  );
  testWidgets('project, architecture', (t) => shot(t, 'project_architecture', size: const Size(1440, 1100), go: (t) => openProject(t, 'Architecture')));
  testWidgets('project, ui', (t) => shot(t, 'project_ui', size: const Size(1440, 1100), go: (t) => openProject(t, 'UI')));
  testWidgets(
    'project, ui, dark',
    (t) => shot(t, 'project_ui_dark', brightness: Brightness.dark, size: const Size(1440, 1100), go: (t) => openProject(t, 'UI')),
  );
  testWidgets('project, data type', (t) => shot(t, 'project_data', go: (t) => openProject(t, 'TunnelConfig')));
  testWidgets('project, merge requests', (t) => shot(t, 'project_mrs', go: (t) => openProject(t, 'Merge Requests')));

  // Straight to the page: the button would fetch the request first.
  Future<void> openReview(WidgetTester t) async {
    GoRouter.of(t.element(find.byType(Scaffold).first)).go('/project/vpn-ios/review/gitlab-412');
    await t.pump(const Duration(milliseconds: 100));
    await t.pump(const Duration(milliseconds: 100));
    await t.pump(const Duration(milliseconds: 100));
  }

  testWidgets('review, overview', (t) => shot(t, 'review_overview', size: const Size(1440, 2400), go: openReview));
  testWidgets(
    'review, local branch',
    (t) => shot(
      t,
      'review_local',
      size: const Size(1440, 900),
      go: (t) async {
        GoRouter.of(t.element(find.byType(Scaffold).first)).go('/project/vpn-ios/review/local-feat-VPN-310-split-tunnel');
        for (var i = 0; i < 3; i++) {
          await t.pump(const Duration(milliseconds: 100));
        }
      },
    ),
  );
  testWidgets('review, dark', (t) => shot(t, 'review_overview_dark', brightness: Brightness.dark, size: const Size(1440, 2400), go: openReview));

  // The README screenshots: the main screens in dark, short so the README stays readable, at 2x so they are sharp.
  const readme = '../../../docs/screenshots';
  const short = Size(1440, 760);
  testWidgets('readme, board', (t) => shot(t, 'board', ratio: 2, size: short, brightness: Brightness.dark, dir: readme));
  testWidgets('readme, by type', (t) => shot(t, 'by_type', ratio: 2, size: short, brightness: Brightness.dark, dir: readme, go: byType));
  testWidgets('readme, review', (t) => shot(t, 'review', ratio: 2, size: short, brightness: Brightness.dark, dir: readme, go: openReview));
  testWidgets(
    'readme, project feature',
    (t) => shot(t, 'project_feature', ratio: 2, size: short, brightness: Brightness.dark, dir: readme, go: (t) => openProject(t, 'Tunnel connect')),
  );
  testWidgets(
    'readme, project overview',
    (t) => shot(t, 'project_overview', ratio: 2, size: short, brightness: Brightness.dark, dir: readme, go: (t) => openProject(t, 'Overview')),
  );
  testWidgets(
    'readme, activity',
    (t) => shot(t, 'activity', ratio: 2, size: short, brightness: Brightness.dark, dir: readme, go: (t) => openActivity(t, 'Week')),
  );
  testWidgets(
    'readme, notices',
    (t) => shot(
      t,
      'notices',
      ratio: 2,
      size: short,
      brightness: Brightness.dark,
      dir: readme,
      notices: sampleNotices,
      board: (b) => b.copyWith(
        asks: [
          PermissionAsk('Bash', {'command': 'rtk git diff --no-compact 375e625...5071665 -- SharedKit'}),
        ],
      ),
    ),
  );
}
