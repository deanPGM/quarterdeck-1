// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Activity {

 DateTime get at;/// done, todo, merged, approved, meeting, session or note.
 String get kind; String get title;/// Same id, same event: logged once.
 String? get id;/// Where it happened: gitlab, jira, slack, mail, calendar, claude.
 String? get source;/// Short reference: "backend!77", "VPN-120", "#vpn-team".
 String? get ref; String? get url; String? get project;/// Extra: why Deck closed it, the session folder, how long.
 String? get detail;
/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCopyWith<Activity> get copyWith => _$ActivityCopyWithImpl<Activity>(this as Activity, _$identity);

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Activity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Activity&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.project, _this.project) || other.project == _this.project)&&(identical(other.detail, _this.detail) || other.detail == _this.detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Activity;
  return Object.hash(runtimeType,_this.at,_this.kind,_this.title,_this.id,_this.source,_this.ref,_this.url,_this.project,_this.detail);
}

@override
String toString() {
  final _this = this as Activity;
  return 'Activity(at: ${_this.at}, kind: ${_this.kind}, title: ${_this.title}, id: ${_this.id}, source: ${_this.source}, ref: ${_this.ref}, url: ${_this.url}, project: ${_this.project}, detail: ${_this.detail})';
}


}

/// @nodoc
abstract mixin class $ActivityCopyWith<$Res>  {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) _then) = _$ActivityCopyWithImpl;
@useResult
$Res call({
 DateTime at, String kind, String title, String? id, String? source, String? ref, String? url, String? project, String? detail
});




}
/// @nodoc
class _$ActivityCopyWithImpl<$Res>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._self, this._then);

  final Activity _self;
  final $Res Function(Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? kind = null,Object? title = null,Object? id = freezed,Object? source = freezed,Object? ref = freezed,Object? url = freezed,Object? project = freezed,Object? detail = freezed,}) {
  return _then(Activity(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Activity].
extension ActivityPatterns on Activity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Activity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Activity value)  $default,){
final _that = this;
switch (_that) {
case _Activity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Activity value)?  $default,){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  String kind,  String title,  String? id,  String? source,  String? ref,  String? url,  String? project,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.at,_that.kind,_that.title,_that.id,_that.source,_that.ref,_that.url,_that.project,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  String kind,  String title,  String? id,  String? source,  String? ref,  String? url,  String? project,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _Activity():
return $default(_that.at,_that.kind,_that.title,_that.id,_that.source,_that.ref,_that.url,_that.project,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  String kind,  String title,  String? id,  String? source,  String? ref,  String? url,  String? project,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.at,_that.kind,_that.title,_that.id,_that.source,_that.ref,_that.url,_that.project,_that.detail);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _Activity implements Activity {
  const _Activity({required this.at, required this.kind, required this.title, this.id, this.source, this.ref, this.url, this.project, this.detail});
  factory _Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

@override final  DateTime at;
/// done, todo, merged, approved, meeting, session or note.
@override final  String kind;
@override final  String title;
/// Same id, same event: logged once.
@override final  String? id;
/// Where it happened: gitlab, jira, slack, mail, calendar, claude.
@override final  String? source;
/// Short reference: "backend!77", "VPN-120", "#vpn-team".
@override final  String? ref;
@override final  String? url;
@override final  String? project;
/// Extra: why Deck closed it, the session folder, how long.
@override final  String? detail;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCopyWith<_Activity> get copyWith => __$ActivityCopyWithImpl<_Activity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Activity&&(identical(other.at, at) || other.at == at)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.url, url) || other.url == url)&&(identical(other.project, project) || other.project == project)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,at,kind,title,id,source,ref,url,project,detail);
}

@override
String toString() {
    return 'Activity(at: $at, kind: $kind, title: $title, id: $id, source: $source, ref: $ref, url: $url, project: $project, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$ActivityCopyWith<$Res> implements $ActivityCopyWith<$Res> {
  factory _$ActivityCopyWith(_Activity value, $Res Function(_Activity) _then) = __$ActivityCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, String kind, String title, String? id, String? source, String? ref, String? url, String? project, String? detail
});




}
/// @nodoc
class __$ActivityCopyWithImpl<$Res>
    implements _$ActivityCopyWith<$Res> {
  __$ActivityCopyWithImpl(this._self, this._then);

  final _Activity _self;
  final $Res Function(_Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? kind = null,Object? title = null,Object? id = freezed,Object? source = freezed,Object? ref = freezed,Object? url = freezed,Object? project = freezed,Object? detail = freezed,}) {
  return _then(_Activity(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
