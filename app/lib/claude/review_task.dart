// What a review session does: steps 1 to 4 of Skim's skim-review skill
// (skills/skim-review/SKILL.md), adapted to a session Deck starts in the
// project folder for one merge request, with no one to answer. Step 4 runs
// alone too ("Find issues"). Keep the steps in sync with Skim's.

/// Steps 1 to 3c: what the change is, before any finding.
const _prepareSteps = r'''
You are preparing the review of one merge request in Deck, for the reviewer
who will read it there. Work alone: nobody answers questions in this session.
The review tools of the Deck MCP server are already set to this review. You
may read the project with Read, Grep, Glob and read only git commands. Never
edit a file and never post anything to GitLab, GitHub or Jira.

Do steps 1 to 4 below, then stop with one paragraph: what the change does
and what the reviewer should read hardest.

## Step 1: open and size up

Call `get_review`. It returns the repo, the refs, the head sha, stats and how
many files are hidden by default. Tell the user in one line what you are
reviewing and how much is hidden.

Then call `get_ticket`, before the diff: the ticket says what the change was
supposed to do, and you read the code against it. Three answers:

- `fetched`: read the text. Keep it in mind for every step below.
- `no_text` or `partial`, with a `todo` line per ticket. Deck never fetches a
  ticket itself, so this is your job: fetch it with whatever reaches it, a
  Jira or GitHub MCP tool, `glab issue view`, `gh issue view`. Then
  `set_ticket(ref, body, title)` with the description, the acceptance
  criteria and the comments that matter, as plain text, so the reviewer sees
  it in Deck. When you have nothing that reaches it, tell the user in
  one line and go on without it.
- `none`: no reference anywhere. Say so in one line and go on.

Call `get_diff` with the default hidden tags. Files tagged `generated`,
`lockfile`, `formatting-only` and `moved-only` are not returned. Do not ask
for them unless a visible change depends on one.

If the visible diff is over about 3,000 real lines, read it file by file
with `get_file` rather than all at once.

## Step 1b: does the change do what the ticket asks?

Only with a ticket that has text. Read the ticket, then the diff, then call
`set_ticket_check(ref, verdict, summary, items)` once. It is the first thing
the reviewer sees, above the chapters, and it goes into the published summary.

- One item per requirement or acceptance criterion the ticket states, in the
  ticket's words: `done` with the `paths` that do it, `missing` when no hunk
  does it. A requirement half done is `missing` with the half that is not.
- One `extra` item per topic the diff does that no requirement explains, with
  its paths. One per topic, not per file: a refactor touching six files is one
  item. Tests, translations and wiring the requirement needs are not extra.
- `verdict`: `fulfilled` when nothing is missing, `partial` when something
  is, `not_addressed` when the diff does something else, `unclear` when the
  ticket is too thin to list requirements. Then `items` still lists what the
  diff does as `extra`, so the reviewer sees the scope.
- `summary`: two or three sentences, the verdict first in plain words, then
  what is missing. "Does what APP-231 asks, except the retry on 429, which
  is not in the diff." Nothing the items already say.

Do not write findings yet: this pass describes the change, the check carries
what is missing. Findings come in step 4.

## Step 2: one line per file

For every visible file call `set_file_note(path, summary)`. One sentence,
what changed and why it matters, under 120 characters. Name the symbol, not the
line count. Examples:

- `New LRU cache, disk backed, 200 MB cap, evicts by last access`
- `fetchTrack reads the cache first, deleteTrack invalidates after the network call`
- `Wrapped body in SafeArea, no logic change`

`extra_tags` is the second half of the job, and the reviewer feels it more
than the summaries. Every tag becomes a chip in the sidebar that hides every
file carrying it in one click, next to the classifier's own `generated` and
`lockfile`. So tag the **kind of change**, not the topic: name what a
reviewer could decide to skip as a group.

- `translations`, `build-system`, `dependency-bump`, `api-client`,
  `fixtures`, `config`, `dead-code`, `migration`, `public-api`
- kebab-case, one or two words, and reuse a tag you already used in this
  review rather than inventing a near synonym: two chips for one idea split
  the group and the click stops working
- only what is true of the whole file, and at most two or three per file
- never restate a classifier tag (`test`, `docs`, `ci`, `generated`,
  `lockfile`, `binary`, `large`, `formatting-only`, `moved-only`,
  `rename-only`)

A merge request with 40 changed `.arb` files and 6 real ones should end with
`translations` on the 40, so the reviewer hides them and reads 6.

Hunks arrive already split at declaration boundaries: four methods added next
to each other are four hunks, and a long test group is one hunk per test. So a
hunk is usually one thing, and it deserves one line. Call
`set_hunk_note(path, hunk_ref, summary)` for every hunk over roughly ten
lines, and for every large comment or doc block. `hunk_ref` comes from
`get_diff`. Pass `notes: [...]` to send a whole file's hunk notes in one call
rather than one call each; `set_file_note` takes the same `notes` array.

The reviewer reads that line above the hunk and decides whether to open it, so
write what they would have learned by reading it, not a label:

- `Adds VPN_SERVICE_EXE to the brand table, with why it is not the SCM name`
- `New test group: the exe filename must agree in brand.h, CMake and the csproj`

## Step 3: reading order

Call `set_groups` once with the whole change split into chapters in the order
a reviewer should read them:

1. The core change: the two or three files that are the idea.
2. Consequences: call sites, models, UI that follow from it.
3. Tests.
4. Glue: wiring, registration, config, localisation.

Each group has a `title`, a two sentence `overview`, and `items` with `path`
and optionally `hunk_ref` (from `get_diff`) when only part of a file belongs.
With a ticket, the overview of a chapter says which requirement it serves, in
one clause: "The cache itself, AC-01 and AC-02." A chapter no requirement
explains says so: "Not in the ticket." That is often the chapter to read
hardest.
Every visible file belongs to exactly one group. Files you cannot place go in
a last group named "Unclear" with a note saying why.

## Step 3b: the features, one tab each

Call `set_features` once, when the change has a shape a reviewer would
otherwise rebuild in their head from four files. The features appear as tabs
above the chapters, so they are the first thing the reviewer sees.

A feature is one thing the change does for its user: "tracks cached on disk",
"a settings screen for the cache size". Most merge requests do one thing: pass
one feature. When the change does several unrelated things, pass one feature
per thing, so each tab tells one story. Glue (wiring, config, translations) is
never a feature of its own.

Each feature has a `title` (the tab label, a few words), a `summary` (one or
two sentences) and up to two pictures. Draw the code **as it stands after the
change**, never a before and after. Stay under about fifteen boxes or arrows
per picture: a picture of every file is the wall the chapters just replaced.

### The class graph

`graph` is the classes the feature touches and how they relate, as data. Deck
draws it as a class diagram, coloured by status, and the reviewer clicks a box
to read your notes on it.

- `nodes`: one per class, interface or module, `name` as the code names it.
  `status` is `added`, `changed` or `removed` for what this change did, or
  `context` for an unchanged class the others need to make sense (the
  interface a new class implements, the caller of a changed method).
- `edited`: one or two sentences, what this change did to it. This is what
  the reviewer clicks for, so say the change, not the class: "Now evicts past
  200 MB, oldest first" beats "Cache class". Empty for context.
- `role`: one sentence, what it is for in this feature.
- `path` and `line`: where it lives in the diff. Leave them out for a context
  class outside the diff.
- `edges`: `from`, `to` (node names), `kind`, and an optional `label` of a few
  words, such as the method called. `extends` and `implements` for types,
  `owns` when one holds the other, `uses` for a dependency, `calls` and
  `creates` for what happens at runtime.
- `caption`: one line under the graph, what to take from it.

### The sequence

`sequence` is the calls the feature makes, as mermaid `sequenceDiagram`
source: a request end to end, a feature from the tap to the store. Put the new
or changed steps inside a `rect rgb(218, 251, 225)` block, the green the diff
uses. Use exactly this colour: in dark mode Deck swaps it for a dark one. Leave
the theme to Deck: a `%%{init}%%` or front matter theme has no effect. Name
participants after symbols that exist in the diff.

**A sequence gets `steps`, so the reviewer can play it.** Deck turns it into a
player: one numbered row per arrow, Play, ← →, and beside the picture every
step with your comment, the current one open. Pass one entry per arrow, in
source order (notes, `rect`, `alt`, `loop` lines are not arrows). Deck numbers
the rows itself; leave `autonumber` out, Deck
drops it anyway.

- `title`: a few words, what happens. "Server asks for the branch name".
- `detail`: one or two sentences, how it happens in this change.
- `why`: only when the reviewer would not see it: the risk, the reason.
- `path` and `line`: where the step lives in the diff, so the comment links
  to the code. The path must be a file of the diff.
- `mark`: `touched` for the steps this change added or changed (the same ones
  inside the green `rect`), `concern` for the one or two a reviewer should
  read hard. Most steps have no mark.

Use the sequence features that carry meaning: `alt`/`else` for the error path,
`opt` for a step that may not run, `loop` for a retry, `Note over` for what a
participant does that is not a call. A count that does not match the arrows
puts comments on the wrong arrow, and Deck says so under the picture.

The `caption` of either picture is one line: what the reviewer should take
from it, not a title.

```
set_features(features: [
  {
    title: "Tracks from disk",
    summary: "Tracks now come from a disk cache first; the network is the fallback.",
    graph: {
      nodes: [
        { name: "TrackCache", status: "added", edited: "New. Reads and writes tracks under their id, evicts past 200 MB.", role: "Keeps played tracks on disk.", path: "cache/TrackCache.kt", line: 12 },
        { name: "Player", status: "changed", edited: "Asks the cache before the network.", path: "player/Player.kt", line: 88 },
        { name: "Network", status: "context", role: "Fetches track bytes." }
      ],
      edges: [
        { from: "Player", to: "TrackCache", kind: "calls", label: "get(trackId)" },
        { from: "TrackCache", to: "Network", kind: "uses", label: "fetch on miss" }
      ]
    },
    sequence: {
      mermaid: "sequenceDiagram\n  participant P as Player\n  participant C as TrackCache\n  participant N as Network\n  P->>C: get(trackId)\n  rect rgb(218, 251, 225)\n    C->>C: lookup on disk\n    C->>N: fetch on miss\n    N-->>C: bytes\n  end\n  C-->>P: track",
      caption: "Disk first, network on a miss.",
      steps: [
        { title: "Player asks for a track" },
        { title: "Lookup on disk", detail: "TrackCache reads the file under its id.", path: "cache/TrackCache.kt", line: 41, mark: "touched" },
        { title: "Fetch on miss", detail: "Only when the file is absent.", why: "No timeout here, so a slow network blocks playback.", mark: "concern" },
        { title: "Bytes come back", mark: "touched" },
        { title: "Track returned" }
      ]
    }
  }
])
```

Pass the graph, the sequence or both, whichever shows the feature: a new class
hierarchy needs only the graph, a new request path only the sequence.

**Skip the call when there is nothing to draw**, and say nothing about it: a
rename, 40 translation files, a dependency bump, a change inside one function.
A picture of a change with no shape costs a screen and teaches nothing.

## Step 3c: the triage

Call `set_checklist(items)` once, after the chapters. It sits on the overview,
above them: the questions a reviewer would ask before opening a single file,
already answered.

- Six items at most, and only questions this change actually raises. A
  two file change with a test does not need a triage; skip the call.
- `text` is the question in a few words: "tests for the new cache".
- `evidence` is what you found, in one line, never a promise to look. "b.txt
  and the cache have no test" beats "should check the tests".
- `state`: `ok` when the evidence settles it, `concern` when it does not,
  `unclear` when the diff cannot say (runtime behaviour, a service outside
  the repository).
- `paths` are the files that back it, so the reviewer jumps from the line to
  the code. They must be paths of the diff.

Most of it is already computed. `get_diff` tags files `test` and `ci`, so read
the tags rather than guessing. Questions worth an item: a changed public symbol
with no test, CI or build files touched, a helper added that duplicates one
that exists, a migration, a dependency added, a public API changed.

A `concern` here is not a finding. It says where to look.
''';

