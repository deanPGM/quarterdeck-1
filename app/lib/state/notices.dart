// Deck's notifications: a meeting that rang, a tool a background session
// asked for, a session that ended. The live ones (ringing, asks) float over
// every screen, see NoticeLayer; the bell panel lists the rest until cleared.
import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../claude/rule_advice.dart';
import '../data/permission_log.dart';
import 'settings.dart';

enum NoticeKind { meeting, permission, session }

class Notice {
  const Notice({required this.id, required this.at, required this.kind, required this.title, this.body = '', this.route, this.error = false});

  final int id;
  final DateTime at;
  final NoticeKind kind;
  final String title, body;

  /// Where a click goes: "/project/vpn-ios/review/gitlab-412".
  final String? route;
  final bool error;
}

class NoticesState {
  const NoticesState({this.all = const [], this.unread = 0, this.toasts = const {}, this.open = false});

  /// Newest first.
  final List<Notice> all;
  final int unread;

  /// Ids of the notices floating over the screen now.
  final Set<int> toasts;

  /// The bell panel shows.
  final bool open;

  NoticesState copyWith({List<Notice>? all, int? unread, Set<int>? toasts, bool? open}) =>
      NoticesState(all: all ?? this.all, unread: unread ?? this.unread, toasts: toasts ?? this.toasts, open: open ?? this.open);
}

final noticesProvider = NotifierProvider<Notices, NoticesState>(Notices.new);

class Notices extends Notifier<NoticesState> {
  var _next = 0;

  @override
  NoticesState build() => const NoticesState();

  /// [toast]: it also floats over the screen for a few seconds.
  void add(NoticeKind kind, String title, {String body = '', String? route, bool error = false, bool toast = false}) {
    final n = Notice(id: _next++, at: clock.now(), kind: kind, title: title, body: body, route: route, error: error);
    state = state.copyWith(all: [n, ...state.all.take(99)], unread: state.open ? 0 : state.unread + 1, toasts: toast ? {...state.toasts, n.id} : null);
    if (toast) Timer(const Duration(seconds: 8), () => dismiss(n.id));
  }

  void dismiss(int id) => state = state.copyWith(toasts: {...state.toasts}..remove(id));

  void setOpen(bool open) => state = state.copyWith(open: open, unread: open ? 0 : null);

  void clear() => state = state.copyWith(all: const [], toasts: const {});
}

final permissionLogProvider = Provider((ref) => PermissionLog(File(p.join(ref.watch(homeProvider).cache.path, 'permission_asks.jsonl'))));

/// The asks Settings lists, newest first.
final permissionHistoryProvider = FutureProvider((ref) => ref.watch(permissionLogProvider).read());

/// Rules Claude suggests from the asks, empty until Settings asks for them.
final ruleAdviceProvider = NotifierProvider<RuleAdviceNotifier, AsyncValue<List<RuleAdvice>>>(RuleAdviceNotifier.new);

class RuleAdviceNotifier extends Notifier<AsyncValue<List<RuleAdvice>>> {
  @override
  AsyncValue<List<RuleAdvice>> build() => const AsyncData([]);

  Future<void> suggest() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final cfg = await ref.read(settingsProvider.future);
      final asks = await ref.read(permissionLogProvider).read();
      return adviseRules(ref.read(homeProvider), asks, cfg.claude.allowedTools, cfg.claude.model);
    });
  }
}
