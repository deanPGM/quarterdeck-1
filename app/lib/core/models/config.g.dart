// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderConfig _$ProviderConfigFromJson(Map<String, dynamic> json) => _ProviderConfig(
  enabled: json['enabled'] as bool? ?? true,
  access: $enumDecodeNullable(_$AccessEnumMap, json['access'], unknownValue: Access.cli) ?? Access.claude,
  options: (json['options'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)) ?? const {},
  projectsOnly: json['projectsOnly'] as bool? ?? false,
);

Map<String, dynamic> _$ProviderConfigToJson(_ProviderConfig instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'access': _$AccessEnumMap[instance.access]!,
  'options': instance.options,
  'projectsOnly': instance.projectsOnly,
};

const _$AccessEnumMap = {Access.cli: 'cli', Access.claude: 'claude'};

_ProjectConfig _$ProjectConfigFromJson(Map<String, dynamic> json) => _ProjectConfig(
  id: json['id'] as String,
  name: json['name'] as String,
  dir: json['dir'] as String?,
  repo: json['repo'] as String?,
  board: json['board'] as String?,
  channels: (json['channels'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  worktree: json['worktree'] as bool? ?? true,
  ide: json['ide'] as String?,
  browserProfile: json['browserProfile'] as String?,
  description: json['description'] as String?,
  aliases: (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  logo: json['logo'] as String?,
  platforms: (json['platforms'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  tech: json['tech'] as String?,
);

Map<String, dynamic> _$ProjectConfigToJson(_ProjectConfig instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dir': ?instance.dir,
  'repo': ?instance.repo,
  'board': ?instance.board,
  'channels': instance.channels,
  'worktree': instance.worktree,
  'ide': ?instance.ide,
  'browserProfile': ?instance.browserProfile,
  'description': ?instance.description,
  'aliases': instance.aliases,
  'logo': ?instance.logo,
  'platforms': instance.platforms,
  'tech': ?instance.tech,
};

_ClaudeConfig _$ClaudeConfigFromJson(Map<String, dynamic> json) => _ClaudeConfig(
  model: json['model'] as String? ?? 'haiku',
  codeModel: json['codeModel'] as String? ?? 'claude-opus-5-5',
  reviewSkills: (json['reviewSkills'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const ['code-review high'],
  allowedTools: (json['allowedTools'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  refreshMinutes: (json['refreshMinutes'] as num?)?.toInt() ?? 30,
  dailyBudgetUsd: (json['dailyBudgetUsd'] as num?)?.toDouble() ?? 1.0,
  askPermission: json['askPermission'] as bool? ?? true,
  collectRuns: json['collectRuns'] as bool? ?? false,
);

Map<String, dynamic> _$ClaudeConfigToJson(_ClaudeConfig instance) => <String, dynamic>{
  'model': instance.model,
  'codeModel': instance.codeModel,
  'reviewSkills': instance.reviewSkills,
  'allowedTools': instance.allowedTools,
  'refreshMinutes': instance.refreshMinutes,
  'dailyBudgetUsd': instance.dailyBudgetUsd,
  'askPermission': instance.askPermission,
  'collectRuns': instance.collectRuns,
};

_ActionsConfig _$ActionsConfigFromJson(Map<String, dynamic> json) => _ActionsConfig(
  ide: json['ide'] as String? ?? 'idea',
  terminal: json['terminal'] as String? ?? 'Deck',
  browserProfile: json['browserProfile'] as String?,
  terminalDock: json['terminalDock'] as String? ?? 'bottom',
  terminalRight: (json['terminalRight'] as num?)?.toDouble() ?? .3,
  terminalBottom: (json['terminalBottom'] as num?)?.toDouble() ?? .35,
  newTab: json['newTab'] as bool? ?? false,
  review: json['review'] as String? ?? 'claude "/skim-code:review {url}"',
  feedback:
      json['feedback'] as String? ??
      'claude "Read the open review threads on my merge request {url}. For each one, say in a line what you would change or answer. Then wait for my go."',
);

Map<String, dynamic> _$ActionsConfigToJson(_ActionsConfig instance) => <String, dynamic>{
  'ide': instance.ide,
  'terminal': instance.terminal,
  'browserProfile': ?instance.browserProfile,
  'terminalDock': instance.terminalDock,
  'terminalRight': instance.terminalRight,
  'terminalBottom': instance.terminalBottom,
  'newTab': instance.newTab,
  'review': instance.review,
  'feedback': instance.feedback,
};

_DeckConfig _$DeckConfigFromJson(Map<String, dynamic> json) => _DeckConfig(
  providers: (json['providers'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, ProviderConfig.fromJson(e as Map<String, dynamic>))) ?? const {},
  projects: (json['projects'] as List<dynamic>?)?.map((e) => ProjectConfig.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  claude: json['claude'] == null ? const ClaudeConfig() : ClaudeConfig.fromJson(json['claude'] as Map<String, dynamic>),
  actions: json['actions'] == null ? const ActionsConfig() : ActionsConfig.fromJson(json['actions'] as Map<String, dynamic>),
  gitBackup: json['gitBackup'] as bool? ?? true,
  checkUpdates: json['checkUpdates'] as bool? ?? true,
);

Map<String, dynamic> _$DeckConfigToJson(_DeckConfig instance) => <String, dynamic>{
  'providers': instance.providers.map((k, e) => MapEntry(k, e.toJson())),
  'projects': instance.projects.map((e) => e.toJson()).toList(),
  'claude': instance.claude.toJson(),
  'actions': instance.actions.toJson(),
  'gitBackup': instance.gitBackup,
  'checkUpdates': instance.checkUpdates,
};
