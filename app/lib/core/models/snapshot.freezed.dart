// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Snapshot {

 SourceState get state; String? get message; DateTime? get at;/// Your user name on that provider.
 String? get me; List<DeckCard> get cards;/// Calendar only: the meetings of the next 24 hours, by start time.
 List<EventRecord> get events;
/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnapshotCopyWith<Snapshot> get copyWith => _$SnapshotCopyWithImpl<Snapshot>(this as Snapshot, _$identity);

  /// Serializes this Snapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Snapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Snapshot&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.me, _this.me) || other.me == _this.me)&&const DeepCollectionEquality().equals(other.cards, _this.cards)&&const DeepCollectionEquality().equals(other.events, _this.events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Snapshot;
  return Object.hash(runtimeType,_this.state,_this.message,_this.at,_this.me,const DeepCollectionEquality().hash(_this.cards),const DeepCollectionEquality().hash(_this.events));
}

@override
String toString() {
  final _this = this as Snapshot;
  return 'Snapshot(state: ${_this.state}, message: ${_this.message}, at: ${_this.at}, me: ${_this.me}, cards: ${_this.cards}, events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $SnapshotCopyWith<$Res>  {
  factory $SnapshotCopyWith(Snapshot value, $Res Function(Snapshot) _then) = _$SnapshotCopyWithImpl;
@useResult
$Res call({
 SourceState state, String? message, DateTime? at, String? me, List<DeckCard> cards, List<EventRecord> events
});




}
/// @nodoc
class _$SnapshotCopyWithImpl<$Res>
    implements $SnapshotCopyWith<$Res> {
  _$SnapshotCopyWithImpl(this._self, this._then);

  final Snapshot _self;
  final $Res Function(Snapshot) _then;

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? message = freezed,Object? at = freezed,Object? me = freezed,Object? cards = null,Object? events = null,}) {
  return _then(Snapshot(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SourceState,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as String?,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<DeckCard>,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<EventRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [Snapshot].
extension SnapshotPatterns on Snapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Snapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Snapshot value)  $default,){
final _that = this;
switch (_that) {
case _Snapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Snapshot value)?  $default,){
final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SourceState state,  String? message,  DateTime? at,  String? me,  List<DeckCard> cards,  List<EventRecord> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that.state,_that.message,_that.at,_that.me,_that.cards,_that.events);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SourceState state,  String? message,  DateTime? at,  String? me,  List<DeckCard> cards,  List<EventRecord> events)  $default,) {final _that = this;
switch (_that) {
case _Snapshot():
return $default(_that.state,_that.message,_that.at,_that.me,_that.cards,_that.events);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SourceState state,  String? message,  DateTime? at,  String? me,  List<DeckCard> cards,  List<EventRecord> events)?  $default,) {final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that.state,_that.message,_that.at,_that.me,_that.cards,_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Snapshot implements Snapshot {
  const _Snapshot({this.state = SourceState.empty, this.message, this.at, this.me,  List<DeckCard> cards = const [],  List<EventRecord> events = const []}): _cards = cards,_events = events;
  factory _Snapshot.fromJson(Map<String, dynamic> json) => _$SnapshotFromJson(json);

@override@JsonKey() final  SourceState state;
@override final  String? message;
@override final  DateTime? at;
/// Your user name on that provider.
@override final  String? me;
 final  List<DeckCard> _cards;
@override@JsonKey() List<DeckCard> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

/// Calendar only: the meetings of the next 24 hours, by start time.
 final  List<EventRecord> _events;
/// Calendar only: the meetings of the next 24 hours, by start time.
@override@JsonKey() List<EventRecord> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnapshotCopyWith<_Snapshot> get copyWith => __$SnapshotCopyWithImpl<_Snapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Snapshot&&(identical(other.state, state) || other.state == state)&&(identical(other.message, message) || other.message == message)&&(identical(other.at, at) || other.at == at)&&(identical(other.me, me) || other.me == me)&&const DeepCollectionEquality().equals(other.cards, _cards)&&const DeepCollectionEquality().equals(other.events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,state,message,at,me,const DeepCollectionEquality().hash(_cards),const DeepCollectionEquality().hash(_events));
}

@override
String toString() {
    return 'Snapshot(state: $state, message: $message, at: $at, me: $me, cards: $cards, events: $events)';
}


}

/// @nodoc
abstract mixin class _$SnapshotCopyWith<$Res> implements $SnapshotCopyWith<$Res> {
  factory _$SnapshotCopyWith(_Snapshot value, $Res Function(_Snapshot) _then) = __$SnapshotCopyWithImpl;
@override @useResult
$Res call({
 SourceState state, String? message, DateTime? at, String? me, List<DeckCard> cards, List<EventRecord> events
});




}
/// @nodoc
class __$SnapshotCopyWithImpl<$Res>
    implements _$SnapshotCopyWith<$Res> {
  __$SnapshotCopyWithImpl(this._self, this._then);

  final _Snapshot _self;
  final $Res Function(_Snapshot) _then;

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? message = freezed,Object? at = freezed,Object? me = freezed,Object? cards = null,Object? events = null,}) {
  return _then(_Snapshot(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SourceState,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as String?,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<DeckCard>,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<EventRecord>,
  ));
}


}


