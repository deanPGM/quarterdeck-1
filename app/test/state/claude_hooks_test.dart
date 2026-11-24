// The hook commands Deck gives Claude in its tabs, run for real through the
// shell against the /tab endpoint.
import 'dart:convert';
import 'dart:io';

import 'package:deck/core/models/session_progress.dart';
import 'package:deck/mcp/http_host.dart';
import 'package:deck/state/sessions.dart';
import 'package:deck/state/terminals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const port = 47991;
  final got = <(int?, String?, String)>[];
  late HttpMcpHost host;

  setUpAll(() async {
    host = HttpMcpHost((_, _) => throw UnimplementedError(), onHook: (tab, session, s) => got.add((tab, session, s)));
    await host.start(port: port);
  });
  tearDownAll(() => host.stop());
  setUp(got.clear);

  final hooks = claudeHooks(port)['hooks']! as Map<String, Object?>;
  String command(String event) => (((hooks[event]! as List).single as Map)['hooks'] as List).single['command'] as String;

  const sid = '3f1c2a9e-0b7d-4c55-9a51-2e6f1d0c8b47';

  Future<void> fire(String event, Map<String, Object?> input, {String tab = '7'}) async {
    final p = await Process.start('/bin/sh', ['-c', command(event)], environment: {'DECK_TAB': tab});
    // Claude writes the input with spaces after the colons in some versions.
    p.stdin.write(const JsonEncoder.withIndent(' ').convert({'session_id': sid, 'cwd': '/tmp', ...input}));
    await p.stdin.close();
    expect(await p.exitCode, 0);
  }

  test('each event tells Deck the state of tab 7 and of the session', () async {
    await fire('UserPromptSubmit', {'prompt': 'hi'});
    await fire('PreToolUse', {'tool_name': 'Bash', 'tool_input': {}});
    await fire('PreToolUse', {'tool_name': 'AskUserQuestion', 'tool_input': {}});
    await fire('PostToolUse', {'tool_name': 'AskUserQuestion'});
    await fire('Notification', {'message': 'Claude needs your permission'});
    await fire('Stop', {});
    expect(got, [
      for (final s in ['working', 'working', 'blocked', 'working', 'blocked', 'done']) (7, sid, s),
    ]);
  });

  test('in an outside terminal there is no tab, only the session', () async {
    await fire('Stop', {}, tab: '');
    expect(got, [(null, sid, 'done')]);
  });

  test('the hook state wins over the transcript, except closed and a stopped turn', () {
    final at = DateTime(2026, 11, 6);
    SessionStatus? over(SessionStatus s, String? hook) => withHook(SessionProgress(status: s, last: 'x', at: at), hook)?.status;
    expect(over(SessionStatus.working, 'blocked'), SessionStatus.waiting);
    expect(over(SessionStatus.working, 'done'), SessionStatus.done);
    expect(over(SessionStatus.done, 'working'), SessionStatus.working);
    expect(over(SessionStatus.idle, 'working'), SessionStatus.idle);
    expect(over(SessionStatus.closed, 'working'), SessionStatus.closed);
    expect(over(SessionStatus.done, null), SessionStatus.done);
  });

  test('the endpoint refuses an unknown state', () async {
    final r = await HttpClient().post('127.0.0.1', port, '/tab?id=1&state=sleeping').then((r) => r.close());
    expect(r.statusCode, 400);
    expect(got, isEmpty);
  });
}
