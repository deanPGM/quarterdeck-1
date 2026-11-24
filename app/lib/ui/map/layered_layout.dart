// A small Sugiyama layout for the map's class graphs and state machines:
// break cycles, rank by longest path, order each rank by barycenters to cut
// crossings, then place boxes as close to their neighbours as the gaps allow.
// Every edge spans two ranks at least, and its label rides on the bend in the
// middle rank, so a label is a box the layout keeps clear like any other.
import 'dart:math' as math;
import 'dart:ui';

class LayoutEdge {
  const LayoutEdge(this.from, this.to, {this.label = Size.zero});
  final int from, to;

  /// Room for the label, zero when there is none.
  final Size label;
}

class EdgeRoute {
  const EdgeRoute(this.points, {this.label, this.self = false});

  /// From the edge of the source box to the edge of the target box. Empty for a self edge.
  final List<Offset> points;

  /// Where the label goes, null with none.
  final Rect? label;

  /// A node to itself: the view draws the loop beside the box.
  final bool self;
}

class LayeredGraph {
  const LayeredGraph({required this.nodes, required this.edges, required this.lanes, required this.size, required this.horizontal});
  final List<Rect> nodes;
  final List<EdgeRoute> edges;

  /// One band per lane, in lane order, empty without lanes.
  final List<Rect> lanes;
  final Size size;
  final bool horizontal;
}

