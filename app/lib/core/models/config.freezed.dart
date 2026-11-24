// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderConfig {

 bool get enabled;@JsonKey(unknownEnumValue: Access.cli) Access get access;/// Provider specific settings (Jira escalation type, Slack queries...).
 Map<String, String> get options;
/// Create a copy of ProviderConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderConfigCopyWith<ProviderConfig> get copyWith => _$ProviderConfigCopyWithImpl<ProviderConfig>(this as ProviderConfig, _$identity);

  /// Serializes this ProviderConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProviderConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderConfig&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.access, _this.access) || other.access == _this.access)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProviderConfig;
  return Object.hash(runtimeType,_this.enabled,_this.access,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as ProviderConfig;
  return 'ProviderConfig(enabled: ${_this.enabled}, access: ${_this.access}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $ProviderConfigCopyWith<$Res>  {
  factory $ProviderConfigCopyWith(ProviderConfig value, $Res Function(ProviderConfig) _then) = _$ProviderConfigCopyWithImpl;
@useResult
$Res call({
 bool enabled,@JsonKey(unknownEnumValue: Access.cli) Access access, Map<String, String> options
});




}
/// @nodoc
class _$ProviderConfigCopyWithImpl<$Res>
    implements $ProviderConfigCopyWith<$Res> {
  _$ProviderConfigCopyWithImpl(this._self, this._then);

  final ProviderConfig _self;
  final $Res Function(ProviderConfig) _then;

/// Create a copy of ProviderConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? access = null,Object? options = null,}) {
  return _then(ProviderConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as Access,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderConfig].
extension ProviderConfigPatterns on ProviderConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderConfig value)  $default,){
final _that = this;
switch (_that) {
case _ProviderConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled, @JsonKey(unknownEnumValue: Access.cli)  Access access,  Map<String, String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderConfig() when $default != null:
return $default(_that.enabled,_that.access,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled, @JsonKey(unknownEnumValue: Access.cli)  Access access,  Map<String, String> options)  $default,) {final _that = this;
switch (_that) {
case _ProviderConfig():
return $default(_that.enabled,_that.access,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled, @JsonKey(unknownEnumValue: Access.cli)  Access access,  Map<String, String> options)?  $default,) {final _that = this;
switch (_that) {
case _ProviderConfig() when $default != null:
return $default(_that.enabled,_that.access,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderConfig implements ProviderConfig {
  const _ProviderConfig({this.enabled = true, @JsonKey(unknownEnumValue: Access.cli) this.access = Access.claude,  Map<String, String> options = const {}}): _options = options;
  factory _ProviderConfig.fromJson(Map<String, dynamic> json) => _$ProviderConfigFromJson(json);

@override@JsonKey() final  bool enabled;
@override@JsonKey(unknownEnumValue: Access.cli) final  Access access;
/// Provider specific settings (Jira escalation type, Slack queries...).
 final  Map<String, String> _options;
/// Provider specific settings (Jira escalation type, Slack queries...).
@override@JsonKey() Map<String, String> get options {
  if (_options is EqualUnmodifiableMapView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_options);
}


/// Create a copy of ProviderConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderConfigCopyWith<_ProviderConfig> get copyWith => __$ProviderConfigCopyWithImpl<_ProviderConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.access, access) || other.access == access)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,access,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'ProviderConfig(enabled: $enabled, access: $access, options: $options)';
}


}

/// @nodoc
abstract mixin class _$ProviderConfigCopyWith<$Res> implements $ProviderConfigCopyWith<$Res> {
  factory _$ProviderConfigCopyWith(_ProviderConfig value, $Res Function(_ProviderConfig) _then) = __$ProviderConfigCopyWithImpl;
@override @useResult
$Res call({
 bool enabled,@JsonKey(unknownEnumValue: Access.cli) Access access, Map<String, String> options
});




}
/// @nodoc
class __$ProviderConfigCopyWithImpl<$Res>
    implements _$ProviderConfigCopyWith<$Res> {
  __$ProviderConfigCopyWithImpl(this._self, this._then);

  final _ProviderConfig _self;
  final $Res Function(_ProviderConfig) _then;

/// Create a copy of ProviderConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? access = null,Object? options = null,}) {
  return _then(_ProviderConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as Access,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$ProjectConfig {

 String get id; String get name; String? get dir;/// "gitlab:group/project" or "github:owner/repo".
 String? get repo;/// "jira:KEY", "gitlab:group/project" or "github:owner/repo".
 String? get board; List<String> get channels;/// Start ticket work in a git worktree.
 bool get worktree;/// IDE command for this project. Null uses the one in Actions.
 String? get ide;/// Chrome profile folder ("Profile 2") its links open in. Null uses the
/// one in Actions.
 String? get browserProfile;/// What the project is, in a sentence. Written by the project info run,
/// editable.
 String? get description;/// Other names messages use for it: app and store names, bundle ids,
/// ticket prefixes. Claude tags Slack and mail with them.
 List<String> get aliases;/// The app icon: a file in the Deck state folder, `projects/<id>-<time>.png`.
 String? get logo;/// Where it runs, from [platforms]: a badge on the logo tells two apps of
/// one product apart.
 List<String> get platforms;/// Languages, frameworks and tools, in a few words: "Swift, SwiftUI, Xcode".
 String? get tech;
/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectConfigCopyWith<ProjectConfig> get copyWith => _$ProjectConfigCopyWithImpl<ProjectConfig>(this as ProjectConfig, _$identity);

  /// Serializes this ProjectConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectConfig&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.dir, _this.dir) || other.dir == _this.dir)&&(identical(other.repo, _this.repo) || other.repo == _this.repo)&&(identical(other.board, _this.board) || other.board == _this.board)&&const DeepCollectionEquality().equals(other.channels, _this.channels)&&(identical(other.worktree, _this.worktree) || other.worktree == _this.worktree)&&(identical(other.ide, _this.ide) || other.ide == _this.ide)&&(identical(other.browserProfile, _this.browserProfile) || other.browserProfile == _this.browserProfile)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.logo, _this.logo) || other.logo == _this.logo)&&const DeepCollectionEquality().equals(other.platforms, _this.platforms)&&(identical(other.tech, _this.tech) || other.tech == _this.tech));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectConfig;
  return Object.hash(runtimeType,_this.id,_this.name,_this.dir,_this.repo,_this.board,const DeepCollectionEquality().hash(_this.channels),_this.worktree,_this.ide,_this.browserProfile,_this.description,const DeepCollectionEquality().hash(_this.aliases),_this.logo,const DeepCollectionEquality().hash(_this.platforms),_this.tech);
}

@override
String toString() {
  final _this = this as ProjectConfig;
  return 'ProjectConfig(id: ${_this.id}, name: ${_this.name}, dir: ${_this.dir}, repo: ${_this.repo}, board: ${_this.board}, channels: ${_this.channels}, worktree: ${_this.worktree}, ide: ${_this.ide}, browserProfile: ${_this.browserProfile}, description: ${_this.description}, aliases: ${_this.aliases}, logo: ${_this.logo}, platforms: ${_this.platforms}, tech: ${_this.tech})';
}


}

/// @nodoc
abstract mixin class $ProjectConfigCopyWith<$Res>  {
  factory $ProjectConfigCopyWith(ProjectConfig value, $Res Function(ProjectConfig) _then) = _$ProjectConfigCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? dir, String? repo, String? board, List<String> channels, bool worktree, String? ide, String? browserProfile, String? description, List<String> aliases, String? logo, List<String> platforms, String? tech
});




}
/// @nodoc
class _$ProjectConfigCopyWithImpl<$Res>
    implements $ProjectConfigCopyWith<$Res> {
  _$ProjectConfigCopyWithImpl(this._self, this._then);

  final ProjectConfig _self;
  final $Res Function(ProjectConfig) _then;

/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dir = freezed,Object? repo = freezed,Object? board = freezed,Object? channels = null,Object? worktree = null,Object? ide = freezed,Object? browserProfile = freezed,Object? description = freezed,Object? aliases = null,Object? logo = freezed,Object? platforms = null,Object? tech = freezed,}) {
  return _then(ProjectConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dir: freezed == dir ? _self.dir : dir // ignore: cast_nullable_to_non_nullable
as String?,repo: freezed == repo ? _self.repo : repo // ignore: cast_nullable_to_non_nullable
as String?,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String?,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,worktree: null == worktree ? _self.worktree : worktree // ignore: cast_nullable_to_non_nullable
as bool,ide: freezed == ide ? _self.ide : ide // ignore: cast_nullable_to_non_nullable
as String?,browserProfile: freezed == browserProfile ? _self.browserProfile : browserProfile // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,platforms: null == platforms ? _self.platforms : platforms // ignore: cast_nullable_to_non_nullable
as List<String>,tech: freezed == tech ? _self.tech : tech // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectConfig].
extension ProjectConfigPatterns on ProjectConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectConfig value)  $default,){
final _that = this;
switch (_that) {
case _ProjectConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? dir,  String? repo,  String? board,  List<String> channels,  bool worktree,  String? ide,  String? browserProfile,  String? description,  List<String> aliases,  String? logo,  List<String> platforms,  String? tech)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
return $default(_that.id,_that.name,_that.dir,_that.repo,_that.board,_that.channels,_that.worktree,_that.ide,_that.browserProfile,_that.description,_that.aliases,_that.logo,_that.platforms,_that.tech);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? dir,  String? repo,  String? board,  List<String> channels,  bool worktree,  String? ide,  String? browserProfile,  String? description,  List<String> aliases,  String? logo,  List<String> platforms,  String? tech)  $default,) {final _that = this;
switch (_that) {
case _ProjectConfig():
return $default(_that.id,_that.name,_that.dir,_that.repo,_that.board,_that.channels,_that.worktree,_that.ide,_that.browserProfile,_that.description,_that.aliases,_that.logo,_that.platforms,_that.tech);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? dir,  String? repo,  String? board,  List<String> channels,  bool worktree,  String? ide,  String? browserProfile,  String? description,  List<String> aliases,  String? logo,  List<String> platforms,  String? tech)?  $default,) {final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
return $default(_that.id,_that.name,_that.dir,_that.repo,_that.board,_that.channels,_that.worktree,_that.ide,_that.browserProfile,_that.description,_that.aliases,_that.logo,_that.platforms,_that.tech);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectConfig implements ProjectConfig {
  const _ProjectConfig({required this.id, required this.name, this.dir, this.repo, this.board,  List<String> channels = const [], this.worktree = true, this.ide, this.browserProfile, this.description,  List<String> aliases = const [], this.logo,  List<String> platforms = const [], this.tech}): _channels = channels,_aliases = aliases,_platforms = platforms;
  factory _ProjectConfig.fromJson(Map<String, dynamic> json) => _$ProjectConfigFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? dir;
/// "gitlab:group/project" or "github:owner/repo".
@override final  String? repo;
/// "jira:KEY", "gitlab:group/project" or "github:owner/repo".
@override final  String? board;
 final  List<String> _channels;
@override@JsonKey() List<String> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

/// Start ticket work in a git worktree.
@override@JsonKey() final  bool worktree;
/// IDE command for this project. Null uses the one in Actions.
@override final  String? ide;
/// Chrome profile folder ("Profile 2") its links open in. Null uses the
/// one in Actions.
@override final  String? browserProfile;
/// What the project is, in a sentence. Written by the project info run,
/// editable.
@override final  String? description;
/// Other names messages use for it: app and store names, bundle ids,
/// ticket prefixes. Claude tags Slack and mail with them.
 final  List<String> _aliases;
/// Other names messages use for it: app and store names, bundle ids,
/// ticket prefixes. Claude tags Slack and mail with them.
@override@JsonKey() List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

/// The app icon: a file in the Deck state folder, `projects/<id>-<time>.png`.
@override final  String? logo;
/// Where it runs, from [platforms]: a badge on the logo tells two apps of
/// one product apart.
 final  List<String> _platforms;
/// Where it runs, from [platforms]: a badge on the logo tells two apps of
/// one product apart.
@override@JsonKey() List<String> get platforms {
  if (_platforms is EqualUnmodifiableListView) return _platforms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_platforms);
}

/// Languages, frameworks and tools, in a few words: "Swift, SwiftUI, Xcode".
@override final  String? tech;

/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectConfigCopyWith<_ProjectConfig> get copyWith => __$ProjectConfigCopyWithImpl<_ProjectConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dir, dir) || other.dir == dir)&&(identical(other.repo, repo) || other.repo == repo)&&(identical(other.board, board) || other.board == board)&&const DeepCollectionEquality().equals(other.channels, _channels)&&(identical(other.worktree, worktree) || other.worktree == worktree)&&(identical(other.ide, ide) || other.ide == ide)&&(identical(other.browserProfile, browserProfile) || other.browserProfile == browserProfile)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.logo, logo) || other.logo == logo)&&const DeepCollectionEquality().equals(other.platforms, _platforms)&&(identical(other.tech, tech) || other.tech == tech));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,dir,repo,board,const DeepCollectionEquality().hash(_channels),worktree,ide,browserProfile,description,const DeepCollectionEquality().hash(_aliases),logo,const DeepCollectionEquality().hash(_platforms),tech);
}

