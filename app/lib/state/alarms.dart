// Rings before meetings you accepted. Deck plays the chime itself, in a loop,
// until you stop it or join (a Focus mode mutes notification sounds), brings
// its window to the front, and shows a notification that joins on click.
// Timers are set again whenever the board changes. The calendar is fetched
// again before each alarm, so a moved meeting rings at its new time.
import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_notifier/local_notifier.dart';

import '../core/meetings.dart';
import '../core/models/records.dart';
import '../sources/chrome.dart';
import 'board.dart';
import 'notices.dart';
import 'settings.dart';

/// Rings stop by themselves after this, in case you are away.
const ringFor = Duration(minutes: 2);

final alarmsProvider = Provider<void>((ref) {
  final board = ref.watch(boardProvider).value;
  final cfg = ref.watch(settingsProvider).value;
  if (board == null || cfg == null || cfg.providers['calendar']?.enabled != true) return;
  final lead = alarmLead(cfg.providers['calendar']!.options['alarmMinutes']);
  final now = clock.now();
  final rung = ref.read(ringingProvider.notifier).rung;
  final events = board.snapshots['calendar']?.events ?? const <EventRecord>[];
  final timers = [
    for (final e in alarmsFor(events, board.triage, now))
      if (!rung.contains(e.id)) Timer(e.start.subtract(lead).difference(now), () => ref.read(ringingProvider.notifier).ring(e)),
    for (final t in checksFor(events, board.triage, now, lead)) Timer(t.difference(now), () => ref.read(boardProvider.notifier).refreshOne('calendar')),
  ];
  ref.onDispose(() {
    for (final t in timers) {
      t.cancel();
    }
  });
});

/// The meeting ringing now, if any.
final ringingProvider = NotifierProvider<Ringing, EventRecord?>(Ringing.new);

class Ringing extends Notifier<EventRecord?> {
  /// Meetings that already rang, so a board change never rings one twice.
  final rung = <String>{};
  Process? _sound;
  Timer? _cap;

  @override
  EventRecord? build() {
    ref.onDispose(_silence);
    return null;
  }

  void ring(EventRecord e) {
    rung.add(e.id);
    _silence();
    state = e;
    _cap = Timer(ringFor, stop);
    _notify(e);
    ref.read(noticesProvider.notifier).add(NoticeKind.meeting, e.title, body: 'Starts at ${clockTime(e.start)}.');
    if (Platform.isMacOS) {
      unawaited(_loop(e));
      unawaited(Process.run('osascript', ['-e', 'tell application id "io.github.paillardf.quarterdeck" to activate']));
    }
  }

  Future<void> _loop(EventRecord e) async {
    while (state == e) {
      final p = _sound = await Process.start('afplay', ['/System/Library/Sounds/Glass.aiff']);
      // Stopped while the chime was starting.
      if (state != e) p.kill();
      await p.exitCode;
    }
  }

  void stop() {
    _silence();
    state = null;
  }

  /// Stops the ring and opens the call.
  void join(EventRecord e) {
    if (state?.id == e.id) stop();
    final u = joinUri(e);
    if (u != null) unawaited(openLink(u, ref.read(settingsProvider).value?.actions.browserProfile));
  }

  void _silence() {
    _cap?.cancel();
    _cap = null;
    _sound?.kill();
    _sound = null;
  }

  void _notify(EventRecord e) {
    final join = joinUri(e);
    final at = clockTime(e.start);
    final n = LocalNotification(
      identifier: 'deck-${e.id}',
      title: e.title,
      body: join == null ? 'Starts at $at.' : 'Starts at $at. Click to join.',
      actions: join == null ? null : [LocalNotificationAction(text: 'Join')],
    );
    n.onClick = () => join == null ? stop() : this.join(e);
    n.onClickAction = (_) => this.join(e);
    unawaited(n.show());
  }
}
