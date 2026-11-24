// Port of Skim's packages/core/tests/tickets.test.ts.
import 'package:deck/core/review/skim_config.dart';
import 'package:deck/core/review/tickets.dart';
import 'package:flutter_test/flutter_test.dart';

const mr = (provider: 'gitlab', webUrl: 'https://gitlab.example.com/group/app/-/merge_requests/7', projectPath: 'group/app');
const pr = (provider: 'github', webUrl: 'https://github.com/acme/app/pull/9', projectPath: 'acme/app');

typedef Forge = ({String provider, String webUrl, String projectPath});

String? url(String ref, SkimConfig config, [Forge? f]) => ticketUrl(ref, config, provider: f?.provider, webUrl: f?.webUrl, projectPath: f?.projectPath);

List<(String, String?)> refs(List<String> sources, SkimConfig config, [Forge? f]) => [
  for (final t in ticketRefsFor(sources, config, provider: f?.provider, webUrl: f?.webUrl, projectPath: f?.projectPath)) (t.ref, t.url),
];

void main() {
  group('findTicketRefs', () {
    test('finds Jira keys and issue numbers, first seen first, once each', () {
      expect(
        findTicketRefs(['feat/APP-231-cache', 'APP-231 disk cache\n\nCloses #12, see also APP-231 and #12.', 'fixup: hash with SHA-256, encode as UTF-8']),
        ['APP-231', '#12'],
      );
    });

    test('orders by position in the text, not by pattern', () {
      expect(findTicketRefs(['#3 then APP-1']), ['#3', 'APP-1']);
    });

    test('does not read a hex colour, an anchor or a lower case word as a ticket', () {
      expect(findTicketRefs(['color #ff0000, url/page#2, e-mail-1, ABC-1x']), isEmpty);
    });

    test('uses only the repository pattern when one is given', () {
      expect(findTicketRefs(['APP-1 fixes #3 and OTHER-9'], [RegExp(r'APP-\d+')]), ['APP-1']);
    });
  });

  group('ticketUrl', () {
    test('prefers ticket.url, with {id} stripped of a leading #', () {
      final config = SkimConfig(ticketUrl: 'https://tracker/{id}');
      expect(url('APP-1', config), 'https://tracker/APP-1');
      expect(url('#12', config, mr), 'https://tracker/12');
    });

    test('fills every {id} of the template, not only the first', () {
      expect(url('#12', SkimConfig(ticketUrl: 'https://tracker/{id}/browse/{id}'), mr), 'https://tracker/12/browse/12');
    });

    test('links #n to the issue of the request on both forges, and nothing else', () {
      expect(url('#12', SkimConfig(), mr), 'https://gitlab.example.com/group/app/-/issues/12');
      expect(url('#12', SkimConfig(), pr), 'https://github.com/acme/app/issues/12');
      expect(url('#12', SkimConfig()), isNull);
      expect(url('APP-1', SkimConfig(), mr), isNull);
    });

    test('ticketRefsFor pairs each ref with its url', () {
      expect(refs(['APP-1 #2'], SkimConfig(), mr), [('APP-1', null), ('#2', 'https://gitlab.example.com/group/app/-/issues/2')]);
    });

    test('leaves issue numbers out of the default on a pull request, since GitHub squash subjects carry them', () {
      expect(refs(['APP-1 disk cache (#1234)'], SkimConfig(), pr), [('APP-1', null)]);
      // An explicit pattern is taken as written, on either forge.
      expect(refs(['fixes #42'], SkimConfig(ticketPattern: RegExp(r'#\d+')), pr), [('#42', 'https://github.com/acme/app/issues/42')]);
    });
  });
}
