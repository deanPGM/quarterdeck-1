---
name: deck-provider
description: "Add or change a Deck data provider (GitLab, GitHub, Jira, Slack, Mail, Calendar...) or its card rules: how it is fetched (direct CLI call like glab or gh, or background Claude task), the record shape, the classifier, the Settings options. Use when touching app/lib/core/classify, app/lib/claude/tasks.dart, app/lib/sources, or providers_catalog.dart."
---

# Add or change a Deck provider

Principle: the less work the AI does, the better. Prefer a direct call to a
command line tool the user is logged in to (glab, gh: 0 tokens). Use the background Claude session only for what
needs a claude.ai connector or judgement. See `DESIGN.md`, "Decisions and why".

## Steps

1. **Catalog.** Add or edit the entry in `app/lib/core/providers_catalog.dart`:
   id, name, description, supported access modes (best first), options shown
   in Settings. Add its icon and color in `_providerIcons`
   (`app/lib/ui/settings/settings_screen.dart`).
2. **Record.** Define or reuse a record in `app/lib/core/models/records.dart`.
   Records from Claude are part of the Deck MCP contract: keep field names
   stable, document each field.
3. **Classifier.** Pure function in `app/lib/core/classify/`: record + `now` →
   `DeckCard` (bucket, score, one line `next`, tags). Add cases to
   `app/test/core/classify_test.dart` with the exact expected `next` text.
4. **Fetch.**
   - Direct: a source in `app/lib/sources/` that runs the CLI with
     `shellEnvironment()` (see `gitlab_source.dart`). Fetch details only for
     items that changed. Add a live check in `app/tool/` like `check_gitlab.dart`.
   - Background Claude: a `taskFor` case in `app/lib/claude/tasks.dart`. The
     app writes the exact queries and the record fields; Claude must not plan.
     Allowed tools: read only (the worker reads untrusted text), never send,
     post or write tools.
5. **Ingest.** Map the provider in `Board._ingest` or the direct refresh in
   `app/lib/state/board.dart`. Messages merge since the last fetch; lists
   (MRs, tickets) replace.
6. **Projects.** If cards should match a project, extend `projectsOf` in
   `app/lib/core/projects.dart`.
7. Run `dart run build_runner build -d`, `flutter analyze`, `flutter test`,
   then one real refresh against the user's account and report the cards it gave.

## Measure

Report time and cost of one real refresh. Background runs log both in
Settings → Claude → Recent runs. A direct source should stay under a few
seconds and 0 tokens.