String reviewPrompt(List<String> skills) => '$_prepareSteps\n${findingsStep(skills)}';

/// The first message of a terminal session opened on a review: the user
/// wants to talk about the merge request at length.
const talkPrompt = '''
We are going to talk about the merge request of this Deck review. The review
tools of the Deck MCP server are set to it. Call get_review, then read the diff
with get_diff. Give me a summary in five lines at most, then wait for my
questions. Never post anything to GitLab, GitHub or Jira.
''';

/// The first message when the terminal is opened from one thread. [where] is
/// "path:line", or null for a thread on the whole change.
String threadTalkPrompt(String id, String? where, {required bool fresh}) =>
    '''
${fresh ? 'We are going to talk about one thread of the merge request of this Deck review. The review tools of the Deck MCP server are set to it. Call get_review first. ' : ''}Let us talk about thread $id${where == null ? '' : ' on $where'}. Call list_threads and read that thread with all its messages, then read the code around it. Tell me in a few lines what is asked and what you think, then wait for my questions. Never post anything to GitLab, GitHub or Jira.
''';

/// Your own merge request: the same picture of the change, to answer your
/// reviewers with it, but no bug hunt.
const analyzePrompt =
    '''
$_prepareSteps
This is the user's own merge request: they read this analysis to answer their
reviewers. Do steps 1 to 3 (with 1b and 3b) only. Skip step 4: write no
findings. Stop with one paragraph: what the change does.
''';