/// @nodoc
mixin _$Triage {

 bool get pin; bool get urgent;/// -3..3, moves the card up or down.
 int get boost;/// Hidden until this day. Far future means until you unsnooze.
 DateTime? get snoozeUntil; String? get note; bool get done;/// When it was marked done, by you or by Deck: Flow shows today's.
 DateTime? get doneAt;/// You started it (Claude, IDE or review clicked): it sits in Doing until
/// done or "Not now".
 DateTime? get startedAt;/// Why Deck closed it itself (MR merged, you replied). Null when you did.
 String? get doneReason;/// You reopened a card Deck closed: Deck does not close it again.
 bool get keepOpen;/// The last Claude session started from this card (its id), to show its progress.
 String? get session;/// Meetings only: no alarm for this one.
 bool get silent;
/// Create a copy of Triage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriageCopyWith<Triage> get copyWith => _$TriageCopyWithImpl<Triage>(this as Triage, _$identity);

  /// Serializes this Triage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Triage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Triage&&(identical(other.pin, _this.pin) || other.pin == _this.pin)&&(identical(other.urgent, _this.urgent) || other.urgent == _this.urgent)&&(identical(other.boost, _this.boost) || other.boost == _this.boost)&&(identical(other.snoozeUntil, _this.snoozeUntil) || other.snoozeUntil == _this.snoozeUntil)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.doneAt, _this.doneAt) || other.doneAt == _this.doneAt)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.doneReason, _this.doneReason) || other.doneReason == _this.doneReason)&&(identical(other.keepOpen, _this.keepOpen) || other.keepOpen == _this.keepOpen)&&(identical(other.session, _this.session) || other.session == _this.session)&&(identical(other.silent, _this.silent) || other.silent == _this.silent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Triage;
  return Object.hash(runtimeType,_this.pin,_this.urgent,_this.boost,_this.snoozeUntil,_this.note,_this.done,_this.doneAt,_this.startedAt,_this.doneReason,_this.keepOpen,_this.session,_this.silent);
}

@override
String toString() {
  final _this = this as Triage;
  return 'Triage(pin: ${_this.pin}, urgent: ${_this.urgent}, boost: ${_this.boost}, snoozeUntil: ${_this.snoozeUntil}, note: ${_this.note}, done: ${_this.done}, doneAt: ${_this.doneAt}, startedAt: ${_this.startedAt}, doneReason: ${_this.doneReason}, keepOpen: ${_this.keepOpen}, session: ${_this.session}, silent: ${_this.silent})';
}


}

