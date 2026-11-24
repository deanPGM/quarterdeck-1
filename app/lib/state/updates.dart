// Is a newer Quarterdeck out? Checked a minute after start and once a day,
// unless Settings > General turns it off. A local build (version 'dev') only
// checks when asked.
import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/updates.dart';
import '../sources/releases.dart';
import 'settings.dart';

export '../core/updates.dart' show Release, appVersion, isDevBuild;

enum UpdateStep { idle, checking, installing, failed }

class UpdateState {
  const UpdateState({this.current = appVersion, this.latest, this.step = UpdateStep.idle, this.checkedAt, this.error, this.dismissed = false});

  /// The running version: "0.1.0", or "dev".
  final String current;

  /// The latest release, once a check found one.
  final Release? latest;
  final UpdateStep step;
  final DateTime? checkedAt;

  /// Why the last check or update failed.
  final String? error;

  /// Later was clicked: the notice stays away until a newer release.
  final bool dismissed;

  /// Built from source: it never updates itself.
  bool get dev => current == 'dev';

  /// A release newer than this build.
  Release? get available => latest != null && isNewer(latest!.version, current) ? latest : null;

  /// The notice over every screen shows.
  bool get offer => available != null && !dismissed && step != UpdateStep.checking;

  UpdateState copyWith({Release? latest, UpdateStep? step, DateTime? checkedAt, String? error, bool clearError = false, bool? dismissed}) => UpdateState(
    current: current,
    latest: latest ?? this.latest,
    step: step ?? this.step,
    checkedAt: checkedAt ?? this.checkedAt,
    error: clearError ? null : error ?? this.error,
    dismissed: dismissed ?? this.dismissed,
  );
}

/// Fetches the latest release; tests and Widgetbook replace it.
final latestReleaseProvider = Provider<Future<Release?> Function()>((ref) => latestRelease);

final updatesProvider = NotifierProvider<Updates, UpdateState>(Updates.new);

class Updates extends Notifier<UpdateState> {
  @override
  UpdateState build() {
    if (!isDevBuild) {
      final first = Timer(const Duration(minutes: 1), _auto);
      final daily = Timer.periodic(const Duration(days: 1), (_) => _auto());
      ref.onDispose(() {
        first.cancel();
        daily.cancel();
      });
    }
    return const UpdateState();
  }

  Future<void> _auto() async {
    if ((await ref.read(settingsProvider.future)).checkUpdates) await check();
  }

  Future<void> check() async {
    if (state.step == UpdateStep.checking || state.step == UpdateStep.installing) return;
    final seen = state.available?.version;
    state = state.copyWith(step: UpdateStep.checking, clearError: true);
    try {
      final r = await ref.read(latestReleaseProvider)();
      // A newer release than the one dismissed is offered again.
      state = UpdateState(latest: r, checkedAt: clock.now(), dismissed: state.dismissed && r?.version == seen);
    } catch (e) {
      state = state.copyWith(step: UpdateStep.idle, error: _short(e));
    }
  }

  void dismiss() => state = state.copyWith(dismissed: true);

  /// Runs [update] (the install script, see actions/updater.dart). It quits
  /// this app when it works, so a return means it failed.
  Future<void> install(Future<int> Function(String version) update, {required String log}) async {
    final r = state.available;
    if (r == null || state.step == UpdateStep.installing) return;
    state = state.copyWith(step: UpdateStep.installing, clearError: true);
    try {
      final code = await update(r.version);
      state = state.copyWith(step: UpdateStep.failed, error: 'The update stopped (exit $code). Details in $log');
    } catch (e) {
      state = state.copyWith(step: UpdateStep.failed, error: _short(e));
    }
  }

  String _short(Object e) => '$e'.replaceFirst(RegExp(r'^\w*(Exception|Error): '), '');
}
