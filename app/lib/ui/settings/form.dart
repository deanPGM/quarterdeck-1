// Small building blocks for settings panes, in the macOS System Settings style:
// grouped rounded boxes, one row per setting, control on the right.
import 'package:flutter/material.dart';

import '../theme.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, this.title, this.footer, required this.children});

  final String? title;
  final String? footer;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(title!, style: context.t.titleMedium?.copyWith(fontSize: 13)),
            ),
          Container(
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.sep, width: .5),
            ),
            child: Column(
              children: [
                for (final (i, w) in children.indexed) ...[if (i > 0) Divider(indent: 14, color: c.sep), w],
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
              child: Text(footer!, style: context.t.bodySmall),
            ),
        ],
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key, required this.label, this.description, this.trailing, this.below});

  final String label;
  final String? description;
  final Widget? trailing;

  /// A wide control under the label (text field, list).
  final Widget? below;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.t.bodyMedium!.copyWith(fontSize: 13.5)),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(description!, style: context.t.bodySmall),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 16), trailing!],
          ],
        ),
        if (below != null) Padding(padding: const EdgeInsets.only(top: 8), child: below!),
      ],
    ),
  );
}

/// A text field that saves when you press Enter or leave it.
class CommitField extends StatefulWidget {
  const CommitField({super.key, required this.value, required this.onCommit, this.hint, this.width, this.mono = false});

  final String value;
  final ValueChanged<String> onCommit;
  final String? hint;
  final double? width;
  final bool mono;

  @override
  State<CommitField> createState() => _CommitFieldState();
}

class _CommitFieldState extends State<CommitField> {
  late final _ctl = TextEditingController(text: widget.value);
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _commit();
    });
  }

  @override
  void didUpdateWidget(CommitField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && widget.value != _ctl.text) _ctl.text = widget.value;
  }

  void _commit() {
    if (_ctl.text.trim() != widget.value) widget.onCommit(_ctl.text.trim());
  }

  @override
  void dispose() {
    _ctl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.width,
    child: TextField(
      controller: _ctl,
      focusNode: _focus,
      onSubmitted: (_) => _commit(),
      style: widget.mono ? mono(context.t.bodyMedium!.copyWith(fontSize: 13)) : context.t.bodyMedium!.copyWith(fontSize: 13),
      decoration: InputDecoration(hintText: widget.hint),
    ),
  );
}
