// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardState {

 Map<String, Snapshot> get snapshots; Map<String, Triage> get triage;/// Links you made (true) or cut (false), per pair key (core/links.dart).
 Map<String, bool> get links;/// Provider ids and card keys being fetched.
 Set<String> get busy; List<ClaudeRun> get runs; List<PermissionAsk> get asks;
/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardStateCopyWith<BoardState> get copyWith => _$BoardStateCopyWithImpl<BoardState>(this as BoardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BoardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardState&&const DeepCollectionEquality().equals(other.snapshots, _this.snapshots)&&const DeepCollectionEquality().equals(other.triage, _this.triage)&&const DeepCollectionEquality().equals(other.links, _this.links)&&const DeepCollectionEquality().equals(other.busy, _this.busy)&&const DeepCollectionEquality().equals(other.runs, _this.runs)&&const DeepCollectionEquality().equals(other.asks, _this.asks));
}


@override
int get hashCode {
  final _this = this as BoardState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.snapshots),const DeepCollectionEquality().hash(_this.triage),const DeepCollectionEquality().hash(_this.links),const DeepCollectionEquality().hash(_this.busy),const DeepCollectionEquality().hash(_this.runs),const DeepCollectionEquality().hash(_this.asks));
}

@override
String toString() {
  final _this = this as BoardState;
  return 'BoardState(snapshots: ${_this.snapshots}, triage: ${_this.triage}, links: ${_this.links}, busy: ${_this.busy}, runs: ${_this.runs}, asks: ${_this.asks})';
}


}

/// @nodoc
abstract mixin class $BoardStateCopyWith<$Res>  {
  factory $BoardStateCopyWith(BoardState value, $Res Function(BoardState) _then) = _$BoardStateCopyWithImpl;
@useResult
$Res call({
 Map<String, Snapshot> snapshots, Map<String, Triage> triage, Map<String, bool> links, Set<String> busy, List<ClaudeRun> runs, List<PermissionAsk> asks
});




}
/// @nodoc
class _$BoardStateCopyWithImpl<$Res>
    implements $BoardStateCopyWith<$Res> {
  _$BoardStateCopyWithImpl(this._self, this._then);

  final BoardState _self;
  final $Res Function(BoardState) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snapshots = null,Object? triage = null,Object? links = null,Object? busy = null,Object? runs = null,Object? asks = null,}) {
  return _then(BoardState(
snapshots: null == snapshots ? _self.snapshots : snapshots // ignore: cast_nullable_to_non_nullable
as Map<String, Snapshot>,triage: null == triage ? _self.triage : triage // ignore: cast_nullable_to_non_nullable
as Map<String, Triage>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as Set<String>,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as List<ClaudeRun>,asks: null == asks ? _self.asks : asks // ignore: cast_nullable_to_non_nullable
as List<PermissionAsk>,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardState].
extension BoardStatePatterns on BoardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardState value)  $default,){
final _that = this;
switch (_that) {
case _BoardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardState value)?  $default,){
final _that = this;
switch (_that) {
case _BoardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Snapshot> snapshots,  Map<String, Triage> triage,  Map<String, bool> links,  Set<String> busy,  List<ClaudeRun> runs,  List<PermissionAsk> asks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardState() when $default != null:
return $default(_that.snapshots,_that.triage,_that.links,_that.busy,_that.runs,_that.asks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Snapshot> snapshots,  Map<String, Triage> triage,  Map<String, bool> links,  Set<String> busy,  List<ClaudeRun> runs,  List<PermissionAsk> asks)  $default,) {final _that = this;
switch (_that) {
case _BoardState():
return $default(_that.snapshots,_that.triage,_that.links,_that.busy,_that.runs,_that.asks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Snapshot> snapshots,  Map<String, Triage> triage,  Map<String, bool> links,  Set<String> busy,  List<ClaudeRun> runs,  List<PermissionAsk> asks)?  $default,) {final _that = this;
switch (_that) {
case _BoardState() when $default != null:
return $default(_that.snapshots,_that.triage,_that.links,_that.busy,_that.runs,_that.asks);case _:
  return null;

}
}

}

/// @nodoc


class _BoardState implements BoardState {
  const _BoardState({ Map<String, Snapshot> snapshots = const {},  Map<String, Triage> triage = const {},  Map<String, bool> links = const {},  Set<String> busy = const {},  List<ClaudeRun> runs = const [],  List<PermissionAsk> asks = const []}): _snapshots = snapshots,_triage = triage,_links = links,_busy = busy,_runs = runs,_asks = asks;
  

 final  Map<String, Snapshot> _snapshots;
@override@JsonKey() Map<String, Snapshot> get snapshots {
  if (_snapshots is EqualUnmodifiableMapView) return _snapshots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_snapshots);
}

 final  Map<String, Triage> _triage;
@override@JsonKey() Map<String, Triage> get triage {
  if (_triage is EqualUnmodifiableMapView) return _triage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_triage);
}

