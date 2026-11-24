import 'dart:ui';

import 'package:deck/ui/map/layered_layout.dart';
import 'package:flutter_test/flutter_test.dart';

const _box = Size(100, 40);

/// Two rects overlap by more than a hair.
bool _overlap(Rect a, Rect b) => a.deflate(.5).overlaps(b.deflate(.5));

void _noOverlaps(List<Rect> rects) {
  for (var a = 0; a < rects.length; a++) {
    for (var b = a + 1; b < rects.length; b++) {
      expect(_overlap(rects[a], rects[b]), isFalse, reason: '$a ${rects[a]} overlaps $b ${rects[b]}');
    }
  }
}

void main() {
  test('a chain goes down, one rank per edge', () {
    final g = layeredLayout(List.filled(3, _box), const [LayoutEdge(0, 1), LayoutEdge(1, 2)]);
    expect(g.nodes[0].bottom, lessThan(g.nodes[1].top));
    expect(g.nodes[1].bottom, lessThan(g.nodes[2].top));
    // Straight down: nothing pulls them sideways.
    expect(g.nodes[0].center.dx, closeTo(g.nodes[2].center.dx, .01));
    expect(g.edges[0].points.first.dy, g.nodes[0].bottom);
    expect(g.edges[0].points.last.dy, g.nodes[1].top);
  });

  test('a fan out sits side by side without overlaps, labels clear of boxes', () {
    final edges = [for (var i = 1; i < 6; i++) LayoutEdge(0, i, label: const Size(70, 16))];
    final g = layeredLayout(List.filled(6, _box), edges);
    _noOverlaps([...g.nodes, for (final e in g.edges) e.label!]);
    for (var i = 2; i < 6; i++) {
      expect(g.nodes[i].top, g.nodes[1].top);
    }
    expect(g.size.width, greaterThanOrEqualTo(g.nodes.map((r) => r.right).reduce((a, b) => a > b ? a : b)));
  });

  test('a cycle still lays out; the back edge runs from its source to its target', () {
    final g = layeredLayout(List.filled(3, _box), const [LayoutEdge(0, 1), LayoutEdge(1, 2), LayoutEdge(2, 0)], first: const [0]);
    expect(g.nodes[0].top, lessThan(g.nodes[2].top));
    final back = g.edges[2].points;
    expect(back.first.dy, g.nodes[2].top);
    expect(back.last.dy, g.nodes[0].bottom);
    expect(routeDirection(back).dy, lessThan(0));
  });

  test('crossings get removed by the ordering', () {
    // 0 and 1 on top, 2 and 3 below, wired crosswise in the input order.
    final g = layeredLayout(List.filled(4, _box), const [LayoutEdge(0, 3), LayoutEdge(1, 2), LayoutEdge(0, 3), LayoutEdge(1, 2)]);
    expect(g.nodes[0].center.dx < g.nodes[1].center.dx, g.nodes[3].center.dx < g.nodes[2].center.dx);
  });

  test('lanes are columns that keep their nodes', () {
    final g = layeredLayout(List.filled(4, _box), const [LayoutEdge(0, 1), LayoutEdge(1, 2), LayoutEdge(2, 3)], lanes: const [0, 1, 0, 1]);
    expect(g.lanes.length, 2);
    expect(g.lanes[0].right, lessThan(g.lanes[1].left));
    for (final (i, l) in [0, 1, 0, 1].indexed) {
      expect(g.lanes[l].inflate(.01).contains(g.nodes[i].topLeft) && g.lanes[l].inflate(.01).contains(g.nodes[i].bottomRight), isTrue);
    }
  });

  test('lanes keep their nodes even when edges pull them towards another lane', () {
    // A tangle across three lanes, the same every run.
    var seed = 7;
    int next(int m) => (seed = (seed * 1103515245 + 12345) & 0x7fffffff) % m;
    const n = 16;
    final lanes = [for (var i = 0; i < n; i++) i % 3];
    final edges = [
      for (var k = 0; k < 26; k++)
        () {
          final a = next(n), b = next(n);
          return LayoutEdge(a, a == b ? (b + 1) % n : b, label: next(2) == 0 ? const Size(90, 16) : Size.zero);
        }(),
    ];
    final g = layeredLayout(List.filled(n, _box), edges, lanes: lanes);
    for (var i = 0; i < n; i++) {
      final lane = g.lanes[lanes[i]].inflate(.01);
      expect(lane.contains(g.nodes[i].topLeft) && lane.contains(g.nodes[i].bottomRight), isTrue, reason: 'node $i ${g.nodes[i]} out of ${g.lanes[lanes[i]]}');
    }
    _noOverlaps(g.nodes);
  });

  test('a hub with many leaves stacks them in rows of fanRow', () {
    final edges = [for (var i = 1; i < 9; i++) LayoutEdge(0, i, label: const Size(60, 16))];
    final g = layeredLayout(List.filled(9, _box), edges, fanRow: 4);
    final rows = {for (var i = 1; i < 9; i++) g.nodes[i].top}.toList();
    expect(rows.length, 2);
    for (final top in rows) {
      expect([for (var i = 1; i < 9; i++) g.nodes[i].top].where((t) => t == top).length, 4);
    }
    _noOverlaps([...g.nodes, for (final e in g.edges) e.label!]);
    // Without it they share one rank.
    expect({for (var i = 1; i < 9; i++) layeredLayout(List.filled(9, _box), edges).nodes[i].top}.length, 1);
  });

  test('backAside runs a long return beside the ranks it crosses', () {
    // A chain with a side branch, and a return from the bottom to the top.
    const edges = [LayoutEdge(0, 1), LayoutEdge(1, 2), LayoutEdge(2, 3), LayoutEdge(1, 4), LayoutEdge(3, 0)];
    final g = layeredLayout(List.filled(5, _box), edges, first: const [0], backAside: true);
    final back = g.edges[4].points;
    for (final p in back.sublist(1, back.length - 1)) {
      for (final r in [g.nodes[1], g.nodes[2], g.nodes[4]]) {
        if (p.dy >= r.top && p.dy <= r.bottom) expect(p.dx, greaterThan(r.right), reason: '$p beside $r');
      }
    }
  });

  test('horizontal goes left to right, self edges keep room', () {
    final g = layeredLayout(List.filled(2, _box), const [LayoutEdge(0, 1), LayoutEdge(1, 1)], horizontal: true, selfLoop: 30);
    expect(g.nodes[0].right, lessThan(g.nodes[1].left));
    expect(g.nodes[1].size, _box);
    expect(g.edges[1].self, isTrue);
    expect(g.size.height, greaterThanOrEqualTo(g.nodes[1].bottom + 30));
    expect(routeDirection(g.edges[0].points, horizontal: true).dx, greaterThan(0));
  });

  test('nothing to lay out is fine', () {
    expect(layeredLayout(const [], const []).size, Size.zero);
  });
}
