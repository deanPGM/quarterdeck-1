// The Deck folder: deck.json (settings), state/ (your decisions, kept in git),
// cache/ (fetched data, safe to delete). Chosen in Settings → Storage and
// remembered in ~/.deck/home, so the app and any tool find the same folder.
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

String get userHome => Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '.';

String expandHome(String path) => path == '~' || path.startsWith('~/') ? p.join(userHome, path.substring(path.length == 1 ? 1 : 2)) : path;

/// [path] with the home folder as ~.
String tildeHome(String path) => path.startsWith('$userHome/') ? '~${path.substring(userHome.length)}' : path;

class DeckHome {
  DeckHome(this.dir);

  final String dir;

  static File get pointer => File(p.join(userHome, '.deck', 'home'));

  static DeckHome resolve() {
    final env = Platform.environment['DECK_HOME'];
    if (env != null && env.isNotEmpty) return DeckHome(expandHome(env));
    if (pointer.existsSync()) {
      final saved = pointer.readAsStringSync().trim();
      if (saved.isNotEmpty) return DeckHome(expandHome(saved));
    }
    return DeckHome(p.join(userHome, '.deck'));
  }

  /// Makes [dir] the Deck folder from now on.
  static Future<DeckHome> select(String dir) async {
    await pointer.parent.create(recursive: true);
    await pointer.writeAsString('$dir\n');
    return DeckHome(dir);
  }

  File get config => File(p.join(dir, 'deck.json'));
  Directory get state => Directory(p.join(dir, 'state'));
  Directory get cache => Directory(p.join(dir, 'cache'));

  /// A path relative to state/, such as a project logo, made absolute.
  String inState(String path) => p.join(state.path, path);

  /// A path relative to the Deck folder, or absolute, or starting with ~.
  String resolvePath(String path) => p.isAbsolute(expandHome(path)) ? expandHome(path) : p.join(dir, path);
}

Future<Object?> readJson(File f) async => f.existsSync() ? jsonDecode(await f.readAsString()) : null;

/// Writes through a temp file so a crash never leaves half a file.
Future<void> writeJson(File f, Object? data) async {
  await f.parent.create(recursive: true);
  final tmp = File('${f.path}.tmp');
  await tmp.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  await tmp.rename(f.path);
}
