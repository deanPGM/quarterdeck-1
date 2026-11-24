// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectUpdate {

/// Unique per source: `slack:<id>`, `mail:<id>`, `gitlab:<path>!<iid>`.
 String get id; DateTime get at; String get provider;/// Where it came from: "#vpn-team", a sender, an MR author.
 String get source; String get text; String? get url;/// When Deck logged it: what came after your last visit, or after the
/// last Facts run, is new.
 DateTime? get added;
/// Create a copy of ProjectUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectUpdateCopyWith<ProjectUpdate> get copyWith => _$ProjectUpdateCopyWithImpl<ProjectUpdate>(this as ProjectUpdate, _$identity);

  /// Serializes this ProjectUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectUpdate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.added, _this.added) || other.added == _this.added));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectUpdate;
  return Object.hash(runtimeType,_this.id,_this.at,_this.provider,_this.source,_this.text,_this.url,_this.added);
}

@override
String toString() {
  final _this = this as ProjectUpdate;
  return 'ProjectUpdate(id: ${_this.id}, at: ${_this.at}, provider: ${_this.provider}, source: ${_this.source}, text: ${_this.text}, url: ${_this.url}, added: ${_this.added})';
}


}

/// @nodoc
abstract mixin class $ProjectUpdateCopyWith<$Res>  {
  factory $ProjectUpdateCopyWith(ProjectUpdate value, $Res Function(ProjectUpdate) _then) = _$ProjectUpdateCopyWithImpl;
@useResult
$Res call({
 String id, DateTime at, String provider, String source, String text, String? url, DateTime? added
});




}
/// @nodoc
class _$ProjectUpdateCopyWithImpl<$Res>
    implements $ProjectUpdateCopyWith<$Res> {
  _$ProjectUpdateCopyWithImpl(this._self, this._then);

  final ProjectUpdate _self;
  final $Res Function(ProjectUpdate) _then;

/// Create a copy of ProjectUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? at = null,Object? provider = null,Object? source = null,Object? text = null,Object? url = freezed,Object? added = freezed,}) {
  return _then(ProjectUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectUpdate].
extension ProjectUpdatePatterns on ProjectUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectUpdate value)  $default,){
final _that = this;
switch (_that) {
case _ProjectUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime at,  String provider,  String source,  String text,  String? url,  DateTime? added)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectUpdate() when $default != null:
return $default(_that.id,_that.at,_that.provider,_that.source,_that.text,_that.url,_that.added);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime at,  String provider,  String source,  String text,  String? url,  DateTime? added)  $default,) {final _that = this;
switch (_that) {
case _ProjectUpdate():
return $default(_that.id,_that.at,_that.provider,_that.source,_that.text,_that.url,_that.added);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime at,  String provider,  String source,  String text,  String? url,  DateTime? added)?  $default,) {final _that = this;
switch (_that) {
case _ProjectUpdate() when $default != null:
return $default(_that.id,_that.at,_that.provider,_that.source,_that.text,_that.url,_that.added);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectUpdate implements ProjectUpdate {
  const _ProjectUpdate({required this.id, required this.at, required this.provider, required this.source, required this.text, this.url, this.added});
  factory _ProjectUpdate.fromJson(Map<String, dynamic> json) => _$ProjectUpdateFromJson(json);

/// Unique per source: `slack:<id>`, `mail:<id>`, `gitlab:<path>!<iid>`.
@override final  String id;
@override final  DateTime at;
@override final  String provider;
/// Where it came from: "#vpn-team", a sender, an MR author.
@override final  String source;
@override final  String text;
@override final  String? url;
/// When Deck logged it: what came after your last visit, or after the
/// last Facts run, is new.
@override final  DateTime? added;

/// Create a copy of ProjectUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectUpdateCopyWith<_ProjectUpdate> get copyWith => __$ProjectUpdateCopyWithImpl<_ProjectUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.source, source) || other.source == source)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.added, added) || other.added == added));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,at,provider,source,text,url,added);
}

@override
String toString() {
    return 'ProjectUpdate(id: $id, at: $at, provider: $provider, source: $source, text: $text, url: $url, added: $added)';
}


}

/// @nodoc
abstract mixin class _$ProjectUpdateCopyWith<$Res> implements $ProjectUpdateCopyWith<$Res> {
  factory _$ProjectUpdateCopyWith(_ProjectUpdate value, $Res Function(_ProjectUpdate) _then) = __$ProjectUpdateCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime at, String provider, String source, String text, String? url, DateTime? added
});




}
/// @nodoc
class __$ProjectUpdateCopyWithImpl<$Res>
    implements _$ProjectUpdateCopyWith<$Res> {
  __$ProjectUpdateCopyWithImpl(this._self, this._then);

  final _ProjectUpdate _self;
  final $Res Function(_ProjectUpdate) _then;

/// Create a copy of ProjectUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? at = null,Object? provider = null,Object? source = null,Object? text = null,Object? url = freezed,Object? added = freezed,}) {
  return _then(_ProjectUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProjectDoc {

/// The link, also the key: one entry per url.
 String get url; String get title;/// slack, mail, or you.
 String get provider;/// Where it was shared: "#vpn-team", a sender. Null when you added it.
 String? get source; DateTime get at;/// You removed it: kept so the same message read again does not bring it back.
 bool get removed;
/// Create a copy of ProjectDoc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDocCopyWith<ProjectDoc> get copyWith => _$ProjectDocCopyWithImpl<ProjectDoc>(this as ProjectDoc, _$identity);

  /// Serializes this ProjectDoc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectDoc;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDoc&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.removed, _this.removed) || other.removed == _this.removed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectDoc;
  return Object.hash(runtimeType,_this.url,_this.title,_this.provider,_this.source,_this.at,_this.removed);
}

@override
String toString() {
  final _this = this as ProjectDoc;
  return 'ProjectDoc(url: ${_this.url}, title: ${_this.title}, provider: ${_this.provider}, source: ${_this.source}, at: ${_this.at}, removed: ${_this.removed})';
}


}

/// @nodoc
abstract mixin class $ProjectDocCopyWith<$Res>  {
  factory $ProjectDocCopyWith(ProjectDoc value, $Res Function(ProjectDoc) _then) = _$ProjectDocCopyWithImpl;
@useResult
$Res call({
 String url, String title, String provider, String? source, DateTime at, bool removed
});




}
/// @nodoc
class _$ProjectDocCopyWithImpl<$Res>
    implements $ProjectDocCopyWith<$Res> {
  _$ProjectDocCopyWithImpl(this._self, this._then);

  final ProjectDoc _self;
  final $Res Function(ProjectDoc) _then;

/// Create a copy of ProjectDoc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? title = null,Object? provider = null,Object? source = freezed,Object? at = null,Object? removed = null,}) {
  return _then(ProjectDoc(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,removed: null == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectDoc].
extension ProjectDocPatterns on ProjectDoc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDoc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDoc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDoc value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDoc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDoc value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDoc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String title,  String provider,  String? source,  DateTime at,  bool removed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDoc() when $default != null:
return $default(_that.url,_that.title,_that.provider,_that.source,_that.at,_that.removed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String title,  String provider,  String? source,  DateTime at,  bool removed)  $default,) {final _that = this;
switch (_that) {
case _ProjectDoc():
return $default(_that.url,_that.title,_that.provider,_that.source,_that.at,_that.removed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String title,  String provider,  String? source,  DateTime at,  bool removed)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDoc() when $default != null:
return $default(_that.url,_that.title,_that.provider,_that.source,_that.at,_that.removed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDoc implements ProjectDoc {
  const _ProjectDoc({required this.url, required this.title, required this.provider, this.source, required this.at, this.removed = false});
  factory _ProjectDoc.fromJson(Map<String, dynamic> json) => _$ProjectDocFromJson(json);

/// The link, also the key: one entry per url.
@override final  String url;
@override final  String title;
/// slack, mail, or you.
@override final  String provider;
/// Where it was shared: "#vpn-team", a sender. Null when you added it.
@override final  String? source;
@override final  DateTime at;
/// You removed it: kept so the same message read again does not bring it back.
@override@JsonKey() final  bool removed;

/// Create a copy of ProjectDoc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDocCopyWith<_ProjectDoc> get copyWith => __$ProjectDocCopyWithImpl<_ProjectDoc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDocToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDoc&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.source, source) || other.source == source)&&(identical(other.at, at) || other.at == at)&&(identical(other.removed, removed) || other.removed == removed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,title,provider,source,at,removed);
}

@override
String toString() {
    return 'ProjectDoc(url: $url, title: $title, provider: $provider, source: $source, at: $at, removed: $removed)';
}


}

/// @nodoc
abstract mixin class _$ProjectDocCopyWith<$Res> implements $ProjectDocCopyWith<$Res> {
  factory _$ProjectDocCopyWith(_ProjectDoc value, $Res Function(_ProjectDoc) _then) = __$ProjectDocCopyWithImpl;
@override @useResult
$Res call({
 String url, String title, String provider, String? source, DateTime at, bool removed
});




}
/// @nodoc
class __$ProjectDocCopyWithImpl<$Res>
    implements _$ProjectDocCopyWith<$Res> {
  __$ProjectDocCopyWithImpl(this._self, this._then);

  final _ProjectDoc _self;
  final $Res Function(_ProjectDoc) _then;

/// Create a copy of ProjectDoc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? title = null,Object? provider = null,Object? source = freezed,Object? at = null,Object? removed = null,}) {
  return _then(_ProjectDoc(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,removed: null == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Fact {

/// A key of [factSections].
 String get section; String get text;/// Where it came from, as the update says ("#vpn-team, Nov 2").
 String? get source;/// The value it replaced, shown as "(was ...)".
 String? get was;/// The id of the update it came from: a click opens that update's link.
 String? get ref;/// You wrote or changed it: Claude keeps it as it is.
 bool get edited;
/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactCopyWith<Fact> get copyWith => _$FactCopyWithImpl<Fact>(this as Fact, _$identity);

  /// Serializes this Fact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Fact;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fact&&(identical(other.section, _this.section) || other.section == _this.section)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.was, _this.was) || other.was == _this.was)&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.edited, _this.edited) || other.edited == _this.edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Fact;
  return Object.hash(runtimeType,_this.section,_this.text,_this.source,_this.was,_this.ref,_this.edited);
}

@override
String toString() {
  final _this = this as Fact;
  return 'Fact(section: ${_this.section}, text: ${_this.text}, source: ${_this.source}, was: ${_this.was}, ref: ${_this.ref}, edited: ${_this.edited})';
}


}

/// @nodoc
abstract mixin class $FactCopyWith<$Res>  {
  factory $FactCopyWith(Fact value, $Res Function(Fact) _then) = _$FactCopyWithImpl;
@useResult
$Res call({
 String section, String text, String? source, String? was, String? ref, bool edited
});




}
/// @nodoc
class _$FactCopyWithImpl<$Res>
    implements $FactCopyWith<$Res> {
  _$FactCopyWithImpl(this._self, this._then);

  final Fact _self;
  final $Res Function(Fact) _then;

/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? section = null,Object? text = null,Object? source = freezed,Object? was = freezed,Object? ref = freezed,Object? edited = null,}) {
  return _then(Fact(
section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,was: freezed == was ? _self.was : was // ignore: cast_nullable_to_non_nullable
as String?,ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Fact].
extension FactPatterns on Fact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fact value)  $default,){
final _that = this;
switch (_that) {
case _Fact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fact value)?  $default,){
final _that = this;
switch (_that) {
case _Fact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String section,  String text,  String? source,  String? was,  String? ref,  bool edited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fact() when $default != null:
return $default(_that.section,_that.text,_that.source,_that.was,_that.ref,_that.edited);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String section,  String text,  String? source,  String? was,  String? ref,  bool edited)  $default,) {final _that = this;
switch (_that) {
case _Fact():
return $default(_that.section,_that.text,_that.source,_that.was,_that.ref,_that.edited);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String section,  String text,  String? source,  String? was,  String? ref,  bool edited)?  $default,) {final _that = this;
switch (_that) {
case _Fact() when $default != null:
return $default(_that.section,_that.text,_that.source,_that.was,_that.ref,_that.edited);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Fact implements Fact {
  const _Fact({required this.section, required this.text, this.source, this.was, this.ref, this.edited = false});
  factory _Fact.fromJson(Map<String, dynamic> json) => _$FactFromJson(json);

/// A key of [factSections].
@override final  String section;
@override final  String text;
/// Where it came from, as the update says ("#vpn-team, Nov 2").
@override final  String? source;
/// The value it replaced, shown as "(was ...)".
@override final  String? was;
/// The id of the update it came from: a click opens that update's link.
@override final  String? ref;
/// You wrote or changed it: Claude keeps it as it is.
@override@JsonKey() final  bool edited;

/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactCopyWith<_Fact> get copyWith => __$FactCopyWithImpl<_Fact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FactToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fact&&(identical(other.section, section) || other.section == section)&&(identical(other.text, text) || other.text == text)&&(identical(other.source, source) || other.source == source)&&(identical(other.was, was) || other.was == was)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.edited, edited) || other.edited == edited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,section,text,source,was,ref,edited);
}

@override
String toString() {
    return 'Fact(section: $section, text: $text, source: $source, was: $was, ref: $ref, edited: $edited)';
}


}

/// @nodoc
abstract mixin class _$FactCopyWith<$Res> implements $FactCopyWith<$Res> {
  factory _$FactCopyWith(_Fact value, $Res Function(_Fact) _then) = __$FactCopyWithImpl;
@override @useResult
$Res call({
 String section, String text, String? source, String? was, String? ref, bool edited
});




}
/// @nodoc
class __$FactCopyWithImpl<$Res>
    implements _$FactCopyWith<$Res> {
  __$FactCopyWithImpl(this._self, this._then);

  final _Fact _self;
  final $Res Function(_Fact) _then;

/// Create a copy of Fact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? section = null,Object? text = null,Object? source = freezed,Object? was = freezed,Object? ref = freezed,Object? edited = null,}) {
  return _then(_Fact(
section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,was: freezed == was ? _self.was : was // ignore: cast_nullable_to_non_nullable
as String?,ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Overview {

 List<Fact> get facts;/// Facts cover the updates up to this time.
 DateTime? get factsUpTo;/// Your last visit of the page: newer updates are marked new.
 DateTime? get seenAt;/// Merged merge requests are read up to this time.
 DateTime? get mergedUpTo;
/// Create a copy of Overview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverviewCopyWith<Overview> get copyWith => _$OverviewCopyWithImpl<Overview>(this as Overview, _$identity);

  /// Serializes this Overview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Overview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Overview&&const DeepCollectionEquality().equals(other.facts, _this.facts)&&(identical(other.factsUpTo, _this.factsUpTo) || other.factsUpTo == _this.factsUpTo)&&(identical(other.seenAt, _this.seenAt) || other.seenAt == _this.seenAt)&&(identical(other.mergedUpTo, _this.mergedUpTo) || other.mergedUpTo == _this.mergedUpTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Overview;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.facts),_this.factsUpTo,_this.seenAt,_this.mergedUpTo);
}

@override
String toString() {
  final _this = this as Overview;
  return 'Overview(facts: ${_this.facts}, factsUpTo: ${_this.factsUpTo}, seenAt: ${_this.seenAt}, mergedUpTo: ${_this.mergedUpTo})';
}


}

/// @nodoc
abstract mixin class $OverviewCopyWith<$Res>  {
  factory $OverviewCopyWith(Overview value, $Res Function(Overview) _then) = _$OverviewCopyWithImpl;
@useResult
$Res call({
 List<Fact> facts, DateTime? factsUpTo, DateTime? seenAt, DateTime? mergedUpTo
});




}
/// @nodoc
class _$OverviewCopyWithImpl<$Res>
    implements $OverviewCopyWith<$Res> {
  _$OverviewCopyWithImpl(this._self, this._then);

  final Overview _self;
  final $Res Function(Overview) _then;

/// Create a copy of Overview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? facts = null,Object? factsUpTo = freezed,Object? seenAt = freezed,Object? mergedUpTo = freezed,}) {
  return _then(Overview(
facts: null == facts ? _self.facts : facts // ignore: cast_nullable_to_non_nullable
as List<Fact>,factsUpTo: freezed == factsUpTo ? _self.factsUpTo : factsUpTo // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mergedUpTo: freezed == mergedUpTo ? _self.mergedUpTo : mergedUpTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Overview].
extension OverviewPatterns on Overview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Overview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Overview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Overview value)  $default,){
final _that = this;
switch (_that) {
case _Overview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Overview value)?  $default,){
final _that = this;
switch (_that) {
case _Overview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Fact> facts,  DateTime? factsUpTo,  DateTime? seenAt,  DateTime? mergedUpTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Overview() when $default != null:
return $default(_that.facts,_that.factsUpTo,_that.seenAt,_that.mergedUpTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Fact> facts,  DateTime? factsUpTo,  DateTime? seenAt,  DateTime? mergedUpTo)  $default,) {final _that = this;
switch (_that) {
case _Overview():
return $default(_that.facts,_that.factsUpTo,_that.seenAt,_that.mergedUpTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Fact> facts,  DateTime? factsUpTo,  DateTime? seenAt,  DateTime? mergedUpTo)?  $default,) {final _that = this;
switch (_that) {
case _Overview() when $default != null:
return $default(_that.facts,_that.factsUpTo,_that.seenAt,_that.mergedUpTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Overview implements Overview {
  const _Overview({ List<Fact> facts = const [], this.factsUpTo, this.seenAt, this.mergedUpTo}): _facts = facts;
  factory _Overview.fromJson(Map<String, dynamic> json) => _$OverviewFromJson(json);

 final  List<Fact> _facts;
@override@JsonKey() List<Fact> get facts {
  if (_facts is EqualUnmodifiableListView) return _facts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_facts);
}

/// Facts cover the updates up to this time.
@override final  DateTime? factsUpTo;
/// Your last visit of the page: newer updates are marked new.
@override final  DateTime? seenAt;
/// Merged merge requests are read up to this time.
@override final  DateTime? mergedUpTo;

/// Create a copy of Overview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverviewCopyWith<_Overview> get copyWith => __$OverviewCopyWithImpl<_Overview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Overview&&const DeepCollectionEquality().equals(other.facts, _facts)&&(identical(other.factsUpTo, factsUpTo) || other.factsUpTo == factsUpTo)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.mergedUpTo, mergedUpTo) || other.mergedUpTo == mergedUpTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_facts),factsUpTo,seenAt,mergedUpTo);
}

@override
String toString() {
    return 'Overview(facts: $facts, factsUpTo: $factsUpTo, seenAt: $seenAt, mergedUpTo: $mergedUpTo)';
}


}

/// @nodoc
abstract mixin class _$OverviewCopyWith<$Res> implements $OverviewCopyWith<$Res> {
  factory _$OverviewCopyWith(_Overview value, $Res Function(_Overview) _then) = __$OverviewCopyWithImpl;
@override @useResult
$Res call({
 List<Fact> facts, DateTime? factsUpTo, DateTime? seenAt, DateTime? mergedUpTo
});




}
/// @nodoc
class __$OverviewCopyWithImpl<$Res>
    implements _$OverviewCopyWith<$Res> {
  __$OverviewCopyWithImpl(this._self, this._then);

  final _Overview _self;
  final $Res Function(_Overview) _then;

/// Create a copy of Overview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? facts = null,Object? factsUpTo = freezed,Object? seenAt = freezed,Object? mergedUpTo = freezed,}) {
  return _then(_Overview(
facts: null == facts ? _self._facts : facts // ignore: cast_nullable_to_non_nullable
as List<Fact>,factsUpTo: freezed == factsUpTo ? _self.factsUpTo : factsUpTo // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mergedUpTo: freezed == mergedUpTo ? _self.mergedUpTo : mergedUpTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
