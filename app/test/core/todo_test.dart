import 'package:deck/actions/launcher.dart';
import 'package:deck/core/classify/todo.dart';
import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/config.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 10, 15, 9, 30);

void main() {
  test('a todo from Slack says where it came from and opens the message', () {
    final c = classifyTodo({
      'title': 'Answer Mo',
      'need': 'Say if deploys run only on develop.',
      'source': 'slack',
      'from': '#vpn-team',
      'url': 'https://acme.slack.com/archives/C1/p2',
    }, _now);
    expect(c.ref, 'Slack · #vpn-team');
    expect(c.channel, '#vpn-team');
    expect(actionsFor(c, const DeckConfig()).first, CardAction.open);
  });

  test('a todo from mail opens the thread', () {
    final c = classifyTodo({
      'title': 'Reply',
      'need': 'Reply to Jo.',
      'source': 'Mail',
      'from': 'Jo Carter',
      'url': 'https://mail.google.com/mail/u/0/#all/18f',
    }, _now);
    expect(c.ref, 'Mail · Jo Carter');
    expect(c.channel, isNull);
    expect(actionsFor(c, const DeckConfig()), [CardAction.open, CardAction.claude]);
  });

  test('a todo without a source or with an unsafe link has no open button, only Claude', () {
    expect(classifyTodo({'title': 'Plan', 'need': 'Plan it.'}, _now).ref, 'Deck');
    final bad = classifyTodo({'title': 'x', 'need': 'x', 'source': 'other', 'url': 'file:///etc/passwd'}, _now);
    expect(actionsFor(bad, const DeckConfig()), [CardAction.claude]);
  });

  test('Claude prompt: a card that needs you asks for a plan, any other only gives context', () {
    final c = classifyTodo({'title': 'Plan', 'need': 'Plan it.'}, _now);
    expect(promptFor(c, CardAction.claude), contains('Deck says what is needed: Plan it.'));
    expect(promptFor(c, CardAction.claude), isNot(contains('Read it first')));
    final waiting = promptFor(c.copyWith(bucket: Bucket.blocked, url: 'https://gitlab.com/a/b/-/merge_requests/1'), CardAction.claude);
    expect(waiting, startsWith('Context for this session: Deck note Deck: https://gitlab.com/a/b/-/merge_requests/1'));
    expect(waiting, contains('wait for my instructions'));
  });
}
