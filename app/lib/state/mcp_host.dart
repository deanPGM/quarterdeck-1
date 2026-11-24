import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../mcp/deck_server.dart';
import '../mcp/http_host.dart';
import 'board.dart';
import 'project_info.dart';
import 'project_map.dart';
import 'reviews.dart';
import 'sessions.dart';
import 'terminals.dart';

part 'mcp_host.g.dart';

/// The Deck MCP server, up as long as the app runs. Background sessions and
/// your own terminal sessions reach it at http://127.0.0.1:4777/mcp.
@Riverpod(keepAlive: true)
Future<HttpMcpHost> mcpHost(Ref ref) async {
  final board = ref.read(boardProvider.notifier);
  final maps = ref.read(projectMapsProvider.notifier);
  final reviews = ref.read(reviewsProvider.notifier);
  final infos = ref.read(projectInfosProvider.notifier);
  final host = HttpMcpHost(
    (ch, q) => DeckMcpServer(
      ch,
      board,
      maps: maps,
      reviews: reviews,
      infos: infos,
      run: q['run'],
      project: q['project'],
      review: q['review'],
      talk: q['talk'] != null,
      ledger: q['ledger'],
    ),
    onHook: (tab, session, state) {
      if (tab != null) ref.read(terminalsProvider.notifier).hook(tab, state);
      if (session != null) ref.read(sessionHooksProvider.notifier).set(session, state);
    },
  );
  await host.start(port: mcpPort);
  ref.onDispose(host.stop);
  return host;
}
