// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Anchor {

 String get path;/// new or old.
 String get side;@JsonKey(name: 'hunk_ref') String get hunkRef; int get line; int get endLine;@JsonKey(name: 'content_hash') String get contentHash;
/// Create a copy of Anchor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnchorCopyWith<Anchor> get copyWith => _$AnchorCopyWithImpl<Anchor>(this as Anchor, _$identity);

  /// Serializes this Anchor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Anchor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Anchor&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.side, _this.side) || other.side == _this.side)&&(identical(other.hunkRef, _this.hunkRef) || other.hunkRef == _this.hunkRef)&&(identical(other.line, _this.line) || other.line == _this.line)&&(identical(other.endLine, _this.endLine) || other.endLine == _this.endLine)&&(identical(other.contentHash, _this.contentHash) || other.contentHash == _this.contentHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Anchor;
  return Object.hash(runtimeType,_this.path,_this.side,_this.hunkRef,_this.line,_this.endLine,_this.contentHash);
}

@override
String toString() {
  final _this = this as Anchor;
  return 'Anchor(path: ${_this.path}, side: ${_this.side}, hunkRef: ${_this.hunkRef}, line: ${_this.line}, endLine: ${_this.endLine}, contentHash: ${_this.contentHash})';
}


}

/// @nodoc
abstract mixin class $AnchorCopyWith<$Res>  {
  factory $AnchorCopyWith(Anchor value, $Res Function(Anchor) _then) = _$AnchorCopyWithImpl;
@useResult
$Res call({
 String path, String side,@JsonKey(name: 'hunk_ref') String hunkRef, int line, int endLine,@JsonKey(name: 'content_hash') String contentHash
});




}
/// @nodoc
class _$AnchorCopyWithImpl<$Res>
    implements $AnchorCopyWith<$Res> {
  _$AnchorCopyWithImpl(this._self, this._then);

  final Anchor _self;
  final $Res Function(Anchor) _then;

/// Create a copy of Anchor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? side = null,Object? hunkRef = null,Object? line = null,Object? endLine = null,Object? contentHash = null,}) {
  return _then(Anchor(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String,hunkRef: null == hunkRef ? _self.hunkRef : hunkRef // ignore: cast_nullable_to_non_nullable
as String,line: null == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int,endLine: null == endLine ? _self.endLine : endLine // ignore: cast_nullable_to_non_nullable
as int,contentHash: null == contentHash ? _self.contentHash : contentHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Anchor].
extension AnchorPatterns on Anchor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Anchor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Anchor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Anchor value)  $default,){
final _that = this;
switch (_that) {
case _Anchor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Anchor value)?  $default,){
final _that = this;
switch (_that) {
case _Anchor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String side, @JsonKey(name: 'hunk_ref')  String hunkRef,  int line,  int endLine, @JsonKey(name: 'content_hash')  String contentHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Anchor() when $default != null:
return $default(_that.path,_that.side,_that.hunkRef,_that.line,_that.endLine,_that.contentHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String side, @JsonKey(name: 'hunk_ref')  String hunkRef,  int line,  int endLine, @JsonKey(name: 'content_hash')  String contentHash)  $default,) {final _that = this;
switch (_that) {
case _Anchor():
return $default(_that.path,_that.side,_that.hunkRef,_that.line,_that.endLine,_that.contentHash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String side, @JsonKey(name: 'hunk_ref')  String hunkRef,  int line,  int endLine, @JsonKey(name: 'content_hash')  String contentHash)?  $default,) {final _that = this;
switch (_that) {
case _Anchor() when $default != null:
return $default(_that.path,_that.side,_that.hunkRef,_that.line,_that.endLine,_that.contentHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Anchor implements Anchor {
  const _Anchor({required this.path, this.side = 'new', @JsonKey(name: 'hunk_ref') required this.hunkRef, required this.line, required this.endLine, @JsonKey(name: 'content_hash') required this.contentHash});
  factory _Anchor.fromJson(Map<String, dynamic> json) => _$AnchorFromJson(json);

@override final  String path;
/// new or old.
@override@JsonKey() final  String side;
@override@JsonKey(name: 'hunk_ref') final  String hunkRef;
@override final  int line;
@override final  int endLine;
@override@JsonKey(name: 'content_hash') final  String contentHash;

/// Create a copy of Anchor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnchorCopyWith<_Anchor> get copyWith => __$AnchorCopyWithImpl<_Anchor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnchorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Anchor&&(identical(other.path, path) || other.path == path)&&(identical(other.side, side) || other.side == side)&&(identical(other.hunkRef, hunkRef) || other.hunkRef == hunkRef)&&(identical(other.line, line) || other.line == line)&&(identical(other.endLine, endLine) || other.endLine == endLine)&&(identical(other.contentHash, contentHash) || other.contentHash == contentHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,side,hunkRef,line,endLine,contentHash);
}

@override
String toString() {
    return 'Anchor(path: $path, side: $side, hunkRef: $hunkRef, line: $line, endLine: $endLine, contentHash: $contentHash)';
}


}

/// @nodoc
abstract mixin class _$AnchorCopyWith<$Res> implements $AnchorCopyWith<$Res> {
  factory _$AnchorCopyWith(_Anchor value, $Res Function(_Anchor) _then) = __$AnchorCopyWithImpl;
@override @useResult
$Res call({
 String path, String side,@JsonKey(name: 'hunk_ref') String hunkRef, int line, int endLine,@JsonKey(name: 'content_hash') String contentHash
});




}
/// @nodoc
class __$AnchorCopyWithImpl<$Res>
    implements _$AnchorCopyWith<$Res> {
  __$AnchorCopyWithImpl(this._self, this._then);

  final _Anchor _self;
  final $Res Function(_Anchor) _then;

/// Create a copy of Anchor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? side = null,Object? hunkRef = null,Object? line = null,Object? endLine = null,Object? contentHash = null,}) {
  return _then(_Anchor(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String,hunkRef: null == hunkRef ? _self.hunkRef : hunkRef // ignore: cast_nullable_to_non_nullable
as String,line: null == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int,endLine: null == endLine ? _self.endLine : endLine // ignore: cast_nullable_to_non_nullable
as int,contentHash: null == contentHash ? _self.contentHash : contentHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Message {

 String get id; String get author; String get body;/// Replacement text for the anchored lines, posted as a suggestion.
 String? get suggestion; String? get remoteId; String get createdAt;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Message;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.suggestion, _this.suggestion) || other.suggestion == _this.suggestion)&&(identical(other.remoteId, _this.remoteId) || other.remoteId == _this.remoteId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Message;
  return Object.hash(runtimeType,_this.id,_this.author,_this.body,_this.suggestion,_this.remoteId,_this.createdAt);
}

@override
String toString() {
  final _this = this as Message;
  return 'Message(id: ${_this.id}, author: ${_this.author}, body: ${_this.body}, suggestion: ${_this.suggestion}, remoteId: ${_this.remoteId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String id, String author, String body, String? suggestion, String? remoteId, String createdAt
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? body = null,Object? suggestion = freezed,Object? remoteId = freezed,Object? createdAt = null,}) {
  return _then(Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as String?,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String author,  String body,  String? suggestion,  String? remoteId,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.author,_that.body,_that.suggestion,_that.remoteId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String author,  String body,  String? suggestion,  String? remoteId,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.author,_that.body,_that.suggestion,_that.remoteId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String author,  String body,  String? suggestion,  String? remoteId,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.author,_that.body,_that.suggestion,_that.remoteId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({required this.id, required this.author, required this.body, this.suggestion, this.remoteId, this.createdAt = ''});
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String id;
@override final  String author;
@override final  String body;
/// Replacement text for the anchored lines, posted as a suggestion.
@override final  String? suggestion;
@override final  String? remoteId;
@override@JsonKey() final  String createdAt;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.body, body) || other.body == body)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,author,body,suggestion,remoteId,createdAt);
}

@override
String toString() {
    return 'Message(id: $id, author: $author, body: $body, suggestion: $suggestion, remoteId: $remoteId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String author, String body, String? suggestion, String? remoteId, String createdAt
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? body = null,Object? suggestion = freezed,Object? remoteId = freezed,Object? createdAt = null,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as String?,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Thread {

 String get id;/// Null for a thread about the whole change.
 Anchor? get anchor; String get severity; String get state; String get authorType; String? get remoteId; String? get roundId; String get createdAt; String get updatedAt;/// What was posted (remote id set, or written on the forge) and the talk
/// with Claude (never posted), oldest first.
 List<Message> get messages;/// The one message the next publish posts: the opening note of a thread
/// not on the forge yet, a reply on one that is. Claude writes it, the
/// user may edit it. Null: nothing goes out.
 Message? get answer;/// The user asked Claude something on it and Claude has not answered yet.
 bool get waiting;/// The user's call on the answer: accept (it goes out on the next
/// publish) or reject (nothing goes out). Null: not decided yet. A new
/// answer from Claude clears it, so the user reads the new text.
 String? get decision;/// The commit that fixes it, or `uncommitted` when the change is in the
/// fix worktree but could not be committed.
 String? get fix;/// The commit that undid [fix] on the branch: a Reject of a fix with
/// commits on top that could not leave without them.
 String? get fixRevert;
/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadCopyWith<Thread> get copyWith => _$ThreadCopyWithImpl<Thread>(this as Thread, _$identity);

  /// Serializes this Thread to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Thread;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Thread&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.anchor, _this.anchor) || other.anchor == _this.anchor)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.authorType, _this.authorType) || other.authorType == _this.authorType)&&(identical(other.remoteId, _this.remoteId) || other.remoteId == _this.remoteId)&&(identical(other.roundId, _this.roundId) || other.roundId == _this.roundId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&(identical(other.answer, _this.answer) || other.answer == _this.answer)&&(identical(other.waiting, _this.waiting) || other.waiting == _this.waiting)&&(identical(other.decision, _this.decision) || other.decision == _this.decision)&&(identical(other.fix, _this.fix) || other.fix == _this.fix)&&(identical(other.fixRevert, _this.fixRevert) || other.fixRevert == _this.fixRevert));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Thread;
  return Object.hash(runtimeType,_this.id,_this.anchor,_this.severity,_this.state,_this.authorType,_this.remoteId,_this.roundId,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.messages),_this.answer,_this.waiting,_this.decision,_this.fix,_this.fixRevert);
}

@override
String toString() {
  final _this = this as Thread;
  return 'Thread(id: ${_this.id}, anchor: ${_this.anchor}, severity: ${_this.severity}, state: ${_this.state}, authorType: ${_this.authorType}, remoteId: ${_this.remoteId}, roundId: ${_this.roundId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, messages: ${_this.messages}, answer: ${_this.answer}, waiting: ${_this.waiting}, decision: ${_this.decision}, fix: ${_this.fix}, fixRevert: ${_this.fixRevert})';
}


}

/// @nodoc
abstract mixin class $ThreadCopyWith<$Res>  {
  factory $ThreadCopyWith(Thread value, $Res Function(Thread) _then) = _$ThreadCopyWithImpl;
@useResult
$Res call({
 String id, Anchor? anchor, String severity, String state, String authorType, String? remoteId, String? roundId, String createdAt, String updatedAt, List<Message> messages, Message? answer, bool waiting, String? decision, String? fix, String? fixRevert
});


$AnchorCopyWith<$Res>? get anchor;$MessageCopyWith<$Res>? get answer;

}
/// @nodoc
class _$ThreadCopyWithImpl<$Res>
    implements $ThreadCopyWith<$Res> {
  _$ThreadCopyWithImpl(this._self, this._then);

  final Thread _self;
  final $Res Function(Thread) _then;

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? anchor = freezed,Object? severity = null,Object? state = null,Object? authorType = null,Object? remoteId = freezed,Object? roundId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? messages = null,Object? answer = freezed,Object? waiting = null,Object? decision = freezed,Object? fix = freezed,Object? fixRevert = freezed,}) {
  return _then(Thread(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as Anchor?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,authorType: null == authorType ? _self.authorType : authorType // ignore: cast_nullable_to_non_nullable
as String,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,roundId: freezed == roundId ? _self.roundId : roundId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Message?,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as bool,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,fix: freezed == fix ? _self.fix : fix // ignore: cast_nullable_to_non_nullable
as String?,fixRevert: freezed == fixRevert ? _self.fixRevert : fixRevert // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnchorCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $AnchorCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res>? get answer {
    if (_self.answer == null) {
    return null;
  }

  return $MessageCopyWith<$Res>(_self.answer!, (value) {
    return _then(_self.copyWith(answer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Thread].
extension ThreadPatterns on Thread {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Thread value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Thread() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Thread value)  $default,){
final _that = this;
switch (_that) {
case _Thread():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Thread value)?  $default,){
final _that = this;
switch (_that) {
case _Thread() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Anchor? anchor,  String severity,  String state,  String authorType,  String? remoteId,  String? roundId,  String createdAt,  String updatedAt,  List<Message> messages,  Message? answer,  bool waiting,  String? decision,  String? fix,  String? fixRevert)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Thread() when $default != null:
return $default(_that.id,_that.anchor,_that.severity,_that.state,_that.authorType,_that.remoteId,_that.roundId,_that.createdAt,_that.updatedAt,_that.messages,_that.answer,_that.waiting,_that.decision,_that.fix,_that.fixRevert);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Anchor? anchor,  String severity,  String state,  String authorType,  String? remoteId,  String? roundId,  String createdAt,  String updatedAt,  List<Message> messages,  Message? answer,  bool waiting,  String? decision,  String? fix,  String? fixRevert)  $default,) {final _that = this;
switch (_that) {
case _Thread():
return $default(_that.id,_that.anchor,_that.severity,_that.state,_that.authorType,_that.remoteId,_that.roundId,_that.createdAt,_that.updatedAt,_that.messages,_that.answer,_that.waiting,_that.decision,_that.fix,_that.fixRevert);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Anchor? anchor,  String severity,  String state,  String authorType,  String? remoteId,  String? roundId,  String createdAt,  String updatedAt,  List<Message> messages,  Message? answer,  bool waiting,  String? decision,  String? fix,  String? fixRevert)?  $default,) {final _that = this;
switch (_that) {
case _Thread() when $default != null:
return $default(_that.id,_that.anchor,_that.severity,_that.state,_that.authorType,_that.remoteId,_that.roundId,_that.createdAt,_that.updatedAt,_that.messages,_that.answer,_that.waiting,_that.decision,_that.fix,_that.fixRevert);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Thread implements Thread {
  const _Thread({required this.id, this.anchor, required this.severity, required this.state, required this.authorType, this.remoteId, this.roundId, this.createdAt = '', this.updatedAt = '',  List<Message> messages = const [], this.answer, this.waiting = false, this.decision, this.fix, this.fixRevert}): _messages = messages;
  factory _Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);

@override final  String id;
/// Null for a thread about the whole change.
@override final  Anchor? anchor;
@override final  String severity;
@override final  String state;
@override final  String authorType;
@override final  String? remoteId;
@override final  String? roundId;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  String updatedAt;
/// What was posted (remote id set, or written on the forge) and the talk
/// with Claude (never posted), oldest first.
 final  List<Message> _messages;
/// What was posted (remote id set, or written on the forge) and the talk
/// with Claude (never posted), oldest first.
@override@JsonKey() List<Message> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

/// The one message the next publish posts: the opening note of a thread
/// not on the forge yet, a reply on one that is. Claude writes it, the
/// user may edit it. Null: nothing goes out.
@override final  Message? answer;
/// The user asked Claude something on it and Claude has not answered yet.
@override@JsonKey() final  bool waiting;
/// The user's call on the answer: accept (it goes out on the next
/// publish) or reject (nothing goes out). Null: not decided yet. A new
/// answer from Claude clears it, so the user reads the new text.
@override final  String? decision;
/// The commit that fixes it, or `uncommitted` when the change is in the
/// fix worktree but could not be committed.
@override final  String? fix;
/// The commit that undid [fix] on the branch: a Reject of a fix with
/// commits on top that could not leave without them.
@override final  String? fixRevert;

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThreadCopyWith<_Thread> get copyWith => __$ThreadCopyWithImpl<_Thread>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThreadToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Thread&&(identical(other.id, id) || other.id == id)&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.state, state) || other.state == state)&&(identical(other.authorType, authorType) || other.authorType == authorType)&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.roundId, roundId) || other.roundId == roundId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.messages, _messages)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.fix, fix) || other.fix == fix)&&(identical(other.fixRevert, fixRevert) || other.fixRevert == fixRevert));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,anchor,severity,state,authorType,remoteId,roundId,createdAt,updatedAt,const DeepCollectionEquality().hash(_messages),answer,waiting,decision,fix,fixRevert);
}

