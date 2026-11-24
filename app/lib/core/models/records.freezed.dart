// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'records.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadRecord {

 String get start; String get last; List<String> get people;
/// Create a copy of ThreadRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadRecordCopyWith<ThreadRecord> get copyWith => _$ThreadRecordCopyWithImpl<ThreadRecord>(this as ThreadRecord, _$identity);

  /// Serializes this ThreadRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ThreadRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadRecord&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.last, _this.last) || other.last == _this.last)&&const DeepCollectionEquality().equals(other.people, _this.people));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ThreadRecord;
  return Object.hash(runtimeType,_this.start,_this.last,const DeepCollectionEquality().hash(_this.people));
}

@override
String toString() {
  final _this = this as ThreadRecord;
  return 'ThreadRecord(start: ${_this.start}, last: ${_this.last}, people: ${_this.people})';
}


}

/// @nodoc
abstract mixin class $ThreadRecordCopyWith<$Res>  {
  factory $ThreadRecordCopyWith(ThreadRecord value, $Res Function(ThreadRecord) _then) = _$ThreadRecordCopyWithImpl;
@useResult
$Res call({
 String start, String last, List<String> people
});




}
/// @nodoc
class _$ThreadRecordCopyWithImpl<$Res>
    implements $ThreadRecordCopyWith<$Res> {
  _$ThreadRecordCopyWithImpl(this._self, this._then);

  final ThreadRecord _self;
  final $Res Function(ThreadRecord) _then;

/// Create a copy of ThreadRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? last = null,Object? people = null,}) {
  return _then(ThreadRecord(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ThreadRecord].
extension ThreadRecordPatterns on ThreadRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThreadRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThreadRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThreadRecord value)  $default,){
final _that = this;
switch (_that) {
case _ThreadRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThreadRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ThreadRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String start,  String last,  List<String> people)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThreadRecord() when $default != null:
return $default(_that.start,_that.last,_that.people);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String start,  String last,  List<String> people)  $default,) {final _that = this;
switch (_that) {
case _ThreadRecord():
return $default(_that.start,_that.last,_that.people);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String start,  String last,  List<String> people)?  $default,) {final _that = this;
switch (_that) {
case _ThreadRecord() when $default != null:
return $default(_that.start,_that.last,_that.people);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ThreadRecord implements ThreadRecord {
  const _ThreadRecord({required this.start, required this.last,  List<String> people = const []}): _people = people;
  factory _ThreadRecord.fromJson(Map<String, dynamic> json) => _$ThreadRecordFromJson(json);

@override final  String start;
@override final  String last;
 final  List<String> _people;
@override@JsonKey() List<String> get people {
  if (_people is EqualUnmodifiableListView) return _people;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_people);
}


/// Create a copy of ThreadRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThreadRecordCopyWith<_ThreadRecord> get copyWith => __$ThreadRecordCopyWithImpl<_ThreadRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThreadRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThreadRecord&&(identical(other.start, start) || other.start == start)&&(identical(other.last, last) || other.last == last)&&const DeepCollectionEquality().equals(other.people, _people));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,start,last,const DeepCollectionEquality().hash(_people));
}

@override
String toString() {
    return 'ThreadRecord(start: $start, last: $last, people: $people)';
}


}

/// @nodoc
abstract mixin class _$ThreadRecordCopyWith<$Res> implements $ThreadRecordCopyWith<$Res> {
  factory _$ThreadRecordCopyWith(_ThreadRecord value, $Res Function(_ThreadRecord) _then) = __$ThreadRecordCopyWithImpl;
@override @useResult
$Res call({
 String start, String last, List<String> people
});




}
/// @nodoc
class __$ThreadRecordCopyWithImpl<$Res>
    implements _$ThreadRecordCopyWith<$Res> {
  __$ThreadRecordCopyWithImpl(this._self, this._then);

  final _ThreadRecord _self;
  final $Res Function(_ThreadRecord) _then;

/// Create a copy of ThreadRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? last = null,Object? people = null,}) {
  return _then(_ThreadRecord(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self._people : people // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$MrRecord {

 String get path; int get iid; String get title; String get url; String get author; MrRole get role; bool get draft; bool get conflicts;/// Head pipeline status, upper case. Empty when there is none.
 String get pipeline; List<String> get approvers; bool get approved; DateTime get createdAt; DateTime get updatedAt; List<ThreadRecord> get threads; String? get sha;/// Source branch: often names the ticket ("feat/AVPN-123").
 String get branch;
/// Create a copy of MrRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MrRecordCopyWith<MrRecord> get copyWith => _$MrRecordCopyWithImpl<MrRecord>(this as MrRecord, _$identity);

  /// Serializes this MrRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MrRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MrRecord&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.iid, _this.iid) || other.iid == _this.iid)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.conflicts, _this.conflicts) || other.conflicts == _this.conflicts)&&(identical(other.pipeline, _this.pipeline) || other.pipeline == _this.pipeline)&&const DeepCollectionEquality().equals(other.approvers, _this.approvers)&&(identical(other.approved, _this.approved) || other.approved == _this.approved)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.threads, _this.threads)&&(identical(other.sha, _this.sha) || other.sha == _this.sha)&&(identical(other.branch, _this.branch) || other.branch == _this.branch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MrRecord;
  return Object.hash(runtimeType,_this.path,_this.iid,_this.title,_this.url,_this.author,_this.role,_this.draft,_this.conflicts,_this.pipeline,const DeepCollectionEquality().hash(_this.approvers),_this.approved,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.threads),_this.sha,_this.branch);
}

@override
String toString() {
  final _this = this as MrRecord;
  return 'MrRecord(path: ${_this.path}, iid: ${_this.iid}, title: ${_this.title}, url: ${_this.url}, author: ${_this.author}, role: ${_this.role}, draft: ${_this.draft}, conflicts: ${_this.conflicts}, pipeline: ${_this.pipeline}, approvers: ${_this.approvers}, approved: ${_this.approved}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, threads: ${_this.threads}, sha: ${_this.sha}, branch: ${_this.branch})';
}


}

