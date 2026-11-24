// The feature map of a project, as Skim writes it in `.skim/map/`: one JSON
// file per feature and per data type, `index.json` for the last complete pass.
// Same shape as Skim's (packages/core/src/types.ts), so maps drawn by either
// tool read in both. Kinds stay strings: the files are the contract.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

const nodeStatuses = ['added', 'changed', 'removed', 'context'];
const edgeKinds = ['extends', 'implements', 'owns', 'uses', 'calls', 'creates'];
const stepMarks = ['touched', 'concern'];
const concernSeverities = ['high', 'medium', 'low'];
const linkKinds = ['calls', 'calledBy'];
const noteKinds = ['dead-code', 'platform', 'config', 'finding'];
const dataUses = ['sends', 'receives', 'reads', 'writes'];
const dataBoundaries = ['wire', 'storage', 'url', 'file'];
const violationSeverities = ['high', 'medium', 'low', 'accepted'];
const uiTokenKinds = ['color', 'type', 'spacing', 'radius', 'icon', 'other'];

/// A feature or data type id: a lowercase slug, also its file name.
final featureId = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');

@freezed
abstract class GraphNode with _$GraphNode {
  const factory GraphNode({
    /// The symbol as the code names it, unique in the graph.
    required String name,

    /// added, changed, removed or context. The map draws context only.
    @Default('context') String status,
    @Default('') String edited,
    @Default('') String role,
    String? path,
    int? line,

    /// The lane it runs in (clock, parent, cloud). Absent with one lane.
    String? side,

    /// The id of the feature this node is borrowed from.
    String? feature,
  }) = _GraphNode;

  factory GraphNode.fromJson(Map<String, Object?> json) => _$GraphNodeFromJson(json);
}

@freezed
abstract class GraphEdge with _$GraphEdge {
  const factory GraphEdge({required String from, required String to, required String kind, @Default('') String label}) = _GraphEdge;

  factory GraphEdge.fromJson(Map<String, Object?> json) => _$GraphEdgeFromJson(json);
}

@freezed
abstract class FeatureGraph with _$FeatureGraph {
  const factory FeatureGraph({@Default('') String caption, @Default([]) List<GraphNode> nodes, @Default([]) List<GraphEdge> edges}) = _FeatureGraph;

  factory FeatureGraph.fromJson(Map<String, Object?> json) => _$FeatureGraphFromJson(json);
}

/// The comment on one arrow of a sequence, in source order.
@freezed
abstract class DiagramStep with _$DiagramStep {
  const factory DiagramStep({
    required String title,
    @Default('') String detail,
    @Default('') String why,
    String? path,
    int? line,

    /// touched or concern.
    String? mark,

    /// high, medium or low, with mark concern only.
    String? severity,
  }) = _DiagramStep;

  factory DiagramStep.fromJson(Map<String, Object?> json) => _$DiagramStepFromJson(json);
}

@freezed
abstract class MapSequence with _$MapSequence {
  const factory MapSequence({
    /// The tab label. Empty reads as the main flow.
    @Default('') String title,

    /// mermaid sequenceDiagram source.
    required String mermaid,
    @Default('') String caption,
    @Default([]) List<DiagramStep> steps,
  }) = _MapSequence;

  factory MapSequence.fromJson(Map<String, Object?> json) => _$MapSequenceFromJson(json);
}

@freezed
abstract class MapTransition with _$MapTransition {
  const factory MapTransition({required String title, @Default('') String detail, String? path, int? line}) = _MapTransition;

  factory MapTransition.fromJson(Map<String, Object?> json) => _$MapTransitionFromJson(json);
}

@freezed
abstract class MapState with _$MapState {
  const factory MapState({
    required String title,
    @Default('') String caption,

    /// mermaid stateDiagram-v2 source.
    required String mermaid,
    @Default([]) List<MapTransition> transitions,
  }) = _MapState;

  factory MapState.fromJson(Map<String, Object?> json) => _$MapStateFromJson(json);
}

@freezed
abstract class MapLink with _$MapLink {
  const factory MapLink({required String feature, required String kind, @Default('') String detail, String? path, int? line}) = _MapLink;

  factory MapLink.fromJson(Map<String, Object?> json) => _$MapLinkFromJson(json);
}

@freezed
abstract class MapNote with _$MapNote {
  const factory MapNote({required String kind, required String text, String? path, int? line}) = _MapNote;

  factory MapNote.fromJson(Map<String, Object?> json) => _$MapNoteFromJson(json);
}

@freezed
abstract class MapDataUse with _$MapDataUse {
  const factory MapDataUse({required String type, required String use, @Default('') String detail}) = _MapDataUse;

  factory MapDataUse.fromJson(Map<String, Object?> json) => _$MapDataUseFromJson(json);
}

@freezed
abstract class MapFeature with _$MapFeature {
  const factory MapFeature({
    required String id,
    required String title,
    @Default('') String summary,
    FeatureGraph? graph,

    /// Files and folders that implement it. A change under one makes it stale.
    @Default([]) List<String> paths,

    /// The head it was drawn at.
    @Default('') String commit,
    @Default('') String updatedAt,
    @JsonKey(readValue: _readSequences) @Default([]) List<MapSequence> sequences,
    @Default([]) List<MapState> states,
    @Default([]) List<MapLink> links,
    @Default([]) List<MapNote> notes,
    @Default([]) List<MapDataUse> data,
  }) = _MapFeature;