@override
String toString() {
    return 'Thread(id: $id, anchor: $anchor, severity: $severity, state: $state, authorType: $authorType, remoteId: $remoteId, roundId: $roundId, createdAt: $createdAt, updatedAt: $updatedAt, messages: $messages, answer: $answer, waiting: $waiting, decision: $decision, fix: $fix, fixRevert: $fixRevert)';
}


}

/// @nodoc
abstract mixin class _$ThreadCopyWith<$Res> implements $ThreadCopyWith<$Res> {
  factory _$ThreadCopyWith(_Thread value, $Res Function(_Thread) _then) = __$ThreadCopyWithImpl;
@override @useResult
$Res call({
 String id, Anchor? anchor, String severity, String state, String authorType, String? remoteId, String? roundId, String createdAt, String updatedAt, List<Message> messages, Message? answer, bool waiting, String? decision, String? fix, String? fixRevert
});


@override $AnchorCopyWith<$Res>? get anchor;@override $MessageCopyWith<$Res>? get answer;

}
/// @nodoc
class __$ThreadCopyWithImpl<$Res>
    implements _$ThreadCopyWith<$Res> {
  __$ThreadCopyWithImpl(this._self, this._then);

  final _Thread _self;
  final $Res Function(_Thread) _then;

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? anchor = freezed,Object? severity = null,Object? state = null,Object? authorType = null,Object? remoteId = freezed,Object? roundId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? messages = null,Object? answer = freezed,Object? waiting = null,Object? decision = freezed,Object? fix = freezed,Object? fixRevert = freezed,}) {
  return _then(_Thread(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as Anchor?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,authorType: null == authorType ? _self.authorType : authorType // ignore: cast_nullable_to_non_nullable
as String,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,roundId: freezed == roundId ? _self.roundId : roundId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Message?,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as bool,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,fix: freezed == fix ? _self.fix : fix // ignore: cast_nullable_to_non_nullable
as String?,fixRevert: freezed == fixRevert ? _self.fixRevert : fixRevert // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnchorCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $AnchorCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}/// Create a copy of Thread
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res>? get answer {
    if (_self.answer == null) {
    return null;
  }

  return $MessageCopyWith<$Res>(_self.answer!, (value) {
    return _then(_self.copyWith(answer: value));
  });
}
}


/// @nodoc
mixin _$Round {

 String get id; int get number; String get baseSha; String get headSha; String? get verdict; String? get publishedAt;/// The summary note on the forge, once posted.
 String? get remoteNoteId; String get createdAt;
/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundCopyWith<Round> get copyWith => _$RoundCopyWithImpl<Round>(this as Round, _$identity);

  /// Serializes this Round to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Round;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Round&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.baseSha, _this.baseSha) || other.baseSha == _this.baseSha)&&(identical(other.headSha, _this.headSha) || other.headSha == _this.headSha)&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.remoteNoteId, _this.remoteNoteId) || other.remoteNoteId == _this.remoteNoteId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Round;
  return Object.hash(runtimeType,_this.id,_this.number,_this.baseSha,_this.headSha,_this.verdict,_this.publishedAt,_this.remoteNoteId,_this.createdAt);
}

@override
String toString() {
  final _this = this as Round;
  return 'Round(id: ${_this.id}, number: ${_this.number}, baseSha: ${_this.baseSha}, headSha: ${_this.headSha}, verdict: ${_this.verdict}, publishedAt: ${_this.publishedAt}, remoteNoteId: ${_this.remoteNoteId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $RoundCopyWith<$Res>  {
  factory $RoundCopyWith(Round value, $Res Function(Round) _then) = _$RoundCopyWithImpl;
@useResult
$Res call({
 String id, int number, String baseSha, String headSha, String? verdict, String? publishedAt, String? remoteNoteId, String createdAt
});




}
/// @nodoc
class _$RoundCopyWithImpl<$Res>
    implements $RoundCopyWith<$Res> {
  _$RoundCopyWithImpl(this._self, this._then);

  final Round _self;
  final $Res Function(Round) _then;

/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? baseSha = null,Object? headSha = null,Object? verdict = freezed,Object? publishedAt = freezed,Object? remoteNoteId = freezed,Object? createdAt = null,}) {
  return _then(Round(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,baseSha: null == baseSha ? _self.baseSha : baseSha // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,remoteNoteId: freezed == remoteNoteId ? _self.remoteNoteId : remoteNoteId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Round].
extension RoundPatterns on Round {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Round value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Round() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Round value)  $default,){
final _that = this;
switch (_that) {
case _Round():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Round value)?  $default,){
final _that = this;
switch (_that) {
case _Round() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String baseSha,  String headSha,  String? verdict,  String? publishedAt,  String? remoteNoteId,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Round() when $default != null:
return $default(_that.id,_that.number,_that.baseSha,_that.headSha,_that.verdict,_that.publishedAt,_that.remoteNoteId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String baseSha,  String headSha,  String? verdict,  String? publishedAt,  String? remoteNoteId,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _Round():
return $default(_that.id,_that.number,_that.baseSha,_that.headSha,_that.verdict,_that.publishedAt,_that.remoteNoteId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String baseSha,  String headSha,  String? verdict,  String? publishedAt,  String? remoteNoteId,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Round() when $default != null:
return $default(_that.id,_that.number,_that.baseSha,_that.headSha,_that.verdict,_that.publishedAt,_that.remoteNoteId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Round implements Round {
  const _Round({required this.id, required this.number, required this.baseSha, required this.headSha, this.verdict, this.publishedAt, this.remoteNoteId, this.createdAt = ''});
  factory _Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

@override final  String id;
@override final  int number;
@override final  String baseSha;
@override final  String headSha;
@override final  String? verdict;
@override final  String? publishedAt;
/// The summary note on the forge, once posted.
@override final  String? remoteNoteId;
@override@JsonKey() final  String createdAt;

/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoundCopyWith<_Round> get copyWith => __$RoundCopyWithImpl<_Round>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoundToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Round&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.baseSha, baseSha) || other.baseSha == baseSha)&&(identical(other.headSha, headSha) || other.headSha == headSha)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.remoteNoteId, remoteNoteId) || other.remoteNoteId == remoteNoteId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,number,baseSha,headSha,verdict,publishedAt,remoteNoteId,createdAt);
}

@override
String toString() {
    return 'Round(id: $id, number: $number, baseSha: $baseSha, headSha: $headSha, verdict: $verdict, publishedAt: $publishedAt, remoteNoteId: $remoteNoteId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RoundCopyWith<$Res> implements $RoundCopyWith<$Res> {
  factory _$RoundCopyWith(_Round value, $Res Function(_Round) _then) = __$RoundCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String baseSha, String headSha, String? verdict, String? publishedAt, String? remoteNoteId, String createdAt
});




}
/// @nodoc
class __$RoundCopyWithImpl<$Res>
    implements _$RoundCopyWith<$Res> {
  __$RoundCopyWithImpl(this._self, this._then);

  final _Round _self;
  final $Res Function(_Round) _then;

/// Create a copy of Round
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? baseSha = null,Object? headSha = null,Object? verdict = freezed,Object? publishedAt = freezed,Object? remoteNoteId = freezed,Object? createdAt = null,}) {
  return _then(_Round(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,baseSha: null == baseSha ? _self.baseSha : baseSha // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,remoteNoteId: freezed == remoteNoteId ? _self.remoteNoteId : remoteNoteId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DiffRefs {

 String get baseSha; String get startSha; String get headSha;
/// Create a copy of DiffRefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiffRefsCopyWith<DiffRefs> get copyWith => _$DiffRefsCopyWithImpl<DiffRefs>(this as DiffRefs, _$identity);

  /// Serializes this DiffRefs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiffRefs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiffRefs&&(identical(other.baseSha, _this.baseSha) || other.baseSha == _this.baseSha)&&(identical(other.startSha, _this.startSha) || other.startSha == _this.startSha)&&(identical(other.headSha, _this.headSha) || other.headSha == _this.headSha));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiffRefs;
  return Object.hash(runtimeType,_this.baseSha,_this.startSha,_this.headSha);
}

@override
String toString() {
  final _this = this as DiffRefs;
  return 'DiffRefs(baseSha: ${_this.baseSha}, startSha: ${_this.startSha}, headSha: ${_this.headSha})';
}


}

/// @nodoc
abstract mixin class $DiffRefsCopyWith<$Res>  {
  factory $DiffRefsCopyWith(DiffRefs value, $Res Function(DiffRefs) _then) = _$DiffRefsCopyWithImpl;
@useResult
$Res call({
 String baseSha, String startSha, String headSha
});




}
/// @nodoc
class _$DiffRefsCopyWithImpl<$Res>
    implements $DiffRefsCopyWith<$Res> {
  _$DiffRefsCopyWithImpl(this._self, this._then);

  final DiffRefs _self;
  final $Res Function(DiffRefs) _then;

/// Create a copy of DiffRefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseSha = null,Object? startSha = null,Object? headSha = null,}) {
  return _then(DiffRefs(
baseSha: null == baseSha ? _self.baseSha : baseSha // ignore: cast_nullable_to_non_nullable
as String,startSha: null == startSha ? _self.startSha : startSha // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiffRefs].
extension DiffRefsPatterns on DiffRefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiffRefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiffRefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiffRefs value)  $default,){
final _that = this;
switch (_that) {
case _DiffRefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiffRefs value)?  $default,){
final _that = this;
switch (_that) {
case _DiffRefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String baseSha,  String startSha,  String headSha)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiffRefs() when $default != null:
return $default(_that.baseSha,_that.startSha,_that.headSha);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String baseSha,  String startSha,  String headSha)  $default,) {final _that = this;
switch (_that) {
case _DiffRefs():
return $default(_that.baseSha,_that.startSha,_that.headSha);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String baseSha,  String startSha,  String headSha)?  $default,) {final _that = this;
switch (_that) {
case _DiffRefs() when $default != null:
return $default(_that.baseSha,_that.startSha,_that.headSha);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiffRefs implements DiffRefs {
  const _DiffRefs({this.baseSha = '', this.startSha = '', this.headSha = ''});
  factory _DiffRefs.fromJson(Map<String, dynamic> json) => _$DiffRefsFromJson(json);

@override@JsonKey() final  String baseSha;
@override@JsonKey() final  String startSha;
@override@JsonKey() final  String headSha;

/// Create a copy of DiffRefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiffRefsCopyWith<_DiffRefs> get copyWith => __$DiffRefsCopyWithImpl<_DiffRefs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiffRefsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiffRefs&&(identical(other.baseSha, baseSha) || other.baseSha == baseSha)&&(identical(other.startSha, startSha) || other.startSha == startSha)&&(identical(other.headSha, headSha) || other.headSha == headSha));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,baseSha,startSha,headSha);
}

@override
String toString() {
    return 'DiffRefs(baseSha: $baseSha, startSha: $startSha, headSha: $headSha)';
}


}

/// @nodoc
abstract mixin class _$DiffRefsCopyWith<$Res> implements $DiffRefsCopyWith<$Res> {
  factory _$DiffRefsCopyWith(_DiffRefs value, $Res Function(_DiffRefs) _then) = __$DiffRefsCopyWithImpl;
@override @useResult
$Res call({
 String baseSha, String startSha, String headSha
});




}
/// @nodoc
class __$DiffRefsCopyWithImpl<$Res>
    implements _$DiffRefsCopyWith<$Res> {
  __$DiffRefsCopyWithImpl(this._self, this._then);

  final _DiffRefs _self;
  final $Res Function(_DiffRefs) _then;

/// Create a copy of DiffRefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseSha = null,Object? startSha = null,Object? headSha = null,}) {
  return _then(_DiffRefs(
baseSha: null == baseSha ? _self.baseSha : baseSha // ignore: cast_nullable_to_non_nullable
as String,startSha: null == startSha ? _self.startSha : startSha // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MrSource {

/// gitlab or github.
 String get provider; String get url; int get iid;/// "group/project" or "owner/repo".
 String get projectPath; String get title; String get description; String get author; String get sourceBranch; String get targetBranch; DiffRefs get diffRefs;
/// Create a copy of MrSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MrSourceCopyWith<MrSource> get copyWith => _$MrSourceCopyWithImpl<MrSource>(this as MrSource, _$identity);

  /// Serializes this MrSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MrSource;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MrSource&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.iid, _this.iid) || other.iid == _this.iid)&&(identical(other.projectPath, _this.projectPath) || other.projectPath == _this.projectPath)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.sourceBranch, _this.sourceBranch) || other.sourceBranch == _this.sourceBranch)&&(identical(other.targetBranch, _this.targetBranch) || other.targetBranch == _this.targetBranch)&&(identical(other.diffRefs, _this.diffRefs) || other.diffRefs == _this.diffRefs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MrSource;
  return Object.hash(runtimeType,_this.provider,_this.url,_this.iid,_this.projectPath,_this.title,_this.description,_this.author,_this.sourceBranch,_this.targetBranch,_this.diffRefs);
}

@override
String toString() {
  final _this = this as MrSource;
  return 'MrSource(provider: ${_this.provider}, url: ${_this.url}, iid: ${_this.iid}, projectPath: ${_this.projectPath}, title: ${_this.title}, description: ${_this.description}, author: ${_this.author}, sourceBranch: ${_this.sourceBranch}, targetBranch: ${_this.targetBranch}, diffRefs: ${_this.diffRefs})';
}


}

/// @nodoc
abstract mixin class $MrSourceCopyWith<$Res>  {
  factory $MrSourceCopyWith(MrSource value, $Res Function(MrSource) _then) = _$MrSourceCopyWithImpl;
@useResult
$Res call({
 String provider, String url, int iid, String projectPath, String title, String description, String author, String sourceBranch, String targetBranch, DiffRefs diffRefs
});


$DiffRefsCopyWith<$Res> get diffRefs;

}
/// @nodoc
class _$MrSourceCopyWithImpl<$Res>
    implements $MrSourceCopyWith<$Res> {
  _$MrSourceCopyWithImpl(this._self, this._then);

  final MrSource _self;
  final $Res Function(MrSource) _then;

/// Create a copy of MrSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? url = null,Object? iid = null,Object? projectPath = null,Object? title = null,Object? description = null,Object? author = null,Object? sourceBranch = null,Object? targetBranch = null,Object? diffRefs = null,}) {
  return _then(MrSource(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,iid: null == iid ? _self.iid : iid // ignore: cast_nullable_to_non_nullable
as int,projectPath: null == projectPath ? _self.projectPath : projectPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,sourceBranch: null == sourceBranch ? _self.sourceBranch : sourceBranch // ignore: cast_nullable_to_non_nullable
as String,targetBranch: null == targetBranch ? _self.targetBranch : targetBranch // ignore: cast_nullable_to_non_nullable
as String,diffRefs: null == diffRefs ? _self.diffRefs : diffRefs // ignore: cast_nullable_to_non_nullable
as DiffRefs,
  ));
}
/// Create a copy of MrSource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiffRefsCopyWith<$Res> get diffRefs {
  
  return $DiffRefsCopyWith<$Res>(_self.diffRefs, (value) {
    return _then(_self.copyWith(diffRefs: value));
  });
}
}


/// Adds pattern-matching-related methods to [MrSource].
extension MrSourcePatterns on MrSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MrSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MrSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MrSource value)  $default,){
final _that = this;
switch (_that) {
case _MrSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MrSource value)?  $default,){
final _that = this;
switch (_that) {
case _MrSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String url,  int iid,  String projectPath,  String title,  String description,  String author,  String sourceBranch,  String targetBranch,  DiffRefs diffRefs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MrSource() when $default != null:
return $default(_that.provider,_that.url,_that.iid,_that.projectPath,_that.title,_that.description,_that.author,_that.sourceBranch,_that.targetBranch,_that.diffRefs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String url,  int iid,  String projectPath,  String title,  String description,  String author,  String sourceBranch,  String targetBranch,  DiffRefs diffRefs)  $default,) {final _that = this;
switch (_that) {
case _MrSource():
return $default(_that.provider,_that.url,_that.iid,_that.projectPath,_that.title,_that.description,_that.author,_that.sourceBranch,_that.targetBranch,_that.diffRefs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String url,  int iid,  String projectPath,  String title,  String description,  String author,  String sourceBranch,  String targetBranch,  DiffRefs diffRefs)?  $default,) {final _that = this;
switch (_that) {
case _MrSource() when $default != null:
return $default(_that.provider,_that.url,_that.iid,_that.projectPath,_that.title,_that.description,_that.author,_that.sourceBranch,_that.targetBranch,_that.diffRefs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MrSource implements MrSource {
  const _MrSource({required this.provider, required this.url, required this.iid, required this.projectPath, this.title = '', this.description = '', this.author = '', this.sourceBranch = '', this.targetBranch = '', this.diffRefs = const DiffRefs()});
  factory _MrSource.fromJson(Map<String, dynamic> json) => _$MrSourceFromJson(json);

/// gitlab or github.
@override final  String provider;
@override final  String url;
@override final  int iid;
/// "group/project" or "owner/repo".
@override final  String projectPath;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String author;
@override@JsonKey() final  String sourceBranch;
@override@JsonKey() final  String targetBranch;
@override@JsonKey() final  DiffRefs diffRefs;

/// Create a copy of MrSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MrSourceCopyWith<_MrSource> get copyWith => __$MrSourceCopyWithImpl<_MrSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MrSourceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MrSource&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.url, url) || other.url == url)&&(identical(other.iid, iid) || other.iid == iid)&&(identical(other.projectPath, projectPath) || other.projectPath == projectPath)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&(identical(other.sourceBranch, sourceBranch) || other.sourceBranch == sourceBranch)&&(identical(other.targetBranch, targetBranch) || other.targetBranch == targetBranch)&&(identical(other.diffRefs, diffRefs) || other.diffRefs == diffRefs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,provider,url,iid,projectPath,title,description,author,sourceBranch,targetBranch,diffRefs);
}

@override
String toString() {
    return 'MrSource(provider: $provider, url: $url, iid: $iid, projectPath: $projectPath, title: $title, description: $description, author: $author, sourceBranch: $sourceBranch, targetBranch: $targetBranch, diffRefs: $diffRefs)';
}


}

/// @nodoc
abstract mixin class _$MrSourceCopyWith<$Res> implements $MrSourceCopyWith<$Res> {
  factory _$MrSourceCopyWith(_MrSource value, $Res Function(_MrSource) _then) = __$MrSourceCopyWithImpl;
@override @useResult
$Res call({
 String provider, String url, int iid, String projectPath, String title, String description, String author, String sourceBranch, String targetBranch, DiffRefs diffRefs
});


@override $DiffRefsCopyWith<$Res> get diffRefs;

}
/// @nodoc
class __$MrSourceCopyWithImpl<$Res>
    implements _$MrSourceCopyWith<$Res> {
  __$MrSourceCopyWithImpl(this._self, this._then);

  final _MrSource _self;
  final $Res Function(_MrSource) _then;

/// Create a copy of MrSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? url = null,Object? iid = null,Object? projectPath = null,Object? title = null,Object? description = null,Object? author = null,Object? sourceBranch = null,Object? targetBranch = null,Object? diffRefs = null,}) {
  return _then(_MrSource(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,iid: null == iid ? _self.iid : iid // ignore: cast_nullable_to_non_nullable
as int,projectPath: null == projectPath ? _self.projectPath : projectPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,sourceBranch: null == sourceBranch ? _self.sourceBranch : sourceBranch // ignore: cast_nullable_to_non_nullable
as String,targetBranch: null == targetBranch ? _self.targetBranch : targetBranch // ignore: cast_nullable_to_non_nullable
as String,diffRefs: null == diffRefs ? _self.diffRefs : diffRefs // ignore: cast_nullable_to_non_nullable
as DiffRefs,
  ));
}

/// Create a copy of MrSource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiffRefsCopyWith<$Res> get diffRefs {
  
  return $DiffRefsCopyWith<$Res>(_self.diffRefs, (value) {
    return _then(_self.copyWith(diffRefs: value));
  });
}
}


/// @nodoc
mixin _$FileNote {

 String get path; String get summary; List<String> get extraTags;
/// Create a copy of FileNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileNoteCopyWith<FileNote> get copyWith => _$FileNoteCopyWithImpl<FileNote>(this as FileNote, _$identity);

  /// Serializes this FileNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FileNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileNote&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.extraTags, _this.extraTags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FileNote;
  return Object.hash(runtimeType,_this.path,_this.summary,const DeepCollectionEquality().hash(_this.extraTags));
}

@override
String toString() {
  final _this = this as FileNote;
  return 'FileNote(path: ${_this.path}, summary: ${_this.summary}, extraTags: ${_this.extraTags})';
}


}

/// @nodoc
abstract mixin class $FileNoteCopyWith<$Res>  {
  factory $FileNoteCopyWith(FileNote value, $Res Function(FileNote) _then) = _$FileNoteCopyWithImpl;
@useResult
$Res call({
 String path, String summary, List<String> extraTags
});




}
/// @nodoc
class _$FileNoteCopyWithImpl<$Res>
    implements $FileNoteCopyWith<$Res> {
  _$FileNoteCopyWithImpl(this._self, this._then);

  final FileNote _self;
  final $Res Function(FileNote) _then;

/// Create a copy of FileNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? summary = null,Object? extraTags = null,}) {
  return _then(FileNote(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,extraTags: null == extraTags ? _self.extraTags : extraTags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FileNote].
extension FileNotePatterns on FileNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileNote value)  $default,){
final _that = this;
switch (_that) {
case _FileNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileNote value)?  $default,){
final _that = this;
switch (_that) {
case _FileNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String summary,  List<String> extraTags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileNote() when $default != null:
return $default(_that.path,_that.summary,_that.extraTags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String summary,  List<String> extraTags)  $default,) {final _that = this;
switch (_that) {
case _FileNote():
return $default(_that.path,_that.summary,_that.extraTags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String summary,  List<String> extraTags)?  $default,) {final _that = this;
switch (_that) {
case _FileNote() when $default != null:
return $default(_that.path,_that.summary,_that.extraTags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileNote implements FileNote {
  const _FileNote({required this.path, required this.summary,  List<String> extraTags = const []}): _extraTags = extraTags;
  factory _FileNote.fromJson(Map<String, dynamic> json) => _$FileNoteFromJson(json);

@override final  String path;
@override final  String summary;
 final  List<String> _extraTags;
@override@JsonKey() List<String> get extraTags {
  if (_extraTags is EqualUnmodifiableListView) return _extraTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraTags);
}


/// Create a copy of FileNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileNoteCopyWith<_FileNote> get copyWith => __$FileNoteCopyWithImpl<_FileNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileNote&&(identical(other.path, path) || other.path == path)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.extraTags, _extraTags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,summary,const DeepCollectionEquality().hash(_extraTags));
}

@override
String toString() {
    return 'FileNote(path: $path, summary: $summary, extraTags: $extraTags)';
}


}

/// @nodoc
abstract mixin class _$FileNoteCopyWith<$Res> implements $FileNoteCopyWith<$Res> {
  factory _$FileNoteCopyWith(_FileNote value, $Res Function(_FileNote) _then) = __$FileNoteCopyWithImpl;
@override @useResult
$Res call({
 String path, String summary, List<String> extraTags
});




}
/// @nodoc
class __$FileNoteCopyWithImpl<$Res>
    implements _$FileNoteCopyWith<$Res> {
  __$FileNoteCopyWithImpl(this._self, this._then);

  final _FileNote _self;
  final $Res Function(_FileNote) _then;

/// Create a copy of FileNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? summary = null,Object? extraTags = null,}) {
  return _then(_FileNote(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,extraTags: null == extraTags ? _self._extraTags : extraTags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$HunkNote {

 String get path; String get hunkRef; String get summary;
/// Create a copy of HunkNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HunkNoteCopyWith<HunkNote> get copyWith => _$HunkNoteCopyWithImpl<HunkNote>(this as HunkNote, _$identity);

  /// Serializes this HunkNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HunkNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HunkNote&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.hunkRef, _this.hunkRef) || other.hunkRef == _this.hunkRef)&&(identical(other.summary, _this.summary) || other.summary == _this.summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HunkNote;
  return Object.hash(runtimeType,_this.path,_this.hunkRef,_this.summary);
}

@override
String toString() {
  final _this = this as HunkNote;
  return 'HunkNote(path: ${_this.path}, hunkRef: ${_this.hunkRef}, summary: ${_this.summary})';
}


}

/// @nodoc
abstract mixin class $HunkNoteCopyWith<$Res>  {
  factory $HunkNoteCopyWith(HunkNote value, $Res Function(HunkNote) _then) = _$HunkNoteCopyWithImpl;
@useResult
$Res call({
 String path, String hunkRef, String summary
});




}
/// @nodoc
class _$HunkNoteCopyWithImpl<$Res>
    implements $HunkNoteCopyWith<$Res> {
  _$HunkNoteCopyWithImpl(this._self, this._then);

  final HunkNote _self;
  final $Res Function(HunkNote) _then;

/// Create a copy of HunkNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? hunkRef = null,Object? summary = null,}) {
  return _then(HunkNote(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,hunkRef: null == hunkRef ? _self.hunkRef : hunkRef // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HunkNote].
extension HunkNotePatterns on HunkNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HunkNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HunkNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HunkNote value)  $default,){
final _that = this;
switch (_that) {
case _HunkNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HunkNote value)?  $default,){
final _that = this;
switch (_that) {
case _HunkNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String hunkRef,  String summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HunkNote() when $default != null:
return $default(_that.path,_that.hunkRef,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String hunkRef,  String summary)  $default,) {final _that = this;
switch (_that) {
case _HunkNote():
return $default(_that.path,_that.hunkRef,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String hunkRef,  String summary)?  $default,) {final _that = this;
switch (_that) {
case _HunkNote() when $default != null:
return $default(_that.path,_that.hunkRef,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HunkNote implements HunkNote {
  const _HunkNote({required this.path, required this.hunkRef, required this.summary});
  factory _HunkNote.fromJson(Map<String, dynamic> json) => _$HunkNoteFromJson(json);

@override final  String path;
@override final  String hunkRef;
@override final  String summary;

/// Create a copy of HunkNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HunkNoteCopyWith<_HunkNote> get copyWith => __$HunkNoteCopyWithImpl<_HunkNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HunkNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HunkNote&&(identical(other.path, path) || other.path == path)&&(identical(other.hunkRef, hunkRef) || other.hunkRef == hunkRef)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,hunkRef,summary);
}

@override
String toString() {
    return 'HunkNote(path: $path, hunkRef: $hunkRef, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$HunkNoteCopyWith<$Res> implements $HunkNoteCopyWith<$Res> {
  factory _$HunkNoteCopyWith(_HunkNote value, $Res Function(_HunkNote) _then) = __$HunkNoteCopyWithImpl;
@override @useResult
$Res call({
 String path, String hunkRef, String summary
});




}
/// @nodoc
class __$HunkNoteCopyWithImpl<$Res>
    implements _$HunkNoteCopyWith<$Res> {
  __$HunkNoteCopyWithImpl(this._self, this._then);

  final _HunkNote _self;
  final $Res Function(_HunkNote) _then;

/// Create a copy of HunkNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? hunkRef = null,Object? summary = null,}) {
  return _then(_HunkNote(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,hunkRef: null == hunkRef ? _self.hunkRef : hunkRef // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GroupItem {

 String get path; String? get hunkRef;
/// Create a copy of GroupItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupItemCopyWith<GroupItem> get copyWith => _$GroupItemCopyWithImpl<GroupItem>(this as GroupItem, _$identity);

  /// Serializes this GroupItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GroupItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupItem&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.hunkRef, _this.hunkRef) || other.hunkRef == _this.hunkRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GroupItem;
  return Object.hash(runtimeType,_this.path,_this.hunkRef);
}

@override
String toString() {
  final _this = this as GroupItem;
  return 'GroupItem(path: ${_this.path}, hunkRef: ${_this.hunkRef})';
}


}

/// @nodoc
abstract mixin class $GroupItemCopyWith<$Res>  {
  factory $GroupItemCopyWith(GroupItem value, $Res Function(GroupItem) _then) = _$GroupItemCopyWithImpl;
@useResult
$Res call({
 String path, String? hunkRef
});




}
/// @nodoc
class _$GroupItemCopyWithImpl<$Res>
    implements $GroupItemCopyWith<$Res> {
  _$GroupItemCopyWithImpl(this._self, this._then);

  final GroupItem _self;
  final $Res Function(GroupItem) _then;

/// Create a copy of GroupItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? hunkRef = freezed,}) {
  return _then(GroupItem(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,hunkRef: freezed == hunkRef ? _self.hunkRef : hunkRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupItem].
extension GroupItemPatterns on GroupItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupItem value)  $default,){
final _that = this;
switch (_that) {
case _GroupItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupItem value)?  $default,){
final _that = this;
switch (_that) {
case _GroupItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String? hunkRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupItem() when $default != null:
return $default(_that.path,_that.hunkRef);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String? hunkRef)  $default,) {final _that = this;
switch (_that) {
case _GroupItem():
return $default(_that.path,_that.hunkRef);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String? hunkRef)?  $default,) {final _that = this;
switch (_that) {
case _GroupItem() when $default != null:
return $default(_that.path,_that.hunkRef);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupItem implements GroupItem {
  const _GroupItem({required this.path, this.hunkRef});
  factory _GroupItem.fromJson(Map<String, dynamic> json) => _$GroupItemFromJson(json);

@override final  String path;
@override final  String? hunkRef;

/// Create a copy of GroupItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupItemCopyWith<_GroupItem> get copyWith => __$GroupItemCopyWithImpl<_GroupItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupItem&&(identical(other.path, path) || other.path == path)&&(identical(other.hunkRef, hunkRef) || other.hunkRef == hunkRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,hunkRef);
}

@override
String toString() {
    return 'GroupItem(path: $path, hunkRef: $hunkRef)';
}


}

/// @nodoc
abstract mixin class _$GroupItemCopyWith<$Res> implements $GroupItemCopyWith<$Res> {
  factory _$GroupItemCopyWith(_GroupItem value, $Res Function(_GroupItem) _then) = __$GroupItemCopyWithImpl;
@override @useResult
$Res call({
 String path, String? hunkRef
});




}
/// @nodoc
class __$GroupItemCopyWithImpl<$Res>
    implements _$GroupItemCopyWith<$Res> {
  __$GroupItemCopyWithImpl(this._self, this._then);

  final _GroupItem _self;
  final $Res Function(_GroupItem) _then;

/// Create a copy of GroupItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? hunkRef = freezed,}) {
  return _then(_GroupItem(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,hunkRef: freezed == hunkRef ? _self.hunkRef : hunkRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReviewGroup {

 String get title; String get overview; List<GroupItem> get items;
/// Create a copy of ReviewGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewGroupCopyWith<ReviewGroup> get copyWith => _$ReviewGroupCopyWithImpl<ReviewGroup>(this as ReviewGroup, _$identity);

  /// Serializes this ReviewGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewGroup&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.overview, _this.overview) || other.overview == _this.overview)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewGroup;
  return Object.hash(runtimeType,_this.title,_this.overview,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as ReviewGroup;
  return 'ReviewGroup(title: ${_this.title}, overview: ${_this.overview}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $ReviewGroupCopyWith<$Res>  {
  factory $ReviewGroupCopyWith(ReviewGroup value, $Res Function(ReviewGroup) _then) = _$ReviewGroupCopyWithImpl;
@useResult
$Res call({
 String title, String overview, List<GroupItem> items
});




}
/// @nodoc
class _$ReviewGroupCopyWithImpl<$Res>
    implements $ReviewGroupCopyWith<$Res> {
  _$ReviewGroupCopyWithImpl(this._self, this._then);

  final ReviewGroup _self;
  final $Res Function(ReviewGroup) _then;

/// Create a copy of ReviewGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? overview = null,Object? items = null,}) {
  return _then(ReviewGroup(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<GroupItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewGroup].
extension ReviewGroupPatterns on ReviewGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewGroup value)  $default,){
final _that = this;
switch (_that) {
case _ReviewGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewGroup value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String overview,  List<GroupItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewGroup() when $default != null:
return $default(_that.title,_that.overview,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String overview,  List<GroupItem> items)  $default,) {final _that = this;
switch (_that) {
case _ReviewGroup():
return $default(_that.title,_that.overview,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String overview,  List<GroupItem> items)?  $default,) {final _that = this;
switch (_that) {
case _ReviewGroup() when $default != null:
return $default(_that.title,_that.overview,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewGroup implements ReviewGroup {
  const _ReviewGroup({required this.title, this.overview = '',  List<GroupItem> items = const []}): _items = items;
  factory _ReviewGroup.fromJson(Map<String, dynamic> json) => _$ReviewGroupFromJson(json);

@override final  String title;
@override@JsonKey() final  String overview;
 final  List<GroupItem> _items;
@override@JsonKey() List<GroupItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ReviewGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewGroupCopyWith<_ReviewGroup> get copyWith => __$ReviewGroupCopyWithImpl<_ReviewGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewGroupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewGroup&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,overview,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'ReviewGroup(title: $title, overview: $overview, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReviewGroupCopyWith<$Res> implements $ReviewGroupCopyWith<$Res> {
  factory _$ReviewGroupCopyWith(_ReviewGroup value, $Res Function(_ReviewGroup) _then) = __$ReviewGroupCopyWithImpl;
@override @useResult
$Res call({
 String title, String overview, List<GroupItem> items
});




}
/// @nodoc
class __$ReviewGroupCopyWithImpl<$Res>
    implements _$ReviewGroupCopyWith<$Res> {
  __$ReviewGroupCopyWithImpl(this._self, this._then);

  final _ReviewGroup _self;
  final $Res Function(_ReviewGroup) _then;

/// Create a copy of ReviewGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? overview = null,Object? items = null,}) {
  return _then(_ReviewGroup(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<GroupItem>,
  ));
}


}


/// @nodoc
mixin _$ReviewFeature {

 String get title; String get summary; FeatureGraph? get graph; MapSequence? get sequence;
/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewFeatureCopyWith<ReviewFeature> get copyWith => _$ReviewFeatureCopyWithImpl<ReviewFeature>(this as ReviewFeature, _$identity);

  /// Serializes this ReviewFeature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewFeature;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewFeature&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.graph, _this.graph) || other.graph == _this.graph)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewFeature;
  return Object.hash(runtimeType,_this.title,_this.summary,_this.graph,_this.sequence);
}

@override
String toString() {
  final _this = this as ReviewFeature;
  return 'ReviewFeature(title: ${_this.title}, summary: ${_this.summary}, graph: ${_this.graph}, sequence: ${_this.sequence})';
}


}

/// @nodoc
abstract mixin class $ReviewFeatureCopyWith<$Res>  {
  factory $ReviewFeatureCopyWith(ReviewFeature value, $Res Function(ReviewFeature) _then) = _$ReviewFeatureCopyWithImpl;
@useResult
$Res call({
 String title, String summary, FeatureGraph? graph, MapSequence? sequence
});


$FeatureGraphCopyWith<$Res>? get graph;$MapSequenceCopyWith<$Res>? get sequence;

}
/// @nodoc
class _$ReviewFeatureCopyWithImpl<$Res>
    implements $ReviewFeatureCopyWith<$Res> {
  _$ReviewFeatureCopyWithImpl(this._self, this._then);

  final ReviewFeature _self;
  final $Res Function(ReviewFeature) _then;

/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? summary = null,Object? graph = freezed,Object? sequence = freezed,}) {
  return _then(ReviewFeature(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,graph: freezed == graph ? _self.graph : graph // ignore: cast_nullable_to_non_nullable
as FeatureGraph?,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as MapSequence?,
  ));
}
/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatureGraphCopyWith<$Res>? get graph {
    if (_self.graph == null) {
    return null;
  }

  return $FeatureGraphCopyWith<$Res>(_self.graph!, (value) {
    return _then(_self.copyWith(graph: value));
  });
}/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapSequenceCopyWith<$Res>? get sequence {
    if (_self.sequence == null) {
    return null;
  }

  return $MapSequenceCopyWith<$Res>(_self.sequence!, (value) {
    return _then(_self.copyWith(sequence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReviewFeature].
extension ReviewFeaturePatterns on ReviewFeature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewFeature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewFeature value)  $default,){
final _that = this;
switch (_that) {
case _ReviewFeature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewFeature value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewFeature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String summary,  FeatureGraph? graph,  MapSequence? sequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewFeature() when $default != null:
return $default(_that.title,_that.summary,_that.graph,_that.sequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String summary,  FeatureGraph? graph,  MapSequence? sequence)  $default,) {final _that = this;
switch (_that) {
case _ReviewFeature():
return $default(_that.title,_that.summary,_that.graph,_that.sequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String summary,  FeatureGraph? graph,  MapSequence? sequence)?  $default,) {final _that = this;
switch (_that) {
case _ReviewFeature() when $default != null:
return $default(_that.title,_that.summary,_that.graph,_that.sequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewFeature implements ReviewFeature {
  const _ReviewFeature({required this.title, this.summary = '', this.graph, this.sequence});
  factory _ReviewFeature.fromJson(Map<String, dynamic> json) => _$ReviewFeatureFromJson(json);

@override final  String title;
@override@JsonKey() final  String summary;
@override final  FeatureGraph? graph;
@override final  MapSequence? sequence;

/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewFeatureCopyWith<_ReviewFeature> get copyWith => __$ReviewFeatureCopyWithImpl<_ReviewFeature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewFeatureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewFeature&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.graph, graph) || other.graph == graph)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,summary,graph,sequence);
}

@override
String toString() {
    return 'ReviewFeature(title: $title, summary: $summary, graph: $graph, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class _$ReviewFeatureCopyWith<$Res> implements $ReviewFeatureCopyWith<$Res> {
  factory _$ReviewFeatureCopyWith(_ReviewFeature value, $Res Function(_ReviewFeature) _then) = __$ReviewFeatureCopyWithImpl;
@override @useResult
$Res call({
 String title, String summary, FeatureGraph? graph, MapSequence? sequence
});


@override $FeatureGraphCopyWith<$Res>? get graph;@override $MapSequenceCopyWith<$Res>? get sequence;

}
/// @nodoc
class __$ReviewFeatureCopyWithImpl<$Res>
    implements _$ReviewFeatureCopyWith<$Res> {
  __$ReviewFeatureCopyWithImpl(this._self, this._then);

  final _ReviewFeature _self;
  final $Res Function(_ReviewFeature) _then;

/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? summary = null,Object? graph = freezed,Object? sequence = freezed,}) {
  return _then(_ReviewFeature(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,graph: freezed == graph ? _self.graph : graph // ignore: cast_nullable_to_non_nullable
as FeatureGraph?,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as MapSequence?,
  ));
}

/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatureGraphCopyWith<$Res>? get graph {
    if (_self.graph == null) {
    return null;
  }

  return $FeatureGraphCopyWith<$Res>(_self.graph!, (value) {
    return _then(_self.copyWith(graph: value));
  });
}/// Create a copy of ReviewFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapSequenceCopyWith<$Res>? get sequence {
    if (_self.sequence == null) {
    return null;
  }

  return $MapSequenceCopyWith<$Res>(_self.sequence!, (value) {
    return _then(_self.copyWith(sequence: value));
  });
}
}


/// @nodoc
mixin _$ChecklistItem {

 String get text; String get evidence; List<String> get paths;/// ok, concern or unclear.
 String get state;/// The head judged, so a list written before a push shows as stale.
 String get headSha;
/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemCopyWith<ChecklistItem> get copyWith => _$ChecklistItemCopyWithImpl<ChecklistItem>(this as ChecklistItem, _$identity);

  /// Serializes this ChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChecklistItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItem&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.evidence, _this.evidence) || other.evidence == _this.evidence)&&const DeepCollectionEquality().equals(other.paths, _this.paths)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.headSha, _this.headSha) || other.headSha == _this.headSha));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChecklistItem;
  return Object.hash(runtimeType,_this.text,_this.evidence,const DeepCollectionEquality().hash(_this.paths),_this.state,_this.headSha);
}

@override
String toString() {
  final _this = this as ChecklistItem;
  return 'ChecklistItem(text: ${_this.text}, evidence: ${_this.evidence}, paths: ${_this.paths}, state: ${_this.state}, headSha: ${_this.headSha})';
}


}

/// @nodoc
abstract mixin class $ChecklistItemCopyWith<$Res>  {
  factory $ChecklistItemCopyWith(ChecklistItem value, $Res Function(ChecklistItem) _then) = _$ChecklistItemCopyWithImpl;
@useResult
$Res call({
 String text, String evidence, List<String> paths, String state, String headSha
});




}
/// @nodoc
class _$ChecklistItemCopyWithImpl<$Res>
    implements $ChecklistItemCopyWith<$Res> {
  _$ChecklistItemCopyWithImpl(this._self, this._then);

  final ChecklistItem _self;
  final $Res Function(ChecklistItem) _then;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? evidence = null,Object? paths = null,Object? state = null,Object? headSha = null,}) {
  return _then(ChecklistItem(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as String,paths: null == paths ? _self.paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistItem].
extension ChecklistItemPatterns on ChecklistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistItem value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistItem value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String evidence,  List<String> paths,  String state,  String headSha)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.text,_that.evidence,_that.paths,_that.state,_that.headSha);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String evidence,  List<String> paths,  String state,  String headSha)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem():
return $default(_that.text,_that.evidence,_that.paths,_that.state,_that.headSha);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String evidence,  List<String> paths,  String state,  String headSha)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.text,_that.evidence,_that.paths,_that.state,_that.headSha);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistItem implements ChecklistItem {
  const _ChecklistItem({required this.text, this.evidence = '',  List<String> paths = const [], required this.state, this.headSha = ''}): _paths = paths;
  factory _ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);

@override final  String text;
@override@JsonKey() final  String evidence;
 final  List<String> _paths;
@override@JsonKey() List<String> get paths {
  if (_paths is EqualUnmodifiableListView) return _paths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paths);
}

/// ok, concern or unclear.
@override final  String state;
/// The head judged, so a list written before a push shows as stale.
@override@JsonKey() final  String headSha;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistItemCopyWith<_ChecklistItem> get copyWith => __$ChecklistItemCopyWithImpl<_ChecklistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItem&&(identical(other.text, text) || other.text == text)&&(identical(other.evidence, evidence) || other.evidence == evidence)&&const DeepCollectionEquality().equals(other.paths, _paths)&&(identical(other.state, state) || other.state == state)&&(identical(other.headSha, headSha) || other.headSha == headSha));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text,evidence,const DeepCollectionEquality().hash(_paths),state,headSha);
}

@override
String toString() {
    return 'ChecklistItem(text: $text, evidence: $evidence, paths: $paths, state: $state, headSha: $headSha)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemCopyWith<$Res> implements $ChecklistItemCopyWith<$Res> {
  factory _$ChecklistItemCopyWith(_ChecklistItem value, $Res Function(_ChecklistItem) _then) = __$ChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 String text, String evidence, List<String> paths, String state, String headSha
});




}
/// @nodoc
class __$ChecklistItemCopyWithImpl<$Res>
    implements _$ChecklistItemCopyWith<$Res> {
  __$ChecklistItemCopyWithImpl(this._self, this._then);

  final _ChecklistItem _self;
  final $Res Function(_ChecklistItem) _then;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? evidence = null,Object? paths = null,Object? state = null,Object? headSha = null,}) {
  return _then(_ChecklistItem(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as String,paths: null == paths ? _self._paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StoredTicket {

 String get ref; String? get url; String? get title; String get body;
/// Create a copy of StoredTicket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoredTicketCopyWith<StoredTicket> get copyWith => _$StoredTicketCopyWithImpl<StoredTicket>(this as StoredTicket, _$identity);

  /// Serializes this StoredTicket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StoredTicket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoredTicket&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StoredTicket;
  return Object.hash(runtimeType,_this.ref,_this.url,_this.title,_this.body);
}

@override
String toString() {
  final _this = this as StoredTicket;
  return 'StoredTicket(ref: ${_this.ref}, url: ${_this.url}, title: ${_this.title}, body: ${_this.body})';
}


}

/// @nodoc
abstract mixin class $StoredTicketCopyWith<$Res>  {
  factory $StoredTicketCopyWith(StoredTicket value, $Res Function(StoredTicket) _then) = _$StoredTicketCopyWithImpl;
@useResult
$Res call({
 String ref, String? url, String? title, String body
});




}
/// @nodoc
class _$StoredTicketCopyWithImpl<$Res>
    implements $StoredTicketCopyWith<$Res> {
  _$StoredTicketCopyWithImpl(this._self, this._then);

  final StoredTicket _self;
  final $Res Function(StoredTicket) _then;

/// Create a copy of StoredTicket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? url = freezed,Object? title = freezed,Object? body = null,}) {
  return _then(StoredTicket(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoredTicket].
extension StoredTicketPatterns on StoredTicket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoredTicket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoredTicket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoredTicket value)  $default,){
final _that = this;
switch (_that) {
case _StoredTicket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoredTicket value)?  $default,){
final _that = this;
switch (_that) {
case _StoredTicket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ref,  String? url,  String? title,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoredTicket() when $default != null:
return $default(_that.ref,_that.url,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ref,  String? url,  String? title,  String body)  $default,) {final _that = this;
switch (_that) {
case _StoredTicket():
return $default(_that.ref,_that.url,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ref,  String? url,  String? title,  String body)?  $default,) {final _that = this;
switch (_that) {
case _StoredTicket() when $default != null:
return $default(_that.ref,_that.url,_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoredTicket implements StoredTicket {
  const _StoredTicket({required this.ref, this.url, this.title, this.body = ''});
  factory _StoredTicket.fromJson(Map<String, dynamic> json) => _$StoredTicketFromJson(json);

@override final  String ref;
@override final  String? url;
@override final  String? title;
@override@JsonKey() final  String body;

/// Create a copy of StoredTicket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoredTicketCopyWith<_StoredTicket> get copyWith => __$StoredTicketCopyWithImpl<_StoredTicket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoredTicketToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoredTicket&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ref,url,title,body);
}

@override
String toString() {
    return 'StoredTicket(ref: $ref, url: $url, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$StoredTicketCopyWith<$Res> implements $StoredTicketCopyWith<$Res> {
  factory _$StoredTicketCopyWith(_StoredTicket value, $Res Function(_StoredTicket) _then) = __$StoredTicketCopyWithImpl;
@override @useResult
$Res call({
 String ref, String? url, String? title, String body
});




}
/// @nodoc
class __$StoredTicketCopyWithImpl<$Res>
    implements _$StoredTicketCopyWith<$Res> {
  __$StoredTicketCopyWithImpl(this._self, this._then);

  final _StoredTicket _self;
  final $Res Function(_StoredTicket) _then;

/// Create a copy of StoredTicket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? url = freezed,Object? title = freezed,Object? body = null,}) {
  return _then(_StoredTicket(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TicketCheckItem {

 String get text; String get state; List<String> get paths;
/// Create a copy of TicketCheckItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCheckItemCopyWith<TicketCheckItem> get copyWith => _$TicketCheckItemCopyWithImpl<TicketCheckItem>(this as TicketCheckItem, _$identity);

  /// Serializes this TicketCheckItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TicketCheckItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketCheckItem&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.state, _this.state) || other.state == _this.state)&&const DeepCollectionEquality().equals(other.paths, _this.paths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TicketCheckItem;
  return Object.hash(runtimeType,_this.text,_this.state,const DeepCollectionEquality().hash(_this.paths));
}

@override
String toString() {
  final _this = this as TicketCheckItem;
  return 'TicketCheckItem(text: ${_this.text}, state: ${_this.state}, paths: ${_this.paths})';
}


}

/// @nodoc
abstract mixin class $TicketCheckItemCopyWith<$Res>  {
  factory $TicketCheckItemCopyWith(TicketCheckItem value, $Res Function(TicketCheckItem) _then) = _$TicketCheckItemCopyWithImpl;
@useResult
$Res call({
 String text, String state, List<String> paths
});




}
/// @nodoc
class _$TicketCheckItemCopyWithImpl<$Res>
    implements $TicketCheckItemCopyWith<$Res> {
  _$TicketCheckItemCopyWithImpl(this._self, this._then);

  final TicketCheckItem _self;
  final $Res Function(TicketCheckItem) _then;

/// Create a copy of TicketCheckItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? state = null,Object? paths = null,}) {
  return _then(TicketCheckItem(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,paths: null == paths ? _self.paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketCheckItem].
extension TicketCheckItemPatterns on TicketCheckItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketCheckItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketCheckItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketCheckItem value)  $default,){
final _that = this;
switch (_that) {
case _TicketCheckItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketCheckItem value)?  $default,){
final _that = this;
switch (_that) {
case _TicketCheckItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String state,  List<String> paths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketCheckItem() when $default != null:
return $default(_that.text,_that.state,_that.paths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String state,  List<String> paths)  $default,) {final _that = this;
switch (_that) {
case _TicketCheckItem():
return $default(_that.text,_that.state,_that.paths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String state,  List<String> paths)?  $default,) {final _that = this;
switch (_that) {
case _TicketCheckItem() when $default != null:
return $default(_that.text,_that.state,_that.paths);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketCheckItem implements TicketCheckItem {
  const _TicketCheckItem({required this.text, required this.state,  List<String> paths = const []}): _paths = paths;
  factory _TicketCheckItem.fromJson(Map<String, dynamic> json) => _$TicketCheckItemFromJson(json);

@override final  String text;
@override final  String state;
 final  List<String> _paths;
@override@JsonKey() List<String> get paths {
  if (_paths is EqualUnmodifiableListView) return _paths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paths);
}


/// Create a copy of TicketCheckItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCheckItemCopyWith<_TicketCheckItem> get copyWith => __$TicketCheckItemCopyWithImpl<_TicketCheckItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketCheckItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketCheckItem&&(identical(other.text, text) || other.text == text)&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other.paths, _paths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text,state,const DeepCollectionEquality().hash(_paths));
}

@override
String toString() {
    return 'TicketCheckItem(text: $text, state: $state, paths: $paths)';
}


}

/// @nodoc
abstract mixin class _$TicketCheckItemCopyWith<$Res> implements $TicketCheckItemCopyWith<$Res> {
  factory _$TicketCheckItemCopyWith(_TicketCheckItem value, $Res Function(_TicketCheckItem) _then) = __$TicketCheckItemCopyWithImpl;
@override @useResult
$Res call({
 String text, String state, List<String> paths
});




}
/// @nodoc
class __$TicketCheckItemCopyWithImpl<$Res>
    implements _$TicketCheckItemCopyWith<$Res> {
  __$TicketCheckItemCopyWithImpl(this._self, this._then);

  final _TicketCheckItem _self;
  final $Res Function(_TicketCheckItem) _then;

/// Create a copy of TicketCheckItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? state = null,Object? paths = null,}) {
  return _then(_TicketCheckItem(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,paths: null == paths ? _self._paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TicketCheck {

 String get ref; String get headSha; String get verdict; String get summary; List<TicketCheckItem> get items;
/// Create a copy of TicketCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCheckCopyWith<TicketCheck> get copyWith => _$TicketCheckCopyWithImpl<TicketCheck>(this as TicketCheck, _$identity);

  /// Serializes this TicketCheck to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TicketCheck;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketCheck&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.headSha, _this.headSha) || other.headSha == _this.headSha)&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TicketCheck;
  return Object.hash(runtimeType,_this.ref,_this.headSha,_this.verdict,_this.summary,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as TicketCheck;
  return 'TicketCheck(ref: ${_this.ref}, headSha: ${_this.headSha}, verdict: ${_this.verdict}, summary: ${_this.summary}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $TicketCheckCopyWith<$Res>  {
  factory $TicketCheckCopyWith(TicketCheck value, $Res Function(TicketCheck) _then) = _$TicketCheckCopyWithImpl;
@useResult
$Res call({
 String ref, String headSha, String verdict, String summary, List<TicketCheckItem> items
});




}
/// @nodoc
class _$TicketCheckCopyWithImpl<$Res>
    implements $TicketCheckCopyWith<$Res> {
  _$TicketCheckCopyWithImpl(this._self, this._then);

  final TicketCheck _self;
  final $Res Function(TicketCheck) _then;

/// Create a copy of TicketCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? headSha = null,Object? verdict = null,Object? summary = null,Object? items = null,}) {
  return _then(TicketCheck(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TicketCheckItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketCheck].
extension TicketCheckPatterns on TicketCheck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketCheck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketCheck() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketCheck value)  $default,){
final _that = this;
switch (_that) {
case _TicketCheck():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketCheck value)?  $default,){
final _that = this;
switch (_that) {
case _TicketCheck() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ref,  String headSha,  String verdict,  String summary,  List<TicketCheckItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketCheck() when $default != null:
return $default(_that.ref,_that.headSha,_that.verdict,_that.summary,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ref,  String headSha,  String verdict,  String summary,  List<TicketCheckItem> items)  $default,) {final _that = this;
switch (_that) {
case _TicketCheck():
return $default(_that.ref,_that.headSha,_that.verdict,_that.summary,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ref,  String headSha,  String verdict,  String summary,  List<TicketCheckItem> items)?  $default,) {final _that = this;
switch (_that) {
case _TicketCheck() when $default != null:
return $default(_that.ref,_that.headSha,_that.verdict,_that.summary,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketCheck implements TicketCheck {
  const _TicketCheck({required this.ref, this.headSha = '', required this.verdict, this.summary = '',  List<TicketCheckItem> items = const []}): _items = items;
  factory _TicketCheck.fromJson(Map<String, dynamic> json) => _$TicketCheckFromJson(json);

@override final  String ref;
@override@JsonKey() final  String headSha;
@override final  String verdict;
@override@JsonKey() final  String summary;
 final  List<TicketCheckItem> _items;
@override@JsonKey() List<TicketCheckItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TicketCheck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCheckCopyWith<_TicketCheck> get copyWith => __$TicketCheckCopyWithImpl<_TicketCheck>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketCheckToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketCheck&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.headSha, headSha) || other.headSha == headSha)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ref,headSha,verdict,summary,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'TicketCheck(ref: $ref, headSha: $headSha, verdict: $verdict, summary: $summary, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TicketCheckCopyWith<$Res> implements $TicketCheckCopyWith<$Res> {
  factory _$TicketCheckCopyWith(_TicketCheck value, $Res Function(_TicketCheck) _then) = __$TicketCheckCopyWithImpl;
@override @useResult
$Res call({
 String ref, String headSha, String verdict, String summary, List<TicketCheckItem> items
});




}
/// @nodoc
class __$TicketCheckCopyWithImpl<$Res>
    implements _$TicketCheckCopyWith<$Res> {
  __$TicketCheckCopyWithImpl(this._self, this._then);

  final _TicketCheck _self;
  final $Res Function(_TicketCheck) _then;

/// Create a copy of TicketCheck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? headSha = null,Object? verdict = null,Object? summary = null,Object? items = null,}) {
  return _then(_TicketCheck(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,headSha: null == headSha ? _self.headSha : headSha // ignore: cast_nullable_to_non_nullable
as String,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TicketCheckItem>,
  ));
}


}


/// @nodoc
mixin _$Review {

/// "gitlab-412": provider and number, unique in its project.
 String get id; String get project; MrSource? get mr;/// What the diff runs between: `origin/<target>` and the local source
/// branch, or the MR head fetched into `skim/mr-<iid>`.
 String get baseRef; String get headRef;/// The head is the reviewer's own branch, nothing was fetched into it.
 bool get local;/// A review of a local checkout, no merge request: the folder that has
/// [headRef] checked out. The diff runs to its working tree, edits not
/// committed yet included, and the review session runs there.
 String? get folder;/// Your own merge request: the threads are your reviewers', and only
/// replies you wrote yourself go out, never Claude's drafts.
 bool get own; String get createdAt; String get updatedAt; List<FileNote> get fileNotes; List<HunkNote> get hunkNotes; List<ReviewGroup> get groups; List<ReviewFeature> get features; List<ChecklistItem> get checklist; List<StoredTicket> get tickets; List<TicketCheck> get ticketChecks;/// Path to the head sha it was viewed at: a later change to it shows.
 Map<String, String> get viewed;/// Null keeps the repository's default.
 List<String>? get hiddenTags; List<Thread> get threads; List<Round> get rounds;/// The last Claude session on this review: answering a thread resumes
/// it, so the diff it read is still in its context.
 String? get sessionId;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Review;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.project, _this.project) || other.project == _this.project)&&(identical(other.mr, _this.mr) || other.mr == _this.mr)&&(identical(other.baseRef, _this.baseRef) || other.baseRef == _this.baseRef)&&(identical(other.headRef, _this.headRef) || other.headRef == _this.headRef)&&(identical(other.local, _this.local) || other.local == _this.local)&&(identical(other.folder, _this.folder) || other.folder == _this.folder)&&(identical(other.own, _this.own) || other.own == _this.own)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.fileNotes, _this.fileNotes)&&const DeepCollectionEquality().equals(other.hunkNotes, _this.hunkNotes)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.features, _this.features)&&const DeepCollectionEquality().equals(other.checklist, _this.checklist)&&const DeepCollectionEquality().equals(other.tickets, _this.tickets)&&const DeepCollectionEquality().equals(other.ticketChecks, _this.ticketChecks)&&const DeepCollectionEquality().equals(other.viewed, _this.viewed)&&const DeepCollectionEquality().equals(other.hiddenTags, _this.hiddenTags)&&const DeepCollectionEquality().equals(other.threads, _this.threads)&&const DeepCollectionEquality().equals(other.rounds, _this.rounds)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Review;
  return Object.hashAll([runtimeType,_this.id,_this.project,_this.mr,_this.baseRef,_this.headRef,_this.local,_this.folder,_this.own,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.fileNotes),const DeepCollectionEquality().hash(_this.hunkNotes),const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.features),const DeepCollectionEquality().hash(_this.checklist),const DeepCollectionEquality().hash(_this.tickets),const DeepCollectionEquality().hash(_this.ticketChecks),const DeepCollectionEquality().hash(_this.viewed),const DeepCollectionEquality().hash(_this.hiddenTags),const DeepCollectionEquality().hash(_this.threads),const DeepCollectionEquality().hash(_this.rounds),_this.sessionId]);
}

@override
String toString() {
  final _this = this as Review;
  return 'Review(id: ${_this.id}, project: ${_this.project}, mr: ${_this.mr}, baseRef: ${_this.baseRef}, headRef: ${_this.headRef}, local: ${_this.local}, folder: ${_this.folder}, own: ${_this.own}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, fileNotes: ${_this.fileNotes}, hunkNotes: ${_this.hunkNotes}, groups: ${_this.groups}, features: ${_this.features}, checklist: ${_this.checklist}, tickets: ${_this.tickets}, ticketChecks: ${_this.ticketChecks}, viewed: ${_this.viewed}, hiddenTags: ${_this.hiddenTags}, threads: ${_this.threads}, rounds: ${_this.rounds}, sessionId: ${_this.sessionId})';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String id, String project, MrSource? mr, String baseRef, String headRef, bool local, String? folder, bool own, String createdAt, String updatedAt, List<FileNote> fileNotes, List<HunkNote> hunkNotes, List<ReviewGroup> groups, List<ReviewFeature> features, List<ChecklistItem> checklist, List<StoredTicket> tickets, List<TicketCheck> ticketChecks, Map<String, String> viewed, List<String>? hiddenTags, List<Thread> threads, List<Round> rounds, String? sessionId
});


$MrSourceCopyWith<$Res>? get mr;

}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? project = null,Object? mr = freezed,Object? baseRef = null,Object? headRef = null,Object? local = null,Object? folder = freezed,Object? own = null,Object? createdAt = null,Object? updatedAt = null,Object? fileNotes = null,Object? hunkNotes = null,Object? groups = null,Object? features = null,Object? checklist = null,Object? tickets = null,Object? ticketChecks = null,Object? viewed = null,Object? hiddenTags = freezed,Object? threads = null,Object? rounds = null,Object? sessionId = freezed,}) {
  return _then(Review(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String,mr: freezed == mr ? _self.mr : mr // ignore: cast_nullable_to_non_nullable
as MrSource?,baseRef: null == baseRef ? _self.baseRef : baseRef // ignore: cast_nullable_to_non_nullable
as String,headRef: null == headRef ? _self.headRef : headRef // ignore: cast_nullable_to_non_nullable
as String,local: null == local ? _self.local : local // ignore: cast_nullable_to_non_nullable
as bool,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String?,own: null == own ? _self.own : own // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,fileNotes: null == fileNotes ? _self.fileNotes : fileNotes // ignore: cast_nullable_to_non_nullable
as List<FileNote>,hunkNotes: null == hunkNotes ? _self.hunkNotes : hunkNotes // ignore: cast_nullable_to_non_nullable
as List<HunkNote>,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<ReviewGroup>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<ReviewFeature>,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<StoredTicket>,ticketChecks: null == ticketChecks ? _self.ticketChecks : ticketChecks // ignore: cast_nullable_to_non_nullable
as List<TicketCheck>,viewed: null == viewed ? _self.viewed : viewed // ignore: cast_nullable_to_non_nullable
as Map<String, String>,hiddenTags: freezed == hiddenTags ? _self.hiddenTags : hiddenTags // ignore: cast_nullable_to_non_nullable
as List<String>?,threads: null == threads ? _self.threads : threads // ignore: cast_nullable_to_non_nullable
as List<Thread>,rounds: null == rounds ? _self.rounds : rounds // ignore: cast_nullable_to_non_nullable
as List<Round>,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MrSourceCopyWith<$Res>? get mr {
    if (_self.mr == null) {
    return null;
  }

  return $MrSourceCopyWith<$Res>(_self.mr!, (value) {
    return _then(_self.copyWith(mr: value));
  });
}
}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String project,  MrSource? mr,  String baseRef,  String headRef,  bool local,  String? folder,  bool own,  String createdAt,  String updatedAt,  List<FileNote> fileNotes,  List<HunkNote> hunkNotes,  List<ReviewGroup> groups,  List<ReviewFeature> features,  List<ChecklistItem> checklist,  List<StoredTicket> tickets,  List<TicketCheck> ticketChecks,  Map<String, String> viewed,  List<String>? hiddenTags,  List<Thread> threads,  List<Round> rounds,  String? sessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.project,_that.mr,_that.baseRef,_that.headRef,_that.local,_that.folder,_that.own,_that.createdAt,_that.updatedAt,_that.fileNotes,_that.hunkNotes,_that.groups,_that.features,_that.checklist,_that.tickets,_that.ticketChecks,_that.viewed,_that.hiddenTags,_that.threads,_that.rounds,_that.sessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String project,  MrSource? mr,  String baseRef,  String headRef,  bool local,  String? folder,  bool own,  String createdAt,  String updatedAt,  List<FileNote> fileNotes,  List<HunkNote> hunkNotes,  List<ReviewGroup> groups,  List<ReviewFeature> features,  List<ChecklistItem> checklist,  List<StoredTicket> tickets,  List<TicketCheck> ticketChecks,  Map<String, String> viewed,  List<String>? hiddenTags,  List<Thread> threads,  List<Round> rounds,  String? sessionId)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.id,_that.project,_that.mr,_that.baseRef,_that.headRef,_that.local,_that.folder,_that.own,_that.createdAt,_that.updatedAt,_that.fileNotes,_that.hunkNotes,_that.groups,_that.features,_that.checklist,_that.tickets,_that.ticketChecks,_that.viewed,_that.hiddenTags,_that.threads,_that.rounds,_that.sessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String project,  MrSource? mr,  String baseRef,  String headRef,  bool local,  String? folder,  bool own,  String createdAt,  String updatedAt,  List<FileNote> fileNotes,  List<HunkNote> hunkNotes,  List<ReviewGroup> groups,  List<ReviewFeature> features,  List<ChecklistItem> checklist,  List<StoredTicket> tickets,  List<TicketCheck> ticketChecks,  Map<String, String> viewed,  List<String>? hiddenTags,  List<Thread> threads,  List<Round> rounds,  String? sessionId)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.project,_that.mr,_that.baseRef,_that.headRef,_that.local,_that.folder,_that.own,_that.createdAt,_that.updatedAt,_that.fileNotes,_that.hunkNotes,_that.groups,_that.features,_that.checklist,_that.tickets,_that.ticketChecks,_that.viewed,_that.hiddenTags,_that.threads,_that.rounds,_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.id, required this.project, this.mr, required this.baseRef, required this.headRef, this.local = false, this.folder, this.own = false, this.createdAt = '', this.updatedAt = '',  List<FileNote> fileNotes = const [],  List<HunkNote> hunkNotes = const [],  List<ReviewGroup> groups = const [],  List<ReviewFeature> features = const [],  List<ChecklistItem> checklist = const [],  List<StoredTicket> tickets = const [],  List<TicketCheck> ticketChecks = const [],  Map<String, String> viewed = const {},  List<String>? hiddenTags,  List<Thread> threads = const [],  List<Round> rounds = const [], this.sessionId}): _fileNotes = fileNotes,_hunkNotes = hunkNotes,_groups = groups,_features = features,_checklist = checklist,_tickets = tickets,_ticketChecks = ticketChecks,_viewed = viewed,_hiddenTags = hiddenTags,_threads = threads,_rounds = rounds;
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

/// "gitlab-412": provider and number, unique in its project.
@override final  String id;
@override final  String project;
@override final  MrSource? mr;
/// What the diff runs between: `origin/<target>` and the local source
/// branch, or the MR head fetched into `skim/mr-<iid>`.
@override final  String baseRef;
@override final  String headRef;
/// The head is the reviewer's own branch, nothing was fetched into it.
@override@JsonKey() final  bool local;
/// A review of a local checkout, no merge request: the folder that has
/// [headRef] checked out. The diff runs to its working tree, edits not
/// committed yet included, and the review session runs there.
@override final  String? folder;
/// Your own merge request: the threads are your reviewers', and only
/// replies you wrote yourself go out, never Claude's drafts.
@override@JsonKey() final  bool own;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  String updatedAt;
 final  List<FileNote> _fileNotes;
@override@JsonKey() List<FileNote> get fileNotes {
  if (_fileNotes is EqualUnmodifiableListView) return _fileNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fileNotes);
}

 final  List<HunkNote> _hunkNotes;
@override@JsonKey() List<HunkNote> get hunkNotes {
  if (_hunkNotes is EqualUnmodifiableListView) return _hunkNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hunkNotes);
}

 final  List<ReviewGroup> _groups;
@override@JsonKey() List<ReviewGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  List<ReviewFeature> _features;
@override@JsonKey() List<ReviewFeature> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

 final  List<ChecklistItem> _checklist;
@override@JsonKey() List<ChecklistItem> get checklist {
  if (_checklist is EqualUnmodifiableListView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklist);
}

 final  List<StoredTicket> _tickets;
@override@JsonKey() List<StoredTicket> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}

 final  List<TicketCheck> _ticketChecks;
@override@JsonKey() List<TicketCheck> get ticketChecks {
  if (_ticketChecks is EqualUnmodifiableListView) return _ticketChecks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ticketChecks);
}

/// Path to the head sha it was viewed at: a later change to it shows.
 final  Map<String, String> _viewed;
/// Path to the head sha it was viewed at: a later change to it shows.
@override@JsonKey() Map<String, String> get viewed {
  if (_viewed is EqualUnmodifiableMapView) return _viewed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_viewed);
}

/// Null keeps the repository's default.
 final  List<String>? _hiddenTags;
/// Null keeps the repository's default.
@override List<String>? get hiddenTags {
  final value = _hiddenTags;
  if (value == null) return null;
  if (_hiddenTags is EqualUnmodifiableListView) return _hiddenTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Thread> _threads;
@override@JsonKey() List<Thread> get threads {
  if (_threads is EqualUnmodifiableListView) return _threads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_threads);
}

 final  List<Round> _rounds;
@override@JsonKey() List<Round> get rounds {
  if (_rounds is EqualUnmodifiableListView) return _rounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rounds);
}

/// The last Claude session on this review: answering a thread resumes
/// it, so the diff it read is still in its context.
@override final  String? sessionId;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.id, id) || other.id == id)&&(identical(other.project, project) || other.project == project)&&(identical(other.mr, mr) || other.mr == mr)&&(identical(other.baseRef, baseRef) || other.baseRef == baseRef)&&(identical(other.headRef, headRef) || other.headRef == headRef)&&(identical(other.local, local) || other.local == local)&&(identical(other.folder, folder) || other.folder == folder)&&(identical(other.own, own) || other.own == own)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.fileNotes, _fileNotes)&&const DeepCollectionEquality().equals(other.hunkNotes, _hunkNotes)&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.features, _features)&&const DeepCollectionEquality().equals(other.checklist, _checklist)&&const DeepCollectionEquality().equals(other.tickets, _tickets)&&const DeepCollectionEquality().equals(other.ticketChecks, _ticketChecks)&&const DeepCollectionEquality().equals(other.viewed, _viewed)&&const DeepCollectionEquality().equals(other.hiddenTags, _hiddenTags)&&const DeepCollectionEquality().equals(other.threads, _threads)&&const DeepCollectionEquality().equals(other.rounds, _rounds)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,project,mr,baseRef,headRef,local,folder,own,createdAt,updatedAt,const DeepCollectionEquality().hash(_fileNotes),const DeepCollectionEquality().hash(_hunkNotes),const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_checklist),const DeepCollectionEquality().hash(_tickets),const DeepCollectionEquality().hash(_ticketChecks),const DeepCollectionEquality().hash(_viewed),const DeepCollectionEquality().hash(_hiddenTags),const DeepCollectionEquality().hash(_threads),const DeepCollectionEquality().hash(_rounds),sessionId]);
}