/// @nodoc
abstract mixin class $MrRecordCopyWith<$Res>  {
  factory $MrRecordCopyWith(MrRecord value, $Res Function(MrRecord) _then) = _$MrRecordCopyWithImpl;
@useResult
$Res call({
 String path, int iid, String title, String url, String author, MrRole role, bool draft, bool conflicts, String pipeline, List<String> approvers, bool approved, DateTime createdAt, DateTime updatedAt, List<ThreadRecord> threads, String? sha, String branch
});




}
/// @nodoc
class _$MrRecordCopyWithImpl<$Res>
    implements $MrRecordCopyWith<$Res> {
  _$MrRecordCopyWithImpl(this._self, this._then);

  final MrRecord _self;
  final $Res Function(MrRecord) _then;

/// Create a copy of MrRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? iid = null,Object? title = null,Object? url = null,Object? author = null,Object? role = null,Object? draft = null,Object? conflicts = null,Object? pipeline = null,Object? approvers = null,Object? approved = null,Object? createdAt = null,Object? updatedAt = null,Object? threads = null,Object? sha = freezed,Object? branch = null,}) {
  return _then(MrRecord(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,iid: null == iid ? _self.iid : iid // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MrRole,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as bool,pipeline: null == pipeline ? _self.pipeline : pipeline // ignore: cast_nullable_to_non_nullable
as String,approvers: null == approvers ? _self.approvers : approvers // ignore: cast_nullable_to_non_nullable
as List<String>,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,threads: null == threads ? _self.threads : threads // ignore: cast_nullable_to_non_nullable
as List<ThreadRecord>,sha: freezed == sha ? _self.sha : sha // ignore: cast_nullable_to_non_nullable
as String?,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MrRecord].
extension MrRecordPatterns on MrRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MrRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MrRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MrRecord value)  $default,){
final _that = this;
switch (_that) {
case _MrRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MrRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MrRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  int iid,  String title,  String url,  String author,  MrRole role,  bool draft,  bool conflicts,  String pipeline,  List<String> approvers,  bool approved,  DateTime createdAt,  DateTime updatedAt,  List<ThreadRecord> threads,  String? sha,  String branch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MrRecord() when $default != null:
return $default(_that.path,_that.iid,_that.title,_that.url,_that.author,_that.role,_that.draft,_that.conflicts,_that.pipeline,_that.approvers,_that.approved,_that.createdAt,_that.updatedAt,_that.threads,_that.sha,_that.branch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  int iid,  String title,  String url,  String author,  MrRole role,  bool draft,  bool conflicts,  String pipeline,  List<String> approvers,  bool approved,  DateTime createdAt,  DateTime updatedAt,  List<ThreadRecord> threads,  String? sha,  String branch)  $default,) {final _that = this;
switch (_that) {
case _MrRecord():
return $default(_that.path,_that.iid,_that.title,_that.url,_that.author,_that.role,_that.draft,_that.conflicts,_that.pipeline,_that.approvers,_that.approved,_that.createdAt,_that.updatedAt,_that.threads,_that.sha,_that.branch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  int iid,  String title,  String url,  String author,  MrRole role,  bool draft,  bool conflicts,  String pipeline,  List<String> approvers,  bool approved,  DateTime createdAt,  DateTime updatedAt,  List<ThreadRecord> threads,  String? sha,  String branch)?  $default,) {final _that = this;
switch (_that) {
case _MrRecord() when $default != null:
return $default(_that.path,_that.iid,_that.title,_that.url,_that.author,_that.role,_that.draft,_that.conflicts,_that.pipeline,_that.approvers,_that.approved,_that.createdAt,_that.updatedAt,_that.threads,_that.sha,_that.branch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MrRecord implements MrRecord {
  const _MrRecord({required this.path, required this.iid, required this.title, required this.url, required this.author, required this.role, this.draft = false, this.conflicts = false, this.pipeline = '',  List<String> approvers = const [], this.approved = false, required this.createdAt, required this.updatedAt,  List<ThreadRecord> threads = const [], this.sha, this.branch = ''}): _approvers = approvers,_threads = threads;
  factory _MrRecord.fromJson(Map<String, dynamic> json) => _$MrRecordFromJson(json);

@override final  String path;
@override final  int iid;
@override final  String title;
@override final  String url;
@override final  String author;
@override final  MrRole role;
@override@JsonKey() final  bool draft;
@override@JsonKey() final  bool conflicts;
/// Head pipeline status, upper case. Empty when there is none.
@override@JsonKey() final  String pipeline;
 final  List<String> _approvers;
@override@JsonKey() List<String> get approvers {
  if (_approvers is EqualUnmodifiableListView) return _approvers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_approvers);
}

@override@JsonKey() final  bool approved;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<ThreadRecord> _threads;
@override@JsonKey() List<ThreadRecord> get threads {
  if (_threads is EqualUnmodifiableListView) return _threads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_threads);
}

@override final  String? sha;
/// Source branch: often names the ticket ("feat/AVPN-123").
@override@JsonKey() final  String branch;

/// Create a copy of MrRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MrRecordCopyWith<_MrRecord> get copyWith => __$MrRecordCopyWithImpl<_MrRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MrRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MrRecord&&(identical(other.path, path) || other.path == path)&&(identical(other.iid, iid) || other.iid == iid)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.author, author) || other.author == author)&&(identical(other.role, role) || other.role == role)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.conflicts, conflicts) || other.conflicts == conflicts)&&(identical(other.pipeline, pipeline) || other.pipeline == pipeline)&&const DeepCollectionEquality().equals(other.approvers, _approvers)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.threads, _threads)&&(identical(other.sha, sha) || other.sha == sha)&&(identical(other.branch, branch) || other.branch == branch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,iid,title,url,author,role,draft,conflicts,pipeline,const DeepCollectionEquality().hash(_approvers),approved,createdAt,updatedAt,const DeepCollectionEquality().hash(_threads),sha,branch);
}

@override
String toString() {
    return 'MrRecord(path: $path, iid: $iid, title: $title, url: $url, author: $author, role: $role, draft: $draft, conflicts: $conflicts, pipeline: $pipeline, approvers: $approvers, approved: $approved, createdAt: $createdAt, updatedAt: $updatedAt, threads: $threads, sha: $sha, branch: $branch)';
}


}

/// @nodoc
abstract mixin class _$MrRecordCopyWith<$Res> implements $MrRecordCopyWith<$Res> {
  factory _$MrRecordCopyWith(_MrRecord value, $Res Function(_MrRecord) _then) = __$MrRecordCopyWithImpl;
@override @useResult
$Res call({
 String path, int iid, String title, String url, String author, MrRole role, bool draft, bool conflicts, String pipeline, List<String> approvers, bool approved, DateTime createdAt, DateTime updatedAt, List<ThreadRecord> threads, String? sha, String branch
});




}
/// @nodoc
class __$MrRecordCopyWithImpl<$Res>
    implements _$MrRecordCopyWith<$Res> {
  __$MrRecordCopyWithImpl(this._self, this._then);

  final _MrRecord _self;
  final $Res Function(_MrRecord) _then;

/// Create a copy of MrRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? iid = null,Object? title = null,Object? url = null,Object? author = null,Object? role = null,Object? draft = null,Object? conflicts = null,Object? pipeline = null,Object? approvers = null,Object? approved = null,Object? createdAt = null,Object? updatedAt = null,Object? threads = null,Object? sha = freezed,Object? branch = null,}) {
  return _then(_MrRecord(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,iid: null == iid ? _self.iid : iid // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MrRole,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as bool,pipeline: null == pipeline ? _self.pipeline : pipeline // ignore: cast_nullable_to_non_nullable
as String,approvers: null == approvers ? _self._approvers : approvers // ignore: cast_nullable_to_non_nullable
as List<String>,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,threads: null == threads ? _self._threads : threads // ignore: cast_nullable_to_non_nullable
as List<ThreadRecord>,sha: freezed == sha ? _self.sha : sha // ignore: cast_nullable_to_non_nullable
as String?,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CommentRecord {

 String? get author; bool get mine; DateTime get at;
/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentRecordCopyWith<CommentRecord> get copyWith => _$CommentRecordCopyWithImpl<CommentRecord>(this as CommentRecord, _$identity);

  /// Serializes this CommentRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CommentRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentRecord&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.mine, _this.mine) || other.mine == _this.mine)&&(identical(other.at, _this.at) || other.at == _this.at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CommentRecord;
  return Object.hash(runtimeType,_this.author,_this.mine,_this.at);
}

@override
String toString() {
  final _this = this as CommentRecord;
  return 'CommentRecord(author: ${_this.author}, mine: ${_this.mine}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $CommentRecordCopyWith<$Res>  {
  factory $CommentRecordCopyWith(CommentRecord value, $Res Function(CommentRecord) _then) = _$CommentRecordCopyWithImpl;
@useResult
$Res call({
 String? author, bool mine, DateTime at
});




}
/// @nodoc
class _$CommentRecordCopyWithImpl<$Res>
    implements $CommentRecordCopyWith<$Res> {
  _$CommentRecordCopyWithImpl(this._self, this._then);

  final CommentRecord _self;
  final $Res Function(CommentRecord) _then;

/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? author = freezed,Object? mine = null,Object? at = null,}) {
  return _then(CommentRecord(
author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentRecord].
extension CommentRecordPatterns on CommentRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentRecord value)  $default,){
final _that = this;
switch (_that) {
case _CommentRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CommentRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? author,  bool mine,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentRecord() when $default != null:
return $default(_that.author,_that.mine,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? author,  bool mine,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _CommentRecord():
return $default(_that.author,_that.mine,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? author,  bool mine,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _CommentRecord() when $default != null:
return $default(_that.author,_that.mine,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentRecord implements CommentRecord {
  const _CommentRecord({this.author, this.mine = false, required this.at});
  factory _CommentRecord.fromJson(Map<String, dynamic> json) => _$CommentRecordFromJson(json);

@override final  String? author;
@override@JsonKey() final  bool mine;
@override final  DateTime at;

/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentRecordCopyWith<_CommentRecord> get copyWith => __$CommentRecordCopyWithImpl<_CommentRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentRecord&&(identical(other.author, author) || other.author == author)&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,author,mine,at);
}

@override
String toString() {
    return 'CommentRecord(author: $author, mine: $mine, at: $at)';
}


}

/// @nodoc
abstract mixin class _$CommentRecordCopyWith<$Res> implements $CommentRecordCopyWith<$Res> {
  factory _$CommentRecordCopyWith(_CommentRecord value, $Res Function(_CommentRecord) _then) = __$CommentRecordCopyWithImpl;
@override @useResult
$Res call({
 String? author, bool mine, DateTime at
});




}
/// @nodoc
class __$CommentRecordCopyWithImpl<$Res>
    implements _$CommentRecordCopyWith<$Res> {
  __$CommentRecordCopyWithImpl(this._self, this._then);

  final _CommentRecord _self;
  final $Res Function(_CommentRecord) _then;

/// Create a copy of CommentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? author = freezed,Object? mine = null,Object? at = null,}) {
  return _then(_CommentRecord(
author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$IssueRecord {

 String get key; String get summary; String get url; String get status;/// Jira status category: new, indeterminate or done.
 String get statusCategory; String get type; DateTime? get created; DateTime? get updated; CommentRecord? get lastComment;
/// Create a copy of IssueRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueRecordCopyWith<IssueRecord> get copyWith => _$IssueRecordCopyWithImpl<IssueRecord>(this as IssueRecord, _$identity);

  /// Serializes this IssueRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IssueRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueRecord&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.statusCategory, _this.statusCategory) || other.statusCategory == _this.statusCategory)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.created, _this.created) || other.created == _this.created)&&(identical(other.updated, _this.updated) || other.updated == _this.updated)&&(identical(other.lastComment, _this.lastComment) || other.lastComment == _this.lastComment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IssueRecord;
  return Object.hash(runtimeType,_this.key,_this.summary,_this.url,_this.status,_this.statusCategory,_this.type,_this.created,_this.updated,_this.lastComment);
}

@override
String toString() {
  final _this = this as IssueRecord;
  return 'IssueRecord(key: ${_this.key}, summary: ${_this.summary}, url: ${_this.url}, status: ${_this.status}, statusCategory: ${_this.statusCategory}, type: ${_this.type}, created: ${_this.created}, updated: ${_this.updated}, lastComment: ${_this.lastComment})';
}


}

/// @nodoc
abstract mixin class $IssueRecordCopyWith<$Res>  {
  factory $IssueRecordCopyWith(IssueRecord value, $Res Function(IssueRecord) _then) = _$IssueRecordCopyWithImpl;
@useResult
$Res call({
 String key, String summary, String url, String status, String statusCategory, String type, DateTime? created, DateTime? updated, CommentRecord? lastComment
});


$CommentRecordCopyWith<$Res>? get lastComment;

}
/// @nodoc
class _$IssueRecordCopyWithImpl<$Res>
    implements $IssueRecordCopyWith<$Res> {
  _$IssueRecordCopyWithImpl(this._self, this._then);

  final IssueRecord _self;
  final $Res Function(IssueRecord) _then;

/// Create a copy of IssueRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? summary = null,Object? url = null,Object? status = null,Object? statusCategory = null,Object? type = null,Object? created = freezed,Object? updated = freezed,Object? lastComment = freezed,}) {
  return _then(IssueRecord(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusCategory: null == statusCategory ? _self.statusCategory : statusCategory // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime?,lastComment: freezed == lastComment ? _self.lastComment : lastComment // ignore: cast_nullable_to_non_nullable
as CommentRecord?,
  ));
}
/// Create a copy of IssueRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentRecordCopyWith<$Res>? get lastComment {
    if (_self.lastComment == null) {
    return null;
  }

  return $CommentRecordCopyWith<$Res>(_self.lastComment!, (value) {
    return _then(_self.copyWith(lastComment: value));
  });
}
}


/// Adds pattern-matching-related methods to [IssueRecord].
extension IssueRecordPatterns on IssueRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IssueRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IssueRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IssueRecord value)  $default,){
final _that = this;
switch (_that) {
case _IssueRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IssueRecord value)?  $default,){
final _that = this;
switch (_that) {
case _IssueRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String summary,  String url,  String status,  String statusCategory,  String type,  DateTime? created,  DateTime? updated,  CommentRecord? lastComment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IssueRecord() when $default != null:
return $default(_that.key,_that.summary,_that.url,_that.status,_that.statusCategory,_that.type,_that.created,_that.updated,_that.lastComment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String summary,  String url,  String status,  String statusCategory,  String type,  DateTime? created,  DateTime? updated,  CommentRecord? lastComment)  $default,) {final _that = this;
switch (_that) {
case _IssueRecord():
return $default(_that.key,_that.summary,_that.url,_that.status,_that.statusCategory,_that.type,_that.created,_that.updated,_that.lastComment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String summary,  String url,  String status,  String statusCategory,  String type,  DateTime? created,  DateTime? updated,  CommentRecord? lastComment)?  $default,) {final _that = this;
switch (_that) {
case _IssueRecord() when $default != null:
return $default(_that.key,_that.summary,_that.url,_that.status,_that.statusCategory,_that.type,_that.created,_that.updated,_that.lastComment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IssueRecord implements IssueRecord {
  const _IssueRecord({required this.key, required this.summary, required this.url, required this.status, required this.statusCategory, required this.type, this.created, this.updated, this.lastComment});
  factory _IssueRecord.fromJson(Map<String, dynamic> json) => _$IssueRecordFromJson(json);

@override final  String key;
@override final  String summary;
@override final  String url;
@override final  String status;
/// Jira status category: new, indeterminate or done.
@override final  String statusCategory;
@override final  String type;
@override final  DateTime? created;
@override final  DateTime? updated;
@override final  CommentRecord? lastComment;

/// Create a copy of IssueRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueRecordCopyWith<_IssueRecord> get copyWith => __$IssueRecordCopyWithImpl<_IssueRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IssueRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssueRecord&&(identical(other.key, key) || other.key == key)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.url, url) || other.url == url)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusCategory, statusCategory) || other.statusCategory == statusCategory)&&(identical(other.type, type) || other.type == type)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.lastComment, lastComment) || other.lastComment == lastComment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,summary,url,status,statusCategory,type,created,updated,lastComment);
}

@override
String toString() {
    return 'IssueRecord(key: $key, summary: $summary, url: $url, status: $status, statusCategory: $statusCategory, type: $type, created: $created, updated: $updated, lastComment: $lastComment)';
}


}

/// @nodoc
abstract mixin class _$IssueRecordCopyWith<$Res> implements $IssueRecordCopyWith<$Res> {
  factory _$IssueRecordCopyWith(_IssueRecord value, $Res Function(_IssueRecord) _then) = __$IssueRecordCopyWithImpl;
@override @useResult
$Res call({
 String key, String summary, String url, String status, String statusCategory, String type, DateTime? created, DateTime? updated, CommentRecord? lastComment
});


@override $CommentRecordCopyWith<$Res>? get lastComment;

}
/// @nodoc
class __$IssueRecordCopyWithImpl<$Res>
    implements _$IssueRecordCopyWith<$Res> {
  __$IssueRecordCopyWithImpl(this._self, this._then);

  final _IssueRecord _self;
  final $Res Function(_IssueRecord) _then;

/// Create a copy of IssueRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? summary = null,Object? url = null,Object? status = null,Object? statusCategory = null,Object? type = null,Object? created = freezed,Object? updated = freezed,Object? lastComment = freezed,}) {
  return _then(_IssueRecord(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusCategory: null == statusCategory ? _self.statusCategory : statusCategory // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime?,lastComment: freezed == lastComment ? _self.lastComment : lastComment // ignore: cast_nullable_to_non_nullable
as CommentRecord?,
  ));
}

/// Create a copy of IssueRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentRecordCopyWith<$Res>? get lastComment {
    if (_self.lastComment == null) {
    return null;
  }

  return $CommentRecordCopyWith<$Res>(_self.lastComment!, (value) {
    return _then(_self.copyWith(lastComment: value));
  });
}
}


/// @nodoc
mixin _$DocLink {

 String get url; String get title;
/// Create a copy of DocLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocLinkCopyWith<DocLink> get copyWith => _$DocLinkCopyWithImpl<DocLink>(this as DocLink, _$identity);

  /// Serializes this DocLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DocLink;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocLink&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.title, _this.title) || other.title == _this.title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DocLink;
  return Object.hash(runtimeType,_this.url,_this.title);
}

@override
String toString() {
  final _this = this as DocLink;
  return 'DocLink(url: ${_this.url}, title: ${_this.title})';
}


}

/// @nodoc
abstract mixin class $DocLinkCopyWith<$Res>  {
  factory $DocLinkCopyWith(DocLink value, $Res Function(DocLink) _then) = _$DocLinkCopyWithImpl;
@useResult
$Res call({
 String url, String title
});




}
/// @nodoc
class _$DocLinkCopyWithImpl<$Res>
    implements $DocLinkCopyWith<$Res> {
  _$DocLinkCopyWithImpl(this._self, this._then);

  final DocLink _self;
  final $Res Function(DocLink) _then;

/// Create a copy of DocLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? title = null,}) {
  return _then(DocLink(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DocLink].
extension DocLinkPatterns on DocLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocLink value)  $default,){
final _that = this;
switch (_that) {
case _DocLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocLink value)?  $default,){
final _that = this;
switch (_that) {
case _DocLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocLink() when $default != null:
return $default(_that.url,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String title)  $default,) {final _that = this;
switch (_that) {
case _DocLink():
return $default(_that.url,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String title)?  $default,) {final _that = this;
switch (_that) {
case _DocLink() when $default != null:
return $default(_that.url,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocLink implements DocLink {
  const _DocLink({required this.url, required this.title});
  factory _DocLink.fromJson(Map<String, dynamic> json) => _$DocLinkFromJson(json);

@override final  String url;
@override final  String title;

/// Create a copy of DocLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocLinkCopyWith<_DocLink> get copyWith => __$DocLinkCopyWithImpl<_DocLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocLinkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocLink&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,title);
}

@override
String toString() {
    return 'DocLink(url: $url, title: $title)';
}


}

/// @nodoc
abstract mixin class _$DocLinkCopyWith<$Res> implements $DocLinkCopyWith<$Res> {
  factory _$DocLinkCopyWith(_DocLink value, $Res Function(_DocLink) _then) = __$DocLinkCopyWithImpl;
@override @useResult
$Res call({
 String url, String title
});




}
/// @nodoc
class __$DocLinkCopyWithImpl<$Res>
    implements _$DocLinkCopyWith<$Res> {
  __$DocLinkCopyWithImpl(this._self, this._then);

  final _DocLink _self;
  final $Res Function(_DocLink) _then;

/// Create a copy of DocLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? title = null,}) {
  return _then(_DocLink(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MessageRecord {

 String get id; String get url; String? get from;/// "#channel", "DM", or the mail subject's sender.
 String? get where; DateTime get at; String get title;/// True when it asks the user to do, answer, review or decide something.
 bool get ask;/// One imperative line, only when ask is true.
 String? get need;/// True when the ask is work to do (fix, write, check), not only an answer.
/// A task stays open after the user replied.
 bool get task;/// True when the user already answered.
 bool get done; bool get urgent;/// The user answered and waits on the other side.
 bool get waiting; String? get project;/// Mail only: ask, fyi, noise or phishing. Null means ask decides.
 String? get kind;/// Only with project: one line of news about the project worth keeping
/// beyond this message (a date, a decision, who owns what, an open
/// question). It goes to the project's Overview.
 String? get lasting;/// Only with project: documents the message links to about the project
/// (a doc, a sheet, a dashboard, a design). They go to the project's
/// Overview, under Documents.
 List<DocLink> get docs;/// The item the message is about: "AVPN-65" (Jira), "vpn-ios!955"
/// (merge request), "vpn-android#12" (issue). An ask about a card already on
/// the board goes on that card instead of making one.
 String? get about;/// Slack only: a message in a project channel not aimed at the user, kept
/// because it is a bug report, request or question to the team. With an
/// [about] (an existing ticket tracks it), it makes no card.
 bool get team;
/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageRecordCopyWith<MessageRecord> get copyWith => _$MessageRecordCopyWithImpl<MessageRecord>(this as MessageRecord, _$identity);

  /// Serializes this MessageRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.where, _this.where) || other.where == _this.where)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.ask, _this.ask) || other.ask == _this.ask)&&(identical(other.need, _this.need) || other.need == _this.need)&&(identical(other.task, _this.task) || other.task == _this.task)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.urgent, _this.urgent) || other.urgent == _this.urgent)&&(identical(other.waiting, _this.waiting) || other.waiting == _this.waiting)&&(identical(other.project, _this.project) || other.project == _this.project)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.lasting, _this.lasting) || other.lasting == _this.lasting)&&const DeepCollectionEquality().equals(other.docs, _this.docs)&&(identical(other.about, _this.about) || other.about == _this.about)&&(identical(other.team, _this.team) || other.team == _this.team));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageRecord;
  return Object.hash(runtimeType,_this.id,_this.url,_this.from,_this.where,_this.at,_this.title,_this.ask,_this.need,_this.task,_this.done,_this.urgent,_this.waiting,_this.project,_this.kind,_this.lasting,const DeepCollectionEquality().hash(_this.docs),_this.about,_this.team);
}

@override
String toString() {
  final _this = this as MessageRecord;
  return 'MessageRecord(id: ${_this.id}, url: ${_this.url}, from: ${_this.from}, where: ${_this.where}, at: ${_this.at}, title: ${_this.title}, ask: ${_this.ask}, need: ${_this.need}, task: ${_this.task}, done: ${_this.done}, urgent: ${_this.urgent}, waiting: ${_this.waiting}, project: ${_this.project}, kind: ${_this.kind}, lasting: ${_this.lasting}, docs: ${_this.docs}, about: ${_this.about}, team: ${_this.team})';
}


}

/// @nodoc
abstract mixin class $MessageRecordCopyWith<$Res>  {
  factory $MessageRecordCopyWith(MessageRecord value, $Res Function(MessageRecord) _then) = _$MessageRecordCopyWithImpl;
@useResult
$Res call({
 String id, String url, String? from, String? where, DateTime at, String title, bool ask, String? need, bool task, bool done, bool urgent, bool waiting, String? project, String? kind, String? lasting, List<DocLink> docs, String? about, bool team
});




}
/// @nodoc
class _$MessageRecordCopyWithImpl<$Res>
    implements $MessageRecordCopyWith<$Res> {
  _$MessageRecordCopyWithImpl(this._self, this._then);

  final MessageRecord _self;
  final $Res Function(MessageRecord) _then;

/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? from = freezed,Object? where = freezed,Object? at = null,Object? title = null,Object? ask = null,Object? need = freezed,Object? task = null,Object? done = null,Object? urgent = null,Object? waiting = null,Object? project = freezed,Object? kind = freezed,Object? lasting = freezed,Object? docs = null,Object? about = freezed,Object? team = null,}) {
  return _then(MessageRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,where: freezed == where ? _self.where : where // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ask: null == ask ? _self.ask : ask // ignore: cast_nullable_to_non_nullable
as bool,need: freezed == need ? _self.need : need // ignore: cast_nullable_to_non_nullable
as String?,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as bool,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,urgent: null == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as bool,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as bool,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lasting: freezed == lasting ? _self.lasting : lasting // ignore: cast_nullable_to_non_nullable
as String?,docs: null == docs ? _self.docs : docs // ignore: cast_nullable_to_non_nullable
as List<DocLink>,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageRecord].
extension MessageRecordPatterns on MessageRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageRecord value)  $default,){
final _that = this;
switch (_that) {
case _MessageRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  String? from,  String? where,  DateTime at,  String title,  bool ask,  String? need,  bool task,  bool done,  bool urgent,  bool waiting,  String? project,  String? kind,  String? lasting,  List<DocLink> docs,  String? about,  bool team)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
return $default(_that.id,_that.url,_that.from,_that.where,_that.at,_that.title,_that.ask,_that.need,_that.task,_that.done,_that.urgent,_that.waiting,_that.project,_that.kind,_that.lasting,_that.docs,_that.about,_that.team);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  String? from,  String? where,  DateTime at,  String title,  bool ask,  String? need,  bool task,  bool done,  bool urgent,  bool waiting,  String? project,  String? kind,  String? lasting,  List<DocLink> docs,  String? about,  bool team)  $default,) {final _that = this;
switch (_that) {
case _MessageRecord():
return $default(_that.id,_that.url,_that.from,_that.where,_that.at,_that.title,_that.ask,_that.need,_that.task,_that.done,_that.urgent,_that.waiting,_that.project,_that.kind,_that.lasting,_that.docs,_that.about,_that.team);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  String? from,  String? where,  DateTime at,  String title,  bool ask,  String? need,  bool task,  bool done,  bool urgent,  bool waiting,  String? project,  String? kind,  String? lasting,  List<DocLink> docs,  String? about,  bool team)?  $default,) {final _that = this;
switch (_that) {
case _MessageRecord() when $default != null:
return $default(_that.id,_that.url,_that.from,_that.where,_that.at,_that.title,_that.ask,_that.need,_that.task,_that.done,_that.urgent,_that.waiting,_that.project,_that.kind,_that.lasting,_that.docs,_that.about,_that.team);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageRecord implements MessageRecord {
  const _MessageRecord({required this.id, required this.url, this.from, this.where, required this.at, required this.title, this.ask = false, this.need, this.task = false, this.done = false, this.urgent = false, this.waiting = false, this.project, this.kind, this.lasting,  List<DocLink> docs = const [], this.about, this.team = false}): _docs = docs;
  factory _MessageRecord.fromJson(Map<String, dynamic> json) => _$MessageRecordFromJson(json);

@override final  String id;
@override final  String url;
@override final  String? from;
/// "#channel", "DM", or the mail subject's sender.
@override final  String? where;
@override final  DateTime at;
@override final  String title;
/// True when it asks the user to do, answer, review or decide something.
@override@JsonKey() final  bool ask;
/// One imperative line, only when ask is true.
@override final  String? need;
/// True when the ask is work to do (fix, write, check), not only an answer.
/// A task stays open after the user replied.
@override@JsonKey() final  bool task;
/// True when the user already answered.
@override@JsonKey() final  bool done;
@override@JsonKey() final  bool urgent;
/// The user answered and waits on the other side.
@override@JsonKey() final  bool waiting;
@override final  String? project;
/// Mail only: ask, fyi, noise or phishing. Null means ask decides.
@override final  String? kind;
/// Only with project: one line of news about the project worth keeping
/// beyond this message (a date, a decision, who owns what, an open
/// question). It goes to the project's Overview.
@override final  String? lasting;
/// Only with project: documents the message links to about the project
/// (a doc, a sheet, a dashboard, a design). They go to the project's
/// Overview, under Documents.
 final  List<DocLink> _docs;
/// Only with project: documents the message links to about the project
/// (a doc, a sheet, a dashboard, a design). They go to the project's
/// Overview, under Documents.
@override@JsonKey() List<DocLink> get docs {
  if (_docs is EqualUnmodifiableListView) return _docs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_docs);
}

/// The item the message is about: "AVPN-65" (Jira), "vpn-ios!955"
/// (merge request), "vpn-android#12" (issue). An ask about a card already on
/// the board goes on that card instead of making one.
@override final  String? about;
/// Slack only: a message in a project channel not aimed at the user, kept
/// because it is a bug report, request or question to the team. With an
/// [about] (an existing ticket tracks it), it makes no card.
@override@JsonKey() final  bool team;

/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageRecordCopyWith<_MessageRecord> get copyWith => __$MessageRecordCopyWithImpl<_MessageRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.from, from) || other.from == from)&&(identical(other.where, where) || other.where == where)&&(identical(other.at, at) || other.at == at)&&(identical(other.title, title) || other.title == title)&&(identical(other.ask, ask) || other.ask == ask)&&(identical(other.need, need) || other.need == need)&&(identical(other.task, task) || other.task == task)&&(identical(other.done, done) || other.done == done)&&(identical(other.urgent, urgent) || other.urgent == urgent)&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.project, project) || other.project == project)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lasting, lasting) || other.lasting == lasting)&&const DeepCollectionEquality().equals(other.docs, _docs)&&(identical(other.about, about) || other.about == about)&&(identical(other.team, team) || other.team == team));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,url,from,where,at,title,ask,need,task,done,urgent,waiting,project,kind,lasting,const DeepCollectionEquality().hash(_docs),about,team);
}

@override
String toString() {
    return 'MessageRecord(id: $id, url: $url, from: $from, where: $where, at: $at, title: $title, ask: $ask, need: $need, task: $task, done: $done, urgent: $urgent, waiting: $waiting, project: $project, kind: $kind, lasting: $lasting, docs: $docs, about: $about, team: $team)';
}


}

/// @nodoc
abstract mixin class _$MessageRecordCopyWith<$Res> implements $MessageRecordCopyWith<$Res> {
  factory _$MessageRecordCopyWith(_MessageRecord value, $Res Function(_MessageRecord) _then) = __$MessageRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, String? from, String? where, DateTime at, String title, bool ask, String? need, bool task, bool done, bool urgent, bool waiting, String? project, String? kind, String? lasting, List<DocLink> docs, String? about, bool team
});




}
/// @nodoc
class __$MessageRecordCopyWithImpl<$Res>
    implements _$MessageRecordCopyWith<$Res> {
  __$MessageRecordCopyWithImpl(this._self, this._then);

  final _MessageRecord _self;
  final $Res Function(_MessageRecord) _then;

/// Create a copy of MessageRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? from = freezed,Object? where = freezed,Object? at = null,Object? title = null,Object? ask = null,Object? need = freezed,Object? task = null,Object? done = null,Object? urgent = null,Object? waiting = null,Object? project = freezed,Object? kind = freezed,Object? lasting = freezed,Object? docs = null,Object? about = freezed,Object? team = null,}) {
  return _then(_MessageRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,where: freezed == where ? _self.where : where // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ask: null == ask ? _self.ask : ask // ignore: cast_nullable_to_non_nullable
as bool,need: freezed == need ? _self.need : need // ignore: cast_nullable_to_non_nullable
as String?,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as bool,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,urgent: null == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as bool,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as bool,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lasting: freezed == lasting ? _self.lasting : lasting // ignore: cast_nullable_to_non_nullable
as String?,docs: null == docs ? _self._docs : docs // ignore: cast_nullable_to_non_nullable
as List<DocLink>,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EventRecord {

 String get id; String get title; DateTime get start; DateTime get end;/// The event in the calendar.
 String get url;/// Video call link (Meet, Zoom, Teams), when there is one.
 String? get join;/// True when the user accepted it or organizes it.
 bool get going; int get attendees;
/// Create a copy of EventRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventRecordCopyWith<EventRecord> get copyWith => _$EventRecordCopyWithImpl<EventRecord>(this as EventRecord, _$identity);

  /// Serializes this EventRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.join, _this.join) || other.join == _this.join)&&(identical(other.going, _this.going) || other.going == _this.going)&&(identical(other.attendees, _this.attendees) || other.attendees == _this.attendees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventRecord;
  return Object.hash(runtimeType,_this.id,_this.title,_this.start,_this.end,_this.url,_this.join,_this.going,_this.attendees);
}

@override
String toString() {
  final _this = this as EventRecord;
  return 'EventRecord(id: ${_this.id}, title: ${_this.title}, start: ${_this.start}, end: ${_this.end}, url: ${_this.url}, join: ${_this.join}, going: ${_this.going}, attendees: ${_this.attendees})';
}


}

/// @nodoc
abstract mixin class $EventRecordCopyWith<$Res>  {
  factory $EventRecordCopyWith(EventRecord value, $Res Function(EventRecord) _then) = _$EventRecordCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime start, DateTime end, String url, String? join, bool going, int attendees
});




}
/// @nodoc
class _$EventRecordCopyWithImpl<$Res>
    implements $EventRecordCopyWith<$Res> {
  _$EventRecordCopyWithImpl(this._self, this._then);

  final EventRecord _self;
  final $Res Function(EventRecord) _then;

/// Create a copy of EventRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? start = null,Object? end = null,Object? url = null,Object? join = freezed,Object? going = null,Object? attendees = null,}) {
  return _then(EventRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,join: freezed == join ? _self.join : join // ignore: cast_nullable_to_non_nullable
as String?,going: null == going ? _self.going : going // ignore: cast_nullable_to_non_nullable
as bool,attendees: null == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EventRecord].
extension EventRecordPatterns on EventRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventRecord value)  $default,){
final _that = this;
switch (_that) {
case _EventRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventRecord value)?  $default,){
final _that = this;
switch (_that) {
case _EventRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime start,  DateTime end,  String url,  String? join,  bool going,  int attendees)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventRecord() when $default != null:
return $default(_that.id,_that.title,_that.start,_that.end,_that.url,_that.join,_that.going,_that.attendees);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime start,  DateTime end,  String url,  String? join,  bool going,  int attendees)  $default,) {final _that = this;
switch (_that) {
case _EventRecord():
return $default(_that.id,_that.title,_that.start,_that.end,_that.url,_that.join,_that.going,_that.attendees);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime start,  DateTime end,  String url,  String? join,  bool going,  int attendees)?  $default,) {final _that = this;
switch (_that) {
case _EventRecord() when $default != null:
return $default(_that.id,_that.title,_that.start,_that.end,_that.url,_that.join,_that.going,_that.attendees);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventRecord implements EventRecord {
  const _EventRecord({required this.id, required this.title, required this.start, required this.end, this.url = '', this.join, this.going = false, this.attendees = 0});
  factory _EventRecord.fromJson(Map<String, dynamic> json) => _$EventRecordFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime start;
@override final  DateTime end;
/// The event in the calendar.
@override@JsonKey() final  String url;
/// Video call link (Meet, Zoom, Teams), when there is one.
@override final  String? join;
/// True when the user accepted it or organizes it.
@override@JsonKey() final  bool going;
@override@JsonKey() final  int attendees;

/// Create a copy of EventRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventRecordCopyWith<_EventRecord> get copyWith => __$EventRecordCopyWithImpl<_EventRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.url, url) || other.url == url)&&(identical(other.join, join) || other.join == join)&&(identical(other.going, going) || other.going == going)&&(identical(other.attendees, attendees) || other.attendees == attendees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,start,end,url,join,going,attendees);
}

@override
String toString() {
    return 'EventRecord(id: $id, title: $title, start: $start, end: $end, url: $url, join: $join, going: $going, attendees: $attendees)';
}


}

/// @nodoc
abstract mixin class _$EventRecordCopyWith<$Res> implements $EventRecordCopyWith<$Res> {
  factory _$EventRecordCopyWith(_EventRecord value, $Res Function(_EventRecord) _then) = __$EventRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime start, DateTime end, String url, String? join, bool going, int attendees
});




}
/// @nodoc
class __$EventRecordCopyWithImpl<$Res>
    implements _$EventRecordCopyWith<$Res> {
  __$EventRecordCopyWithImpl(this._self, this._then);

  final _EventRecord _self;
  final $Res Function(_EventRecord) _then;

/// Create a copy of EventRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? start = null,Object? end = null,Object? url = null,Object? join = freezed,Object? going = null,Object? attendees = null,}) {
  return _then(_EventRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,join: freezed == join ? _self.join : join // ignore: cast_nullable_to_non_nullable
as String?,going: null == going ? _self.going : going // ignore: cast_nullable_to_non_nullable
as bool,attendees: null == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
