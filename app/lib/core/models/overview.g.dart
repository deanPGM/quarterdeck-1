// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectUpdate _$ProjectUpdateFromJson(Map<String, dynamic> json) => _ProjectUpdate(
  id: json['id'] as String,
  at: DateTime.parse(json['at'] as String),
  provider: json['provider'] as String,
  source: json['source'] as String,
  text: json['text'] as String,
  url: json['url'] as String?,
  added: json['added'] == null ? null : DateTime.parse(json['added'] as String),
);

Map<String, dynamic> _$ProjectUpdateToJson(_ProjectUpdate instance) => <String, dynamic>{
  'id': instance.id,
  'at': instance.at.toIso8601String(),
  'provider': instance.provider,
  'source': instance.source,
  'text': instance.text,
  'url': ?instance.url,
  'added': ?instance.added?.toIso8601String(),
};

_ProjectDoc _$ProjectDocFromJson(Map<String, dynamic> json) => _ProjectDoc(
  url: json['url'] as String,
  title: json['title'] as String,
  provider: json['provider'] as String,
  source: json['source'] as String?,
  at: DateTime.parse(json['at'] as String),
  removed: json['removed'] as bool? ?? false,
);

Map<String, dynamic> _$ProjectDocToJson(_ProjectDoc instance) => <String, dynamic>{
  'url': instance.url,
  'title': instance.title,
  'provider': instance.provider,
  'source': ?instance.source,
  'at': instance.at.toIso8601String(),
  'removed': instance.removed,
};

_Fact _$FactFromJson(Map<String, dynamic> json) => _Fact(
  section: json['section'] as String,
  text: json['text'] as String,
  source: json['source'] as String?,
  was: json['was'] as String?,
  ref: json['ref'] as String?,
  edited: json['edited'] as bool? ?? false,
);

Map<String, dynamic> _$FactToJson(_Fact instance) => <String, dynamic>{
  'section': instance.section,
  'text': instance.text,
  'source': ?instance.source,
  'was': ?instance.was,
  'ref': ?instance.ref,
  'edited': instance.edited,
};

_Overview _$OverviewFromJson(Map<String, dynamic> json) => _Overview(
  facts: (json['facts'] as List<dynamic>?)?.map((e) => Fact.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  factsUpTo: json['factsUpTo'] == null ? null : DateTime.parse(json['factsUpTo'] as String),
  seenAt: json['seenAt'] == null ? null : DateTime.parse(json['seenAt'] as String),
  mergedUpTo: json['mergedUpTo'] == null ? null : DateTime.parse(json['mergedUpTo'] as String),
);

Map<String, dynamic> _$OverviewToJson(_Overview instance) => <String, dynamic>{
  'facts': instance.facts.map((e) => e.toJson()).toList(),
  'factsUpTo': ?instance.factsUpTo?.toIso8601String(),
  'seenAt': ?instance.seenAt?.toIso8601String(),
  'mergedUpTo': ?instance.mergedUpTo?.toIso8601String(),
};
