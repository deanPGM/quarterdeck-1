// Sessions that run inside Deck, one tab each, instead of in an outside
// terminal window. Deck owns the process, so it knows which ones still run.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_pty2/flutter_pty2.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xterm2/xterm.dart';

import '../sources/shell_env.dart';
import 'board.dart' show mcpPort;
import 'settings.dart';
import 'ui_memory.dart';

part 'terminals.g.dart';

/// What a tab is for, so it can be told apart from the others.
class TermInfo {
  const TermInfo({required this.title, this.action, this.detail, this.cardKey, this.logo, this.platforms = const []});

  /// Short name on the tab: the card ref.
  final String title;

  /// What was started: 'Claude', 'Review', 'Draft'.
  final String? action;

  /// The card's title.
  final String? detail;

  /// The card that started it.
  final String? cardKey;

  /// The logo file of the project it runs in.
  final String? logo;

  /// Its platforms, badges on the logo.
  final List<String> platforms;

  Map<String, Object?> toJson() => {
    'title': title,
    'action': ?action,
    'detail': ?detail,
    'cardKey': ?cardKey,
    'logo': ?logo,
    if (platforms.isNotEmpty) 'platforms': platforms,
  };

  factory TermInfo.fromJson(Map<String, Object?> j) => TermInfo(
    title: '${j['title']}',
    action: j['action'] as String?,
    detail: j['detail'] as String?,
    cardKey: j['cardKey'] as String?,
    logo: j['logo'] as String?,
    platforms: ((j['platforms'] as List?) ?? const []).cast<String>(),
  );
}

class TermTab {
  TermTab(this.id, this.info, this.dir, this.terminal, this.pty, this.restore);

  /// Claude's hooks name the tab with it ($DECK_TAB).
  final int id;
  final TermInfo info;
  final String dir;
  final Terminal terminal;
  final PtySession pty;

  /// The line that brings the session back after a restart, such as
  /// `claude --resume <id>`. Null: the tab is not reopened.
  final String? restore;

  /// Reopened at the next start: it has a [restore] line and was neither
  /// closed nor ended by you.
  bool kept = true;
  bool exited = false;

  /// Claude asks for a permission or an answer. Only Claude's hooks set it.
  bool waiting = false;

  /// Claude's hooks told Deck its state at least once.
  bool hooked = false;

  /// Claude works on a turn.
  bool working = false;
  DateTime _lastOutput = DateTime.now();
}

/// Claude settings whose hooks POST the session's state to Deck on [port]:
/// working, blocked (asks you) or done. They name the Deck tab ($DECK_TAB,
/// empty in an outside terminal) and Claude's session id, read from the
/// hook's input.
Map<String, Object?> claudeHooks(int port) {
  const read = r'''i=$(cat); s=$(printf %s "$i" | grep -oE '"session_id": *"[^"]*"' | head -1 | sed -E 's/.*"([^"]*)"$/\1/'); ''';
  String post(String state) => 'curl -s -m 2 -X POST "http://127.0.0.1:$port/tab?id=\$DECK_TAB&session=\$s&state=$state" >/dev/null 2>&1 || true';
  List<Object> run(String command, [String? matcher]) => [
    {
      'matcher': ?matcher,
      'hooks': [
        {'type': 'command', 'command': '$read$command'},
      ],
    },
  ];
  // A tool that asks you (a question, the plan) blocks; any other works.
  const asks = r'"tool_name": *"(AskUserQuestion|ExitPlanMode)"';
  return {
    'hooks': {
      'UserPromptSubmit': run(post('working')),
      'PreToolUse': run("if printf %s \"\$i\" | grep -qE '$asks'; then ${post('blocked')}; else ${post('working')}; fi", '*'),
      'PostToolUse': run(post('working'), '*'),
      'Notification': run(post('blocked'), 'permission_prompt|elicitation_dialog'),
      'Stop': run(post('done')),
    },
  };
}

/// A hooked Claude tab this long without output is not working any more.
const _stopped = Duration(seconds: 10);

