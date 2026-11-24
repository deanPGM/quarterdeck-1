// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardTag _$CardTagFromJson(Map<String, dynamic> json) => _CardTag($enumDecode(_$TagToneEnumMap, json['tone']), json['label'] as String);

Map<String, dynamic> _$CardTagToJson(_CardTag instance) => <String, dynamic>{'tone': _$TagToneEnumMap[instance.tone]!, 'label': instance.label};

const _$TagToneEnumMap = {TagTone.neutral: 'neutral', TagTone.act: 'act', TagTone.done: 'done', TagTone.warn: 'warn'};

_DeckCard _$DeckCardFromJson(Map<String, dynamic> json) => _DeckCard(
  key: json['key'] as String,
  provider: json['provider'] as String,
  lane: $enumDecode(_$LaneEnumMap, readLane(json, 'lane')),
  ref: json['ref'] as String,
  url: json['url'] as String,
  title: json['title'] as String,
  next: json['next'] as String,
  why: json['why'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => CardTag.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  bucket: $enumDecode(_$BucketEnumMap, json['bucket']),
  score: (json['score'] as num).toInt(),
  updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
  author: json['author'] as String?,
  path: json['path'] as String?,
  iid: (json['iid'] as num?)?.toInt(),
  reviewable: json['reviewable'] as bool? ?? false,
  feedback: json['feedback'] as bool? ?? false,
  channel: json['channel'] as String?,
  project: json['project'] as String?,
  source: json['source'] as String?,
  kind: json['kind'] as String?,
  threads: (json['threads'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  refs: (json['refs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$DeckCardToJson(_DeckCard instance) => <String, dynamic>{
  'key': instance.key,
  'provider': instance.provider,
  'lane': _$LaneEnumMap[instance.lane]!,
  'ref': instance.ref,
  'url': instance.url,
  'title': instance.title,
  'next': instance.next,
  'why': ?instance.why,
  'tags': instance.tags.map((e) => e.toJson()).toList(),
  'bucket': _$BucketEnumMap[instance.bucket]!,
  'score': instance.score,
  'updatedAt': ?instance.updatedAt?.toIso8601String(),
  'author': ?instance.author,
  'path': ?instance.path,
  'iid': ?instance.iid,
  'reviewable': instance.reviewable,
  'feedback': instance.feedback,
  'channel': ?instance.channel,
  'project': ?instance.project,
  'source': ?instance.source,
  'kind': ?instance.kind,
  'threads': instance.threads,
  'refs': instance.refs,
};

const _$LaneEnumMap = {Lane.reply: 'reply', Lane.review: 'review', Lane.mine: 'mine', Lane.task: 'task'};

const _$BucketEnumMap = {Bucket.action: 'action', Bucket.blocked: 'blocked', Bucket.clear: 'clear'};
