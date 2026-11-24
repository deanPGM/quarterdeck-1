// Deck's component catalog. Run: cd app/widgetbook && flutter run -d macos
import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/config.dart';
import 'package:deck/core/models/snapshot.dart';
import 'package:deck/core/review/diff.dart';
import 'package:deck/dev/fixtures.dart';
import 'package:deck/dev/map_samples.dart';
import 'package:deck/dev/review_samples.dart';
import 'package:deck/main.dart';
import 'package:deck/state/board.dart';
import 'package:deck/ui/board/board_model.dart';
import 'package:deck/ui/board/card_tile.dart';
import 'package:deck/ui/board/meeting_strip.dart';
import 'package:deck/ui/map/class_graph.dart';
import 'package:deck/ui/map/sequence_view.dart';
import 'package:deck/ui/map/state_view.dart';
import 'package:deck/ui/review/file_diff.dart';
import 'package:deck/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';

void main() => runApp(const DeckWidgetbook());

final _board = sampleBoard();
final _now = DateTime.now();

DeckCard _card(String key) => _board.snapshots.values.expand((s) => s.cards).firstWhere((c) => c.key.contains(key));

/// A card with its triage driven by knobs.
Widget _cardCase(BuildContext context, String key) {
  final k = context.knobs;
  final card = _card(key);
  final triage = Triage(
    urgent: k.boolean(label: 'Urgent'),
    pin: k.boolean(label: 'Pinned'),
    boost: k.int.slider(label: 'Boost', initialValue: 0, min: -3, max: 3),
    note: k.stringOrNull(label: 'Note'),
    snoozeUntil: k.boolean(label: 'Snoozed') ? _now.add(const Duration(days: 3)) : null,
  );
  final items = buildItems(
    {
      'x': Snapshot(cards: [card]),
    },
    {card.key: triage},
    {if (k.boolean(label: 'Reloading')) card.key},
    sampleConfig,
    _now,
  );
  return Center(
    child: SizedBox(
      width: k.double.slider(label: 'Width', initialValue: 330, min: 260, max: 480),
      child: CardTile(item: items.single, now: _now),
    ),
  );
}

class DeckWidgetbook extends StatelessWidget {
  const DeckWidgetbook({super.key});

  @override
  Widget build(BuildContext context) => Widgetbook.material(
    addons: [
      MaterialThemeAddon(
        themes: [
          WidgetbookTheme(name: 'Light', data: deckTheme(Brightness.light)),
          WidgetbookTheme(name: 'Dark', data: deckTheme(Brightness.dark)),
        ],
      ),
    ],
    directories: [
      WidgetbookFolder(
        name: 'Board',
        children: [
          WidgetbookComponent(
            name: 'CardTile',
            useCases: [
              WidgetbookUseCase(name: 'Review, threads answered', builder: (c) => _cardCase(c, 'vpn-ios!412')),
              WidgetbookUseCase(name: 'Review, first', builder: (c) => _cardCase(c, 'vpn-ios!418')),
              WidgetbookUseCase(name: 'My MR, ready to merge', builder: (c) => _cardCase(c, 'backend!77')),
              WidgetbookUseCase(name: 'My MR, waits for review', builder: (c) => _cardCase(c, 'backend!81')),
              WidgetbookUseCase(name: 'Escalation', builder: (c) => _cardCase(c, 'VPN-120')),
              WidgetbookUseCase(name: 'Ticket in review', builder: (c) => _cardCase(c, 'VPN-131')),
              WidgetbookUseCase(name: 'Slack ask', builder: (c) => _cardCase(c, 'C1/2')),
              WidgetbookUseCase(name: 'Todo', builder: (c) => _cardCase(c, 'todo:1')),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Calendar',
        children: [
          WidgetbookComponent(
            name: 'Meeting strip',
            useCases: [
              WidgetbookUseCase(
                name: 'Today',
                builder: (c) => Align(
                  alignment: Alignment.topLeft,
                  child: MeetingStrip(
                    events: _board.snapshots['calendar']!.events,
                    silenced: {
                      if (c.knobs.boolean(label: 'Daily silenced')) 'e1',
                      'e3',
                    },
                    now: _now,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Map',
        children: [
          WidgetbookComponent(
            name: 'Sequence player',
            useCases: [
              WidgetbookUseCase(
                name: 'Watering flow',
                builder: (_) => const _Pad(SequencePlayer(sequence: sampleSequence)),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'State diagram',
            useCases: [
              WidgetbookUseCase(
                name: 'Top to bottom',
                builder: (_) => const _Pad(StateDiagramView(state: sampleState)),
              ),
              WidgetbookUseCase(
                name: 'Left to right, composite',
                builder: (_) => const _Pad(StateDiagramView(state: sampleStateLr)),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'Class graph',
            useCases: [
              WidgetbookUseCase(
                name: 'Lanes and statuses',
                builder: (_) => const _Pad(ClassGraphView(graph: sampleGraph, featureTitles: {'history': 'Garden history'})),
              ),
              WidgetbookUseCase(
                name: 'Busy map',
                builder: (_) => const _Pad(ClassGraphView(graph: sampleBigGraph)),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Review',
        children: [
          WidgetbookComponent(
            name: 'File diff',
            useCases: [
              WidgetbookUseCase(name: 'Every sample', builder: (c) => _diffCase(c, sampleDiffFiles)),
              WidgetbookUseCase(name: 'Big hunk split, with notes', builder: (c) => _diffCase(c, [sampleSplitHunk])),
              WidgetbookUseCase(name: 'Moved block', builder: (c) => _diffCase(c, [sampleMoved])),
              WidgetbookUseCase(name: '3,000 lines', builder: (c) => _diffCase(c, [sampleBigFile()])),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Screens',
        children: [
          WidgetbookComponent(
            name: 'App',
            useCases: [
              WidgetbookUseCase(
                name: 'Board and settings',
                builder: (_) => ProviderScope(overrides: overrides(sampleConfig, sampleBoard()), child: const DeckApp()),
              ),
              WidgetbookUseCase(
                name: 'Before setup',
                builder: (_) => ProviderScope(overrides: overrides(const DeckConfig(), const BoardState()), child: const DeckApp()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// A diagram on a page that scrolls, as the map page shows it.
class _Pad extends StatelessWidget {
  const _Pad(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(16), child: child);
}

/// Review diffs in one scroll view, the way the review screen lists them.
Widget _diffCase(BuildContext context, List<DiffFile> files) {
  final split = context.knobs.boolean(label: 'Split');
  return CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverMainAxisGroup(
          slivers: [
            for (final f in files)
              FileDiffView(
                file: f,
                split: split,
                note: sampleFileNotes[f.path],
                hunkNotes: sampleHunkNotes,
                loadContext: sampleLoadContext,
                onViewed: (_) {},
                onOpen: (_) {},
              ),
          ],
        ),
      ),
    ],
  );
}