/// What the panel shows. A new value on every change, so watchers rebuild.
class TermState {
  const TermState({this.tabs = const [], this.current = 0, this.shown = false, this.full = false, this.dragged});

  final List<TermTab> tabs;
  final int current;

  /// The panel is on screen. Hiding it keeps the sessions running.
  final bool shown;

  /// The panel takes the whole window. Not saved: a restart opens it at its
  /// saved size.
  final bool full;

  /// Share of the window while its edge is dragged, until it is saved.
  final double? dragged;

  TermTab? get selected => tabs.isEmpty ? null : tabs[current];

  int get waitingCount => tabs.where((t) => t.waiting).length;

  /// The running tab [cardKey] started for [action], if any.
  TermTab? running(String cardKey, {String? action}) =>
      tabs.where((t) => !t.exited && t.info.cardKey == cardKey && (action == null || t.info.action == action)).firstOrNull;
}

/// One set for the whole app: the tabs own processes, so it never disposes
/// while the app runs.
@Riverpod(keepAlive: true)
class Terminals extends _$Terminals {
  Timer? _tick;

  /// The tabs, for dispose: the state can not be read there.
  var _tabs = const <TermTab>[];

  @override
  TermState build() {
    ref.onDispose(() {
      _tick?.cancel();
      for (final t in _tabs) {
        if (!t.exited) t.pty.kill();
      }
    });
    return const TermState();
  }

  void _set({List<TermTab>? tabs, int? current, bool? shown, bool? full, double? dragged, bool clearDrag = false}) {
    state = TermState(
      tabs: _tabs = tabs ?? [...state.tabs],
      current: current ?? state.current,
      shown: shown ?? state.shown,
      full: full ?? state.full,
      dragged: clearDrag ? null : dragged ?? state.dragged,
    );
    // Restarts with the panel as it is now, once restore read the last one.
    if (_restored) ref.read(uiMemoryProvider).setPanel(state.shown);
  }

  /// Claude's hook in tab [id] says it is 'working', 'blocked' (asks you) or
  /// 'done' (the turn ended).
  void hook(int id, String event) {
    final t = _tabs.where((t) => t.id == id).firstOrNull;
    if (t == null || t.exited) return;
    t
      ..hooked = true
      ..working = event == 'working'
      ..waiting = event == 'blocked';
    _set();
  }

  var _nextId = 0;

  /// Settings with hooks that tell Deck the state of a Claude session in a
  /// tab, on port [mcpPort]. Written once per run.
  late final Future<String> _hooks = () async {
    final f = File(p.join(ref.read(homeProvider).cache.path, 'claude-hooks.json'));
    await f.parent.create(recursive: true);
    await f.writeAsString(jsonEncode(claudeHooks(mcpPort)));
    return f.path;
  }();

  /// [line] with Deck's hooks on each `claude` it starts, in a Deck tab or an
  /// outside terminal. Not on Windows, where the hook commands would run in
  /// another shell.
  Future<String> withHooks(String line) async {
    if (Platform.isWindows) return line;
    final file = await _hooks;
    // The talks quote every word, so 'claude' too.
    return line.replaceAllMapped(RegExp(r"(^|&& |; )('?claude'?) "), (m) => "${m[1]}${m[2]} --settings '$file' ");
  }

  /// Shows or hides the panel. It comes back at its saved size.
  void toggle() => _set(shown: !state.shown, full: false);

  /// The panel over the whole window, or back to its size.
  void setFull(bool full) => _set(full: full);

  /// Dragging the edge leaves full size.
  void resize(double? share) => _set(dragged: share, clearDrag: share == null, full: false);

  File get _saved => File(p.join(ref.read(homeProvider).cache.path, 'terminals.json'));

  /// Writes the tabs to reopen at the next start.
  Future<void> _save() async {
    final keep = [
      for (final t in _tabs)
        if (t.restore != null && t.kept) {'info': t.info.toJson(), 'dir': t.dir, 'restore': t.restore},
    ];
    await _saved.parent.create(recursive: true);
    await _saved.writeAsString(jsonEncode(keep));
  }

