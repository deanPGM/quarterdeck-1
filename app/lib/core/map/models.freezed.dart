// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GraphNode {

/// The symbol as the code names it, unique in the graph.
 String get name;/// added, changed, removed or context. The map draws context only.
 String get status; String get edited; String get role; String? get path; int? get line;/// The lane it runs in (clock, parent, cloud). Absent with one lane.
 String? get side;/// The id of the feature this node is borrowed from.
 String? get feature;
/// Create a copy of GraphNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraphNodeCopyWith<GraphNode> get copyWith => _$GraphNodeCopyWithImpl<GraphNode>(this as GraphNode, _$identity);

  /// Serializes this GraphNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GraphNode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphNode&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.edited, _this.edited) || other.edited == _this.edited)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line)&&(identical(other.side, _this.side) || other.side == _this.side)&&(identical(other.feature, _this.feature) || other.feature == _this.feature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GraphNode;
  return Object.hash(runtimeType,_this.name,_this.status,_this.edited,_this.role,_this.path,_this.line,_this.side,_this.feature);
}

@override
String toString() {
  final _this = this as GraphNode;
  return 'GraphNode(name: ${_this.name}, status: ${_this.status}, edited: ${_this.edited}, role: ${_this.role}, path: ${_this.path}, line: ${_this.line}, side: ${_this.side}, feature: ${_this.feature})';
}


}

