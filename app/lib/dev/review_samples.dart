// Made up diffs for Widgetbook and the golden tests of the review screen: the
// same garden watering app as the map samples. Never real work data.
import '../core/review/diff.dart';

/// Builds a DiffFile from a tiny patch: `@@ -a,b +c,d @@ heading` starts a
/// hunk, then one line each, prefixed ' ', '-', '+', or '<' and '>' for a
/// deleted and an added line git marked as moved.
DiffFile samplePatch(String path, String patch, {String status = 'modified', String? oldPath, List<String> tags = const []}) {
  final hunks = <Hunk>[];
  var oldNo = 0, newNo = 0;
  final header = RegExp(r'^@@ -(\d+),(\d+) \+(\d+),(\d+) @@ ?(.*)$');
  for (final raw in patch.trimRight().split('\n')) {
    final h = header.firstMatch(raw);
    if (h != null) {
      int g(int i) => int.parse(h[i]!);
      oldNo = g(1);
      newNo = g(3);
      hunks.add(Hunk(header: h[5]!, oldStart: g(1), oldCount: g(2), newStart: g(3), newCount: g(4), lines: [], ref: '$path#${hunks.length}'));
      continue;
    }
    if (hunks.isEmpty) continue;
    // An empty line is a blank context line whose leading space got trimmed.
    final content = raw.isEmpty ? '' : raw.substring(1);
    hunks.last.lines.add(switch (raw.isEmpty ? ' ' : raw[0]) {
      '-' || '<' => DiffLine(type: lineDelete, content: content, oldLine: oldNo++, moved: raw[0] == '<'),
      '+' || '>' => DiffLine(type: lineAdd, content: content, newLine: newNo++, moved: raw[0] == '>'),
      _ => DiffLine(type: lineContext, content: content, oldLine: oldNo++, newLine: newNo++),
    });
  }
  // Counts come from the lines, so a hand written header cannot be off by one.
  final counted = [
    for (final h in hunks)
      Hunk(
        header: h.header,
        oldStart: h.oldStart,
        oldCount: h.lines.where((l) => l.type != lineAdd).length,
        newStart: h.newStart,
        newCount: h.lines.where((l) => l.type != lineDelete).length,
        lines: h.lines,
        ref: h.ref,
      ),
  ];
  final lines = counted.expand((h) => h.lines);
  int count(String type, {bool real = false}) => lines.where((l) => l.type == type && !(real && l.moved)).length;
  return DiffFile(oldPath: oldPath ?? path, newPath: path, path: path, status: status, hunks: counted, additions: count(lineAdd), deletions: count(lineDelete))
    ..realAdditions = count(lineAdd, real: true)
    ..realDeletions = count(lineDelete, real: true)
    ..tags = [...tags];
}

/// A widget wrapped in a GestureDetector: every line inside moves right.
final sampleWrap = samplePatch('lib/garden/plant_card.dart', r'''
@@ -1,6 +1,6 @@
 import 'package:flutter/material.dart';

-import 'plant.dart';
+import '../models/plant.dart';

 /// One plant in the bed list, with its latin name under it.
 class PlantCard extends StatelessWidget {
@@ -14,18 +14,21 @@ class PlantCard extends StatelessWidget {
   final Plant plant;
   final ValueChanged<Plant> onOpen;

   @override
   Widget build(BuildContext context) {
-    return Padding(
-      padding: const EdgeInsets.all(12),
-      child: Column(
-        crossAxisAlignment: CrossAxisAlignment.start,
-        children: [
-          Text(plant.name, style: context.t.titleMedium),
-          Text(plant.latinName),
-        ],
-      ),
+    return GestureDetector(
+      onTap: () => onOpen(plant),
+      child: Padding(
+        padding: const EdgeInsets.all(12),
+        child: Column(
+          crossAxisAlignment: CrossAxisAlignment.start,
+          children: [
+            Text(plant.name, style: context.t.titleMedium),
+            Text(plant.latinName, style: context.t.bodySmall),
+          ],
+        ),
+      ),
     );
   }
 }
''');

/// A helper moved from the top of the class to the bottom, plus one real edit.
final sampleMoved = samplePatch(
  'lib/garden/watering_service.dart',
  r'''
@@ -12,15 +12,9 @@ class WateringService {
   final ValveDriver valves;
   final GardenLog log;

-  Duration _nextSlot(Bed bed) {
-    final last = log.lastWatered(bed);
-    return last == null ? Duration.zero : bed.interval - DateTime.now().difference(last);
-  }
-
<  /// Seconds of water a bed needs for its moisture.
<  int secondsFor(Bed bed, double moisture) => ((bed.threshold - moisture) * bed.flowRate).ceil();
<
   Future<void> water(Bed bed) async {
-    if (_nextSlot(bed) > Duration.zero) return;
+    if (await rain.expectedWithin(const Duration(hours: 6))) return log.skip(bed, 'rain');
     await valves.open(bed.valve, Duration(seconds: secondsFor(bed, bed.moisture)));
     log.watered(bed);
   }
@@ -40,6 +32,9 @@ class WateringService {
     await valves.closeAll();
     log.write('stopped');
   }
>
>  /// Seconds of water a bed needs for its moisture.
>  int secondsFor(Bed bed, double moisture) => ((bed.threshold - moisture) * bed.flowRate).ceil();
 }
''',
  tags: ['moved-only'],
);

