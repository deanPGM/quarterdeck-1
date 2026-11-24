// The small widgets every screen is built from: headers, cards, tags,
// banners, sidebar rows. One copy each, so a screen cannot drift.
import 'package:flutter/material.dart';

import 'theme.dart';

/// Space around a page's content.
const pagePadding = EdgeInsets.fromLTRB(28, 26, 28, 28);

/// Space around a page head that sits over a list (board, activity, MRs).
const headPadding = EdgeInsets.fromLTRB(28, 26, 24, 14);

/// Space around a strip under that head: meetings, alarm, filters.
const stripPadding = EdgeInsets.fromLTRB(28, 0, 24, 12);

/// A page title, an optional line under it, and [trailing] on the right.
class PageHead extends StatelessWidget {
  const PageHead({super.key, required this.title, this.subtitle, this.leading, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? leading, trailing;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (leading != null) ...[leading!, const SizedBox(width: 14)],
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.t.headlineSmall),
            if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: context.t.bodySmall)],
          ],
        ),
      ),
      ?trailing,
    ],
  );
}

/// A small caps label over a section.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.padding = EdgeInsets.zero});

  final String text;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Text(text.toUpperCase(), style: context.t.labelSmall),
  );
}

/// A rounded content card on the page background. With [onTap] the whole
/// card is a button.
class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.child, this.onTap, this.mouseCursor, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final VoidCallback? onTap;
  final MouseCursor? mouseCursor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final body = Padding(padding: padding, child: child);
    return Material(
      color: context.c.card,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: onTap == null && mouseCursor == null ? body : InkWell(onTap: onTap, mouseCursor: mouseCursor, child: body),
    );
  }
}

/// A short tinted tag: a state, a severity, a label.
class StatusTag extends StatelessWidget {
  const StatusTag(this.label, this.color, {super.key, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: .14), borderRadius: BorderRadius.circular(5)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 11, color: color), const SizedBox(width: 3)],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.t.bodySmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ],
    ),
  );
}

/// A box tinted with [color]: notes, banners, status lines. [dense] inside a
/// card, roomy on a page.
class TintBox extends StatelessWidget {
  const TintBox({super.key, required this.color, required this.child, this.dense = false, this.margin});

  final Color color;
  final Widget child;
  final bool dense;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: margin,
    padding: dense ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6) : const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(dense ? 6 : 10)),
    child: child,
  );
}

/// An icon and a line in a [TintBox], with an optional [trailing] control.
class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.icon, required this.color, required this.text, this.trailing});

  final IconData icon;
  final Color color;
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => TintBox(
    color: color,
    child: Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: context.t.bodyMedium)),
        ?trailing,
      ],
    ),
  );
}

/// What a page says when it has nothing to show: an icon, a title, a line,
/// and an optional button.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.text, this.action});

  final IconData icon;
  final String title;
  final String? text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: context.c.label3),
        const SizedBox(height: 12),
        Text(title, style: context.t.titleMedium),
        if (text != null) ...[const SizedBox(height: 4), Text(text!, style: context.t.bodySmall)],
        if (action != null) ...[const SizedBox(height: 14), action!],
      ],
    ),
  );
}

/// The chevron button on top of a sidebar that goes back a level.
class SidebarBack extends StatelessWidget {
  const SidebarBack({super.key, required this.label, required this.onPressed});

  final Widget label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      style: TextButton.styleFrom(foregroundColor: context.c.label2),
      onPressed: onPressed,
      icon: const Icon(Icons.chevron_left_rounded, size: 18),
      label: label,
    ),
  );
}

/// One row of a sidebar: icon, label, a count or state on the right.
class SidebarRow extends StatelessWidget {
  const SidebarRow({super.key, required this.label, required this.selected, required this.onTap, this.leading, this.trailing, this.dim = false, this.color});

  final String label;
  final bool selected, dim;

  /// The label color, for an action row like "Add Project…".
  final Color? color;
  final VoidCallback onTap;
  final Widget? leading, trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -3),
      selected: selected,
      selectedTileColor: c.fill,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.only(left: leading == null ? 16 : 8, right: 8),
      minLeadingWidth: 0,
      horizontalTitleGap: 10,
      leading: leading,
      title: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: context.t.bodyMedium!.copyWith(fontSize: 13, color: color ?? (dim ? c.label2 : c.label)),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// The caps heading of a sidebar group.
class SidebarSection extends StatelessWidget {
  const SidebarSection(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => SectionLabel(label, padding: const EdgeInsets.fromLTRB(8, 16, 8, 4));
}

/// A white icon on an accent fill: a rounded square like System Settings,
/// or a [circle].
class AccentIcon extends StatelessWidget {
  const AccentIcon(this.icon, this.color, {super.key, this.size = 22, this.circle = false});

  final IconData icon;
  final Color color;
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(circle ? size / 2 : size * .27)),
    child: Icon(icon, size: size * .6, color: context.c.onAccent),
  );
}
