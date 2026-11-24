// The review tools through a real MCP client, the way a review session calls them.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:deck/core/review/review.dart';
import 'package:deck/data/deck_home.dart';
import 'package:deck/data/review_store.dart';
import 'package:deck/mcp/deck_server.dart';
import 'package:deck/mcp/review_tools.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:stream_channel/stream_channel.dart';

class _Reviews implements ReviewBackend {
  _Reviews(this.service);

  final ReviewService service;
  final changed = <String>[];

  @override
  Future<ReviewService?> reviewOf(String project, String id) async => project == 'app' && id == 'gitlab-7' ? service : null;

  @override
  void reviewChanged(String project, String id) => changed.add(id);
}

class _NoBoard implements DeckBackend {
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  late Directory tmp;
  late _Reviews reviews;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('deck-rtools-');
    final root = p.join(tmp.path, 'repo');
    Directory(root).createSync();
    void git(List<String> a) =>
        Process.runSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@example.com', '-c', 'commit.gpgsign=false', ...a], workingDirectory: root);
    git(['init', '-q', '-b', 'main']);
    File(p.join(root, 'a.dart')).writeAsStringSync('void a() {}\n');
    git(['add', '.']);
    git(['commit', '-q', '-m', 'base']);
    git(['checkout', '-q', '-b', 'feat']);
    File(p.join(root, 'a.dart')).writeAsStringSync('void a() {}\nvoid b() {}\n');
    git(['commit', '-qam', 'b']);
    final store = ReviewStore(DeckHome(p.join(tmp.path, 'deck')));
    await store.save(const Review(id: 'gitlab-7', project: 'app', baseRef: 'main', headRef: 'feat'));
    reviews = _Reviews(ReviewService(store, store.load('app', 'gitlab-7')!, root));
  });

  tearDown(() => tmp.deleteSync(recursive: true));

  Future<ServerConnection> connect({String? project, String? review}) async {
    final toServer = StreamController<String>(), toClient = StreamController<String>();
    DeckMcpServer(StreamChannel(toServer.stream, toClient.sink), _NoBoard(), reviews: reviews, project: project, review: review);
    final s = MCPClient(Implementation(name: 't', version: '0')).connectServer(StreamChannel(toClient.stream, toServer.sink));
    await s.initialize(
      InitializeRequest(
        protocolVersion: ProtocolVersion.latestSupported,
        capabilities: ClientCapabilities(),
        clientInfo: Implementation(name: 't', version: '0'),
      ),
    );
    s.notifyInitialized();
    return s;
  }

  Future<(bool, Object?)> call(ServerConnection s, String tool, [Map<String, Object?> args = const {}]) async {
    final r = await s.callTool(CallToolRequest(name: tool, arguments: args));
    final text = (r.content.single as TextContent).text;
    return (r.isError ?? false, r.isError ?? false ? text : jsonDecode(text));
  }

  test('reads the diff in Skim\'s shape and writes notes, telling the page', () async {
    final s = await connect(project: 'app', review: 'gitlab-7');
    final (_, diff) = await call(s, 'get_diff');
    final file = ((diff! as Map)['files'] as List).single as Map;
    expect(file['path'], 'a.dart');
    final ref = ((file['hunks'] as List).single as Map)['ref'];
    expect((await call(s, 'set_file_note', {'path': 'a.dart', 'summary': 'Adds b'})).$2, {'written': 1});
    expect(
      (await call(s, 'set_hunk_note', {
        'notes': [
          {'path': 'a.dart', 'hunk_ref': ref, 'summary': 'b'},
        ],
      })).$2,
      {'written': 1},
    );
    expect(reviews.changed, ['gitlab-7', 'gitlab-7']);
    final (err, msg) = await call(s, 'set_groups', {
      'groups': [
        {
          'title': 'x',
          'items': [
            {'path': 'nope'},
          ],
        },
      ],
    });
    expect((err, msg), (true, 'Path not in diff: nope'));
  });

  test('says how to name the review when the session has none', () async {
    final s = await connect();
    expect((await call(s, 'get_review')).$1, isTrue);
    expect((await call(s, 'get_ticket', {'project': 'app', 'review': 'gitlab-7'})).$2, containsPair('status', 'none'));
  });

  test('threads: the agent adds, talks, writes the answer, fixes and withdraws', () async {
    final s = await connect(project: 'app', review: 'gitlab-7');
    final (_, t) = await call(s, 'add_thread', {'path': 'a.dart', 'line': 2, 'body': 'b is unused', 'severity': 'nit'});
    final id = (t! as Map)['id'] as String;
    expect(t, containsPair('authorType', 'agent'));
    expect((t as Map)['anchor'], containsPair('hunk_ref', isA<String>()));
    expect(t['answer'], containsPair('body', 'b is unused'));
    expect((await call(s, 'add_thread', {'path': 'a.dart', 'line': 9, 'body': 'x', 'severity': 'nit'})).$1, isTrue);
    expect((await call(s, 'add_thread', {'body': 'No test', 'severity': 'question'})).$2, isNot(contains('anchor')));

    await reviews.service.reply(id, body: 'why?', author: 'user');
    expect(((await call(s, 'list_threads', {'waiting': true})).$2! as List).single, containsPair('id', id));
    expect((await call(s, 'reply', {'thread_id': id, 'body': 'b is never called', 'suggestion': ''})).$2, containsPair('waiting', false));
    final (_, revised) = await call(s, 'set_answer', {'thread_id': id, 'body': 'b is never called: drop it'});
    expect((revised! as Map)['answer'], containsPair('body', 'b is never called: drop it'));
    expect(((revised as Map)['messages'] as List).map((m) => (m as Map)['body']), ['why?', 'b is never called']);
    expect((await call(s, 'set_thread_state', {'thread_id': id, 'state': 'resolved'})).$1, isTrue);
    expect((await call(s, 'mark_fixed', {'thread_id': id, 'body': 'Changed, not committed.'})).$2, containsPair('fix', 'uncommitted'));
    expect((await call(s, 'set_thread_state', {'thread_id': id, 'state': 'dismissed'})).$2, containsPair('state', 'dismissed'));
  });
}
