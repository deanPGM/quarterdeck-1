// One Claude session Deck ran in the background: when, for what, how long,
// what it cost and how it ended.

class ClaudeRun {
  const ClaudeRun({required this.at, required this.providers, required this.seconds, this.costUsd = 0, this.error, this.sessionId});

  final DateTime at;

  /// The transcript, opened again from Settings.
  final String? sessionId;
  final List<String> providers;
  final int seconds;
  final double costUsd;
  final String? error;
}
