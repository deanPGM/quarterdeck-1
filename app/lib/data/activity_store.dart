// The activity log on disk: one JSON line per event, one file per month in
// state/activity/ (kept in git with the rest of your state).
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/models/activity.dart';
import 'deck_home.dart';

class ActivityStore {
  ActivityStore(this.home);

  final DeckHome home;

  File _file(DateTime d) => File(p.join(home.state.path, 'activity', '${d.year}-${'${d.month}'.padLeft(2, '0')}.jsonl'));

  Future<List<Activity>> _month(DateTime d) async {
    final f = _file(d);
    if (!f.existsSync()) return [];
    return [
      for (final l in await f.readAsLines())
        if (l.trim().isNotEmpty) Activity.fromJson(jsonDecode(l) as Map<String, Object?>),
    ];
  }

  /// Appends [items], skipping ids already logged that month. Returns what was added.
  Future<List<Activity>> add(Iterable<Activity> items) async {
    final added = <Activity>[];
    for (final e in items) {
      if (e.id != null && (await _month(e.at)).any((x) => x.id == e.id)) continue;
      final f = _file(e.at);
      await f.parent.create(recursive: true);
      await f.writeAsString('${jsonEncode(e.toJson())}\n', mode: FileMode.append);
      added.add(e);
    }
    return added;
  }

  /// Everything from [from] to [to], both days included, oldest first.
  Future<List<Activity>> read(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day), end = DateTime(to.year, to.month, to.day + 1);
    final out = <Activity>[];
    for (var m = DateTime(start.year, start.month); m.isBefore(end); m = DateTime(m.year, m.month + 1)) {
      out.addAll((await _month(m)).where((e) => !e.at.isBefore(start) && e.at.isBefore(end)));
    }
    return out..sort((a, b) => a.at.compareTo(b.at));
  }
}