  factory MapFeature.fromJson(Map<String, Object?> json) => _$MapFeatureFromJson(json);
}

/// A file written before a feature could have several flows holds one
/// `sequence`: it reads as a list of one.
Object? _readSequences(Map<dynamic, dynamic> json, String key) {
  final old = json['sequence'];
  return json[key] ??
      (old is Map
          ? [
              <String, Object?>{'title': '', ...old.cast<String, Object?>()},
            ]
          : null);
}

@freezed
abstract class MapDataField with _$MapDataField {
  const factory MapDataField({required String name, required String type, @Default('') String note, @Default(false) bool optional, @Default('') String since}) =
      _MapDataField;

  factory MapDataField.fromJson(Map<String, Object?> json) => _$MapDataFieldFromJson(json);
}

@freezed
abstract class MapDefinition with _$MapDefinition {
  const factory MapDefinition({required String path, int? line}) = _MapDefinition;

  factory MapDefinition.fromJson(Map<String, Object?> json) => _$MapDefinitionFromJson(json);
}

/// One type that crosses a boundary (wire, storage, url, file), written once
/// for the whole map.
@freezed
abstract class MapDataType with _$MapDataType {
  const factory MapDataType({
    required String id,
    required String name,
    required String boundary,
    @Default('') String summary,
    @Default([]) List<MapDataField> fields,
    @Default('') String since,
    @Default('') String until,
    @Default([]) List<MapDefinition> definitions,
    @Default('') String commit,
    @Default('') String updatedAt,
  }) = _MapDataType;

  factory MapDataType.fromJson(Map<String, Object?> json) => _$MapDataTypeFromJson(json);
}

/// One layer of the app, top first: what lives in it and how its classes
/// are named, so a class name says where it belongs.
@freezed
abstract class ArchLayer with _$ArchLayer {
  const factory ArchLayer({
    /// A slug the rules and violations point at: view, view-model.
    required String id,
    required String name,

    /// One sentence: what this layer does and what it must not do.
    @Default('') String role,

    /// Class name patterns of the layer: `*Screen`, `*ViewModel`, `*Manager`.
    @Default([]) List<String> naming,

    /// Folders or files where the layer lives.
    @Default([]) List<String> paths,

    /// A few real classes, as the code names them.
    @Default([]) List<String> examples,
  }) = _ArchLayer;

  factory ArchLayer.fromJson(Map<String, Object?> json) => _$ArchLayerFromJson(json);
}

/// A dependency the architecture allows: [from] may use [to].
@freezed
abstract class ArchFlow with _$ArchFlow {
  const factory ArchFlow({required String from, required String to, @Default('') String label}) = _ArchFlow;

  factory ArchFlow.fromJson(Map<String, Object?> json) => _$ArchFlowFromJson(json);
}

/// A place where the code breaks a rule of its own architecture.
@freezed
abstract class ArchViolation with _$ArchViolation {
  const factory ArchViolation({
    /// The class that breaks the rule, and its layer.
    required String from,
    required String fromLayer,

    /// What it reaches: one or more classes, and their layer.
    @Default([]) List<String> to,
    required String toLayer,

    /// high, medium, low, or accepted (a known, agreed exception).
    required String severity,

    /// One or two sentences: which rule, and what it costs.
    required String why,

    /// One line: what would fix it, when the docs or the code say.
    @Default('') String fix,
    String? path,
    int? line,
  }) = _ArchViolation;

  factory ArchViolation.fromJson(Map<String, Object?> json) => _$ArchViolationFromJson(json);
}

/// The app's architecture as its own docs describe it, checked against the
/// code: the layers top to bottom, the dependencies allowed between them,
/// and where the code does not follow. Deck's own `architecture.json` next
/// to the features; Skim does not read it.
@freezed
abstract class MapArchitecture with _$MapArchitecture {
  const factory MapArchitecture({
    /// Two or three sentences: the pattern (MVVM, clean, layered) and its main rule.
    @Default('') String summary,
    @Default([]) List<ArchLayer> layers,
    @Default([]) List<ArchFlow> flows,

    /// Rules in plain words that the layers and flows do not say.
    @Default([]) List<String> rules,
    @Default([]) List<ArchViolation> violations,

    /// The docs the rules come from, so the reader can check them.
    @Default([]) List<String> sources,
    @Default('') String commit,
    @Default('') String updatedAt,
  }) = _MapArchitecture;

  factory MapArchitecture.fromJson(Map<String, Object?> json) => _$MapArchitectureFromJson(json);
}

/// A design token of the UI: a color, a text style, a spacing step.
@freezed
abstract class UiToken with _$UiToken {
  const factory UiToken({
    /// color, type, spacing, radius, icon or other.
    required String kind,

    /// As the code names it: `c.label2`, `t.bodySmall`.
    required String name,
    @Default('') String note,
    String? path,
    int? line,
  }) = _UiToken;

