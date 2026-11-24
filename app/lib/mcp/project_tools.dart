// The tool the project info run writes with: the names, logo, platforms,
// task board, channels and IDE it found for the project.
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import '../core/platforms.dart';

/// What the run found. Empty lists and nulls mean "not found".
typedef ProjectInfo = ({
  String name,
  String? description,
  List<String> aliases,
  String? logo,
  List<String> platforms,
  String? tech,
  String? board,
  List<String> channels,
  String? ide,
});

/// What the project info tool needs from the app.
abstract interface class ProjectInfoBackend {
  /// Saves what the run found for project [id]. The logo is a path in the
  /// project folder or absolute. Returns an error to show the session, or null.
  Future<String?> setProjectInfo(String id, ProjectInfo info);
}

final _setInfo = Tool(
  name: 'set_project_info',
  description: 'Save what you found about the project in the current folder. Call it once, at the end. Leave out what you did not find.',
  inputSchema: Schema.object(
    properties: {
      'name': Schema.string(description: 'The product name users and colleagues say: "Acme VPN", not the folder name.'),
      'description': Schema.string(description: 'One sentence: what it is and for which platforms.'),
      'aliases': Schema.list(
        items: Schema.string(),
        description: 'Every other name messages may use for it: app and store names, bundle or package ids, the repo name, ticket prefixes.',
      ),
      'logo': Schema.string(description: 'Path of the app icon, relative to the project folder. PNG, JPEG, WebP or SVG.'),
      // No enum: one value off ("ios") would refuse the whole call. Unknown ones are dropped.
      'platforms': Schema.list(items: Schema.string(), description: 'Where it runs, from: ${platforms.keys.join(', ')}.'),
      'tech': Schema.string(description: 'Main languages, frameworks and build tools, in a few words: "Swift, SwiftUI, Xcode".'),
      'board': Schema.string(description: 'The task board: "jira:KEY", from the ticket prefix the commits and branches use.'),
      'channels': Schema.list(items: Schema.string(), description: 'Slack channels about this project, "#name".'),
      'ide': Schema.string(description: 'Command that opens the folder in the IDE that fits the tech: xed, studio, idea, code.'),
    },
    required: ['name'],
  ),
);

/// Registered only on a session Deck started for one project.
void registerProjectTools(ToolsSupport server, ProjectInfoBackend backend, {required String project}) {
  List<String> list(Object? v) => [
    for (final x in (v as List?) ?? const [])
      if ('$x'.trim().isNotEmpty) '$x'.trim(),
  ];
  String? text(Object? v) => v is String && v.trim().isNotEmpty ? v.trim() : null;

  server.registerTool(_setInfo, (r) async {
    final a = r.arguments ?? const <String, Object?>{};
    final name = text(a['name']);
    if (name == null) return CallToolResult(isError: true, content: [TextContent(text: 'name is required.')]);
    final error = await backend.setProjectInfo(project, (
      name: name,
      description: text(a['description']),
      aliases: list(a['aliases']),
      logo: text(a['logo']),
      platforms: [
        for (final x in list(a['platforms']))
          if (platforms.containsKey(x)) x,
      ],
      tech: text(a['tech']),
      board: text(a['board']),
      channels: list(a['channels']),
      ide: text(a['ide']),
    ));
    if (error != null) return CallToolResult(isError: true, content: [TextContent(text: error)]);
    return CallToolResult(
      content: [
        TextContent(text: jsonEncode({'ok': true})),
      ],
    );
  });
}
