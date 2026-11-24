import 'package:deck/claude/project_info_task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a board found on the forge is not looked for again', () {
    final p = projectInfoPrompt('vpn', board: 'gitlab:acme/vpn');
    expect(p, contains('already set to "gitlab:acme/vpn" by Deck: leave it out.'));
    expect(p, isNot(contains('"jira:KEY"')));
  });

  test('with no forge board, Jira only for the project\'s own tickets', () {
    final p = projectInfoPrompt('vpn');
    expect(p, contains('"jira:KEY" only when this project\'s own tickets live in Jira'));
    expect(p, contains('company wide board'));
  });

  test('channels are found by what is said in them, not only by name', () {
    final p = projectInfoPrompt('vpn');
    expect(p, contains('slack_search_public_and_private'));
    expect(p, contains('by content'));
  });
}
