import 'package:deck/core/links.dart';
import 'package:deck/core/models/card.dart';
import 'package:flutter_test/flutter_test.dart';

DeckCard _card(String key, String provider, String ref, {String title = '', String url = '', String? path, int? iid, List<String> refs = const []}) => DeckCard(
  key: key,
  provider: provider,
  lane: Lane.task,
  ref: ref,
  url: url,
  title: title,
  next: '',
  bucket: Bucket.action,
  score: 0,
  path: path,
  iid: iid,
  refs: refs,
);

void main() {
  final ticket = _card('jira:AVPN-123', 'jira', 'AVPN-123', title: 'Login fails');
  final mr = _card('gitlab:acme/app!955', 'gitlab', 'app!955', title: 'Fix login', path: 'acme/app', iid: 955, refs: ['feat/avpn-123-login']);
  final slack = _card('slack:C1/2', 'slack', '#team', title: 'Can you look at the login?', refs: ['app!955']);
  final other = _card('jira:AVPN-7', 'jira', 'AVPN-7', title: 'Use UTF-8 in logs');

  test('finds links from branch, about and links, both ways', () {
    final l = linksOf([ticket, mr, slack, other], const {});
    expect(l['jira:AVPN-123']!.map((x) => x.key), ['gitlab:acme/app!955']);
    expect(l['gitlab:acme/app!955']!.map((x) => x.key).toSet(), {'jira:AVPN-123', 'slack:C1/2'});
    expect(l['slack:C1/2']!.single, (key: 'gitlab:acme/app!955', manual: false));
    expect(l['jira:AVPN-7'], isNull, reason: 'UTF-8 matches no card');
  });

  test('a merge request link in a todo links it', () {
    final todo = _card('todo:1', 'todo', 'Deck', title: 'Ship it', url: 'https://gitlab.com/acme/app/-/merge_requests/955');
    expect(linksOf([mr, todo], const {})['todo:1']!.single.key, mr.key);
  });

  test('your links are added, the ones you cut stay cut', () {
    final l = linksOf([ticket, mr, slack, other], {pairKey(mr.key, ticket.key): false, pairKey(other.key, slack.key): true});
    expect(l['jira:AVPN-123'], isNull);
    expect(l['jira:AVPN-7']!.single, (key: 'slack:C1/2', manual: true));
  });

  test('a link to a card no longer on the board is skipped', () {
    expect(linksOf([ticket], {pairKey(ticket.key, 'slack:gone'): true}), isEmpty);
  });
}