/// One long change the parser split at declarations: three hunks back to back.
final sampleSplitHunk = samplePatch('lib/garden/schedule_repository.dart', r'''
@@ -20,8 +20,10 @@ class ScheduleRepository {
   ScheduleRepository(this.db);
   final Database db;

-  Future<List<Slot>> slots() async => (await db.query('slots')).map(Slot.fromRow).toList();
+  /// Every slot, the earliest first.
+  Future<List<Slot>> slots() async =>
+      (await db.query('slots', orderBy: 'starts_at')).map(Slot.fromRow).toList();

   Future<void> save(Slot slot) => db.insert('slots', slot.toRow());

@@ -27,4 +29,7 @@ class ScheduleRepository {
-  Future<void> remove(int id) => db.delete('slots', where: 'id = ?', whereArgs: [id]);
+  Future<void> remove(int id) async {
+    await db.delete('slot_beds', where: 'slot_id = ?', whereArgs: [id]);
+    await db.delete('slots', where: 'id = ?', whereArgs: [id]);
+  }

   Future<Slot?> byId(int id) async {
     final rows = await db.query('slots', where: 'id = ?', whereArgs: [id]);
@@ -31,3 +36,31 @@ class ScheduleRepository {
     return rows.isEmpty ? null : Slot.fromRow(rows.first);
   }
+
+  /// Slots that overlap [from, to), for the week view.
+  Future<List<Slot>> between(DateTime from, DateTime to) async {
+    final rows = await db.query(
+      'slots',
+      where: 'starts_at < ? AND ends_at > ?',
+      whereArgs: [to.millisecondsSinceEpoch, from.millisecondsSinceEpoch],
+      orderBy: 'starts_at',
+    );
+    return rows.map(Slot.fromRow).toList();
+  }
+
+  /// Moves every slot of a bed by [shift], for the holiday mode.
+  Future<int> shiftBed(int bedId, Duration shift) async {
+    final slots = await forBed(bedId);
+    var moved = 0;
+    for (final slot in slots) {
+      final next = slot.copyWith(startsAt: slot.startsAt.add(shift), endsAt: slot.endsAt.add(shift));
+      if (next.startsAt.isBefore(DateTime.now())) continue;
+      await db.update('slots', next.toRow(), where: 'id = ?', whereArgs: [slot.id]);
+      moved++;
+    }
+    return moved;
+  }
+
+  Future<List<Slot>> forBed(int bedId) async =>
+      (await db.query('slots', where: 'bed_id = ?', whereArgs: [bedId])).map(Slot.fromRow).toList();
 }
''');

/// A one word typo fix.
final sampleTiny = samplePatch('lib/garden/units.dart', r'''
@@ -3,5 +3,5 @@
 /// Conversions for the settings page, metric first.
 const litresPerGallon = 3.785;
-double toGallons(double litres) => litres / litresPerGalon;
+double toGallons(double litres) => litres / litresPerGallon;
 double toLitres(double gallons) => gallons * litresPerGallon;

''');

final sampleBinary = DiffFile(
  oldPath: 'assets/plants/fern.png',
  newPath: 'assets/plants/fern.png',
  path: 'assets/plants/fern.png',
  status: 'modified',
  hunks: [],
  additions: 0,
  deletions: 0,
  isBinary: true,
)..tags = ['binary'];

final sampleRenamed = samplePatch('lib/garden/seed_catalog.dart', '', status: 'renamed', oldPath: 'lib/garden/seed_list.dart', tags: ['rename-only']);

final sampleDiffFiles = [sampleWrap, sampleMoved, sampleSplitHunk, sampleTiny, sampleBinary, sampleRenamed];

/// One line per file, as the agent writes them.
const sampleFileNotes = {
  'lib/garden/plant_card.dart': 'The card opens the plant page on tap, the body is only re-indented.',
  'lib/garden/watering_service.dart': 'Skips watering when rain is expected; secondsFor moved to the end.',
  'lib/garden/schedule_repository.dart': 'Ordered slots, cascade delete, week and holiday queries.',
  'lib/garden/units.dart': 'Typo in the gallon constant name.',
};

/// One line per hunk ref.
const sampleHunkNotes = {
  'lib/garden/schedule_repository.dart#0': 'slots() now sorts by start time',
  'lib/garden/schedule_repository.dart#1': 'remove() deletes the bed links first, no foreign key cascade in SQLite here',
  'lib/garden/plant_card.dart#1': 'Wraps the card in a GestureDetector, the rest is indentation',
};

/// Plausible new side lines for the expand control.
Future<List<String>?> sampleLoadContext(int from, int to) async => [for (var n = from; n <= to; n++) '  // bed rule $n: water before ${6 + n % 4} am'];

/// A 3,000 line change, to check the view stays lazy.
DiffFile sampleBigFile({int lines = 3000}) => samplePatch(
  'lib/garden/generated_plants.dart',
  [
    '@@ -1,${lines ~/ 2} +1,${lines ~/ 2} @@',
    for (var i = 0; i < lines ~/ 2; i++) ...[
      '-  Plant(id: $i, name: \'Plant $i\', water: ${i % 7}),',
      '+  Plant(id: $i, name: \'Plant $i\', water: ${i % 9}),',
    ],
  ].join('\n'),
);
