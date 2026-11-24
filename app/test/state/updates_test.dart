import 'package:deck/state/updates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Release _r(String v) => Release(version: v, notes: '', url: 'https://example.com/v$v');

void main() {
  // Tests are a dev build: the state says which version runs.
  ProviderContainer container(Future<Release?> Function() latest) {
    final c = ProviderContainer(overrides: [latestReleaseProvider.overrideWithValue(latest)]);
    addTearDown(c.dispose);
    return c;
  }

  test('a dev build is never offered an update', () async {
    final c = container(() async => _r('9.0.0'));
    await c.read(updatesProvider.notifier).check();
    final s = c.read(updatesProvider);
    expect(s.dev, isTrue);
    expect(s.latest?.version, '9.0.0');
    expect(s.available, isNull);
    expect(s.offer, isFalse);
  });

  test('a newer release is offered until Later, and again for a newer one', () {
    var s = UpdateState(current: '0.1.0', latest: _r('0.2.0'));
    expect(s.available?.version, '0.2.0');
    expect(s.offer, isTrue);
    s = s.copyWith(dismissed: true);
    expect(s.offer, isFalse);
    expect(UpdateState(current: '0.1.0', latest: _r('0.1.0')).available, isNull);
  });

  test('a failed check keeps what was known and says why', () async {
    final c = container(() async => throw const SocketExceptionLike('no network'));
    await c.read(updatesProvider.notifier).check();
    final s = c.read(updatesProvider);
    expect(s.step, UpdateStep.idle);
    expect(s.error, 'no network');
  });
}

class SocketExceptionLike implements Exception {
  const SocketExceptionLike(this.message);

  final String message;

  @override
  String toString() => message;
}