/// Step 4 alone, on a review already prepared: the reviewer pressed Find issues.
String findingsPrompt(List<String> skills) => '''
You are reviewing one merge request in Deck for bugs, for the reviewer who
reads it there. Work alone: nobody answers questions in this session. The
review tools of the Deck MCP server are already set to this review. You may
read the project with Read, Grep, Glob and read only git commands. Never
edit a file and never post anything to GitLab, GitHub or Jira.

The review is already prepared: `get_review` returns it, with file notes,
chapters and the ticket check. Call `get_review`, `get_ticket` and
`get_diff`, then do step 4 below, then stop with one line: how many findings
you added.

${findingsStep(skills)}''';

/// Skim's step 4. The bug hunt is the review skills set in Settings
/// (/code-review by default), run headless as forked skills that return their
/// findings as text. With none set, the method written out below.
String findingsStep(List<String> skills) => '$_findingsHead${skills.isEmpty ? _ownMethod : _skillsMethod(skills)}$_findingsRules';

const _findingsHead = r'''
## Step 4: findings

Call `list_threads` first. Never add a finding that is already there (same
point on the same lines, whoever wrote it), and never touch the reviewer's
own threads.

''';

String _skillsMethod(List<String> skills) =>
    '''
Run each review skill below with the `Skill` tool, one after the other. Give
it its arguments as written, then the range of the change: `<base sha>...<head
sha>` from `get_review`, or in a round the last published head `...` the
current head, from `get_round_delta`. A skill returns its findings as text.
It only reports: never let it post, edit or fix anything.

${[for (final s in skills) '- `/$s`'].join('\n')}

Each finding a skill returns is a candidate, not a thread yet. Drop the ones
on files `get_diff` hides, then take the rest through the rules below, with
your own reading of the ticket.

''';

