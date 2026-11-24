import 'dart:io';

import 'package:deck/core/models/activity.dart';
import 'package:deck/data/activity_store.dart';
import 'package:deck/data/deck_home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late ActivityStore store;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('deck-activity');
    store = ActivityStore(DeckHome(dir.path));
  });
  tearDown(() => dir.deleteSync(recursive: true));

  test('logs an event once per id and reads days across months', () async {
    await store.add([
      Activity(at: DateTime(2026, 9, 30, 17), kind: 'merged', title: 'Rate limit', id: 'merged:a'),
      Activity(at: DateTime(2026, 10, 1, 9), kind: 'note', title: 'Planned the retro'),
      Activity(at: DateTime(2026, 10, 2, 9), kind: 'note', title: 'Out of range'),
    ]);
    final again = await store.add([Activity(at: DateTime(2026, 9, 30, 18), kind: 'merged', title: 'Rate limit', id: 'merged:a')]);
    expect(again, isEmpty);
    final got = await store.read(DateTime(2026, 9, 30), DateTime(2026, 10, 1));
    expect(got.map((e) => e.title), ['Rate limit', 'Planned the retro']);
    expect(File('${dir.path}/state/activity/2026-09.jsonl').readAsLinesSync(), hasLength(1));
  });
}
