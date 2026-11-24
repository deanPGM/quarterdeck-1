// The feature map of a project folder, in `.skim/map/`: one JSON file per
// feature and per data type, `index.json` for the commit of the last complete
// pass. A port of Skim's packages/core/src/map.ts, same files and same rules,
// so a map drawn by Skim reads here and the other way round. The folder
// ignores itself: the map is a local cache, not part of the code.
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/map/models.dart';

/// A refusal the agent reads and fixes: the message says what to change.
class MapError implements Exception {
  MapError(this.message);

  final String message;

  @override
  String toString() => message;
}

/// More flows or machines than this is two features.
const _maxViews = 3;

/// Words mermaid's sequence parser reads as syntax whatever their case: a
/// participant named `Par` or `Link` makes the whole picture fail to parse.
final _sequenceKeywords = 'participant actor create destroy box as loop rect opt alt else par and critical option break end note over left right of links link properties details activate deactivate autonumber title'
    .split(' ')
    .toSet();

final _stateDiagram = RegExp(r'^\s*(%%.*\n\s*)*stateDiagram(-v2)?\b');

typedef Json = Map<String, Object?>;

class MapStore {
  MapStore(this.root);

  /// The project folder, a git working tree.
  final String root;

  Directory get dir => Directory(p.join(root, '.skim', 'map'));
  File _featureFile(String id) => File(p.join(dir.path, 'features', '$id.json'));
  File _dataFile(String id) => File(p.join(dir.path, 'data', '$id.json'));
  File get _index => File(p.join(dir.path, 'index.json'));

  /// Deck's own: the features the pass under way said it would draw, so a
  /// stopped pass resumes where it was. Skim reads only features/ and data/.
  File get _plan => File(p.join(dir.path, 'plan.json'));

  File get _architecture => File(p.join(dir.path, 'architecture.json'));

  MapArchitecture? readArchitecture() => _architecture.existsSync() ? _tryParse(_architecture, MapArchitecture.fromJson) : null;

  /// Writes the architecture, replacing the one there. Layers have unique
  /// ids, flows and violations name them, paths exist.
  Future<MapArchitecture> writeArchitecture(Json input) async {
    final layers = _list(input['layers']);
    if (layers.isEmpty) throw MapError('an architecture needs at least one layer, top first');
    final ids = <String>{};
    final cleanLayers = [
      for (final l in layers)
        () {
          final id = _str(l['id']);
          if (!featureId.hasMatch(id)) throw MapError('layer id must be a lowercase slug like view-model, got ${jsonEncode(l['id'])}');
          if (!ids.add(id)) throw MapError('layer "$id" appears twice');
          final name = _str(l['name']);
          if (name.isEmpty) throw MapError('layer "$id" needs a name');
          final paths = [
            for (final x in (l['paths'] as List?) ?? const [])
              if (_str(x).isNotEmpty) p.posix.normalize(_str(x)).replaceAll(RegExp(r'/+$'), ''),
          ];
          for (final path in paths) {
            if (!_inRepo(path)) throw MapError('Path not in the repository: $path');
          }
          return <String, Object?>{
            'id': id,
            'name': name,
            'role': _str(l['role']),
            'naming': [
              for (final x in (l['naming'] as List?) ?? const [])
                if (_str(x).isNotEmpty) _str(x),
            ],
            'paths': paths,
            'examples': [
              for (final x in (l['examples'] as List?) ?? const [])
                if (_str(x).isNotEmpty) _str(x),
            ],
          };
        }(),
    ];
    void known(Object? id, String what) {
      if (!ids.contains(id)) throw MapError('$what must be a layer id (${ids.join(', ')}), got ${jsonEncode(id)}');
    }

    final flows = [
      for (final f in _list(input['flows']))
        () {
          known(f['from'], 'flow from');
          known(f['to'], 'flow to');
          return <String, Object?>{'from': f['from'], 'to': f['to'], 'label': _str(f['label'])};
        }(),
    ];
    final violations = [
      for (final v in _list(input['violations']))
        () {
          final from = _str(v['from']);
          if (from.isEmpty) throw MapError('every violation names the class that breaks the rule in from');
          known(v['fromLayer'] ?? v['from_layer'], 'violation fromLayer');
          known(v['toLayer'] ?? v['to_layer'], 'violation toLayer');
          _oneOf('violation severity', v['severity'], violationSeverities);
          final why = _str(v['why']);
          if (why.isEmpty) throw MapError('violation of $from needs a why');
          return <String, Object?>{
            'from': from,
            'fromLayer': v['fromLayer'] ?? v['from_layer'],
            'to': [
              for (final x in (v['to'] as List?) ?? const [])
                if (_str(x).isNotEmpty) _str(x),
            ],
            'toLayer': v['toLayer'] ?? v['to_layer'],
            'severity': v['severity'],
            'why': why,
            'fix': _str(v['fix']),
            ..._place(v['path'], v['line']),
          };
        }(),
    ];
    final sources = [
      for (final x in (input['sources'] as List?) ?? const [])
        if (_str(x).isNotEmpty) _str(x),
    ];
    for (final src in sources) {
      if (!_inRepo(src)) throw MapError('Path not in the repository: $src');
    }
    final json = <String, Object?>{
      'summary': _str(input['summary']),
      'layers': cleanLayers,
      'flows': flows,
      'rules': [
        for (final x in (input['rules'] as List?) ?? const [])
          if (_str(x).isNotEmpty) _str(x),
      ],
      'violations': violations,
      'sources': sources,
      'commit': await _head(),
      'updatedAt': _now(),
    };
    _ensureDir();
    _write(_architecture, json);
    return MapArchitecture.fromJson(json);
  }

