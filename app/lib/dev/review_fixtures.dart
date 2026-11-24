// A made up review for golden tests and Widgetbook: the garden sample diffs
// with what a review session writes over them.
import 'package:deck/core/map/models.dart';
import 'package:deck/core/review/anchors.dart';
import 'package:deck/core/review/diff.dart';
import 'package:deck/core/review/review.dart';
import 'package:deck/dev/review_samples.dart';
import 'package:deck/sources/mr_review.dart';

const sampleHead = 'c0ffee00c0ffee00c0ffee00c0ffee00c0ffee00';

DiffSnapshot sampleReviewDiff() {
  final files = [
    ...sampleDiffFiles,
    samplePatch('pubspec.lock', '@@ -1 +1 @@\n-a: 1\n+a: 2', tags: ['lockfile']),
  ];
  return DiffSnapshot(baseSha: 'b' * 40, headSha: sampleHead, baseRef: 'origin/main', headRef: 'skim/mr-412', files: files);
}

Review sampleReview() {
  final snap = sampleReviewDiff();
  String ref(String key) {
    final [path, i] = key.split('#');
    return snap.files.firstWhere((f) => f.path == path).hunks[int.parse(i)].ref;
  }

  return Review(
    id: 'gitlab-412',
    project: 'vpn-ios',
    baseRef: 'origin/main',
    headRef: 'skim/mr-412',
    mr: const MrSource(
      provider: 'gitlab',
      url: 'https://gitlab.com/acme/vpn-ios/-/merge_requests/412',
      iid: 412,
      projectPath: 'acme/vpn-ios',
      title: 'Skip watering when rain is expected',
      description:
          'Closes GARDEN-31.\n\n- The watering service reads the forecast first\n- Plant cards open the plant page\n- The schedule repository sorts slots',
      author: 'robin',
      sourceBranch: 'feat/GARDEN-31-rain',
      targetBranch: 'main',
    ),
    fileNotes: [
      for (final MapEntry(key: path, value: s) in sampleFileNotes.entries)
        FileNote(path: path, summary: s, extraTags: path.endsWith('units.dart') ? ['typo'] : const []),
    ],
    hunkNotes: [for (final MapEntry(key: k, value: s) in sampleHunkNotes.entries) HunkNote(path: k.split('#').first, hunkRef: ref(k), summary: s)],
    groups: const [
      ReviewGroup(
        title: 'Rain check',
        overview: 'The watering service asks the forecast before it opens a valve. GARDEN-31.',
        items: [GroupItem(path: 'lib/garden/watering_service.dart')],
      ),
      ReviewGroup(
        title: 'Schedule',
        overview: 'Slots come back sorted and a bed delete removes its links. Not in the ticket.',
        items: [GroupItem(path: 'lib/garden/schedule_repository.dart')],
      ),
      ReviewGroup(
        title: 'Glue',
        overview: 'The card tap, a renamed constant and a new icon.',
        items: [
          GroupItem(path: 'lib/garden/plant_card.dart'),
          GroupItem(path: 'lib/garden/units.dart'),
          GroupItem(path: 'assets/icons/rain.png'),
        ],
      ),
    ],
    features: const [
      ReviewFeature(
        title: 'Rain check',
        summary: 'Watering is skipped when the forecast says rain within six hours.',
        graph: FeatureGraph(
          nodes: [
            GraphNode(
              name: 'WateringService',
              status: 'changed',
              edited: 'Asks the forecast before opening a valve.',
              path: 'lib/garden/watering_service.dart',
              line: 12,
            ),
            GraphNode(name: 'Forecast', status: 'context', role: 'Hourly rain forecast.'),
          ],
          edges: [GraphEdge(from: 'WateringService', to: 'Forecast', kind: 'uses', label: 'rainWithin(6 h)')],
        ),
      ),
    ],
    checklist: const [
      ChecklistItem(
        text: 'tests for the rain check',
        state: 'concern',
        evidence: 'No test covers rainWithin.',
        paths: ['lib/garden/watering_service.dart'],
        headSha: sampleHead,
      ),
      ChecklistItem(text: 'migration', state: 'ok', evidence: 'No schema change.', headSha: sampleHead),
    ],
    ticketChecks: const [
      TicketCheck(
        ref: 'GARDEN-31',
        headSha: sampleHead,
        verdict: 'partial',
        summary: 'Does what GARDEN-31 asks, except the setting to turn the rain check off.',
        items: [
          TicketCheckItem(text: 'Skip watering when rain is expected', state: 'done', paths: ['lib/garden/watering_service.dart']),
          TicketCheckItem(text: 'A setting to turn it off', state: 'missing'),
          TicketCheckItem(text: 'Schedule slots sorted', state: 'extra', paths: ['lib/garden/schedule_repository.dart']),
        ],
      ),
    ],
    viewed: const {'lib/garden/units.dart': sampleHead},
    threads: sampleThreads(snap),
  );
}

