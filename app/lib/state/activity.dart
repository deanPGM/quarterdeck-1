// The activity log and its saved summary for the period on screen. Read again
// each time the Activity view opens a period.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../claude/summary.dart';
import '../core/activity_view.dart';
import '../core/models/activity.dart';
import '../data/activity_store.dart';
import 'settings.dart';

final activityProvider = FutureProvider.autoDispose.family<List<Activity>, (DateTime, DateTime)>(
  (ref, r) => ActivityStore(ref.watch(homeProvider)).read(r.$1, r.$2),
);

final activitySummaryProvider = AsyncNotifierProvider.autoDispose.family<ActivitySummaryNotifier, ActivitySummary?, (Period, DateTime)>(
  ActivitySummaryNotifier.new,
);

class ActivitySummaryNotifier extends AsyncNotifier<ActivitySummary?> {
  ActivitySummaryNotifier(this.key);

  final (Period, DateTime) key;

  @override
  Future<ActivitySummary?> build() => readSummary(ref.watch(homeProvider), key.$1, key.$2);

  /// Has Claude write the summary of [lines], with [waiting] (cards that wait
  /// on others) as questions for the daily. Throws with a short message when
  /// Claude fails, and keeps the summary there was.
  Future<void> write(List<Activity> lines, String label, {List<String> waiting = const []}) async {
    final cfg = await ref.read(settingsProvider.future);
    state = AsyncData(await writeSummary(ref.read(homeProvider), key.$1, key.$2, label, lines, cfg.claude.model, projects: cfg.projects, waiting: waiting));
  }
}
