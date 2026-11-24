// Any session adds documents and facts to a project's Overview.
import 'dart:async';

import 'package:dart_mcp/client.dart';
import 'package:deck/mcp/deck_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';

class _Board implements DeckBackend {
  final added = <List<Object?>>[];

  @override
  Future<bool> addProjectDoc(String project, String url, String title) async {
    if (project != 'vpn') return false;
    added.add([url, title]);
    return true;
  }

  @override
  Future<bool> addProjectFact(String project, String section, String text, String? source) async {
    if (project != 'vpn') return false;
    added.add([section, text, source]);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  late _Board board;

  Future<ServerConnection> connect() async {
    board = _Board();
    final toServer = StreamController<String>();
    final toClient = StreamController<String>();
    DeckMcpServer(StreamChannel(toServer.stream, toClient.sink), board);
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

  Future<bool> call(ServerConnection s, String tool, Map<String, Object?> args) async =>
      !((await s.callTool(CallToolRequest(name: tool, arguments: args))).isError ?? false);

  test('adds a document, trimmed; refuses a non https link or an unknown project', () async {
    final s = await connect();
    expect(await call(s, 'add_project_doc', {'project': 'vpn', 'url': ' https://docs.google.com/x ', 'title': ' Plan '}), isTrue);
    expect(await call(s, 'add_project_doc', {'project': 'vpn', 'url': 'http://x', 'title': 'Plan'}), isFalse);
    expect(await call(s, 'add_project_doc', {'project': 'other', 'url': 'https://x', 'title': 'Plan'}), isFalse);
    expect(board.added, [
      ['https://docs.google.com/x', 'Plan'],
    ]);
  });

  test('adds a fact; refuses an unknown section', () async {
    final s = await connect();
    expect(await call(s, 'add_project_fact', {'project': 'vpn', 'section': 'release', 'text': ' 2.0 on Dec 1 ', 'source': '#vpn'}), isTrue);
    expect(await call(s, 'add_project_fact', {'project': 'vpn', 'section': 'gossip', 'text': 'x'}), isFalse);
    expect(board.added, [
      ['release', '2.0 on Dec 1', '#vpn'],
    ]);
  });
}
