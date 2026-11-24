// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardTag {

 TagTone get tone; String get label;
/// Create a copy of CardTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardTagCopyWith<CardTag> get copyWith => _$CardTagCopyWithImpl<CardTag>(this as CardTag, _$identity);

  /// Serializes this CardTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CardTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardTag&&(identical(other.tone, _this.tone) || other.tone == _this.tone)&&(identical(other.label, _this.label) || other.label == _this.label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CardTag;
  return Object.hash(runtimeType,_this.tone,_this.label);
}

@override
String toString() {
  final _this = this as CardTag;
  return 'CardTag(tone: ${_this.tone}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $CardTagCopyWith<$Res>  {
  factory $CardTagCopyWith(CardTag value, $Res Function(CardTag) _then) = _$CardTagCopyWithImpl;
@useResult
$Res call({
 TagTone tone, String label
});




}
/// @nodoc
class _$CardTagCopyWithImpl<$Res>
    implements $CardTagCopyWith<$Res> {
  _$CardTagCopyWithImpl(this._self, this._then);

  final CardTag _self;
  final $Res Function(CardTag) _then;

/// Create a copy of CardTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tone = null,Object? label = null,}) {
  return _then(CardTag(
null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as TagTone,null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CardTag].
extension CardTagPatterns on CardTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardTag value)  $default,){
final _that = this;
switch (_that) {
case _CardTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardTag value)?  $default,){
final _that = this;
switch (_that) {
case _CardTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TagTone tone,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardTag() when $default != null:
return $default(_that.tone,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TagTone tone,  String label)  $default,) {final _that = this;
switch (_that) {
case _CardTag():
return $default(_that.tone,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TagTone tone,  String label)?  $default,) {final _that = this;
switch (_that) {
case _CardTag() when $default != null:
return $default(_that.tone,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardTag implements CardTag {
  const _CardTag(this.tone, this.label);
  factory _CardTag.fromJson(Map<String, dynamic> json) => _$CardTagFromJson(json);

@override final  TagTone tone;
@override final  String label;

/// Create a copy of CardTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardTagCopyWith<_CardTag> get copyWith => __$CardTagCopyWithImpl<_CardTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardTag&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tone,label);
}

@override
String toString() {
    return 'CardTag(tone: $tone, label: $label)';
}


}

/// @nodoc
abstract mixin class _$CardTagCopyWith<$Res> implements $CardTagCopyWith<$Res> {
  factory _$CardTagCopyWith(_CardTag value, $Res Function(_CardTag) _then) = __$CardTagCopyWithImpl;
@override @useResult
$Res call({
 TagTone tone, String label
});




}
/// @nodoc
class __$CardTagCopyWithImpl<$Res>
    implements _$CardTagCopyWith<$Res> {
  __$CardTagCopyWithImpl(this._self, this._then);

  final _CardTag _self;
  final $Res Function(_CardTag) _then;

/// Create a copy of CardTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tone = null,Object? label = null,}) {
  return _then(_CardTag(
null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as TagTone,null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DeckCard {

 String get key; String get provider;@JsonKey(readValue: readLane) Lane get lane; String get ref; String get url; String get title;/// One line: what has to happen next.
 String get next; String? get why; List<CardTag> get tags; Bucket get bucket; int get score; DateTime? get updatedAt; String? get author; String? get path; int? get iid;/// A review from you is what it needs, first or again.
 bool get reviewable;/// Your own merge request: reviewers left threads that wait on you.
 bool get feedback; String? get channel; String? get project;/// Todos: where it came from (slack, mail, gitlab, github, jira, meeting, other).
 String? get source;/// Mail: ask, fyi, noise or phishing.
 String? get kind;/// Mail: the Gmail thread ids this card stands for, to archive them.
 List<String> get threads;/// Other items this card mentions that its title and link do not show: a
/// merge request's branch, the ticket or MR Claude read a message is
/// about. Links to cards are found from them (core/links.dart).
 List<String> get refs;
/// Create a copy of DeckCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeckCardCopyWith<DeckCard> get copyWith => _$DeckCardCopyWithImpl<DeckCard>(this as DeckCard, _$identity);

  /// Serializes this DeckCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeckCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeckCard&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.lane, _this.lane) || other.lane == _this.lane)&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.why, _this.why) || other.why == _this.why)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.bucket, _this.bucket) || other.bucket == _this.bucket)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.iid, _this.iid) || other.iid == _this.iid)&&(identical(other.reviewable, _this.reviewable) || other.reviewable == _this.reviewable)&&(identical(other.feedback, _this.feedback) || other.feedback == _this.feedback)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.project, _this.project) || other.project == _this.project)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&const DeepCollectionEquality().equals(other.threads, _this.threads)&&const DeepCollectionEquality().equals(other.refs, _this.refs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeckCard;
  return Object.hashAll([runtimeType,_this.key,_this.provider,_this.lane,_this.ref,_this.url,_this.title,_this.next,_this.why,const DeepCollectionEquality().hash(_this.tags),_this.bucket,_this.score,_this.updatedAt,_this.author,_this.path,_this.iid,_this.reviewable,_this.feedback,_this.channel,_this.project,_this.source,_this.kind,const DeepCollectionEquality().hash(_this.threads),const DeepCollectionEquality().hash(_this.refs)]);
}

@override
String toString() {
  final _this = this as DeckCard;
  return 'DeckCard(key: ${_this.key}, provider: ${_this.provider}, lane: ${_this.lane}, ref: ${_this.ref}, url: ${_this.url}, title: ${_this.title}, next: ${_this.next}, why: ${_this.why}, tags: ${_this.tags}, bucket: ${_this.bucket}, score: ${_this.score}, updatedAt: ${_this.updatedAt}, author: ${_this.author}, path: ${_this.path}, iid: ${_this.iid}, reviewable: ${_this.reviewable}, feedback: ${_this.feedback}, channel: ${_this.channel}, project: ${_this.project}, source: ${_this.source}, kind: ${_this.kind}, threads: ${_this.threads}, refs: ${_this.refs})';
}


}

/// @nodoc
abstract mixin class $DeckCardCopyWith<$Res>  {
  factory $DeckCardCopyWith(DeckCard value, $Res Function(DeckCard) _then) = _$DeckCardCopyWithImpl;
@useResult
$Res call({
 String key, String provider,@JsonKey(readValue: readLane) Lane lane, String ref, String url, String title, String next, String? why, List<CardTag> tags, Bucket bucket, int score, DateTime? updatedAt, String? author, String? path, int? iid, bool reviewable, bool feedback, String? channel, String? project, String? source, String? kind, List<String> threads, List<String> refs
});




}
/// @nodoc
class _$DeckCardCopyWithImpl<$Res>
    implements $DeckCardCopyWith<$Res> {
  _$DeckCardCopyWithImpl(this._self, this._then);

  final DeckCard _self;
  final $Res Function(DeckCard) _then;

/// Create a copy of DeckCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? provider = null,Object? lane = null,Object? ref = null,Object? url = null,Object? title = null,Object? next = null,Object? why = freezed,Object? tags = null,Object? bucket = null,Object? score = null,Object? updatedAt = freezed,Object? author = freezed,Object? path = freezed,Object? iid = freezed,Object? reviewable = null,Object? feedback = null,Object? channel = freezed,Object? project = freezed,Object? source = freezed,Object? kind = freezed,Object? threads = null,Object? refs = null,}) {
  return _then(DeckCard(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,lane: null == lane ? _self.lane : lane // ignore: cast_nullable_to_non_nullable
as Lane,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,why: freezed == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<CardTag>,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as Bucket,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,iid: freezed == iid ? _self.iid : iid // ignore: cast_nullable_to_non_nullable
as int?,reviewable: null == reviewable ? _self.reviewable : reviewable // ignore: cast_nullable_to_non_nullable
as bool,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as bool,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String?,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,threads: null == threads ? _self.threads : threads // ignore: cast_nullable_to_non_nullable
as List<String>,refs: null == refs ? _self.refs : refs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeckCard].
extension DeckCardPatterns on DeckCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeckCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeckCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeckCard value)  $default,){
final _that = this;
switch (_that) {
case _DeckCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeckCard value)?  $default,){
final _that = this;
switch (_that) {
case _DeckCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String provider, @JsonKey(readValue: readLane)  Lane lane,  String ref,  String url,  String title,  String next,  String? why,  List<CardTag> tags,  Bucket bucket,  int score,  DateTime? updatedAt,  String? author,  String? path,  int? iid,  bool reviewable,  bool feedback,  String? channel,  String? project,  String? source,  String? kind,  List<String> threads,  List<String> refs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeckCard() when $default != null:
return $default(_that.key,_that.provider,_that.lane,_that.ref,_that.url,_that.title,_that.next,_that.why,_that.tags,_that.bucket,_that.score,_that.updatedAt,_that.author,_that.path,_that.iid,_that.reviewable,_that.feedback,_that.channel,_that.project,_that.source,_that.kind,_that.threads,_that.refs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String provider, @JsonKey(readValue: readLane)  Lane lane,  String ref,  String url,  String title,  String next,  String? why,  List<CardTag> tags,  Bucket bucket,  int score,  DateTime? updatedAt,  String? author,  String? path,  int? iid,  bool reviewable,  bool feedback,  String? channel,  String? project,  String? source,  String? kind,  List<String> threads,  List<String> refs)  $default,) {final _that = this;
switch (_that) {
case _DeckCard():
return $default(_that.key,_that.provider,_that.lane,_that.ref,_that.url,_that.title,_that.next,_that.why,_that.tags,_that.bucket,_that.score,_that.updatedAt,_that.author,_that.path,_that.iid,_that.reviewable,_that.feedback,_that.channel,_that.project,_that.source,_that.kind,_that.threads,_that.refs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String provider, @JsonKey(readValue: readLane)  Lane lane,  String ref,  String url,  String title,  String next,  String? why,  List<CardTag> tags,  Bucket bucket,  int score,  DateTime? updatedAt,  String? author,  String? path,  int? iid,  bool reviewable,  bool feedback,  String? channel,  String? project,  String? source,  String? kind,  List<String> threads,  List<String> refs)?  $default,) {final _that = this;
switch (_that) {
case _DeckCard() when $default != null:
return $default(_that.key,_that.provider,_that.lane,_that.ref,_that.url,_that.title,_that.next,_that.why,_that.tags,_that.bucket,_that.score,_that.updatedAt,_that.author,_that.path,_that.iid,_that.reviewable,_that.feedback,_that.channel,_that.project,_that.source,_that.kind,_that.threads,_that.refs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeckCard implements DeckCard {
  const _DeckCard({required this.key, required this.provider, @JsonKey(readValue: readLane) required this.lane, required this.ref, required this.url, required this.title, required this.next, this.why,  List<CardTag> tags = const [], required this.bucket, required this.score, this.updatedAt, this.author, this.path, this.iid, this.reviewable = false, this.feedback = false, this.channel, this.project, this.source, this.kind,  List<String> threads = const [],  List<String> refs = const []}): _tags = tags,_threads = threads,_refs = refs;
  factory _DeckCard.fromJson(Map<String, dynamic> json) => _$DeckCardFromJson(json);

@override final  String key;
@override final  String provider;
@override@JsonKey(readValue: readLane) final  Lane lane;
@override final  String ref;
@override final  String url;
@override final  String title;
/// One line: what has to happen next.
@override final  String next;
@override final  String? why;
 final  List<CardTag> _tags;
@override@JsonKey() List<CardTag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  Bucket bucket;
@override final  int score;
@override final  DateTime? updatedAt;
@override final  String? author;
@override final  String? path;
@override final  int? iid;
/// A review from you is what it needs, first or again.
@override@JsonKey() final  bool reviewable;
/// Your own merge request: reviewers left threads that wait on you.
@override@JsonKey() final  bool feedback;
@override final  String? channel;
@override final  String? project;
/// Todos: where it came from (slack, mail, gitlab, github, jira, meeting, other).
@override final  String? source;
/// Mail: ask, fyi, noise or phishing.
@override final  String? kind;
/// Mail: the Gmail thread ids this card stands for, to archive them.
 final  List<String> _threads;
/// Mail: the Gmail thread ids this card stands for, to archive them.
@override@JsonKey() List<String> get threads {
  if (_threads is EqualUnmodifiableListView) return _threads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_threads);
}

/// Other items this card mentions that its title and link do not show: a
/// merge request's branch, the ticket or MR Claude read a message is
/// about. Links to cards are found from them (core/links.dart).
 final  List<String> _refs;
/// Other items this card mentions that its title and link do not show: a
/// merge request's branch, the ticket or MR Claude read a message is
/// about. Links to cards are found from them (core/links.dart).
@override@JsonKey() List<String> get refs {
  if (_refs is EqualUnmodifiableListView) return _refs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_refs);
}


/// Create a copy of DeckCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeckCardCopyWith<_DeckCard> get copyWith => __$DeckCardCopyWithImpl<_DeckCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeckCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeckCard&&(identical(other.key, key) || other.key == key)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.lane, lane) || other.lane == lane)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.next, next) || other.next == next)&&(identical(other.why, why) || other.why == why)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&(identical(other.score, score) || other.score == score)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.author, author) || other.author == author)&&(identical(other.path, path) || other.path == path)&&(identical(other.iid, iid) || other.iid == iid)&&(identical(other.reviewable, reviewable) || other.reviewable == reviewable)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.project, project) || other.project == project)&&(identical(other.source, source) || other.source == source)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.threads, _threads)&&const DeepCollectionEquality().equals(other.refs, _refs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,key,provider,lane,ref,url,title,next,why,const DeepCollectionEquality().hash(_tags),bucket,score,updatedAt,author,path,iid,reviewable,feedback,channel,project,source,kind,const DeepCollectionEquality().hash(_threads),const DeepCollectionEquality().hash(_refs)]);
}

@override
String toString() {
    return 'DeckCard(key: $key, provider: $provider, lane: $lane, ref: $ref, url: $url, title: $title, next: $next, why: $why, tags: $tags, bucket: $bucket, score: $score, updatedAt: $updatedAt, author: $author, path: $path, iid: $iid, reviewable: $reviewable, feedback: $feedback, channel: $channel, project: $project, source: $source, kind: $kind, threads: $threads, refs: $refs)';
}


}

/// @nodoc
abstract mixin class _$DeckCardCopyWith<$Res> implements $DeckCardCopyWith<$Res> {
  factory _$DeckCardCopyWith(_DeckCard value, $Res Function(_DeckCard) _then) = __$DeckCardCopyWithImpl;
@override @useResult
$Res call({
 String key, String provider,@JsonKey(readValue: readLane) Lane lane, String ref, String url, String title, String next, String? why, List<CardTag> tags, Bucket bucket, int score, DateTime? updatedAt, String? author, String? path, int? iid, bool reviewable, bool feedback, String? channel, String? project, String? source, String? kind, List<String> threads, List<String> refs
});




}
/// @nodoc
class __$DeckCardCopyWithImpl<$Res>
    implements _$DeckCardCopyWith<$Res> {
  __$DeckCardCopyWithImpl(this._self, this._then);

  final _DeckCard _self;
  final $Res Function(_DeckCard) _then;

/// Create a copy of DeckCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? provider = null,Object? lane = null,Object? ref = null,Object? url = null,Object? title = null,Object? next = null,Object? why = freezed,Object? tags = null,Object? bucket = null,Object? score = null,Object? updatedAt = freezed,Object? author = freezed,Object? path = freezed,Object? iid = freezed,Object? reviewable = null,Object? feedback = null,Object? channel = freezed,Object? project = freezed,Object? source = freezed,Object? kind = freezed,Object? threads = null,Object? refs = null,}) {
  return _then(_DeckCard(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,lane: null == lane ? _self.lane : lane // ignore: cast_nullable_to_non_nullable
as Lane,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,why: freezed == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<CardTag>,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as Bucket,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,iid: freezed == iid ? _self.iid : iid // ignore: cast_nullable_to_non_nullable
as int?,reviewable: null == reviewable ? _self.reviewable : reviewable // ignore: cast_nullable_to_non_nullable
as bool,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as bool,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String?,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,threads: null == threads ? _self._threads : threads // ignore: cast_nullable_to_non_nullable
as List<String>,refs: null == refs ? _self._refs : refs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
