// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  at: DateTime.parse(json['at'] as String),
  kind: json['kind'] as String,
  title: json['title'] as String,
  id: json['id'] as String?,
  source: json['source'] as String?,
  ref: json['ref'] as String?,
  url: json['url'] as String?,
  project: json['project'] as String?,
  detail: json['detail'] as String?,
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'kind': instance.kind,
  'title': instance.title,
  'id': ?instance.id,
  'source': ?instance.source,
  'ref': ?instance.ref,
  'url': ?instance.url,
  'project': ?instance.project,
  'detail': ?instance.detail,
};
