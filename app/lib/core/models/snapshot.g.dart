// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Snapshot _$SnapshotFromJson(Map<String, dynamic> json) => _Snapshot(
  state: $enumDecodeNullable(_$SourceStateEnumMap, json['state']) ?? SourceState.empty,
  message: json['message'] as String?,
  at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
  me: json['me'] as String?,
  cards: (json['cards'] as List<dynamic>?)?.map((e) => DeckCard.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  events: (json['events'] as List<dynamic>?)?.map((e) => EventRecord.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$SnapshotToJson(_Snapshot instance) => <String, dynamic>{
  'state': _$SourceStateEnumMap[instance.state]!,
  'message': ?instance.message,
  'at': ?instance.at?.toIso8601String(),
  'me': ?instance.me,
  'cards': instance.cards.map((e) => e.toJson()).toList(),
  'events': instance.events.map((e) => e.toJson()).toList(),
};

const _$SourceStateEnumMap = {SourceState.empty: 'empty', SourceState.loading: 'loading', SourceState.ok: 'ok', SourceState.error: 'error'};

_Triage _$TriageFromJson(Map<String, dynamic> json) => _Triage(
  pin: json['pin'] as bool? ?? false,
  urgent: json['urgent'] as bool? ?? false,
  boost: (json['boost'] as num?)?.toInt() ?? 0,
  snoozeUntil: json['snoozeUntil'] == null ? null : DateTime.parse(json['snoozeUntil'] as String),
  note: json['note'] as String?,
  done: json['done'] as bool? ?? false,
  doneAt: json['doneAt'] == null ? null : DateTime.parse(json['doneAt'] as String),
  startedAt: json['startedAt'] == null ? null : DateTime.parse(json['startedAt'] as String),
  doneReason: json['doneReason'] as String?,
  keepOpen: json['keepOpen'] as bool? ?? false,
  session: json['session'] as String?,
  silent: json['silent'] as bool? ?? false,
);

Map<String, dynamic> _$TriageToJson(_Triage instance) => <String, dynamic>{
  'pin': instance.pin,
  'urgent': instance.urgent,
  'boost': instance.boost,
  'snoozeUntil': ?instance.snoozeUntil?.toIso8601String(),
  'note': ?instance.note,
  'done': instance.done,
  'doneAt': ?instance.doneAt?.toIso8601String(),
  'startedAt': ?instance.startedAt?.toIso8601String(),
  'doneReason': ?instance.doneReason,
  'keepOpen': instance.keepOpen,
  'session': ?instance.session,
  'silent': instance.silent,
};