const _ownMethod = r'''
Review the visible diff for bugs: correctness first, then reuse and
simplification. Nothing you write reaches GitLab until the reviewer
publishes, and they reject what they disagree with, so a false positive costs
a click and a missed bug costs a round. Cover the ground:

- **Correctness.** Logic and conditions, off by one, null and empty cases,
  error paths that swallow or leak, async ordering and races, resources not
  closed, state that outlives its owner, security (input reaching a shell, a
  query, a path, a log), data loss.
- **Callers.** For every changed public symbol, `Grep` its callers: a changed
  signature or meaning breaks them silently.
- **Reuse.** A helper the diff adds that already exists in the repository
  (`Grep` for it). Name the existing one.
- **Simplification.** Code that does the same with much less, an abstraction
  with one caller.

Read the code, do not run it: no tests, no build, no type check. CI does that.

''';

const _findingsRules = r'''
With a ticket, the review reads the code against it, not only against itself.
Open the review with a brief, in your own words, three lines at
most: what the ticket asks, the constraints and edge cases it names, and
what the diff does beyond it (your `extra` items from step 1b). Then three
rules on top of correctness, in this order:

1. **Scope.** Code no requirement explains is a `question` thread on its
   first hunk: "Not in APP-231. Meant to be here, or a separate change?"
   One per topic, not per file, and only when the code is more than the
   wiring the requirement needs. A refactor the change depends on is not
   scope creep, say nothing. This is where over engineering shows: an
   abstraction with one caller, a config for a value the ticket fixed, a
   generalisation the ticket never asked for. Name the simpler shape in the
   finding, not as a fix.
2. **Requirements.** A stated requirement, edge case or constraint with no
   code and no test is a general thread (no `path`): `must-fix` when the
   ticket calls it an acceptance criterion, `suggestion` otherwise. Cite the
   ticket sentence. Skip the ones your ticket check already lists as
   `missing`: the check carries them, one place is enough. What belongs here
   is the finer grain: the requirement is done but a case it names is not
   ("survives a restart" done, the restart with a full disk not).
3. **Pitfalls.** A comment on the ticket that names a risk, a past bug or a
   "careful with" is a test the diff should pass. Read the code for that
   case specifically, and when it fails, the finding cites the comment.

Without a ticket, run the review as is.

Then a second pass that cuts false positives: go over every finding you have
in mind and try to prove it wrong from the code (a guard elsewhere, a caller
that never passes that value, a type that rules it out). Keep the ones that
survive, and every `must-fix` you still believe.

For each finding call `add_thread`:

- `path`, `line` (and `end_line` for a range), `side` (`new` unless the
  finding is about deleted code). Leave `path` and `line` out when the finding
  is about the whole change and no single line carries it: scope, a missing
  test, the wrong target branch. It publishes as a discussion on the merge
  request rather than on a line.
- `severity`: `must-fix` (bug, data loss, security), `suggestion` (better
  way, real cost), `nit` (style), `question` (you need the author's intent).
`body` is the comment exactly as it would be posted on the merge request,
written to the author: it becomes the thread's answer.

- `body` on a line: **40 words maximum.** One short sentence for what is
  wrong, one for what it costs. A `question` is the question alone. Cut what
  the reviewer has under their eyes: do not describe what the code does, do
  not quote it, do not list the cases, do not compare with the MR
  description. No parenthesis, no figures you did not read in the code, at
  most one `file:line` and only when the mechanism is in another file. No
  fix in prose. A `suggestion` only when it is a complete, compiling
  replacement of the anchored lines.
- `body` on the whole change (no `path`): the reviewer has no code next to
  it, so give what they need to judge, a short paragraph. Still no fix.

  Too long: "After the Pro taps the Settings button (page.dart:334) and grants
  the camera permission, coming back to the app fires `resumed` but
  `_permissionDenied` is never re-evaluated, so the error view stays on screen
  and the camera only works after closing and reopening the page. The denied
  state also does not distinguish a one-time refusal from a permanent one, so
  a first "deny" is sent straight to system settings."

  Right: "`_permissionDenied` is not re-checked on `resumed`. After granting
  the permission in Settings the error view stays until the page is
  reopened."

One message per finding, and stop there. Do not follow it with an example, a
rationale or a fix nobody asked for: the reviewer reads every thread, and the
ones they want more on they ask about with one click. Silence is the default.

Do not add threads on hidden files. Do not comment on formatting.
''';

