import 'package:deck/core/classify/notes.dart';
import 'package:flutter_test/flutter_test.dart';

const _steps = '''
[Alex Kim] Document Approach: Write a summary of the cache-based
alternate strategy for offline sync.

[Sam Lee, Jordan Park] Brief Max: Update Max about the hackathon
project feasibility discussion.

[Riley Chen] Create Ticket: Mention Sam Lee in the ticket.
''';

void main() {
  test('only the steps with your name become todos, on one line', () {
    expect(stepsFor(_steps, 'sam lee'), [(title: 'Brief Max', need: 'Update Max about the hackathon project feasibility discussion.')]);
  });

  test('a first name is enough', () {
    expect(stepsFor(_steps, 'Sam').map((s) => s.title), ['Brief Max']);
  });

  test('no name, no steps', () {
    expect(stepsFor(_steps, ' '), isEmpty);
  });

  group('a step on an open card', () {
    const targets = <NoteTarget>[
      (key: 'gitlab:vpn-ios!412', ref: 'vpn-ios!412', title: 'Fix cold launch sync'),
      (key: 'gitlab:backend!412', ref: 'backend!412', title: 'Rate limit'),
      (key: 'jira:VPN-131', ref: 'VPN-131', title: 'Kill switch survives reboot'),
      (key: 'todo:1', ref: '', title: 'Prepare the retro'),
    ];
    ({String title, String need}) step(String title, String need) => (title: title, need: need);

    test('a ref it names wins, but not one two cards share', () {
      expect(stepCard(step('Kill switch', 'Close VPN-131 once tested.'), targets, const {}), 'jira:VPN-131');
      expect(stepCard(step('Merge', 'Merge vpn-ios!412 today.'), targets, const {}), 'gitlab:vpn-ios!412');
      expect(stepCard(step('Merge', 'Merge !412 today.'), targets, const {}), isNull);
    });

    test('else the card Claude linked, if it is open', () {
      final links = stepLinks([
        {'step': 'Retro  Notes', 'card': 'todo:1'},
        {'step': 'Gone', 'card': 'todo:9'},
      ]);
      expect(stepCard(step('Retro notes', 'Collect them.'), targets, links), 'todo:1');
      expect(stepCard(step('Gone', 'x'), targets, links), isNull);
      expect(stepCard(step('Other', 'x'), targets, links), isNull);
    });
  });
}
