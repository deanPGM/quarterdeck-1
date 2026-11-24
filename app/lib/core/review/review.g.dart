// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Anchor _$AnchorFromJson(Map<String, dynamic> json) => _Anchor(
  path: json['path'] as String,
  side: json['side'] as String? ?? 'new',
  hunkRef: json['hunk_ref'] as String,
  line: (json['line'] as num).toInt(),
  endLine: (json['endLine'] as num).toInt(),
  contentHash: json['content_hash'] as String,
);

Map<String, dynamic> _$AnchorToJson(_Anchor instance) => <String, dynamic>{
  'path': instance.path,
  'side': instance.side,
  'hunk_ref': instance.hunkRef,
  'line': instance.line,
  'endLine': instance.endLine,
  'content_hash': instance.contentHash,
};

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  author: json['author'] as String,
  body: json['body'] as String,
  suggestion: json['suggestion'] as String?,
  remoteId: json['remoteId'] as String?,
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author,
  'body': instance.body,
  'suggestion': ?instance.suggestion,
  'remoteId': ?instance.remoteId,
  'createdAt': instance.createdAt,
};

_Thread _$ThreadFromJson(Map<String, dynamic> json) => _Thread(
  id: json['id'] as String,
  anchor: json['anchor'] == null ? null : Anchor.fromJson(json['anchor'] as Map<String, dynamic>),
  severity: json['severity'] as String,
  state: json['state'] as String,
  authorType: json['authorType'] as String,
  remoteId: json['remoteId'] as String?,
  roundId: json['roundId'] as String?,
  createdAt: json['createdAt'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
  messages: (json['messages'] as List<dynamic>?)?.map((e) => Message.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  answer: json['answer'] == null ? null : Message.fromJson(json['answer'] as Map<String, dynamic>),
  waiting: json['waiting'] as bool? ?? false,
  decision: json['decision'] as String?,
  fix: json['fix'] as String?,
  fixRevert: json['fixRevert'] as String?,
);

Map<String, dynamic> _$ThreadToJson(_Thread instance) => <String, dynamic>{
  'id': instance.id,
  'anchor': ?instance.anchor?.toJson(),
  'severity': instance.severity,
  'state': instance.state,
  'authorType': instance.authorType,
  'remoteId': ?instance.remoteId,
  'roundId': ?instance.roundId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'messages': instance.messages.map((e) => e.toJson()).toList(),
  'answer': ?instance.answer?.toJson(),
  'waiting': instance.waiting,
  'decision': ?instance.decision,
  'fix': ?instance.fix,
  'fixRevert': ?instance.fixRevert,
};

_Round _$RoundFromJson(Map<String, dynamic> json) => _Round(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  baseSha: json['baseSha'] as String,
  headSha: json['headSha'] as String,
  verdict: json['verdict'] as String?,
  publishedAt: json['publishedAt'] as String?,
  remoteNoteId: json['remoteNoteId'] as String?,
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$RoundToJson(_Round instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'baseSha': instance.baseSha,
  'headSha': instance.headSha,
  'verdict': ?instance.verdict,
  'publishedAt': ?instance.publishedAt,
  'remoteNoteId': ?instance.remoteNoteId,
  'createdAt': instance.createdAt,
};

_DiffRefs _$DiffRefsFromJson(Map<String, dynamic> json) =>
    _DiffRefs(baseSha: json['baseSha'] as String? ?? '', startSha: json['startSha'] as String? ?? '', headSha: json['headSha'] as String? ?? '');

Map<String, dynamic> _$DiffRefsToJson(_DiffRefs instance) => <String, dynamic>{
  'baseSha': instance.baseSha,
  'startSha': instance.startSha,
  'headSha': instance.headSha,
};

_MrSource _$MrSourceFromJson(Map<String, dynamic> json) => _MrSource(
  provider: json['provider'] as String,
  url: json['url'] as String,
  iid: (json['iid'] as num).toInt(),
  projectPath: json['projectPath'] as String,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  author: json['author'] as String? ?? '',
  sourceBranch: json['sourceBranch'] as String? ?? '',
  targetBranch: json['targetBranch'] as String? ?? '',
  diffRefs: json['diffRefs'] == null ? const DiffRefs() : DiffRefs.fromJson(json['diffRefs'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MrSourceToJson(_MrSource instance) => <String, dynamic>{
  'provider': instance.provider,
  'url': instance.url,
  'iid': instance.iid,
  'projectPath': instance.projectPath,
  'title': instance.title,
  'description': instance.description,
  'author': instance.author,
  'sourceBranch': instance.sourceBranch,
  'targetBranch': instance.targetBranch,
  'diffRefs': instance.diffRefs.toJson(),
};

_FileNote _$FileNoteFromJson(Map<String, dynamic> json) => _FileNote(
  path: json['path'] as String,
  summary: json['summary'] as String,
  extraTags: (json['extraTags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$FileNoteToJson(_FileNote instance) => <String, dynamic>{
  'path': instance.path,
  'summary': instance.summary,
  'extraTags': instance.extraTags,
};

_HunkNote _$HunkNoteFromJson(Map<String, dynamic> json) =>
    _HunkNote(path: json['path'] as String, hunkRef: json['hunkRef'] as String, summary: json['summary'] as String);

Map<String, dynamic> _$HunkNoteToJson(_HunkNote instance) => <String, dynamic>{'path': instance.path, 'hunkRef': instance.hunkRef, 'summary': instance.summary};

_GroupItem _$GroupItemFromJson(Map<String, dynamic> json) => _GroupItem(path: json['path'] as String, hunkRef: json['hunkRef'] as String?);

Map<String, dynamic> _$GroupItemToJson(_GroupItem instance) => <String, dynamic>{'path': instance.path, 'hunkRef': ?instance.hunkRef};

_ReviewGroup _$ReviewGroupFromJson(Map<String, dynamic> json) => _ReviewGroup(
  title: json['title'] as String,
  overview: json['overview'] as String? ?? '',
  items: (json['items'] as List<dynamic>?)?.map((e) => GroupItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$ReviewGroupToJson(_ReviewGroup instance) => <String, dynamic>{
  'title': instance.title,
  'overview': instance.overview,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

_ReviewFeature _$ReviewFeatureFromJson(Map<String, dynamic> json) => _ReviewFeature(
  title: json['title'] as String,
  summary: json['summary'] as String? ?? '',
  graph: json['graph'] == null ? null : FeatureGraph.fromJson(json['graph'] as Map<String, dynamic>),
  sequence: json['sequence'] == null ? null : MapSequence.fromJson(json['sequence'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReviewFeatureToJson(_ReviewFeature instance) => <String, dynamic>{
  'title': instance.title,
  'summary': instance.summary,
  'graph': ?instance.graph?.toJson(),
  'sequence': ?instance.sequence?.toJson(),
};

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) => _ChecklistItem(
  text: json['text'] as String,
  evidence: json['evidence'] as String? ?? '',
  paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  state: json['state'] as String,
  headSha: json['headSha'] as String? ?? '',
);

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) => <String, dynamic>{
  'text': instance.text,
  'evidence': instance.evidence,
  'paths': instance.paths,
  'state': instance.state,
  'headSha': instance.headSha,
};

_StoredTicket _$StoredTicketFromJson(Map<String, dynamic> json) =>
    _StoredTicket(ref: json['ref'] as String, url: json['url'] as String?, title: json['title'] as String?, body: json['body'] as String? ?? '');

Map<String, dynamic> _$StoredTicketToJson(_StoredTicket instance) => <String, dynamic>{
  'ref': instance.ref,
  'url': ?instance.url,
  'title': ?instance.title,
  'body': instance.body,
};

_TicketCheckItem _$TicketCheckItemFromJson(Map<String, dynamic> json) => _TicketCheckItem(
  text: json['text'] as String,
  state: json['state'] as String,
  paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$TicketCheckItemToJson(_TicketCheckItem instance) => <String, dynamic>{
  'text': instance.text,
  'state': instance.state,
  'paths': instance.paths,
};

_TicketCheck _$TicketCheckFromJson(Map<String, dynamic> json) => _TicketCheck(
  ref: json['ref'] as String,
  headSha: json['headSha'] as String? ?? '',
  verdict: json['verdict'] as String,
  summary: json['summary'] as String? ?? '',
  items: (json['items'] as List<dynamic>?)?.map((e) => TicketCheckItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$TicketCheckToJson(_TicketCheck instance) => <String, dynamic>{
  'ref': instance.ref,
  'headSha': instance.headSha,
  'verdict': instance.verdict,
  'summary': instance.summary,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  project: json['project'] as String,
  mr: json['mr'] == null ? null : MrSource.fromJson(json['mr'] as Map<String, dynamic>),
  baseRef: json['baseRef'] as String,
  headRef: json['headRef'] as String,
  local: json['local'] as bool? ?? false,
  folder: json['folder'] as String?,
  own: json['own'] as bool? ?? false,
  createdAt: json['createdAt'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
  fileNotes: (json['fileNotes'] as List<dynamic>?)?.map((e) => FileNote.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  hunkNotes: (json['hunkNotes'] as List<dynamic>?)?.map((e) => HunkNote.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  groups: (json['groups'] as List<dynamic>?)?.map((e) => ReviewGroup.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  features: (json['features'] as List<dynamic>?)?.map((e) => ReviewFeature.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  checklist: (json['checklist'] as List<dynamic>?)?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  tickets: (json['tickets'] as List<dynamic>?)?.map((e) => StoredTicket.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  ticketChecks: (json['ticketChecks'] as List<dynamic>?)?.map((e) => TicketCheck.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  viewed: (json['viewed'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)) ?? const {},
  hiddenTags: (json['hiddenTags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  threads: (json['threads'] as List<dynamic>?)?.map((e) => Thread.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  rounds: (json['rounds'] as List<dynamic>?)?.map((e) => Round.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  sessionId: json['sessionId'] as String?,
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'project': instance.project,
  'mr': ?instance.mr?.toJson(),
  'baseRef': instance.baseRef,
  'headRef': instance.headRef,
  'local': instance.local,
  'folder': ?instance.folder,
  'own': instance.own,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'fileNotes': instance.fileNotes.map((e) => e.toJson()).toList(),
  'hunkNotes': instance.hunkNotes.map((e) => e.toJson()).toList(),
  'groups': instance.groups.map((e) => e.toJson()).toList(),
  'features': instance.features.map((e) => e.toJson()).toList(),
  'checklist': instance.checklist.map((e) => e.toJson()).toList(),
  'tickets': instance.tickets.map((e) => e.toJson()).toList(),
  'ticketChecks': instance.ticketChecks.map((e) => e.toJson()).toList(),
  'viewed': instance.viewed,
  'hiddenTags': ?instance.hiddenTags,
  'threads': instance.threads.map((e) => e.toJson()).toList(),
  'rounds': instance.rounds.map((e) => e.toJson()).toList(),
  'sessionId': ?instance.sessionId,
};