@override
String toString() {
    return 'ProjectConfig(id: $id, name: $name, dir: $dir, repo: $repo, board: $board, channels: $channels, worktree: $worktree, ide: $ide, browserProfile: $browserProfile, description: $description, aliases: $aliases, logo: $logo, platforms: $platforms, tech: $tech)';
}


}

/// @nodoc
abstract mixin class _$ProjectConfigCopyWith<$Res> implements $ProjectConfigCopyWith<$Res> {
  factory _$ProjectConfigCopyWith(_ProjectConfig value, $Res Function(_ProjectConfig) _then) = __$ProjectConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? dir, String? repo, String? board, List<String> channels, bool worktree, String? ide, String? browserProfile, String? description, List<String> aliases, String? logo, List<String> platforms, String? tech
});




}
/// @nodoc
class __$ProjectConfigCopyWithImpl<$Res>
    implements _$ProjectConfigCopyWith<$Res> {
  __$ProjectConfigCopyWithImpl(this._self, this._then);

  final _ProjectConfig _self;
  final $Res Function(_ProjectConfig) _then;

/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dir = freezed,Object? repo = freezed,Object? board = freezed,Object? channels = null,Object? worktree = null,Object? ide = freezed,Object? browserProfile = freezed,Object? description = freezed,Object? aliases = null,Object? logo = freezed,Object? platforms = null,Object? tech = freezed,}) {
  return _then(_ProjectConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dir: freezed == dir ? _self.dir : dir // ignore: cast_nullable_to_non_nullable
as String?,repo: freezed == repo ? _self.repo : repo // ignore: cast_nullable_to_non_nullable
as String?,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String?,channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,worktree: null == worktree ? _self.worktree : worktree // ignore: cast_nullable_to_non_nullable
as bool,ide: freezed == ide ? _self.ide : ide // ignore: cast_nullable_to_non_nullable
as String?,browserProfile: freezed == browserProfile ? _self.browserProfile : browserProfile // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,platforms: null == platforms ? _self._platforms : platforms // ignore: cast_nullable_to_non_nullable
as List<String>,tech: freezed == tech ? _self.tech : tech // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ClaudeConfig {

/// Pulling data: the background runs that read Jira, Slack and mail.
 String get model;/// Code: project maps and reviews, which read the whole repository.
 String get codeModel;/// The skills a review runs to find issues, each with its arguments:
/// "code-review high", "ponytail:ponytail-review". Deck adds the range.
 List<String> get reviewSkills;/// Tool rules every background session may use without asking, in
/// Claude Code syntax: "Bash(npm test:*)", "mcp__server__tool".
 List<String> get allowedTools; int get refreshMinutes;/// Background runs stop for the day once this is spent.
 double get dailyBudgetUsd;/// Ask before a background session uses a tool it was not given.
 bool get askPermission;/// Keep the run ledger, raw logs and issues sessions report, for the
/// deck-insights skill. Off: nothing is written, sessions get no
/// deck_report_issue.
 bool get collectRuns;
/// Create a copy of ClaudeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaudeConfigCopyWith<ClaudeConfig> get copyWith => _$ClaudeConfigCopyWithImpl<ClaudeConfig>(this as ClaudeConfig, _$identity);

  /// Serializes this ClaudeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClaudeConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaudeConfig&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.codeModel, _this.codeModel) || other.codeModel == _this.codeModel)&&const DeepCollectionEquality().equals(other.reviewSkills, _this.reviewSkills)&&const DeepCollectionEquality().equals(other.allowedTools, _this.allowedTools)&&(identical(other.refreshMinutes, _this.refreshMinutes) || other.refreshMinutes == _this.refreshMinutes)&&(identical(other.dailyBudgetUsd, _this.dailyBudgetUsd) || other.dailyBudgetUsd == _this.dailyBudgetUsd)&&(identical(other.askPermission, _this.askPermission) || other.askPermission == _this.askPermission)&&(identical(other.collectRuns, _this.collectRuns) || other.collectRuns == _this.collectRuns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClaudeConfig;
  return Object.hash(runtimeType,_this.model,_this.codeModel,const DeepCollectionEquality().hash(_this.reviewSkills),const DeepCollectionEquality().hash(_this.allowedTools),_this.refreshMinutes,_this.dailyBudgetUsd,_this.askPermission,_this.collectRuns);
}

@override
String toString() {
  final _this = this as ClaudeConfig;
  return 'ClaudeConfig(model: ${_this.model}, codeModel: ${_this.codeModel}, reviewSkills: ${_this.reviewSkills}, allowedTools: ${_this.allowedTools}, refreshMinutes: ${_this.refreshMinutes}, dailyBudgetUsd: ${_this.dailyBudgetUsd}, askPermission: ${_this.askPermission}, collectRuns: ${_this.collectRuns})';
}


}

