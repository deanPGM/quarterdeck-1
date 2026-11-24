import 'dart:io';

import 'package:deck/data/deck_home.dart';
import 'package:deck/data/run_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RunWatch counts tool calls, tool errors, refusals and failed MCP servers', () {
    final w = RunWatch()
      ..add({
        'type': 'system',
        'subtype': 'init',
        'mcp_servers': [
          {'name': 'deck', 'status': 'connected'},
          {'name': 'slack', 'status': 'failed'},
        ],
      })
      ..add({
        'type': 'assistant',
        'message': {
          'content': [
            {'type': 'text', 'text': 'Reading tasks'},
            {'type': 'tool_use', 'id': 't1', 'name': 'mcp__deck__deck_tasks'},
            {'type': 'tool_use', 'id': 't2', 'name': 'mcp__deck__deck_submit'},
          ],
        },
      })
      ..add({
        'type': 'user',
        'message': {
          'content': [
            {'type': 'tool_result', 'tool_use_id': 't1'},
            {'type': 'tool_result', 'tool_use_id': 't2', 'is_error': true},
          ],
        },
      })
      ..add({
        'type': 'result',
        'num_turns': 3,
        'duration_api_ms': 4200,
        'total_cost_usd': 0.02,
        'usage': {'input_tokens': 10, 'output_tokens': 5, 'cache_read_input_tokens': 900},
        'permission_denials': [
          {'tool_name': 'Bash', 'tool_use_id': 't3'},
        ],
      });
    expect(w.toolCalls, {'mcp__deck__deck_tasks': 1, 'mcp__deck__deck_submit': 1});
    expect(w.toolErrors, {'mcp__deck__deck_submit': 1});
    expect(w.mcpFailed, ['slack: failed']);
    final t = w.totals;
    expect((t.turns, t.apiSeconds, t.cost), (3, 4, 0.02));
    expect(t.denials, ['Bash']);
    expect(t.tokens, {'input': 10, 'output': 5, 'cacheRead': 900});
  });

  test('RunLog writes a line per run and reads a range back', () async {
    final dir = await Directory.systemTemp.createTemp('runlog');
    addTearDown(() => dir.delete(recursive: true));
    final log = _on(dir);
    final oct = DateTime(2026, 10, 31, 23), nov = DateTime(2026, 11, 2, 9);
    final a = RunRecord(id: runIdOf(oct, 'map:all', 'abc'), kind: 'map:all', at: oct, outcome: RunOutcome.timeout, toolErrors: const {'Bash': 2});
    final b = RunRecord(id: runIdOf(nov, 'worker', 'def'), kind: 'worker', at: nov, outcome: RunOutcome.ok, costUsd: 0.01, tokens: const {'input': 3});
    await log.add(b);
    await log.add(a);
    final both = await log.read(DateTime(2026, 10, 1), DateTime(2026, 11, 30));
    expect([for (final r in both) r.id], ['20261031-230000-map_all-abc', '20261102-090000-worker-def']);
    expect(both.first.outcome, RunOutcome.timeout);
    expect(both.first.toolErrors, {'Bash': 2});
    expect(both.last.tokens, {'input': 3});
    expect(await log.read(DateTime(2026, 11, 1), DateTime(2026, 11, 1)), isEmpty);
  });

  test('RunLog skips a broken line and sums what a session already cost', () async {
    final dir = await Directory.systemTemp.createTemp('runlog');
    addTearDown(() => dir.delete(recursive: true));
    final log = _on(dir);
    final now = DateTime.now();
    RunRecord run(String tag, double cost, int api, {String session = 's1'}) =>
        RunRecord(id: runIdOf(now, 'review', tag), kind: 'review', at: now, outcome: RunOutcome.ok, sessionId: session, costUsd: cost, apiSeconds: api);
    await log.add(run('a', 2.5, 300));
    final month = File('${dir.path}/cache/runs/${now.year}-${'${now.month}'.padLeft(2, '0')}.jsonl');
    month.writeAsStringSync('e__knowledge"}\n', mode: FileMode.append);
    await log.add(run('b', 0.2, 10));
    await log.add(run('c', 9, 99, session: 's2'));
    expect((await log.read(now, now)).length, 3);
    final spent = await log.spentBy('s1');
    expect(spent.cost, closeTo(2.7, 1e-9));
    expect(spent.apiSeconds, 310);
  });

  test('tailOf cuts the MCP tool list', () {
    expect(tailOf('Error: tool x not found. Available MCP tools: a, b, c\nmore'), 'Error: tool x not found. Available MCP tools: …\nmore');
  });

  test('openLog drops logs older than 30 days', () async {
    final dir = await Directory.systemTemp.createTemp('runlog');
    addTearDown(() => dir.delete(recursive: true));
    final log = _on(dir);
    final old = log.logOf('old')..createSync(recursive: true);
    old.setLastModifiedSync(DateTime.now().subtract(const Duration(days: 31)));
    await (log.openLog('new')..writeln('x')).close();
    expect(old.existsSync(), isFalse);
    expect(log.logOf('new').readAsStringSync(), 'x\n');
  });

  test('RunLog keeps nothing until the setting is on', () async {
    final dir = await Directory.systemTemp.createTemp('runlog');
    addTearDown(() => dir.delete(recursive: true));
    final log = RunLog(DeckHome(dir.path));
    expect(log.on, isFalse);
    final now = DateTime.now();
    await log.add(RunRecord(id: runIdOf(now, 'worker', 'x'), kind: 'worker', at: now, outcome: RunOutcome.ok));
    await log.addIssue({'at': now.toIso8601String(), 'kind': 'bug', 'what': 'x'});
    expect(Directory('${dir.path}/cache/runs').existsSync(), isFalse);
    expect(_on(dir).on, isTrue);
  });
}

/// A ledger in [dir] with Settings › Claude › Keep a run log on.
RunLog _on(Directory dir) {
  File('${dir.path}/deck.json').writeAsStringSync('{"claude": {"collectRuns": true}}');
  return RunLog(DeckHome(dir.path));
}
