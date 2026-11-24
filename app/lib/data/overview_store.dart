// A project's Overview on disk, in state/projects/<id>/ (backed up with the
// rest of your state): updates.jsonl, one JSON line per update, and
// overview.json with the Facts, docs.json with the Documents.
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/models/overview.dart';
import 'deck_home.dart';

class OverviewStore {
  OverviewStore(this.home);

  final DeckHome home;

  Directory _dir(String project) => Directory(p.join(home.state.path, 'projects', project));
  File _updates(String project) => File(p.join(_dir(project).path, 'updates.jsonl'));
  File _overview(String project) => File(p.join(_dir(project).path, 'overview.json'));
  File _docs(String project) => File(p.join(_dir(project).path, 'docs.json'));

  /// Every document of [project], removed ones too, newest first.
  Future<List<ProjectDoc>> docs(String project) async {
    final f = _docs(project);
    if (!f.existsSync()) return [];
    try {
      final list = [for (final x in jsonDecode(await f.readAsString()) as List) ProjectDoc.fromJson(x as Map<String, Object?>)];
      return list..sort((a, b) => b.at.compareTo(a.at));
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeDocs(String project, List<ProjectDoc> docs) async {
    final f = _docs(project);
    await f.parent.create(recursive: true);
    await f.writeAsString(const JsonEncoder.withIndent('  ').convert([for (final d in docs) d.toJson()]));
  }

  /// Adds [items] whose url is not there yet. With [force], one you removed
  /// comes back (you added it by hand). Returns how many were added.
  Future<int> addDocs(String project, Iterable<ProjectDoc> items, {bool force = false}) async {
    final all = await docs(project);
    var n = 0;
    for (final d in items) {
      final i = all.indexWhere((x) => x.url == d.url);
      if (i < 0) {
        all.add(d);
      } else if (force && all[i].removed) {
        all[i] = d;
      } else {
        continue;
      }
      n++;
    }
    if (n > 0) await _writeDocs(project, all);
    return n;
  }

  /// Hides the document at [url]; it stays in the file so it is not added again.
  Future<void> removeDoc(String project, String url) async {
    final all = await docs(project);
    await _writeDocs(project, [for (final d in all) d.url == url ? d.copyWith(removed: true) : d]);
  }

  /// Every update of [project], newest first.
  Future<List<ProjectUpdate>> updates(String project) async {
    final f = _updates(project);
    if (!f.existsSync()) return [];
    final out = <ProjectUpdate>[];
    for (final l in await f.readAsLines()) {
      if (l.trim().isEmpty) continue;
      try {
        out.add(ProjectUpdate.fromJson(jsonDecode(l) as Map<String, Object?>));
      } catch (_) {
        // A broken line is skipped, not the log.
      }
    }
    return out..sort((a, b) => b.at.compareTo(a.at));
  }

  /// Appends [items] whose id is not logged yet. Returns how many were added.
  Future<int> add(String project, Iterable<ProjectUpdate> items) async {
    final have = {for (final u in await updates(project)) u.id};
    final now = DateTime.now();
    final fresh = [
      for (final u in items)
        if (have.add(u.id)) u.copyWith(added: u.added ?? now),
    ];
    if (fresh.isEmpty) return 0;
    final f = _updates(project);
    await f.parent.create(recursive: true);
    await f.writeAsString(fresh.map((u) => '${jsonEncode(u.toJson())}\n').join(), mode: FileMode.append);
    return fresh.length;
  }

  Future<Overview> read(String project) async {
    final f = _overview(project);
    if (!f.existsSync()) return const Overview();
    try {
      return Overview.fromJson(jsonDecode(await f.readAsString()) as Map<String, Object?>);
    } catch (_) {
      return const Overview();
    }
  }

  Future<void> write(String project, Overview o) async {
    final f = _overview(project);
    await f.parent.create(recursive: true);
    await f.writeAsString(const JsonEncoder.withIndent('  ').convert(o.toJson()));
  }
}
