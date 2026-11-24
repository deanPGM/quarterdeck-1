// The GitLab style filter field: tokens for project, type and provider, free
// text for titles. Focus opens a menu of what you can pick, with counts.
// Pure widget: data and callbacks only.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models/board_filter.dart';
import '../../core/models/card.dart';
import '../parts.dart';
import '../theme.dart';

enum FilterKind { project, type, provider }

/// One row of the menu, and the token it becomes.
class FilterOption {
  const FilterOption(this.kind, this.id, this.label, {this.leading, this.count = 0});

  final FilterKind kind;
  final String id;
  final String label;
  final Widget? leading;
  final int count;
}

const _kindNames = {FilterKind.project: 'Project', FilterKind.type: 'Type', FilterKind.provider: 'Provider'};

bool picked(BoardFilter f, FilterOption o) => switch (o.kind) {
  FilterKind.project => f.projects.contains(o.id),
  FilterKind.type => f.types.any((t) => t.name == o.id),
  FilterKind.provider => f.providers.contains(o.id),
};

/// [f] with [o] added, or removed when [remove].
BoardFilter toggle(BoardFilter f, FilterOption o, {bool remove = false}) {
  Set<T> edit<T>(Set<T> s, T v) => remove ? ({...s}..remove(v)) : {...s, v};
  return switch (o.kind) {
    FilterKind.project => f.copyWith(projects: edit(f.projects, o.id)),
    FilterKind.type => f.copyWith(types: edit(f.types, Lane.values.byName(o.id))),
    FilterKind.provider => f.copyWith(providers: edit(f.providers, o.id)),
  };
}

class FilterField extends StatefulWidget {
  const FilterField({super.key, required this.filter, required this.options, required this.onChanged});

  final BoardFilter filter;
  final List<FilterOption> options;
  final ValueChanged<BoardFilter> onChanged;

  @override
  State<FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<FilterField> {
  late final _text = TextEditingController(text: widget.filter.text);
  final _focus = FocusNode();
  final _menu = OverlayPortalController();
  final _link = LayerLink();
  var _width = 400.0;

  /// The highlighted menu row, -1 for none.
  var _hi = -1;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      _focus.hasFocus ? _menu.show() : _menu.hide();
      setState(() => _hi = -1);
    });
  }

  @override
  void didUpdateWidget(FilterField old) {
    super.didUpdateWidget(old);
    if (widget.filter.text != _text.text) _text.text = widget.filter.text;
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  List<FilterOption> get _shown {
    final q = _text.text.trim().toLowerCase();
    return [
      for (final o in widget.options)
        if (!picked(widget.filter, o) && (q.isEmpty || o.label.toLowerCase().contains(q))) o,
    ];
  }

  void _pick(FilterOption o) {
    _text.clear();
    widget.onChanged(toggle(widget.filter, o).copyWith(text: ''));
    setState(() => _hi = -1);
  }

  List<FilterOption> get _tokens => [
    for (final o in widget.options)
      if (picked(widget.filter, o)) o,
  ];

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final n = _shown.length;
    switch (e.logicalKey) {
      case LogicalKeyboardKey.arrowDown when n > 0:
        setState(() => _hi = (_hi + 1).clamp(0, n - 1));
      case LogicalKeyboardKey.arrowUp when n > 0:
        setState(() => _hi = (_hi - 1).clamp(-1, n - 1));
      case LogicalKeyboardKey.enter || LogicalKeyboardKey.numpadEnter:
        if (_hi >= 0 && _hi < n) {
          _pick(_shown[_hi]);
        } else {
          _focus.unfocus();
        }
      case LogicalKeyboardKey.escape:
        _focus.unfocus();
      case LogicalKeyboardKey.backspace when _text.text.isEmpty && _tokens.isNotEmpty:
        widget.onChanged(toggle(widget.filter, _tokens.last, remove: true));
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c, f = widget.filter;
    return LayoutBuilder(
      builder: (context, box) {
        _width = box.maxWidth;
        return CompositedTransformTarget(
          link: _link,
          child: OverlayPortal(
            controller: _menu,
            overlayChildBuilder: _overlay,
            child: GestureDetector(
              onTap: _focus.requestFocus,
              child: Container(
                constraints: const BoxConstraints(minHeight: 36),
                padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                decoration: BoxDecoration(
                  color: c.fill,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _focus.hasFocus ? c.blue : Colors.transparent),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 17, color: c.label2),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          for (final o in _tokens) _Token(option: o, onRemove: () => widget.onChanged(toggle(f, o, remove: true))),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 160, maxWidth: 360),
                            child: IntrinsicWidth(
                              child: Focus(
                                canRequestFocus: false,
                                skipTraversal: true,
                                onKeyEvent: _key,
                                child: TextField(
                                  controller: _text,
                                  focusNode: _focus,
                                  style: context.t.bodyMedium,
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    filled: false,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                                    hintText: _tokens.isEmpty ? 'Filter by project, type, provider, or search titles' : null,
                                  ),
                                  onChanged: (v) {
                                    widget.onChanged(f.copyWith(text: v));
                                    setState(() => _hi = v.isEmpty || _shown.isEmpty ? -1 : 0);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!f.isEmpty)
                      TextButton(
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                        onPressed: () {
                          _text.clear();
                          widget.onChanged(const BoardFilter());
                        },
                        child: const Text('Clear'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _overlay(BuildContext context) {
    final c = context.c, shown = _shown;
    final rows = <Widget>[];
    FilterKind? kind;
    for (final (n, o) in shown.indexed) {
      if (o.kind != kind) {
        kind = o.kind;
        rows.add(SectionLabel(_kindNames[kind]!, padding: const EdgeInsets.fromLTRB(12, 10, 12, 4)));
      }
      rows.add(
        Material(
          color: n == _hi ? c.fill : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => _pick(o),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 22, child: o.leading),
                  const SizedBox(width: 6),
                  Expanded(child: Text(o.label, style: context.t.bodyMedium)),
                  Text('${o.count}', style: context.t.bodySmall),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return CompositedTransformFollower(
      link: _link,
      targetAnchor: Alignment.bottomLeft,
      offset: const Offset(0, 4),
      child: Align(
        alignment: Alignment.topLeft,
        // Clicks here keep the field focused.
        child: TextFieldTapRegion(
          child: Container(
            width: _width.clamp(280, 420),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: context.c.shadow.withValues(alpha: .16), blurRadius: 18, offset: const Offset(0, 6))],
            ),
            child: Material(
              key: const Key('filter-menu'),
              color: c.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: c.sep),
              ),
              shadowColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4),
                  children: [
                    if (rows.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('No project, type or provider matches. Press Enter to search titles.', style: context.t.bodySmall),
                      ),
                    ...rows,
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: c.sep)),
                      ),
                      child: Text('Type to narrow, or to search titles. Up and Down to move, Enter to pick.', style: context.t.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Token extends StatelessWidget {
  const _Token({required this.option, required this.onRemove});

  final FilterOption option;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      height: 26,
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.sep),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${_kindNames[option.kind]} ', style: context.t.bodySmall),
          if (option.leading != null) ...[option.leading!, const SizedBox(width: 4)],
          Text(option.label, style: context.t.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 12.5)),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.close_rounded, size: 14, color: c.label2),
            ),
          ),
        ],
      ),
    );
  }
}
