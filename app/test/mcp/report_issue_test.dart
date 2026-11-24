// Any session reports a problem it hit in Deck; the issue carries who reported it.
import 'dart:async';

import 'package:dart_mcp/client.dart';
import 'package:deck/mcp/deck_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';

class _Board implements DeckBackend {
  final issues = <Map<String, Object?>>[];

  @override
  Future<void> reportIssue(Map<String, Object?> issue) async => issues.add(issue);

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  late _Board board;

  Future<ServerConnection> connect({String? run, String? ledger}) async {
    board = _Board();
    final toServer = StreamController<String>();
    final toClient = StreamController<String>();
    DeckMcpServer(StreamChannel(toServer.stream, toClient.sink), board, run: run, ledger: ledger);
    final server = MCPClient(Implementation(name: 'test', version: '0')).connectServer(StreamChannel(toClient.stream, toServer.sink));
    await server.initialize(
      InitializeRequest(
        protocolVersion: ProtocolVersion.latestSupported,
        capabilities: ClientCapabilities(),
        clientInfo: Implementation(name: 'test', version: '0'),
      ),
    );
    server.notifyInitialized();
    return server;
  }

  Future<bool> call(ServerConnection s, Map<String, Object?> args) async =>
      !((await s.callTool(CallToolRequest(name: 'deck_report_issue', arguments: args))).isError ?? false);

  test('saves the issue with the run and ledger of the session', () async {
    final s = await connect(run: 'slack-1', ledger: '20261117-090000-worker-ab12');
    expect(await call(s, {'kind': 'unclear', 'what': ' Which channel counts as mine? ', 'tool': 'mcp__deck__deck_submit', 'detail': ''}), isTrue);
    expect(board.issues.single..remove('at'), {
      'kind': 'unclear',
      'what': 'Which channel counts as mine?',
      'tool': 'mcp__deck__deck_submit',
      'run': 'slack-1',
      'ledger': '20261117-090000-worker-ab12',
    });
  });

  test('refuses an unknown kind or an empty what', () async {
    final s = await connect();
    expect(await call(s, {'kind': 'rant', 'what': 'x'}), isFalse);
    expect(await call(s, {'kind': 'bug', 'what': '  '}), isFalse);
    expect(board.issues, isEmpty);
  });
}
