import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/models/config.dart';
import '../core/models/snapshot.dart';
import 'deck_home.dart';

class ConfigStore {
  ConfigStore(this.home);

  final DeckHome home;

  Future<DeckConfig> load() async {
    final json = await readJson(home.config);
    return json == null ? const DeckConfig() : DeckConfig.fromJson(json as Map<String, Object?>);
  }

  Future<void> save(DeckConfig c) => writeJson(home.config, c.toJson());
}

class SnapshotStore {
  SnapshotStore(this.home);

  final DeckHome home;

  // Todos are yours, not fetched: they live with the state, not the cache.
  File _file(String provider) => provider == 'todo' ? File(p.join(home.state.path, 'todos.json')) : File(p.join(home.cache.path, '$provider.json'));

  /// The cache is disposable: a file Deck cannot read counts as empty.
  Future<Snapshot> load(String provider) async {
    try {
      final json = await readJson(_file(provider));
      return json == null ? const Snapshot() : Snapshot.fromJson(json as Map<String, Object?>);
    } catch (_) {
      return const Snapshot();
    }
  }

  Future<void> save(String provider, Snapshot s) => writeJson(_file(provider), s.toJson());
}

class TriageStore {
  TriageStore(this.home);

  final DeckHome home;

  File get _file => File(p.join(home.state.path, 'triage.json'));

  Future<Map<String, Triage>> load() async {
    final json = await readJson(_file) as Map<String, Object?>?;
    return {for (final e in (json ?? {}).entries) e.key: Triage.fromJson(e.value! as Map<String, Object?>)};
  }

  Future<void> save(Map<String, Triage> all) => writeJson(_file, {for (final e in all.entries) e.key: e.value.toJson()});
}

/// Links you made (true) or cut (false) between two cards, per pair key
/// (core/links.dart). Your data: lives in state/, backed up with git.
class LinkStore {
  LinkStore(this.home);

  final DeckHome home;

  File get _file => File(p.join(home.state.path, 'links.json'));

  Future<Map<String, bool>> load() async => {for (final e in ((await readJson(_file) as Map<String, Object?>?) ?? {}).entries) e.key: e.value == true};

  Future<void> save(Map<String, bool> all) => writeJson(_file, all);
}