/// The talk on each thread, for a session Deck resumes when the user asked
/// Claude something. [own]: the user is the author of the merge request and
/// answers its reviewers; otherwise the user is the reviewer. A fix is
/// committed in [fixDir], a working tree on [branch]; [fixError] says why
/// there is none.
String answerPrompt({required bool own, String? fixDir, required String branch, String? fixError, ({String provider, int iid, String path})? mr}) =>
    '''
The user asked you something in Deck. This turn you answer the threads that
wait on you, then stop. The review tools of the Deck MCP server are set to
this review. ${own ? '''The user is the author of this merge request: the threads are their
reviewers' comments, and the answer of a thread is the user's reply to the
reviewer.''' : '''The user is reviewing this merge request: the answer of a thread is the
comment they post to its author.'''}

## How a thread works

A thread has two parts:

- **The talk** (`messages`): what the user and you say to each other. Never
  posted. Messages with a `remoteId` or author `remote` are on the merge
  request already.
- **The answer** (`answer`): the one message the next publish posts, under
  the user's name. You write it with `set_answer`, the user may edit it.

Every thread you take ends with an answer the user can post as it is (or
none, when nothing should go out), and the talk handed back. `set_answer`,
`mark_fixed` and `reply` all hand it back.

The user accepts or rejects each answer in Deck (`decision`); only an
accepted one is posted. A new answer from you clears their call, so they read
it again: do not rewrite an accepted answer unless the talk asks for it.

Call `list_threads(waiting: true)`. Oldest first, take each one. Its last
message is the user's:

- **`Fix it now.`** See "Fix" below.
- **`Decline it.`** The user will not make the change the reviewer asks.
  Change no code. `set_answer` with the user's reply to the reviewer that
  says why the code stays as it is, from the code and the talk: **two lines
  maximum**, plain and friendly, no apology. It goes out as it is.
- **`Example?`** `reply` with the smallest case that goes wrong: the input
  or the sequence, then the wrong result. **Five lines maximum**, code
  included. For a point you could not settle, the case you could not settle.
- **`More context?`** `reply` with why it matters and how the code gets
  there, citing `file:line`. **Five lines maximum**.
- **`Possible fix?`** `reply` with one way to fix it, **three lines
  maximum**: the idea and what it costs. Attach a `suggestion` only when it
  is a complete, compiling replacement of the anchored lines.
- **`Shorter.`** `set_answer` with the same point in fewer words.
- **Anything else** is the user's question or context. Read the code with
  `get_file` or Read if needed, then `reply` with a direct answer. When the
  talk changed what should go out (you agree the point is wrong, smaller, or
  about something else), also `set_answer` with the new text, whole.

Text after the first line of a button message is the user's context: take
it into account.

## Writing style

Plain English, short sentences, no dashes mid sentence. Cite `file:line`.
In the talk: never restate what the user already read, answer and stop. In
an answer: written to ${own ? 'the reviewer, first person, no greeting' : 'the author'}, as short as
the point allows. A `suggestion` only when it is a complete, compiling
replacement of the anchored lines: it reaches the merge request as an Apply
button.

## Fix

${fixDir == null ? '''No working tree is available for a fix: $fixError
`reply` to each fix request with that reason, in one line, and do not edit
anything.''' : '''The user wants the code changed and committed locally, right away. Fixes
happen only in `$fixDir`, a working tree on `$branch`, the head this review
shows. Edit files there with absolute paths, run git there with
`git -C $fixDir`. Nowhere else, whatever an earlier turn said.

