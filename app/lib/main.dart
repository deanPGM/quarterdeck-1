import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_notifier/local_notifier.dart';

import 'state/ui_memory.dart';
import 'ui/board/board_screen.dart';
import 'ui/notices/notice_layer.dart';
import 'ui/project/project_screen.dart';
import 'ui/review/review_screen.dart';
import 'ui/settings/settings_screen.dart';
import 'ui/terminals/terminal_panel.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localNotifier.setup(appName: 'Quarterdeck');
  runApp(const ProviderScope(child: DeckApp()));
}

class DeckApp extends ConsumerStatefulWidget {
  const DeckApp({super.key});

  @override
  ConsumerState<DeckApp> createState() => _DeckAppState();
}

class _DeckAppState extends ConsumerState<DeckApp> {
  // Opens where you were when Deck quit, and remembers every move.
  late final UiMemory _memory = ref.read(uiMemoryProvider);
  late final GoRouter _router = GoRouter(
    initialLocation: _memory.location,
    routes: [
      // The terminal panel stays docked whatever the screen, and the
      // notifications float over all of it.
      ShellRoute(
        builder: (_, s, child) => NoticeLayer(
          child: TerminalDock(project: s.uri.pathSegments.length > 1 && s.uri.pathSegments.first == 'project' ? s.uri.pathSegments[1] : null, child: child),
        ),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (_, _) => const NoTransitionPage(child: BoardScreen()),
          ),
          GoRoute(
            path: '/project/:id',
            // A bare project link opens the section you left it on.
            redirect: (_, s) => switch (_memory.places[s.pathParameters['id']]) {
              final q? when s.uri.query.isEmpty => '${s.uri.path}?$q',
              _ => null,
            },
            pageBuilder: (_, s) => NoTransitionPage(
              child: ProjectScreen(id: s.pathParameters['id']!, place: ProjectPlace.of(s.uri.queryParameters)),
            ),
          ),
          GoRoute(
            path: '/project/:id/review/:review',
            pageBuilder: (_, s) => NoTransitionPage(
              child: ReviewScreen(project: s.pathParameters['id']!, id: s.pathParameters['review']!),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (_, s) => NoTransitionPage(child: SettingsScreen(section: s.uri.queryParameters['section'])),
          ),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _router.routerDelegate.addListener(() => _memory.setLocation(_router.routerDelegate.currentConfiguration.uri));
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Quarterdeck',
    debugShowCheckedModeBanner: false,
    theme: deckTheme(Brightness.light),
    darkTheme: deckTheme(Brightness.dark),
    routerConfig: _router,
  );
}