  File get _ui => File(p.join(dir.path, 'ui.json'));

  MapUi? readUi() => _ui.existsSync() ? _tryParse(_ui, MapUi.fromJson) : null;

  /// Writes the UI analysis, replacing the one there. Paths exist, kinds and
  /// severities are known, a duplicate has two copies or more.
  Future<MapUi> writeUi(Json input) async {
    List<String> strings(Object? v) => [
      for (final x in (v as List?) ?? const [])
        if (_str(x).isNotEmpty) _str(x),
    ];
    String named(Json j, String what) {
      final name = _str(j['name']);
      if (name.isEmpty) throw MapError('every $what needs a name');
      return name;
    }

    final paths = [for (final x in strings(input['paths'])) p.posix.normalize(x).replaceAll(RegExp(r'/+$'), '')];
    if (paths.isEmpty) throw MapError('paths must list the folders the UI lives in');
    final sources = strings(input['sources']);
    for (final path in [...paths, ...sources]) {
      if (!_inRepo(path)) throw MapError('Path not in the repository: $path');
    }
    final tokens = [
      for (final t in _list(input['tokens']))
        () {
          _oneOf('token kind', t['kind'], uiTokenKinds);
          return <String, Object?>{'kind': t['kind'], 'name': named(t, 'token'), 'note': _str(t['note']), ..._place(t['path'], t['line'])};
        }(),
    ];
    final components = [
      for (final c in _list(input['components'])) <String, Object?>{'name': named(c, 'component'), 'role': _str(c['role']), ..._place(c['path'], c['line'])},
    ];
    final screens = [
      for (final s in _list(input['screens']))
        <String, Object?>{'name': named(s, 'screen'), 'role': _str(s['role']), ..._place(s['path'], s['line']), 'uses': strings(s['uses'])},
    ];
    final duplicates = [
      for (final d in _list(input['duplicates']))
        () {
          final title = _str(d['title']);
          if (title.isEmpty) throw MapError('every duplicate needs a title');
          _oneOf('duplicate severity', d['severity'], violationSeverities);
          final why = _str(d['why']);
          if (why.isEmpty) throw MapError('duplicate "$title" needs a why');
          final copies = [
            for (final c in _list(d['copies'])) <String, Object?>{'name': named(c, 'copy'), ..._place(c['path'], c['line'])},
          ];
          if (copies.length < 2) throw MapError('duplicate "$title" needs two copies or more');
          return <String, Object?>{'title': title, 'severity': d['severity'], 'why': why, 'use': _str(d['use']), 'copies': copies};
        }(),
    ];
    final breaks = [
      for (final b in _list(input['breaks']))
        () {
          final rule = _str(b['rule']);
          if (rule.isEmpty) throw MapError('every break names the rule it breaks');
          _oneOf('break severity', b['severity'], violationSeverities);
          final why = _str(b['why']);
          if (why.isEmpty) throw MapError('break of "$rule" needs a why');
          final count = b['count'];
          return <String, Object?>{
            'rule': rule,
            'severity': b['severity'],
            'why': why,
            'fix': _str(b['fix']),
            'where': _str(b['where']),
            'count': count is num && count > 1 ? count.toInt() : 1,
            ..._place(b['path'], b['line']),
          };
        }(),
    ];
    final json = <String, Object?>{
      'summary': _str(input['summary']),
      'rules': strings(input['rules']),
      'sources': sources,
      'paths': paths,
      'tokens': tokens,
      'components': components,
      'screens': screens,
      'duplicates': duplicates,
      'breaks': breaks,
      'commit': await _head(),
      'updatedAt': _now(),
    };
    _ensureDir();
    _write(_ui, json);
    return MapUi.fromJson(json);
  }

