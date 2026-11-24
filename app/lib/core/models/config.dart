// deck.json: everything the Settings window edits.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';
part 'config.g.dart';

/// How Deck reaches a provider: it runs a command line tool itself (glab, gh:
/// no model, no tokens), or the background Claude session fetches it with its own
/// tools.
enum Access { cli, claude }

@freezed
abstract class ProviderConfig with _$ProviderConfig {
  const factory ProviderConfig({
    @Default(true) bool enabled,
    // An old "mcp" value reads as cli.
    @JsonKey(unknownEnumValue: Access.cli) @Default(Access.claude) Access access,

    /// Provider specific settings (Jira escalation type, Slack queries...).
    @Default({}) Map<String, String> options,
  }) = _ProviderConfig;

  factory ProviderConfig.fromJson(Map<String, Object?> json) => _$ProviderConfigFromJson(json);
}

/// A folder you work in, and where its work comes from.
@freezed
abstract class ProjectConfig with _$ProjectConfig {
  const factory ProjectConfig({
    required String id,
    required String name,
    String? dir,

    /// "gitlab:group/project" or "github:owner/repo".
    String? repo,

    /// "jira:KEY", "gitlab:group/project" or "github:owner/repo".
    String? board,
    @Default([]) List<String> channels,

    /// Start ticket work in a git worktree.
    @Default(true) bool worktree,

    /// IDE command for this project. Null uses the one in Actions.
    String? ide,

    /// Chrome profile folder ("Profile 2") its links open in. Null uses the
    /// one in Actions.
    String? browserProfile,

    /// What the project is, in a sentence. Written by the project info run,
    /// editable.
    String? description,

    /// Other names messages use for it: app and store names, bundle ids,
    /// ticket prefixes. Claude tags Slack and mail with them.
    @Default([]) List<String> aliases,

    /// The app icon: a file in the Deck state folder, `projects/<id>-<time>.png`.
    String? logo,

    /// Where it runs, from [platforms]: a badge on the logo tells two apps of
    /// one product apart.
    @Default([]) List<String> platforms,

    /// Languages, frameworks and tools, in a few words: "Swift, SwiftUI, Xcode".
    String? tech,
  }) = _ProjectConfig;

  factory ProjectConfig.fromJson(Map<String, Object?> json) => _$ProjectConfigFromJson(json);
}

@freezed
abstract class ClaudeConfig with _$ClaudeConfig {
  const factory ClaudeConfig({
    /// Pulling data: the background runs that read Jira, Slack and mail.
    @Default('haiku') String model,

    /// Code: project maps and reviews, which read the whole repository.
    @Default('claude-opus-5-5') String codeModel,

    /// The skills a review runs to find issues, each with its arguments:
    /// "code-review high", "ponytail:ponytail-review". Deck adds the range.
    @Default(['code-review high']) List<String> reviewSkills,

    /// Tool rules every background session may use without asking, in
    /// Claude Code syntax: "Bash(npm test:*)", "mcp__server__tool".
    @Default([]) List<String> allowedTools,
    @Default(30) int refreshMinutes,

    /// Background runs stop for the day once this is spent.
    @Default(1.0) double dailyBudgetUsd,

    /// Ask before a background session uses a tool it was not given.
    @Default(true) bool askPermission,

    /// Keep the run ledger, raw logs and issues sessions report, for the
    /// deck-insights skill. Off: nothing is written, sessions get no
    /// deck_report_issue.
    @Default(false) bool collectRuns,
  }) = _ClaudeConfig;

  factory ClaudeConfig.fromJson(Map<String, Object?> json) => _$ClaudeConfigFromJson(json);
}

@freezed
abstract class ActionsConfig with _$ActionsConfig {
  const factory ActionsConfig({
    @Default('idea') String ide,

    /// 'Deck' runs sessions in a panel of the app; 'Terminal' and 'iTerm'
    /// open an outside window.
    @Default('Deck') String terminal,

    /// Chrome profile folder links open in when no project picks one. Null
    /// uses the default browser.
    String? browserProfile,

    /// Where the Deck terminal panel sits: 'bottom' or 'right'.
    @Default('bottom') String terminalDock,

    /// Share of the window the panel takes, docked on the right and at the
    /// bottom. Dragging its edge changes it, and it stays for next time.
    @Default(.3) double terminalRight,
    @Default(.35) double terminalBottom,

    /// Open sessions as a tab of the front window: iTerm and Windows Terminal
    /// only. Terminal.app has no tab command, so it always opens a window.
    @Default(false) bool newTab,
    @Default('claude "/skim-code:review {url}"') String review,

    /// Your own merge request, once reviewers left threads for you.
    @Default(
      'claude "Read the open review threads on my merge request {url}. For each one, say in a line what you would change or answer. Then wait for my go."',
    )
    String feedback,
  }) = _ActionsConfig;

  factory ActionsConfig.fromJson(Map<String, Object?> json) => _$ActionsConfigFromJson(json);
}

@freezed
abstract class DeckConfig with _$DeckConfig {
  const factory DeckConfig({
    @Default({}) Map<String, ProviderConfig> providers,
    @Default([]) List<ProjectConfig> projects,
    @Default(ClaudeConfig()) ClaudeConfig claude,
    @Default(ActionsConfig()) ActionsConfig actions,

    /// Commit state changes to the git repo in the Deck folder.
    @Default(true) bool gitBackup,

    /// Look for a newer release on GitHub at start and once a day.
    @Default(true) bool checkUpdates,
  }) = _DeckConfig;

  factory DeckConfig.fromJson(Map<String, Object?> json) => _$DeckConfigFromJson(json);
}