  var _restored = false;

  /// Reopens the sessions that ran when Deck quit, and the panel if it was
  /// open. Once per run.
  Future<void> restore() async {
    if (_restored) return;
    _restored = true;
    final memory = ref.read(uiMemoryProvider);
    final shown = memory.panel;
    var saved = const <Object?>[];
    try {
      saved = jsonDecode(await _saved.readAsString()) as List<Object?>;
    } on Object {
      // None yet, or unreadable: no session to bring back.
    }
    for (final s in saved.cast<Map<String, Object?>>()) {
      final dir = '${s['dir']}';
      if (!Directory(dir).existsSync()) continue;
      final line = '${s['restore']}';
      await open(TermInfo.fromJson((s['info']! as Map).cast()), line, dir, restore: line, show: false);
    }
    _set(shown: shown || state.shown);
  }

  /// Runs [line] through the login shell in a new tab and selects it.
  /// [restore] is the line that brings it back after a restart; [show]
  /// false adds the tab without opening the panel.
  Future<void> open(TermInfo info, String line, String dir, {String? restore, bool show = true}) async {
    final env = await shellEnvironment();
    final id = ++_nextId;
    final run = await withHooks(line);
    final terminal = Terminal(maxLines: 10000);
    final pty = await Pty.spawn(
      PtySpawnOptions(
        executable: Platform.isWindows ? 'cmd.exe' : env['SHELL'] ?? '/bin/zsh',
        arguments: Platform.isWindows ? ['/k', run] : ['-lc', run],
        workingDirectory: dir,
        environment: PtyEnvironment.replace({...env, 'TERM': 'xterm-256color', 'COLORTERM': 'truecolor', 'DECK_TAB': '$id'}),
      ),
    );
    final tab = TermTab(id, info, dir, terminal, pty, restore);
    pty.utf8Output().listen((s) {
      tab._lastOutput = DateTime.now();
      terminal.write(s);
    });
    terminal.onOutput = pty.input.writeUtf8;
    terminal.onResize = (w, h, _, _) => pty.resize(PtySize(columns: w, rows: h));
    pty.done.then((exit) {
      tab.exited = true;
      tab.waiting = tab.working = false;
      terminal.write('\r\n[$exit]\r\n');
      // Ended on its own (you quit it): not reopened. Killed, as when Deck
      // quits, it is.
      if (exit case PtyExitCode(code: 0) when tab.kept && tab.restore != null) {
        tab.kept = false;
        unawaited(_save());
      }
      _set();
    });
    _set(tabs: [...state.tabs, tab]);
    _tick ??= Timer.periodic(const Duration(seconds: 1), (_) => _checkStopped());
    if (show) focus(tab);
    if (restore != null) await _save();
  }

  /// Claude's spinner draws all along a turn. Silent this long while
  /// "working": the turn was stopped (Esc), and no Stop hook came.
  void _checkStopped() {
    final now = DateTime.now();
    var changed = false;
    for (final t in state.tabs) {
      if (!t.exited && t.working && now.difference(t._lastOutput) > _stopped) {
        t.working = false;
        changed = true;
      }
    }
    if (changed) _set();
  }

  /// Shows the running tab [cardKey] started for [action]. False when there
  /// is none.
  bool focusRunning(String cardKey, {String? action}) {
    final tab = state.running(cardKey, action: action);
    if (tab != null) focus(tab);
    return tab != null;
  }

  /// Selects [tab] and shows the panel.
  void focus(TermTab tab) => _set(current: state.tabs.indexOf(tab), shown: true);

  void select(int i) => _set(current: i);

  void close(int i) {
    final tabs = [...state.tabs];
    final tab = tabs.removeAt(i)..kept = false;
    if (!tab.exited) tab.pty.kill();
    unawaited(tab.pty.close());
    if (tabs.isEmpty) {
      _tick?.cancel();
      _tick = null;
    }
    _set(tabs: tabs, current: state.current.clamp(0, tabs.isEmpty ? 0 : tabs.length - 1));
    if (tab.restore != null) unawaited(_save());
  }
}