/// Lays out [sizes] boxes joined by [edges], top to bottom, or left to right
/// when [horizontal]. [lanes] gives each node a lane index: lanes are columns
/// (rows when horizontal) that never mix. [first] nodes start the ranking, such
/// as the start state. [selfLoop] is room kept beside a box with a self edge,
/// across the flow: right of it top to bottom, under it left to right.
/// [fanRow] caps how many leaves of one box share a rank: a box that feeds
/// (or is fed by) more leaves than that stacks them in rows, so a hub with
/// ten helpers is not one very wide line. Zero keeps them in one rank.
/// [backAside] runs the edges that go back more than one rank against the flow
/// down the far side of every rank they cross, so they read as returns instead of tangling the middle.
LayeredGraph layeredLayout(
  List<Size> sizes,
  List<LayoutEdge> edges, {
  List<int>? lanes,
  List<int> first = const [],
  bool horizontal = false,
  double gap = 28,
  double layerGap = 14,
  double laneGap = 40,
  double selfLoop = 0,
  bool backAside = false,
  int fanRow = 0,
}) {
  final n = sizes.length;
  // Work top to bottom; a horizontal layout is the same one, transposed at the end.
  Size tb(Size s) => horizontal ? Size(s.height, s.width) : s;
  final looped = {
    for (final e in edges)
      if (e.from == e.to) e.from,
  };
  final slot = [for (var i = 0; i < n; i++) tb(sizes[i]) + (looped.contains(i) ? Offset(selfLoop, 0) : Offset.zero)];
  final lane = [for (var i = 0; i < n; i++) lanes == null ? 0 : lanes[i]];
  final laneCount = lanes == null || n == 0 ? 1 : lane.reduce(math.max) + 1;

  // Break cycles: an edge back to a node still on the DFS stack is turned around.
  final out = List.generate(n, (_) => <int>[]);
  final indeg = List.filled(n, 0);
  for (final (i, e) in edges.indexed) {
    if (e.from == e.to) continue;
    out[e.from].add(i);
    indeg[e.to]++;
  }
  final roots = [
    ...first,
    for (var i = 0; i < n; i++)
      if (indeg[i] == 0) i,
    for (var i = 0; i < n; i++) i,
  ];
  final state = List.filled(n, 0);
  final reversed = List.filled(edges.length, false);
  final discovered = <int>[];
  void dfs(int u) {
    state[u] = 1;
    discovered.add(u);
    for (final i in out[u]) {
      final v = edges[i].to;
      if (state[v] == 1) {
        reversed[i] = true;
      } else if (state[v] == 0) {
        dfs(v);
      }
    }
    state[u] = 2;
  }

  for (final r in roots) {
    if (state[r] == 0) dfs(r);
  }
  final dag = <(int, int, int)>[
    for (final (i, e) in edges.indexed)
      if (e.from != e.to) reversed[i] ? (e.to, e.from, i) : (e.from, e.to, i),
  ];

  // Rank by longest path, two ranks per edge, then pull each source down next to what it feeds.
  final preds = List.generate(n, (_) => <int>[]), succs = List.generate(n, (_) => <int>[]);
  for (final (u, v, _) in dag) {
    succs[u].add(v);
    preds[v].add(u);
  }
  final rank = List.filled(n, 0);
  final left = [for (var i = 0; i < n; i++) preds[i].length];
  final topo = [
    for (var i = 0; i < n; i++)
      if (left[i] == 0) i,
  ];
  for (var k = 0; k < topo.length; k++) {
    for (final v in succs[topo[k]]) {
      rank[v] = math.max(rank[v], rank[topo[k]] + 2);
      if (--left[v] == 0) topo.add(v);
    }
  }
  for (final u in topo.reversed) {
    if (preds[u].isEmpty && succs[u].isNotEmpty) rank[u] = succs[u].map((v) => rank[v]).reduce(math.min) - 2;
  }
  // Rows of leaves: the leaves only u feeds go one row under the other, those only feeding u one row over the other.
  final stacked = <int>{};
  if (fanRow > 0) {
    for (var u = 0; u < n; u++) {
      for (final out in [true, false]) {
        final leaves = {
          for (final v in out ? succs[u] : preds[u])
            if ((out ? succs[v] : preds[v]).isEmpty && (out ? preds[v] : succs[v]).toSet().length == 1 && !first.contains(v)) v,
        }.toList()..sort();
        for (var g = 0; g < laneCount; g++) {
          final group = leaves.where((v) => lane[v] == g).toList();
          if (group.length <= fanRow) continue;
          final per = (group.length / (group.length / fanRow).ceil()).ceil();
          for (final (j, v) in group.indexed) {
            rank[v] = rank[u] + (out ? 2 : -2) * (1 + j ~/ per);
            if (j >= per) stacked.add(v);
          }
        }
      }
    }
    final low = n == 0 ? 0 : rank.reduce(math.min);
    for (var i = 0; i < n; i++) {
      rank[i] -= low;
    }
  }

  // Virtual nodes: the real ones, then one bend per rank an edge crosses.
  final vRank = [...rank], vSize = [...slot], vLane = [...lane];
  final vBack = [for (var i = 0; i < n; i++) false];
  final up = List.generate(n, (_) => <int>[]), down = List.generate(n, (_) => <int>[]);
  final chains = <int, List<int>>{}, labelAt = <int, int>{};
  for (final (u, v, i) in dag) {
    final chain = <int>[];
    // A stacked leaf's label sits right by the leaf, not among the boxes of the row it passes.
    final mid = stacked.contains(v) ? rank[v] - 1 : (stacked.contains(u) ? rank[u] + 1 : rank[u] + (rank[v] - rank[u]) ~/ 2);
    var prev = u;
    for (var r = rank[u] + 1; r < rank[v]; r++) {
      final d = vRank.length;
      final label = r == mid ? tb(edges[i].label) : Size.zero;
      vRank.add(r);
      vSize.add(label == Size.zero ? const Size(8, 0) : label);
      // Bends sit in the target's lane: an edge into another lane crosses over in the gap
      // right under its source, where no box stands, then runs down beside its target.
      vLane.add(lane[v]);
      // A return to the next rank up stays where it is: only long ones go round the side.
      vBack.add(backAside && reversed[i] && rank[v] - rank[u] > 2);
      up.add([prev]);
      down.add([]);
      down[prev].add(d);
      if (r == mid && label != Size.zero) labelAt[i] = d;
      chain.add(d);
      prev = d;
    }
    down[prev].add(v);
    up[v].add(prev);
    chains[i] = chain;
  }
  final count = vRank.length;
  final ranks = count == 0 ? 0 : vRank.reduce(math.max) + 1;

  // First order: the order a walk from the roots meets them, so related boxes start close.
  final seen = List.filled(count, -1);
  var tick = 0;
  void walk(int v) {
    if (seen[v] >= 0) return;
    seen[v] = tick++;
    down[v].forEach(walk);
  }

  discovered.forEach(walk);
  for (var v = 0; v < count; v++) {
    walk(v);
  }
  var layers = List.generate(ranks, (_) => <int>[]);
  for (var v = 0; v < count; v++) {
    layers[vRank[v]].add(v);
  }
  final pos = List.filled(count, 0.0);
  void index() {
    for (final l in layers) {
      for (final (k, v) in l.indexed) {
        pos[v] = k.toDouble();
      }
    }
  }

  for (final l in layers) {
    l.sort((a, b) => vLane[a] != vLane[b] ? vLane[a] - vLane[b] : seen[a] - seen[b]);
  }
  index();

  int crossings() {
    var c = 0;
    for (final l in layers) {
      final ends = [
        for (final u in l)
          for (final v in down[u]) (pos[u], pos[v]),
      ];
      for (var a = 0; a < ends.length; a++) {
        for (var b = a + 1; b < ends.length; b++) {
          if ((ends[a].$1 - ends[b].$1) * (ends[a].$2 - ends[b].$2) < 0) c++;
        }
      }
    }
    return c;
  }

  // Swaps two neighbours of a rank when that crosses fewer edges, until none helps.
  int pairCross(int a, int b) {
    var c = 0;
    for (final near in [up, down]) {
      for (final p in near[a]) {
        for (final q in near[b]) {
          if (pos[p] > pos[q]) c++;
        }
      }
    }
    return c;
  }

  void transpose() {
    for (var pass = 0, changed = true; changed && pass < 12; pass++) {
      changed = false;
      for (final l in layers) {
        for (var k = 0; k + 1 < l.length; k++) {
          final a = l[k], b = l[k + 1];
          if (vLane[a] != vLane[b] || vBack[a] != vBack[b]) continue;
          if (pairCross(b, a) < pairCross(a, b)) {
            l[k] = b;
            l[k + 1] = a;
            pos[a] = k + 1.0;
            pos[b] = k.toDouble();
            changed = true;
          }
        }
      }
    }
  }

  int group(int v) => vLane[v] * 2 + (vBack[v] ? 1 : 0);
  for (final l in layers) {
    l.sort((a, b) => group(a) != group(b) ? group(a) - group(b) : pos[a].compareTo(pos[b]));
  }
  index();
  var best = [
    for (final l in layers) [...l],
  ];
  var fewest = crossings();
  for (var it = 0; it < 24 && fewest > 0; it++) {
    final downward = it.isEven;
    for (var k = 0; k < ranks; k++) {
      final r = downward ? k : ranks - 1 - k;
      final bary = <int, double>{
        for (final v in layers[r])
          v: () {
            final near = downward ? up[v] : down[v];
            return near.isEmpty ? pos[v] : near.map((u) => pos[u]).reduce((a, b) => a + b) / near.length;
          }(),
      };
      layers[r].sort((a, b) {
        if (group(a) != group(b)) return group(a) - group(b);
        final d = bary[a]!.compareTo(bary[b]!);
        return d != 0 ? d : pos[a].compareTo(pos[b]);
      });
      for (final (k2, v) in layers[r].indexed) {
        pos[v] = k2.toDouble();
      }
    }
    transpose();
    final c = crossings();
    if (c < fewest) {
      fewest = c;
      best = [
        for (final l in layers) [...l],
      ];
    }
  }
  layers = best;
  index();

  // Ranks top to bottom; an empty rank takes no room.
  final thick = [for (final l in layers) l.isEmpty ? 0.0 : l.map((v) => vSize[v].height).reduce(math.max)];
  final mid = List.filled(ranks, 0.0);
  var y = 0.0;
  for (var r = 0; r < ranks; r++) {
    if (layers[r].isEmpty) continue;
    if (y > 0) y += layerGap;
    mid[r] = y + thick[r] / 2;
    y += thick[r];
  }

  // Lanes: columns as wide as their widest rank.
  final laneWidth = List.filled(laneCount, 0.0);
  for (final l in layers) {
    for (var g = 0; g < laneCount; g++) {
      final m = l.where((v) => vLane[v] == g).toList();
      if (m.isEmpty) continue;
      laneWidth[g] = math.max(laneWidth[g], m.map((v) => vSize[v].width).reduce((a, b) => a + b) + gap * (m.length - 1));
    }
  }
  final laneLeft = List.filled(laneCount, 0.0);
  for (var g = 1; g < laneCount; g++) {
    laneLeft[g] = laneLeft[g - 1] + laneWidth[g - 1] + laneGap;
  }

  final x = List.filled(count, 0.0);
  // Centres as close to [want] as the order and the gaps allow: isotonic regression (pool adjacent violators).
  void place(List<int> row, Map<int, double> want, int g) {
    if (row.isEmpty) return;
    final offset = [0.0];
    for (var k = 1; k < row.length; k++) {
      offset.add(offset[k - 1] + (vSize[row[k - 1]].width + vSize[row[k]].width) / 2 + gap);
    }
    final blocks = <(double, int)>[];
    for (var k = 0; k < row.length; k++) {
      var b = (want[row[k]]! - offset[k], 1);
      while (blocks.isNotEmpty && blocks.last.$1 / blocks.last.$2 > b.$1 / b.$2) {
        final last = blocks.removeLast();
        b = (last.$1 + b.$1, last.$2 + b.$2);
      }
      blocks.add(b);
    }
    // In a lane every box stays inside the column: one common bound on x - offset, which
    // clamping the regression's answer meets at its best.
    final lo = laneCount > 1 ? laneLeft[g] + vSize[row.first].width / 2 : double.negativeInfinity;
    final hi = laneCount > 1 ? laneLeft[g] + laneWidth[g] - vSize[row.last].width / 2 - offset.last : double.infinity;
    var k = 0;
    for (final (sum, c) in blocks) {
      for (var j = 0; j < c; j++, k++) {
        x[row[k]] = (sum / c).clamp(lo, math.max(lo, hi)) + offset[k];
      }
    }
  }

  List<int> rowOf(List<int> l, int g) => l.where((v) => vLane[v] == g).toList();
  for (final l in layers) {
    for (var g = 0; g < laneCount; g++) {
      final row = rowOf(l, g);
      if (row.isEmpty) continue;
      final w = row.map((v) => vSize[v].width).reduce((a, b) => a + b) + gap * (row.length - 1);
      var at = laneLeft[g] + (laneWidth[g] - w) / 2;
      for (final v in row) {
        x[v] = at + vSize[v].width / 2;
        at += vSize[v].width + gap;
      }
    }
  }
  for (var it = 0; it < 8; it++) {
    final downward = it.isEven;
    for (var k = 0; k < ranks; k++) {
      final r = downward ? k : ranks - 1 - k;
      final want = <int, double>{};
      for (final v in layers[r]) {
        // The last pass looks both ways, so a box settles between what calls it and what it calls.
        final near = it == 7 ? [...up[v], ...down[v]] : (downward ? up[v] : down[v]);
        want[v] = near.isEmpty ? x[v] : near.map((u) => x[u]).reduce((a, b) => a + b) / near.length;
      }
      for (var g = 0; g < laneCount; g++) {
        place(rowOf(layers[r], g), want, g);
      }
    }
  }

  // Without lanes the boxes drift freely: start them at zero.
  final shift = laneCount > 1 || count == 0 ? 0.0 : -[for (var v = 0; v < count; v++) x[v] - vSize[v].width / 2].reduce(math.min);
  Rect slotRect(int v) => Rect.fromCenter(center: Offset(x[v] + shift, mid[vRank[v]]), width: vSize[v].width, height: vSize[v].height);
  final nodeTb = [
    for (var i = 0; i < n; i++)
      () {
        final s = slotRect(i), size = tb(sizes[i]);
        return Rect.fromLTWH(s.left, s.top, size.width, size.height);
      }(),
  ];
  var width = 0.0;
  for (var v = 0; v < count; v++) {
    width = math.max(width, slotRect(v).right);
  }
  for (var g = 0; g < laneCount && laneCount > 1; g++) {
    width = math.max(width, laneLeft[g] + laneWidth[g]);
  }

  // Ports: the edges leaving the bottom of a box spread along it, sorted by where they head.
  final bottom = <int, List<(int, double)>>{}, top = <int, List<(int, double)>>{};
  for (final (u, v, i) in dag) {
    final chain = chains[i]!;
    (bottom[u] ??= []).add((i, x[chain.first] + shift));
    (top[v] ??= []).add((i, x[chain.last] + shift));
  }
  final portBottom = <int, double>{}, portTop = <int, double>{};
  void spread(Map<int, List<(int, double)>> ports, Map<int, double> into) {
    for (final MapEntry(key: node, value: list) in ports.entries) {
      list.sort((a, b) => a.$2 != b.$2 ? a.$2.compareTo(b.$2) : a.$1 - b.$1);
      final r = nodeTb[node];
      for (final (k, (i, _)) in list.indexed) {
        into[i] = r.left + r.width * (.1 + .8 * (k + 1) / (list.length + 1));
      }
    }
  }

  spread(bottom, portBottom);
  spread(top, portTop);

  Offset flip(Offset p) => horizontal ? Offset(p.dy, p.dx) : p;
  Rect flipRect(Rect r) => horizontal ? Rect.fromLTRB(r.top, r.left, r.bottom, r.right) : r;
  final routes = <EdgeRoute>[];
  final byIndex = {for (final d in dag) d.$3: d};
  final labels = {for (final MapEntry(key: i, value: d) in labelAt.entries) i: slotRect(d)};

  // A route bends at every rank it crosses, which reads as a zigzag. Pull
  // the bends onto the straight line between the ports whenever that line
  // and its label stay clear of every other box and label.
  bool clear(List<Offset> pts, int u, int v, int i, Rect? label) {
    for (var k = 1; k < pts.length; k++) {
      final a = pts[k - 1], b = pts[k];
      final steps = ((b - a).distance / 4).ceil().clamp(1, 1000);
      for (var s = 0; s <= steps; s++) {
        final q = Offset.lerp(a, b, s / steps)!;
        for (var w = 0; w < n; w++) {
          if (w != u && w != v && nodeTb[w].inflate(6).contains(q)) return false;
        }
        for (final MapEntry(key: j, value: r) in labels.entries) {
          if (j != i && r.inflate(2).contains(q)) return false;
        }
      }
    }
    if (label == null) return true;
    for (var w = 0; w < n; w++) {
      if (nodeTb[w].inflate(4).overlaps(label)) return false;
    }
    for (final MapEntry(key: j, value: r) in labels.entries) {
      if (j != i && r.inflate(2).overlaps(label)) return false;
    }
    return true;
  }

  for (final (i, e) in edges.indexed) {
    if (e.from == e.to) {
      routes.add(const EdgeRoute([], self: true));
      continue;
    }
    final (u, v, _) = byIndex[i]!;
    final a = Offset(portBottom[i]!, nodeTb[u].bottom), b = Offset(portTop[i]!, nodeTb[v].top);
    var pts = [a, for (final d in chains[i]!) Offset(x[d] + shift, mid[vRank[d]]), b];
    final at = labelAt[i];
    final line = [for (final q in pts) Offset(a.dx + (b.dx - a.dx) * (q.dy - a.dy) / (b.dy - a.dy), q.dy)];
    final moved = at == null ? null : labels[i]!.shift(Offset(line[chains[i]!.indexOf(at) + 1].dx - labels[i]!.center.dx, 0));
    if (clear(line, u, v, i, moved)) {
      pts = line;
      if (moved != null) labels[i] = moved;
    }
    final out = pts.map(flip).toList();
    routes.add(EdgeRoute(reversed[i] ? out.reversed.toList() : out, label: at == null ? null : flipRect(labels[i]!)));
  }

  return LayeredGraph(
    nodes: nodeTb.map(flipRect).toList(),
    edges: routes,
    lanes: [for (var g = 0; g < laneCount && laneCount > 1; g++) flipRect(Rect.fromLTWH(laneLeft[g], 0, laneWidth[g], y))],
    size: horizontal ? Size(y, width) : Size(width, y),
    horizontal: horizontal,
  );
}