  /// Keeps the list of features this pass draws, redraws or confirms.
  void writePlan(List<String> features) {
    _ensureDir();
    _write(_plan, {'features': features, 'updatedAt': _now()});
  }

  Future<String> _git(List<String> args) async {
    final r = await Process.run('git', ['-C', root, ...args]);
    if (r.exitCode != 0) throw ProcessException('git', args, '${r.stderr}'.trim(), r.exitCode);
    return r.stdout as String;
  }

  Future<String> _head() async => (await _git(['rev-parse', 'HEAD'])).trim();

  String _now() => DateTime.now().toUtc().toIso8601String();

  /// Written beside, then renamed over: the page reads the map while agents
  /// write it, and must never read half a file.
  void _write(File f, Json value) {
    final tmp = File('${f.path}.tmp');
    tmp.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(value)}\n');
    tmp.renameSync(f.path);
  }

  void _ensureDir() {
    Directory(p.join(dir.path, 'features')).createSync(recursive: true);
    Directory(p.join(dir.path, 'data')).createSync(recursive: true);
    final ignore = File(p.join(dir.path, '.gitignore'));
    if (!ignore.existsSync()) ignore.writeAsStringSync('# The feature map is a local cache, written by the skim-map skill.\n*\n');
  }

  /// Every JSON file of one folder. A file that does not parse (edited by
  /// hand) is left out, not the whole map with it.
  List<T> _readAll<T>(String folder, T Function(Json) parse) {
    final d = Directory(p.join(dir.path, folder));
    if (!d.existsSync()) return [];
    return [for (final f in d.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) ?_tryParse(f, parse)];
  }

  T? _tryParse<T>(File f, T Function(Json) parse) {
    try {
      return parse(jsonDecode(f.readAsStringSync()) as Json);
    } catch (_) {
      return null;
    }
  }

  List<MapFeature> readFeatures() => _readAll('features', MapFeature.fromJson)..sort((a, b) => a.title.compareTo(b.title));

  List<MapDataType> readDataTypes() => _readAll('data', MapDataType.fromJson)..sort((a, b) => a.name.compareTo(b.name));

  MapFeature readFeature(String id) {
    if (!featureId.hasMatch(id) || !_featureFile(id).existsSync()) throw MapError('No feature ${jsonEncode(id)} in the map');
    return MapFeature.fromJson(jsonDecode(_featureFile(id).readAsStringSync()) as Json);
  }

  MapDataType readDataType(String id) {
    if (!featureId.hasMatch(id) || !_dataFile(id).existsSync()) throw MapError('No data type ${jsonEncode(id)} in the map');
    return MapDataType.fromJson(jsonDecode(_dataFile(id).readAsStringSync()) as Json);
  }

  /// A path of the map names a file or a folder of the working tree, never
  /// outside it.
  bool _inRepo(String path) {
    if (path.isEmpty || path.startsWith('-') || path.contains('\x00') || path.split('/').contains('..')) return false;
    if (path.startsWith('/')) return false;
    return FileSystemEntity.typeSync(p.join(root, path)) != FileSystemEntityType.notFound;
  }

  /// A path with its line, checked. The line is kept only with a path.
  Json _place(Object? path, Object? line) {
    final s = path is String && path.isNotEmpty ? path : null;
    if (s != null && !_inRepo(s)) throw MapError('Path not in the repository: $s');
    return {'path': s, 'line': s != null && line is num && line != 0 ? line.toInt() : null};
  }

  static String _str(Object? v) => v is String ? v.trim() : '';

  static List<Json> _list(Object? v) => v is List
      ? [
          for (final e in v)
            if (e is Map) e.cast<String, Object?>(),
        ]
      : const [];

  static void _oneOf(String what, Object? value, List<String> allowed) {
    if (!allowed.contains(value)) throw MapError('$what must be one of ${allowed.join(', ')}, got ${jsonEncode(value)}');
  }

  /// Refuses a sequence whose participant id mermaid would read as a keyword,
  /// before it reaches the page as a parse error.
  static void checkSequence(String mermaid) {
    for (final m in RegExp(r'^\s*(?:participant|actor)\s+([^\s]+)', multiLine: true, caseSensitive: false).allMatches(mermaid)) {
      if (_sequenceKeywords.contains(m[1]!.toLowerCase())) {
        throw MapError(
          'participant ${jsonEncode(m[1])} is a mermaid keyword and breaks the diagram: use another id, '
          'such as ${m[1]}1 or an abbreviation, and keep the name with "as"',
        );
      }
    }
  }

  List<Json> _steps(Object? raw) => [for (final st in _list(raw)) _step(st)];

  Json _step(Json st) {
    final title = _str(st['title']);
    if (title.isEmpty) throw MapError('every step needs a title');
    final mark = st['mark'];
    final severity = st['severity'];
    if (mark != null) _oneOf('step mark', mark, stepMarks);
    if (severity != null) _oneOf('step severity', severity, concernSeverities);
    if (severity != null && mark != 'concern') throw MapError('a step severity goes with mark concern');
    return {'title': title, 'detail': _str(st['detail']), 'why': _str(st['why']), ..._place(st['path'], st['line']), 'mark': mark, 'severity': ?severity};
  }

  Json? _graph(Object? raw) {
    if (raw is! Map) return null;
    final g = raw.cast<String, Object?>();
    final names = <String>{};
    final nodes = [
      for (final n in _list(g['nodes']))
        () {
          final name = _str(n['name']);
          if (name.isEmpty) throw MapError('every node needs a name');
          if (!names.add(name)) throw MapError('node ${jsonEncode(name)} appears twice');
          _oneOf('node status', n['status'], nodeStatuses);
          final side = _str(n['side']);
          final feature = _str(n['feature']);
          if (feature.isNotEmpty && !featureId.hasMatch(feature))
            throw MapError('node feature must be a feature id like track-cache, got ${jsonEncode(feature)}');
          return <String, Object?>{
            'name': name,
            'status': n['status'],
            'edited': _str(n['edited']),
            'role': _str(n['role']),
            ..._place(n['path'], n['line']),
            if (side.isNotEmpty) 'side': side,
            if (feature.isNotEmpty) 'feature': feature,
          };
        }(),
    ];
    if (nodes.isEmpty) throw MapError('a graph needs at least one node');
    final edges = [
      for (final e in _list(g['edges']))
        () {
          for (final end in [e['from'], e['to']]) {
            if (!names.contains(_str(end))) throw MapError('edge end ${jsonEncode(end)} is not a node of the graph');
          }
          _oneOf('edge kind', e['kind'], edgeKinds);
          return <String, Object?>{'from': _str(e['from']), 'to': _str(e['to']), 'kind': e['kind'], 'label': _str(e['label'])};
        }(),
    ];
    return {'caption': _str(g['caption']), 'nodes': nodes, 'edges': edges};
  }

  /// Writes one feature, replacing the file of the same id. A link to a
  /// feature the map does not have yet is a warning, not a refusal: in a pass
  /// the other feature may be drawn later, and [readMap] lists what is broken.
  Future<({MapFeature feature, List<String> warnings})> writeFeature(Json input) async {
    final id = input['id'];
    if (id is! String || !featureId.hasMatch(id) || id.length > 64)
      throw MapError('feature id must be a lowercase slug like track-cache, got ${jsonEncode(id)}');
    final title = _str(input['title']);
    if (title.isEmpty) throw MapError('every feature needs a title');
    // Spelled the way git diff names files, `./src/` as `src`, or the stale check never matches it.
    final paths = {
      for (final raw in (input['paths'] as List?) ?? const [])
        if (_str(raw).isNotEmpty) p.posix.normalize(_str(raw)).replaceAll(RegExp(r'/+$'), ''),
    }.toList();
    if (paths.isEmpty) throw MapError('a feature needs at least one path');
    if (paths.contains('.')) throw MapError('a feature names its folders or files, not the whole repository');
    for (final path in paths) {
      if (!_inRepo(path)) throw MapError('Path not in the repository: $path');
    }
    if (input['sequence'] != null && input['sequences'] != null) throw MapError('pass sequences, or the older sequence, not both');

    final graph = _graph(input['graph']);
    final single = input['sequence'];
    final seqInput = input['sequences'] != null
        ? _list(input['sequences'])
        : single is Map && _str(single['mermaid']).isNotEmpty
        ? [single.cast<String, Object?>()]
        : <Json>[];
    if (seqInput.length > _maxViews) throw MapError('at most $_maxViews sequences: a feature with more flows is two features');
    final sequences = [
      for (final q in seqInput)
        () {
          final mermaid = q['mermaid'];
          if (mermaid is! String || mermaid.trim().isEmpty) throw MapError('every sequence needs its mermaid source');
          final t = _str(q['title']);
          if (t.isEmpty && seqInput.length > 1) throw MapError('with several sequences, each needs a title');
          checkSequence(mermaid);
          return <String, Object?>{'title': t, 'mermaid': mermaid, 'caption': _str(q['caption']), 'steps': _steps(q['steps'])};
        }(),
    ];

    final stateInput = _list(input['states']);
    if (stateInput.length > _maxViews) throw MapError('at most $_maxViews state diagrams');
    final states = [
      for (final st in stateInput)
        () {
          final t = _str(st['title']);
          if (t.isEmpty) throw MapError('every state diagram needs a title');
          final mermaid = st['mermaid'];
          if (mermaid is! String || !_stateDiagram.hasMatch(mermaid)) throw MapError('state ${jsonEncode(t)} must be mermaid stateDiagram-v2 source');
          final transitions = [
            for (final tr in _list(st['transitions']))
              () {
                final tt = _str(tr['title']);
                if (tt.isEmpty) throw MapError('every transition needs a title');
                return <String, Object?>{'title': tt, 'detail': _str(tr['detail']), ..._place(tr['path'], tr['line'])};
              }(),
          ];
          return <String, Object?>{'title': t, 'caption': _str(st['caption']), 'mermaid': mermaid, 'transitions': transitions};
        }(),
    ];

    final links = [
      for (final l in _list(input['links']))
        () {
          final f = _str(l['feature']);
          if (f.isEmpty || !featureId.hasMatch(f)) throw MapError('link feature must be a feature id like track-cache, got ${jsonEncode(l['feature'])}');
          if (f == id) throw MapError('a feature does not link to itself');
          _oneOf('link kind', l['kind'], linkKinds);
          return <String, Object?>{'feature': f, 'kind': l['kind'], 'detail': _str(l['detail']), ..._place(l['path'], l['line'])};
        }(),
    ];

    final notes = [
      for (final n in _list(input['notes']))
        () {
          _oneOf('note kind', n['kind'], noteKinds);
          final text = _str(n['text']);
          if (text.isEmpty) throw MapError('every note needs a text');
          return <String, Object?>{'kind': n['kind'], 'text': text, ..._place(n['path'], n['line'])};
        }(),
    ];

    final data = [
      for (final d in _list(input['data']))
        () {
          final type = _str(d['type']);
          if (type.isEmpty || !featureId.hasMatch(type)) throw MapError('data type must be a data type id like clock-state, got ${jsonEncode(d['type'])}');
          _oneOf('data use', d['use'], dataUses);
          return <String, Object?>{'type': type, 'use': d['use'], 'detail': _str(d['detail'])};
        }(),
    ];

    final ids = readFeatures().map((f) => f.id).toSet();
    final named = {for (final l in links) l['feature']! as String, for (final n in _list(graph?['nodes'])) ?n['feature'] as String?};
    final types = readDataTypes().map((d) => d.id).toSet();
    final warnings = [
      for (final f in named)
        if (!ids.contains(f)) 'No feature ${jsonEncode(f)} in the map yet: write it in this pass, or fix the link.',
      for (final t in {for (final d in data) d['type']! as String})
        if (!types.contains(t)) 'No data type ${jsonEncode(t)} in the map yet: write it with set_map_data, or fix the id.',
    ];

    final json = <String, Object?>{
      'id': id,
      'title': title,
      'summary': _str(input['summary']),
      'graph': graph,
      'sequences': sequences,
      'states': states,
      'links': links,
      'notes': notes,
      'data': data,
      'paths': paths,
      'commit': await _head(),
      'updatedAt': _now(),
    };
    _ensureDir();
    _write(_featureFile(id), json);
    return (feature: MapFeature.fromJson(json), warnings: warnings);
  }

  /// Writes one data type. Every place it is declared must exist: the
  /// definitions are how the type goes stale.
  Future<MapDataType> writeDataType(String id, Json input) async {
    if (!featureId.hasMatch(id) || id.length > 64) throw MapError('data type id must be a lowercase slug like clock-state, got ${jsonEncode(id)}');
    final name = _str(input['name']);
    if (name.isEmpty) throw MapError('a data type needs the name the code gives it');
    _oneOf('data boundary', input['boundary'], dataBoundaries);
    final definitions = [
      for (final d in _list(input['definitions']))
        () {
          final path = _str(d['path']);
          if (path.isEmpty) throw MapError('every definition needs a path');
          return _place(p.posix.normalize(path), d['line']);
        }(),
    ];
    if (definitions.isEmpty) throw MapError('a data type needs at least one definition: the file that declares it');
    final names = <String>{};
    final fields = [
      for (final f in _list(input['fields']))
        () {
          final n = _str(f['name']);
          if (n.isEmpty) throw MapError('every field needs a name');
          if (!names.add(n)) throw MapError('field ${jsonEncode(n)} appears twice');
          final type = _str(f['type']);
          if (type.isEmpty) throw MapError('field ${jsonEncode(n)} needs a type');
          return <String, Object?>{'name': n, 'type': type, 'note': _str(f['note']), 'optional': f['optional'] == true, 'since': _str(f['since'])};
        }(),
    ];
    final json = <String, Object?>{
      'id': id,
      'name': name,
      'boundary': input['boundary'],
      'summary': _str(input['summary']),
      'fields': fields,
      'since': _str(input['since']),
      'until': _str(input['until']),
      'definitions': definitions,
      'commit': await _head(),
      'updatedAt': _now(),
    };
    _ensureDir();
    _write(_dataFile(id), json);
    return MapDataType.fromJson(json);
  }

  void removeFeature(String id) {
    readFeature(id);
    _featureFile(id).deleteSync();
  }

  void removeDataType(String id) {
    readDataType(id);
    _dataFile(id).deleteSync();
  }

  /// Marks a stale feature as still true at head without redrawing it: the
  /// change under its paths moved nothing the views show. Refused when one of
  /// its paths is gone, since that always needs a rewrite.
  Future<MapFeature> confirmFeature(String id) async {
    final feature = readFeature(id);
    final gone = feature.paths.where((path) => !_inRepo(path)).toList();
    if (gone.isNotEmpty) throw MapError('Paths gone from the repository: ${gone.join(', ')}. Rewrite the feature with set_map_feature.');
    final confirmed = feature.copyWith(commit: await _head(), updatedAt: _now());
    _write(_featureFile(id), confirmed.toJson());
    return confirmed;
  }

  /// Records that the map now describes head: the end of a complete pass.
  Future<FeatureMap> stamp() async {
    // A stamp says the pass is complete. Links to features nobody drew say it is not.
    final broken = (await readMap()).brokenLinks;
    if (broken.isNotEmpty) {
      final list = broken.map((l) => '${l.from} -> ${l.to}').join(', ');
      throw MapError('Not stamped: links to features the map does not have ($list). Draw them or fix the ids, then stamp again.');
    }
    _ensureDir();
    _write(_index, {'commit': await _head(), 'updatedAt': _now()});
    // The pass is complete: nothing left to resume.
    if (_plan.existsSync()) _plan.deleteSync();
    return readMap();
  }

  static bool _claims(String path, String file) => file == path || file.startsWith('$path/');

  /// The map with what changed since it was drawn. Null fields of
  /// [FeatureMap] mean there is no complete pass yet.
  Future<FeatureMap> readMap() async {
    String? commit;
    String? updatedAt;
    try {
      final raw = jsonDecode(_index.readAsStringSync()) as Json;
      commit = raw['commit'] as String?;
      updatedAt = raw['updatedAt'] as String?;
    } catch (_) {}
    final features = readFeatures();
    final head = await _head();
    // Files changed from a commit to head, null when the commit is gone. Most
    // features share one commit, so it is asked once.
    final since = <String, Future<List<String>?>>{};
    Future<List<String>?> changedSince(String from) {
      if (from == head) return Future.value(const []);
      return since[from] ??= _git(['diff', '--name-only', '--no-renames', from, head, '--'])
          .then<List<String>?>((out) => out.split('\n').where((l) => l.isNotEmpty).toList(), onError: (_) => null);
    }

    final fromStamp = commit == null ? const <String>[] : await changedSince(commit);
    final commitMissing = fromStamp == null;
    final changedFiles = fromStamp ?? const <String>[];
    // A feature is stale from the commit it was drawn at, not from the stamp:
    // a pass resumed across commits stamps features drawn before them.
    final staleFeatures = <String>[];
    for (final f in features) {
      final own = await changedSince(f.commit);
      if (commitMissing || own == null || own.any((file) => f.paths.any((path) => _claims(path, file)))) staleFeatures.add(f.id);
    }
    final uncoveredFiles = changedFiles.where((file) => !features.any((f) => f.paths.any((path) => _claims(path, file)))).toList();
    final ids = features.map((f) => f.id).toSet();
    final dataTypes = readDataTypes();
    final typeIds = dataTypes.map((d) => d.id).toSet();
    // A missing data type is named `data/<id>`, so it never reads as a missing feature of the same id.
    final brokenLinks = [
      for (final f in features) ...[
        for (final to in {...f.links.map((l) => l.feature), ...?f.graph?.nodes.map((n) => n.feature).whereType<String>()})
          if (!ids.contains(to)) BrokenLink(from: f.id, to: to),
        for (final t in {...f.data.map((d) => d.type)})
          if (!typeIds.contains(t)) BrokenLink(from: f.id, to: 'data/$t'),
      ],
    ];
    final staleData = <String>[];
    for (final d in dataTypes) {
      final own = await changedSince(d.commit);
      if (commitMissing || own == null || own.any((file) => d.definitions.any((def) => def.path == file))) staleData.add(d.id);
    }
    var plan = const <String>[], planLeft = const <String>[];
    try {
      final raw = jsonDecode(_plan.readAsStringSync()) as Json;
      plan = [for (final f in (raw['features'] as List?) ?? const []) '$f'];
      final at = '${raw['updatedAt'] ?? ''}';
      final byId = {for (final f in features) f.id: f};
      // Drawn or confirmed after the plan was written: done in this pass.
      planLeft = [
        for (final id in plan)
          if ((byId[id]?.updatedAt ?? '').compareTo(at) < 0) id,
      ];
    } catch (_) {}

    /// A file under [watched] changed since [since].
    Future<bool> stale(String since, Iterable<String> watched) async {
      final own = await changedSince(since);
      return commitMissing || own == null || own.any((file) => watched.any((path) => _claims(path, file)));
    }

    final architecture = readArchitecture();
    final staleArchitecture =
        architecture != null && await stale(architecture.commit, [for (final l in architecture.layers) ...l.paths, ...architecture.sources]);
    final ui = readUi();
    final staleUi = ui != null && await stale(ui.commit, [...ui.paths, ...ui.sources]);
    return FeatureMap(
      root: root,
      architecture: architecture,
      staleArchitecture: staleArchitecture,
      ui: ui,
      staleUi: staleUi,
      plan: plan,
      planLeft: planLeft,
      commit: commit,
      updatedAt: updatedAt,
      head: head,
      commitMissing: commitMissing,
      features: features,
      changedFiles: changedFiles,
      staleFeatures: staleFeatures,
      uncoveredFiles: uncoveredFiles,
      brokenLinks: brokenLinks,
      dataTypes: dataTypes,
      staleData: staleData,
    );
  }
}
