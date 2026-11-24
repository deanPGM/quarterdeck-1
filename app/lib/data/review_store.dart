// The reviews of each project: one JSON file per merge request in
// state/reviews/<project>/<id>.json, plus the rules every write follows
// (Skim's ReviewService, packages/core/src/review.ts): a path, a hunk or a
// ticket the diff does not have is refused, so the page never links to
// nothing, and a list written as a whole is checked before anything is kept.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

import '../core/map/models.dart';
import '../core/review/anchors.dart';
import '../core/review/diff.dart';
import '../core/review/publish_plan.dart';
import '../core/review/review.dart';
import '../core/review/tickets.dart';
import 'deck_home.dart';
import 'map_store.dart';
import 'review_git.dart';

/// A refusal the agent reads and fixes.
class ReviewError implements Exception {
  ReviewError(this.message);

  final String message;

  @override
  String toString() => message;
}

/// A fix with commits on top that need it: it leaves the branch only as a
/// revert commit, which the user is asked for.
class FixBuriedError extends ReviewError {
  FixBuriedError(super.message);
}

typedef Json = Map<String, Object?>;

class ReviewStore {
  ReviewStore(this.home);

  final DeckHome home;

  Directory _dir(String project) => Directory(p.join(home.state.path, 'reviews', project));
  File _file(String project, String id) => File(p.join(_dir(project).path, '$id.json'));

  Review? load(String project, String id) {
    final f = _file(project, id);
    if (!f.existsSync()) return null;
    try {
      return Review.fromJson(migrateReviewJson(jsonDecode(f.readAsStringSync()) as Json));
    } catch (_) {
      return null;
    }
  }

  List<Review> list(String project) {
    final d = _dir(project);
    if (!d.existsSync()) return [];
    return [for (final f in d.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) ?load(project, p.basenameWithoutExtension(f.path))]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> delete(String project, String id) async {
    final f = _file(project, id);
    if (f.existsSync()) await f.delete();
  }

  Future<void> save(Review r) => writeJson(_file(r.project, r.id), r.copyWith(updatedAt: DateTime.now().toUtc().toIso8601String()).toJson());
}

/// One review with its project folder: the diff it reads, the tickets it
/// names, and the checked writes.
class ReviewService {
  ReviewService(this.store, this.review, this.root);

  final ReviewStore store;
  Review review;

  /// The project folder, a git working tree.
  final String root;

  DiffSnapshot? _snap;
  String? _snapKey;

  Future<({String baseSha, String headSha})> shas() async {
    // A local checkout: its working tree, edits not committed yet included.
    final folder = review.folder;
    final headSha = folder != null && Directory(folder).existsSync() ? await worktreeHead(folder) : await revParse(root, review.headRef);
    // A bare base ref means three dot: diff from the merge base, like the MR.
    final baseSha = await mergeBase(root, review.baseRef, headSha);
    return (baseSha: baseSha, headSha: headSha);
  }

  Future<DiffSnapshot> snapshot() async {
    final s = await shas();
    final key = '${s.baseSha}..${s.headSha}';
    if (_snapKey != key) {
      _snap = await deriveSnapshot(root, s.baseSha, s.headSha, review.baseRef, review.headRef);
      _snapKey = key;
    }
    return _snap!;
  }

  /// The tickets the change names: branch, MR title and description, commits.
  Future<List<TicketRef>> ticketRefs() async {
    final s = await shas();
    final mr = review.mr;
    final sources = [
      mr?.sourceBranch.isNotEmpty ?? false ? mr!.sourceBranch : review.headRef,
      mr?.title ?? '',
      mr?.description ?? '',
      ...await commitMessages(root, s.baseSha, s.headSha),
    ];
    return ticketRefsFor(sources, loadSkimConfig(root), provider: mr?.provider, webUrl: mr?.url, projectPath: mr?.projectPath);
  }

  Future<void> _save(Review r) async {
    review = r;
    await store.save(r);
  }

  Future<Set<String>> _paths() async => {for (final f in (await snapshot()).files) f.path};

  void _known(Set<String> known, Iterable<String> paths) {
    for (final path in paths) {
      if (!known.contains(path)) throw ReviewError('Path not in diff: $path');
    }
  }

  static String _str(Object? v) => v is String ? v.trim() : '';
  static List<Json> _list(Object? v) => v is List
      ? [
          for (final e in v)
            if (e is Map) e.cast<String, Object?>(),
        ]
      : const [];
  static List<String> _strings(Object? v) => v is List
      ? [
          for (final e in v)
            if (e is String && e.trim().isNotEmpty) e.trim(),
        ]
      : const [];

