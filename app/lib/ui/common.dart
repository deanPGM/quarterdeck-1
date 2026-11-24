// Small helpers every screen shares: ask to confirm or for a line, show a toast, open a
// file in the IDE, the compact button size, and markdown in the theme.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../actions/launcher.dart';
import '../state/settings.dart';
import 'map/sequence_view.dart' show OpenCode;
import 'theme.dart';

export 'map/sequence_view.dart' show OpenCode;

/// Asks [title] with [text], Cancel and [action]. True when [action] is picked.
Future<bool> confirm(BuildContext context, {required String title, required String text, required String action, bool destructive = false}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(width: 420, child: Text(text)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: destructive ? FilledButton.styleFrom(backgroundColor: context.c.red) : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    ) ??
    false;

/// Asks for a line of text under [title], with Cancel and Save. Null when
/// cancelled.
Future<String?> ask(BuildContext context, {required String title, String? text, String? hint, int lines = 3}) {
  final ctl = TextEditingController(text: text);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: ctl,
          autofocus: true,
          maxLines: lines,
          decoration: InputDecoration(hintText: hint),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, ctl.text), child: const Text('Save')),
      ],
    ),
  );
}

/// Shows the ticket Deck will make on [board] ("Jira OM"), title and
/// description editable. Null when cancelled.
Future<({String title, String body})?> askTicket(BuildContext context, {required String board, required String title, required String body}) {
  final t = TextEditingController(text: title), b = TextEditingController(text: body);
  return showDialog<({String title, String body})>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Make Ticket in $board'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: t,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: b,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => t.text.trim().isEmpty ? null : Navigator.pop(ctx, (title: t.text.trim(), body: b.text.trim())),
          child: const Text('Make Ticket'),
        ),
      ],
    ),
  );
}

/// A short floating message at the bottom of the window.
void showToast(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating, width: 420));

/// Opens a file of project [projectId] in its IDE, or in the IDE set in Settings.
OpenCode codeOpener(WidgetRef ref, String projectId) => (path, line) async {
  final cfg = await ref.read(settingsProvider.future);
  final p = cfg.projects.where((x) => x.id == projectId).firstOrNull;
  if (p?.dir != null) await openInIde(p!.ide ?? cfg.actions.ide, p.dir!, path, line);
};

/// The compact button size, for buttons inside cards and strips. Works on
/// any button kind; [color] tints the text and icon.
ButtonStyle smallButton(BuildContext context, {Color? color}) => ButtonStyle(
  visualDensity: VisualDensity.compact,
  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
  minimumSize: const WidgetStatePropertyAll(Size(0, 28)),
  foregroundColor: color == null ? null : WidgetStatePropertyAll(color),
  textStyle: WidgetStatePropertyAll(context.t.labelMedium),
);

/// Markdown in the theme: body text, mono() code, a checkbox that fits.
Widget deckMarkdown(BuildContext context, String text, {Color? color}) {
  final c = context.c, dark = Theme.of(context).brightness == Brightness.dark;
  final style = context.t.bodyMedium!.copyWith(color: color);
  return MarkdownBlock(
    data: text,
    selectable: false,
    config: (dark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig).copy(
      configs: [
        PConfig(textStyle: style),
        CodeConfig(style: mono(style.copyWith(fontSize: 12, backgroundColor: c.fill))),
        // The package's own box sits at a padding of half the line height
        // minus 12: negative at this font size, and the card fails to build.
        CheckBoxConfig(
          builder: (checked) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(checked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, size: 14, color: c.label2),
          ),
        ),
      ],
    ),
  );
}
