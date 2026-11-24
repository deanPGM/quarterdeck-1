---
name: deck-ui-change
description: "Change or add anything visible in the Deck Flutter app (board, cards, Settings window, theme) and verify it with golden screenshots and Widgetbook. Use when editing files under app/lib/ui, app/lib/dev, app/widgetbook, or when the user reports a layout or design issue in Deck."
---

# Change Deck's UI

The terminal has no Screen Recording permission, so screenshots of the running
app fail. Golden test PNGs are how you see the UI. Never report a UI change as
done without looking at the PNGs.

## Steps

1. Make the change in `app/lib/ui/`. Colors come from `DeckColors`
   (`context.c`), text styles from `context.t`. Build text styles from the
   platform ones (`t.bodyMedium!.copyWith(...)`), never a bare `TextStyle(...)`
   in the theme: that drops the system font on Linux and Windows.
2. If the change shows a new state, add it to the sample data in
   `app/lib/dev/fixtures.dart` (made up names only, never real work data) and,
   if it is a card state, a use case in `app/widgetbook/lib/main.dart`.
3. If it is a new screen or pane, add a test in `app/test/golden/screens_test.dart`.
4. From `app/`:
   ```
   dart format lib test
   flutter analyze
   flutter test --update-goldens test/golden
   ```
   A test that throws (overflow, ListTile without Material ancestor) is a real
   bug: fix it, do not hide it.
5. Read the changed PNGs in `app/test/golden/goldens/` (light and dark) and
   check the change is what was asked, and nothing else moved.
6. Rebuild and restart the app so the user sees it:
   `pkill -f Quarterdeck.app/Contents/MacOS/Quarterdeck; flutter build macos --debug && open build/macos/Build/Products/Debug/Quarterdeck.app`

## Rules

- Layout: rows that end with controls (menu, flags) give the free space to one
  `Expanded`, never a `Flexible` plus a `Spacer` (that left the card menu off
  the right edge once).
- Lists with highlights (`ListTile`) sit in a `Material`, not a colored `Container`.
- Formatting: page width 160.
- Pure widgets (like `CardTile`) take data and callbacks, no providers, so
  Widgetbook and tests can render them.
