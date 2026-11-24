# Deck (Flutter app)

Developer notes for the Flutter app. What Quarterdeck is, how to install it
and what it does in the background: [`../README.md`](../README.md).

## Run

```
flutter run -d macos          # the app
cd widgetbook && flutter run -d macos   # the component catalog
flutter test                  # unit and golden tests
flutter test --update-goldens test/golden   # after a UI change
dart run build_runner build -d   # after changing a freezed model or provider
```

Settings live in the Deck folder (default `~/.deck`, change it in Settings →
General): `deck.json`, `state/` (backed up with git), `cache/` (disposable).

## Layout

| Folder | What |
|---|---|
| `lib/core` | Pure Dart: models, classifiers (rules that turn a record into a card), projects |
| `lib/data` | Deck folder, stores, git backup |
| `lib/sources` | Direct fetching: GitLab (glab), GitHub (gh), shell environment |
| `lib/claude` | Background session: task specs per provider, runner |
| `lib/mcp` | Deck's own MCP server and its HTTP transport |
| `lib/state` | Riverpod providers: settings, board, reviews, terminals, MCP host |
| `lib/actions` | Launch Claude, the IDE or a review from a card |
| `lib/ui` | Board, Settings, theme |
| `lib/dev` | Sample data and fakes for tests and Widgetbook |
| `tool/` | Spikes and live checks (`dart run tool/check_gitlab.dart`, `check_github.dart`) |

Each layer imports only the ones before it: `core` ← `data` ← `sources` ←
`mcp` ← `claude` ← `state` ← `actions` ← `ui`. So:

- `core` is pure Dart: no Flutter, no IO. Types that cross layers live there.
- `ui` reads and changes things only through `state` providers (and starts
  `actions`). It never calls `data`, `sources` or `claude` itself.
- State the app keeps lives in a provider, never in a top level variable,
  so tests can override it.

## Not done yet

See [`../BACKLOG.md`](../BACKLOG.md).
