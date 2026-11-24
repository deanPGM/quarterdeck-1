// The feature map tools of the Deck MCP server: the names, inputs and
// refusals of Skim's (packages/mcp), so the skim-map steps work unchanged.
// A call names its project with `project`; a session Deck started for one
// project (its URL carries ?project=) gets that one by default.
import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import '../core/map/models.dart';
import '../data/map_store.dart';

/// What the map tools need from the app.
abstract interface class MapBackend {
  /// The ids of the projects that have a folder, for an error that says
  /// which ones exist.
  List<String> mapProjects();

  /// The map of project [id], null when Deck has no folder for it.
  MapStore? mapOf(String id);

  /// The map of [project] changed: the page reads it again.
  void mapChanged(String project);

  /// The session said which features this pass draws or confirms.
  void mapPlanned(String project, List<String> features);

  /// Feature [id] of [project] was drawn or confirmed in this pass.
  void mapFeatureDone(String project, String id);
}

Map<String, Object?> _str(String description) => {'type': 'string', 'description': description};
Map<String, Object?> _enum(List<String> values, [String? description]) => {'type': 'string', 'enum': values, 'description': ?description};
Map<String, Object?> _list(Map<String, Object?> items, [String? description]) => {'type': 'array', 'items': items, 'description': ?description};
Map<String, Object?> _obj(Map<String, Object?> props, {List<String> required = const [], String? description}) => {
  'type': 'object',
  'properties': props,
  if (required.isNotEmpty) 'required': required,
  'description': ?description,
};

final _place = {
  'path': _str('The file it lives in, relative to the repository root.'),
  'line': {'type': 'integer', 'description': 'The line in that file.'},
};

final _project = {'project': _str('The Deck project id. Optional in a session Deck started for one project.')};

final _step = _obj(
  {
    'title': _str('A few words: what happens at this step.'),
    'detail': _str('One or two sentences: how it happens, in the code.'),
    'why': _str('Why the reader should care, only when it is not obvious.'),
    ..._place,
    'mark': _enum(['touched', 'concern'], 'concern: a fragile step, look hard here. Never touched in the map.'),
    'severity': _enum(['high', 'medium', 'low'], 'With mark concern only: how bad it is.'),
  },
  required: ['title'],
);

final _feature = _obj(
  {
    'title': _str('The page title: a few words naming the feature.'),
    'summary': _str('One or two sentences: what the feature does, for whom.'),
    'graph': _obj(
      {
        'caption': _str('One line under the graph: what the reader should take from it.'),
        'nodes': _list(
          _obj(
            {
              'name': _str('The class, interface or module as the code names it. Unique in the graph.'),
              'status': _enum(['added', 'changed', 'removed', 'context'], 'Always context in the map.'),
              'role': _str('One sentence: what it is for in this feature.'),
              ..._place,
              'side': _str('The lane it runs in when the app spans devices or tiers: clock, parent, cloud.'),
              'feature': _str('The id of the feature this class belongs to, when borrowed from another feature. Leave path out.'),
            },
            required: ['name', 'status'],
          ),
        ),
        'edges': _list(
          _obj(
            {
              'from': _str('Node name.'),
              'to': _str('Node name.'),
              'kind': _enum(['extends', 'implements', 'owns', 'uses', 'calls', 'creates']),
              'label': _str('A few words on the arrow, such as the method called.'),
            },
            required: ['from', 'to', 'kind'],
          ),
        ),
      },
      required: ['nodes'],
    ),
    'sequences': _list(
      _obj(
        {
          'title': _str('The tab label: "Main flow", "Wrong PIN". Required when there are several.'),
          'mermaid': _str('sequenceDiagram source, without the ```mermaid fence.'),
          'caption': _str('One line under the picture.'),
          'steps': _list(_step, 'One entry per message (arrow), in source order. Not notes, loop, alt or rect lines.'),
        },
        required: ['mermaid'],
      ),
      'The main flow first, then up to two more: a failure, restore or second actor flow. At most 3.',
    ),
    'states': _list(
      _obj(
        {
          'title': _str('What the machine is: "Clock mode".'),
          'mermaid': _str('stateDiagram-v2 source.'),
          'caption': _str('One line under the picture.'),
          'transitions': _list(
            _obj({'title': _str('A few words.'), 'detail': _str('One sentence.'), ..._place}, required: ['title']),
            'One entry per arrow, in source order.',
          ),
        },
        required: ['title', 'mermaid'],
      ),
      'Only when an enum, status or stored progress decides what the feature does. At most 3.',
    ),
    'links': _list(
      _obj(
        {
          'feature': _str('The other feature id.'),
          'kind': _enum(['calls', 'calledBy']),
          'detail': _str('A few words: what goes across.'),
          ..._place,
        },
        required: ['feature', 'kind'],
      ),
      'The other features this one calls or is called by.',
    ),
    'notes': _list(
      _obj(
        {
          'kind': _enum(['dead-code', 'platform', 'config', 'finding']),
          'text': _str('One or two sentences.'),
          ..._place,
        },
        required: ['kind', 'text'],
      ),
      'What is not a step: dead code, a platform split, a constant kept in sync elsewhere, a bug noticed while reading.',
    ),
    'data': _list(
      _obj(
        {
          'type': _str('The id of a data type written with set_map_data.'),
          'use': _enum(['sends', 'receives', 'reads', 'writes']),
          'detail': _str('A few words: when or why.'),
        },
        required: ['type', 'use'],
      ),
      'The data types this feature moves across a boundary.',
    ),
  },
  required: ['title'],
);

