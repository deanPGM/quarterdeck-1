// Where a Claude Code session started from a card is now, read from its
// transcript.

/// Where a session stands, for the card that started it.
/// [waiting]: it asks you (a permission, a question); only hooks know it.
/// [done]: the turn ended. [idle]: silent for minutes, state unknown.
/// [closed]: no Claude Code process runs it any more; it can be resumed.
enum SessionStatus { working, waiting, done, idle, closed }

class SessionProgress {
  const SessionProgress({required this.status, this.title, this.last, this.cwd, required this.at});

  final SessionStatus status;
  final String? title;

  /// Where it ran: `claude --resume` finds the session only from there.
  final String? cwd;

  /// Claude's last text, first line.
  final String? last;
  final DateTime at;
}
