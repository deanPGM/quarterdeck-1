// Fetches on launch when the board is old, then every refreshMinutes. Lives as
// long as the app: opening the board again (back from Settings) fetches nothing.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'board.dart';
import 'settings.dart';

final autoRefreshProvider = FutureProvider<void>((ref) async {
  final cfg = await ref.read(settingsProvider.future);
  final board = await ref.read(boardProvider.future);
  final ats = board.snapshots.entries.where((e) => e.key != 'todo').map((e) => e.value.at);
  final stale = ats.isEmpty || ats.any((a) => a == null || DateTime.now().difference(a).inMinutes >= 5);
  if (stale && cfg.providers.isNotEmpty) unawaited(ref.read(boardProvider.notifier).refresh());
  final timer = Timer.periodic(Duration(minutes: cfg.claude.refreshMinutes), (_) => ref.read(boardProvider.notifier).refresh());
  ref.onDispose(timer.cancel);
});