Tool _tool(String name, String description, [Map<String, Object?> props = const {}, List<String> required = const []]) => Tool(
  name: name,
  description: description,
  inputSchema: ObjectSchema.fromMap(_obj({..._project, ...props}, required: required)),
);

final _getMap = _tool(
  'get_map',
  'The feature map of the project (`.skim/map/`): every feature with its id, title, summary and paths, the commit the map '
      'was last stamped at, and what changed since: changedFiles, staleFeatures (ids a changed file belongs to), '
      'uncoveredFiles (changed files no feature claims) and brokenLinks (links or borrowed nodes naming a feature the map '
      'does not have, `data/<id>` for a missing data type), dataTypes and staleData (types whose declaring file changed). '
      'commit is null before the first pass. planLeft, when present, lists the features a stopped pass planned and has '
      'not drawn yet: resume with those. The user browses the map in Deck, on the project page.',
);

final _getFeature = _tool(
  'get_map_feature',
  'One feature of the map, whole: its class graph and views as last written. Read it before redrawing a stale feature.',
  {'id': _str('The feature id, from get_map.')},
  ['id'],
);

final _setFeature = _tool(
  'set_map_feature',
  'Write one feature of the project map, replacing the one with the same id. In the map nothing is added or changed: '
      'give every node status context and say what it is for in `role`. A feature has up to three `sequences` (main flow '
      'first), up to three `states`, `links` to other features and `notes`; all optional. `paths` lists the files and '
      'folders that implement the feature; a later commit touching one of them marks the feature stale. A link to a '
      'feature not written yet comes back as a warning: write it later in the pass, or fix the id.',
  {
    'id': _str('Stable lowercase slug, also the file name: track-cache. Reuse it to update the feature.'),
    'paths': _list({'type': 'string'}, 'Files and folders of the repository that implement the feature, relative to its root.'),
    'feature': _feature,
  },
  ['id', 'paths', 'feature'],
);

final _getData = _tool(
  'get_map_data',
  'One data type of the map, whole: its fields, versions and definitions. Read it before rewriting a stale one.',
  {'id': _str('The data type id, from get_map.')},
  ['id'],
);

final _setData = _tool(
  'set_map_data',
  'Write one data type of the map, replacing the one with the same id: a type that crosses a boundary (a message on the '
      'wire, a stored document, a URL format, a file), written once for the whole map. Features point at it from their '
      '`data`. List every place it is declared in `definitions`: a type declared twice (Dart and TypeScript) is shown as '
      'one to keep in sync, and a change to any of those files makes it stale.',
  {
    'id': _str('Stable lowercase slug, also the file name: clock-state.'),
    'name': _str('As the code names it: ClockStateMessage.'),
    'boundary': _enum(['wire', 'storage', 'url', 'file']),
    'summary': _str('One sentence: what it carries and between whom.'),
    'since': _str('The protocol or schema version that introduced it, free text.'),
    'until': _str('The last version that carries it, when it is on its way out.'),
    'fields': _list(
      _obj(
        {
          'name': {'type': 'string'},
          'type': _str('As the code writes it. The name of another data type links to it.'),
          'note': _str('A few words, only when the name does not say it: units, allowed values.'),
          'optional': {'type': 'boolean'},
          'since': _str('The version that added the field, when later than the type.'),
        },
        required: ['name', 'type'],
      ),
    ),
    'definitions': _list(
      _obj(
        {
          'path': {'type': 'string'},
          'line': {'type': 'integer'},
        },
        required: ['path'],
      ),
      'Every file that declares it.',
    ),
  },
  ['id', 'name', 'boundary', 'definitions'],
);