  factory UiToken.fromJson(Map<String, Object?> json) => _$UiTokenFromJson(json);
}

/// A widget or a view built to be shared between screens.
@freezed
abstract class UiComponent with _$UiComponent {
  const factory UiComponent({required String name, @Default('') String role, String? path, int? line}) = _UiComponent;

  factory UiComponent.fromJson(Map<String, Object?> json) => _$UiComponentFromJson(json);
}

/// A screen, a page or a pane, and the shared components it uses.
@freezed
abstract class UiScreen with _$UiScreen {
  const factory UiScreen({required String name, @Default('') String role, String? path, int? line, @Default([]) List<String> uses}) = _UiScreen;

  factory UiScreen.fromJson(Map<String, Object?> json) => _$UiScreenFromJson(json);
}

/// One copy of a duplicated piece of UI.
@freezed
abstract class UiCopy with _$UiCopy {
  const factory UiCopy({required String name, String? path, int? line}) = _UiCopy;

  factory UiCopy.fromJson(Map<String, Object?> json) => _$UiCopyFromJson(json);
}

/// The same piece of UI built two or more times.
@freezed
abstract class UiDuplicate with _$UiDuplicate {
  const factory UiDuplicate({
    /// A few words: what is built twice.
    required String title,

    /// high, medium, low, or accepted (an agreed copy).
    required String severity,

    /// One or two sentences: how the copies differ, and what that costs.
    required String why,

    /// The shared component the copies should use, existing or to create.
    @Default('') String use,
    @Default([]) List<UiCopy> copies,
  }) = _UiDuplicate;

  factory UiDuplicate.fromJson(Map<String, Object?> json) => _$UiDuplicateFromJson(json);
}

/// A place where the UI breaks one of the project's UI rules.
@freezed
abstract class UiBreak with _$UiBreak {
  const factory UiBreak({
    /// The rule, in a few words.
    required String rule,
    required String severity,
    required String why,
    @Default('') String fix,

    /// The class it happens in.
    @Default('') String where,

    /// How many places break it the same way; [path] is one of them.
    @Default(1) int count,
    String? path,
    int? line,
  }) = _UiBreak;

  factory UiBreak.fromJson(Map<String, Object?> json) => _$UiBreakFromJson(json);
}

/// The app's UI checked against its own UI guidelines: the shared tokens and
/// components, the screens and what they use, the pieces built twice and
/// where the code breaks the rules. Deck's own `ui.json`; Skim does not read it.
@freezed
abstract class MapUi with _$MapUi {
  const factory MapUi({
    /// Two or three sentences: how the UI is built and its main rule.
    @Default('') String summary,
    @Default([]) List<String> rules,

    /// The docs and skills the rules come from.
    @Default([]) List<String> sources,

    /// The folders the UI lives in. A change under one makes it stale.
    @Default([]) List<String> paths,
    @Default([]) List<UiToken> tokens,
    @Default([]) List<UiComponent> components,
    @Default([]) List<UiScreen> screens,
    @Default([]) List<UiDuplicate> duplicates,
    @Default([]) List<UiBreak> breaks,
    @Default('') String commit,
    @Default('') String updatedAt,
  }) = _MapUi;

  factory MapUi.fromJson(Map<String, Object?> json) => _$MapUiFromJson(json);
}

@freezed
abstract class BrokenLink with _$BrokenLink {
  const factory BrokenLink({required String from, required String to}) = _BrokenLink;

  factory BrokenLink.fromJson(Map<String, Object?> json) => _$BrokenLinkFromJson(json);
}

/// The map with what changed in the repository since it was last stamped.
@freezed
abstract class FeatureMap with _$FeatureMap {
  const factory FeatureMap({
    required String root,

    /// The head of the last complete pass, null before the first one.
    String? commit,
    String? updatedAt,
    required String head,

    /// The stamped commit is gone (rebase, shallow clone): every feature is stale.
    @Default(false) bool commitMissing,
    @Default([]) List<MapFeature> features,
    @Default([]) List<String> changedFiles,
    @Default([]) List<String> staleFeatures,
    @Default([]) List<String> uncoveredFiles,
    @Default([]) List<BrokenLink> brokenLinks,
    @Default([]) List<MapDataType> dataTypes,
    @Default([]) List<String> staleData,

    /// The features the current pass said it would draw (Deck's `plan.json`),
    /// empty when no pass is under way.
    @Default([]) List<String> plan,

    /// The planned features not drawn or confirmed since the plan: what a
    /// stopped pass has left to do.
    @Default([]) List<String> planLeft,

    /// The layers and where the code breaks them, null until drawn.
    MapArchitecture? architecture,

    /// A file under a layer changed since the architecture was written.
    @Default(false) bool staleArchitecture,

    /// The UI checked against its guidelines, null until drawn.
    MapUi? ui,

    /// A file under the UI folders or its sources changed since it was written.
    @Default(false) bool staleUi,
  }) = _FeatureMap;

  factory FeatureMap.fromJson(Map<String, Object?> json) => _$FeatureMapFromJson(json);
}
