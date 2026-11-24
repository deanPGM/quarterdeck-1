import 'dart:convert';
import 'dart:io';

import 'package:deck/core/models/config.dart';
import 'package:deck/core/models/session_progress.dart';
import 'package:deck/sources/claude_sessions.dart';
import 'package:flutter_test/flutter_test.dart';

String _l(Map<String, Object?> e) => jsonEncode({'entrypoint': 'cli', 'cwd': '/Users/sam/projects/vpn-ios', ...e});
String _you(String at, String text) => _l({
  'type': 'user',
  'timestamp': at,
  'origin': {'kind': 'human'},
  'message': {'content': text},
});
String _tool(String at) => _l({
  'type': 'user',
  'timestamp': at,
  'message': {
    'content': [
      {'type': 'tool_result'},
    ],
  },
});
String _claude(String at, String stop, String text) => _l({
  'type': 'assistant',
  'timestamp': at,
  'message': {
    'stop_reason': stop,
    'content': [
      {'type': 'text', 'text': text},
    ],
  },
});

void main() {
  test('a session gives one line per day with your prompts and its title', () {
    final days = parseSessionDays('s1', [
      _you('2026-10-14T09:00:00Z', 'Fix the cold start'),
      _tool('2026-10-14T09:01:00Z'),
      _you('2026-10-14T10:00:00Z', 'Now the tests'),
      _you('2026-10-15T08:00:00Z', 'Ship it'),
      jsonEncode({'type': 'ai-title', 'aiTitle': 'Tunnel cold start fix'}),
    ]);
    expect(days.map((d) => (d.title, d.prompts)), [('Tunnel cold start fix', 2), ('Tunnel cold start fix', 1)]);
    final a = sessionActivity(days.first, const [ProjectConfig(id: 'vpn', name: 'VPN iOS', dir: '/Users/sam/projects/vpn-ios')]);
    expect(a.project, 'VPN iOS');
    expect(a.id, startsWith('session:s1:2026-10-1'));
  });

  test('claude -p sessions and sessions without a prompt are not logged', () {
    expect(
      parseSessionDays('w', [
        jsonEncode({'entrypoint': 'sdk-cli', 'type': 'user', 'cwd': '/x', 'timestamp': '2026-10-15T08:00:00Z'}),
      ]),
      isEmpty,
    );
    expect(parseSessionDays('e', [_tool('2026-10-15T08:00:00Z')]), isEmpty);
  });

  test('progress: waiting after Claude ends its turn, working while tools run', () {
    final now = DateTime(2026, 10, 15, 12);
    final done = parseProgress([_you('2026-10-15T09:00:00Z', 'Go'), _claude('2026-10-15T09:05:00Z', 'end_turn', 'Plan ready.\nDetails')], now, now)!;
    expect((done.status, done.last), (SessionStatus.done, 'Plan ready.'));
    final busy = parseProgress([_you('2026-10-15T09:00:00Z', 'Go'), _claude('2026-10-15T09:01:00Z', 'tool_use', 'Reading the code')], now, now)!;
    expect(busy.status, SessionStatus.working);
    expect(parseProgress([_claude('2026-10-15T09:01:00Z', 'tool_use', 'x')], now.subtract(const Duration(minutes: 10)), now)!.status, SessionStatus.idle);
    expect(parseProgress([_claude('2026-10-15T09:01:00Z', 'end_turn', 'x')], now, now, open: false)!.status, SessionStatus.closed);
  });

  test('a session is open while Claude Code has its sessions file', () {
    final dir = Directory.systemTemp.createTempSync('sessions');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/123.json').writeAsStringSync(jsonEncode({'pid': 123, 'sessionId': 'abc'}));
    File('${dir.path}/123.abc.key').writeAsStringSync('x');
    expect(sessionOpen('abc', dir: dir.path), isTrue);
    expect(sessionOpen('other', dir: dir.path), isFalse);
    File('${dir.path}/123.json').deleteSync();
    expect(sessionOpen('abc', dir: dir.path), isFalse);
  });
}
