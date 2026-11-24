// Serves an MCP server over the MCP "streamable HTTP" transport, so every
// Claude session (background or in your terminal) reaches the same running
// app at http://127.0.0.1:<port>/mcp.
//
// dart_mcp only knows stream channels. Each HTTP session gets its own channel
// and its own server instance: a POSTed request is pushed into the channel and
// the matching response is returned as plain JSON. No server push (GET) yet.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_mcp/server.dart' show MCPServer;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:stream_channel/stream_channel.dart';

/// [query] holds the query parameters of the session's URL: `run` and
/// `project` are set by Deck for its background runs, absent for your own
/// sessions.
typedef ServerFactory = MCPServer Function(StreamChannel<String> channel, Map<String, String> query);

class _Session {
  _Session(ServerFactory factory, Map<String, String> query) {
    server = factory(StreamChannel(_in.stream, _out.sink), query);
    _out.stream.listen((line) {
      final msg = jsonDecode(line) as Map<String, Object?>;
      final id = msg['id'];
      // Responses to our pending requests. Server initiated messages
      // (logging, pings) are dropped: we offer no push channel.
      if (id != null && !msg.containsKey('method')) _pending.remove(jsonEncode(id))?.complete(msg);
    });
  }

  final _in = StreamController<String>();
  final _out = StreamController<String>();
  final _pending = <String, Completer<Map<String, Object?>>>{};
  late final MCPServer server;

  Future<Map<String, Object?>?> handle(Map<String, Object?> msg) {
    final id = msg['id'];
    _in.add(jsonEncode(msg));
    if (id == null || !msg.containsKey('method')) return Future.value(null);
    final done = Completer<Map<String, Object?>>();
    _pending[jsonEncode(id)] = done;
    return done.future;
  }

  Future<void> close() async {
    await server.shutdown();
    await _in.close();
  }
}

class HttpMcpHost {
  HttpMcpHost(this.factory, {this.onHook});

  final ServerFactory factory;

  /// `POST /tab?id=<tab>&session=<id>&state=<working|blocked|done>`, from the
  /// Claude hooks Deck gives the sessions it starts. The tab is missing in
  /// an outside terminal.
  final void Function(int? tab, String? session, String state)? onHook;
  final _sessions = <String, _Session>{};
  HttpServer? _http;

  String _newId() {
    final r = Random.secure();
    return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }

  Future<Response> _handle(Request req) async {
    if (req.url.path == 'tab' && req.method == 'POST') {
      final q = req.url.queryParameters;
      final id = int.tryParse(q['id'] ?? '');
      final session = q['session'];
      final state = q['state'];
      if (!const {'working', 'blocked', 'done'}.contains(state)) return Response.badRequest();
      onHook?.call(id, session == null || session.isEmpty ? null : session, state!);
      return Response.ok('');
    }
    if (req.url.path != 'mcp') return Response.notFound('Not found');
    final sid = req.headers['mcp-session-id'];
    if (req.method == 'DELETE') {
      await _sessions.remove(sid)?.close();
      return Response.ok('');
    }
    if (req.method != 'POST') return Response(405, headers: {'allow': 'POST, DELETE'});

    final body = jsonDecode(await req.readAsString());
    final batch = body is List;
    final msgs = (batch ? body : [body]).cast<Map<String, Object?>>();
    var id = sid;
    _Session? session = sid == null ? null : _sessions[sid];
    if (session == null) {
      if (!msgs.any((m) => m['method'] == 'initialize')) {
        return Response(
          404,
          body: jsonEncode({
            'jsonrpc': '2.0',
            'error': {'code': -32001, 'message': 'Unknown session'},
          }),
        );
      }
      id = _newId();
      session = _sessions[id] = _Session(factory, req.url.queryParameters);
    }
    final replies = (await Future.wait(msgs.map(session.handle))).whereType<Map<String, Object?>>().toList();
    final headers = {'content-type': 'application/json', 'mcp-session-id': id!};
    if (replies.isEmpty) return Response(202, headers: headers);
    return Response.ok(jsonEncode(batch ? replies : replies.single), headers: headers);
  }

  Future<void> start({int port = 4778}) async {
    _http = await shelf_io.serve(_handle, InternetAddress.loopbackIPv4, port);
  }

  Future<void> stop() async {
    for (final s in _sessions.values) {
      await s.close();
    }
    _sessions.clear();
    await _http?.close(force: true);
  }
}
