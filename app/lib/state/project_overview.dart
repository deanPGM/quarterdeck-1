// A project's Overview: updates from Slack, mail and merged merge requests,
// and the Facts Claude keeps from them. Visiting the page reads the merged
// merge requests and rewrites Facts from what is new.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../claude/facts.dart';
import '../core/models/overview.dart';
import '../data/overview_store.dart';
import 'forges.dart';
import 'settings.dart';

part 'project_overview.g.dart';

@Riverpod(keepAlive: true)
OverviewStore overviewStore(Ref ref) => OverviewStore(ref.watch(homeProvider));

/// What the page shows. [lastSeen] is the visit before this one.
typedef OverviewView = ({Overview overview, List<ProjectUpdate> updates, List<ProjectDoc> docs, DateTime? lastSeen, bool writing, String? error});

/// Updates logged after [seen].
int newSince(List<ProjectUpdate> updates, DateTime? seen) => updates.where((u) => seen == null || (u.added ?? u.at).isAfter(seen)).length;

/// New updates since your last visit, for the sidebars.
@riverpod
Future<int> projectNewCount(Ref ref, String id) async {
  final store = ref.watch(overviewStoreProvider);
  return newSince(await store.updates(id), (await store.read(id)).seenAt);
}

@riverpod
class ProjectOverviewState extends _$ProjectOverviewState {
  OverviewStore get _store => ref.read(overviewStoreProvider);

  @override
  Future<OverviewView> build(String id) async {
    final o = await _store.read(id);
    return (overview: o, updates: await _store.updates(id), docs: await _docs(), lastSeen: o.seenAt, writing: false, error: null);
  }

  void _put(OverviewView v) => state = AsyncData(v);

  /// The documents still shown, newest first.
  Future<List<ProjectDoc>> _docs() async => [
    for (final d in await _store.docs(id))
      if (!d.removed) d,
  ];

  /// The page opened: marks the visit, reads merged merge requests, then
  /// rewrites Facts when updates came in since the last run.
  Future<void> visit() async {
    final s = await future;
    if (s.writing) return;
    final cfg = await ref.read(settingsProvider.future);
    final project = cfg.projects.where((p) => p.id == id).firstOrNull;
    if (project == null) return;
    final now = DateTime.now();
    var o = s.overview.copyWith(seenAt: now);
    await _store.write(id, o);
    ref.invalidate(projectNewCountProvider(id));
    _put((overview: o, updates: s.updates, docs: s.docs, lastSeen: s.overview.seenAt, writing: true, error: null));
    String? error;
    try {
      if (project.repo case final r? when r.startsWith('gitlab:')) {
        final path = r.substring('gitlab:'.length);
        final merged = await ref.read(gitlabSourceProvider).merged(path, o.mergedUpTo ?? now.subtract(const Duration(days: 14)));
        await _store.add(id, [
          for (final m in merged)
            ProjectUpdate(id: 'gitlab:$path!${m.iid}', at: m.at, provider: 'gitlab', source: m.author, text: 'Merged !${m.iid}: ${m.title}', url: m.url),
        ]);
        o = o.copyWith(mergedUpTo: now);
      }
    } catch (e) {
      error = 'Could not read merged merge requests: $e';
    }
    final updates = await _store.updates(id);
    final fresh = [
      for (final u in updates.reversed)
        if (o.factsUpTo == null || (u.added ?? u.at).isAfter(o.factsUpTo!)) u,
    ];
    if (fresh.isNotEmpty) {
      _put((overview: o, updates: updates, docs: s.docs, lastSeen: s.overview.seenAt, writing: true, error: error));
      try {
        final facts = await writeFacts(ref.read(homeProvider), project.name, o.facts, fresh, cfg.claude.model);
        o = o.copyWith(facts: facts, factsUpTo: now);
      } catch (e) {
        error = 'Could not update the facts: $e';
      }
    }
    await _store.write(id, o);
    _put((overview: o, updates: updates, docs: s.docs, lastSeen: s.overview.seenAt, writing: false, error: error));
  }

  /// Changes fact [i] to [text], or drops it when [text] is empty. Claude
  /// keeps an edited fact as it is.
  Future<void> editFact(int i, String text) async {
    final s = await future;
    final facts = [...s.overview.facts];
    if (text.trim().isEmpty) {
      facts.removeAt(i);
    } else {
      facts[i] = facts[i].copyWith(text: text.trim(), edited: true);
    }
    final o = s.overview.copyWith(facts: facts);
    await _store.write(id, o);
    _put((overview: o, updates: s.updates, docs: s.docs, lastSeen: s.lastSeen, writing: s.writing, error: s.error));
  }

  /// Adds a link you paste, under Documents. A removed one comes back.
  Future<void> addDoc(String url, String title) async {
    await _store.addDocs(id, [ProjectDoc(url: url.trim(), title: title.trim(), provider: 'you', at: DateTime.now())], force: true);
    final s = await future;
    _put((overview: s.overview, updates: s.updates, docs: await _docs(), lastSeen: s.lastSeen, writing: s.writing, error: s.error));
  }

  /// Hides the document at [url].
  Future<void> removeDoc(String url) async {
    await _store.removeDoc(id, url);
    final s = await future;
    _put((overview: s.overview, updates: s.updates, docs: await _docs(), lastSeen: s.lastSeen, writing: s.writing, error: s.error));
  }
}
