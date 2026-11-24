// Golden screenshots of the feature map's diagrams, drawn from made up samples.
// Update with: flutter test --update-goldens test/golden/map_diagrams_test.dart
@Tags(['golden'])
library;

import 'package:deck/dev/map_samples.dart';
import 'package:deck/ui/map/class_graph.dart';
import 'package:deck/ui/map/sequence_view.dart';
import 'package:deck/ui/map/state_view.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fonts.dart';

void main() {
  late bool fonts;
  setUpAll(() async => fonts = await loadFonts());

  Future<void> shot(
    WidgetTester t,
    String name,
    Widget child, {
    Brightness brightness = Brightness.light,
    Size size = const Size(1100, 800),
    Future<void> Function(WidgetTester)? go,
  }) async {
    if (!fonts) return markTestSkipped('macOS fonts not found');
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: deckTheme(brightness),
        home: Scaffold(
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
    await t.pump(const Duration(milliseconds: 100));
    if (go != null) await go(t);
    await t.pump(const Duration(milliseconds: 400));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));
  }

  const sequence = SequencePlayer(sequence: sampleSequence);
  Future<void> pickStep(WidgetTester t) async {
    await t.tap(find.text('Log the watering'));
    await t.pump(const Duration(milliseconds: 100));
  }

  testWidgets('sequence, overview', (t) => shot(t, 'map_sequence', sequence));
  testWidgets('sequence, a step picked', (t) => shot(t, 'map_sequence_step', sequence, go: pickStep));
  testWidgets('sequence, dark', (t) => shot(t, 'map_sequence_dark', sequence, brightness: Brightness.dark, go: pickStep));
  testWidgets('sequence, narrow', (t) => shot(t, 'map_sequence_narrow', sequence, size: const Size(640, 1300)));

  const state = StateDiagramView(state: sampleState);
  Future<void> pickLeak(WidgetTester t) async {
    await t.tap(find.text('Leak'));
    await t.pump(const Duration(milliseconds: 100));
  }

  testWidgets('state', (t) => shot(t, 'map_state', state));
  testWidgets('state, a transition picked', (t) => shot(t, 'map_state_picked', state, go: pickLeak));
  testWidgets('state, dark', (t) => shot(t, 'map_state_dark', state, brightness: Brightness.dark, go: pickLeak));
  testWidgets('state, left to right', (t) => shot(t, 'map_state_lr', const StateDiagramView(state: sampleStateLr), size: const Size(1400, 600)));

  const graph = ClassGraphView(graph: sampleGraph, featureTitles: {'history': 'Garden history'});
  Future<void> pickValve(WidgetTester t) async {
    await t.tap(find.text('ValveDriver'));
    await t.pump(const Duration(milliseconds: 100));
  }

  testWidgets('class graph, lanes', (t) => shot(t, 'map_classes', graph, size: const Size(1300, 700)));
  testWidgets('class graph, a class picked', (t) => shot(t, 'map_classes_picked', graph, go: pickValve));
  testWidgets('class graph, dark', (t) => shot(t, 'map_classes_dark', graph, brightness: Brightness.dark, go: pickValve));
  testWidgets('class graph, busy', (t) => shot(t, 'map_classes_big', const ClassGraphView(graph: sampleBigGraph), size: const Size(1300, 1000)));
}
