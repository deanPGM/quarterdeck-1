---
name: deck-insights
description: "Review the Claude sessions Deck ran in the background (workers for Jira/Slack/mail/calendar, map, review, project info, summary, facts) and report what fails, what is slow, what costs, and the issues sessions reported with deck_report_issue; then propose prompt fixes, speed ideas and bugs to fix. Use when the user says /deck-insights, 'review Deck's sessions', 'why do background runs fail', 'how can the Deck prompts be better', 'what did sessions report', or asks for an insights report on Deck."
---

# Deck insights

A report on Deck's own Claude sessions, like `/insights` for the user's work,
to make the prompts better, the runs faster and to fix what breaks. Read
`DESIGN.md`, "Run ledger for every Claude session Deck starts", for where the
data comes from.

## Data

All of it is collected only while Settings › Claude › Keep a run log is on
(`claude.collectRuns` in `~/.deck/deck.json`, off by default). When the digest
finds no runs, say so and ask the user to turn it on, then come back later.

- **Run ledger** `~/.deck/cache/runs/YYYY-MM.jsonl`: one line per run (kind,
  subject, outcome, seconds, cost, tokens, turns, tool calls and errors,
  refused tools, MCP servers that failed, stderr tail). Since 2026-11-17.
- **Raw logs** `~/.deck/cache/runs/logs/<id>.log`: the stream JSON and stderr
  of each run, 30 days.
- **Reported issues** `~/.deck/cache/runs/issues.jsonl`: what sessions said
  got in their way (`deck_report_issue`), with run, project, review and ledger id.
- **Transcripts** `~/.claude/projects/<folder>/<session>.jsonl`: workers run in
  `~/.deck/cache/worker`, map and review sessions in the project folder (the
  ledger line has `dir` and `sessionId`). Summary, facts and rule advice keep
  no transcript: their raw log is the only record.
- **The prompts**: `app/lib/claude/tasks.dart` (worker tasks per provider),
  `map_task.dart`, `review_task.dart`, `project_info_task.dart`, `summary.dart`,
  `facts.dart`, `rule_advice.dart`, the MCP tool descriptions in
  `app/lib/mcp/*.dart`, the record checks in `app/lib/state/board.dart`
  (`submit`).

## Steps

1. **Digest.** Run `python3 .claude/skills/deck-insights/scripts/digest.py --days 7`
   (another period if the user asked). It prints per kind: outcomes, time
   p50/p90, cost, tool calls, tool errors grouped by text, tool latency, the
   issues, the runs worth reading (`toRead`), and `previous` (the last digest)
   for the trend. It saves itself to `~/.deck/cache/insights/<date>.json`.
2. **Read the evidence.** Do not report from numbers alone. For the top error
   groups and the `toRead` runs, open the transcript or raw log (with
   `grep`/`sed -n` on the relevant lines, they are large) and find what the
   session was doing when it went wrong: which instruction it misread, what it
   retried, where the time went. Read 5 to 10 runs, more when a cause is
   unclear. Use subagents for this when there are many to read.
3. **Read the prompt behind each problem**: the task's instructions in
   `tasks.dart` or the session's prompt file, and the tool description.
4. **Sort every finding** into one of:
   - **Bug**: Deck is wrong (a tool fails, a check refuses good records, the
     MCP server drops the call). Name the file and what to change.
   - **Prompt**: the session misread or guessed. Quote the instruction and give
     the new wording.
   - **Speed / cost**: too many calls, a slow tool, a bigger model than needed,
     tool search on every run, a task that a CLI call could do with 0 tokens
     (see the "less AI work" principle in `deck-provider`).
   - **Environment**: not Deck's fault (the Mac slept, a connector is logged
     out). Say what the user can do, or how Deck could say it better.
5. **Report** in chat, in this order, short:
   - One line: runs, failure rate, cost, and the trend against `previous`.
   - A table per kind: runs, failed, p50/p90 time, cost.
   - Top findings, most impact first (runs affected × cost of each failure):
     what, evidence (counts plus one example with the transcript path), the
     fix. At most 8.
   - The reported issues not covered by a finding, one line each.
   Save the same text to `~/.deck/cache/insights/<date>.md`.
6. **Act.** Ask which findings to apply. Prompt and small bug fixes: make them
   (follow `deck-provider` or `deck-ui-change` when they apply, run
   `flutter analyze` and `flutter test`). Larger ones: add to `BACKLOG.md`.
   Never edit the ledger, logs or issues.
7. **Prune what does not pay.** The collection is on trial: list each ledger
   field, the raw logs, `deck_report_issue` and each digest section that no
   finding used in this report, and in the previous ones saved in
   `~/.deck/cache/insights/`. Something unused in 3 reports in a row: propose
   removing it from `run_log.dart`, `worker.dart`, `ask.dart`, the MCP server
   or `digest.py`.

## Notes

- A worker run is one Claude session over a batch of tasks; its subject is the
  providers. `review:<kind>` and `map:<part>` are the long code sessions.
- `deck_submit` refusals are Deck's record check in `board.dart`: a refusal
  means either the prompt asks for a shape the model gets wrong, or the check
  is too strict. Look at which field.
- "MCP tool mcp__deck__deck_permission ... not found" means the session never
  reached Deck's MCP server (Deck closed or restarted while it ran).
- Long gaps with no events at night are usually the Mac asleep, not a slow tool.