/// Links you made (true) or cut (false), per pair key (core/links.dart).
 final  Map<String, bool> _links;
/// Links you made (true) or cut (false), per pair key (core/links.dart).
@override@JsonKey() Map<String, bool> get links {
  if (_links is EqualUnmodifiableMapView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_links);
}

/// Provider ids and card keys being fetched.
 final  Set<String> _busy;
/// Provider ids and card keys being fetched.
@override@JsonKey() Set<String> get busy {
  if (_busy is EqualUnmodifiableSetView) return _busy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_busy);
}

 final  List<ClaudeRun> _runs;
@override@JsonKey() List<ClaudeRun> get runs {
  if (_runs is EqualUnmodifiableListView) return _runs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_runs);
}

 final  List<PermissionAsk> _asks;
@override@JsonKey() List<PermissionAsk> get asks {
  if (_asks is EqualUnmodifiableListView) return _asks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_asks);
}


/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardStateCopyWith<_BoardState> get copyWith => __$BoardStateCopyWithImpl<_BoardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardState&&const DeepCollectionEquality().equals(other.snapshots, _snapshots)&&const DeepCollectionEquality().equals(other.triage, _triage)&&const DeepCollectionEquality().equals(other.links, _links)&&const DeepCollectionEquality().equals(other.busy, _busy)&&const DeepCollectionEquality().equals(other.runs, _runs)&&const DeepCollectionEquality().equals(other.asks, _asks));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_snapshots),const DeepCollectionEquality().hash(_triage),const DeepCollectionEquality().hash(_links),const DeepCollectionEquality().hash(_busy),const DeepCollectionEquality().hash(_runs),const DeepCollectionEquality().hash(_asks));
}

@override
String toString() {
    return 'BoardState(snapshots: $snapshots, triage: $triage, links: $links, busy: $busy, runs: $runs, asks: $asks)';
}


}

/// @nodoc
abstract mixin class _$BoardStateCopyWith<$Res> implements $BoardStateCopyWith<$Res> {
  factory _$BoardStateCopyWith(_BoardState value, $Res Function(_BoardState) _then) = __$BoardStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Snapshot> snapshots, Map<String, Triage> triage, Map<String, bool> links, Set<String> busy, List<ClaudeRun> runs, List<PermissionAsk> asks
});




}
/// @nodoc
class __$BoardStateCopyWithImpl<$Res>
    implements _$BoardStateCopyWith<$Res> {
  __$BoardStateCopyWithImpl(this._self, this._then);

  final _BoardState _self;
  final $Res Function(_BoardState) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snapshots = null,Object? triage = null,Object? links = null,Object? busy = null,Object? runs = null,Object? asks = null,}) {
  return _then(_BoardState(
snapshots: null == snapshots ? _self._snapshots : snapshots // ignore: cast_nullable_to_non_nullable
as Map<String, Snapshot>,triage: null == triage ? _self._triage : triage // ignore: cast_nullable_to_non_nullable
as Map<String, Triage>,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,busy: null == busy ? _self._busy : busy // ignore: cast_nullable_to_non_nullable
as Set<String>,runs: null == runs ? _self._runs : runs // ignore: cast_nullable_to_non_nullable
as List<ClaudeRun>,asks: null == asks ? _self._asks : asks // ignore: cast_nullable_to_non_nullable
as List<PermissionAsk>,
  ));
}


}

// dart format on