  /// One note per file, replacing the one there. Batched: every note is
  /// checked before any is kept.
  Future<List<FileNote>> setFileNotes(List<Json> notes) async {
    final known = await _paths();
    final clean = [
      for (final n in notes)
        () {
          final path = _str(n['path']);
          _known(known, [path]);
          final summary = _str(n['summary']);
          if (summary.isEmpty) throw ReviewError('summary must not be empty ($path)');
          final tags = _strings(n['extra_tags'] ?? n['extraTags']);
          final clash = tags.where(fileTags.contains).toList();
          if (clash.isNotEmpty) throw ReviewError('extra_tags must not restate a classifier tag: ${clash.join(', ')}');
          return FileNote(path: path, summary: summary, extraTags: tags);
        }(),
    ];
    final byPath = {for (final n in review.fileNotes) n.path: n, for (final n in clean) n.path: n};
    await _save(review.copyWith(fileNotes: byPath.values.toList()));
    return clean;
  }

  Future<List<HunkNote>> setHunkNotes(List<Json> notes) async {
    final snap = await snapshot();
    final refs = {
      for (final f in snap.files)
        for (final h in f.hunks) h.ref: f.path,
    };
    final clean = [
      for (final n in notes)
        () {
          final ref = _str(n['hunk_ref'] ?? n['hunkRef']);
          final path = refs[ref];
          if (path == null) throw ReviewError('No hunk $ref in the diff: take hunk_ref from get_diff');
          final summary = _str(n['summary']);
          if (summary.isEmpty) throw ReviewError('summary must not be empty ($ref)');
          return HunkNote(path: path, hunkRef: ref, summary: summary);
        }(),
    ];
    final byRef = {for (final n in review.hunkNotes) n.hunkRef: n, for (final n in clean) n.hunkRef: n};
    await _save(review.copyWith(hunkNotes: byRef.values.toList()));
    return clean;
  }

  /// The whole reading order, replaced.
  Future<List<ReviewGroup>> setGroups(List<Json> groups) async {
    final known = await _paths();
    final clean = [
      for (final g in groups)
        () {
          final title = _str(g['title']);
          if (title.isEmpty) throw ReviewError('every group needs a title');
          final items = [
            for (final it in _list(g['items']))
              () {
                final path = _str(it['path']);
                _known(known, [path]);
                final ref = _str(it['hunk_ref'] ?? it['hunkRef']);
                return GroupItem(path: path, hunkRef: ref.isEmpty ? null : ref);
              }(),
          ];
          return ReviewGroup(title: title, overview: _str(g['overview']), items: items);
        }(),
    ];
    await _save(review.copyWith(groups: clean));
    return clean;
  }

  /// Every feature tab, replaced. Paths point into the diff.
  Future<List<ReviewFeature>> setFeatures(List<Json> features) async {
    final known = await _paths();
    Json place(Json x) {
      final path = _str(x['path']);
      if (path.isNotEmpty) _known(known, [path]);
      return {'path': path.isEmpty ? null : path, 'line': path.isNotEmpty && x['line'] is num ? (x['line'] as num).toInt() : null};
    }

    final clean = [
      for (final f in features)
        () {
          final title = _str(f['title']);
          if (title.isEmpty) throw ReviewError('every feature needs a title');
          FeatureGraph? graph;
          final g = f['graph'];
          if (g is Map) {
            final names = <String>{};
            final nodes = [
              for (final n in _list(g['nodes']))
                () {
                  final name = _str(n['name']);
                  if (name.isEmpty) throw ReviewError('every node needs a name');
                  if (!names.add(name)) throw ReviewError('node "$name" appears twice');
                  if (!nodeStatuses.contains(n['status']))
                    throw ReviewError('node status must be one of ${nodeStatuses.join(', ')}, got ${jsonEncode(n['status'])}');
                  if (n['feature'] != null) throw ReviewError('a node names another feature only in the feature map');
                  final side = _str(n['side']);
                  return GraphNode.fromJson({
                    'name': name,
                    'status': n['status'],
                    'edited': _str(n['edited']),
                    'role': _str(n['role']),
                    ...place(n),
                    if (side.isNotEmpty) 'side': side,
                  });
                }(),
            ];
            if (nodes.isEmpty) throw ReviewError('a graph needs at least one node');
            final edges = [
              for (final e in _list(g['edges']))
                () {
                  for (final end in [e['from'], e['to']]) {
                    if (!names.contains(_str(end))) throw ReviewError('edge end ${jsonEncode(end)} is not a node of the graph');
                  }
                  if (!edgeKinds.contains(e['kind'])) throw ReviewError('edge kind must be one of ${edgeKinds.join(', ')}, got ${jsonEncode(e['kind'])}');
                  return GraphEdge(from: _str(e['from']), to: _str(e['to']), kind: e['kind']! as String, label: _str(e['label']));
                }(),
            ];
            graph = FeatureGraph(caption: _str(g['caption']), nodes: nodes, edges: edges);
          }
          MapSequence? sequence;
          final q = f['sequence'];
          if (q is Map && _str(q['mermaid']).isNotEmpty) {
            final mermaid = q['mermaid']! as String;
            try {
              MapStore.checkSequence(mermaid);
            } on MapError catch (e) {
              throw ReviewError(e.message);
            }
            final steps = [
              for (final st in _list(q['steps']))
                () {
                  final t = _str(st['title']);
                  if (t.isEmpty) throw ReviewError('every step needs a title');
                  if (st['mark'] != null && !stepMarks.contains(st['mark'])) throw ReviewError('step mark must be one of ${stepMarks.join(', ')}');
                  if (st['severity'] != null && st['mark'] != 'concern') throw ReviewError('a step severity goes with mark concern');
                  return DiagramStep.fromJson({
                    'title': t,
                    'detail': _str(st['detail']),
                    'why': _str(st['why']),
                    ...place(st),
                    'mark': st['mark'],
                    'severity': st['severity'],
                  });
                }(),
            ];
            sequence = MapSequence(mermaid: mermaid, caption: _str(q['caption']), steps: steps);
          }
          return ReviewFeature(title: title, summary: _str(f['summary']), graph: graph, sequence: sequence);
        }(),
    ];
    await _save(review.copyWith(features: clean));
    return clean;
  }