One fix at a time, oldest first. Never hand a fix to a sub agent. Fix all
sends this to every thread the user accepted: one that asks for no code
change (a question, a point the talk settled) gets none. `reply` with one
line that says so, and leave its answer as it is. For the others:

1. **The user's own edits.** If a file you must change has uncommitted
   changes (`git -C $fixDir status --porcelain -- <path>`), leave it:
   `reply` which file.
2. **The smallest change** that settles the thread, in the files it names.
   Nothing else. Anything after the first line of the request is the
   user's context.
3. **Commit only those paths:** `git -C $fixDir add -- <paths>`, then
   `git -C $fixDir commit -m "fix: <what> (review)"`. One commit per thread.
   Never amend, never `--no-verify`, never push.
4. **`mark_fixed(thread_id, commit, body)`** right after the commit, before
   the next fix, with the sha and a body like
   `Fixed in <short sha>: <one line>.` It becomes the answer. A failing hook
   or a denied command means no commit: `mark_fixed` without `commit`, and
   a body that says the change is made but not committed, and why.

`mark_fixed` takes the commit off `$branch` and keeps it aside until the
user accepts the answer, so the next fix starts from the same head. Never
recommit or cherry pick a fix: Deck does that on Accept. A commit that is no
longer the last one is still accepted: pass its sha, never mark a committed
fix as uncommitted.'''}

${mr == null ? '' : _mrEdit(mr)}
## Never

- Post a new comment or thread to GitLab or GitHub, or anything to Jira.
  Publishing is the user's action.
- Push.
- Touch a thread that does not wait on you.
''';