/// @nodoc
abstract mixin class $GraphNodeCopyWith<$Res>  {
  factory $GraphNodeCopyWith(GraphNode value, $Res Function(GraphNode) _then) = _$GraphNodeCopyWithImpl;
@useResult
$Res call({
 String name, String status, String edited, String role, String? path, int? line, String? side, String? feature
});




}
/// @nodoc
class _$GraphNodeCopyWithImpl<$Res>
    implements $GraphNodeCopyWith<$Res> {
  _$GraphNodeCopyWithImpl(this._self, this._then);

  final GraphNode _self;
  final $Res Function(GraphNode) _then;

/// Create a copy of GraphNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,Object? edited = null,Object? role = null,Object? path = freezed,Object? line = freezed,Object? side = freezed,Object? feature = freezed,}) {
  return _then(GraphNode(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,side: freezed == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String?,feature: freezed == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GraphNode].
extension GraphNodePatterns on GraphNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GraphNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GraphNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GraphNode value)  $default,){
final _that = this;
switch (_that) {
case _GraphNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GraphNode value)?  $default,){
final _that = this;
switch (_that) {
case _GraphNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String status,  String edited,  String role,  String? path,  int? line,  String? side,  String? feature)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GraphNode() when $default != null:
return $default(_that.name,_that.status,_that.edited,_that.role,_that.path,_that.line,_that.side,_that.feature);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String status,  String edited,  String role,  String? path,  int? line,  String? side,  String? feature)  $default,) {final _that = this;
switch (_that) {
case _GraphNode():
return $default(_that.name,_that.status,_that.edited,_that.role,_that.path,_that.line,_that.side,_that.feature);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String status,  String edited,  String role,  String? path,  int? line,  String? side,  String? feature)?  $default,) {final _that = this;
switch (_that) {
case _GraphNode() when $default != null:
return $default(_that.name,_that.status,_that.edited,_that.role,_that.path,_that.line,_that.side,_that.feature);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GraphNode implements GraphNode {
  const _GraphNode({required this.name, this.status = 'context', this.edited = '', this.role = '', this.path, this.line, this.side, this.feature});
  factory _GraphNode.fromJson(Map<String, dynamic> json) => _$GraphNodeFromJson(json);

/// The symbol as the code names it, unique in the graph.
@override final  String name;
/// added, changed, removed or context. The map draws context only.
@override@JsonKey() final  String status;
@override@JsonKey() final  String edited;
@override@JsonKey() final  String role;
@override final  String? path;
@override final  int? line;
/// The lane it runs in (clock, parent, cloud). Absent with one lane.
@override final  String? side;
/// The id of the feature this node is borrowed from.
@override final  String? feature;

/// Create a copy of GraphNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GraphNodeCopyWith<_GraphNode> get copyWith => __$GraphNodeCopyWithImpl<_GraphNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GraphNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GraphNode&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.edited, edited) || other.edited == edited)&&(identical(other.role, role) || other.role == role)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line)&&(identical(other.side, side) || other.side == side)&&(identical(other.feature, feature) || other.feature == feature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,status,edited,role,path,line,side,feature);
}

@override
String toString() {
    return 'GraphNode(name: $name, status: $status, edited: $edited, role: $role, path: $path, line: $line, side: $side, feature: $feature)';
}


}

/// @nodoc
abstract mixin class _$GraphNodeCopyWith<$Res> implements $GraphNodeCopyWith<$Res> {
  factory _$GraphNodeCopyWith(_GraphNode value, $Res Function(_GraphNode) _then) = __$GraphNodeCopyWithImpl;
@override @useResult
$Res call({
 String name, String status, String edited, String role, String? path, int? line, String? side, String? feature
});




}
/// @nodoc
class __$GraphNodeCopyWithImpl<$Res>
    implements _$GraphNodeCopyWith<$Res> {
  __$GraphNodeCopyWithImpl(this._self, this._then);

  final _GraphNode _self;
  final $Res Function(_GraphNode) _then;

/// Create a copy of GraphNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,Object? edited = null,Object? role = null,Object? path = freezed,Object? line = freezed,Object? side = freezed,Object? feature = freezed,}) {
  return _then(_GraphNode(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,side: freezed == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String?,feature: freezed == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GraphEdge {

 String get from; String get to; String get kind; String get label;
/// Create a copy of GraphEdge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraphEdgeCopyWith<GraphEdge> get copyWith => _$GraphEdgeCopyWithImpl<GraphEdge>(this as GraphEdge, _$identity);

  /// Serializes this GraphEdge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GraphEdge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphEdge&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.label, _this.label) || other.label == _this.label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GraphEdge;
  return Object.hash(runtimeType,_this.from,_this.to,_this.kind,_this.label);
}

@override
String toString() {
  final _this = this as GraphEdge;
  return 'GraphEdge(from: ${_this.from}, to: ${_this.to}, kind: ${_this.kind}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $GraphEdgeCopyWith<$Res>  {
  factory $GraphEdgeCopyWith(GraphEdge value, $Res Function(GraphEdge) _then) = _$GraphEdgeCopyWithImpl;
@useResult
$Res call({
 String from, String to, String kind, String label
});




}
/// @nodoc
class _$GraphEdgeCopyWithImpl<$Res>
    implements $GraphEdgeCopyWith<$Res> {
  _$GraphEdgeCopyWithImpl(this._self, this._then);

  final GraphEdge _self;
  final $Res Function(GraphEdge) _then;

/// Create a copy of GraphEdge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? kind = null,Object? label = null,}) {
  return _then(GraphEdge(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GraphEdge].
extension GraphEdgePatterns on GraphEdge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GraphEdge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GraphEdge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GraphEdge value)  $default,){
final _that = this;
switch (_that) {
case _GraphEdge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GraphEdge value)?  $default,){
final _that = this;
switch (_that) {
case _GraphEdge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to,  String kind,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GraphEdge() when $default != null:
return $default(_that.from,_that.to,_that.kind,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to,  String kind,  String label)  $default,) {final _that = this;
switch (_that) {
case _GraphEdge():
return $default(_that.from,_that.to,_that.kind,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to,  String kind,  String label)?  $default,) {final _that = this;
switch (_that) {
case _GraphEdge() when $default != null:
return $default(_that.from,_that.to,_that.kind,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GraphEdge implements GraphEdge {
  const _GraphEdge({required this.from, required this.to, required this.kind, this.label = ''});
  factory _GraphEdge.fromJson(Map<String, dynamic> json) => _$GraphEdgeFromJson(json);

@override final  String from;
@override final  String to;
@override final  String kind;
@override@JsonKey() final  String label;

/// Create a copy of GraphEdge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GraphEdgeCopyWith<_GraphEdge> get copyWith => __$GraphEdgeCopyWithImpl<_GraphEdge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GraphEdgeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GraphEdge&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,to,kind,label);
}

@override
String toString() {
    return 'GraphEdge(from: $from, to: $to, kind: $kind, label: $label)';
}


}

/// @nodoc
abstract mixin class _$GraphEdgeCopyWith<$Res> implements $GraphEdgeCopyWith<$Res> {
  factory _$GraphEdgeCopyWith(_GraphEdge value, $Res Function(_GraphEdge) _then) = __$GraphEdgeCopyWithImpl;
@override @useResult
$Res call({
 String from, String to, String kind, String label
});




}
/// @nodoc
class __$GraphEdgeCopyWithImpl<$Res>
    implements _$GraphEdgeCopyWith<$Res> {
  __$GraphEdgeCopyWithImpl(this._self, this._then);

  final _GraphEdge _self;
  final $Res Function(_GraphEdge) _then;

/// Create a copy of GraphEdge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? kind = null,Object? label = null,}) {
  return _then(_GraphEdge(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FeatureGraph {

 String get caption; List<GraphNode> get nodes; List<GraphEdge> get edges;
/// Create a copy of FeatureGraph
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureGraphCopyWith<FeatureGraph> get copyWith => _$FeatureGraphCopyWithImpl<FeatureGraph>(this as FeatureGraph, _$identity);

  /// Serializes this FeatureGraph to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeatureGraph;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureGraph&&(identical(other.caption, _this.caption) || other.caption == _this.caption)&&const DeepCollectionEquality().equals(other.nodes, _this.nodes)&&const DeepCollectionEquality().equals(other.edges, _this.edges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeatureGraph;
  return Object.hash(runtimeType,_this.caption,const DeepCollectionEquality().hash(_this.nodes),const DeepCollectionEquality().hash(_this.edges));
}

@override
String toString() {
  final _this = this as FeatureGraph;
  return 'FeatureGraph(caption: ${_this.caption}, nodes: ${_this.nodes}, edges: ${_this.edges})';
}


}

/// @nodoc
abstract mixin class $FeatureGraphCopyWith<$Res>  {
  factory $FeatureGraphCopyWith(FeatureGraph value, $Res Function(FeatureGraph) _then) = _$FeatureGraphCopyWithImpl;
@useResult
$Res call({
 String caption, List<GraphNode> nodes, List<GraphEdge> edges
});




}
/// @nodoc
class _$FeatureGraphCopyWithImpl<$Res>
    implements $FeatureGraphCopyWith<$Res> {
  _$FeatureGraphCopyWithImpl(this._self, this._then);

  final FeatureGraph _self;
  final $Res Function(FeatureGraph) _then;

/// Create a copy of FeatureGraph
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? caption = null,Object? nodes = null,Object? edges = null,}) {
  return _then(FeatureGraph(
caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<GraphNode>,edges: null == edges ? _self.edges : edges // ignore: cast_nullable_to_non_nullable
as List<GraphEdge>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureGraph].
extension FeatureGraphPatterns on FeatureGraph {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureGraph value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureGraph() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureGraph value)  $default,){
final _that = this;
switch (_that) {
case _FeatureGraph():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureGraph value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureGraph() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String caption,  List<GraphNode> nodes,  List<GraphEdge> edges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureGraph() when $default != null:
return $default(_that.caption,_that.nodes,_that.edges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String caption,  List<GraphNode> nodes,  List<GraphEdge> edges)  $default,) {final _that = this;
switch (_that) {
case _FeatureGraph():
return $default(_that.caption,_that.nodes,_that.edges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String caption,  List<GraphNode> nodes,  List<GraphEdge> edges)?  $default,) {final _that = this;
switch (_that) {
case _FeatureGraph() when $default != null:
return $default(_that.caption,_that.nodes,_that.edges);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureGraph implements FeatureGraph {
  const _FeatureGraph({this.caption = '',  List<GraphNode> nodes = const [],  List<GraphEdge> edges = const []}): _nodes = nodes,_edges = edges;
  factory _FeatureGraph.fromJson(Map<String, dynamic> json) => _$FeatureGraphFromJson(json);

@override@JsonKey() final  String caption;
 final  List<GraphNode> _nodes;
@override@JsonKey() List<GraphNode> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}

 final  List<GraphEdge> _edges;
@override@JsonKey() List<GraphEdge> get edges {
  if (_edges is EqualUnmodifiableListView) return _edges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_edges);
}


/// Create a copy of FeatureGraph
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureGraphCopyWith<_FeatureGraph> get copyWith => __$FeatureGraphCopyWithImpl<_FeatureGraph>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureGraphToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureGraph&&(identical(other.caption, caption) || other.caption == caption)&&const DeepCollectionEquality().equals(other.nodes, _nodes)&&const DeepCollectionEquality().equals(other.edges, _edges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,caption,const DeepCollectionEquality().hash(_nodes),const DeepCollectionEquality().hash(_edges));
}

@override
String toString() {
    return 'FeatureGraph(caption: $caption, nodes: $nodes, edges: $edges)';
}


}

/// @nodoc
abstract mixin class _$FeatureGraphCopyWith<$Res> implements $FeatureGraphCopyWith<$Res> {
  factory _$FeatureGraphCopyWith(_FeatureGraph value, $Res Function(_FeatureGraph) _then) = __$FeatureGraphCopyWithImpl;
@override @useResult
$Res call({
 String caption, List<GraphNode> nodes, List<GraphEdge> edges
});




}
/// @nodoc
class __$FeatureGraphCopyWithImpl<$Res>
    implements _$FeatureGraphCopyWith<$Res> {
  __$FeatureGraphCopyWithImpl(this._self, this._then);

  final _FeatureGraph _self;
  final $Res Function(_FeatureGraph) _then;

/// Create a copy of FeatureGraph
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? caption = null,Object? nodes = null,Object? edges = null,}) {
  return _then(_FeatureGraph(
caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<GraphNode>,edges: null == edges ? _self._edges : edges // ignore: cast_nullable_to_non_nullable
as List<GraphEdge>,
  ));
}


}


/// @nodoc
mixin _$DiagramStep {

 String get title; String get detail; String get why; String? get path; int? get line;/// touched or concern.
 String? get mark;/// high, medium or low, with mark concern only.
 String? get severity;
/// Create a copy of DiagramStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagramStepCopyWith<DiagramStep> get copyWith => _$DiagramStepCopyWithImpl<DiagramStep>(this as DiagramStep, _$identity);

  /// Serializes this DiagramStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiagramStep;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagramStep&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&(identical(other.why, _this.why) || other.why == _this.why)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line)&&(identical(other.mark, _this.mark) || other.mark == _this.mark)&&(identical(other.severity, _this.severity) || other.severity == _this.severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiagramStep;
  return Object.hash(runtimeType,_this.title,_this.detail,_this.why,_this.path,_this.line,_this.mark,_this.severity);
}

@override
String toString() {
  final _this = this as DiagramStep;
  return 'DiagramStep(title: ${_this.title}, detail: ${_this.detail}, why: ${_this.why}, path: ${_this.path}, line: ${_this.line}, mark: ${_this.mark}, severity: ${_this.severity})';
}


}

/// @nodoc
abstract mixin class $DiagramStepCopyWith<$Res>  {
  factory $DiagramStepCopyWith(DiagramStep value, $Res Function(DiagramStep) _then) = _$DiagramStepCopyWithImpl;
@useResult
$Res call({
 String title, String detail, String why, String? path, int? line, String? mark, String? severity
});




}
/// @nodoc
class _$DiagramStepCopyWithImpl<$Res>
    implements $DiagramStepCopyWith<$Res> {
  _$DiagramStepCopyWithImpl(this._self, this._then);

  final DiagramStep _self;
  final $Res Function(DiagramStep) _then;

/// Create a copy of DiagramStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? detail = null,Object? why = null,Object? path = freezed,Object? line = freezed,Object? mark = freezed,Object? severity = freezed,}) {
  return _then(DiagramStep(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,mark: freezed == mark ? _self.mark : mark // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagramStep].
extension DiagramStepPatterns on DiagramStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagramStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagramStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagramStep value)  $default,){
final _that = this;
switch (_that) {
case _DiagramStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagramStep value)?  $default,){
final _that = this;
switch (_that) {
case _DiagramStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String detail,  String why,  String? path,  int? line,  String? mark,  String? severity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagramStep() when $default != null:
return $default(_that.title,_that.detail,_that.why,_that.path,_that.line,_that.mark,_that.severity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String detail,  String why,  String? path,  int? line,  String? mark,  String? severity)  $default,) {final _that = this;
switch (_that) {
case _DiagramStep():
return $default(_that.title,_that.detail,_that.why,_that.path,_that.line,_that.mark,_that.severity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String detail,  String why,  String? path,  int? line,  String? mark,  String? severity)?  $default,) {final _that = this;
switch (_that) {
case _DiagramStep() when $default != null:
return $default(_that.title,_that.detail,_that.why,_that.path,_that.line,_that.mark,_that.severity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiagramStep implements DiagramStep {
  const _DiagramStep({required this.title, this.detail = '', this.why = '', this.path, this.line, this.mark, this.severity});
  factory _DiagramStep.fromJson(Map<String, dynamic> json) => _$DiagramStepFromJson(json);

@override final  String title;
@override@JsonKey() final  String detail;
@override@JsonKey() final  String why;
@override final  String? path;
@override final  int? line;
/// touched or concern.
@override final  String? mark;
/// high, medium or low, with mark concern only.
@override final  String? severity;

/// Create a copy of DiagramStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagramStepCopyWith<_DiagramStep> get copyWith => __$DiagramStepCopyWithImpl<_DiagramStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiagramStepToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagramStep&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.why, why) || other.why == why)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line)&&(identical(other.mark, mark) || other.mark == mark)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,detail,why,path,line,mark,severity);
}

@override
String toString() {
    return 'DiagramStep(title: $title, detail: $detail, why: $why, path: $path, line: $line, mark: $mark, severity: $severity)';
}


}

/// @nodoc
abstract mixin class _$DiagramStepCopyWith<$Res> implements $DiagramStepCopyWith<$Res> {
  factory _$DiagramStepCopyWith(_DiagramStep value, $Res Function(_DiagramStep) _then) = __$DiagramStepCopyWithImpl;
@override @useResult
$Res call({
 String title, String detail, String why, String? path, int? line, String? mark, String? severity
});




}
/// @nodoc
class __$DiagramStepCopyWithImpl<$Res>
    implements _$DiagramStepCopyWith<$Res> {
  __$DiagramStepCopyWithImpl(this._self, this._then);

  final _DiagramStep _self;
  final $Res Function(_DiagramStep) _then;

/// Create a copy of DiagramStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? detail = null,Object? why = null,Object? path = freezed,Object? line = freezed,Object? mark = freezed,Object? severity = freezed,}) {
  return _then(_DiagramStep(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,mark: freezed == mark ? _self.mark : mark // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MapSequence {

/// The tab label. Empty reads as the main flow.
 String get title;/// mermaid sequenceDiagram source.
 String get mermaid; String get caption; List<DiagramStep> get steps;
/// Create a copy of MapSequence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapSequenceCopyWith<MapSequence> get copyWith => _$MapSequenceCopyWithImpl<MapSequence>(this as MapSequence, _$identity);

  /// Serializes this MapSequence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapSequence;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapSequence&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.mermaid, _this.mermaid) || other.mermaid == _this.mermaid)&&(identical(other.caption, _this.caption) || other.caption == _this.caption)&&const DeepCollectionEquality().equals(other.steps, _this.steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapSequence;
  return Object.hash(runtimeType,_this.title,_this.mermaid,_this.caption,const DeepCollectionEquality().hash(_this.steps));
}

@override
String toString() {
  final _this = this as MapSequence;
  return 'MapSequence(title: ${_this.title}, mermaid: ${_this.mermaid}, caption: ${_this.caption}, steps: ${_this.steps})';
}


}

/// @nodoc
abstract mixin class $MapSequenceCopyWith<$Res>  {
  factory $MapSequenceCopyWith(MapSequence value, $Res Function(MapSequence) _then) = _$MapSequenceCopyWithImpl;
@useResult
$Res call({
 String title, String mermaid, String caption, List<DiagramStep> steps
});




}
/// @nodoc
class _$MapSequenceCopyWithImpl<$Res>
    implements $MapSequenceCopyWith<$Res> {
  _$MapSequenceCopyWithImpl(this._self, this._then);

  final MapSequence _self;
  final $Res Function(MapSequence) _then;

/// Create a copy of MapSequence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? mermaid = null,Object? caption = null,Object? steps = null,}) {
  return _then(MapSequence(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mermaid: null == mermaid ? _self.mermaid : mermaid // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<DiagramStep>,
  ));
}

}


/// Adds pattern-matching-related methods to [MapSequence].
extension MapSequencePatterns on MapSequence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapSequence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapSequence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapSequence value)  $default,){
final _that = this;
switch (_that) {
case _MapSequence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapSequence value)?  $default,){
final _that = this;
switch (_that) {
case _MapSequence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String mermaid,  String caption,  List<DiagramStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapSequence() when $default != null:
return $default(_that.title,_that.mermaid,_that.caption,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String mermaid,  String caption,  List<DiagramStep> steps)  $default,) {final _that = this;
switch (_that) {
case _MapSequence():
return $default(_that.title,_that.mermaid,_that.caption,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String mermaid,  String caption,  List<DiagramStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _MapSequence() when $default != null:
return $default(_that.title,_that.mermaid,_that.caption,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapSequence implements MapSequence {
  const _MapSequence({this.title = '', required this.mermaid, this.caption = '',  List<DiagramStep> steps = const []}): _steps = steps;
  factory _MapSequence.fromJson(Map<String, dynamic> json) => _$MapSequenceFromJson(json);

/// The tab label. Empty reads as the main flow.
@override@JsonKey() final  String title;
/// mermaid sequenceDiagram source.
@override final  String mermaid;
@override@JsonKey() final  String caption;
 final  List<DiagramStep> _steps;
@override@JsonKey() List<DiagramStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of MapSequence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapSequenceCopyWith<_MapSequence> get copyWith => __$MapSequenceCopyWithImpl<_MapSequence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapSequenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapSequence&&(identical(other.title, title) || other.title == title)&&(identical(other.mermaid, mermaid) || other.mermaid == mermaid)&&(identical(other.caption, caption) || other.caption == caption)&&const DeepCollectionEquality().equals(other.steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,mermaid,caption,const DeepCollectionEquality().hash(_steps));
}

@override
String toString() {
    return 'MapSequence(title: $title, mermaid: $mermaid, caption: $caption, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$MapSequenceCopyWith<$Res> implements $MapSequenceCopyWith<$Res> {
  factory _$MapSequenceCopyWith(_MapSequence value, $Res Function(_MapSequence) _then) = __$MapSequenceCopyWithImpl;
@override @useResult
$Res call({
 String title, String mermaid, String caption, List<DiagramStep> steps
});




}
/// @nodoc
class __$MapSequenceCopyWithImpl<$Res>
    implements _$MapSequenceCopyWith<$Res> {
  __$MapSequenceCopyWithImpl(this._self, this._then);

  final _MapSequence _self;
  final $Res Function(_MapSequence) _then;

/// Create a copy of MapSequence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? mermaid = null,Object? caption = null,Object? steps = null,}) {
  return _then(_MapSequence(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mermaid: null == mermaid ? _self.mermaid : mermaid // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<DiagramStep>,
  ));
}


}


/// @nodoc
mixin _$MapTransition {

 String get title; String get detail; String? get path; int? get line;
/// Create a copy of MapTransition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapTransitionCopyWith<MapTransition> get copyWith => _$MapTransitionCopyWithImpl<MapTransition>(this as MapTransition, _$identity);

  /// Serializes this MapTransition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapTransition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTransition&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapTransition;
  return Object.hash(runtimeType,_this.title,_this.detail,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as MapTransition;
  return 'MapTransition(title: ${_this.title}, detail: ${_this.detail}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $MapTransitionCopyWith<$Res>  {
  factory $MapTransitionCopyWith(MapTransition value, $Res Function(MapTransition) _then) = _$MapTransitionCopyWithImpl;
@useResult
$Res call({
 String title, String detail, String? path, int? line
});




}
/// @nodoc
class _$MapTransitionCopyWithImpl<$Res>
    implements $MapTransitionCopyWith<$Res> {
  _$MapTransitionCopyWithImpl(this._self, this._then);

  final MapTransition _self;
  final $Res Function(MapTransition) _then;

/// Create a copy of MapTransition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? detail = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(MapTransition(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapTransition].
extension MapTransitionPatterns on MapTransition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapTransition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapTransition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapTransition value)  $default,){
final _that = this;
switch (_that) {
case _MapTransition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapTransition value)?  $default,){
final _that = this;
switch (_that) {
case _MapTransition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String detail,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapTransition() when $default != null:
return $default(_that.title,_that.detail,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String detail,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _MapTransition():
return $default(_that.title,_that.detail,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String detail,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _MapTransition() when $default != null:
return $default(_that.title,_that.detail,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapTransition implements MapTransition {
  const _MapTransition({required this.title, this.detail = '', this.path, this.line});
  factory _MapTransition.fromJson(Map<String, dynamic> json) => _$MapTransitionFromJson(json);

@override final  String title;
@override@JsonKey() final  String detail;
@override final  String? path;
@override final  int? line;

/// Create a copy of MapTransition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapTransitionCopyWith<_MapTransition> get copyWith => __$MapTransitionCopyWithImpl<_MapTransition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapTransitionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapTransition&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,detail,path,line);
}

@override
String toString() {
    return 'MapTransition(title: $title, detail: $detail, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$MapTransitionCopyWith<$Res> implements $MapTransitionCopyWith<$Res> {
  factory _$MapTransitionCopyWith(_MapTransition value, $Res Function(_MapTransition) _then) = __$MapTransitionCopyWithImpl;
@override @useResult
$Res call({
 String title, String detail, String? path, int? line
});




}
/// @nodoc
class __$MapTransitionCopyWithImpl<$Res>
    implements _$MapTransitionCopyWith<$Res> {
  __$MapTransitionCopyWithImpl(this._self, this._then);

  final _MapTransition _self;
  final $Res Function(_MapTransition) _then;

/// Create a copy of MapTransition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? detail = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_MapTransition(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MapState {

 String get title; String get caption;/// mermaid stateDiagram-v2 source.
 String get mermaid; List<MapTransition> get transitions;
/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapStateCopyWith<MapState> get copyWith => _$MapStateCopyWithImpl<MapState>(this as MapState, _$identity);

  /// Serializes this MapState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapState&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.caption, _this.caption) || other.caption == _this.caption)&&(identical(other.mermaid, _this.mermaid) || other.mermaid == _this.mermaid)&&const DeepCollectionEquality().equals(other.transitions, _this.transitions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapState;
  return Object.hash(runtimeType,_this.title,_this.caption,_this.mermaid,const DeepCollectionEquality().hash(_this.transitions));
}

@override
String toString() {
  final _this = this as MapState;
  return 'MapState(title: ${_this.title}, caption: ${_this.caption}, mermaid: ${_this.mermaid}, transitions: ${_this.transitions})';
}


}

/// @nodoc
abstract mixin class $MapStateCopyWith<$Res>  {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) _then) = _$MapStateCopyWithImpl;
@useResult
$Res call({
 String title, String caption, String mermaid, List<MapTransition> transitions
});




}
/// @nodoc
class _$MapStateCopyWithImpl<$Res>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._self, this._then);

  final MapState _self;
  final $Res Function(MapState) _then;

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? caption = null,Object? mermaid = null,Object? transitions = null,}) {
  return _then(MapState(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,mermaid: null == mermaid ? _self.mermaid : mermaid // ignore: cast_nullable_to_non_nullable
as String,transitions: null == transitions ? _self.transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<MapTransition>,
  ));
}

}


/// Adds pattern-matching-related methods to [MapState].
extension MapStatePatterns on MapState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapState value)  $default,){
final _that = this;
switch (_that) {
case _MapState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapState value)?  $default,){
final _that = this;
switch (_that) {
case _MapState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String caption,  String mermaid,  List<MapTransition> transitions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that.title,_that.caption,_that.mermaid,_that.transitions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String caption,  String mermaid,  List<MapTransition> transitions)  $default,) {final _that = this;
switch (_that) {
case _MapState():
return $default(_that.title,_that.caption,_that.mermaid,_that.transitions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String caption,  String mermaid,  List<MapTransition> transitions)?  $default,) {final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that.title,_that.caption,_that.mermaid,_that.transitions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapState implements MapState {
  const _MapState({required this.title, this.caption = '', required this.mermaid,  List<MapTransition> transitions = const []}): _transitions = transitions;
  factory _MapState.fromJson(Map<String, dynamic> json) => _$MapStateFromJson(json);

@override final  String title;
@override@JsonKey() final  String caption;
/// mermaid stateDiagram-v2 source.
@override final  String mermaid;
 final  List<MapTransition> _transitions;
@override@JsonKey() List<MapTransition> get transitions {
  if (_transitions is EqualUnmodifiableListView) return _transitions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transitions);
}


/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapStateCopyWith<_MapState> get copyWith => __$MapStateCopyWithImpl<_MapState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapState&&(identical(other.title, title) || other.title == title)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.mermaid, mermaid) || other.mermaid == mermaid)&&const DeepCollectionEquality().equals(other.transitions, _transitions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,caption,mermaid,const DeepCollectionEquality().hash(_transitions));
}

@override
String toString() {
    return 'MapState(title: $title, caption: $caption, mermaid: $mermaid, transitions: $transitions)';
}


}

/// @nodoc
abstract mixin class _$MapStateCopyWith<$Res> implements $MapStateCopyWith<$Res> {
  factory _$MapStateCopyWith(_MapState value, $Res Function(_MapState) _then) = __$MapStateCopyWithImpl;
@override @useResult
$Res call({
 String title, String caption, String mermaid, List<MapTransition> transitions
});




}
/// @nodoc
class __$MapStateCopyWithImpl<$Res>
    implements _$MapStateCopyWith<$Res> {
  __$MapStateCopyWithImpl(this._self, this._then);

  final _MapState _self;
  final $Res Function(_MapState) _then;

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? caption = null,Object? mermaid = null,Object? transitions = null,}) {
  return _then(_MapState(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,mermaid: null == mermaid ? _self.mermaid : mermaid // ignore: cast_nullable_to_non_nullable
as String,transitions: null == transitions ? _self._transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<MapTransition>,
  ));
}


}


/// @nodoc
mixin _$MapLink {

 String get feature; String get kind; String get detail; String? get path; int? get line;
/// Create a copy of MapLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapLinkCopyWith<MapLink> get copyWith => _$MapLinkCopyWithImpl<MapLink>(this as MapLink, _$identity);

  /// Serializes this MapLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapLink;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapLink&&(identical(other.feature, _this.feature) || other.feature == _this.feature)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapLink;
  return Object.hash(runtimeType,_this.feature,_this.kind,_this.detail,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as MapLink;
  return 'MapLink(feature: ${_this.feature}, kind: ${_this.kind}, detail: ${_this.detail}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $MapLinkCopyWith<$Res>  {
  factory $MapLinkCopyWith(MapLink value, $Res Function(MapLink) _then) = _$MapLinkCopyWithImpl;
@useResult
$Res call({
 String feature, String kind, String detail, String? path, int? line
});




}
/// @nodoc
class _$MapLinkCopyWithImpl<$Res>
    implements $MapLinkCopyWith<$Res> {
  _$MapLinkCopyWithImpl(this._self, this._then);

  final MapLink _self;
  final $Res Function(MapLink) _then;

/// Create a copy of MapLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feature = null,Object? kind = null,Object? detail = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(MapLink(
feature: null == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapLink].
extension MapLinkPatterns on MapLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapLink value)  $default,){
final _that = this;
switch (_that) {
case _MapLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapLink value)?  $default,){
final _that = this;
switch (_that) {
case _MapLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String feature,  String kind,  String detail,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapLink() when $default != null:
return $default(_that.feature,_that.kind,_that.detail,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String feature,  String kind,  String detail,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _MapLink():
return $default(_that.feature,_that.kind,_that.detail,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String feature,  String kind,  String detail,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _MapLink() when $default != null:
return $default(_that.feature,_that.kind,_that.detail,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapLink implements MapLink {
  const _MapLink({required this.feature, required this.kind, this.detail = '', this.path, this.line});
  factory _MapLink.fromJson(Map<String, dynamic> json) => _$MapLinkFromJson(json);

@override final  String feature;
@override final  String kind;
@override@JsonKey() final  String detail;
@override final  String? path;
@override final  int? line;

/// Create a copy of MapLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapLinkCopyWith<_MapLink> get copyWith => __$MapLinkCopyWithImpl<_MapLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapLinkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapLink&&(identical(other.feature, feature) || other.feature == feature)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,feature,kind,detail,path,line);
}

@override
String toString() {
    return 'MapLink(feature: $feature, kind: $kind, detail: $detail, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$MapLinkCopyWith<$Res> implements $MapLinkCopyWith<$Res> {
  factory _$MapLinkCopyWith(_MapLink value, $Res Function(_MapLink) _then) = __$MapLinkCopyWithImpl;
@override @useResult
$Res call({
 String feature, String kind, String detail, String? path, int? line
});




}
/// @nodoc
class __$MapLinkCopyWithImpl<$Res>
    implements _$MapLinkCopyWith<$Res> {
  __$MapLinkCopyWithImpl(this._self, this._then);

  final _MapLink _self;
  final $Res Function(_MapLink) _then;

/// Create a copy of MapLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feature = null,Object? kind = null,Object? detail = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_MapLink(
feature: null == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MapNote {

 String get kind; String get text; String? get path; int? get line;
/// Create a copy of MapNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapNoteCopyWith<MapNote> get copyWith => _$MapNoteCopyWithImpl<MapNote>(this as MapNote, _$identity);

  /// Serializes this MapNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapNote&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapNote;
  return Object.hash(runtimeType,_this.kind,_this.text,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as MapNote;
  return 'MapNote(kind: ${_this.kind}, text: ${_this.text}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $MapNoteCopyWith<$Res>  {
  factory $MapNoteCopyWith(MapNote value, $Res Function(MapNote) _then) = _$MapNoteCopyWithImpl;
@useResult
$Res call({
 String kind, String text, String? path, int? line
});




}
/// @nodoc
class _$MapNoteCopyWithImpl<$Res>
    implements $MapNoteCopyWith<$Res> {
  _$MapNoteCopyWithImpl(this._self, this._then);

  final MapNote _self;
  final $Res Function(MapNote) _then;

/// Create a copy of MapNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? text = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(MapNote(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapNote].
extension MapNotePatterns on MapNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapNote value)  $default,){
final _that = this;
switch (_that) {
case _MapNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapNote value)?  $default,){
final _that = this;
switch (_that) {
case _MapNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String text,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapNote() when $default != null:
return $default(_that.kind,_that.text,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String text,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _MapNote():
return $default(_that.kind,_that.text,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String text,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _MapNote() when $default != null:
return $default(_that.kind,_that.text,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapNote implements MapNote {
  const _MapNote({required this.kind, required this.text, this.path, this.line});
  factory _MapNote.fromJson(Map<String, dynamic> json) => _$MapNoteFromJson(json);

@override final  String kind;
@override final  String text;
@override final  String? path;
@override final  int? line;

/// Create a copy of MapNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapNoteCopyWith<_MapNote> get copyWith => __$MapNoteCopyWithImpl<_MapNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapNote&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,text,path,line);
}

@override
String toString() {
    return 'MapNote(kind: $kind, text: $text, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$MapNoteCopyWith<$Res> implements $MapNoteCopyWith<$Res> {
  factory _$MapNoteCopyWith(_MapNote value, $Res Function(_MapNote) _then) = __$MapNoteCopyWithImpl;
@override @useResult
$Res call({
 String kind, String text, String? path, int? line
});




}
/// @nodoc
class __$MapNoteCopyWithImpl<$Res>
    implements _$MapNoteCopyWith<$Res> {
  __$MapNoteCopyWithImpl(this._self, this._then);

  final _MapNote _self;
  final $Res Function(_MapNote) _then;

/// Create a copy of MapNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? text = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_MapNote(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MapDataUse {

 String get type; String get use; String get detail;
/// Create a copy of MapDataUse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDataUseCopyWith<MapDataUse> get copyWith => _$MapDataUseCopyWithImpl<MapDataUse>(this as MapDataUse, _$identity);

  /// Serializes this MapDataUse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapDataUse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDataUse&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.use, _this.use) || other.use == _this.use)&&(identical(other.detail, _this.detail) || other.detail == _this.detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapDataUse;
  return Object.hash(runtimeType,_this.type,_this.use,_this.detail);
}

@override
String toString() {
  final _this = this as MapDataUse;
  return 'MapDataUse(type: ${_this.type}, use: ${_this.use}, detail: ${_this.detail})';
}


}

/// @nodoc
abstract mixin class $MapDataUseCopyWith<$Res>  {
  factory $MapDataUseCopyWith(MapDataUse value, $Res Function(MapDataUse) _then) = _$MapDataUseCopyWithImpl;
@useResult
$Res call({
 String type, String use, String detail
});




}
/// @nodoc
class _$MapDataUseCopyWithImpl<$Res>
    implements $MapDataUseCopyWith<$Res> {
  _$MapDataUseCopyWithImpl(this._self, this._then);

  final MapDataUse _self;
  final $Res Function(MapDataUse) _then;

/// Create a copy of MapDataUse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? use = null,Object? detail = null,}) {
  return _then(MapDataUse(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,use: null == use ? _self.use : use // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MapDataUse].
extension MapDataUsePatterns on MapDataUse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapDataUse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapDataUse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapDataUse value)  $default,){
final _that = this;
switch (_that) {
case _MapDataUse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapDataUse value)?  $default,){
final _that = this;
switch (_that) {
case _MapDataUse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String use,  String detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapDataUse() when $default != null:
return $default(_that.type,_that.use,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String use,  String detail)  $default,) {final _that = this;
switch (_that) {
case _MapDataUse():
return $default(_that.type,_that.use,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String use,  String detail)?  $default,) {final _that = this;
switch (_that) {
case _MapDataUse() when $default != null:
return $default(_that.type,_that.use,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapDataUse implements MapDataUse {
  const _MapDataUse({required this.type, required this.use, this.detail = ''});
  factory _MapDataUse.fromJson(Map<String, dynamic> json) => _$MapDataUseFromJson(json);

@override final  String type;
@override final  String use;
@override@JsonKey() final  String detail;

/// Create a copy of MapDataUse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapDataUseCopyWith<_MapDataUse> get copyWith => __$MapDataUseCopyWithImpl<_MapDataUse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapDataUseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapDataUse&&(identical(other.type, type) || other.type == type)&&(identical(other.use, use) || other.use == use)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,use,detail);
}

@override
String toString() {
    return 'MapDataUse(type: $type, use: $use, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$MapDataUseCopyWith<$Res> implements $MapDataUseCopyWith<$Res> {
  factory _$MapDataUseCopyWith(_MapDataUse value, $Res Function(_MapDataUse) _then) = __$MapDataUseCopyWithImpl;
@override @useResult
$Res call({
 String type, String use, String detail
});




}
/// @nodoc
class __$MapDataUseCopyWithImpl<$Res>
    implements _$MapDataUseCopyWith<$Res> {
  __$MapDataUseCopyWithImpl(this._self, this._then);

  final _MapDataUse _self;
  final $Res Function(_MapDataUse) _then;

/// Create a copy of MapDataUse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? use = null,Object? detail = null,}) {
  return _then(_MapDataUse(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,use: null == use ? _self.use : use // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MapFeature {

 String get id; String get title; String get summary; FeatureGraph? get graph;/// Files and folders that implement it. A change under one makes it stale.
 List<String> get paths;/// The head it was drawn at.
 String get commit; String get updatedAt;@JsonKey(readValue: _readSequences) List<MapSequence> get sequences; List<MapState> get states; List<MapLink> get links; List<MapNote> get notes; List<MapDataUse> get data;
/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapFeatureCopyWith<MapFeature> get copyWith => _$MapFeatureCopyWithImpl<MapFeature>(this as MapFeature, _$identity);

  /// Serializes this MapFeature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapFeature;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapFeature&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.graph, _this.graph) || other.graph == _this.graph)&&const DeepCollectionEquality().equals(other.paths, _this.paths)&&(identical(other.commit, _this.commit) || other.commit == _this.commit)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.sequences, _this.sequences)&&const DeepCollectionEquality().equals(other.states, _this.states)&&const DeepCollectionEquality().equals(other.links, _this.links)&&const DeepCollectionEquality().equals(other.notes, _this.notes)&&const DeepCollectionEquality().equals(other.data, _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapFeature;
  return Object.hash(runtimeType,_this.id,_this.title,_this.summary,_this.graph,const DeepCollectionEquality().hash(_this.paths),_this.commit,_this.updatedAt,const DeepCollectionEquality().hash(_this.sequences),const DeepCollectionEquality().hash(_this.states),const DeepCollectionEquality().hash(_this.links),const DeepCollectionEquality().hash(_this.notes),const DeepCollectionEquality().hash(_this.data));
}

@override
String toString() {
  final _this = this as MapFeature;
  return 'MapFeature(id: ${_this.id}, title: ${_this.title}, summary: ${_this.summary}, graph: ${_this.graph}, paths: ${_this.paths}, commit: ${_this.commit}, updatedAt: ${_this.updatedAt}, sequences: ${_this.sequences}, states: ${_this.states}, links: ${_this.links}, notes: ${_this.notes}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $MapFeatureCopyWith<$Res>  {
  factory $MapFeatureCopyWith(MapFeature value, $Res Function(MapFeature) _then) = _$MapFeatureCopyWithImpl;
@useResult
$Res call({
 String id, String title, String summary, FeatureGraph? graph, List<String> paths, String commit, String updatedAt,@JsonKey(readValue: _readSequences) List<MapSequence> sequences, List<MapState> states, List<MapLink> links, List<MapNote> notes, List<MapDataUse> data
});


$FeatureGraphCopyWith<$Res>? get graph;

}
/// @nodoc
class _$MapFeatureCopyWithImpl<$Res>
    implements $MapFeatureCopyWith<$Res> {
  _$MapFeatureCopyWithImpl(this._self, this._then);

  final MapFeature _self;
  final $Res Function(MapFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? graph = freezed,Object? paths = null,Object? commit = null,Object? updatedAt = null,Object? sequences = null,Object? states = null,Object? links = null,Object? notes = null,Object? data = null,}) {
  return _then(MapFeature(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,graph: freezed == graph ? _self.graph : graph // ignore: cast_nullable_to_non_nullable
as FeatureGraph?,paths: null == paths ? _self.paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,sequences: null == sequences ? _self.sequences : sequences // ignore: cast_nullable_to_non_nullable
as List<MapSequence>,states: null == states ? _self.states : states // ignore: cast_nullable_to_non_nullable
as List<MapState>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<MapLink>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<MapNote>,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<MapDataUse>,
  ));
}
/// Create a copy of MapFeature
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
}
}


/// Adds pattern-matching-related methods to [MapFeature].
extension MapFeaturePatterns on MapFeature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapFeature value)  $default,){
final _that = this;
switch (_that) {
case _MapFeature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapFeature value)?  $default,){
final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  FeatureGraph? graph,  List<String> paths,  String commit,  String updatedAt, @JsonKey(readValue: _readSequences)  List<MapSequence> sequences,  List<MapState> states,  List<MapLink> links,  List<MapNote> notes,  List<MapDataUse> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.graph,_that.paths,_that.commit,_that.updatedAt,_that.sequences,_that.states,_that.links,_that.notes,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  FeatureGraph? graph,  List<String> paths,  String commit,  String updatedAt, @JsonKey(readValue: _readSequences)  List<MapSequence> sequences,  List<MapState> states,  List<MapLink> links,  List<MapNote> notes,  List<MapDataUse> data)  $default,) {final _that = this;
switch (_that) {
case _MapFeature():
return $default(_that.id,_that.title,_that.summary,_that.graph,_that.paths,_that.commit,_that.updatedAt,_that.sequences,_that.states,_that.links,_that.notes,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String summary,  FeatureGraph? graph,  List<String> paths,  String commit,  String updatedAt, @JsonKey(readValue: _readSequences)  List<MapSequence> sequences,  List<MapState> states,  List<MapLink> links,  List<MapNote> notes,  List<MapDataUse> data)?  $default,) {final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.graph,_that.paths,_that.commit,_that.updatedAt,_that.sequences,_that.states,_that.links,_that.notes,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapFeature implements MapFeature {
  const _MapFeature({required this.id, required this.title, this.summary = '', this.graph,  List<String> paths = const [], this.commit = '', this.updatedAt = '', @JsonKey(readValue: _readSequences)  List<MapSequence> sequences = const [],  List<MapState> states = const [],  List<MapLink> links = const [],  List<MapNote> notes = const [],  List<MapDataUse> data = const []}): _paths = paths,_sequences = sequences,_states = states,_links = links,_notes = notes,_data = data;
  factory _MapFeature.fromJson(Map<String, dynamic> json) => _$MapFeatureFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String summary;
@override final  FeatureGraph? graph;
/// Files and folders that implement it. A change under one makes it stale.
 final  List<String> _paths;
/// Files and folders that implement it. A change under one makes it stale.
@override@JsonKey() List<String> get paths {
  if (_paths is EqualUnmodifiableListView) return _paths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paths);
}

/// The head it was drawn at.
@override@JsonKey() final  String commit;
@override@JsonKey() final  String updatedAt;
 final  List<MapSequence> _sequences;
@override@JsonKey(readValue: _readSequences) List<MapSequence> get sequences {
  if (_sequences is EqualUnmodifiableListView) return _sequences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sequences);
}

 final  List<MapState> _states;
@override@JsonKey() List<MapState> get states {
  if (_states is EqualUnmodifiableListView) return _states;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_states);
}

 final  List<MapLink> _links;
@override@JsonKey() List<MapLink> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}

 final  List<MapNote> _notes;
@override@JsonKey() List<MapNote> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

 final  List<MapDataUse> _data;
@override@JsonKey() List<MapDataUse> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapFeatureCopyWith<_MapFeature> get copyWith => __$MapFeatureCopyWithImpl<_MapFeature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapFeatureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapFeature&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.graph, graph) || other.graph == graph)&&const DeepCollectionEquality().equals(other.paths, _paths)&&(identical(other.commit, commit) || other.commit == commit)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.sequences, _sequences)&&const DeepCollectionEquality().equals(other.states, _states)&&const DeepCollectionEquality().equals(other.links, _links)&&const DeepCollectionEquality().equals(other.notes, _notes)&&const DeepCollectionEquality().equals(other.data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,summary,graph,const DeepCollectionEquality().hash(_paths),commit,updatedAt,const DeepCollectionEquality().hash(_sequences),const DeepCollectionEquality().hash(_states),const DeepCollectionEquality().hash(_links),const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'MapFeature(id: $id, title: $title, summary: $summary, graph: $graph, paths: $paths, commit: $commit, updatedAt: $updatedAt, sequences: $sequences, states: $states, links: $links, notes: $notes, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MapFeatureCopyWith<$Res> implements $MapFeatureCopyWith<$Res> {
  factory _$MapFeatureCopyWith(_MapFeature value, $Res Function(_MapFeature) _then) = __$MapFeatureCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String summary, FeatureGraph? graph, List<String> paths, String commit, String updatedAt,@JsonKey(readValue: _readSequences) List<MapSequence> sequences, List<MapState> states, List<MapLink> links, List<MapNote> notes, List<MapDataUse> data
});


@override $FeatureGraphCopyWith<$Res>? get graph;

}
/// @nodoc
class __$MapFeatureCopyWithImpl<$Res>
    implements _$MapFeatureCopyWith<$Res> {
  __$MapFeatureCopyWithImpl(this._self, this._then);

  final _MapFeature _self;
  final $Res Function(_MapFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? graph = freezed,Object? paths = null,Object? commit = null,Object? updatedAt = null,Object? sequences = null,Object? states = null,Object? links = null,Object? notes = null,Object? data = null,}) {
  return _then(_MapFeature(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,graph: freezed == graph ? _self.graph : graph // ignore: cast_nullable_to_non_nullable
as FeatureGraph?,paths: null == paths ? _self._paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,sequences: null == sequences ? _self._sequences : sequences // ignore: cast_nullable_to_non_nullable
as List<MapSequence>,states: null == states ? _self._states : states // ignore: cast_nullable_to_non_nullable
as List<MapState>,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<MapLink>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<MapNote>,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<MapDataUse>,
  ));
}

/// Create a copy of MapFeature
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
}
}


/// @nodoc
mixin _$MapDataField {

 String get name; String get type; String get note; bool get optional; String get since;
/// Create a copy of MapDataField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDataFieldCopyWith<MapDataField> get copyWith => _$MapDataFieldCopyWithImpl<MapDataField>(this as MapDataField, _$identity);

  /// Serializes this MapDataField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapDataField;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDataField&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.optional, _this.optional) || other.optional == _this.optional)&&(identical(other.since, _this.since) || other.since == _this.since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapDataField;
  return Object.hash(runtimeType,_this.name,_this.type,_this.note,_this.optional,_this.since);
}

@override
String toString() {
  final _this = this as MapDataField;
  return 'MapDataField(name: ${_this.name}, type: ${_this.type}, note: ${_this.note}, optional: ${_this.optional}, since: ${_this.since})';
}


}

/// @nodoc
abstract mixin class $MapDataFieldCopyWith<$Res>  {
  factory $MapDataFieldCopyWith(MapDataField value, $Res Function(MapDataField) _then) = _$MapDataFieldCopyWithImpl;
@useResult
$Res call({
 String name, String type, String note, bool optional, String since
});




}
/// @nodoc
class _$MapDataFieldCopyWithImpl<$Res>
    implements $MapDataFieldCopyWith<$Res> {
  _$MapDataFieldCopyWithImpl(this._self, this._then);

  final MapDataField _self;
  final $Res Function(MapDataField) _then;

/// Create a copy of MapDataField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? note = null,Object? optional = null,Object? since = null,}) {
  return _then(MapDataField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,optional: null == optional ? _self.optional : optional // ignore: cast_nullable_to_non_nullable
as bool,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MapDataField].
extension MapDataFieldPatterns on MapDataField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapDataField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapDataField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapDataField value)  $default,){
final _that = this;
switch (_that) {
case _MapDataField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapDataField value)?  $default,){
final _that = this;
switch (_that) {
case _MapDataField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type,  String note,  bool optional,  String since)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapDataField() when $default != null:
return $default(_that.name,_that.type,_that.note,_that.optional,_that.since);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type,  String note,  bool optional,  String since)  $default,) {final _that = this;
switch (_that) {
case _MapDataField():
return $default(_that.name,_that.type,_that.note,_that.optional,_that.since);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type,  String note,  bool optional,  String since)?  $default,) {final _that = this;
switch (_that) {
case _MapDataField() when $default != null:
return $default(_that.name,_that.type,_that.note,_that.optional,_that.since);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapDataField implements MapDataField {
  const _MapDataField({required this.name, required this.type, this.note = '', this.optional = false, this.since = ''});
  factory _MapDataField.fromJson(Map<String, dynamic> json) => _$MapDataFieldFromJson(json);

@override final  String name;
@override final  String type;
@override@JsonKey() final  String note;
@override@JsonKey() final  bool optional;
@override@JsonKey() final  String since;

/// Create a copy of MapDataField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapDataFieldCopyWith<_MapDataField> get copyWith => __$MapDataFieldCopyWithImpl<_MapDataField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapDataFieldToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapDataField&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note)&&(identical(other.optional, optional) || other.optional == optional)&&(identical(other.since, since) || other.since == since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,note,optional,since);
}

@override
String toString() {
    return 'MapDataField(name: $name, type: $type, note: $note, optional: $optional, since: $since)';
}


}

/// @nodoc
abstract mixin class _$MapDataFieldCopyWith<$Res> implements $MapDataFieldCopyWith<$Res> {
  factory _$MapDataFieldCopyWith(_MapDataField value, $Res Function(_MapDataField) _then) = __$MapDataFieldCopyWithImpl;
@override @useResult
$Res call({
 String name, String type, String note, bool optional, String since
});




}
/// @nodoc
class __$MapDataFieldCopyWithImpl<$Res>
    implements _$MapDataFieldCopyWith<$Res> {
  __$MapDataFieldCopyWithImpl(this._self, this._then);

  final _MapDataField _self;
  final $Res Function(_MapDataField) _then;

/// Create a copy of MapDataField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? note = null,Object? optional = null,Object? since = null,}) {
  return _then(_MapDataField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,optional: null == optional ? _self.optional : optional // ignore: cast_nullable_to_non_nullable
as bool,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MapDefinition {

 String get path; int? get line;
/// Create a copy of MapDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDefinitionCopyWith<MapDefinition> get copyWith => _$MapDefinitionCopyWithImpl<MapDefinition>(this as MapDefinition, _$identity);

  /// Serializes this MapDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapDefinition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDefinition&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapDefinition;
  return Object.hash(runtimeType,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as MapDefinition;
  return 'MapDefinition(path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $MapDefinitionCopyWith<$Res>  {
  factory $MapDefinitionCopyWith(MapDefinition value, $Res Function(MapDefinition) _then) = _$MapDefinitionCopyWithImpl;
@useResult
$Res call({
 String path, int? line
});




}
/// @nodoc
class _$MapDefinitionCopyWithImpl<$Res>
    implements $MapDefinitionCopyWith<$Res> {
  _$MapDefinitionCopyWithImpl(this._self, this._then);

  final MapDefinition _self;
  final $Res Function(MapDefinition) _then;

/// Create a copy of MapDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? line = freezed,}) {
  return _then(MapDefinition(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapDefinition].
extension MapDefinitionPatterns on MapDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapDefinition value)  $default,){
final _that = this;
switch (_that) {
case _MapDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _MapDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapDefinition() when $default != null:
return $default(_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _MapDefinition():
return $default(_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _MapDefinition() when $default != null:
return $default(_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapDefinition implements MapDefinition {
  const _MapDefinition({required this.path, this.line});
  factory _MapDefinition.fromJson(Map<String, dynamic> json) => _$MapDefinitionFromJson(json);

@override final  String path;
@override final  int? line;

/// Create a copy of MapDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapDefinitionCopyWith<_MapDefinition> get copyWith => __$MapDefinitionCopyWithImpl<_MapDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapDefinition&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,line);
}

@override
String toString() {
    return 'MapDefinition(path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$MapDefinitionCopyWith<$Res> implements $MapDefinitionCopyWith<$Res> {
  factory _$MapDefinitionCopyWith(_MapDefinition value, $Res Function(_MapDefinition) _then) = __$MapDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String path, int? line
});




}
/// @nodoc
class __$MapDefinitionCopyWithImpl<$Res>
    implements _$MapDefinitionCopyWith<$Res> {
  __$MapDefinitionCopyWithImpl(this._self, this._then);

  final _MapDefinition _self;
  final $Res Function(_MapDefinition) _then;

/// Create a copy of MapDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? line = freezed,}) {
  return _then(_MapDefinition(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MapDataType {

 String get id; String get name; String get boundary; String get summary; List<MapDataField> get fields; String get since; String get until; List<MapDefinition> get definitions; String get commit; String get updatedAt;
/// Create a copy of MapDataType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDataTypeCopyWith<MapDataType> get copyWith => _$MapDataTypeCopyWithImpl<MapDataType>(this as MapDataType, _$identity);

  /// Serializes this MapDataType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapDataType;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDataType&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.boundary, _this.boundary) || other.boundary == _this.boundary)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.fields, _this.fields)&&(identical(other.since, _this.since) || other.since == _this.since)&&(identical(other.until, _this.until) || other.until == _this.until)&&const DeepCollectionEquality().equals(other.definitions, _this.definitions)&&(identical(other.commit, _this.commit) || other.commit == _this.commit)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapDataType;
  return Object.hash(runtimeType,_this.id,_this.name,_this.boundary,_this.summary,const DeepCollectionEquality().hash(_this.fields),_this.since,_this.until,const DeepCollectionEquality().hash(_this.definitions),_this.commit,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MapDataType;
  return 'MapDataType(id: ${_this.id}, name: ${_this.name}, boundary: ${_this.boundary}, summary: ${_this.summary}, fields: ${_this.fields}, since: ${_this.since}, until: ${_this.until}, definitions: ${_this.definitions}, commit: ${_this.commit}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MapDataTypeCopyWith<$Res>  {
  factory $MapDataTypeCopyWith(MapDataType value, $Res Function(MapDataType) _then) = _$MapDataTypeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String boundary, String summary, List<MapDataField> fields, String since, String until, List<MapDefinition> definitions, String commit, String updatedAt
});




}
/// @nodoc
class _$MapDataTypeCopyWithImpl<$Res>
    implements $MapDataTypeCopyWith<$Res> {
  _$MapDataTypeCopyWithImpl(this._self, this._then);

  final MapDataType _self;
  final $Res Function(MapDataType) _then;

/// Create a copy of MapDataType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? boundary = null,Object? summary = null,Object? fields = null,Object? since = null,Object? until = null,Object? definitions = null,Object? commit = null,Object? updatedAt = null,}) {
  return _then(MapDataType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,boundary: null == boundary ? _self.boundary : boundary // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<MapDataField>,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as String,until: null == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as String,definitions: null == definitions ? _self.definitions : definitions // ignore: cast_nullable_to_non_nullable
as List<MapDefinition>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MapDataType].
extension MapDataTypePatterns on MapDataType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapDataType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapDataType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapDataType value)  $default,){
final _that = this;
switch (_that) {
case _MapDataType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapDataType value)?  $default,){
final _that = this;
switch (_that) {
case _MapDataType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String boundary,  String summary,  List<MapDataField> fields,  String since,  String until,  List<MapDefinition> definitions,  String commit,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapDataType() when $default != null:
return $default(_that.id,_that.name,_that.boundary,_that.summary,_that.fields,_that.since,_that.until,_that.definitions,_that.commit,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String boundary,  String summary,  List<MapDataField> fields,  String since,  String until,  List<MapDefinition> definitions,  String commit,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MapDataType():
return $default(_that.id,_that.name,_that.boundary,_that.summary,_that.fields,_that.since,_that.until,_that.definitions,_that.commit,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String boundary,  String summary,  List<MapDataField> fields,  String since,  String until,  List<MapDefinition> definitions,  String commit,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MapDataType() when $default != null:
return $default(_that.id,_that.name,_that.boundary,_that.summary,_that.fields,_that.since,_that.until,_that.definitions,_that.commit,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapDataType implements MapDataType {
  const _MapDataType({required this.id, required this.name, required this.boundary, this.summary = '',  List<MapDataField> fields = const [], this.since = '', this.until = '',  List<MapDefinition> definitions = const [], this.commit = '', this.updatedAt = ''}): _fields = fields,_definitions = definitions;
  factory _MapDataType.fromJson(Map<String, dynamic> json) => _$MapDataTypeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String boundary;
@override@JsonKey() final  String summary;
 final  List<MapDataField> _fields;
@override@JsonKey() List<MapDataField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

@override@JsonKey() final  String since;
@override@JsonKey() final  String until;
 final  List<MapDefinition> _definitions;
@override@JsonKey() List<MapDefinition> get definitions {
  if (_definitions is EqualUnmodifiableListView) return _definitions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_definitions);
}

@override@JsonKey() final  String commit;
@override@JsonKey() final  String updatedAt;

/// Create a copy of MapDataType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapDataTypeCopyWith<_MapDataType> get copyWith => __$MapDataTypeCopyWithImpl<_MapDataType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapDataTypeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapDataType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.boundary, boundary) || other.boundary == boundary)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.fields, _fields)&&(identical(other.since, since) || other.since == since)&&(identical(other.until, until) || other.until == until)&&const DeepCollectionEquality().equals(other.definitions, _definitions)&&(identical(other.commit, commit) || other.commit == commit)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,boundary,summary,const DeepCollectionEquality().hash(_fields),since,until,const DeepCollectionEquality().hash(_definitions),commit,updatedAt);
}

@override
String toString() {
    return 'MapDataType(id: $id, name: $name, boundary: $boundary, summary: $summary, fields: $fields, since: $since, until: $until, definitions: $definitions, commit: $commit, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MapDataTypeCopyWith<$Res> implements $MapDataTypeCopyWith<$Res> {
  factory _$MapDataTypeCopyWith(_MapDataType value, $Res Function(_MapDataType) _then) = __$MapDataTypeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String boundary, String summary, List<MapDataField> fields, String since, String until, List<MapDefinition> definitions, String commit, String updatedAt
});




}
/// @nodoc
class __$MapDataTypeCopyWithImpl<$Res>
    implements _$MapDataTypeCopyWith<$Res> {
  __$MapDataTypeCopyWithImpl(this._self, this._then);

  final _MapDataType _self;
  final $Res Function(_MapDataType) _then;

/// Create a copy of MapDataType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? boundary = null,Object? summary = null,Object? fields = null,Object? since = null,Object? until = null,Object? definitions = null,Object? commit = null,Object? updatedAt = null,}) {
  return _then(_MapDataType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,boundary: null == boundary ? _self.boundary : boundary // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<MapDataField>,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as String,until: null == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as String,definitions: null == definitions ? _self._definitions : definitions // ignore: cast_nullable_to_non_nullable
as List<MapDefinition>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ArchLayer {

/// A slug the rules and violations point at: view, view-model.
 String get id; String get name;/// One sentence: what this layer does and what it must not do.
 String get role;/// Class name patterns of the layer: `*Screen`, `*ViewModel`, `*Manager`.
 List<String> get naming;/// Folders or files where the layer lives.
 List<String> get paths;/// A few real classes, as the code names them.
 List<String> get examples;
/// Create a copy of ArchLayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchLayerCopyWith<ArchLayer> get copyWith => _$ArchLayerCopyWithImpl<ArchLayer>(this as ArchLayer, _$identity);

  /// Serializes this ArchLayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchLayer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchLayer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&const DeepCollectionEquality().equals(other.naming, _this.naming)&&const DeepCollectionEquality().equals(other.paths, _this.paths)&&const DeepCollectionEquality().equals(other.examples, _this.examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchLayer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role,const DeepCollectionEquality().hash(_this.naming),const DeepCollectionEquality().hash(_this.paths),const DeepCollectionEquality().hash(_this.examples));
}

@override
String toString() {
  final _this = this as ArchLayer;
  return 'ArchLayer(id: ${_this.id}, name: ${_this.name}, role: ${_this.role}, naming: ${_this.naming}, paths: ${_this.paths}, examples: ${_this.examples})';
}


}

/// @nodoc
abstract mixin class $ArchLayerCopyWith<$Res>  {
  factory $ArchLayerCopyWith(ArchLayer value, $Res Function(ArchLayer) _then) = _$ArchLayerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String role, List<String> naming, List<String> paths, List<String> examples
});




}
/// @nodoc
class _$ArchLayerCopyWithImpl<$Res>
    implements $ArchLayerCopyWith<$Res> {
  _$ArchLayerCopyWithImpl(this._self, this._then);

  final ArchLayer _self;
  final $Res Function(ArchLayer) _then;

/// Create a copy of ArchLayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? naming = null,Object? paths = null,Object? examples = null,}) {
  return _then(ArchLayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,naming: null == naming ? _self.naming : naming // ignore: cast_nullable_to_non_nullable
as List<String>,paths: null == paths ? _self.paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,examples: null == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchLayer].
extension ArchLayerPatterns on ArchLayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchLayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchLayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchLayer value)  $default,){
final _that = this;
switch (_that) {
case _ArchLayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchLayer value)?  $default,){
final _that = this;
switch (_that) {
case _ArchLayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String role,  List<String> naming,  List<String> paths,  List<String> examples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchLayer() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.naming,_that.paths,_that.examples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String role,  List<String> naming,  List<String> paths,  List<String> examples)  $default,) {final _that = this;
switch (_that) {
case _ArchLayer():
return $default(_that.id,_that.name,_that.role,_that.naming,_that.paths,_that.examples);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String role,  List<String> naming,  List<String> paths,  List<String> examples)?  $default,) {final _that = this;
switch (_that) {
case _ArchLayer() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.naming,_that.paths,_that.examples);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchLayer implements ArchLayer {
  const _ArchLayer({required this.id, required this.name, this.role = '',  List<String> naming = const [],  List<String> paths = const [],  List<String> examples = const []}): _naming = naming,_paths = paths,_examples = examples;
  factory _ArchLayer.fromJson(Map<String, dynamic> json) => _$ArchLayerFromJson(json);

/// A slug the rules and violations point at: view, view-model.
@override final  String id;
@override final  String name;
/// One sentence: what this layer does and what it must not do.
@override@JsonKey() final  String role;
/// Class name patterns of the layer: `*Screen`, `*ViewModel`, `*Manager`.
 final  List<String> _naming;
/// Class name patterns of the layer: `*Screen`, `*ViewModel`, `*Manager`.
@override@JsonKey() List<String> get naming {
  if (_naming is EqualUnmodifiableListView) return _naming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_naming);
}

/// Folders or files where the layer lives.
 final  List<String> _paths;
/// Folders or files where the layer lives.
@override@JsonKey() List<String> get paths {
  if (_paths is EqualUnmodifiableListView) return _paths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paths);
}

/// A few real classes, as the code names them.
 final  List<String> _examples;
/// A few real classes, as the code names them.
@override@JsonKey() List<String> get examples {
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examples);
}


/// Create a copy of ArchLayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchLayerCopyWith<_ArchLayer> get copyWith => __$ArchLayerCopyWithImpl<_ArchLayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchLayerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchLayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.naming, _naming)&&const DeepCollectionEquality().equals(other.paths, _paths)&&const DeepCollectionEquality().equals(other.examples, _examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role,const DeepCollectionEquality().hash(_naming),const DeepCollectionEquality().hash(_paths),const DeepCollectionEquality().hash(_examples));
}

@override
String toString() {
    return 'ArchLayer(id: $id, name: $name, role: $role, naming: $naming, paths: $paths, examples: $examples)';
}


}

/// @nodoc
abstract mixin class _$ArchLayerCopyWith<$Res> implements $ArchLayerCopyWith<$Res> {
  factory _$ArchLayerCopyWith(_ArchLayer value, $Res Function(_ArchLayer) _then) = __$ArchLayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String role, List<String> naming, List<String> paths, List<String> examples
});




}
/// @nodoc
class __$ArchLayerCopyWithImpl<$Res>
    implements _$ArchLayerCopyWith<$Res> {
  __$ArchLayerCopyWithImpl(this._self, this._then);

  final _ArchLayer _self;
  final $Res Function(_ArchLayer) _then;

/// Create a copy of ArchLayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? naming = null,Object? paths = null,Object? examples = null,}) {
  return _then(_ArchLayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,naming: null == naming ? _self._naming : naming // ignore: cast_nullable_to_non_nullable
as List<String>,paths: null == paths ? _self._paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,examples: null == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ArchFlow {

 String get from; String get to; String get label;
/// Create a copy of ArchFlow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchFlowCopyWith<ArchFlow> get copyWith => _$ArchFlowCopyWithImpl<ArchFlow>(this as ArchFlow, _$identity);

  /// Serializes this ArchFlow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchFlow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchFlow&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.label, _this.label) || other.label == _this.label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchFlow;
  return Object.hash(runtimeType,_this.from,_this.to,_this.label);
}

@override
String toString() {
  final _this = this as ArchFlow;
  return 'ArchFlow(from: ${_this.from}, to: ${_this.to}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $ArchFlowCopyWith<$Res>  {
  factory $ArchFlowCopyWith(ArchFlow value, $Res Function(ArchFlow) _then) = _$ArchFlowCopyWithImpl;
@useResult
$Res call({
 String from, String to, String label
});




}
/// @nodoc
class _$ArchFlowCopyWithImpl<$Res>
    implements $ArchFlowCopyWith<$Res> {
  _$ArchFlowCopyWithImpl(this._self, this._then);

  final ArchFlow _self;
  final $Res Function(ArchFlow) _then;

/// Create a copy of ArchFlow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? label = null,}) {
  return _then(ArchFlow(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchFlow].
extension ArchFlowPatterns on ArchFlow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchFlow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchFlow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchFlow value)  $default,){
final _that = this;
switch (_that) {
case _ArchFlow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchFlow value)?  $default,){
final _that = this;
switch (_that) {
case _ArchFlow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchFlow() when $default != null:
return $default(_that.from,_that.to,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to,  String label)  $default,) {final _that = this;
switch (_that) {
case _ArchFlow():
return $default(_that.from,_that.to,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to,  String label)?  $default,) {final _that = this;
switch (_that) {
case _ArchFlow() when $default != null:
return $default(_that.from,_that.to,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchFlow implements ArchFlow {
  const _ArchFlow({required this.from, required this.to, this.label = ''});
  factory _ArchFlow.fromJson(Map<String, dynamic> json) => _$ArchFlowFromJson(json);

@override final  String from;
@override final  String to;
@override@JsonKey() final  String label;

/// Create a copy of ArchFlow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchFlowCopyWith<_ArchFlow> get copyWith => __$ArchFlowCopyWithImpl<_ArchFlow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchFlowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchFlow&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,to,label);
}

@override
String toString() {
    return 'ArchFlow(from: $from, to: $to, label: $label)';
}


}

/// @nodoc
abstract mixin class _$ArchFlowCopyWith<$Res> implements $ArchFlowCopyWith<$Res> {
  factory _$ArchFlowCopyWith(_ArchFlow value, $Res Function(_ArchFlow) _then) = __$ArchFlowCopyWithImpl;
@override @useResult
$Res call({
 String from, String to, String label
});




}
/// @nodoc
class __$ArchFlowCopyWithImpl<$Res>
    implements _$ArchFlowCopyWith<$Res> {
  __$ArchFlowCopyWithImpl(this._self, this._then);

  final _ArchFlow _self;
  final $Res Function(_ArchFlow) _then;

/// Create a copy of ArchFlow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? label = null,}) {
  return _then(_ArchFlow(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ArchViolation {

/// The class that breaks the rule, and its layer.
 String get from; String get fromLayer;/// What it reaches: one or more classes, and their layer.
 List<String> get to; String get toLayer;/// high, medium, low, or accepted (a known, agreed exception).
 String get severity;/// One or two sentences: which rule, and what it costs.
 String get why;/// One line: what would fix it, when the docs or the code say.
 String get fix; String? get path; int? get line;
/// Create a copy of ArchViolation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchViolationCopyWith<ArchViolation> get copyWith => _$ArchViolationCopyWithImpl<ArchViolation>(this as ArchViolation, _$identity);

  /// Serializes this ArchViolation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchViolation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchViolation&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.fromLayer, _this.fromLayer) || other.fromLayer == _this.fromLayer)&&const DeepCollectionEquality().equals(other.to, _this.to)&&(identical(other.toLayer, _this.toLayer) || other.toLayer == _this.toLayer)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.why, _this.why) || other.why == _this.why)&&(identical(other.fix, _this.fix) || other.fix == _this.fix)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchViolation;
  return Object.hash(runtimeType,_this.from,_this.fromLayer,const DeepCollectionEquality().hash(_this.to),_this.toLayer,_this.severity,_this.why,_this.fix,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as ArchViolation;
  return 'ArchViolation(from: ${_this.from}, fromLayer: ${_this.fromLayer}, to: ${_this.to}, toLayer: ${_this.toLayer}, severity: ${_this.severity}, why: ${_this.why}, fix: ${_this.fix}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $ArchViolationCopyWith<$Res>  {
  factory $ArchViolationCopyWith(ArchViolation value, $Res Function(ArchViolation) _then) = _$ArchViolationCopyWithImpl;
@useResult
$Res call({
 String from, String fromLayer, List<String> to, String toLayer, String severity, String why, String fix, String? path, int? line
});




}
/// @nodoc
class _$ArchViolationCopyWithImpl<$Res>
    implements $ArchViolationCopyWith<$Res> {
  _$ArchViolationCopyWithImpl(this._self, this._then);

  final ArchViolation _self;
  final $Res Function(ArchViolation) _then;

/// Create a copy of ArchViolation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? fromLayer = null,Object? to = null,Object? toLayer = null,Object? severity = null,Object? why = null,Object? fix = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(ArchViolation(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,fromLayer: null == fromLayer ? _self.fromLayer : fromLayer // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as List<String>,toLayer: null == toLayer ? _self.toLayer : toLayer // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,fix: null == fix ? _self.fix : fix // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchViolation].
extension ArchViolationPatterns on ArchViolation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchViolation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchViolation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchViolation value)  $default,){
final _that = this;
switch (_that) {
case _ArchViolation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchViolation value)?  $default,){
final _that = this;
switch (_that) {
case _ArchViolation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String fromLayer,  List<String> to,  String toLayer,  String severity,  String why,  String fix,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchViolation() when $default != null:
return $default(_that.from,_that.fromLayer,_that.to,_that.toLayer,_that.severity,_that.why,_that.fix,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String fromLayer,  List<String> to,  String toLayer,  String severity,  String why,  String fix,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _ArchViolation():
return $default(_that.from,_that.fromLayer,_that.to,_that.toLayer,_that.severity,_that.why,_that.fix,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String fromLayer,  List<String> to,  String toLayer,  String severity,  String why,  String fix,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _ArchViolation() when $default != null:
return $default(_that.from,_that.fromLayer,_that.to,_that.toLayer,_that.severity,_that.why,_that.fix,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchViolation implements ArchViolation {
  const _ArchViolation({required this.from, required this.fromLayer,  List<String> to = const [], required this.toLayer, required this.severity, required this.why, this.fix = '', this.path, this.line}): _to = to;
  factory _ArchViolation.fromJson(Map<String, dynamic> json) => _$ArchViolationFromJson(json);

/// The class that breaks the rule, and its layer.
@override final  String from;
@override final  String fromLayer;
/// What it reaches: one or more classes, and their layer.
 final  List<String> _to;
/// What it reaches: one or more classes, and their layer.
@override@JsonKey() List<String> get to {
  if (_to is EqualUnmodifiableListView) return _to;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_to);
}

@override final  String toLayer;
/// high, medium, low, or accepted (a known, agreed exception).
@override final  String severity;
/// One or two sentences: which rule, and what it costs.
@override final  String why;
/// One line: what would fix it, when the docs or the code say.
@override@JsonKey() final  String fix;
@override final  String? path;
@override final  int? line;

/// Create a copy of ArchViolation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchViolationCopyWith<_ArchViolation> get copyWith => __$ArchViolationCopyWithImpl<_ArchViolation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchViolationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchViolation&&(identical(other.from, from) || other.from == from)&&(identical(other.fromLayer, fromLayer) || other.fromLayer == fromLayer)&&const DeepCollectionEquality().equals(other.to, _to)&&(identical(other.toLayer, toLayer) || other.toLayer == toLayer)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.why, why) || other.why == why)&&(identical(other.fix, fix) || other.fix == fix)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,fromLayer,const DeepCollectionEquality().hash(_to),toLayer,severity,why,fix,path,line);
}

@override
String toString() {
    return 'ArchViolation(from: $from, fromLayer: $fromLayer, to: $to, toLayer: $toLayer, severity: $severity, why: $why, fix: $fix, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$ArchViolationCopyWith<$Res> implements $ArchViolationCopyWith<$Res> {
  factory _$ArchViolationCopyWith(_ArchViolation value, $Res Function(_ArchViolation) _then) = __$ArchViolationCopyWithImpl;
@override @useResult
$Res call({
 String from, String fromLayer, List<String> to, String toLayer, String severity, String why, String fix, String? path, int? line
});




}
/// @nodoc
class __$ArchViolationCopyWithImpl<$Res>
    implements _$ArchViolationCopyWith<$Res> {
  __$ArchViolationCopyWithImpl(this._self, this._then);

  final _ArchViolation _self;
  final $Res Function(_ArchViolation) _then;

/// Create a copy of ArchViolation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? fromLayer = null,Object? to = null,Object? toLayer = null,Object? severity = null,Object? why = null,Object? fix = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_ArchViolation(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,fromLayer: null == fromLayer ? _self.fromLayer : fromLayer // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self._to : to // ignore: cast_nullable_to_non_nullable
as List<String>,toLayer: null == toLayer ? _self.toLayer : toLayer // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,fix: null == fix ? _self.fix : fix // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MapArchitecture {

/// Two or three sentences: the pattern (MVVM, clean, layered) and its main rule.
 String get summary; List<ArchLayer> get layers; List<ArchFlow> get flows;/// Rules in plain words that the layers and flows do not say.
 List<String> get rules; List<ArchViolation> get violations;/// The docs the rules come from, so the reader can check them.
 List<String> get sources; String get commit; String get updatedAt;
/// Create a copy of MapArchitecture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapArchitectureCopyWith<MapArchitecture> get copyWith => _$MapArchitectureCopyWithImpl<MapArchitecture>(this as MapArchitecture, _$identity);

  /// Serializes this MapArchitecture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapArchitecture;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapArchitecture&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.layers, _this.layers)&&const DeepCollectionEquality().equals(other.flows, _this.flows)&&const DeepCollectionEquality().equals(other.rules, _this.rules)&&const DeepCollectionEquality().equals(other.violations, _this.violations)&&const DeepCollectionEquality().equals(other.sources, _this.sources)&&(identical(other.commit, _this.commit) || other.commit == _this.commit)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapArchitecture;
  return Object.hash(runtimeType,_this.summary,const DeepCollectionEquality().hash(_this.layers),const DeepCollectionEquality().hash(_this.flows),const DeepCollectionEquality().hash(_this.rules),const DeepCollectionEquality().hash(_this.violations),const DeepCollectionEquality().hash(_this.sources),_this.commit,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MapArchitecture;
  return 'MapArchitecture(summary: ${_this.summary}, layers: ${_this.layers}, flows: ${_this.flows}, rules: ${_this.rules}, violations: ${_this.violations}, sources: ${_this.sources}, commit: ${_this.commit}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MapArchitectureCopyWith<$Res>  {
  factory $MapArchitectureCopyWith(MapArchitecture value, $Res Function(MapArchitecture) _then) = _$MapArchitectureCopyWithImpl;
@useResult
$Res call({
 String summary, List<ArchLayer> layers, List<ArchFlow> flows, List<String> rules, List<ArchViolation> violations, List<String> sources, String commit, String updatedAt
});




}
/// @nodoc
class _$MapArchitectureCopyWithImpl<$Res>
    implements $MapArchitectureCopyWith<$Res> {
  _$MapArchitectureCopyWithImpl(this._self, this._then);

  final MapArchitecture _self;
  final $Res Function(MapArchitecture) _then;

/// Create a copy of MapArchitecture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? layers = null,Object? flows = null,Object? rules = null,Object? violations = null,Object? sources = null,Object? commit = null,Object? updatedAt = null,}) {
  return _then(MapArchitecture(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as List<ArchLayer>,flows: null == flows ? _self.flows : flows // ignore: cast_nullable_to_non_nullable
as List<ArchFlow>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,violations: null == violations ? _self.violations : violations // ignore: cast_nullable_to_non_nullable
as List<ArchViolation>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MapArchitecture].
extension MapArchitecturePatterns on MapArchitecture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapArchitecture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapArchitecture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapArchitecture value)  $default,){
final _that = this;
switch (_that) {
case _MapArchitecture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapArchitecture value)?  $default,){
final _that = this;
switch (_that) {
case _MapArchitecture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<ArchLayer> layers,  List<ArchFlow> flows,  List<String> rules,  List<ArchViolation> violations,  List<String> sources,  String commit,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapArchitecture() when $default != null:
return $default(_that.summary,_that.layers,_that.flows,_that.rules,_that.violations,_that.sources,_that.commit,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<ArchLayer> layers,  List<ArchFlow> flows,  List<String> rules,  List<ArchViolation> violations,  List<String> sources,  String commit,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MapArchitecture():
return $default(_that.summary,_that.layers,_that.flows,_that.rules,_that.violations,_that.sources,_that.commit,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<ArchLayer> layers,  List<ArchFlow> flows,  List<String> rules,  List<ArchViolation> violations,  List<String> sources,  String commit,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MapArchitecture() when $default != null:
return $default(_that.summary,_that.layers,_that.flows,_that.rules,_that.violations,_that.sources,_that.commit,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapArchitecture implements MapArchitecture {
  const _MapArchitecture({this.summary = '',  List<ArchLayer> layers = const [],  List<ArchFlow> flows = const [],  List<String> rules = const [],  List<ArchViolation> violations = const [],  List<String> sources = const [], this.commit = '', this.updatedAt = ''}): _layers = layers,_flows = flows,_rules = rules,_violations = violations,_sources = sources;
  factory _MapArchitecture.fromJson(Map<String, dynamic> json) => _$MapArchitectureFromJson(json);

/// Two or three sentences: the pattern (MVVM, clean, layered) and its main rule.
@override@JsonKey() final  String summary;
 final  List<ArchLayer> _layers;
@override@JsonKey() List<ArchLayer> get layers {
  if (_layers is EqualUnmodifiableListView) return _layers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_layers);
}

 final  List<ArchFlow> _flows;
@override@JsonKey() List<ArchFlow> get flows {
  if (_flows is EqualUnmodifiableListView) return _flows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flows);
}

/// Rules in plain words that the layers and flows do not say.
 final  List<String> _rules;
/// Rules in plain words that the layers and flows do not say.
@override@JsonKey() List<String> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}

 final  List<ArchViolation> _violations;
@override@JsonKey() List<ArchViolation> get violations {
  if (_violations is EqualUnmodifiableListView) return _violations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_violations);
}

/// The docs the rules come from, so the reader can check them.
 final  List<String> _sources;
/// The docs the rules come from, so the reader can check them.
@override@JsonKey() List<String> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override@JsonKey() final  String commit;
@override@JsonKey() final  String updatedAt;

/// Create a copy of MapArchitecture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapArchitectureCopyWith<_MapArchitecture> get copyWith => __$MapArchitectureCopyWithImpl<_MapArchitecture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapArchitectureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapArchitecture&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.layers, _layers)&&const DeepCollectionEquality().equals(other.flows, _flows)&&const DeepCollectionEquality().equals(other.rules, _rules)&&const DeepCollectionEquality().equals(other.violations, _violations)&&const DeepCollectionEquality().equals(other.sources, _sources)&&(identical(other.commit, commit) || other.commit == commit)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_layers),const DeepCollectionEquality().hash(_flows),const DeepCollectionEquality().hash(_rules),const DeepCollectionEquality().hash(_violations),const DeepCollectionEquality().hash(_sources),commit,updatedAt);
}

@override
String toString() {
    return 'MapArchitecture(summary: $summary, layers: $layers, flows: $flows, rules: $rules, violations: $violations, sources: $sources, commit: $commit, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MapArchitectureCopyWith<$Res> implements $MapArchitectureCopyWith<$Res> {
  factory _$MapArchitectureCopyWith(_MapArchitecture value, $Res Function(_MapArchitecture) _then) = __$MapArchitectureCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<ArchLayer> layers, List<ArchFlow> flows, List<String> rules, List<ArchViolation> violations, List<String> sources, String commit, String updatedAt
});




}
/// @nodoc
class __$MapArchitectureCopyWithImpl<$Res>
    implements _$MapArchitectureCopyWith<$Res> {
  __$MapArchitectureCopyWithImpl(this._self, this._then);

  final _MapArchitecture _self;
  final $Res Function(_MapArchitecture) _then;

/// Create a copy of MapArchitecture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? layers = null,Object? flows = null,Object? rules = null,Object? violations = null,Object? sources = null,Object? commit = null,Object? updatedAt = null,}) {
  return _then(_MapArchitecture(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,layers: null == layers ? _self._layers : layers // ignore: cast_nullable_to_non_nullable
as List<ArchLayer>,flows: null == flows ? _self._flows : flows // ignore: cast_nullable_to_non_nullable
as List<ArchFlow>,rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,violations: null == violations ? _self._violations : violations // ignore: cast_nullable_to_non_nullable
as List<ArchViolation>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UiToken {

/// color, type, spacing, radius, icon or other.
 String get kind;/// As the code names it: `c.label2`, `t.bodySmall`.
 String get name; String get note; String? get path; int? get line;
/// Create a copy of UiToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiTokenCopyWith<UiToken> get copyWith => _$UiTokenCopyWithImpl<UiToken>(this as UiToken, _$identity);

  /// Serializes this UiToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UiToken;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiToken&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UiToken;
  return Object.hash(runtimeType,_this.kind,_this.name,_this.note,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as UiToken;
  return 'UiToken(kind: ${_this.kind}, name: ${_this.name}, note: ${_this.note}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $UiTokenCopyWith<$Res>  {
  factory $UiTokenCopyWith(UiToken value, $Res Function(UiToken) _then) = _$UiTokenCopyWithImpl;
@useResult
$Res call({
 String kind, String name, String note, String? path, int? line
});




}
/// @nodoc
class _$UiTokenCopyWithImpl<$Res>
    implements $UiTokenCopyWith<$Res> {
  _$UiTokenCopyWithImpl(this._self, this._then);

  final UiToken _self;
  final $Res Function(UiToken) _then;

/// Create a copy of UiToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? name = null,Object? note = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(UiToken(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UiToken].
extension UiTokenPatterns on UiToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiToken value)  $default,){
final _that = this;
switch (_that) {
case _UiToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiToken value)?  $default,){
final _that = this;
switch (_that) {
case _UiToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String name,  String note,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiToken() when $default != null:
return $default(_that.kind,_that.name,_that.note,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String name,  String note,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _UiToken():
return $default(_that.kind,_that.name,_that.note,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String name,  String note,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _UiToken() when $default != null:
return $default(_that.kind,_that.name,_that.note,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UiToken implements UiToken {
  const _UiToken({required this.kind, required this.name, this.note = '', this.path, this.line});
  factory _UiToken.fromJson(Map<String, dynamic> json) => _$UiTokenFromJson(json);

/// color, type, spacing, radius, icon or other.
@override final  String kind;
/// As the code names it: `c.label2`, `t.bodySmall`.
@override final  String name;
@override@JsonKey() final  String note;
@override final  String? path;
@override final  int? line;

/// Create a copy of UiToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiTokenCopyWith<_UiToken> get copyWith => __$UiTokenCopyWithImpl<_UiToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UiTokenToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiToken&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.note, note) || other.note == note)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name,note,path,line);
}

@override
String toString() {
    return 'UiToken(kind: $kind, name: $name, note: $note, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$UiTokenCopyWith<$Res> implements $UiTokenCopyWith<$Res> {
  factory _$UiTokenCopyWith(_UiToken value, $Res Function(_UiToken) _then) = __$UiTokenCopyWithImpl;
@override @useResult
$Res call({
 String kind, String name, String note, String? path, int? line
});




}
/// @nodoc
class __$UiTokenCopyWithImpl<$Res>
    implements _$UiTokenCopyWith<$Res> {
  __$UiTokenCopyWithImpl(this._self, this._then);

  final _UiToken _self;
  final $Res Function(_UiToken) _then;

/// Create a copy of UiToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,Object? note = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_UiToken(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UiComponent {

 String get name; String get role; String? get path; int? get line;
/// Create a copy of UiComponent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiComponentCopyWith<UiComponent> get copyWith => _$UiComponentCopyWithImpl<UiComponent>(this as UiComponent, _$identity);

  /// Serializes this UiComponent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UiComponent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiComponent&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UiComponent;
  return Object.hash(runtimeType,_this.name,_this.role,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as UiComponent;
  return 'UiComponent(name: ${_this.name}, role: ${_this.role}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $UiComponentCopyWith<$Res>  {
  factory $UiComponentCopyWith(UiComponent value, $Res Function(UiComponent) _then) = _$UiComponentCopyWithImpl;
@useResult
$Res call({
 String name, String role, String? path, int? line
});




}
/// @nodoc
class _$UiComponentCopyWithImpl<$Res>
    implements $UiComponentCopyWith<$Res> {
  _$UiComponentCopyWithImpl(this._self, this._then);

  final UiComponent _self;
  final $Res Function(UiComponent) _then;

/// Create a copy of UiComponent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? role = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(UiComponent(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UiComponent].
extension UiComponentPatterns on UiComponent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiComponent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiComponent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiComponent value)  $default,){
final _that = this;
switch (_that) {
case _UiComponent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiComponent value)?  $default,){
final _that = this;
switch (_that) {
case _UiComponent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String role,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiComponent() when $default != null:
return $default(_that.name,_that.role,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String role,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _UiComponent():
return $default(_that.name,_that.role,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String role,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _UiComponent() when $default != null:
return $default(_that.name,_that.role,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UiComponent implements UiComponent {
  const _UiComponent({required this.name, this.role = '', this.path, this.line});
  factory _UiComponent.fromJson(Map<String, dynamic> json) => _$UiComponentFromJson(json);

@override final  String name;
@override@JsonKey() final  String role;
@override final  String? path;
@override final  int? line;

/// Create a copy of UiComponent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiComponentCopyWith<_UiComponent> get copyWith => __$UiComponentCopyWithImpl<_UiComponent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UiComponentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiComponent&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,role,path,line);
}

@override
String toString() {
    return 'UiComponent(name: $name, role: $role, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$UiComponentCopyWith<$Res> implements $UiComponentCopyWith<$Res> {
  factory _$UiComponentCopyWith(_UiComponent value, $Res Function(_UiComponent) _then) = __$UiComponentCopyWithImpl;
@override @useResult
$Res call({
 String name, String role, String? path, int? line
});




}
/// @nodoc
class __$UiComponentCopyWithImpl<$Res>
    implements _$UiComponentCopyWith<$Res> {
  __$UiComponentCopyWithImpl(this._self, this._then);

  final _UiComponent _self;
  final $Res Function(_UiComponent) _then;

/// Create a copy of UiComponent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? role = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_UiComponent(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UiScreen {

 String get name; String get role; String? get path; int? get line; List<String> get uses;
/// Create a copy of UiScreen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiScreenCopyWith<UiScreen> get copyWith => _$UiScreenCopyWithImpl<UiScreen>(this as UiScreen, _$identity);

  /// Serializes this UiScreen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UiScreen;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiScreen&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line)&&const DeepCollectionEquality().equals(other.uses, _this.uses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UiScreen;
  return Object.hash(runtimeType,_this.name,_this.role,_this.path,_this.line,const DeepCollectionEquality().hash(_this.uses));
}

@override
String toString() {
  final _this = this as UiScreen;
  return 'UiScreen(name: ${_this.name}, role: ${_this.role}, path: ${_this.path}, line: ${_this.line}, uses: ${_this.uses})';
}


}

/// @nodoc
abstract mixin class $UiScreenCopyWith<$Res>  {
  factory $UiScreenCopyWith(UiScreen value, $Res Function(UiScreen) _then) = _$UiScreenCopyWithImpl;
@useResult
$Res call({
 String name, String role, String? path, int? line, List<String> uses
});




}
/// @nodoc
class _$UiScreenCopyWithImpl<$Res>
    implements $UiScreenCopyWith<$Res> {
  _$UiScreenCopyWithImpl(this._self, this._then);

  final UiScreen _self;
  final $Res Function(UiScreen) _then;

/// Create a copy of UiScreen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? role = null,Object? path = freezed,Object? line = freezed,Object? uses = null,}) {
  return _then(UiScreen(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,uses: null == uses ? _self.uses : uses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UiScreen].
extension UiScreenPatterns on UiScreen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiScreen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiScreen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiScreen value)  $default,){
final _that = this;
switch (_that) {
case _UiScreen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiScreen value)?  $default,){
final _that = this;
switch (_that) {
case _UiScreen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String role,  String? path,  int? line,  List<String> uses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiScreen() when $default != null:
return $default(_that.name,_that.role,_that.path,_that.line,_that.uses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String role,  String? path,  int? line,  List<String> uses)  $default,) {final _that = this;
switch (_that) {
case _UiScreen():
return $default(_that.name,_that.role,_that.path,_that.line,_that.uses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String role,  String? path,  int? line,  List<String> uses)?  $default,) {final _that = this;
switch (_that) {
case _UiScreen() when $default != null:
return $default(_that.name,_that.role,_that.path,_that.line,_that.uses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UiScreen implements UiScreen {
  const _UiScreen({required this.name, this.role = '', this.path, this.line,  List<String> uses = const []}): _uses = uses;
  factory _UiScreen.fromJson(Map<String, dynamic> json) => _$UiScreenFromJson(json);

@override final  String name;
@override@JsonKey() final  String role;
@override final  String? path;
@override final  int? line;
 final  List<String> _uses;
@override@JsonKey() List<String> get uses {
  if (_uses is EqualUnmodifiableListView) return _uses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uses);
}


/// Create a copy of UiScreen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiScreenCopyWith<_UiScreen> get copyWith => __$UiScreenCopyWithImpl<_UiScreen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UiScreenToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiScreen&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line)&&const DeepCollectionEquality().equals(other.uses, _uses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,role,path,line,const DeepCollectionEquality().hash(_uses));
}

@override
String toString() {
    return 'UiScreen(name: $name, role: $role, path: $path, line: $line, uses: $uses)';
}


}

/// @nodoc
abstract mixin class _$UiScreenCopyWith<$Res> implements $UiScreenCopyWith<$Res> {
  factory _$UiScreenCopyWith(_UiScreen value, $Res Function(_UiScreen) _then) = __$UiScreenCopyWithImpl;
@override @useResult
$Res call({
 String name, String role, String? path, int? line, List<String> uses
});




}
/// @nodoc
class __$UiScreenCopyWithImpl<$Res>
    implements _$UiScreenCopyWith<$Res> {
  __$UiScreenCopyWithImpl(this._self, this._then);

  final _UiScreen _self;
  final $Res Function(_UiScreen) _then;

/// Create a copy of UiScreen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? role = null,Object? path = freezed,Object? line = freezed,Object? uses = null,}) {
  return _then(_UiScreen(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,uses: null == uses ? _self._uses : uses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$UiCopy {

 String get name; String? get path; int? get line;
/// Create a copy of UiCopy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiCopyCopyWith<UiCopy> get copyWith => _$UiCopyCopyWithImpl<UiCopy>(this as UiCopy, _$identity);

  /// Serializes this UiCopy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UiCopy;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiCopy&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UiCopy;
  return Object.hash(runtimeType,_this.name,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as UiCopy;
  return 'UiCopy(name: ${_this.name}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $UiCopyCopyWith<$Res>  {
  factory $UiCopyCopyWith(UiCopy value, $Res Function(UiCopy) _then) = _$UiCopyCopyWithImpl;
@useResult
$Res call({
 String name, String? path, int? line
});




}
/// @nodoc
class _$UiCopyCopyWithImpl<$Res>
    implements $UiCopyCopyWith<$Res> {
  _$UiCopyCopyWithImpl(this._self, this._then);

  final UiCopy _self;
  final $Res Function(UiCopy) _then;

/// Create a copy of UiCopy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(UiCopy(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UiCopy].
extension UiCopyPatterns on UiCopy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiCopy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiCopy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiCopy value)  $default,){
final _that = this;
switch (_that) {
case _UiCopy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiCopy value)?  $default,){
final _that = this;
switch (_that) {
case _UiCopy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiCopy() when $default != null:
return $default(_that.name,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _UiCopy():
return $default(_that.name,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _UiCopy() when $default != null:
return $default(_that.name,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UiCopy implements UiCopy {
  const _UiCopy({required this.name, this.path, this.line});
  factory _UiCopy.fromJson(Map<String, dynamic> json) => _$UiCopyFromJson(json);

@override final  String name;
@override final  String? path;
@override final  int? line;

/// Create a copy of UiCopy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiCopyCopyWith<_UiCopy> get copyWith => __$UiCopyCopyWithImpl<_UiCopy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UiCopyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiCopy&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,path,line);
}

@override
String toString() {
    return 'UiCopy(name: $name, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$UiCopyCopyWith<$Res> implements $UiCopyCopyWith<$Res> {
  factory _$UiCopyCopyWith(_UiCopy value, $Res Function(_UiCopy) _then) = __$UiCopyCopyWithImpl;
@override @useResult
$Res call({
 String name, String? path, int? line
});




}
/// @nodoc
class __$UiCopyCopyWithImpl<$Res>
    implements _$UiCopyCopyWith<$Res> {
  __$UiCopyCopyWithImpl(this._self, this._then);

  final _UiCopy _self;
  final $Res Function(_UiCopy) _then;

/// Create a copy of UiCopy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_UiCopy(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UiDuplicate {

/// A few words: what is built twice.
 String get title;/// high, medium, low, or accepted (an agreed copy).
 String get severity;/// One or two sentences: how the copies differ, and what that costs.
 String get why;/// The shared component the copies should use, existing or to create.
 String get use; List<UiCopy> get copies;
/// Create a copy of UiDuplicate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiDuplicateCopyWith<UiDuplicate> get copyWith => _$UiDuplicateCopyWithImpl<UiDuplicate>(this as UiDuplicate, _$identity);

  /// Serializes this UiDuplicate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UiDuplicate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiDuplicate&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.why, _this.why) || other.why == _this.why)&&(identical(other.use, _this.use) || other.use == _this.use)&&const DeepCollectionEquality().equals(other.copies, _this.copies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UiDuplicate;
  return Object.hash(runtimeType,_this.title,_this.severity,_this.why,_this.use,const DeepCollectionEquality().hash(_this.copies));
}

@override
String toString() {
  final _this = this as UiDuplicate;
  return 'UiDuplicate(title: ${_this.title}, severity: ${_this.severity}, why: ${_this.why}, use: ${_this.use}, copies: ${_this.copies})';
}


}

/// @nodoc
abstract mixin class $UiDuplicateCopyWith<$Res>  {
  factory $UiDuplicateCopyWith(UiDuplicate value, $Res Function(UiDuplicate) _then) = _$UiDuplicateCopyWithImpl;
@useResult
$Res call({
 String title, String severity, String why, String use, List<UiCopy> copies
});




}
/// @nodoc
class _$UiDuplicateCopyWithImpl<$Res>
    implements $UiDuplicateCopyWith<$Res> {
  _$UiDuplicateCopyWithImpl(this._self, this._then);

  final UiDuplicate _self;
  final $Res Function(UiDuplicate) _then;

/// Create a copy of UiDuplicate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? severity = null,Object? why = null,Object? use = null,Object? copies = null,}) {
  return _then(UiDuplicate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,use: null == use ? _self.use : use // ignore: cast_nullable_to_non_nullable
as String,copies: null == copies ? _self.copies : copies // ignore: cast_nullable_to_non_nullable
as List<UiCopy>,
  ));
}

}


/// Adds pattern-matching-related methods to [UiDuplicate].
extension UiDuplicatePatterns on UiDuplicate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiDuplicate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiDuplicate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiDuplicate value)  $default,){
final _that = this;
switch (_that) {
case _UiDuplicate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiDuplicate value)?  $default,){
final _that = this;
switch (_that) {
case _UiDuplicate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String severity,  String why,  String use,  List<UiCopy> copies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiDuplicate() when $default != null:
return $default(_that.title,_that.severity,_that.why,_that.use,_that.copies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String severity,  String why,  String use,  List<UiCopy> copies)  $default,) {final _that = this;
switch (_that) {
case _UiDuplicate():
return $default(_that.title,_that.severity,_that.why,_that.use,_that.copies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String severity,  String why,  String use,  List<UiCopy> copies)?  $default,) {final _that = this;
switch (_that) {
case _UiDuplicate() when $default != null:
return $default(_that.title,_that.severity,_that.why,_that.use,_that.copies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UiDuplicate implements UiDuplicate {
  const _UiDuplicate({required this.title, required this.severity, required this.why, this.use = '',  List<UiCopy> copies = const []}): _copies = copies;
  factory _UiDuplicate.fromJson(Map<String, dynamic> json) => _$UiDuplicateFromJson(json);

/// A few words: what is built twice.
@override final  String title;
/// high, medium, low, or accepted (an agreed copy).
@override final  String severity;
/// One or two sentences: how the copies differ, and what that costs.
@override final  String why;
/// The shared component the copies should use, existing or to create.
@override@JsonKey() final  String use;
 final  List<UiCopy> _copies;
@override@JsonKey() List<UiCopy> get copies {
  if (_copies is EqualUnmodifiableListView) return _copies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_copies);
}


/// Create a copy of UiDuplicate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiDuplicateCopyWith<_UiDuplicate> get copyWith => __$UiDuplicateCopyWithImpl<_UiDuplicate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UiDuplicateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiDuplicate&&(identical(other.title, title) || other.title == title)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.why, why) || other.why == why)&&(identical(other.use, use) || other.use == use)&&const DeepCollectionEquality().equals(other.copies, _copies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,severity,why,use,const DeepCollectionEquality().hash(_copies));
}

@override
String toString() {
    return 'UiDuplicate(title: $title, severity: $severity, why: $why, use: $use, copies: $copies)';
}


}

/// @nodoc
abstract mixin class _$UiDuplicateCopyWith<$Res> implements $UiDuplicateCopyWith<$Res> {
  factory _$UiDuplicateCopyWith(_UiDuplicate value, $Res Function(_UiDuplicate) _then) = __$UiDuplicateCopyWithImpl;
@override @useResult
$Res call({
 String title, String severity, String why, String use, List<UiCopy> copies
});




}
/// @nodoc
class __$UiDuplicateCopyWithImpl<$Res>
    implements _$UiDuplicateCopyWith<$Res> {
  __$UiDuplicateCopyWithImpl(this._self, this._then);

  final _UiDuplicate _self;
  final $Res Function(_UiDuplicate) _then;

/// Create a copy of UiDuplicate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? severity = null,Object? why = null,Object? use = null,Object? copies = null,}) {
  return _then(_UiDuplicate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,use: null == use ? _self.use : use // ignore: cast_nullable_to_non_nullable
as String,copies: null == copies ? _self._copies : copies // ignore: cast_nullable_to_non_nullable
as List<UiCopy>,
  ));
}


}


/// @nodoc
mixin _$UiBreak {

/// The rule, in a few words.
 String get rule; String get severity; String get why; String get fix;/// The class it happens in.
 String get where;/// How many places break it the same way; [path] is one of them.
 int get count; String? get path; int? get line;
/// Create a copy of UiBreak
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiBreakCopyWith<UiBreak> get copyWith => _$UiBreakCopyWithImpl<UiBreak>(this as UiBreak, _$identity);

  /// Serializes this UiBreak to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UiBreak;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiBreak&&(identical(other.rule, _this.rule) || other.rule == _this.rule)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.why, _this.why) || other.why == _this.why)&&(identical(other.fix, _this.fix) || other.fix == _this.fix)&&(identical(other.where, _this.where) || other.where == _this.where)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.line, _this.line) || other.line == _this.line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UiBreak;
  return Object.hash(runtimeType,_this.rule,_this.severity,_this.why,_this.fix,_this.where,_this.count,_this.path,_this.line);
}

@override
String toString() {
  final _this = this as UiBreak;
  return 'UiBreak(rule: ${_this.rule}, severity: ${_this.severity}, why: ${_this.why}, fix: ${_this.fix}, where: ${_this.where}, count: ${_this.count}, path: ${_this.path}, line: ${_this.line})';
}


}

/// @nodoc
abstract mixin class $UiBreakCopyWith<$Res>  {
  factory $UiBreakCopyWith(UiBreak value, $Res Function(UiBreak) _then) = _$UiBreakCopyWithImpl;
@useResult
$Res call({
 String rule, String severity, String why, String fix, String where, int count, String? path, int? line
});




}
/// @nodoc
class _$UiBreakCopyWithImpl<$Res>
    implements $UiBreakCopyWith<$Res> {
  _$UiBreakCopyWithImpl(this._self, this._then);

  final UiBreak _self;
  final $Res Function(UiBreak) _then;

/// Create a copy of UiBreak
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rule = null,Object? severity = null,Object? why = null,Object? fix = null,Object? where = null,Object? count = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(UiBreak(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,fix: null == fix ? _self.fix : fix // ignore: cast_nullable_to_non_nullable
as String,where: null == where ? _self.where : where // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UiBreak].
extension UiBreakPatterns on UiBreak {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiBreak value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiBreak() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiBreak value)  $default,){
final _that = this;
switch (_that) {
case _UiBreak():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiBreak value)?  $default,){
final _that = this;
switch (_that) {
case _UiBreak() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rule,  String severity,  String why,  String fix,  String where,  int count,  String? path,  int? line)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiBreak() when $default != null:
return $default(_that.rule,_that.severity,_that.why,_that.fix,_that.where,_that.count,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rule,  String severity,  String why,  String fix,  String where,  int count,  String? path,  int? line)  $default,) {final _that = this;
switch (_that) {
case _UiBreak():
return $default(_that.rule,_that.severity,_that.why,_that.fix,_that.where,_that.count,_that.path,_that.line);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rule,  String severity,  String why,  String fix,  String where,  int count,  String? path,  int? line)?  $default,) {final _that = this;
switch (_that) {
case _UiBreak() when $default != null:
return $default(_that.rule,_that.severity,_that.why,_that.fix,_that.where,_that.count,_that.path,_that.line);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UiBreak implements UiBreak {
  const _UiBreak({required this.rule, required this.severity, required this.why, this.fix = '', this.where = '', this.count = 1, this.path, this.line});
  factory _UiBreak.fromJson(Map<String, dynamic> json) => _$UiBreakFromJson(json);

/// The rule, in a few words.
@override final  String rule;
@override final  String severity;
@override final  String why;
@override@JsonKey() final  String fix;
/// The class it happens in.
@override@JsonKey() final  String where;
/// How many places break it the same way; [path] is one of them.
@override@JsonKey() final  int count;
@override final  String? path;
@override final  int? line;

/// Create a copy of UiBreak
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiBreakCopyWith<_UiBreak> get copyWith => __$UiBreakCopyWithImpl<_UiBreak>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UiBreakToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiBreak&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.why, why) || other.why == why)&&(identical(other.fix, fix) || other.fix == fix)&&(identical(other.where, where) || other.where == where)&&(identical(other.count, count) || other.count == count)&&(identical(other.path, path) || other.path == path)&&(identical(other.line, line) || other.line == line));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rule,severity,why,fix,where,count,path,line);
}

@override
String toString() {
    return 'UiBreak(rule: $rule, severity: $severity, why: $why, fix: $fix, where: $where, count: $count, path: $path, line: $line)';
}


}

/// @nodoc
abstract mixin class _$UiBreakCopyWith<$Res> implements $UiBreakCopyWith<$Res> {
  factory _$UiBreakCopyWith(_UiBreak value, $Res Function(_UiBreak) _then) = __$UiBreakCopyWithImpl;
@override @useResult
$Res call({
 String rule, String severity, String why, String fix, String where, int count, String? path, int? line
});




}
/// @nodoc
class __$UiBreakCopyWithImpl<$Res>
    implements _$UiBreakCopyWith<$Res> {
  __$UiBreakCopyWithImpl(this._self, this._then);

  final _UiBreak _self;
  final $Res Function(_UiBreak) _then;

/// Create a copy of UiBreak
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rule = null,Object? severity = null,Object? why = null,Object? fix = null,Object? where = null,Object? count = null,Object? path = freezed,Object? line = freezed,}) {
  return _then(_UiBreak(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,why: null == why ? _self.why : why // ignore: cast_nullable_to_non_nullable
as String,fix: null == fix ? _self.fix : fix // ignore: cast_nullable_to_non_nullable
as String,where: null == where ? _self.where : where // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MapUi {

/// Two or three sentences: how the UI is built and its main rule.
 String get summary; List<String> get rules;/// The docs and skills the rules come from.
 List<String> get sources;/// The folders the UI lives in. A change under one makes it stale.
 List<String> get paths; List<UiToken> get tokens; List<UiComponent> get components; List<UiScreen> get screens; List<UiDuplicate> get duplicates; List<UiBreak> get breaks; String get commit; String get updatedAt;
/// Create a copy of MapUi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapUiCopyWith<MapUi> get copyWith => _$MapUiCopyWithImpl<MapUi>(this as MapUi, _$identity);

  /// Serializes this MapUi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapUi;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapUi&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.rules, _this.rules)&&const DeepCollectionEquality().equals(other.sources, _this.sources)&&const DeepCollectionEquality().equals(other.paths, _this.paths)&&const DeepCollectionEquality().equals(other.tokens, _this.tokens)&&const DeepCollectionEquality().equals(other.components, _this.components)&&const DeepCollectionEquality().equals(other.screens, _this.screens)&&const DeepCollectionEquality().equals(other.duplicates, _this.duplicates)&&const DeepCollectionEquality().equals(other.breaks, _this.breaks)&&(identical(other.commit, _this.commit) || other.commit == _this.commit)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapUi;
  return Object.hash(runtimeType,_this.summary,const DeepCollectionEquality().hash(_this.rules),const DeepCollectionEquality().hash(_this.sources),const DeepCollectionEquality().hash(_this.paths),const DeepCollectionEquality().hash(_this.tokens),const DeepCollectionEquality().hash(_this.components),const DeepCollectionEquality().hash(_this.screens),const DeepCollectionEquality().hash(_this.duplicates),const DeepCollectionEquality().hash(_this.breaks),_this.commit,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MapUi;
  return 'MapUi(summary: ${_this.summary}, rules: ${_this.rules}, sources: ${_this.sources}, paths: ${_this.paths}, tokens: ${_this.tokens}, components: ${_this.components}, screens: ${_this.screens}, duplicates: ${_this.duplicates}, breaks: ${_this.breaks}, commit: ${_this.commit}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MapUiCopyWith<$Res>  {
  factory $MapUiCopyWith(MapUi value, $Res Function(MapUi) _then) = _$MapUiCopyWithImpl;
@useResult
$Res call({
 String summary, List<String> rules, List<String> sources, List<String> paths, List<UiToken> tokens, List<UiComponent> components, List<UiScreen> screens, List<UiDuplicate> duplicates, List<UiBreak> breaks, String commit, String updatedAt
});




}
/// @nodoc
class _$MapUiCopyWithImpl<$Res>
    implements $MapUiCopyWith<$Res> {
  _$MapUiCopyWithImpl(this._self, this._then);

  final MapUi _self;
  final $Res Function(MapUi) _then;

/// Create a copy of MapUi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? rules = null,Object? sources = null,Object? paths = null,Object? tokens = null,Object? components = null,Object? screens = null,Object? duplicates = null,Object? breaks = null,Object? commit = null,Object? updatedAt = null,}) {
  return _then(MapUi(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,paths: null == paths ? _self.paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as List<UiToken>,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as List<UiComponent>,screens: null == screens ? _self.screens : screens // ignore: cast_nullable_to_non_nullable
as List<UiScreen>,duplicates: null == duplicates ? _self.duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as List<UiDuplicate>,breaks: null == breaks ? _self.breaks : breaks // ignore: cast_nullable_to_non_nullable
as List<UiBreak>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MapUi].
extension MapUiPatterns on MapUi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapUi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapUi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapUi value)  $default,){
final _that = this;
switch (_that) {
case _MapUi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapUi value)?  $default,){
final _that = this;
switch (_that) {
case _MapUi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<String> rules,  List<String> sources,  List<String> paths,  List<UiToken> tokens,  List<UiComponent> components,  List<UiScreen> screens,  List<UiDuplicate> duplicates,  List<UiBreak> breaks,  String commit,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapUi() when $default != null:
return $default(_that.summary,_that.rules,_that.sources,_that.paths,_that.tokens,_that.components,_that.screens,_that.duplicates,_that.breaks,_that.commit,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<String> rules,  List<String> sources,  List<String> paths,  List<UiToken> tokens,  List<UiComponent> components,  List<UiScreen> screens,  List<UiDuplicate> duplicates,  List<UiBreak> breaks,  String commit,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MapUi():
return $default(_that.summary,_that.rules,_that.sources,_that.paths,_that.tokens,_that.components,_that.screens,_that.duplicates,_that.breaks,_that.commit,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<String> rules,  List<String> sources,  List<String> paths,  List<UiToken> tokens,  List<UiComponent> components,  List<UiScreen> screens,  List<UiDuplicate> duplicates,  List<UiBreak> breaks,  String commit,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MapUi() when $default != null:
return $default(_that.summary,_that.rules,_that.sources,_that.paths,_that.tokens,_that.components,_that.screens,_that.duplicates,_that.breaks,_that.commit,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapUi implements MapUi {
  const _MapUi({this.summary = '',  List<String> rules = const [],  List<String> sources = const [],  List<String> paths = const [],  List<UiToken> tokens = const [],  List<UiComponent> components = const [],  List<UiScreen> screens = const [],  List<UiDuplicate> duplicates = const [],  List<UiBreak> breaks = const [], this.commit = '', this.updatedAt = ''}): _rules = rules,_sources = sources,_paths = paths,_tokens = tokens,_components = components,_screens = screens,_duplicates = duplicates,_breaks = breaks;
  factory _MapUi.fromJson(Map<String, dynamic> json) => _$MapUiFromJson(json);

/// Two or three sentences: how the UI is built and its main rule.
@override@JsonKey() final  String summary;
 final  List<String> _rules;
@override@JsonKey() List<String> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}

/// The docs and skills the rules come from.
 final  List<String> _sources;
/// The docs and skills the rules come from.
@override@JsonKey() List<String> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

/// The folders the UI lives in. A change under one makes it stale.
 final  List<String> _paths;
/// The folders the UI lives in. A change under one makes it stale.
@override@JsonKey() List<String> get paths {
  if (_paths is EqualUnmodifiableListView) return _paths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paths);
}

 final  List<UiToken> _tokens;
@override@JsonKey() List<UiToken> get tokens {
  if (_tokens is EqualUnmodifiableListView) return _tokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tokens);
}

 final  List<UiComponent> _components;
@override@JsonKey() List<UiComponent> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}

 final  List<UiScreen> _screens;
@override@JsonKey() List<UiScreen> get screens {
  if (_screens is EqualUnmodifiableListView) return _screens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screens);
}

 final  List<UiDuplicate> _duplicates;
@override@JsonKey() List<UiDuplicate> get duplicates {
  if (_duplicates is EqualUnmodifiableListView) return _duplicates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_duplicates);
}

 final  List<UiBreak> _breaks;
@override@JsonKey() List<UiBreak> get breaks {
  if (_breaks is EqualUnmodifiableListView) return _breaks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breaks);
}

@override@JsonKey() final  String commit;
@override@JsonKey() final  String updatedAt;

/// Create a copy of MapUi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapUiCopyWith<_MapUi> get copyWith => __$MapUiCopyWithImpl<_MapUi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapUiToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapUi&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.rules, _rules)&&const DeepCollectionEquality().equals(other.sources, _sources)&&const DeepCollectionEquality().equals(other.paths, _paths)&&const DeepCollectionEquality().equals(other.tokens, _tokens)&&const DeepCollectionEquality().equals(other.components, _components)&&const DeepCollectionEquality().equals(other.screens, _screens)&&const DeepCollectionEquality().equals(other.duplicates, _duplicates)&&const DeepCollectionEquality().equals(other.breaks, _breaks)&&(identical(other.commit, commit) || other.commit == commit)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_rules),const DeepCollectionEquality().hash(_sources),const DeepCollectionEquality().hash(_paths),const DeepCollectionEquality().hash(_tokens),const DeepCollectionEquality().hash(_components),const DeepCollectionEquality().hash(_screens),const DeepCollectionEquality().hash(_duplicates),const DeepCollectionEquality().hash(_breaks),commit,updatedAt);
}

@override
String toString() {
    return 'MapUi(summary: $summary, rules: $rules, sources: $sources, paths: $paths, tokens: $tokens, components: $components, screens: $screens, duplicates: $duplicates, breaks: $breaks, commit: $commit, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MapUiCopyWith<$Res> implements $MapUiCopyWith<$Res> {
  factory _$MapUiCopyWith(_MapUi value, $Res Function(_MapUi) _then) = __$MapUiCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<String> rules, List<String> sources, List<String> paths, List<UiToken> tokens, List<UiComponent> components, List<UiScreen> screens, List<UiDuplicate> duplicates, List<UiBreak> breaks, String commit, String updatedAt
});




}
/// @nodoc
class __$MapUiCopyWithImpl<$Res>
    implements _$MapUiCopyWith<$Res> {
  __$MapUiCopyWithImpl(this._self, this._then);

  final _MapUi _self;
  final $Res Function(_MapUi) _then;

/// Create a copy of MapUi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? rules = null,Object? sources = null,Object? paths = null,Object? tokens = null,Object? components = null,Object? screens = null,Object? duplicates = null,Object? breaks = null,Object? commit = null,Object? updatedAt = null,}) {
  return _then(_MapUi(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,paths: null == paths ? _self._paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,tokens: null == tokens ? _self._tokens : tokens // ignore: cast_nullable_to_non_nullable
as List<UiToken>,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<UiComponent>,screens: null == screens ? _self._screens : screens // ignore: cast_nullable_to_non_nullable
as List<UiScreen>,duplicates: null == duplicates ? _self._duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as List<UiDuplicate>,breaks: null == breaks ? _self._breaks : breaks // ignore: cast_nullable_to_non_nullable
as List<UiBreak>,commit: null == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BrokenLink {

 String get from; String get to;
/// Create a copy of BrokenLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrokenLinkCopyWith<BrokenLink> get copyWith => _$BrokenLinkCopyWithImpl<BrokenLink>(this as BrokenLink, _$identity);

  /// Serializes this BrokenLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BrokenLink;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrokenLink&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BrokenLink;
  return Object.hash(runtimeType,_this.from,_this.to);
}

@override
String toString() {
  final _this = this as BrokenLink;
  return 'BrokenLink(from: ${_this.from}, to: ${_this.to})';
}


}

/// @nodoc
abstract mixin class $BrokenLinkCopyWith<$Res>  {
  factory $BrokenLinkCopyWith(BrokenLink value, $Res Function(BrokenLink) _then) = _$BrokenLinkCopyWithImpl;
@useResult
$Res call({
 String from, String to
});




}
/// @nodoc
class _$BrokenLinkCopyWithImpl<$Res>
    implements $BrokenLinkCopyWith<$Res> {
  _$BrokenLinkCopyWithImpl(this._self, this._then);

  final BrokenLink _self;
  final $Res Function(BrokenLink) _then;

/// Create a copy of BrokenLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(BrokenLink(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BrokenLink].
extension BrokenLinkPatterns on BrokenLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrokenLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrokenLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrokenLink value)  $default,){
final _that = this;
switch (_that) {
case _BrokenLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrokenLink value)?  $default,){
final _that = this;
switch (_that) {
case _BrokenLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrokenLink() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to)  $default,) {final _that = this;
switch (_that) {
case _BrokenLink():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to)?  $default,) {final _that = this;
switch (_that) {
case _BrokenLink() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrokenLink implements BrokenLink {
  const _BrokenLink({required this.from, required this.to});
  factory _BrokenLink.fromJson(Map<String, dynamic> json) => _$BrokenLinkFromJson(json);

@override final  String from;
@override final  String to;

/// Create a copy of BrokenLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrokenLinkCopyWith<_BrokenLink> get copyWith => __$BrokenLinkCopyWithImpl<_BrokenLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrokenLinkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrokenLink&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,to);
}

@override
String toString() {
    return 'BrokenLink(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$BrokenLinkCopyWith<$Res> implements $BrokenLinkCopyWith<$Res> {
  factory _$BrokenLinkCopyWith(_BrokenLink value, $Res Function(_BrokenLink) _then) = __$BrokenLinkCopyWithImpl;
@override @useResult
$Res call({
 String from, String to
});




}
/// @nodoc
class __$BrokenLinkCopyWithImpl<$Res>
    implements _$BrokenLinkCopyWith<$Res> {
  __$BrokenLinkCopyWithImpl(this._self, this._then);

  final _BrokenLink _self;
  final $Res Function(_BrokenLink) _then;

/// Create a copy of BrokenLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_BrokenLink(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FeatureMap {

 String get root;/// The head of the last complete pass, null before the first one.
 String? get commit; String? get updatedAt; String get head;/// The stamped commit is gone (rebase, shallow clone): every feature is stale.
 bool get commitMissing; List<MapFeature> get features; List<String> get changedFiles; List<String> get staleFeatures; List<String> get uncoveredFiles; List<BrokenLink> get brokenLinks; List<MapDataType> get dataTypes; List<String> get staleData;/// The features the current pass said it would draw (Deck's `plan.json`),
/// empty when no pass is under way.
 List<String> get plan;/// The planned features not drawn or confirmed since the plan: what a
/// stopped pass has left to do.
 List<String> get planLeft;/// The layers and where the code breaks them, null until drawn.
 MapArchitecture? get architecture;/// A file under a layer changed since the architecture was written.
 bool get staleArchitecture;/// The UI checked against its guidelines, null until drawn.
 MapUi? get ui;/// A file under the UI folders or its sources changed since it was written.
 bool get staleUi;
/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureMapCopyWith<FeatureMap> get copyWith => _$FeatureMapCopyWithImpl<FeatureMap>(this as FeatureMap, _$identity);

  /// Serializes this FeatureMap to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeatureMap;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureMap&&(identical(other.root, _this.root) || other.root == _this.root)&&(identical(other.commit, _this.commit) || other.commit == _this.commit)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.head, _this.head) || other.head == _this.head)&&(identical(other.commitMissing, _this.commitMissing) || other.commitMissing == _this.commitMissing)&&const DeepCollectionEquality().equals(other.features, _this.features)&&const DeepCollectionEquality().equals(other.changedFiles, _this.changedFiles)&&const DeepCollectionEquality().equals(other.staleFeatures, _this.staleFeatures)&&const DeepCollectionEquality().equals(other.uncoveredFiles, _this.uncoveredFiles)&&const DeepCollectionEquality().equals(other.brokenLinks, _this.brokenLinks)&&const DeepCollectionEquality().equals(other.dataTypes, _this.dataTypes)&&const DeepCollectionEquality().equals(other.staleData, _this.staleData)&&const DeepCollectionEquality().equals(other.plan, _this.plan)&&const DeepCollectionEquality().equals(other.planLeft, _this.planLeft)&&(identical(other.architecture, _this.architecture) || other.architecture == _this.architecture)&&(identical(other.staleArchitecture, _this.staleArchitecture) || other.staleArchitecture == _this.staleArchitecture)&&(identical(other.ui, _this.ui) || other.ui == _this.ui)&&(identical(other.staleUi, _this.staleUi) || other.staleUi == _this.staleUi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeatureMap;
  return Object.hash(runtimeType,_this.root,_this.commit,_this.updatedAt,_this.head,_this.commitMissing,const DeepCollectionEquality().hash(_this.features),const DeepCollectionEquality().hash(_this.changedFiles),const DeepCollectionEquality().hash(_this.staleFeatures),const DeepCollectionEquality().hash(_this.uncoveredFiles),const DeepCollectionEquality().hash(_this.brokenLinks),const DeepCollectionEquality().hash(_this.dataTypes),const DeepCollectionEquality().hash(_this.staleData),const DeepCollectionEquality().hash(_this.plan),const DeepCollectionEquality().hash(_this.planLeft),_this.architecture,_this.staleArchitecture,_this.ui,_this.staleUi);
}

@override
String toString() {
  final _this = this as FeatureMap;
  return 'FeatureMap(root: ${_this.root}, commit: ${_this.commit}, updatedAt: ${_this.updatedAt}, head: ${_this.head}, commitMissing: ${_this.commitMissing}, features: ${_this.features}, changedFiles: ${_this.changedFiles}, staleFeatures: ${_this.staleFeatures}, uncoveredFiles: ${_this.uncoveredFiles}, brokenLinks: ${_this.brokenLinks}, dataTypes: ${_this.dataTypes}, staleData: ${_this.staleData}, plan: ${_this.plan}, planLeft: ${_this.planLeft}, architecture: ${_this.architecture}, staleArchitecture: ${_this.staleArchitecture}, ui: ${_this.ui}, staleUi: ${_this.staleUi})';
}


}

/// @nodoc
abstract mixin class $FeatureMapCopyWith<$Res>  {
  factory $FeatureMapCopyWith(FeatureMap value, $Res Function(FeatureMap) _then) = _$FeatureMapCopyWithImpl;
@useResult
$Res call({
 String root, String? commit, String? updatedAt, String head, bool commitMissing, List<MapFeature> features, List<String> changedFiles, List<String> staleFeatures, List<String> uncoveredFiles, List<BrokenLink> brokenLinks, List<MapDataType> dataTypes, List<String> staleData, List<String> plan, List<String> planLeft, MapArchitecture? architecture, bool staleArchitecture, MapUi? ui, bool staleUi
});


$MapArchitectureCopyWith<$Res>? get architecture;$MapUiCopyWith<$Res>? get ui;

}
/// @nodoc
class _$FeatureMapCopyWithImpl<$Res>
    implements $FeatureMapCopyWith<$Res> {
  _$FeatureMapCopyWithImpl(this._self, this._then);

  final FeatureMap _self;
  final $Res Function(FeatureMap) _then;

/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? root = null,Object? commit = freezed,Object? updatedAt = freezed,Object? head = null,Object? commitMissing = null,Object? features = null,Object? changedFiles = null,Object? staleFeatures = null,Object? uncoveredFiles = null,Object? brokenLinks = null,Object? dataTypes = null,Object? staleData = null,Object? plan = null,Object? planLeft = null,Object? architecture = freezed,Object? staleArchitecture = null,Object? ui = freezed,Object? staleUi = null,}) {
  return _then(FeatureMap(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as String,commit: freezed == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as String,commitMissing: null == commitMissing ? _self.commitMissing : commitMissing // ignore: cast_nullable_to_non_nullable
as bool,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,changedFiles: null == changedFiles ? _self.changedFiles : changedFiles // ignore: cast_nullable_to_non_nullable
as List<String>,staleFeatures: null == staleFeatures ? _self.staleFeatures : staleFeatures // ignore: cast_nullable_to_non_nullable
as List<String>,uncoveredFiles: null == uncoveredFiles ? _self.uncoveredFiles : uncoveredFiles // ignore: cast_nullable_to_non_nullable
as List<String>,brokenLinks: null == brokenLinks ? _self.brokenLinks : brokenLinks // ignore: cast_nullable_to_non_nullable
as List<BrokenLink>,dataTypes: null == dataTypes ? _self.dataTypes : dataTypes // ignore: cast_nullable_to_non_nullable
as List<MapDataType>,staleData: null == staleData ? _self.staleData : staleData // ignore: cast_nullable_to_non_nullable
as List<String>,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as List<String>,planLeft: null == planLeft ? _self.planLeft : planLeft // ignore: cast_nullable_to_non_nullable
as List<String>,architecture: freezed == architecture ? _self.architecture : architecture // ignore: cast_nullable_to_non_nullable
as MapArchitecture?,staleArchitecture: null == staleArchitecture ? _self.staleArchitecture : staleArchitecture // ignore: cast_nullable_to_non_nullable
as bool,ui: freezed == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as MapUi?,staleUi: null == staleUi ? _self.staleUi : staleUi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapArchitectureCopyWith<$Res>? get architecture {
    if (_self.architecture == null) {
    return null;
  }

  return $MapArchitectureCopyWith<$Res>(_self.architecture!, (value) {
    return _then(_self.copyWith(architecture: value));
  });
}/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapUiCopyWith<$Res>? get ui {
    if (_self.ui == null) {
    return null;
  }

  return $MapUiCopyWith<$Res>(_self.ui!, (value) {
    return _then(_self.copyWith(ui: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeatureMap].
extension FeatureMapPatterns on FeatureMap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureMap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureMap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureMap value)  $default,){
final _that = this;
switch (_that) {
case _FeatureMap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureMap value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureMap() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String root,  String? commit,  String? updatedAt,  String head,  bool commitMissing,  List<MapFeature> features,  List<String> changedFiles,  List<String> staleFeatures,  List<String> uncoveredFiles,  List<BrokenLink> brokenLinks,  List<MapDataType> dataTypes,  List<String> staleData,  List<String> plan,  List<String> planLeft,  MapArchitecture? architecture,  bool staleArchitecture,  MapUi? ui,  bool staleUi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureMap() when $default != null:
return $default(_that.root,_that.commit,_that.updatedAt,_that.head,_that.commitMissing,_that.features,_that.changedFiles,_that.staleFeatures,_that.uncoveredFiles,_that.brokenLinks,_that.dataTypes,_that.staleData,_that.plan,_that.planLeft,_that.architecture,_that.staleArchitecture,_that.ui,_that.staleUi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String root,  String? commit,  String? updatedAt,  String head,  bool commitMissing,  List<MapFeature> features,  List<String> changedFiles,  List<String> staleFeatures,  List<String> uncoveredFiles,  List<BrokenLink> brokenLinks,  List<MapDataType> dataTypes,  List<String> staleData,  List<String> plan,  List<String> planLeft,  MapArchitecture? architecture,  bool staleArchitecture,  MapUi? ui,  bool staleUi)  $default,) {final _that = this;
switch (_that) {
case _FeatureMap():
return $default(_that.root,_that.commit,_that.updatedAt,_that.head,_that.commitMissing,_that.features,_that.changedFiles,_that.staleFeatures,_that.uncoveredFiles,_that.brokenLinks,_that.dataTypes,_that.staleData,_that.plan,_that.planLeft,_that.architecture,_that.staleArchitecture,_that.ui,_that.staleUi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String root,  String? commit,  String? updatedAt,  String head,  bool commitMissing,  List<MapFeature> features,  List<String> changedFiles,  List<String> staleFeatures,  List<String> uncoveredFiles,  List<BrokenLink> brokenLinks,  List<MapDataType> dataTypes,  List<String> staleData,  List<String> plan,  List<String> planLeft,  MapArchitecture? architecture,  bool staleArchitecture,  MapUi? ui,  bool staleUi)?  $default,) {final _that = this;
switch (_that) {
case _FeatureMap() when $default != null:
return $default(_that.root,_that.commit,_that.updatedAt,_that.head,_that.commitMissing,_that.features,_that.changedFiles,_that.staleFeatures,_that.uncoveredFiles,_that.brokenLinks,_that.dataTypes,_that.staleData,_that.plan,_that.planLeft,_that.architecture,_that.staleArchitecture,_that.ui,_that.staleUi);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureMap implements FeatureMap {
  const _FeatureMap({required this.root, this.commit, this.updatedAt, required this.head, this.commitMissing = false,  List<MapFeature> features = const [],  List<String> changedFiles = const [],  List<String> staleFeatures = const [],  List<String> uncoveredFiles = const [],  List<BrokenLink> brokenLinks = const [],  List<MapDataType> dataTypes = const [],  List<String> staleData = const [],  List<String> plan = const [],  List<String> planLeft = const [], this.architecture, this.staleArchitecture = false, this.ui, this.staleUi = false}): _features = features,_changedFiles = changedFiles,_staleFeatures = staleFeatures,_uncoveredFiles = uncoveredFiles,_brokenLinks = brokenLinks,_dataTypes = dataTypes,_staleData = staleData,_plan = plan,_planLeft = planLeft;
  factory _FeatureMap.fromJson(Map<String, dynamic> json) => _$FeatureMapFromJson(json);

@override final  String root;
/// The head of the last complete pass, null before the first one.
@override final  String? commit;
@override final  String? updatedAt;
@override final  String head;
/// The stamped commit is gone (rebase, shallow clone): every feature is stale.
@override@JsonKey() final  bool commitMissing;
 final  List<MapFeature> _features;
@override@JsonKey() List<MapFeature> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

 final  List<String> _changedFiles;
@override@JsonKey() List<String> get changedFiles {
  if (_changedFiles is EqualUnmodifiableListView) return _changedFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changedFiles);
}

 final  List<String> _staleFeatures;
@override@JsonKey() List<String> get staleFeatures {
  if (_staleFeatures is EqualUnmodifiableListView) return _staleFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staleFeatures);
}

 final  List<String> _uncoveredFiles;
@override@JsonKey() List<String> get uncoveredFiles {
  if (_uncoveredFiles is EqualUnmodifiableListView) return _uncoveredFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uncoveredFiles);
}

 final  List<BrokenLink> _brokenLinks;
@override@JsonKey() List<BrokenLink> get brokenLinks {
  if (_brokenLinks is EqualUnmodifiableListView) return _brokenLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_brokenLinks);
}

 final  List<MapDataType> _dataTypes;
@override@JsonKey() List<MapDataType> get dataTypes {
  if (_dataTypes is EqualUnmodifiableListView) return _dataTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dataTypes);
}

 final  List<String> _staleData;
@override@JsonKey() List<String> get staleData {
  if (_staleData is EqualUnmodifiableListView) return _staleData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staleData);
}

/// The features the current pass said it would draw (Deck's `plan.json`),
/// empty when no pass is under way.
 final  List<String> _plan;
/// The features the current pass said it would draw (Deck's `plan.json`),
/// empty when no pass is under way.
@override@JsonKey() List<String> get plan {
  if (_plan is EqualUnmodifiableListView) return _plan;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plan);
}

/// The planned features not drawn or confirmed since the plan: what a
/// stopped pass has left to do.
 final  List<String> _planLeft;
/// The planned features not drawn or confirmed since the plan: what a
/// stopped pass has left to do.
@override@JsonKey() List<String> get planLeft {
  if (_planLeft is EqualUnmodifiableListView) return _planLeft;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_planLeft);
}

/// The layers and where the code breaks them, null until drawn.
@override final  MapArchitecture? architecture;
/// A file under a layer changed since the architecture was written.
@override@JsonKey() final  bool staleArchitecture;
/// The UI checked against its guidelines, null until drawn.
@override final  MapUi? ui;
/// A file under the UI folders or its sources changed since it was written.
@override@JsonKey() final  bool staleUi;

/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureMapCopyWith<_FeatureMap> get copyWith => __$FeatureMapCopyWithImpl<_FeatureMap>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureMapToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureMap&&(identical(other.root, root) || other.root == root)&&(identical(other.commit, commit) || other.commit == commit)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.head, head) || other.head == head)&&(identical(other.commitMissing, commitMissing) || other.commitMissing == commitMissing)&&const DeepCollectionEquality().equals(other.features, _features)&&const DeepCollectionEquality().equals(other.changedFiles, _changedFiles)&&const DeepCollectionEquality().equals(other.staleFeatures, _staleFeatures)&&const DeepCollectionEquality().equals(other.uncoveredFiles, _uncoveredFiles)&&const DeepCollectionEquality().equals(other.brokenLinks, _brokenLinks)&&const DeepCollectionEquality().equals(other.dataTypes, _dataTypes)&&const DeepCollectionEquality().equals(other.staleData, _staleData)&&const DeepCollectionEquality().equals(other.plan, _plan)&&const DeepCollectionEquality().equals(other.planLeft, _planLeft)&&(identical(other.architecture, architecture) || other.architecture == architecture)&&(identical(other.staleArchitecture, staleArchitecture) || other.staleArchitecture == staleArchitecture)&&(identical(other.ui, ui) || other.ui == ui)&&(identical(other.staleUi, staleUi) || other.staleUi == staleUi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,root,commit,updatedAt,head,commitMissing,const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_changedFiles),const DeepCollectionEquality().hash(_staleFeatures),const DeepCollectionEquality().hash(_uncoveredFiles),const DeepCollectionEquality().hash(_brokenLinks),const DeepCollectionEquality().hash(_dataTypes),const DeepCollectionEquality().hash(_staleData),const DeepCollectionEquality().hash(_plan),const DeepCollectionEquality().hash(_planLeft),architecture,staleArchitecture,ui,staleUi);
}

@override
String toString() {
    return 'FeatureMap(root: $root, commit: $commit, updatedAt: $updatedAt, head: $head, commitMissing: $commitMissing, features: $features, changedFiles: $changedFiles, staleFeatures: $staleFeatures, uncoveredFiles: $uncoveredFiles, brokenLinks: $brokenLinks, dataTypes: $dataTypes, staleData: $staleData, plan: $plan, planLeft: $planLeft, architecture: $architecture, staleArchitecture: $staleArchitecture, ui: $ui, staleUi: $staleUi)';
}


}

/// @nodoc
abstract mixin class _$FeatureMapCopyWith<$Res> implements $FeatureMapCopyWith<$Res> {
  factory _$FeatureMapCopyWith(_FeatureMap value, $Res Function(_FeatureMap) _then) = __$FeatureMapCopyWithImpl;
@override @useResult
$Res call({
 String root, String? commit, String? updatedAt, String head, bool commitMissing, List<MapFeature> features, List<String> changedFiles, List<String> staleFeatures, List<String> uncoveredFiles, List<BrokenLink> brokenLinks, List<MapDataType> dataTypes, List<String> staleData, List<String> plan, List<String> planLeft, MapArchitecture? architecture, bool staleArchitecture, MapUi? ui, bool staleUi
});


@override $MapArchitectureCopyWith<$Res>? get architecture;@override $MapUiCopyWith<$Res>? get ui;

}
/// @nodoc
class __$FeatureMapCopyWithImpl<$Res>
    implements _$FeatureMapCopyWith<$Res> {
  __$FeatureMapCopyWithImpl(this._self, this._then);

  final _FeatureMap _self;
  final $Res Function(_FeatureMap) _then;

/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? root = null,Object? commit = freezed,Object? updatedAt = freezed,Object? head = null,Object? commitMissing = null,Object? features = null,Object? changedFiles = null,Object? staleFeatures = null,Object? uncoveredFiles = null,Object? brokenLinks = null,Object? dataTypes = null,Object? staleData = null,Object? plan = null,Object? planLeft = null,Object? architecture = freezed,Object? staleArchitecture = null,Object? ui = freezed,Object? staleUi = null,}) {
  return _then(_FeatureMap(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as String,commit: freezed == commit ? _self.commit : commit // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as String,commitMissing: null == commitMissing ? _self.commitMissing : commitMissing // ignore: cast_nullable_to_non_nullable
as bool,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,changedFiles: null == changedFiles ? _self._changedFiles : changedFiles // ignore: cast_nullable_to_non_nullable
as List<String>,staleFeatures: null == staleFeatures ? _self._staleFeatures : staleFeatures // ignore: cast_nullable_to_non_nullable
as List<String>,uncoveredFiles: null == uncoveredFiles ? _self._uncoveredFiles : uncoveredFiles // ignore: cast_nullable_to_non_nullable
as List<String>,brokenLinks: null == brokenLinks ? _self._brokenLinks : brokenLinks // ignore: cast_nullable_to_non_nullable
as List<BrokenLink>,dataTypes: null == dataTypes ? _self._dataTypes : dataTypes // ignore: cast_nullable_to_non_nullable
as List<MapDataType>,staleData: null == staleData ? _self._staleData : staleData // ignore: cast_nullable_to_non_nullable
as List<String>,plan: null == plan ? _self._plan : plan // ignore: cast_nullable_to_non_nullable
as List<String>,planLeft: null == planLeft ? _self._planLeft : planLeft // ignore: cast_nullable_to_non_nullable
as List<String>,architecture: freezed == architecture ? _self.architecture : architecture // ignore: cast_nullable_to_non_nullable
as MapArchitecture?,staleArchitecture: null == staleArchitecture ? _self.staleArchitecture : staleArchitecture // ignore: cast_nullable_to_non_nullable
as bool,ui: freezed == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as MapUi?,staleUi: null == staleUi ? _self.staleUi : staleUi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapArchitectureCopyWith<$Res>? get architecture {
    if (_self.architecture == null) {
    return null;
  }

  return $MapArchitectureCopyWith<$Res>(_self.architecture!, (value) {
    return _then(_self.copyWith(architecture: value));
  });
}/// Create a copy of FeatureMap
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapUiCopyWith<$Res>? get ui {
    if (_self.ui == null) {
    return null;
  }

  return $MapUiCopyWith<$Res>(_self.ui!, (value) {
    return _then(_self.copyWith(ui: value));
  });
}
}

// dart format on
