// Settings, Claude: the tools every background session may use without
// asking, what sessions asked for lately, and Claude's suggested rules.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/meetings.dart';
import '../../core/tool_rules.dart';
import '../../state/notices.dart';
import '../../state/settings.dart';
import '../theme.dart';
import 'form.dart';

class ToolRulesGroups extends ConsumerStatefulWidget {
  const ToolRulesGroups({super.key});

  @override
  ConsumerState<ToolRulesGroups> createState() => _ToolRulesGroupsState();
}

class _ToolRulesGroupsState extends ConsumerState<ToolRulesGroups> {
  Future<void> _setRules(List<String> Function(List<String>) f) =>
      ref.read(settingsProvider.notifier).change((c) => c.copyWith(claude: c.claude.copyWith(allowedTools: f(c.claude.allowedTools))));

  Future<void> _add(String rule) => _setRules((r) => r.contains(rule) ? r : [...r, rule]);

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final code = mono(context.t.bodyMedium!.copyWith(fontSize: 12));
    final rules = ref.watch(settingsProvider).requireValue.claude.allowedTools;
    final asks = ref.watch(permissionHistoryProvider).value ?? const [];
    final suggested = ref.watch(ruleAdviceProvider);
    final error = suggested.hasError ? '${suggested.error}' : null;
    final advice = [
      for (final a in suggested.value ?? const [])
        if (!rules.contains(a.rule)) a,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsGroup(
          title: 'Allowed tools',
          footer: 'Every background session may use these without asking. Bash(git diff:*) allows the commands that start with git diff.',
          children: [
            for (final r in rules)
              SettingsRow(
                label: r,
                trailing: IconButton(
                  onPressed: () => _setRules((x) => [...x]..remove(r)),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  tooltip: 'Remove',
                ),
              ),
            SettingsRow(
              label: 'Add a rule',
              trailing: CommitField(width: 300, mono: true, value: '', hint: 'Bash(npm test:*)', onCommit: (v) => v.isEmpty ? null : _add(v)),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Asked by background sessions',
          children: [
            SettingsRow(
              label: 'Suggest rules with Claude',
              description: error ?? 'Claude reads the asks below and proposes rules. Nothing is added until you click Add.',
              trailing: suggested.isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : FilledButton.tonal(onPressed: asks.isEmpty ? null : ref.read(ruleAdviceProvider.notifier).suggest, child: const Text('Suggest')),
            ),
            for (final a in advice)
              SettingsRow(
                label: a.rule,
                description: a.reason,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      a.risk,
                      style: context.t.bodySmall?.copyWith(
                        color: switch (a.risk) {
                          'low' => c.green,
                          'medium' => c.orange,
                          _ => c.red,
                        },
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(onPressed: () => _add(a.rule), child: const Text('Add')),
                  ],
                ),
              ),
            if (asks.isEmpty) const SettingsRow(label: 'No ask yet'),
            for (final a in asks.take(15))
              SettingsRow(
                label: callSummary(a.tool, a.input),
                description: '${clockTime(a.at)} · ${a.at.day}/${a.at.month} · ${_answers[a.answer] ?? a.answer}',
                trailing: ruleAllows(rules, a.tool, a.input)
                    ? Text('Allowed', style: context.t.bodySmall?.copyWith(color: c.label3))
                    : TextButton(
                        onPressed: () => _add(suggestRule(a.tool, a.input)),
                        child: Text('Allow ${suggestRule(a.tool, a.input)}', style: code),
                      ),
              ),
          ],
        ),
      ],
    );
  }
}

const _answers = {'allow': 'allowed once', 'always': 'always allowed', 'deny': 'denied', 'timeout': 'no answer, denied', 'rule': 'allowed by a rule'};
