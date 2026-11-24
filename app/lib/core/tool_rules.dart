// Allowed tool rules in Claude Code syntax: "Bash(git diff:*)" allows the
// commands that start with "git diff", a bare name allows that whole tool.

/// The rule "Always allow" offers for a call: the command's first words for
/// Bash (two, three after rtk), the tool name for the rest.
String suggestRule(String tool, Map<String, Object?> input) {
  if (tool != 'Bash') return tool;
  final words = '${input['command'] ?? ''}'.trim().split(RegExp(r'\s+'));
  return 'Bash(${words.take(words.first == 'rtk' ? 3 : 2).join(' ')}:*)';
}

/// Whether [rules] allow the call. Checked in Deck for a rule added while a
/// session runs (the session got its rules when it started). A Bash rule
/// only matches one plain command: no ; & | ` $( < > or new line, so a
/// prefix cannot hide a second command after it.
bool ruleAllows(Iterable<String> rules, String tool, Map<String, Object?> input) {
  final cmd = '${input['command'] ?? ''}'.trim();
  final plain = !RegExp(r'[;&|`<>\n]|\$\(').hasMatch(cmd);
  for (final r in rules) {
    if (r == tool) return true;
    final m = RegExp(r'^Bash\((.+?)(:\*)?\)$').firstMatch(r);
    if (tool != 'Bash' || m == null || !plain) continue;
    if (cmd == m[1] || (m[2] != null && cmd.startsWith('${m[1]} '))) return true;
  }
  return false;
}

/// One line for a call: the command for Bash, else the tool and its input.
String callSummary(String tool, Map<String, Object?> input) =>
    tool == 'Bash' && input['command'] != null ? '${input['command']}' : '$tool ${input.isEmpty ? '' : input}'.trim();