final _removeData = _tool('remove_map_data', 'Remove one data type from the map: no code declares it any more.', {'id': _str('The data type id.')}, ['id']);

final _confirm = _tool(
  'confirm_map_feature',
  'Mark a stale feature as still true at head without redrawing it, when the change under its paths moved nothing its '
      'views show: a fix inside a method, a renamed local. Refused when one of its paths is gone. When a class, relation, '
      'flow, state, link or note changed, rewrite it with set_map_feature instead.',
  {'id': _str('The feature id.')},
  ['id'],
);

final _removeFeature = _tool(
  'remove_map_feature',
  'Remove one feature from the map: the code is gone, or it was merged into another feature.',
  {'id': _str('The feature id.')},
  ['id'],
);

final _plan = _tool(
  'plan_map',
  'Tell Deck which features this pass will draw, redraw or confirm, once the list is known and before drawing the '
      'first one, so the user sees how far the pass is. Call it again if the list changes.',
  {
    'features': _list({'type': 'string'}, 'The feature ids, architecture included.'),
  },
  ['features'],
);

final _getArch = _tool(
  'get_map_architecture',
  'The architecture of the map as last written: layers, allowed flows, rules and violations. Read it before rewriting it.',
);

final _setArch = _tool(
  'set_map_architecture',
  'Write the app\'s architecture, replacing the one there: the layers top first (what lives in each, how its classes are '
      'named, where it lives), the dependencies allowed between them, the rules in plain words, and every place the code '
      'breaks them. Take the rules from the project\'s own docs when it has them (list them in sources), else from what '
      'most of the code does. A violation names the class, what it reaches, its severity and why it matters.',
  {
    'summary': _str('Two or three sentences: the pattern (MVVM, layered, clean) and its main rule.'),
    'layers': _list(
      _obj(
        {
          'id': _str('Lowercase slug: view, view-model, manager.'),
          'name': _str('As the docs or the code name it: "ViewModel layer".'),
          'role': _str('One sentence: what it does, and what it must not do.'),
          'naming': _list({'type': 'string'}, 'Class name patterns: *Screen, *View, *ViewModel.'),
          'paths': _list({'type': 'string'}, 'Folders or files where it lives.'),
          'examples': _list({'type': 'string'}, 'Three to six real classes.'),
        },
        required: ['id', 'name'],
      ),
      'Top layer first.',
    ),
    'flows': _list(
      _obj({'from': _str('Layer id.'), 'to': _str('Layer id.'), 'label': _str('A few words, when the kind of use matters.')}, required: ['from', 'to']),
      'Allowed dependencies: from may use to.',
    ),
    'rules': _list({'type': 'string'}, 'What the layers and flows do not say: "Views never call .shared managers".'),
    'violations': _list(
      _obj(
        {
          'from': _str('The class that breaks a rule.'),
          'fromLayer': _str('Its layer id.'),
          'to': _list({'type': 'string'}, 'What it reaches, class names.'),
          'toLayer': _str('The layer id it reaches.'),
          'severity': _enum(['high', 'medium', 'low', 'accepted'], 'accepted: a known exception the docs agree to.'),
          'why': _str('One or two sentences: which rule, and what it costs.'),
          'fix': _str('One line, when the docs or the code say what would fix it.'),
          ..._place,
        },
        required: ['from', 'fromLayer', 'toLayer', 'severity', 'why'],
      ),
    ),
    'sources': _list({'type': 'string'}, 'The docs the rules come from, paths in the repository.'),
  },
  ['layers'],
);

final _getUi = _tool(
  'get_map_ui',
  'The UI analysis as last written: tokens, shared components, screens, duplicates and guideline breaks. Read it before rewriting it.',
);

final _severity = _enum(['high', 'medium', 'low', 'accepted'], 'accepted: a known exception the docs agree to.');

