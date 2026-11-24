import 'package:deck/claude/rule_advice.dart';
import 'package:deck/core/tool_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, Object?> bash(String c) => {'command': c};

  test('the suggested rule keeps the first words, three after rtk', () {
    expect(suggestRule('Bash', bash('git diff main -- a.dart')), 'Bash(git diff:*)');
    expect(suggestRule('Bash', bash('rtk git diff --no-compact a...b')), 'Bash(rtk git diff:*)');
    expect(suggestRule('WebFetch', {'url': 'https://x'}), 'WebFetch');
  });

  test('a prefix rule matches one plain command only', () {
    const rules = ['Bash(rtk git diff:*)', 'WebFetch'];
    expect(ruleAllows(rules, 'Bash', bash('rtk git diff a...b -- x')), isTrue);
    expect(ruleAllows(rules, 'Bash', bash('rtk git diff')), isTrue);
    expect(ruleAllows(rules, 'Bash', bash('rtk git difftool')), isFalse);
    expect(ruleAllows(rules, 'Bash', bash('rtk git diff && rm -rf ~')), isFalse);
    expect(ruleAllows(rules, 'Bash', bash(r'rtk git diff $(rm -rf ~)')), isFalse);
    expect(ruleAllows(rules, 'WebFetch', {'url': 'https://x'}), isTrue);
    expect(ruleAllows(rules, 'Edit', {}), isFalse);
  });

  test('advice is read from the JSON array, words around it or not', () {
    final a = parseAdvice('Here:\n[{"rule": "Bash(git log:*)", "reason": "read only", "risk": "low"}, {"rule": ""}]');
    expect(a, [(rule: 'Bash(git log:*)', reason: 'read only', risk: 'low')]);
    expect(() => parseAdvice('no rules'), throwsA(isA<String>()));
  });
}