/// Claude's findings, the talk about them and what goes out, over the
/// schedule file: one finding talked over, one waiting on Claude, the
/// reviewer's own comment, one about the whole change, one rejected, and one
/// already on the merge request with the author's answer and the next reply.
List<Thread> sampleThreads(DiffSnapshot snap) {
  const path = 'lib/garden/schedule_repository.dart', at = '2026-10-19T09:00:00Z', later = '2026-10-19T09:05:00Z';
  Anchor on(int line, [int? end]) => anchorFor(snap, path: path, line: line, endLine: end);
  Message m(String id, String author, String body, {String? suggestion, String? remoteId, String createdAt = at}) =>
      Message(id: id, author: author, body: body, suggestion: suggestion, remoteId: remoteId, createdAt: createdAt);
  return [
    Thread(
      id: 't1',
      anchor: on(30, 31),
      severity: 'must-fix',
      state: 'open',
      authorType: 'agent',
      messages: [
        m('m2', 'user', 'Is a crash between the two really possible here?'),
        m('m3', 'agent', 'Yes: `remove` awaits the first delete, so an app kill in between keeps the slot row. `byId` then returns a slot with no beds.'),
      ],
      answer: m(
        'm1',
        'agent',
        'The two deletes are not in a transaction: a crash between them leaves a slot with no beds, and `byId` still returns it.',
        suggestion: "  Future<void> remove(int id) => db.transaction((tx) async {\n    await tx.delete('slot_beds', where: 'slot_id = ?', whereArgs: [id]);\n    await tx.delete('slots', where: 'id = ?', whereArgs: [id]);\n  });",
        createdAt: later,
      ),
    ),
    Thread(
      id: 't2',
      anchor: on(56),
      severity: 'suggestion',
      state: 'open',
      authorType: 'agent',
      waiting: true,
      messages: [m('m5', 'user', 'Example?', createdAt: later)],
      answer: m('m4', 'agent', 'A slot already running is skipped too, so holiday mode leaves it where it was.'),
    ),
    Thread(
      id: 't3',
      anchor: on(23),
      severity: 'nit',
      state: 'open',
      authorType: 'user',
      decision: 'accept',
      answer: m('m6', 'user', 'Say "start time", the column name means nothing to a reader.'),
    ),
    Thread(
      id: 't4',
      severity: 'question',
      state: 'open',
      authorType: 'agent',
      decision: 'accept',
      answer: m('m7', 'agent', 'No test covers `between` or `shiftBed`. Is that planned in a follow up?'),
    ),
    Thread(id: 't5', anchor: on(42), severity: 'nit', state: 'dismissed', authorType: 'agent', answer: m('m8', 'agent', 'The table name could be a constant.')),
    Thread(
      id: 't6',
      anchor: on(24),
      severity: 'question',
      state: 'published',
      authorType: 'agent',
      remoteId: 'd6',
      messages: [
        m('m9', 'user', 'Why a list and not a set? Two slots can share a start.', remoteId: 'n1'),
        m('m10', 'remote', '**@maya**\n\nSorted output is what the screen needs, and duplicates are allowed.', remoteId: 'n2', createdAt: later),
        m('m11', 'user', 'Is she right about duplicates?', createdAt: later),
        m('m12', 'agent', 'Yes. `add` has no unique check and the table has no unique index on `start`.', createdAt: later),
      ],
      answer: m('m13', 'agent', 'Makes sense, thanks. Resolving.', createdAt: later),
    ),
  ];
}

const sampleMrStatus = MrStatus(state: 'open', pipeline: 'success', blockers: ['not approved']);
