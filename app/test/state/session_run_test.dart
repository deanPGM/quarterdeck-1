import 'package:deck/state/session_run.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _use(String name, Map<String, Object?> input) => {
  'type': 'assistant',
  'message': {
    'content': [
      {'type': 'tool_use', 'name': name, 'input': input},
    ],
  },
};

void main() {
  test('a shell command reads as words, never as the command line', () {
    expect(
      stepOf(_use('Bash', {'command': 'git ls-files Packages/Kit | head', 'description': 'List files in the kit package'})),
      'List files in the kit package',
    );
    expect(stepOf(_use('Bash', {'command': "bash -c 'git ls-files Packages/Kit | head'"})), 'Listing the files in Packages/Kit');
    expect(stepOf(_use('Bash', {'command': 'grep -rn Entitlements . | head -200'})), 'Running a command');
  });

  test('map and review tools say what they write', () {
    expect(
      stepOf(
        _use('mcp__deck__set_map_feature', {
          'id': 'vpn',
          'feature': {'title': 'VPN connect'},
        }),
      ),
      'Drew VPN connect',
    );
    expect(stepOf(_use('mcp__deck__set_groups', {})), 'Ordering the chapters');
    expect(stepOf(_use('Grep', {'pattern': 'Tunnel'})), 'Searching the code for "Tunnel"');
  });

  test('the time left follows the pace since the plan, once two pieces are done', () {
    final t0 = DateTime(2026, 10, 17, 10);
    final run = SessionRun(startedAt: t0, total: 10, countingSince: t0.add(const Duration(minutes: 5)));
    expect(run.progress('features', t0.add(const Duration(minutes: 8))), '0 of 10 features');
    final two = run.copyWith(done: {'a', 'b'});
    // 2 done in 6 minutes: 3 minutes each, 8 left.
    expect(two.remaining(t0.add(const Duration(minutes: 11))), const Duration(minutes: 24));
    expect(two.progress('features', t0.add(const Duration(minutes: 11))), '2 of 10 features · about 24 min left');
    expect(SessionRun(startedAt: _t, step: 'x').progress('features', _t), isNull);
  });
}

final _t = DateTime(2026);
