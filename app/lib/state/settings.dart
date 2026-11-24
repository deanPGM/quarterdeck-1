import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/models/config.dart';
import '../data/deck_home.dart';
import '../data/stores.dart';
import '../sources/git.dart';

export '../data/deck_home.dart' show tildeHome;

part 'settings.g.dart';

@Riverpod(keepAlive: true)
class Home extends _$Home {
  @override
  DeckHome build() => DeckHome.resolve();

  /// Moves Deck to another folder. Settings and state there are used as is.
  Future<void> select(String dir) async => state = await DeckHome.select(dir);
}

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  Future<DeckConfig> build() => ConfigStore(ref.watch(homeProvider)).load();

  Future<void> save(DeckConfig c) async {
    state = AsyncData(c);
    await ConfigStore(ref.read(homeProvider)).save(c);
  }

  Future<void> change(DeckConfig Function(DeckConfig) edit) async => save(edit(await future));

  /// The repo of folder [dir] from its origin remote, for a new project.
  Future<String?> repoOf(String dir) => detectRepo(dir);
}