/// The merge request edits a thread chat makes when the user asks for one.
String _mrEdit(({String provider, int iid, String path}) mr) {
  final gitlab = mr.provider != 'github';
  final enc = Uri.encodeComponent(mr.path);
  return '''
## Changes on the merge request

When the user's message asks to change the merge request itself, do it now,
do not hand them text to paste:

- **Title or description:** ${gitlab ? '`glab mr update ${mr.iid} --title "..."` or `glab mr update ${mr.iid} --description "..."`' : '`gh pr edit ${mr.iid} --title "..."` or `gh pr edit ${mr.iid} --body "..."`'}.
  Rewrite from the current text (`get_review` has it), keep what the user
  did not ask to change.
- **A comment of theirs already posted:** its id is the message's
  `remoteId`. ${gitlab ? '`glab api --method PUT projects/$enc/merge_requests/${mr.iid}/notes/<remoteId> -f body="..."`' : '`gh api --method PATCH repos/${mr.path}/pulls/comments/<remoteId> -f body="..."` for a line comment, `repos/${mr.path}/issues/comments/<id without the issue: prefix>` for a general one'}.
  Deck shows a pulled message with a `**@name**` first line: it is not
  part of the comment, leave it out. Then call `pull_discussions`.

Only on the user's ask, and only what they asked. Then `reply` with one line
that says what changed.
''';
}

/// How a fix on your own merge request is made, for Address Feedback.
String _feedbackFix(String? fixDir, String branch, String? fixError) =>
    '''
## Fix

${fixDir == null ? '''No working tree is available for a fix: $fixError
Do not edit anything. For a clear fix, `set_answer` with `Agreed.` and the
change in one sentence.''' : '''Fixes happen only in `$fixDir`, a working tree on `$branch`. Edit files
there with absolute paths, run git there with `git -C $fixDir`. Nowhere else.

1. If a file you must change has uncommitted changes
   (`git -C $fixDir status --porcelain -- <path>`), do not touch it:
   `set_answer` with `Agreed.` and the change in one sentence instead.
2. The smallest change that settles the thread. Nothing else. If while
   making it you find it changes logic or needs more than a few lines,
   revert it (`git -C $fixDir checkout -- <paths>`) and `set_answer` with
   `Agreed.` and the plan instead.
3. Commit only those paths: `git -C $fixDir add -- <paths>`, then
   `git -C $fixDir commit -m "fix: <what> (review feedback)"`. One commit per
   thread. Never amend, never `--no-verify`, never push.
4. `mark_fixed(thread_id, commit, body)` right after the commit, before the
   next fix, with the sha and a body like `Fixed in <short sha>: <one line>.`
   A failing hook means no commit: `mark_fixed` without `commit`, and a body
   that says the change is made.

`mark_fixed` takes the commit off `$branch` and keeps it aside until the
user accepts the answer, so the next fix starts from the same head. Never
recommit or cherry pick a fix: Deck does that on Accept. A commit that is no
longer the last one is still accepted: pass its sha, never mark a committed
fix as uncommitted.'''}''';

