// The map tools through a real MCP client, the way a Claude session calls them.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:deck/data/map_store.dart';
import 'package:deck/mcp/deck_server.dart';
import 'package:deck/mcp/map_tools.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:stream_channel/stream_channel.dart';

class _Maps implements MapBackend {
  _Maps(this.root);

  final String root;
  final changed = <String>[];

  @override
  List<String> mapProjects() => ['app'];

  @override
  MapStore? mapOf(String id) => id == 'app' ? MapStore(root) : null;

  @override
  void mapChanged(String project) => changed.add(project);

  final planned = <String>[], done = <String>[];

  @override
  void mapPlanned(String project, List<String> features) => planned.addAll(features);

  @override
  void mapFeatureDone(String project, String id) => done.add(id);
}

class _NoBoard implements DeckBackend {
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  late Directory tmp;
  late _Maps maps;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('deck-tools-');
    Process.runSync('git', ['init', '-q', '-b', 'main'], workingDirectory: tmp.path);
    File(p.join(tmp.path, 'lib/cache.dart'))
      ..createSync(recursive: true)
      ..writeAsStringSync('class Cache {}\n');
    Process.runSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@example.com', '-c', 'commit.gpgsign=false', 'add', '.'], workingDirectory: tmp.path);
    Process.runSync('git', [
      '-c',
      'user.name=t',
      '-c',
      'user.email=t@example.com',
      '-c',
      'commit.gpgsign=false',
      'commit',
      '-q',
      '-m',
      'base',
    ], workingDirectory: tmp.path);
    maps = _Maps(tmp.path);
  });

  tearDown(() => tmp.deleteSync(recursive: true));

  Future<ServerConnection> connect({String? project}) async {
    final toServer = StreamController<String>();
    final toClient = StreamController<String>();
    DeckMcpServer(StreamChannel(toServer.stream, toClient.sink), _NoBoard(), maps: maps, project: project);
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

  Future<(bool, Object?)> call(ServerConnection s, String tool, [Map<String, Object?> args = const {}]) async {
    final r = await s.callTool(CallToolRequest(name: tool, arguments: args));
    final text = (r.content.single as TextContent).text;
    return (r.isError ?? false, r.isError ?? false ? text : jsonDecode(text));
  }

  test('lists the map tools', () async {
    final s = await connect();
    final names = (await s.listTools(ListToolsRequest())).tools.map((t) => t.name).toSet();
    expect(names, containsAll(['get_map', 'set_map_feature', 'stamp_map', 'set_map_data', 'confirm_map_feature']));
  });

  test('asks for the project when the session has none', () async {
    final s = await connect();
    expect(await call(s, 'get_map'), (true, 'Name the project: one of app.'));
    expect((await call(s, 'get_map', {'project': 'web'})).$2, contains('No project "web"'));
  });

  test('writes a feature, warns, refuses a stamp over a broken link, and tells the page', () async {
    final s = await connect(project: 'app');
    final (err, out) = await call(s, 'set_map_feature', {
      'id': 'cache',
      'paths': ['lib'],
      'feature': {
        'title': 'Cache',
        'links': [
          {'feature': 'sync', 'kind': 'calls'},
        ],
      },
    });
    expect(err, isFalse);
    expect((out! as Map)['warnings'], ['No feature "sync" in the map yet: write it in this pass, or fix the link.']);
    expect(maps.changed, ['app']);
    expect(maps.done, ['cache']);
    expect(
      (await call(s, 'plan_map', {
        'features': ['cache', 'sync'],
      })).$2,
      {'planned': 2},
    );
    expect(maps.planned, ['cache', 'sync']);
    final (stampErr, msg) = await call(s, 'stamp_map');
    expect(stampErr, isTrue);
    expect(msg, contains('cache -> sync'));
    final (_, map) = await call(s, 'get_map');
    expect(((map! as Map)['features'] as List).single['id'], 'cache');
    expect((map as Map)['brokenLinks'], [
      {'from': 'cache', 'to': 'sync'},
    ]);
  });

  test('returns a refusal as a tool error the agent can read', () async {
    final s = await connect(project: 'app');
    final (err, msg) = await call(s, 'set_map_feature', {
      'id': 'Bad Id',
      'paths': ['lib'],
      'feature': {'title': 'x'},
    });
    expect(err, isTrue);
    expect(msg, contains('lowercase slug'));
  });
}
