# Deck: backlog

The single list of what Deck does not do yet. `DESIGN.md` holds goals, non
goals and decisions. Gaps against `/morning` and `/evening` were compared on
2026-10-15 against `~/.claude/skills/morning/SKILL.md` and
`~/.claude/skills/evening/SKILL.md`.

## Already covered

- GitLab MRs (authored, assigned, review), direct through glab, 0 tokens.
- GitHub PRs (authored, assigned, review requested, reviewed), direct through gh, 0 tokens.
- Task boards per project: Jira, GitLab issues (glab), GitHub issues (gh), assigned to you.
- Jira issues, Slack asks, mail asks (Claude judges each one).
- Todos (`deck_add_todo`) and triage (pin, urgent, boost, snooze, done, note).
  Replaces a todo.md backlog and the morning carry forward: triage
  state persists in `~/.deck/state`.
- Card actions (Claude, IDE, review, draft), click tested 2026-10-15. Each
  project can set its own IDE command.
- Calendar (2026-10-15): next 24 hours above the board, join button, alarm
  before every accepted meeting (bell turns it off for one). The alarm chime
  loops until Stop or Join (2 min cap), plays through Focus modes, and brings
  Deck to the front.
- Todos say where they came from (Slack, mail, MR, ticket, meeting) and open
  the original in one click.
- Auto close (2026-10-15): a todo linked to an MR is done once the MR is
  merged (`state` and `merged_at`, direct GitLab call). Open Slack and mail
  asks are read again each refresh and closed when you replied. Closed cards
  go to the Done view with the reason; "Mark Not Done" keeps them open.
- Activity log (2026-10-15): `state/activity/YYYY-MM.jsonl`, read and written
  through `deck_activity` and `deck_log_activity`. A card's Claude button
  starts the session with `--session-id`; the card shows "working", "waits for
  you" or "idle" and Claude's last line.