  /// The triage, replaced. Each item carries the head it judged.
  Future<List<ChecklistItem>> setChecklist(List<Json> items) async {
    final snap = await snapshot();
    final known = {for (final f in snap.files) f.path};
    final clean = [
      for (final it in items)
        () {
          final text = _str(it['text']);
          if (text.isEmpty) throw ReviewError('every item needs a text');
          if (!checkStates.contains(it['state'])) throw ReviewError('item state must be one of ${checkStates.join(', ')}, got ${jsonEncode(it['state'])}');
          final paths = _strings(it['paths']);
          _known(known, paths);
          return ChecklistItem(text: text, evidence: _str(it['evidence']), paths: paths, state: it['state']! as String, headSha: snap.headSha);
        }(),
    ];
    await _save(review.copyWith(checklist: clean));
    return clean;
  }

  Future<void> _ticketOf(String ref) async {
    if (!(await ticketRefs()).any((t) => t.ref == ref)) throw ReviewError('$ref is not a ticket of this review');
  }

  /// The ticket text the session fetched with its own tools.
  Future<StoredTicket> setTicket(String ref, Json input) async {
    await _ticketOf(ref);
    final body = _str(input['body']);
    if (body.isEmpty) throw ReviewError('body must not be empty');
    final old = review.tickets.where((t) => t.ref == ref).firstOrNull;
    final t = StoredTicket(
      ref: ref,
      body: body,
      title: _str(input['title']).isEmpty ? old?.title : _str(input['title']),
      url: _str(input['url']).isEmpty ? old?.url : _str(input['url']),
    );
    await _save(review.copyWith(tickets: [...review.tickets.where((x) => x.ref != ref), t]));
    return t;
  }

  Future<TicketCheck> setTicketCheck(String ref, Json input) async {
    await _ticketOf(ref);
    if (!ticketVerdicts.contains(input['verdict'])) throw ReviewError('verdict must be one of ${ticketVerdicts.join(', ')}');
    final summary = _str(input['summary']);
    if (summary.isEmpty) throw ReviewError('summary must not be empty');
    final snap = await snapshot();
    final known = {for (final f in snap.files) f.path};
    final items = [
      for (final it in _list(input['items']))
        () {
          final text = _str(it['text']);
          if (text.isEmpty) throw ReviewError('every item needs a text');
          if (!ticketItemStates.contains(it['state']))
            throw ReviewError('item state must be one of ${ticketItemStates.join(', ')}, got ${jsonEncode(it['state'])}');
          final paths = _strings(it['paths']);
          _known(known, paths);
          return TicketCheckItem(text: text, state: it['state']! as String, paths: paths);
        }(),
    ];
    final check = TicketCheck(ref: ref, headSha: snap.headSha, verdict: input['verdict']! as String, summary: summary, items: items);
    await _save(review.copyWith(ticketChecks: [...review.ticketChecks.where((c) => c.ref != ref), check]));
    return check;
  }

  /// The reviewer marked [path] viewed (or not) at the current head.
  Future<void> setViewed(String path, bool viewed) async {
    final head = (await shas()).headSha;
    final v = {...review.viewed};
    viewed ? v[path] = head : v.remove(path);
    await _save(review.copyWith(viewed: v));
  }

  Future<void> setHiddenTags(List<String> tags) => _save(review.copyWith(hiddenTags: tags));

  Future<void> setSessionId(String id) => _save(review.copyWith(sessionId: id));

  // ---- threads (Skim's review.ts, ADR-0005) --------------------------------

  static String _now() => DateTime.now().toUtc().toIso8601String();

