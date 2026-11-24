// Commits state/ (your pins, snoozes, notes, todos) to the git repo in the Deck
// folder, so it has history and can be pushed or restored. Cache is ignored.
import 'dart:async';
import 'dart:io';

import 'deck_home.dart';

class GitBackup {
  GitBackup(this.home);

  final DeckHome home;
  Future<void>? _running;
  bool _again = false;

  /// Commits pending state changes. Calls while a commit runs are merged
  /// into one more commit afterwards.
  Future<void> run() async {
    if (_running != null) {
      _again = true;
      return _running;
    }
    _running = _commit();
    await _running;
    _running = null;
    if (_again) {
      _again = false;
      await run();
    }
  }

  Future<ProcessResult> _git(List<String> args) => Process.run('git', ['-C', home.dir, ...args]);

  Future<void> _commit() async {
    try {
      if (!Directory('${home.dir}/.git').existsSync()) {
        await _git(['init', '-q']);
        final ignore = File('${home.dir}/.gitignore');
        if (!ignore.existsSync()) await ignore.writeAsString('cache/\n');
      }
      await _git(['add', 'state', 'deck.json', '.gitignore']);
      final staged = await _git(['diff', '--cached', '--quiet']);
      if (staged.exitCode == 0) return;
      await _git(['commit', '-q', '-m', 'Deck: update state']);
    } on ProcessException {
      // No git on this machine: nothing to back up with.
    }
  }
}