/// @nodoc
abstract mixin class $TriageCopyWith<$Res>  {
  factory $TriageCopyWith(Triage value, $Res Function(Triage) _then) = _$TriageCopyWithImpl;
@useResult
$Res call({
 bool pin, bool urgent, int boost, DateTime? snoozeUntil, String? note, bool done, DateTime? doneAt, DateTime? startedAt, String? doneReason, bool keepOpen, String? session, bool silent
});




}
/// @nodoc
class _$TriageCopyWithImpl<$Res>
    implements $TriageCopyWith<$Res> {
  _$TriageCopyWithImpl(this._self, this._then);

  final Triage _self;
  final $Res Function(Triage) _then;

/// Create a copy of Triage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pin = null,Object? urgent = null,Object? boost = null,Object? snoozeUntil = freezed,Object? note = freezed,Object? done = null,Object? doneAt = freezed,Object? startedAt = freezed,Object? doneReason = freezed,Object? keepOpen = null,Object? session = freezed,Object? silent = null,}) {
  return _then(Triage(
pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as bool,urgent: null == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as bool,boost: null == boost ? _self.boost : boost // ignore: cast_nullable_to_non_nullable
as int,snoozeUntil: freezed == snoozeUntil ? _self.snoozeUntil : snoozeUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneReason: freezed == doneReason ? _self.doneReason : doneReason // ignore: cast_nullable_to_non_nullable
as String?,keepOpen: null == keepOpen ? _self.keepOpen : keepOpen // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,silent: null == silent ? _self.silent : silent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Triage].
extension TriagePatterns on Triage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Triage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Triage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Triage value)  $default,){
final _that = this;
switch (_that) {
case _Triage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Triage value)?  $default,){
final _that = this;
switch (_that) {
case _Triage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool pin,  bool urgent,  int boost,  DateTime? snoozeUntil,  String? note,  bool done,  DateTime? doneAt,  DateTime? startedAt,  String? doneReason,  bool keepOpen,  String? session,  bool silent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Triage() when $default != null:
return $default(_that.pin,_that.urgent,_that.boost,_that.snoozeUntil,_that.note,_that.done,_that.doneAt,_that.startedAt,_that.doneReason,_that.keepOpen,_that.session,_that.silent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool pin,  bool urgent,  int boost,  DateTime? snoozeUntil,  String? note,  bool done,  DateTime? doneAt,  DateTime? startedAt,  String? doneReason,  bool keepOpen,  String? session,  bool silent)  $default,) {final _that = this;
switch (_that) {
case _Triage():
return $default(_that.pin,_that.urgent,_that.boost,_that.snoozeUntil,_that.note,_that.done,_that.doneAt,_that.startedAt,_that.doneReason,_that.keepOpen,_that.session,_that.silent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool pin,  bool urgent,  int boost,  DateTime? snoozeUntil,  String? note,  bool done,  DateTime? doneAt,  DateTime? startedAt,  String? doneReason,  bool keepOpen,  String? session,  bool silent)?  $default,) {final _that = this;
switch (_that) {
case _Triage() when $default != null:
return $default(_that.pin,_that.urgent,_that.boost,_that.snoozeUntil,_that.note,_that.done,_that.doneAt,_that.startedAt,_that.doneReason,_that.keepOpen,_that.session,_that.silent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Triage implements Triage {
  const _Triage({this.pin = false, this.urgent = false, this.boost = 0, this.snoozeUntil, this.note, this.done = false, this.doneAt, this.startedAt, this.doneReason, this.keepOpen = false, this.session, this.silent = false});
  factory _Triage.fromJson(Map<String, dynamic> json) => _$TriageFromJson(json);

@override@JsonKey() final  bool pin;
@override@JsonKey() final  bool urgent;
/// -3..3, moves the card up or down.
@override@JsonKey() final  int boost;
/// Hidden until this day. Far future means until you unsnooze.
@override final  DateTime? snoozeUntil;
@override final  String? note;
@override@JsonKey() final  bool done;
/// When it was marked done, by you or by Deck: Flow shows today's.
@override final  DateTime? doneAt;
/// You started it (Claude, IDE or review clicked): it sits in Doing until
/// done or "Not now".
@override final  DateTime? startedAt;
/// Why Deck closed it itself (MR merged, you replied). Null when you did.
@override final  String? doneReason;
/// You reopened a card Deck closed: Deck does not close it again.
@override@JsonKey() final  bool keepOpen;
/// The last Claude session started from this card (its id), to show its progress.
@override final  String? session;
/// Meetings only: no alarm for this one.
@override@JsonKey() final  bool silent;

/// Create a copy of Triage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriageCopyWith<_Triage> get copyWith => __$TriageCopyWithImpl<_Triage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Triage&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.urgent, urgent) || other.urgent == urgent)&&(identical(other.boost, boost) || other.boost == boost)&&(identical(other.snoozeUntil, snoozeUntil) || other.snoozeUntil == snoozeUntil)&&(identical(other.note, note) || other.note == note)&&(identical(other.done, done) || other.done == done)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.doneReason, doneReason) || other.doneReason == doneReason)&&(identical(other.keepOpen, keepOpen) || other.keepOpen == keepOpen)&&(identical(other.session, session) || other.session == session)&&(identical(other.silent, silent) || other.silent == silent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pin,urgent,boost,snoozeUntil,note,done,doneAt,startedAt,doneReason,keepOpen,session,silent);
}

@override
String toString() {
    return 'Triage(pin: $pin, urgent: $urgent, boost: $boost, snoozeUntil: $snoozeUntil, note: $note, done: $done, doneAt: $doneAt, startedAt: $startedAt, doneReason: $doneReason, keepOpen: $keepOpen, session: $session, silent: $silent)';
}


}

/// @nodoc
abstract mixin class _$TriageCopyWith<$Res> implements $TriageCopyWith<$Res> {
  factory _$TriageCopyWith(_Triage value, $Res Function(_Triage) _then) = __$TriageCopyWithImpl;
@override @useResult
$Res call({
 bool pin, bool urgent, int boost, DateTime? snoozeUntil, String? note, bool done, DateTime? doneAt, DateTime? startedAt, String? doneReason, bool keepOpen, String? session, bool silent
});




}
/// @nodoc
class __$TriageCopyWithImpl<$Res>
    implements _$TriageCopyWith<$Res> {
  __$TriageCopyWithImpl(this._self, this._then);

  final _Triage _self;
  final $Res Function(_Triage) _then;

/// Create a copy of Triage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pin = null,Object? urgent = null,Object? boost = null,Object? snoozeUntil = freezed,Object? note = freezed,Object? done = null,Object? doneAt = freezed,Object? startedAt = freezed,Object? doneReason = freezed,Object? keepOpen = null,Object? session = freezed,Object? silent = null,}) {
  return _then(_Triage(
pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as bool,urgent: null == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as bool,boost: null == boost ? _self.boost : boost // ignore: cast_nullable_to_non_nullable
as int,snoozeUntil: freezed == snoozeUntil ? _self.snoozeUntil : snoozeUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneReason: freezed == doneReason ? _self.doneReason : doneReason // ignore: cast_nullable_to_non_nullable
as String?,keepOpen: null == keepOpen ? _self.keepOpen : keepOpen // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,silent: null == silent ? _self.silent : silent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