  static String newId() {
    final r = Random.secure();
    return List.generate(8, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }

  List<Thread> listThreads({String? state, String? path}) => [
    for (final t in review.threads)
      if ((state == null || t.state == state) && (path == null || t.anchor?.path == path)) t,
  ];

  Thread thread(String id) => review.threads.where((t) => t.id == id).firstOrNull ?? (throw ReviewError('Unknown thread: $id'));

  Future<Thread> _put(Thread t) async {
    final i = review.threads.indexWhere((x) => x.id == t.id);
    final list = [...review.threads];
    i < 0 ? list.add(t) : list[i] = t;
    await _save(review.copyWith(threads: list));
    return t;
  }

  Message _message(String author, String body, {String? suggestion, String? remoteId, String? at}) =>
      Message(id: newId(), author: author, body: body, suggestion: suggestion, remoteId: remoteId, createdAt: at ?? _now());

  /// Every thread starts local, not on the forge. An agent finding and a
  /// reviewer comment are what goes out: the answer, with no talk yet. A
  /// reviewer question for Claude ([askAgent]) is talk: it waits on Claude
  /// and nothing goes out until Claude writes an answer. Without path and
  /// line it is about the whole change.
  Future<Thread> addThread({
    String? path,
    int? line,
    int? endLine,
    String side = 'new',
    required String body,
    required String severity,
    required String author,
    String? suggestion,
    bool askAgent = false,
  }) async {
    if (!severities.contains(severity)) throw ReviewError('severity must be one of ${severities.join(', ')}');
    if (body.trim().isEmpty) throw ReviewError('body must not be empty');
    Anchor? anchor;
    if (path != null || line != null) {
      if (path == null || line == null) throw ReviewError('A thread needs both a path and a line, or neither');
      try {
        anchor = anchorFor(await snapshot(), path: path, line: line, side: side, endLine: endLine);
      } on AnchorError catch (e) {
        throw ReviewError(e.message);
      }
    }
    final now = _now();
    // Only the reviewer can ask the agent: an agent asking itself is never answered.
    final ask = askAgent && author == 'user';
    final m = _message(author, body.trim(), suggestion: suggestion, at: now);
    return _put(
      Thread(
        id: newId(),
        anchor: anchor,
        severity: severity,
        state: 'open',
        authorType: author,
        createdAt: now,
        updatedAt: now,
        messages: ask ? [m] : const [],
        answer: ask ? null : m,
        waiting: ask,
        // The reviewer's own comment is their call already.
        decision: !ask && author == 'user' ? 'accept' : null,
      ),
    );
  }

  /// Talk on a thread, never posted. The user's message waits on Claude,
  /// Claude's hands it back. Any state: a published thread is talked over
  /// before its next reply.
  Future<Thread> reply(String threadId, {required String body, required String author, String? suggestion}) async {
    final t = thread(threadId);
    if (body.trim().isEmpty) throw ReviewError('body must not be empty');
    final now = _now();
    return _put(
      t.copyWith(
        waiting: author == 'user',
        updatedAt: now,
        messages: [
          ...t.messages,
          _message(author, body.trim(), suggestion: suggestion, at: now),
        ],
      ),
    );
  }

  /// What the next publish posts on [threadId], once accepted. Empty:
  /// nothing. Claude's answer hands the thread back, like a reply, and asks
  /// for the user's call again; the user's own text is their call.
  Future<Thread> setAnswer(String threadId, {required String body, required String author, String? suggestion}) async {
    final t = thread(threadId);
    if (t.state == 'resolved') throw ReviewError('Thread $threadId is resolved: nothing more goes out on it');
    final text = body.trim();
    final now = _now();
    return _put(
      t.copyWith(
        updatedAt: now,
        waiting: author == 'agent' ? false : t.waiting,
        answer: text.isEmpty ? null : _message(author, text, suggestion: suggestion, at: now),
        // A decline reply was asked for to go out: it stays accepted.
        decision: text.isEmpty ? null : (author == 'user' || declined(t) ? 'accept' : null),
      ),
    );
  }

  /// You reject a reviewer's point on your own merge request: its fix (taken
  /// back already) is forgotten, and Claude is asked for the reply that says
  /// why. That reply is accepted, so the next publish posts it.
  Future<Thread> decline(String threadId) async {
    final t = thread(threadId);
    return _put(
      t.copyWith(
        // A reverted fix keeps its trail; one never pushed leaves no trace.
        fix: t.fixRevert == null ? null : t.fix,
        answer: null,
        decision: 'reject',
        waiting: true,
        updatedAt: _now(),
        messages: [
          ...t.messages,
          _message('user', declineNow, at: _now()),
        ],
      ),
    );
  }

  /// The user's call on the answer: accept, reject, or null to undecide.
  /// A fix commit follows the call: accepted, it goes on the reviewed
  /// branch; taken back before it is pushed, it leaves it again.
  ///
  /// With [defer] (Claude is working on the branch), an Accept only records
  /// the call and queues the fix: it goes on the branch at [applyQueued],
  /// so it never lands between Claude's commit and its mark_fixed. With
  /// [revert], a fix that cannot leave the branch is undone by a revert
  /// commit instead ([FixBuriedError] otherwise).
  Future<Thread> setDecision(String threadId, String? decision, {bool defer = false, bool revert = false}) async {
    var t = thread(threadId);
    if (decision != null && !decisions.contains(decision)) throw ReviewError('decision must be one of ${decisions.join(', ')}');
    if (decision == 'accept' && t.answer == null) throw ReviewError('Thread $threadId has nothing to post');
    final queue = _queued.putIfAbsent(_reviewKey, () => {})..remove(threadId);
    if (t.fix case final fix? when fix != 'uncommitted') {
      final status = (await fixStatuses())[t.id]?.state;
      if (decision == 'accept' && _needsPick(status)) {
        if (defer) {
          queue.add(threadId);
        } else {
          t = await _locked(() => _pick(t, fix));
        }
      }
      // A pushed fix is in the merge request: a Reject can only revert it.
      if ((decision != 'accept' && status == 'local') || (decision == 'reject' && status == 'pushed' && t.decision != 'reject')) {
        if (defer) throw ReviewError('Claude is changing ${review.headRef}: take this fix back once it is done.');
        t = await _locked(() => _unpick(t, fix, revert: revert));
      }
    }
    return _put(thread(threadId).copyWith(decision: decision, updatedAt: _now(), fix: t.fix, fixRevert: t.fixRevert, answer: t.answer));
  }

  /// Not on the branch, or undone there by a revert.
  static bool _needsPick(String? status) => status == 'pending' || status == 'gone' || status == 'dropped' || status == 'queued';

  /// Puts every fix accepted while Claude worked on the branch.
  Future<void> applyQueued() async {
    final ids = [...?_queued[_reviewKey]];
    for (final id in ids) {
      final t = thread(id);
      _queued[_reviewKey]!.remove(id);
      if (t.decision != 'accept' || t.fix == null || t.fix == 'uncommitted') continue;
      if (!_needsPick((await fixStatuses())[id]?.state)) continue;
      final picked = await _locked(() => _pick(t, t.fix!));
      await _put(thread(id).copyWith(fix: picked.fix, fixRevert: picked.fixRevert, answer: picked.answer, updatedAt: _now()));
    }
  }

  /// Fixes accepted while Claude worked, per review: they go on the branch
  /// when it is done. In memory: a session does not outlive the app.
  static final _queued = <String, Set<String>>{};

  String get _reviewKey => '$root|${review.project}|${review.id}';

  /// One write at a time on a branch, whichever review or call asks: an
  /// Accept's cherry pick and a mark_fixed never interleave.
  static final _branchLocks = <String, Future<void>>{};

  Future<T> _locked<T>(Future<T> Function() write) {
    final key = '$root|${review.headRef}';
    final before = _branchLocks[key] ?? Future<void>.value();
    final done = before.then((_) => write());
    _branchLocks[key] = done.then<void>((_) {}, onError: (_) {});
    return done;
  }

  /// Where the fix of [threadId] waits for the user's Accept.
  String _fixRef(String threadId) => 'refs/deck/fix/${review.id}/$threadId';

  /// Puts fix [fix] on the reviewed branch: a fast forward when the branch
  /// has not moved since, else a cherry pick, whose new sha replaces the old
  /// one in the answer. A fix undone by a revert is picked again on top.
  Future<Thread> _pick(Thread t, String fix) async {
    final head = await revParse(root, review.headRef);
    try {
      if (t.fixRevert == null && await revParse(root, '$fix^') == head) {
        await moveBranch(root, review.headRef, fix, head);
        return t;
      }
      final now = await cherryPick(root, review.headRef, fix);
      await setRef(root, _fixRef(t.id), now);
      final answer = t.answer?.copyWith(body: _resha(t.answer!.body, fix, now));
      return t.copyWith(fix: now, fixRevert: null, answer: answer);
    } on ProcessException catch (e) {
      throw ReviewError('The fix ${fix.substring(0, 8)} does not go on ${review.headRef}: ${e.message}');
    }
  }

  /// Takes fix [fix] back off the branch: the last commit simply goes; one
  /// with commits on top leaves with them replayed on its parent. When they
  /// do not apply without it, [revert] adds a commit that undoes it, else
  /// [FixBuriedError].
  Future<Thread> _unpick(Thread t, String fix, {bool revert = false}) async {
    if (await _drop(fix)) return t;
    if (!revert) {
      final remote = _remoteBranch == null ? null : 'refs/remotes/origin/$_remoteBranch';
      final pushed = remote != null && await _ancestor(fix, remote);
      throw FixBuriedError(
        pushed
            ? 'The fix ${fix.substring(0, 8)} is pushed already: only a revert commit can undo it.'
            : 'The fix ${fix.substring(0, 8)} cannot leave ${review.headRef}: the commits on top of it need it, or edits not committed are in the way. '
                  'A revert commit can undo it instead.',
      );
    }
    try {
      return t.copyWith(fixRevert: await revertOn(root, review.headRef, fix));
    } on ProcessException catch (e) {
      throw ReviewError('The fix ${fix.substring(0, 8)} cannot be reverted on ${review.headRef}: ${e.message}');
    }
  }

  /// Takes commit [fix] off the reviewed branch. The commits above it are
  /// replayed on its parent, and the fixes among them (Deck's cherry picks)
  /// follow their new shas. False, nothing moved, when they do not apply
  /// without it or the checkout is in the way. Never a pushed commit.
  Future<bool> _drop(String fix) async {
    final remote = _remoteBranch == null ? null : 'refs/remotes/origin/$_remoteBranch';
    if (remote != null && await _ancestor(fix, remote)) return false;
    final head = await revParse(root, review.headRef);
    final next = await tipWithout(root, review.headRef, fix);
    if (next == null) return false;
    final before = await commitsBetween(root, fix, head);
    try {
      await moveBranch(root, review.headRef, next, head);
    } on ProcessException {
      return false;
    }
    // The tip is what was replayed: nothing else moved the branch meanwhile.
    if (await revParse(root, review.headRef) != next) throw ReviewError('${review.headRef} moved while ${fix.substring(0, 8)} was taken off it');
    final after = await commitsBetween(root, await revParse(root, '$fix^'), next);
    final moved = {for (var i = 0; i < before.length; i++) before[i]: after[i]};
    for (final t in review.threads) {
      final to = moved[t.fix];
      final revertTo = moved[t.fixRevert];
      if (to == null && revertTo == null) continue;
      if (to != null) await setRef(root, _fixRef(t.id), to);
      await _put(
        t.copyWith(
          fix: to ?? t.fix,
          fixRevert: revertTo ?? t.fixRevert,
          answer: to == null ? t.answer : t.answer?.copyWith(body: _resha(t.answer!.body, t.fix!, to)),
        ),
      );
    }
    return true;
  }

  /// [body] with every short sha of [from] written as [to].
  static String _resha(String body, String from, String to) =>
      body.replaceAllMapped(RegExp(r'\b[0-9a-f]{7,40}\b'), (m) => from.startsWith(m[0]!) ? to.substring(0, m[0]!.length) : m[0]!);

  /// The reviewer owns the states. The agent may only dismiss its own
  /// finding before it is posted.
  Future<Thread> setThreadState(String id, String state, String actor) async {
    final t = thread(id);
    if (t.state == state) return t;
    if (!threadTransitions[t.state]!.contains(state)) throw ReviewError('Cannot move thread $id from ${t.state} to $state');
    if (state == 'published') throw ReviewError('Thread $id is published by a publish, not by hand');
    if (actor == 'agent' && !(state == 'dismissed' && t.authorType == 'agent')) {
      throw ReviewError('Agent cannot move thread $id from ${t.state} to $state: only the reviewer can');
    }
    return _put(t.copyWith(state: state, updatedAt: _now()));
  }

  /// The agent changed the code for [threadId] in the fix worktree. With
  /// [commit], it is committed on the reviewed head, after the review's
  /// base. It then leaves the branch for a ref of its own, until the user
  /// accepts the answer (see [setDecision]): the last commit simply goes, one
  /// with commits on top (an Accept landed between the commit and this call)
  /// leaves with them replayed on its parent. A pushed commit, or one the
  /// commits above need, stays: it is recorded as on the branch already,
  /// and a Reject reverts it. Without [commit], the change is left
  /// uncommitted. [body] is the answer that goes out, such as
  /// `Fixed in <sha>: ...`.
  Future<Thread> markFixed(String threadId, {required String body, String? commit}) async {
    final t = thread(threadId);
    if (t.state == 'resolved' || t.state == 'dismissed') throw ReviewError('Thread $threadId is ${t.state}: nothing to fix');
    String fix = 'uncommitted';
    if (commit != null) {
      await _followLocalBranch();
      try {
        fix = await revParse(root, commit);
      } on Object {
        throw ReviewError('Unknown commit: $commit');
      }
      if (!await isAncestor(root, fix, review.headRef)) {
        throw ReviewError('$commit is not on ${review.headRef}, the head this review shows. Commit the fix on the reviewed branch.');
      }
      if (await _ancestor(fix, review.baseRef)) throw ReviewError('$commit is part of ${review.baseRef}, not a fix made in this review.');
      final other = review.threads.where((x) => x.id != threadId && x.fix == fix).firstOrNull;
      if (other != null) throw ReviewError('$commit is the fix of thread ${other.id} already.');
      final f = fix;
      await _locked(() async {
        try {
          await setRef(root, _fixRef(threadId), f);
          if (await _drop(f)) {
            // Set aside: the branch tip is the fix's parent, or what was
            // above it replayed there.
            if (!await _ancestor(await revParse(root, '$f^'), review.headRef) || await _ancestor(f, review.headRef)) {
              throw ReviewError('The fix $commit is still on ${review.headRef} after it was taken off');
            }
          }
        } on ProcessException catch (e) {
          throw ReviewError('The fix $commit cannot be set aside: ${e.message}');
        }
      });
    }
    final now = _now();
    return _put(
      thread(threadId).copyWith(
        fix: fix,
        fixRevert: null,
        waiting: false,
        updatedAt: now,
        decision: null,
        answer: _message('agent', body.trim(), at: now),
      ),
    );
  }

  // ---- fixes --------------------------------------------------------------

  /// The branch on the forge fixes go to: the merge request's source branch,
  /// or for a local review with none, the same branch on origin.
  String? get _remoteBranch => review.mr?.sourceBranch.isNotEmpty ?? false
      ? review.mr!.sourceBranch
      : review.local
      ? review.headRef
      : null;

  /// Where each thread's fix stands: thread id to its status.
  Future<Map<String, FixStatus>> fixStatuses() async {
    final out = <String, FixStatus>{};
    final remote = _remoteBranch == null ? null : 'refs/remotes/origin/$_remoteBranch';
    for (final t in review.threads) {
      final fix = t.fix;
      if (fix == null) continue;
      if (fix == 'uncommitted') {
        out[t.id] = (state: 'uncommitted', sha: null);
        continue;
      }
      final on = await _ancestor(fix, review.headRef);
      final pushed = remote != null && await _ancestor(fix, remote);
      final reverted = t.fixRevert != null && await _ancestor(t.fixRevert!, review.headRef);
      final aside = switch (t.decision) {
        'accept' when _queued[_reviewKey]?.contains(t.id) ?? false => 'queued',
        'accept' => 'gone',
        'reject' => 'dropped',
        _ => 'pending',
      };
      out[t.id] = (state: reverted ? 'dropped' : (pushed ? 'pushed' : (on ? 'local' : aside)), sha: fix);
    }
    return out;
  }

  Future<bool> _ancestor(String a, String b) async {
    try {
      return await isAncestor(root, a, b);
    } on Object {
      return false;
    }
  }

  /// Thread id to the fix its answer names that is not on the forge yet:
  /// an answer saying "Fixed in abc" must not go out before abc does. With
  /// [pushing], the fixes on the branch count as pushed: the send pushes
  /// them first.
  Future<Map<String, String>> unpushedFixes({bool pushing = false}) async => {
    for (final MapEntry(:key, :value) in (await fixStatuses()).entries)
      if (value.state != 'pushed' && !(pushing && value.state == 'local') && review.threads.any((t) => t.id == key && goesOut(t)))
        key: value.sha ?? 'uncommitted',
  };

  /// Pushes the reviewed head to the merge request's source branch.
  Future<void> pushFixes(Map<String, String> env) async {
    final branch = _remoteBranch;
    if (branch == null) throw ReviewError('This review has no source branch to push to.');
    try {
      await pushBranch(root, review.headRef, branch, env);
    } on ProcessException catch (e) {
      throw ReviewError('Push refused: ${e.message}');
    }
  }

  // ---- remote linkage and rounds (publish and pull, forge neutral) --------

  /// The answer went out as a new discussion [remoteId]: it joins the
  /// posted messages under the reviewer's name, with its note id, so a later
  /// pull does not import it back.
  Future<Thread> setThreadRemoteId(String threadId, String remoteId, [String? firstNoteId]) {
    final t = thread(threadId);
    return _put(t.copyWith(remoteId: remoteId, updatedAt: _now(), answer: null, decision: null, messages: [...t.messages, ?_sent(t.answer, firstNoteId)]));
  }

  /// The answer went out as reply [noteId] on the thread's discussion.
  Future<Thread> setAnswerPosted(String threadId, String noteId) {
    final t = thread(threadId);
    return _put(t.copyWith(updatedAt: _now(), answer: null, decision: null, messages: [...t.messages, ?_sent(t.answer, noteId)]));
  }

  static Message? _sent(Message? answer, String? noteId) => answer?.copyWith(author: 'user', remoteId: noteId ?? '', createdAt: _now());

  Future<void> setDiffRefs(DiffRefs refs) async {
    if (review.mr != null) await _save(review.copyWith(mr: review.mr!.copyWith(diffRefs: refs)));
  }

  Round? get lastPublishedRound => review.rounds.where((r) => r.publishedAt != null).lastOrNull;

  /// The next round, on the current shas. An open round left by a failed
  /// publish is reused, not numbered past.
  Future<Round> openRound() async {
    final s = await shas();
    final last = review.rounds.lastOrNull;
    if (last != null && last.publishedAt == null) {
      final r = last.copyWith(baseSha: s.baseSha, headSha: s.headSha);
      await _save(review.copyWith(rounds: [...review.rounds.take(review.rounds.length - 1), r]));
      return r;
    }
    final r = Round(id: newId(), number: (last?.number ?? 0) + 1, baseSha: s.baseSha, headSha: s.headSha, createdAt: _now());
    await _save(review.copyWith(rounds: [...review.rounds, r]));
    return r;
  }

  Round _round(String id) => review.rounds.where((r) => r.id == id).firstOrNull ?? (throw ReviewError('Unknown round: $id'));

  /// Kept as soon as the summary is posted: a retry after a failed verdict
  /// must not post a second one.
  Future<void> setRoundSummaryNote(String roundId, String noteId) async {
    _round(roundId);
    await _save(review.copyWith(rounds: [for (final r in review.rounds) r.id == roundId ? r.copyWith(remoteNoteId: noteId) : r]));
  }

  /// Closes a round: verdict and time kept, every thread posted in it moves
  /// to published, except [exclude]. One that could not be posted keeps its
  /// answer for the next round. One write, so the verdict never goes
  /// without its threads.
  Future<Round> publishRound(String roundId, {required String verdict, String? remoteNoteId, Set<String> exclude = const {}}) async {
    final round = _round(roundId);
    if (round.publishedAt != null) throw ReviewError('Round ${round.number} is already published');
    if (!verdicts.contains(verdict)) throw ReviewError('Invalid verdict: $verdict');
    final now = _now();
    final closed = round.copyWith(verdict: verdict, publishedAt: now, remoteNoteId: remoteNoteId);
    await _save(
      review.copyWith(
        rounds: [for (final r in review.rounds) r.id == roundId ? closed : r],
        threads: [
          for (final t in review.threads)
            t.state == 'open' && t.remoteId != null && !exclude.contains(t.id) ? t.copyWith(state: 'published', roundId: roundId, updatedAt: now) : t,
        ],
      ),
    );
    return closed;
  }

  /// What a next round works on: the diff since the last published head,
  /// and the open threads mapped onto the current head (exact, moved,
  /// outdated, or general for a thread on the whole change).
  Future<({Round? since, DiffSnapshot? delta, String headSha, List<(Thread, String, Anchor?)> threads})> roundDelta() async {
    final current = await snapshot();
    final since = lastPublishedRound;
    final delta = since == null ? null : await deriveSnapshot(root, since.headSha, current.headSha, 'round ${since.number}', review.headRef);
    return (
      since: since,
      delta: delta,
      headSha: current.headSha,
      threads: [
        for (final t in review.threads)
          if (openThreadStates.contains(t.state))
            if (t.anchor case final a?)
              () {
                final r = reanchor(a, current);
                return (t, r.status, r.anchor);
              }()
            else
              (t, 'general', null),
      ],
    );
  }

  /// A discussion on the forge that is not here arrives published, written by remote.
  Future<Thread> importRemoteThread({Anchor? anchor, required String remoteId, required List<({String remoteId, String body, String? createdAt})> messages}) {
    final now = _now();
    return _put(
      Thread(
        id: newId(),
        anchor: anchor,
        severity: 'suggestion',
        state: 'published',
        authorType: 'remote',
        remoteId: remoteId,
        createdAt: now,
        updatedAt: now,
        messages: [for (final m in messages) _message('remote', m.body, remoteId: m.remoteId, at: m.createdAt ?? now)],
      ),
    );
  }

  /// Appends the forge notes not stored yet (by note id). Returns how many.
  Future<int> importRemoteMessages(String threadId, List<({String remoteId, String body, String? createdAt})> messages) async {
    final t = thread(threadId);
    final known = {for (final m in t.messages) ?m.remoteId};
    final fresh = messages.where((m) => !known.contains(m.remoteId)).toList();
    if (fresh.isEmpty) return 0;
    final now = _now();
    await _put(
      t.copyWith(
        updatedAt: now,
        messages: [
          ...t.messages,
          for (final m in fresh) _message('remote', m.body, remoteId: m.remoteId, at: m.createdAt ?? now),
        ],
      ),
    );
    return fresh.length;
  }

  /// Fast forwards `skim/mr-<iid>` to the local source branch. Never anything
  /// else: not a user branch, not a rewrite.
  Future<void> _followLocalBranch() async {
    final mr = review.mr;
    if (mr == null || mr.sourceBranch.isEmpty || !review.headRef.startsWith('skim/')) return;
    final String local;
    try {
      local = await revParse(root, 'refs/heads/${mr.sourceBranch}');
    } on Object {
      return;
    }
    final current = await revParse(root, review.headRef);
    if (local == current || !await isAncestor(root, current, local)) return;
    await updateRef(root, 'refs/heads/${review.headRef}', local, current);
  }
}