/// @nodoc
abstract mixin class $ClaudeConfigCopyWith<$Res>  {
  factory $ClaudeConfigCopyWith(ClaudeConfig value, $Res Function(ClaudeConfig) _then) = _$ClaudeConfigCopyWithImpl;
@useResult
$Res call({
 String model, String codeModel, List<String> reviewSkills, List<String> allowedTools, int refreshMinutes, double dailyBudgetUsd, bool askPermission, bool collectRuns
});




}
/// @nodoc
class _$ClaudeConfigCopyWithImpl<$Res>
    implements $ClaudeConfigCopyWith<$Res> {
  _$ClaudeConfigCopyWithImpl(this._self, this._then);

  final ClaudeConfig _self;
  final $Res Function(ClaudeConfig) _then;

/// Create a copy of ClaudeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? codeModel = null,Object? reviewSkills = null,Object? allowedTools = null,Object? refreshMinutes = null,Object? dailyBudgetUsd = null,Object? askPermission = null,Object? collectRuns = null,}) {
  return _then(ClaudeConfig(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,codeModel: null == codeModel ? _self.codeModel : codeModel // ignore: cast_nullable_to_non_nullable
as String,reviewSkills: null == reviewSkills ? _self.reviewSkills : reviewSkills // ignore: cast_nullable_to_non_nullable
as List<String>,allowedTools: null == allowedTools ? _self.allowedTools : allowedTools // ignore: cast_nullable_to_non_nullable
as List<String>,refreshMinutes: null == refreshMinutes ? _self.refreshMinutes : refreshMinutes // ignore: cast_nullable_to_non_nullable
as int,dailyBudgetUsd: null == dailyBudgetUsd ? _self.dailyBudgetUsd : dailyBudgetUsd // ignore: cast_nullable_to_non_nullable
as double,askPermission: null == askPermission ? _self.askPermission : askPermission // ignore: cast_nullable_to_non_nullable
as bool,collectRuns: null == collectRuns ? _self.collectRuns : collectRuns // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaudeConfig].
extension ClaudeConfigPatterns on ClaudeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaudeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaudeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaudeConfig value)  $default,){
final _that = this;
switch (_that) {
case _ClaudeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaudeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ClaudeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String model,  String codeModel,  List<String> reviewSkills,  List<String> allowedTools,  int refreshMinutes,  double dailyBudgetUsd,  bool askPermission,  bool collectRuns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaudeConfig() when $default != null:
return $default(_that.model,_that.codeModel,_that.reviewSkills,_that.allowedTools,_that.refreshMinutes,_that.dailyBudgetUsd,_that.askPermission,_that.collectRuns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String model,  String codeModel,  List<String> reviewSkills,  List<String> allowedTools,  int refreshMinutes,  double dailyBudgetUsd,  bool askPermission,  bool collectRuns)  $default,) {final _that = this;
switch (_that) {
case _ClaudeConfig():
return $default(_that.model,_that.codeModel,_that.reviewSkills,_that.allowedTools,_that.refreshMinutes,_that.dailyBudgetUsd,_that.askPermission,_that.collectRuns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String model,  String codeModel,  List<String> reviewSkills,  List<String> allowedTools,  int refreshMinutes,  double dailyBudgetUsd,  bool askPermission,  bool collectRuns)?  $default,) {final _that = this;
switch (_that) {
case _ClaudeConfig() when $default != null:
return $default(_that.model,_that.codeModel,_that.reviewSkills,_that.allowedTools,_that.refreshMinutes,_that.dailyBudgetUsd,_that.askPermission,_that.collectRuns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClaudeConfig implements ClaudeConfig {
  const _ClaudeConfig({this.model = 'haiku', this.codeModel = 'claude-opus-5-5',  List<String> reviewSkills = const ['code-review high'],  List<String> allowedTools = const [], this.refreshMinutes = 30, this.dailyBudgetUsd = 1.0, this.askPermission = true, this.collectRuns = false}): _reviewSkills = reviewSkills,_allowedTools = allowedTools;
  factory _ClaudeConfig.fromJson(Map<String, dynamic> json) => _$ClaudeConfigFromJson(json);

/// Pulling data: the background runs that read Jira, Slack and mail.
@override@JsonKey() final  String model;
/// Code: project maps and reviews, which read the whole repository.
@override@JsonKey() final  String codeModel;
/// The skills a review runs to find issues, each with its arguments:
/// "code-review high", "ponytail:ponytail-review". Deck adds the range.
 final  List<String> _reviewSkills;
/// The skills a review runs to find issues, each with its arguments:
/// "code-review high", "ponytail:ponytail-review". Deck adds the range.
@override@JsonKey() List<String> get reviewSkills {
  if (_reviewSkills is EqualUnmodifiableListView) return _reviewSkills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviewSkills);
}

/// Tool rules every background session may use without asking, in
/// Claude Code syntax: "Bash(npm test:*)", "mcp__server__tool".
 final  List<String> _allowedTools;
/// Tool rules every background session may use without asking, in
/// Claude Code syntax: "Bash(npm test:*)", "mcp__server__tool".
@override@JsonKey() List<String> get allowedTools {
  if (_allowedTools is EqualUnmodifiableListView) return _allowedTools;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedTools);
}

@override@JsonKey() final  int refreshMinutes;
/// Background runs stop for the day once this is spent.
@override@JsonKey() final  double dailyBudgetUsd;
/// Ask before a background session uses a tool it was not given.
@override@JsonKey() final  bool askPermission;
/// Keep the run ledger, raw logs and issues sessions report, for the
/// deck-insights skill. Off: nothing is written, sessions get no
/// deck_report_issue.
@override@JsonKey() final  bool collectRuns;

/// Create a copy of ClaudeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaudeConfigCopyWith<_ClaudeConfig> get copyWith => __$ClaudeConfigCopyWithImpl<_ClaudeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClaudeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaudeConfig&&(identical(other.model, model) || other.model == model)&&(identical(other.codeModel, codeModel) || other.codeModel == codeModel)&&const DeepCollectionEquality().equals(other.reviewSkills, _reviewSkills)&&const DeepCollectionEquality().equals(other.allowedTools, _allowedTools)&&(identical(other.refreshMinutes, refreshMinutes) || other.refreshMinutes == refreshMinutes)&&(identical(other.dailyBudgetUsd, dailyBudgetUsd) || other.dailyBudgetUsd == dailyBudgetUsd)&&(identical(other.askPermission, askPermission) || other.askPermission == askPermission)&&(identical(other.collectRuns, collectRuns) || other.collectRuns == collectRuns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,model,codeModel,const DeepCollectionEquality().hash(_reviewSkills),const DeepCollectionEquality().hash(_allowedTools),refreshMinutes,dailyBudgetUsd,askPermission,collectRuns);
}

@override
String toString() {
    return 'ClaudeConfig(model: $model, codeModel: $codeModel, reviewSkills: $reviewSkills, allowedTools: $allowedTools, refreshMinutes: $refreshMinutes, dailyBudgetUsd: $dailyBudgetUsd, askPermission: $askPermission, collectRuns: $collectRuns)';
}


}

/// @nodoc
abstract mixin class _$ClaudeConfigCopyWith<$Res> implements $ClaudeConfigCopyWith<$Res> {
  factory _$ClaudeConfigCopyWith(_ClaudeConfig value, $Res Function(_ClaudeConfig) _then) = __$ClaudeConfigCopyWithImpl;
@override @useResult
$Res call({
 String model, String codeModel, List<String> reviewSkills, List<String> allowedTools, int refreshMinutes, double dailyBudgetUsd, bool askPermission, bool collectRuns
});




}
/// @nodoc
class __$ClaudeConfigCopyWithImpl<$Res>
    implements _$ClaudeConfigCopyWith<$Res> {
  __$ClaudeConfigCopyWithImpl(this._self, this._then);

  final _ClaudeConfig _self;
  final $Res Function(_ClaudeConfig) _then;

/// Create a copy of ClaudeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? codeModel = null,Object? reviewSkills = null,Object? allowedTools = null,Object? refreshMinutes = null,Object? dailyBudgetUsd = null,Object? askPermission = null,Object? collectRuns = null,}) {
  return _then(_ClaudeConfig(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,codeModel: null == codeModel ? _self.codeModel : codeModel // ignore: cast_nullable_to_non_nullable
as String,reviewSkills: null == reviewSkills ? _self._reviewSkills : reviewSkills // ignore: cast_nullable_to_non_nullable
as List<String>,allowedTools: null == allowedTools ? _self._allowedTools : allowedTools // ignore: cast_nullable_to_non_nullable
as List<String>,refreshMinutes: null == refreshMinutes ? _self.refreshMinutes : refreshMinutes // ignore: cast_nullable_to_non_nullable
as int,dailyBudgetUsd: null == dailyBudgetUsd ? _self.dailyBudgetUsd : dailyBudgetUsd // ignore: cast_nullable_to_non_nullable
as double,askPermission: null == askPermission ? _self.askPermission : askPermission // ignore: cast_nullable_to_non_nullable
as bool,collectRuns: null == collectRuns ? _self.collectRuns : collectRuns // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ActionsConfig {

 String get ide;/// 'Deck' runs sessions in a panel of the app; 'Terminal' and 'iTerm'
/// open an outside window.
 String get terminal;/// Chrome profile folder links open in when no project picks one. Null
/// uses the default browser.
 String? get browserProfile;/// Where the Deck terminal panel sits: 'bottom' or 'right'.
 String get terminalDock;/// Share of the window the panel takes, docked on the right and at the
/// bottom. Dragging its edge changes it, and it stays for next time.
 double get terminalRight; double get terminalBottom;/// Open sessions as a tab of the front window: iTerm and Windows Terminal
/// only. Terminal.app has no tab command, so it always opens a window.
 bool get newTab; String get review;/// Your own merge request, once reviewers left threads for you.
 String get feedback;
/// Create a copy of ActionsConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionsConfigCopyWith<ActionsConfig> get copyWith => _$ActionsConfigCopyWithImpl<ActionsConfig>(this as ActionsConfig, _$identity);

  /// Serializes this ActionsConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ActionsConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionsConfig&&(identical(other.ide, _this.ide) || other.ide == _this.ide)&&(identical(other.terminal, _this.terminal) || other.terminal == _this.terminal)&&(identical(other.browserProfile, _this.browserProfile) || other.browserProfile == _this.browserProfile)&&(identical(other.terminalDock, _this.terminalDock) || other.terminalDock == _this.terminalDock)&&(identical(other.terminalRight, _this.terminalRight) || other.terminalRight == _this.terminalRight)&&(identical(other.terminalBottom, _this.terminalBottom) || other.terminalBottom == _this.terminalBottom)&&(identical(other.newTab, _this.newTab) || other.newTab == _this.newTab)&&(identical(other.review, _this.review) || other.review == _this.review)&&(identical(other.feedback, _this.feedback) || other.feedback == _this.feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ActionsConfig;
  return Object.hash(runtimeType,_this.ide,_this.terminal,_this.browserProfile,_this.terminalDock,_this.terminalRight,_this.terminalBottom,_this.newTab,_this.review,_this.feedback);
}

@override
String toString() {
  final _this = this as ActionsConfig;
  return 'ActionsConfig(ide: ${_this.ide}, terminal: ${_this.terminal}, browserProfile: ${_this.browserProfile}, terminalDock: ${_this.terminalDock}, terminalRight: ${_this.terminalRight}, terminalBottom: ${_this.terminalBottom}, newTab: ${_this.newTab}, review: ${_this.review}, feedback: ${_this.feedback})';
}


}

/// @nodoc
abstract mixin class $ActionsConfigCopyWith<$Res>  {
  factory $ActionsConfigCopyWith(ActionsConfig value, $Res Function(ActionsConfig) _then) = _$ActionsConfigCopyWithImpl;
@useResult
$Res call({
 String ide, String terminal, String? browserProfile, String terminalDock, double terminalRight, double terminalBottom, bool newTab, String review, String feedback
});




}
/// @nodoc
class _$ActionsConfigCopyWithImpl<$Res>
    implements $ActionsConfigCopyWith<$Res> {
  _$ActionsConfigCopyWithImpl(this._self, this._then);

  final ActionsConfig _self;
  final $Res Function(ActionsConfig) _then;

/// Create a copy of ActionsConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ide = null,Object? terminal = null,Object? browserProfile = freezed,Object? terminalDock = null,Object? terminalRight = null,Object? terminalBottom = null,Object? newTab = null,Object? review = null,Object? feedback = null,}) {
  return _then(ActionsConfig(
ide: null == ide ? _self.ide : ide // ignore: cast_nullable_to_non_nullable
as String,terminal: null == terminal ? _self.terminal : terminal // ignore: cast_nullable_to_non_nullable
as String,browserProfile: freezed == browserProfile ? _self.browserProfile : browserProfile // ignore: cast_nullable_to_non_nullable
as String?,terminalDock: null == terminalDock ? _self.terminalDock : terminalDock // ignore: cast_nullable_to_non_nullable
as String,terminalRight: null == terminalRight ? _self.terminalRight : terminalRight // ignore: cast_nullable_to_non_nullable
as double,terminalBottom: null == terminalBottom ? _self.terminalBottom : terminalBottom // ignore: cast_nullable_to_non_nullable
as double,newTab: null == newTab ? _self.newTab : newTab // ignore: cast_nullable_to_non_nullable
as bool,review: null == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionsConfig].
extension ActionsConfigPatterns on ActionsConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionsConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionsConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionsConfig value)  $default,){
final _that = this;
switch (_that) {
case _ActionsConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionsConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ActionsConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ide,  String terminal,  String? browserProfile,  String terminalDock,  double terminalRight,  double terminalBottom,  bool newTab,  String review,  String feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionsConfig() when $default != null:
return $default(_that.ide,_that.terminal,_that.browserProfile,_that.terminalDock,_that.terminalRight,_that.terminalBottom,_that.newTab,_that.review,_that.feedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ide,  String terminal,  String? browserProfile,  String terminalDock,  double terminalRight,  double terminalBottom,  bool newTab,  String review,  String feedback)  $default,) {final _that = this;
switch (_that) {
case _ActionsConfig():
return $default(_that.ide,_that.terminal,_that.browserProfile,_that.terminalDock,_that.terminalRight,_that.terminalBottom,_that.newTab,_that.review,_that.feedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ide,  String terminal,  String? browserProfile,  String terminalDock,  double terminalRight,  double terminalBottom,  bool newTab,  String review,  String feedback)?  $default,) {final _that = this;
switch (_that) {
case _ActionsConfig() when $default != null:
return $default(_that.ide,_that.terminal,_that.browserProfile,_that.terminalDock,_that.terminalRight,_that.terminalBottom,_that.newTab,_that.review,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionsConfig implements ActionsConfig {
  const _ActionsConfig({this.ide = 'idea', this.terminal = 'Deck', this.browserProfile, this.terminalDock = 'bottom', this.terminalRight = .3, this.terminalBottom = .35, this.newTab = false, this.review = 'claude "/skim-code:review {url}"', this.feedback = 'claude "Read the open review threads on my merge request {url}. For each one, say in a line what you would change or answer. Then wait for my go."'});
  factory _ActionsConfig.fromJson(Map<String, dynamic> json) => _$ActionsConfigFromJson(json);

@override@JsonKey() final  String ide;
/// 'Deck' runs sessions in a panel of the app; 'Terminal' and 'iTerm'
/// open an outside window.
@override@JsonKey() final  String terminal;
/// Chrome profile folder links open in when no project picks one. Null
/// uses the default browser.
@override final  String? browserProfile;
/// Where the Deck terminal panel sits: 'bottom' or 'right'.
@override@JsonKey() final  String terminalDock;
/// Share of the window the panel takes, docked on the right and at the
/// bottom. Dragging its edge changes it, and it stays for next time.
@override@JsonKey() final  double terminalRight;
@override@JsonKey() final  double terminalBottom;
/// Open sessions as a tab of the front window: iTerm and Windows Terminal
/// only. Terminal.app has no tab command, so it always opens a window.
@override@JsonKey() final  bool newTab;
@override@JsonKey() final  String review;
/// Your own merge request, once reviewers left threads for you.
@override@JsonKey() final  String feedback;

/// Create a copy of ActionsConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionsConfigCopyWith<_ActionsConfig> get copyWith => __$ActionsConfigCopyWithImpl<_ActionsConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionsConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionsConfig&&(identical(other.ide, ide) || other.ide == ide)&&(identical(other.terminal, terminal) || other.terminal == terminal)&&(identical(other.browserProfile, browserProfile) || other.browserProfile == browserProfile)&&(identical(other.terminalDock, terminalDock) || other.terminalDock == terminalDock)&&(identical(other.terminalRight, terminalRight) || other.terminalRight == terminalRight)&&(identical(other.terminalBottom, terminalBottom) || other.terminalBottom == terminalBottom)&&(identical(other.newTab, newTab) || other.newTab == newTab)&&(identical(other.review, review) || other.review == review)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ide,terminal,browserProfile,terminalDock,terminalRight,terminalBottom,newTab,review,feedback);
}

@override
String toString() {
    return 'ActionsConfig(ide: $ide, terminal: $terminal, browserProfile: $browserProfile, terminalDock: $terminalDock, terminalRight: $terminalRight, terminalBottom: $terminalBottom, newTab: $newTab, review: $review, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$ActionsConfigCopyWith<$Res> implements $ActionsConfigCopyWith<$Res> {
  factory _$ActionsConfigCopyWith(_ActionsConfig value, $Res Function(_ActionsConfig) _then) = __$ActionsConfigCopyWithImpl;
@override @useResult
$Res call({
 String ide, String terminal, String? browserProfile, String terminalDock, double terminalRight, double terminalBottom, bool newTab, String review, String feedback
});




}
/// @nodoc
class __$ActionsConfigCopyWithImpl<$Res>
    implements _$ActionsConfigCopyWith<$Res> {
  __$ActionsConfigCopyWithImpl(this._self, this._then);

  final _ActionsConfig _self;
  final $Res Function(_ActionsConfig) _then;

/// Create a copy of ActionsConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ide = null,Object? terminal = null,Object? browserProfile = freezed,Object? terminalDock = null,Object? terminalRight = null,Object? terminalBottom = null,Object? newTab = null,Object? review = null,Object? feedback = null,}) {
  return _then(_ActionsConfig(
ide: null == ide ? _self.ide : ide // ignore: cast_nullable_to_non_nullable
as String,terminal: null == terminal ? _self.terminal : terminal // ignore: cast_nullable_to_non_nullable
as String,browserProfile: freezed == browserProfile ? _self.browserProfile : browserProfile // ignore: cast_nullable_to_non_nullable
as String?,terminalDock: null == terminalDock ? _self.terminalDock : terminalDock // ignore: cast_nullable_to_non_nullable
as String,terminalRight: null == terminalRight ? _self.terminalRight : terminalRight // ignore: cast_nullable_to_non_nullable
as double,terminalBottom: null == terminalBottom ? _self.terminalBottom : terminalBottom // ignore: cast_nullable_to_non_nullable
as double,newTab: null == newTab ? _self.newTab : newTab // ignore: cast_nullable_to_non_nullable
as bool,review: null == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DeckConfig {

 Map<String, ProviderConfig> get providers; List<ProjectConfig> get projects; ClaudeConfig get claude; ActionsConfig get actions;/// Commit state changes to the git repo in the Deck folder.
 bool get gitBackup;
/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeckConfigCopyWith<DeckConfig> get copyWith => _$DeckConfigCopyWithImpl<DeckConfig>(this as DeckConfig, _$identity);

  /// Serializes this DeckConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeckConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeckConfig&&const DeepCollectionEquality().equals(other.providers, _this.providers)&&const DeepCollectionEquality().equals(other.projects, _this.projects)&&(identical(other.claude, _this.claude) || other.claude == _this.claude)&&(identical(other.actions, _this.actions) || other.actions == _this.actions)&&(identical(other.gitBackup, _this.gitBackup) || other.gitBackup == _this.gitBackup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeckConfig;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.providers),const DeepCollectionEquality().hash(_this.projects),_this.claude,_this.actions,_this.gitBackup);
}

@override
String toString() {
  final _this = this as DeckConfig;
  return 'DeckConfig(providers: ${_this.providers}, projects: ${_this.projects}, claude: ${_this.claude}, actions: ${_this.actions}, gitBackup: ${_this.gitBackup})';
}


}

/// @nodoc
abstract mixin class $DeckConfigCopyWith<$Res>  {
  factory $DeckConfigCopyWith(DeckConfig value, $Res Function(DeckConfig) _then) = _$DeckConfigCopyWithImpl;
@useResult
$Res call({
 Map<String, ProviderConfig> providers, List<ProjectConfig> projects, ClaudeConfig claude, ActionsConfig actions, bool gitBackup
});


$ClaudeConfigCopyWith<$Res> get claude;$ActionsConfigCopyWith<$Res> get actions;

}
/// @nodoc
class _$DeckConfigCopyWithImpl<$Res>
    implements $DeckConfigCopyWith<$Res> {
  _$DeckConfigCopyWithImpl(this._self, this._then);

  final DeckConfig _self;
  final $Res Function(DeckConfig) _then;

/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? providers = null,Object? projects = null,Object? claude = null,Object? actions = null,Object? gitBackup = null,}) {
  return _then(DeckConfig(
providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as Map<String, ProviderConfig>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectConfig>,claude: null == claude ? _self.claude : claude // ignore: cast_nullable_to_non_nullable
as ClaudeConfig,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as ActionsConfig,gitBackup: null == gitBackup ? _self.gitBackup : gitBackup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClaudeConfigCopyWith<$Res> get claude {
  
  return $ClaudeConfigCopyWith<$Res>(_self.claude, (value) {
    return _then(_self.copyWith(claude: value));
  });
}/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionsConfigCopyWith<$Res> get actions {
  
  return $ActionsConfigCopyWith<$Res>(_self.actions, (value) {
    return _then(_self.copyWith(actions: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeckConfig].
extension DeckConfigPatterns on DeckConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeckConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeckConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeckConfig value)  $default,){
final _that = this;
switch (_that) {
case _DeckConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeckConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DeckConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, ProviderConfig> providers,  List<ProjectConfig> projects,  ClaudeConfig claude,  ActionsConfig actions,  bool gitBackup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeckConfig() when $default != null:
return $default(_that.providers,_that.projects,_that.claude,_that.actions,_that.gitBackup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, ProviderConfig> providers,  List<ProjectConfig> projects,  ClaudeConfig claude,  ActionsConfig actions,  bool gitBackup)  $default,) {final _that = this;
switch (_that) {
case _DeckConfig():
return $default(_that.providers,_that.projects,_that.claude,_that.actions,_that.gitBackup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, ProviderConfig> providers,  List<ProjectConfig> projects,  ClaudeConfig claude,  ActionsConfig actions,  bool gitBackup)?  $default,) {final _that = this;
switch (_that) {
case _DeckConfig() when $default != null:
return $default(_that.providers,_that.projects,_that.claude,_that.actions,_that.gitBackup);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeckConfig implements DeckConfig {
  const _DeckConfig({ Map<String, ProviderConfig> providers = const {},  List<ProjectConfig> projects = const [], this.claude = const ClaudeConfig(), this.actions = const ActionsConfig(), this.gitBackup = true}): _providers = providers,_projects = projects;
  factory _DeckConfig.fromJson(Map<String, dynamic> json) => _$DeckConfigFromJson(json);

 final  Map<String, ProviderConfig> _providers;
@override@JsonKey() Map<String, ProviderConfig> get providers {
  if (_providers is EqualUnmodifiableMapView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_providers);
}

 final  List<ProjectConfig> _projects;
@override@JsonKey() List<ProjectConfig> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}

@override@JsonKey() final  ClaudeConfig claude;
@override@JsonKey() final  ActionsConfig actions;
/// Commit state changes to the git repo in the Deck folder.
@override@JsonKey() final  bool gitBackup;

/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeckConfigCopyWith<_DeckConfig> get copyWith => __$DeckConfigCopyWithImpl<_DeckConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeckConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeckConfig&&const DeepCollectionEquality().equals(other.providers, _providers)&&const DeepCollectionEquality().equals(other.projects, _projects)&&(identical(other.claude, claude) || other.claude == claude)&&(identical(other.actions, actions) || other.actions == actions)&&(identical(other.gitBackup, gitBackup) || other.gitBackup == gitBackup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_providers),const DeepCollectionEquality().hash(_projects),claude,actions,gitBackup);
}

@override
String toString() {
    return 'DeckConfig(providers: $providers, projects: $projects, claude: $claude, actions: $actions, gitBackup: $gitBackup)';
}


}

/// @nodoc
abstract mixin class _$DeckConfigCopyWith<$Res> implements $DeckConfigCopyWith<$Res> {
  factory _$DeckConfigCopyWith(_DeckConfig value, $Res Function(_DeckConfig) _then) = __$DeckConfigCopyWithImpl;
@override @useResult
$Res call({
 Map<String, ProviderConfig> providers, List<ProjectConfig> projects, ClaudeConfig claude, ActionsConfig actions, bool gitBackup
});


@override $ClaudeConfigCopyWith<$Res> get claude;@override $ActionsConfigCopyWith<$Res> get actions;

}
/// @nodoc
class __$DeckConfigCopyWithImpl<$Res>
    implements _$DeckConfigCopyWith<$Res> {
  __$DeckConfigCopyWithImpl(this._self, this._then);

  final _DeckConfig _self;
  final $Res Function(_DeckConfig) _then;

/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providers = null,Object? projects = null,Object? claude = null,Object? actions = null,Object? gitBackup = null,}) {
  return _then(_DeckConfig(
providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as Map<String, ProviderConfig>,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectConfig>,claude: null == claude ? _self.claude : claude // ignore: cast_nullable_to_non_nullable
as ClaudeConfig,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as ActionsConfig,gitBackup: null == gitBackup ? _self.gitBackup : gitBackup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClaudeConfigCopyWith<$Res> get claude {
  
  return $ClaudeConfigCopyWith<$Res>(_self.claude, (value) {
    return _then(_self.copyWith(claude: value));
  });
}/// Create a copy of DeckConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionsConfigCopyWith<$Res> get actions {
  
  return $ActionsConfigCopyWith<$Res>(_self.actions, (value) {
    return _then(_self.copyWith(actions: value));
  });
}
}

// dart format on