@override
String toString() {
    return 'Review(id: $id, project: $project, mr: $mr, baseRef: $baseRef, headRef: $headRef, local: $local, folder: $folder, own: $own, createdAt: $createdAt, updatedAt: $updatedAt, fileNotes: $fileNotes, hunkNotes: $hunkNotes, groups: $groups, features: $features, checklist: $checklist, tickets: $tickets, ticketChecks: $ticketChecks, viewed: $viewed, hiddenTags: $hiddenTags, threads: $threads, rounds: $rounds, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String project, MrSource? mr, String baseRef, String headRef, bool local, String? folder, bool own, String createdAt, String updatedAt, List<FileNote> fileNotes, List<HunkNote> hunkNotes, List<ReviewGroup> groups, List<ReviewFeature> features, List<ChecklistItem> checklist, List<StoredTicket> tickets, List<TicketCheck> ticketChecks, Map<String, String> viewed, List<String>? hiddenTags, List<Thread> threads, List<Round> rounds, String? sessionId
});


@override $MrSourceCopyWith<$Res>? get mr;

}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? project = null,Object? mr = freezed,Object? baseRef = null,Object? headRef = null,Object? local = null,Object? folder = freezed,Object? own = null,Object? createdAt = null,Object? updatedAt = null,Object? fileNotes = null,Object? hunkNotes = null,Object? groups = null,Object? features = null,Object? checklist = null,Object? tickets = null,Object? ticketChecks = null,Object? viewed = null,Object? hiddenTags = freezed,Object? threads = null,Object? rounds = null,Object? sessionId = freezed,}) {
  return _then(_Review(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String,mr: freezed == mr ? _self.mr : mr // ignore: cast_nullable_to_non_nullable
as MrSource?,baseRef: null == baseRef ? _self.baseRef : baseRef // ignore: cast_nullable_to_non_nullable
as String,headRef: null == headRef ? _self.headRef : headRef // ignore: cast_nullable_to_non_nullable
as String,local: null == local ? _self.local : local // ignore: cast_nullable_to_non_nullable
as bool,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String?,own: null == own ? _self.own : own // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,fileNotes: null == fileNotes ? _self._fileNotes : fileNotes // ignore: cast_nullable_to_non_nullable
as List<FileNote>,hunkNotes: null == hunkNotes ? _self._hunkNotes : hunkNotes // ignore: cast_nullable_to_non_nullable
as List<HunkNote>,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<ReviewGroup>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<ReviewFeature>,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<StoredTicket>,ticketChecks: null == ticketChecks ? _self._ticketChecks : ticketChecks // ignore: cast_nullable_to_non_nullable
as List<TicketCheck>,viewed: null == viewed ? _self._viewed : viewed // ignore: cast_nullable_to_non_nullable
as Map<String, String>,hiddenTags: freezed == hiddenTags ? _self._hiddenTags : hiddenTags // ignore: cast_nullable_to_non_nullable
as List<String>?,threads: null == threads ? _self._threads : threads // ignore: cast_nullable_to_non_nullable
as List<Thread>,rounds: null == rounds ? _self._rounds : rounds // ignore: cast_nullable_to_non_nullable
as List<Round>,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MrSourceCopyWith<$Res>? get mr {
    if (_self.mr == null) {
    return null;
  }

  return $MrSourceCopyWith<$Res>(_self.mr!, (value) {
    return _then(_self.copyWith(mr: value));
  });
}
}

// dart format on
