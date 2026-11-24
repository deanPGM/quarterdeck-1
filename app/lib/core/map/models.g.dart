// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GraphNode _$GraphNodeFromJson(Map<String, dynamic> json) => _GraphNode(
  name: json['name'] as String,
  status: json['status'] as String? ?? 'context',
  edited: json['edited'] as String? ?? '',
  role: json['role'] as String? ?? '',
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
  side: json['side'] as String?,
  feature: json['feature'] as String?,
);

Map<String, dynamic> _$GraphNodeToJson(_GraphNode instance) => <String, dynamic>{
  'name': instance.name,
  'status': instance.status,
  'edited': instance.edited,
  'role': instance.role,
  'path': ?instance.path,
  'line': ?instance.line,
  'side': ?instance.side,
  'feature': ?instance.feature,
};

_GraphEdge _$GraphEdgeFromJson(Map<String, dynamic> json) =>
    _GraphEdge(from: json['from'] as String, to: json['to'] as String, kind: json['kind'] as String, label: json['label'] as String? ?? '');

Map<String, dynamic> _$GraphEdgeToJson(_GraphEdge instance) => <String, dynamic>{
  'from': instance.from,
  'to': instance.to,
  'kind': instance.kind,
  'label': instance.label,
};

_FeatureGraph _$FeatureGraphFromJson(Map<String, dynamic> json) => _FeatureGraph(
  caption: json['caption'] as String? ?? '',
  nodes: (json['nodes'] as List<dynamic>?)?.map((e) => GraphNode.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  edges: (json['edges'] as List<dynamic>?)?.map((e) => GraphEdge.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$FeatureGraphToJson(_FeatureGraph instance) => <String, dynamic>{
  'caption': instance.caption,
  'nodes': instance.nodes.map((e) => e.toJson()).toList(),
  'edges': instance.edges.map((e) => e.toJson()).toList(),
};

_DiagramStep _$DiagramStepFromJson(Map<String, dynamic> json) => _DiagramStep(
  title: json['title'] as String,
  detail: json['detail'] as String? ?? '',
  why: json['why'] as String? ?? '',
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
  mark: json['mark'] as String?,
  severity: json['severity'] as String?,
);

Map<String, dynamic> _$DiagramStepToJson(_DiagramStep instance) => <String, dynamic>{
  'title': instance.title,
  'detail': instance.detail,
  'why': instance.why,
  'path': ?instance.path,
  'line': ?instance.line,
  'mark': ?instance.mark,
  'severity': ?instance.severity,
};

_MapSequence _$MapSequenceFromJson(Map<String, dynamic> json) => _MapSequence(
  title: json['title'] as String? ?? '',
  mermaid: json['mermaid'] as String,
  caption: json['caption'] as String? ?? '',
  steps: (json['steps'] as List<dynamic>?)?.map((e) => DiagramStep.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$MapSequenceToJson(_MapSequence instance) => <String, dynamic>{
  'title': instance.title,
  'mermaid': instance.mermaid,
  'caption': instance.caption,
  'steps': instance.steps.map((e) => e.toJson()).toList(),
};

_MapTransition _$MapTransitionFromJson(Map<String, dynamic> json) => _MapTransition(
  title: json['title'] as String,
  detail: json['detail'] as String? ?? '',
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
);

Map<String, dynamic> _$MapTransitionToJson(_MapTransition instance) => <String, dynamic>{
  'title': instance.title,
  'detail': instance.detail,
  'path': ?instance.path,
  'line': ?instance.line,
};

_MapState _$MapStateFromJson(Map<String, dynamic> json) => _MapState(
  title: json['title'] as String,
  caption: json['caption'] as String? ?? '',
  mermaid: json['mermaid'] as String,
  transitions: (json['transitions'] as List<dynamic>?)?.map((e) => MapTransition.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$MapStateToJson(_MapState instance) => <String, dynamic>{
  'title': instance.title,
  'caption': instance.caption,
  'mermaid': instance.mermaid,
  'transitions': instance.transitions.map((e) => e.toJson()).toList(),
};

_MapLink _$MapLinkFromJson(Map<String, dynamic> json) => _MapLink(
  feature: json['feature'] as String,
  kind: json['kind'] as String,
  detail: json['detail'] as String? ?? '',
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
);

Map<String, dynamic> _$MapLinkToJson(_MapLink instance) => <String, dynamic>{
  'feature': instance.feature,
  'kind': instance.kind,
  'detail': instance.detail,
  'path': ?instance.path,
  'line': ?instance.line,
};

_MapNote _$MapNoteFromJson(Map<String, dynamic> json) =>
    _MapNote(kind: json['kind'] as String, text: json['text'] as String, path: json['path'] as String?, line: (json['line'] as num?)?.toInt());

Map<String, dynamic> _$MapNoteToJson(_MapNote instance) => <String, dynamic>{
  'kind': instance.kind,
  'text': instance.text,
  'path': ?instance.path,
  'line': ?instance.line,
};

_MapDataUse _$MapDataUseFromJson(Map<String, dynamic> json) =>
    _MapDataUse(type: json['type'] as String, use: json['use'] as String, detail: json['detail'] as String? ?? '');

Map<String, dynamic> _$MapDataUseToJson(_MapDataUse instance) => <String, dynamic>{'type': instance.type, 'use': instance.use, 'detail': instance.detail};

_MapFeature _$MapFeatureFromJson(Map<String, dynamic> json) => _MapFeature(
  id: json['id'] as String,
  title: json['title'] as String,
  summary: json['summary'] as String? ?? '',
  graph: json['graph'] == null ? null : FeatureGraph.fromJson(json['graph'] as Map<String, dynamic>),
  paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  commit: json['commit'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
  sequences: (_readSequences(json, 'sequences') as List<dynamic>?)?.map((e) => MapSequence.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  states: (json['states'] as List<dynamic>?)?.map((e) => MapState.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  links: (json['links'] as List<dynamic>?)?.map((e) => MapLink.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  notes: (json['notes'] as List<dynamic>?)?.map((e) => MapNote.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  data: (json['data'] as List<dynamic>?)?.map((e) => MapDataUse.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$MapFeatureToJson(_MapFeature instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'summary': instance.summary,
  'graph': ?instance.graph?.toJson(),
  'paths': instance.paths,
  'commit': instance.commit,
  'updatedAt': instance.updatedAt,
  'sequences': instance.sequences.map((e) => e.toJson()).toList(),
  'states': instance.states.map((e) => e.toJson()).toList(),
  'links': instance.links.map((e) => e.toJson()).toList(),
  'notes': instance.notes.map((e) => e.toJson()).toList(),
  'data': instance.data.map((e) => e.toJson()).toList(),
};

_MapDataField _$MapDataFieldFromJson(Map<String, dynamic> json) => _MapDataField(
  name: json['name'] as String,
  type: json['type'] as String,
  note: json['note'] as String? ?? '',
  optional: json['optional'] as bool? ?? false,
  since: json['since'] as String? ?? '',
);

Map<String, dynamic> _$MapDataFieldToJson(_MapDataField instance) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'note': instance.note,
  'optional': instance.optional,
  'since': instance.since,
};

_MapDefinition _$MapDefinitionFromJson(Map<String, dynamic> json) => _MapDefinition(path: json['path'] as String, line: (json['line'] as num?)?.toInt());

Map<String, dynamic> _$MapDefinitionToJson(_MapDefinition instance) => <String, dynamic>{'path': instance.path, 'line': ?instance.line};

_MapDataType _$MapDataTypeFromJson(Map<String, dynamic> json) => _MapDataType(
  id: json['id'] as String,
  name: json['name'] as String,
  boundary: json['boundary'] as String,
  summary: json['summary'] as String? ?? '',
  fields: (json['fields'] as List<dynamic>?)?.map((e) => MapDataField.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  since: json['since'] as String? ?? '',
  until: json['until'] as String? ?? '',
  definitions: (json['definitions'] as List<dynamic>?)?.map((e) => MapDefinition.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  commit: json['commit'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
);

Map<String, dynamic> _$MapDataTypeToJson(_MapDataType instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'boundary': instance.boundary,
  'summary': instance.summary,
  'fields': instance.fields.map((e) => e.toJson()).toList(),
  'since': instance.since,
  'until': instance.until,
  'definitions': instance.definitions.map((e) => e.toJson()).toList(),
  'commit': instance.commit,
  'updatedAt': instance.updatedAt,
};

_ArchLayer _$ArchLayerFromJson(Map<String, dynamic> json) => _ArchLayer(
  id: json['id'] as String,
  name: json['name'] as String,
  role: json['role'] as String? ?? '',
  naming: (json['naming'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  examples: (json['examples'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$ArchLayerToJson(_ArchLayer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': instance.role,
  'naming': instance.naming,
  'paths': instance.paths,
  'examples': instance.examples,
};

_ArchFlow _$ArchFlowFromJson(Map<String, dynamic> json) =>
    _ArchFlow(from: json['from'] as String, to: json['to'] as String, label: json['label'] as String? ?? '');

Map<String, dynamic> _$ArchFlowToJson(_ArchFlow instance) => <String, dynamic>{'from': instance.from, 'to': instance.to, 'label': instance.label};

_ArchViolation _$ArchViolationFromJson(Map<String, dynamic> json) => _ArchViolation(
  from: json['from'] as String,
  fromLayer: json['fromLayer'] as String,
  to: (json['to'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  toLayer: json['toLayer'] as String,
  severity: json['severity'] as String,
  why: json['why'] as String,
  fix: json['fix'] as String? ?? '',
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
);

Map<String, dynamic> _$ArchViolationToJson(_ArchViolation instance) => <String, dynamic>{
  'from': instance.from,
  'fromLayer': instance.fromLayer,
  'to': instance.to,
  'toLayer': instance.toLayer,
  'severity': instance.severity,
  'why': instance.why,
  'fix': instance.fix,
  'path': ?instance.path,
  'line': ?instance.line,
};

_MapArchitecture _$MapArchitectureFromJson(Map<String, dynamic> json) => _MapArchitecture(
  summary: json['summary'] as String? ?? '',
  layers: (json['layers'] as List<dynamic>?)?.map((e) => ArchLayer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  flows: (json['flows'] as List<dynamic>?)?.map((e) => ArchFlow.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  rules: (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  violations: (json['violations'] as List<dynamic>?)?.map((e) => ArchViolation.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  sources: (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  commit: json['commit'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
);

Map<String, dynamic> _$MapArchitectureToJson(_MapArchitecture instance) => <String, dynamic>{
  'summary': instance.summary,
  'layers': instance.layers.map((e) => e.toJson()).toList(),
  'flows': instance.flows.map((e) => e.toJson()).toList(),
  'rules': instance.rules,
  'violations': instance.violations.map((e) => e.toJson()).toList(),
  'sources': instance.sources,
  'commit': instance.commit,
  'updatedAt': instance.updatedAt,
};

_UiToken _$UiTokenFromJson(Map<String, dynamic> json) => _UiToken(
  kind: json['kind'] as String,
  name: json['name'] as String,
  note: json['note'] as String? ?? '',
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
);

Map<String, dynamic> _$UiTokenToJson(_UiToken instance) => <String, dynamic>{
  'kind': instance.kind,
  'name': instance.name,
  'note': instance.note,
  'path': ?instance.path,
  'line': ?instance.line,
};

_UiComponent _$UiComponentFromJson(Map<String, dynamic> json) =>
    _UiComponent(name: json['name'] as String, role: json['role'] as String? ?? '', path: json['path'] as String?, line: (json['line'] as num?)?.toInt());

Map<String, dynamic> _$UiComponentToJson(_UiComponent instance) => <String, dynamic>{
  'name': instance.name,
  'role': instance.role,
  'path': ?instance.path,
  'line': ?instance.line,
};

_UiScreen _$UiScreenFromJson(Map<String, dynamic> json) => _UiScreen(
  name: json['name'] as String,
  role: json['role'] as String? ?? '',
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
  uses: (json['uses'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$UiScreenToJson(_UiScreen instance) => <String, dynamic>{
  'name': instance.name,
  'role': instance.role,
  'path': ?instance.path,
  'line': ?instance.line,
  'uses': instance.uses,
};

_UiCopy _$UiCopyFromJson(Map<String, dynamic> json) =>
    _UiCopy(name: json['name'] as String, path: json['path'] as String?, line: (json['line'] as num?)?.toInt());

Map<String, dynamic> _$UiCopyToJson(_UiCopy instance) => <String, dynamic>{'name': instance.name, 'path': ?instance.path, 'line': ?instance.line};

_UiDuplicate _$UiDuplicateFromJson(Map<String, dynamic> json) => _UiDuplicate(
  title: json['title'] as String,
  severity: json['severity'] as String,
  why: json['why'] as String,
  use: json['use'] as String? ?? '',
  copies: (json['copies'] as List<dynamic>?)?.map((e) => UiCopy.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$UiDuplicateToJson(_UiDuplicate instance) => <String, dynamic>{
  'title': instance.title,
  'severity': instance.severity,
  'why': instance.why,
  'use': instance.use,
  'copies': instance.copies.map((e) => e.toJson()).toList(),
};

_UiBreak _$UiBreakFromJson(Map<String, dynamic> json) => _UiBreak(
  rule: json['rule'] as String,
  severity: json['severity'] as String,
  why: json['why'] as String,
  fix: json['fix'] as String? ?? '',
  where: json['where'] as String? ?? '',
  count: (json['count'] as num?)?.toInt() ?? 1,
  path: json['path'] as String?,
  line: (json['line'] as num?)?.toInt(),
);

Map<String, dynamic> _$UiBreakToJson(_UiBreak instance) => <String, dynamic>{
  'rule': instance.rule,
  'severity': instance.severity,
  'why': instance.why,
  'fix': instance.fix,
  'where': instance.where,
  'count': instance.count,
  'path': ?instance.path,
  'line': ?instance.line,
};

_MapUi _$MapUiFromJson(Map<String, dynamic> json) => _MapUi(
  summary: json['summary'] as String? ?? '',
  rules: (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  sources: (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  tokens: (json['tokens'] as List<dynamic>?)?.map((e) => UiToken.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  components: (json['components'] as List<dynamic>?)?.map((e) => UiComponent.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  screens: (json['screens'] as List<dynamic>?)?.map((e) => UiScreen.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  duplicates: (json['duplicates'] as List<dynamic>?)?.map((e) => UiDuplicate.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  breaks: (json['breaks'] as List<dynamic>?)?.map((e) => UiBreak.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  commit: json['commit'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
);

Map<String, dynamic> _$MapUiToJson(_MapUi instance) => <String, dynamic>{
  'summary': instance.summary,
  'rules': instance.rules,
  'sources': instance.sources,
  'paths': instance.paths,
  'tokens': instance.tokens.map((e) => e.toJson()).toList(),
  'components': instance.components.map((e) => e.toJson()).toList(),
  'screens': instance.screens.map((e) => e.toJson()).toList(),
  'duplicates': instance.duplicates.map((e) => e.toJson()).toList(),
  'breaks': instance.breaks.map((e) => e.toJson()).toList(),
  'commit': instance.commit,
  'updatedAt': instance.updatedAt,
};

_BrokenLink _$BrokenLinkFromJson(Map<String, dynamic> json) => _BrokenLink(from: json['from'] as String, to: json['to'] as String);

Map<String, dynamic> _$BrokenLinkToJson(_BrokenLink instance) => <String, dynamic>{'from': instance.from, 'to': instance.to};

_FeatureMap _$FeatureMapFromJson(Map<String, dynamic> json) => _FeatureMap(
  root: json['root'] as String,
  commit: json['commit'] as String?,
  updatedAt: json['updatedAt'] as String?,
  head: json['head'] as String,
  commitMissing: json['commitMissing'] as bool? ?? false,
  features: (json['features'] as List<dynamic>?)?.map((e) => MapFeature.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  changedFiles: (json['changedFiles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  staleFeatures: (json['staleFeatures'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  uncoveredFiles: (json['uncoveredFiles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  brokenLinks: (json['brokenLinks'] as List<dynamic>?)?.map((e) => BrokenLink.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  dataTypes: (json['dataTypes'] as List<dynamic>?)?.map((e) => MapDataType.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  staleData: (json['staleData'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  plan: (json['plan'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  planLeft: (json['planLeft'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  architecture: json['architecture'] == null ? null : MapArchitecture.fromJson(json['architecture'] as Map<String, dynamic>),
  staleArchitecture: json['staleArchitecture'] as bool? ?? false,
  ui: json['ui'] == null ? null : MapUi.fromJson(json['ui'] as Map<String, dynamic>),
  staleUi: json['staleUi'] as bool? ?? false,
);

Map<String, dynamic> _$FeatureMapToJson(_FeatureMap instance) => <String, dynamic>{
  'root': instance.root,
  'commit': ?instance.commit,
  'updatedAt': ?instance.updatedAt,
  'head': instance.head,
  'commitMissing': instance.commitMissing,
  'features': instance.features.map((e) => e.toJson()).toList(),
  'changedFiles': instance.changedFiles,
  'staleFeatures': instance.staleFeatures,
  'uncoveredFiles': instance.uncoveredFiles,
  'brokenLinks': instance.brokenLinks.map((e) => e.toJson()).toList(),
  'dataTypes': instance.dataTypes.map((e) => e.toJson()).toList(),
  'staleData': instance.staleData,
  'plan': instance.plan,
  'planLeft': instance.planLeft,
  'architecture': ?instance.architecture?.toJson(),
  'staleArchitecture': instance.staleArchitecture,
  'ui': ?instance.ui?.toJson(),
  'staleUi': instance.staleUi,
};