final _setUi = _tool(
  'set_map_ui',
  'Write the UI analysis, replacing the one there: the UI rules from the project\'s docs and skills (list them in '
      'sources), the design tokens and shared components, every screen with the shared components it uses, the pieces '
      'of UI built twice or more, and every place the UI breaks the rules.',
  {
    'summary': _str('Two or three sentences: how the UI is built (design system, theme, widget kit) and its main rule.'),
    'rules': _list({'type': 'string'}, 'The UI rules in plain words: "Colors come from DeckColors, never a raw Color".'),
    'sources': _list({'type': 'string'}, 'The docs and skills the rules come from, paths in the repository.'),
    'paths': _list({'type': 'string'}, 'The folders the UI lives in. A change under one makes the analysis stale.'),
    'tokens': _list(
      _obj(
        {
          'kind': _enum(uiTokenKinds),
          'name': _str('As the code names it: c.label2, t.bodySmall, Spacing.m.'),
          'note': _str('A few words, when the name does not say it.'),
          ..._place,
        },
        required: ['kind', 'name'],
      ),
    ),
    'components': _list(
      _obj({'name': _str('The widget or view, as the code names it.'), 'role': _str('One sentence: what it shows.'), ..._place}, required: ['name']),
      'Widgets built to be shared between screens.',
    ),
    'screens': _list(
      _obj(
        {
          'name': _str('The screen, page or pane, as the code names it.'),
          'role': _str('One sentence: what the user does there.'),
          ..._place,
          'uses': _list({'type': 'string'}, 'The shared component names it uses.'),
        },
        required: ['name'],
      ),
    ),
    'duplicates': _list(
      _obj(
        {
          'title': _str('A few words: what is built twice, "Code path chip".'),
          'severity': _severity,
          'why': _str('One or two sentences: how the copies differ, and what that costs.'),
          'use': _str('The shared component the copies should use, existing or to create.'),
          'copies': _list(_obj({'name': _str('The class or function of the copy.'), ..._place}, required: ['name']), 'Two or more.'),
        },
        required: ['title', 'severity', 'why', 'copies'],
      ),
    ),
    'breaks': _list(
      _obj(
        {
          'rule': _str('The rule broken, in a few words.'),
          'severity': _severity,
          'why': _str('One or two sentences: what it costs.'),
          'fix': _str('One line, when the docs or the code say what would fix it.'),
          'where': _str('The class it happens in.'),
          'count': {'type': 'integer', 'description': 'How many places break it the same way; path is one of them.'},
          ..._place,
        },
        required: ['rule', 'severity', 'why'],
      ),
    ),
  },
  ['paths'],
);

final _stamp = _tool(
  'stamp_map',
  'Record that the map now describes the current head. Call it once at the end of a complete pass, after every stale '
      'feature is redrawn or confirmed and every uncovered file placed, never in the middle: what changed since the stamp '
      'is how the next update finds its work. Refused while brokenLinks remain.',
);

