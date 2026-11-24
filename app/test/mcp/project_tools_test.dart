// The project info tool through a real MCP client, the way the info run calls it.
import 'dart:async';

import 'package:dart_mcp/client.dart';
import 'package:deck/mcp/deck_server.dart';
import 'package:deck/mcp/project_tools.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';

class _Infos implements ProjectInfoBackend {
  final saved = <String, ProjectInfo>{};

  @override
  Future<String?> setProjectInfo(String id, ProjectInfo info) async {
    if (info.logo == 'icon.ico') return 'The logo must be a PNG, JPEG, WebP or SVG file, not .ico.';
    saved[id] = info;
    return null;
  }
}

class _NoBoard implements DeckBackend {
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  late _Infos infos;

  setUp(() => infos = _Infos());

  Future<ServerConnection> connect({String? project}) async {
    final toServer = StreamController<String>();
    final toClient = StreamController<String>();
    DeckMcpServer(StreamChannel(toServer.stream, toClient.sink), _NoBoard(), infos: infos, project: project);
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

  Future<List<String>> tools(ServerConnection s) async => [for (final t in (await s.listTools(ListToolsRequest())).tools) t.name];

  test('only a session started for one project gets the tool', () async {
    expect(await tools(await connect()), isNot(contains('set_project_info')));
    expect(await tools(await connect(project: 'vpn')), contains('set_project_info'));
  });

  test('saves the info of the session\'s project, trimmed', () async {
    final s = await connect(project: 'vpn');
    final r = await s.callTool(
      CallToolRequest(
        name: 'set_project_info',
        arguments: {
          'name': ' Acme VPN ',
          'description': 'VPN app for Android and Windows.',
          'aliases': ['Acme VPN Android', ' ', 'com.acme.vpn', 'AVPN'],
          'logo': 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
        },
      ),
    );
    expect(r.isError ?? false, isFalse);
    final i = infos.saved['vpn']!;
    expect(i.name, 'Acme VPN');
    expect(i.description, 'VPN app for Android and Windows.');
    expect(i.aliases, ['Acme VPN Android', 'com.acme.vpn', 'AVPN']);
    expect(i.logo, 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png');
    expect(i.platforms, isEmpty);
    expect([i.tech, i.board, i.ide], [null, null, null]);
    expect(i.channels, isEmpty);
  });

  test('passes platforms, board, channels, ide and tech trimmed', () async {
    final s = await connect(project: 'vpn');
    final r = await s.callTool(
      CallToolRequest(
        name: 'set_project_info',
        arguments: {
          'name': 'Acme VPN',
          'platforms': ['android', 'windows'],
          'tech': ' Flutter, Dart ',
          'board': ' jira:AVPN ',
          'channels': [' #vpn-team ', '', 'vpn-alerts'],
          'ide': ' idea ',
        },
      ),
    );
    expect(r.isError ?? false, isFalse, reason: (r.content.firstOrNull as TextContent?)?.text);
    final i = infos.saved['vpn']!;
    expect(i.platforms, ['android', 'windows']);
    expect(i.tech, 'Flutter, Dart');
    expect(i.board, 'jira:AVPN');
    expect(i.channels, ['#vpn-team', 'vpn-alerts']);
    expect(i.ide, 'idea');
  });

  test('drops an unknown platform and keeps the rest', () async {
    final s = await connect(project: 'vpn');
    final r = await s.callTool(
      CallToolRequest(
        name: 'set_project_info',
        arguments: {
          'name': 'Acme VPN',
          'platforms': ['android', 'symbian'],
        },
      ),
    );
    expect(r.isError ?? false, isFalse);
    expect(infos.saved['vpn']!.platforms, ['android']);
  });

  test('passes a refused logo back to the session', () async {
    final s = await connect(project: 'vpn');
    final r = await s.callTool(CallToolRequest(name: 'set_project_info', arguments: {'name': 'Acme VPN', 'logo': 'icon.ico'}));
    expect(r.isError, isTrue);
    expect((r.content.single as TextContent).text, contains('not .ico'));
    expect(infos.saved, isEmpty);
  });
}