- Inbox triage (2026-10-15): Haiku sorts the whole inbox (ask, FYI, noise,
  phishing). Noise is one card per sender with **Make Gmail Filter** (opens
  Gmail's filter form with From filled, then archives what is there), so Gmail
  does the filtering from then on. FYI and asks have **Archive**. Archiving is
  a separate Claude run with only `unlabel_thread`, given ids by Deck. The old
  `email-triage` noise rules became `~/.deck/mailFilters.xml` (one time import).
  GitLab, GitHub and Jira notifications about a card already on the board are
  archived with no card (Haiku reads the key or MR number, Deck matches it);
  @-mentions stay as asks. Those senders never get a filter button.
- Activity view (2026-10-15): day, week, month and year from the activity
  log, counts per kind, lines grouped by day (by month for a year). Claude
  writes a standup (day) or a review (longer) on demand, with no tools, about
  1 cent; saved in `cache/summaries/`, copy button.
- Fresh calendar before alarms (2026-10-15): the calendar is fetched alone
  10 min before each alarm still to come (accepted or not), so a moved or
  newly accepted meeting rings on time.
- Meeting notes (2026-10-15): a Mail option (your name). A task of its own
  in the Mail run reads Gemini notes mail (it skips the inbox). Haiku copies
  the "Suggested next steps" text; Deck keeps the steps with that name (full
  or first name) and adds each once as a todo, "Meeting · <title>", opening
  the notes mail.
- Project info (2026-11-03): adding a project reads its folder with Haiku
  for the product name, other names and icon. Slack and mail are tagged with
  the project by name. The icon shows in the project chips, both sidebars and
  terminal tabs. Not tried live yet.

## Skim in Deck (branch feat/skim-code)

Port every feature of Skim (`paillardf/skim-review`, the code review UI for
big AI written merge requests) into Deck, shown natively, no browser page.
Decisions: Dart port of Skim's core (no Node server), Deck starts Claude
itself and talks to it through threads, diagrams drawn natively. See
DESIGN.md "Code review in Deck".

1. **M1, project page and map (done, map run not tried live yet).** `/project/:id` from the board
   sidebar. Map: Skim's `.skim/map/` format read and written by Deck
   (`data/map_store.dart`, Skim's map tests ported), the 9 map tools on the
   Deck MCP with Skim's names, a Draw/Update Map button that runs the
   skim-map steps in a background session (Settings: "Model for code",
   Opus 5.5 by default), native class graph, sequence player and state
   diagrams. Merge Requests: every open MR of the project, yours and asked
   reviews marked, Start Review still opens the terminal skill. Deck has one
   review action and one review command setting, no round two.
2. **M2, read only review (built 2026-10-17, not tried on a live MR yet).** Port Skim's diff pipeline (three git diffs,
   moved lines from `--color-moved`, big hunks split at declarations, noise
   tags and `.skim.yml`), then the review screen: files, tree and chapters,
   one line per file and per hunk, overview (MR text, CI, stats, weight bar),
   word level diff, unified pairing, syntax highlight.
3. **M3, full review (built 2026-10-20, not tried live yet).** Threads under
   their line and in an inbox, a new one from the sign column (shift for a
   range). Findings written by the review session, Find issues runs them
   again. Claude answers a waiting thread by resuming the review session;
   Fix now commits in a worktree on the head. Publish with a preview to
   GitLab and GitHub. Start Review on a published review pulls the forge's
   replies, then Start round N reads only the code pushed since. Board cards
   open the review in Deck. Skim's sqlite reviews are not migrated (DESIGN.md).
4. **M3 left.**
   - Live checks, in this order: findings on a real MR; Ask Claude and
     Fix (the `--resume` session and the Edit permission paths); a first
     publish on a throwaway MR, both forges; a push, then round 2.
   - Live checks of the talk plus answer threads (2026-11-02): Accept and
     Reject on both kinds of review, Fix then Push, publish of an answer as
     a reply, Open the session in a terminal.
   - Opening the review again force fetches `skim/mr-<iid>` and drops a fix
     not pushed yet: Push first (the fix bar says when one is waiting).
   - Range by drag, not only shift click. The inbox jumps to the file, not
     the line.
   - Pull reads 100 discussions at most (no pagination).
   - Local branch review (2026-11-12), not tried live yet: a review of a
     Claude worktree with edits not committed, Fix refused until they are
     committed. The diff only refreshes when the review is opened again
     from the Merge Requests page.

## Home redesign (branch feat/ui)

Decisions and why: `DESIGN.md`, entries of 2026-11-03. Mockups:
https://claude.ai/artifact/EfRod8VSrWG5izieqcw21K. Built 2026-11-03, steps
1 to 6 (types, Flow, sidebar and filter, Focus, project Overview, Talk).

Left:
- Live checks: the `task` and `lasting` fields on a real Slack and mail
  fetch; a Facts run on a real project (merged MRs through glab, then
  Haiku); a Talk session (Deck tools reached with `?talk=1`, Resume).
- Ranking across types is the old score plus triage. Check on a real day
  that Next puts the right card first.
- Merged MRs come from GitLab only; GitHub projects get Slack and mail
  updates but no merged PRs yet.

- Documents on the Overview (2026-11-05): not tried on a live Slack or mail
  fetch yet. Check that Claude fills `docs` and skips MR and ticket links.

Open: should a fact change (code freeze moved) also become a board card?

- Team asks and tickets (2026-11-20), not tried live yet: Slack searches each
  project channel (`in:#channel`) for bug reports and requests to the team
  (`team` records, a "Team" tag); an ask about a ticket or MR on the board
  goes on that card as a note; a team report an open Jira issue already
  tracks makes no card. Make Ticket on Slack, mail and meeting task cards
  (GitLab and GitHub through glab and gh, Jira through a run that only
  creates the issue). Check: the cost of the channel searches, that chatter
  stays out, a ticket made on each board kind.
- Decline on your own MR (2026-11-20): Reject on a reviewer's thread asks
  Claude for the reply that says why (`Decline it.`) and that reply goes out
  accepted. Not tried live yet.

## Release (open source, GitHub)

Decided 2026-11-20: Deck stays on GitHub and goes public, no app stores.
Builds come from GitHub Actions (free macOS runners for public repos) and
go to GitHub Releases. macOS, Linux and Windows build from the start; Linux and
Windows are labelled experimental until someone uses them daily.

Done 2026-11-20 (branch `release-prep`): `.github/workflows/release.yml`
(written, not run on GitHub yet), MIT LICENSE, root README with the risk
warning, internal names replaced in prompts, hints, tests and docs, Node
prototype and internal notes removed, bundle id
`io.github.paillardf.quarterdeck`. Done 2026-11-24: history squashed into one
commit and the GitHub repo recreated, so no earlier commit is reachable.

Done 2026-11-24: the workflow ran green on all three platforms (Linux and
Windows built, never launched). Release assets have fixed names
(`Quarterdeck-macos.dmg`, `Quarterdeck-linux-x64.tar.gz`,
`Quarterdeck-windows-x64.zip`) so `install.sh` and `install.ps1` fetch
`releases/latest/download/<name>`. The scripts install or update the app, then
offer Claude Code, the `deck` MCP server, `gh` and `glab` with their logins.

1. **First release.** Tag `v0.1.0`, then run both install scripts on a clean
   machine per platform.
2. **MCP server hardening.** `127.0.0.1:4777` has no authentication and no
   Origin check: any local process, and maybe a web page posting to localhost,
   can call it. Refuse requests with a browser Origin, then consider a token
   in the URL that `claude mcp add` carries.
3. **First run.** A one time screen with the README warning (background
   Claude runs, what they read, cost, budget) that the user accepts, then
   which of `claude`, `glab`, `gh` are found and logged in, and whether port
   4777 is free (`onPath` exists).
4. **Update check, after the first update ships.** Built on
   `feat/auto-update` (see DESIGN.md, "Updates in one click"). Left: release
   a version with it, then a newer one, and update for real on macOS, Linux
   and Windows; the scripts' app-only mode and PID quit were only tested in
   pieces.
5. **Homebrew tap.** `paillardf/homebrew-tap`, `brew install --cask
   paillardf/tap/quarterdeck`, updated by the release workflow.
6. **Linux and Windows gaps.** Alarm chime and bring to front use `afplay`
   and `osascript` (`state/alarms.dart`). Chrome profiles read `HOME` and have
   no Windows path (`sources/chrome.dart`), reuse `userHome`. Windows IDE
   launch through a shell (`runInShell`) can break or inject on odd folder
   names. One test pass per platform in a VM before calling them supported.
7. **Developer ID, next steps.** Done 2026-11-24: the release workflow signs
   (hardened runtime) and notarizes the app and the DMG through
   `app/tool/package_macos.sh` (secrets `MACOS_CERT_P12`,
   `MACOS_CERT_PASSWORD`, `APPLE_API_KEY_P8`, `APPLE_API_KEY_ID`,
   `APPLE_API_ISSUER`; the certificate expires 2027-12-24). Left: Sparkle
   (`auto_updater`) for in-place updates, and
   `UNUserNotificationCenter` banners during Focus.

Later: AppImage, Scoop/winget manifests, AUR, a Claude Code plugin that
installs Deck and registers its MCP server.

## Next (recommended order)

1. **Generated detail panels.** Claude fills a card view from a fixed
   component catalog. First use: the meeting prep panel below.
2. **Meeting prep panel.** On demand from a calendar card: Slack and mail with
   the attendees (7 to 14 days), past notes, related MRs. Only for meetings of
   30 min or more, or 3+ attendees.
3. **Stale todo cleanup.** Propose and confirm, never auto drop. Groups: older
   than 4 weeks with no movement, past deadline, superseded by a merged MR or
   closed issue, Sentry sprawl (consolidate), old noise older than 1 week.
   Never touch items added today.
4. **Linked cards move together.** Your triage follows links down from the
   ticket, never up: snooze or pin a ticket and its MRs and messages follow;
   done on a ticket offers to close them too; a message marked done changes
   nothing else. Hovering a card highlights its linked cards. Later, if three
   cards still read as noise: fold them under the ticket.
5. **Menu bar status and global shortcut** (`tray_manager`, `hotkey_manager`).
   Notifications already use `local_notifier`.
6. **Runs and issues in Settings › Claude.** The run ledger and reported
   issues (`cache/runs/`) are only read by the `deck-insights` skill today: a
   list with failed runs first, why, Show transcript, Resume; issues with Mark
   fixed.
7. **App log.** `FlutterError.onError`, `PlatformDispatcher.onError`, provider
   fetch and MCP server errors to `cache/logs/deck-<date>.log`; today they go
   to `debugPrint` and are lost.
8. **From deck-insights 2026-11-23** (`~/.deck/cache/insights/2026-11-23.md`):
   - Jira workers call `getAccessibleAtlassianResources` on every run (138 a
     week, 4 searches failed with no cloudId): learn the cloudId once, pass it
     in the task input.
   - No worker runs on a dark wake: 74 timeouts in one weekend came from runs
     started while the Mac slept (no network, or Deck's MCP server not
     answering). Wait for a minute of real wake and network before an
     overdue run.
   - Review: `get_diff` with default tags can return 143k chars on one line,
     above the tool-result limit; page or split it.
   - Review: generated tags miss Pigeon `.g.swift` and wrongly hide the
     hand-written `shared/api.d.ts`.
   - Review: ticket detection takes "ADR-004" in an MR title for a ticket.
   - Review: the head moved mid-session when uncommitted changes were folded
     into a synthetic head (21 files became 41).
   - Review: no documented path for a follow-up fix after the first fix
     commit was set aside.
   - Map: `set_map_architecture` refuses glob paths; say so in the tool
     schema, or expand globs.
   - Mail: `get_thread` returned 61 KB for one thread; ask for a shorter
     format when only the reply check is needed.
   - Ledger lines before 2026-11-23 hold the cumulative cost of resumed
     sessions; `digest.py` overstates review cost for them.

## Later / maybe

- **Activity history before October 2026.** The log starts 2026-10-15
  (sessions from 2026-10-01). Month and year views need a one time backfill:
  merged MRs and approvals from GitLab, meetings from the calendar, sessions
  from older transcripts.
- **Project filter in the Activity view.** The board's project chips do not
  apply there yet.

- **GitHub provider** against a real connector.
- **Mail rules learned in Deck.** Today a noise sender needs one Gmail filter
  click. A sender judged wrong (an ask marked noise) has no fix but the card
  menu. Maybe a "Not noise" action that tells the next fetch.
- **Slack channel pulse.** Decisions and active threads in the user's channels,
  not only asks to the user. Costs more Haiku runs; maybe a digest panel.
- **Day review.** Merged MRs, MRs opened or reviewed, sent mail, Claude session
  digest (`~/.claude/skills/daily-report/scripts/digest_sessions.py`). Could be
  a "Today" panel.
- **PO build report.** Merged changes per platform in plain words, verified per
  MR, sent to a Slack channel on confirm. Action on the day review panel.
- **claude.ai mirror** for away from the Mac (sync through the git backed state).

## Out of scope (non goals)

Deck is "not a journal" and has "no SilverBullet". These stay in the skills,
or become an optional export later:

- Daily note (`journal/`), end of day summary. (The raw activity log is
  in Deck; the written note is not.)
- Meeting prep and outcome files (`meetings/`).
- Topic page updates and the brain dump list.
- Personal journal (`perso/journal/`).