/// Adds the map tools to [server]. [project] is the session's own project.
void registerMapTools(ToolsSupport server, MapBackend backend, {String? project}) {
  CallToolResult json(Object? data) => CallToolResult(content: [TextContent(text: jsonEncode(data))]);
  CallToolResult fail(String message) => CallToolResult(isError: true, content: [TextContent(text: message)]);

  /// Runs [fn] on the map the call names. [write] tells the page to read it again.
  FutureOr<CallToolResult> Function(CallToolRequest) on(Future<Object?> Function(MapStore map, Map<String, Object?> args) fn, {bool write = false}) {
    return (r) async {
      final args = r.arguments ?? const <String, Object?>{};
      final id = (args['project'] as String?) ?? project;
      final known = backend.mapProjects();
      if (id == null) return fail('Name the project: one of ${known.join(', ')}.');
      final map = backend.mapOf(id);
      if (map == null) return fail('No project "$id" with a folder in Deck. Known: ${known.join(', ')}.');
      try {
        final out = await fn(map, args);
        if (write) backend.mapChanged(id);
        return json(out);
      } on MapError catch (e) {
        return fail(e.message);
      }
    };
  }

  List<String> cap(List<String> files) => files.length > 300 ? [...files.take(300), '... and ${files.length - 300} more'] : files;

  server.registerTool(
    _getMap,
    on((map, _) async {
      final m = await map.readMap();
      return {
        'commit': m.commit,
        'head': m.head,
        'updatedAt': m.updatedAt,
        'commitMissing': m.commitMissing,
        'changedFiles': cap(m.changedFiles),
        'staleFeatures': m.staleFeatures,
        'uncoveredFiles': cap(m.uncoveredFiles),
        'brokenLinks': [for (final l in m.brokenLinks) l.toJson()],
        'staleData': m.staleData,
        if (m.plan.isNotEmpty) 'planLeft': m.planLeft,
        'architecture': m.architecture == null
            ? null
            : {
                'layers': m.architecture!.layers.length,
                'violations': m.architecture!.violations.length,
                'commit': m.architecture!.commit,
                'stale': m.staleArchitecture,
              },
        'ui': m.ui == null
            ? null
            : {
                'screens': m.ui!.screens.length,
                'duplicates': m.ui!.duplicates.length,
                'breaks': m.ui!.breaks.length,
                'commit': m.ui!.commit,
                'stale': m.staleUi,
              },
        'dataTypes': [
          for (final d in m.dataTypes) {'id': d.id, 'name': d.name, 'boundary': d.boundary, 'summary': d.summary},
        ],
        'features': [
          for (final f in m.features) {'id': f.id, 'title': f.title, 'summary': f.summary, 'paths': f.paths, 'commit': f.commit},
        ],
      };
    }),
  );
  server.registerTool(_getFeature, on((map, a) async => map.readFeature('${a['id']}').toJson()));
  server.registerTool(_plan, (r) {
    final a = r.arguments ?? const <String, Object?>{};
    final id = (a['project'] as String?) ?? project;
    if (id == null) return fail('Name the project: one of ${backend.mapProjects().join(', ')}.');
    final ids = [
      for (final f in (a['features'] as List?) ?? const [])
        if (f is String && featureId.hasMatch(f)) f,
    ];
    if (ids.isEmpty) return fail('features must list feature ids like track-cache');
    final map = backend.mapOf(id);
    if (map == null) return fail('No project "$id" with a folder in Deck.');
    map.writePlan(ids);
    backend.mapPlanned(id, ids);
    return json({'planned': ids.length});
  });
  server.registerTool(
    _setFeature,
    on((map, a) async {
      final feature = (a['feature'] as Map?)?.cast<String, Object?>() ?? const {};
      final r = await map.writeFeature({...feature, 'id': a['id'], 'paths': a['paths']});
      backend.mapFeatureDone((a['project'] as String?) ?? project!, r.feature.id);
      return {'id': r.feature.id, 'title': r.feature.title, 'commit': r.feature.commit, if (r.warnings.isNotEmpty) 'warnings': r.warnings};
    }, write: true),
  );
  server.registerTool(_getArch, on((map, _) async => map.readArchitecture()?.toJson() ?? {'architecture': null, 'message': 'Not written yet.'}));
  server.registerTool(
    _setArch,
    on((map, a) async {
      final arch = await map.writeArchitecture(a);
      return {'layers': arch.layers.length, 'violations': arch.violations.length, 'commit': arch.commit};
    }, write: true),
  );
  server.registerTool(_getUi, on((map, _) async => map.readUi()?.toJson() ?? {'ui': null, 'message': 'Not written yet.'}));
  server.registerTool(
    _setUi,
    on((map, a) async {
      final ui = await map.writeUi(a);
      return {'screens': ui.screens.length, 'duplicates': ui.duplicates.length, 'breaks': ui.breaks.length, 'commit': ui.commit};
    }, write: true),
  );
  server.registerTool(_getData, on((map, a) async => map.readDataType('${a['id']}').toJson()));
  server.registerTool(
    _setData,
    on((map, a) async {
      final t = await map.writeDataType('${a['id']}', a);
      return {'id': t.id, 'name': t.name, 'commit': t.commit};
    }, write: true),
  );
  server.registerTool(
    _removeData,
    on((map, a) async {
      map.removeDataType('${a['id']}');
      return {'ok': true};
    }, write: true),
  );
  server.registerTool(
    _confirm,
    on((map, a) async {
      final f = await map.confirmFeature('${a['id']}');
      backend.mapFeatureDone((a['project'] as String?) ?? project!, f.id);
      return {'id': f.id, 'commit': f.commit};
    }, write: true),
  );
  server.registerTool(
    _removeFeature,
    on((map, a) async {
      map.removeFeature('${a['id']}');
      return {'ok': true};
    }, write: true),
  );
  server.registerTool(
    _stamp,
    on((map, _) async {
      final m = await map.stamp();
      return {'commit': m.commit, 'features': m.features.length};
    }, write: true),
  );
}
