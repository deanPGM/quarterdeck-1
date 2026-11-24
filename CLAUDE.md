# CLAUDE.md

Deck: a desktop board of everything on your plate. Read `DESIGN.md` first
(architecture and the why of each decision), then `app/README.md` (layout, run).
What is left to build lives only in `BACKLOG.md`.

## Where the code is

- `app/`: the Flutter app (macOS, Linux, Windows). This is the product.
- `app/widgetbook/`: component catalog.
- Branch: `main`.

## Public repo: check every commit for privacy

`github.com/paillardf/quarterdeck` is public. Anything committed or pushed
(code, tests, fixtures, docs, screenshots, commit messages) is published and
stays fetchable by hash even after a force push. Before each commit, read the
staged diff (`git diff --cached`) and keep out:

- Secrets: tokens, keys, cookies, `.env` files. Run `gitleaks git . --redact`
  (or `gitleaks protect --staged`) before committing.
- The author's employer: its name, products, codenames, repo paths and group
  names, Jira project keys, MR or issue numbers, Slack workspace, channel or
  user IDs, internal hosts and URLs, `~/projects/<employer>` style paths.
- Real people: colleague names, emails, handles, and content copied from real
  meetings, messages, mail or tickets. Fixtures use made-up data only (Acme,
  `acme.atlassian.net`, Sam Lee, `vpn-ios!412`, `D1`, `C1`).
- Data from `~/.deck` (cache, state, run logs, session transcripts) and from
  live checks (`tool/check_*.dart`). Never paste their output into a test,
  fixture, doc or commit message, and never commit a screenshot taken from
  live data: golden and README screenshots come from `app/lib/dev/fixtures.dart`.
- Personal details: home paths (`/Users/<name>`), personal email addresses
  other than the commit author.

When unsure, ask before committing. If something private was already pushed,
stop and tell the user: a fix needs a history rewrite and recreating the repo.

## Commands (from `app/`)

```
flutter analyze
flutter test                                  # unit + golden screenshots
flutter test --update-goldens test/golden     # after any UI change, then look at the PNGs
dart run build_runner build -d                # after changing a freezed model or a @riverpod provider
flutter build macos --debug && open build/macos/Build/Products/Debug/Quarterdeck.app
dart run tool/check_gitlab.dart                # live GitLab check through glab, no UI
dart run tool/check_github.dart                # live GitHub check through gh, no UI
```

## Skills

- `deck-ui-change`: any visible change, verified with golden screenshots.
- `deck-provider`: add or change a provider, its fetch, records and card rules.
- `deck-insights`: report on Deck's background sessions (failures, speed, cost,
  issues they reported) and propose prompt and bug fixes.

Notes:
- The app listens on port 4777. Stop it before launching another: `pkill -f Quarterdeck.app/Contents/MacOS/Quarterdeck`.
- Live data is in `~/.deck`. `cache/` can be deleted; `state/` is the user's data (git repo), never delete it.
