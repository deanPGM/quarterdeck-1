// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardFilter {

/// Project ids, or `other`.
 Set<String> get projects; Set<Lane> get types;/// Provider ids (gitlab, slack, todo...).
 Set<String> get providers;/// Searches titles, refs, next steps and notes.
 String get text;
/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardFilterCopyWith<BoardFilter> get copyWith => _$BoardFilterCopyWithImpl<BoardFilter>(this as BoardFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BoardFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardFilter&&const DeepCollectionEquality().equals(other.projects, _this.projects)&&const DeepCollectionEquality().equals(other.types, _this.types)&&const DeepCollectionEquality().equals(other.providers, _this.providers)&&(identical(other.text, _this.text) || other.text == _this.text));
}


@override
int get hashCode {
  final _this = this as BoardFilter;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.projects),const DeepCollectionEquality().hash(_this.types),const DeepCollectionEquality().hash(_this.providers),_this.text);
}

@override
String toString() {
  final _this = this as BoardFilter;
  return 'BoardFilter(projects: ${_this.projects}, types: ${_this.types}, providers: ${_this.providers}, text: ${_this.text})';
}


}

/// @nodoc
abstract mixin class $BoardFilterCopyWith<$Res>  {
  factory $BoardFilterCopyWith(BoardFilter value, $Res Function(BoardFilter) _then) = _$BoardFilterCopyWithImpl;
@useResult
$Res call({
 Set<String> projects, Set<Lane> types, Set<String> providers, String text
});




}
/// @nodoc
class _$BoardFilterCopyWithImpl<$Res>
    implements $BoardFilterCopyWith<$Res> {
  _$BoardFilterCopyWithImpl(this._self, this._then);

  final BoardFilter _self;
  final $Res Function(BoardFilter) _then;

/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projects = null,Object? types = null,Object? providers = null,Object? text = null,}) {
  return _then(BoardFilter(
projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as Set<String>,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as Set<Lane>,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as Set<String>,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardFilter].
extension BoardFilterPatterns on BoardFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardFilter value)  $default,){
final _that = this;
switch (_that) {
case _BoardFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardFilter value)?  $default,){
final _that = this;
switch (_that) {
case _BoardFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> projects,  Set<Lane> types,  Set<String> providers,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardFilter() when $default != null:
return $default(_that.projects,_that.types,_that.providers,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> projects,  Set<Lane> types,  Set<String> providers,  String text)  $default,) {final _that = this;
switch (_that) {
case _BoardFilter():
return $default(_that.projects,_that.types,_that.providers,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> projects,  Set<Lane> types,  Set<String> providers,  String text)?  $default,) {final _that = this;
switch (_that) {
case _BoardFilter() when $default != null:
return $default(_that.projects,_that.types,_that.providers,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _BoardFilter extends BoardFilter {
  const _BoardFilter({ Set<String> projects = const {},  Set<Lane> types = const {},  Set<String> providers = const {}, this.text = ''}): _projects = projects,_types = types,_providers = providers,super._();
  

/// Project ids, or `other`.
 final  Set<String> _projects;
/// Project ids, or `other`.
@override@JsonKey() Set<String> get projects {
  if (_projects is EqualUnmodifiableSetView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_projects);
}

 final  Set<Lane> _types;
@override@JsonKey() Set<Lane> get types {
  if (_types is EqualUnmodifiableSetView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_types);
}

/// Provider ids (gitlab, slack, todo...).
 final  Set<String> _providers;
/// Provider ids (gitlab, slack, todo...).
@override@JsonKey() Set<String> get providers {
  if (_providers is EqualUnmodifiableSetView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_providers);
}

/// Searches titles, refs, next steps and notes.
@override@JsonKey() final  String text;

/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardFilterCopyWith<_BoardFilter> get copyWith => __$BoardFilterCopyWithImpl<_BoardFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardFilter&&const DeepCollectionEquality().equals(other.projects, _projects)&&const DeepCollectionEquality().equals(other.types, _types)&&const DeepCollectionEquality().equals(other.providers, _providers)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_projects),const DeepCollectionEquality().hash(_types),const DeepCollectionEquality().hash(_providers),text);
}

@override
String toString() {
    return 'BoardFilter(projects: $projects, types: $types, providers: $providers, text: $text)';
}


}

/// @nodoc
abstract mixin class _$BoardFilterCopyWith<$Res> implements $BoardFilterCopyWith<$Res> {
  factory _$BoardFilterCopyWith(_BoardFilter value, $Res Function(_BoardFilter) _then) = __$BoardFilterCopyWithImpl;
@override @useResult
$Res call({
 Set<String> projects, Set<Lane> types, Set<String> providers, String text
});




}
/// @nodoc
class __$BoardFilterCopyWithImpl<$Res>
    implements _$BoardFilterCopyWith<$Res> {
  __$BoardFilterCopyWithImpl(this._self, this._then);

  final _BoardFilter _self;
  final $Res Function(_BoardFilter) _then;

/// Create a copy of BoardFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projects = null,Object? types = null,Object? providers = null,Object? text = null,}) {
  return _then(_BoardFilter(
projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as Set<String>,types: null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as Set<Lane>,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as Set<String>,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