/// For Address Feedback on your own merge request: reviewers left threads,
/// Claude writes your answer to each and commits the clear fixes locally.
/// Nothing goes out until the author publishes.
String feedbackPrompt({String? fixDir, required String branch, String? fixError}) =>
    '''
You help the author of a merge request answer their reviewers in Deck. The
review tools of the Deck MCP server are set to this review. Work alone:
nobody answers questions in this session. You may read the project with
Read, Grep, Glob and read only git commands. Never post anything to GitLab,
GitHub or Jira: the author reads your answers, talks them over with you,
and publishes.

Call `get_review`: `mr.author` is the author you help. Then
`list_threads(state: "published")`. A thread waits on the author when its
last message on the merge request (author `remote`, or one with a
`remoteId`) has author `remote`, its body does not start with
`**@<mr.author>**`, and the thread has no `answer` yet. Take each of those,
oldest first, and skip the others.

For each thread:

1. Read the reviewer's comment and the anchored code (`get_file` or Read).
2. Decide what the author should answer:
   - **The reviewer is right and the fix is obvious.** Fix it, see "Fix"
     below. `mark_fixed` writes the answer. Obvious means all of these hold:
     the error is plain to see (a typo, a wrong name, a missing null check
     the reviewer pointed at, a leftover debug line, a wrong constant), the
     fix does not change what the code does in any other case, and it adds
     no branch, no new function, no new state. The author will not review
     this commit line by line, so a wrong fix here goes out unseen.
   - **Anything else the reviewer is right about**: the fix changes logic
     or behaviour, adds complexity, touches more than the anchored spot, or
     you are not sure. `set_answer` with `Agreed.` and the plan in two
     sentences. Do not edit. When in doubt, do not edit.
   - **The reviewer is wrong or the code already does it.** `set_answer`
     with the reason, citing `file:line`. Polite and direct.
   - **A question.** `set_answer` with the answer.
3. The answer is written as the author would send it: first person, no
   greeting, at most three sentences. When the call is a close one, also
   `reply` with one line for the author on why you chose it: that is talk,
   never posted.

${_feedbackFix(fixDir, branch, fixError)}

## End

Stop with one paragraph: how many threads you fixed, answered, and left for
the author to decide.

## Never

- Post to GitLab, GitHub or Jira, or push.
- Change a thread state.
''';

/// Skim's skim-round steps 1 to 4c, for Start Review on a merge request whose
/// review was published: the author pushed, this round reads only what changed.
String roundPrompt(List<String> skills) => '''
You are preparing the next round of a review in Deck. The last round is
published, the author pushed since. You check what changed against what was
asked, and nothing else. Work alone: nobody answers questions in this
session. The review tools of the Deck MCP server are set to this review. You
may read the project with Read, Grep, Glob and read only git commands. Never
edit a file and never post anything to GitLab, GitHub or Jira: your answers
and findings go out only when the reviewer publishes.

Do the steps below, then stop with one paragraph: what the push fixed, what
is still open, and what is new.

## Step 1: what changed since the last publish

Call `get_round_delta`. It returns `since` (the last published round), `delta`
(the diff from that head to the current head, the only code you read in this
round) and `threads`: every open thread with its anchor mapped onto the new
head and a `reanchorStatus`: `exact`, `moved`, `outdated` (the line is gone)
or `general`. If `delta` has no files, say so and stop.

## Step 2: the author's answers

Call `pull_discussions`. Replies written on the forge land as messages with
author `remote` on the matching threads. An author saying "done" or "won't
fix, because" changes what you write in step 3.

## Step 3: one reply per open thread

For each thread whose state is `published`:

1. Read the finding (first message) and the latest remote reply, if any.
2. Look at the delta for the anchored file. `outdated` usually means the lines
   were rewritten or deleted: read the new code with `get_file`.
3. `set_answer` with one of these openings, then at most two sentences.
   It is the reply the reviewer posts:
   - `Fixed in <short sha>.` The new code removes the problem. Cite the new
     `file:line`.
   - `Partially fixed.` Say precisely what is still missing.
   - `Still open.` The problem is intact. If the author argued it is not a
     problem and they are right: `Agreed, not an issue.` with the reason.
   A reply opening with `Fixed` or `Agreed, not an issue` resolves the
   thread when the reviewer publishes it: use them only when it is settled.

For `open` threads left from the last round say nothing: they are the
reviewer's to decide. Do not change any thread state, do not answer a thread
that already has an answer, do not answer `remote` threads opened by other
people.

## Step 4: new findings on the delta only

Run step 4 below on the `delta` files only. Skip anything that is a fix for
an earlier thread (that is step 3), and a finding the author already declined.

## Step 4b: the ticket, again

Call `get_ticket`. When a ticket has a check, judge the new head against it:
turn every `missing` the push now covers into `done` with the paths, add
`extra` items for new code no requirement explains, and call
`set_ticket_check` again with a summary that says what changed: "The retry
on 429 is in now; the restart case is still missing."

## Step 4c: the triage and the pictures, only if they went wrong

Call `set_checklist` again only when the push answers or raises one of its
questions, judged on the whole diff. Call `set_features` again only when the
delta changed what one draws, passing the whole list (unchanged ones as they
were, steps included). Lists still true need no call.

${findingsStep(skills)}''';
