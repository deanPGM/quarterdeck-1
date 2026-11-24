// Every tool a background session asked for and what came of it, so Settings
// can list them and Claude can suggest rules from them. In the cache: it can
// be deleted.
import 'dart:convert';
import 'dart:io';

class PermissionEntry {
  const PermissionEntry({required this.at, required this.tool, this.input = const {}, required this.answer});

  factory PermissionEntry.fromJson(Map<String, Object?> j) => PermissionEntry(
    at: DateTime.parse(j['at']! as String),
    tool: j['tool']! as String,
    input: (j['input'] as Map?)?.cast<String, Object?>() ?? const {},
    answer: j['answer']! as String,
  );

  final DateTime at;
  final String tool;
  final Map<String, Object?> input;

  /// allow, always, deny, timeout, or rule (an allowed tool rule matched).
  final String answer;

  Map<String, Object?> toJson() => {'at': at.toIso8601String(), 'tool': tool, 'input': input, 'answer': answer};
}

class PermissionLog {
  PermissionLog(this.file);

  final File file;

  Future<void> add(PermissionEntry e) async {
    await file.parent.create(recursive: true);
    await file.writeAsString('${jsonEncode(e.toJson())}\n', mode: FileMode.append, flush: true);
  }

  /// The last [count] entries, newest first.
  Future<List<PermissionEntry>> read({int count = 200}) async {
    if (!file.existsSync()) return const [];
    final lines = await file.readAsLines();
    return [
      for (final l in lines.reversed.take(count))
        if (l.trim().isNotEmpty) PermissionEntry.fromJson(jsonDecode(l) as Map<String, Object?>),
    ];
  }
}