/// A path through a route: a straight line when its points line up, else
/// one smooth curve through them (Catmull-Rom), with no kink at the bends.
Path routePath(List<Offset> points, {bool horizontal = false}) {
  final p = Path();
  if (points.isEmpty) return p;
  final pts = _simplify(points);
  p.moveTo(pts.first.dx, pts.first.dy);
  if (pts.length == 2) return p..lineTo(pts.last.dx, pts.last.dy);
  Offset tangent(int k) => k == 0
      ? pts[1] - pts[0]
      : k == pts.length - 1
      ? pts[k] - pts[k - 1]
      : (pts[k + 1] - pts[k - 1]) / 2;
  for (var k = 1; k < pts.length; k++) {
    final c1 = pts[k - 1] + tangent(k - 1) / 3, c2 = pts[k] - tangent(k) / 3;
    p.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, pts[k].dx, pts[k].dy);
  }
  return p;
}

/// Drops the points that sit on the line between their neighbours.
List<Offset> _simplify(List<Offset> points) {
  final out = [points.first];
  for (var k = 1; k < points.length - 1; k++) {
    final a = out.last, b = points[k], c = points[k + 1];
    final d = c - a;
    final off = d.distance == 0 ? 0 : ((b.dx - a.dx) * d.dy - (b.dy - a.dy) * d.dx).abs() / d.distance;
    if (off > .5) out.add(b);
  }
  return out..add(points.last);
}

/// The unit direction an arrow head points at the last point of a route, or
/// at its first with [start] (away from the line, into the source box): the
/// direction the path itself arrives with.
Offset routeDirection(List<Offset> points, {bool horizontal = false, bool start = false}) {
  final pts = _simplify(points);
  final d = start ? pts[0] - pts[1] : pts.last - pts[pts.length - 2];
  return d.distance == 0 ? (horizontal ? const Offset(1, 0) : const Offset(0, 1)) : d / d.distance;
}
