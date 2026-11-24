import 'package:freezed_annotation/freezed_annotation.dart';

part 'overview.freezed.dart';
part 'overview.g.dart';

/// One line of news about a project: a lasting fact from a Slack message or a
/// mail, or a merged merge request. Append only, in `state/projects/<id>/`.
@freezed
abstract class ProjectUpdate with _$ProjectUpdate {
  const factory ProjectUpdate({
    /// Unique per source: `slack:<id>`, `mail:<id>`, `gitlab:<path>!<iid>`.
    required String id,
    required DateTime at,
    required String provider,

    /// Where it came from: "#vpn-team", a sender, an MR author.
    required String source,
    required String text,
    String? url,

    /// When Deck logged it: what came after your last visit, or after the
    /// last Facts run, is new.
    DateTime? added,
  }) = _ProjectUpdate;

  factory ProjectUpdate.fromJson(Map<String, Object?> json) => _$ProjectUpdateFromJson(json);
}

/// A document linked to a project: a doc, a sheet, a dashboard, a design.
/// Found in Slack and mail, or added by you. In `state/projects/<id>/docs.json`.
@freezed
abstract class ProjectDoc with _$ProjectDoc {
  const factory ProjectDoc({
    /// The link, also the key: one entry per url.
    required String url,
    required String title,

    /// slack, mail, or you.
    required String provider,

    /// Where it was shared: "#vpn-team", a sender. Null when you added it.
    String? source,
    required DateTime at,

    /// You removed it: kept so the same message read again does not bring it back.
    @Default(false) bool removed,
  }) = _ProjectDoc;

  factory ProjectDoc.fromJson(Map<String, Object?> json) => _$ProjectDocFromJson(json);
}

/// Sections of the Facts list, in page order.
const factSections = {'release': 'Release', 'decisions': 'Decisions', 'people': 'People', 'questions': 'Open questions'};

/// One line of Facts, written by Claude from the updates, or by you.
@freezed
abstract class Fact with _$Fact {
  const factory Fact({
    /// A key of [factSections].
    required String section,
    required String text,

    /// Where it came from, as the update says ("#vpn-team, Nov 2").
    String? source,

    /// The value it replaced, shown as "(was ...)".
    String? was,

    /// The id of the update it came from: a click opens that update's link.
    String? ref,

    /// You wrote or changed it: Claude keeps it as it is.
    @Default(false) bool edited,
  }) = _Fact;

  factory Fact.fromJson(Map<String, Object?> json) => _$FactFromJson(json);
}

/// A project's Facts and the marks that go with them.
@freezed
abstract class Overview with _$Overview {
  const factory Overview({
    @Default([]) List<Fact> facts,

    /// Facts cover the updates up to this time.
    DateTime? factsUpTo,

    /// Your last visit of the page: newer updates are marked new.
    DateTime? seenAt,

    /// Merged merge requests are read up to this time.
    DateTime? mergedUpTo,
  }) = _Overview;

  factory Overview.fromJson(Map<String, Object?> json) => _$OverviewFromJson(json);
}
