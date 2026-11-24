// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThreadRecord _$ThreadRecordFromJson(Map<String, dynamic> json) => _ThreadRecord(
  start: json['start'] as String,
  last: json['last'] as String,
  people: (json['people'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$ThreadRecordToJson(_ThreadRecord instance) => <String, dynamic>{
  'start': instance.start,
  'last': instance.last,
  'people': instance.people,
};

_MrRecord _$MrRecordFromJson(Map<String, dynamic> json) => _MrRecord(
  path: json['path'] as String,
  iid: (json['iid'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String,
  author: json['author'] as String,
  role: $enumDecode(_$MrRoleEnumMap, json['role']),
  draft: json['draft'] as bool? ?? false,
  conflicts: json['conflicts'] as bool? ?? false,
  pipeline: json['pipeline'] as String? ?? '',
  approvers: (json['approvers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  approved: json['approved'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  threads: (json['threads'] as List<dynamic>?)?.map((e) => ThreadRecord.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  sha: json['sha'] as String?,
  branch: json['branch'] as String? ?? '',
);

Map<String, dynamic> _$MrRecordToJson(_MrRecord instance) => <String, dynamic>{
  'path': instance.path,
  'iid': instance.iid,
  'title': instance.title,
  'url': instance.url,
  'author': instance.author,
  'role': _$MrRoleEnumMap[instance.role]!,
  'draft': instance.draft,
  'conflicts': instance.conflicts,
  'pipeline': instance.pipeline,
  'approvers': instance.approvers,
  'approved': instance.approved,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'threads': instance.threads.map((e) => e.toJson()).toList(),
  'sha': ?instance.sha,
  'branch': instance.branch,
};

const _$MrRoleEnumMap = {MrRole.mine: 'mine', MrRole.review: 'review'};

_CommentRecord _$CommentRecordFromJson(Map<String, dynamic> json) =>
    _CommentRecord(author: json['author'] as String?, mine: json['mine'] as bool? ?? false, at: DateTime.parse(json['at'] as String));

Map<String, dynamic> _$CommentRecordToJson(_CommentRecord instance) => <String, dynamic>{
  'author': ?instance.author,
  'mine': instance.mine,
  'at': instance.at.toIso8601String(),
};

_IssueRecord _$IssueRecordFromJson(Map<String, dynamic> json) => _IssueRecord(
  key: json['key'] as String,
  summary: json['summary'] as String,
  url: json['url'] as String,
  status: json['status'] as String,
  statusCategory: json['statusCategory'] as String,
  type: json['type'] as String,
  created: json['created'] == null ? null : DateTime.parse(json['created'] as String),
  updated: json['updated'] == null ? null : DateTime.parse(json['updated'] as String),
  lastComment: json['lastComment'] == null ? null : CommentRecord.fromJson(json['lastComment'] as Map<String, dynamic>),
);

Map<String, dynamic> _$IssueRecordToJson(_IssueRecord instance) => <String, dynamic>{
  'key': instance.key,
  'summary': instance.summary,
  'url': instance.url,
  'status': instance.status,
  'statusCategory': instance.statusCategory,
  'type': instance.type,
  'created': ?instance.created?.toIso8601String(),
  'updated': ?instance.updated?.toIso8601String(),
  'lastComment': ?instance.lastComment?.toJson(),
};

_DocLink _$DocLinkFromJson(Map<String, dynamic> json) => _DocLink(url: json['url'] as String, title: json['title'] as String);

Map<String, dynamic> _$DocLinkToJson(_DocLink instance) => <String, dynamic>{'url': instance.url, 'title': instance.title};

_MessageRecord _$MessageRecordFromJson(Map<String, dynamic> json) => _MessageRecord(
  id: json['id'] as String,
  url: json['url'] as String,
  from: json['from'] as String?,
  where: json['where'] as String?,
  at: DateTime.parse(json['at'] as String),
  title: json['title'] as String,
  ask: json['ask'] as bool? ?? false,
  need: json['need'] as String?,
  task: json['task'] as bool? ?? false,
  done: json['done'] as bool? ?? false,
  urgent: json['urgent'] as bool? ?? false,
  waiting: json['waiting'] as bool? ?? false,
  project: json['project'] as String?,
  kind: json['kind'] as String?,
  lasting: json['lasting'] as String?,
  docs: (json['docs'] as List<dynamic>?)?.map((e) => DocLink.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  about: json['about'] as String?,
  team: json['team'] as bool? ?? false,
);

Map<String, dynamic> _$MessageRecordToJson(_MessageRecord instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'from': ?instance.from,
  'where': ?instance.where,
  'at': instance.at.toIso8601String(),
  'title': instance.title,
  'ask': instance.ask,
  'need': ?instance.need,
  'task': instance.task,
  'done': instance.done,
  'urgent': instance.urgent,
  'waiting': instance.waiting,
  'project': ?instance.project,
  'kind': ?instance.kind,
  'lasting': ?instance.lasting,
  'docs': instance.docs.map((e) => e.toJson()).toList(),
  'about': ?instance.about,
  'team': instance.team,
};

_EventRecord _$EventRecordFromJson(Map<String, dynamic> json) => _EventRecord(
  id: json['id'] as String,
  title: json['title'] as String,
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  url: json['url'] as String? ?? '',
  join: json['join'] as String?,
  going: json['going'] as bool? ?? false,
  attendees: (json['attendees'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EventRecordToJson(_EventRecord instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'url': instance.url,
  'join': ?instance.join,
  'going': instance.going,
  'attendees': instance.attendees,
};
