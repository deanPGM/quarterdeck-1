// Progress of the Claude session a card started, read from its transcript
// while the card is on screen. The hooks Deck gives the sessions it starts
// tell the exact state, which wins over the transcript's guess.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/session_progress.dart';
import '../sources/claude_sessions.dart';

final sessionProgressProvider = StreamProvider.autoDispose.family<SessionProgress?, String>((ref, id) => watchProgress(id));

/// The last state each session's hooks sent: working, blocked or done. Lost
/// when Deck quits; the transcript speaks until the next hook.
final sessionHooksProvider = NotifierProvider<SessionHooks, Map<String, String>>(SessionHooks.new);

class SessionHooks extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  void set(String session, String hook) => state = {...state, session: hook};
}

/// [s] with the state its hooks sent, [hook]. A closed session stays closed.
SessionProgress? withHook(SessionProgress? s, String? hook) {
  if (s == null || hook == null || s.status == SessionStatus.closed) return s;
  final status = switch (hook) {
    // Esc sends no Stop: a transcript silent for minutes is not working.
    'working' when s.status == SessionStatus.idle => SessionStatus.idle,
    'working' => SessionStatus.working,
    'blocked' => SessionStatus.waiting,
    _ => SessionStatus.done,
  };
  return SessionProgress(status: status, title: s.title, last: s.last, cwd: s.cwd, at: s.at);
}
