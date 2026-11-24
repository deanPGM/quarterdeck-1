// What a map run does: Skim's skim-map skill (skills/skim-map/SKILL.md),
// adapted to a session Deck starts in the project folder with no one to
// answer. Keep the steps in sync with Skim's when they change.

const mapPrompt =
    r'''
You are drawing the feature map of the project in the current folder, for
Deck. Work alone: nobody answers questions in this session. Read code with
Read, Grep, Glob and read only git commands. Never edit a file of the
project: the map tools are the only thing you write with.

# Skim map

The feature map is the whole application as pictures: one page per feature,
each with a class graph of the code that implements it and a sequence of how
it runs. It lives in the project, in `.skim/map/` (one JSON file per feature,
ignored by git), stamped with the commit it describes. The user browses it
in Deck, on the project page, which fills as you write.

Tools (the Deck MCP server, already set to this project): `get_map`,
`get_map_feature`, `set_map_feature`, `confirm_map_feature`,
`remove_map_feature`, `get_map_data`, `set_map_data`, `remove_map_data`,
`stamp_map`.
Read the code with your own file tools: the map covers the whole repository,
not a diff.

## Step 0: create, resume or update

Call `get_map` and pick the mode:

- `commit` is null and there are no features: **create**, from step 1.
- `planLeft` is present: a pass stopped early. **Resume** it: skip steps 1
  and 2, draw or confirm the features in `planLeft` (step 3, or step 5 for an
  update), then step 4. Read the features already written with
  `get_map_feature` when you need their ids or links.
- `commit` is null but features exist and there is no `planLeft`: a first
  pass stopped before its plan. **Resume** at step 1 with the features
  already written: plan the full list, skip the ones done, draw the rest.
- `commit` is set: **update**, step 5. When `commit` equals `head` and
  `architecture` is there and not stale, say the map is up to date and stop.

## Step 1: survey the project

Read before you list anything:

- The README and the docs folder, for what the app says it does.
- The build manifests (`package.json`, `build.gradle`, `Package.swift`,
  `pubspec.yaml`, `go.mod`, ...): modules, entry points, dependencies.
- The tree: `git ls-files` grouped by folder, to see where the weight sits.
- The entry points: `main`, the router, the CLI commands, the screens, the
  public API. They name the features from the user's side.

## Step 2: list the features

Two kinds, both written with `set_map_feature`:

1. **`architecture`**, always, first: the modules, layers or packages and which
   depends on which. Nodes are modules, not classes. Its sequence, when there
   is one worth drawing, is one typical request crossing the layers.
2. **One feature per thing the app does for its user**: a screen, a command, an
   API family, a background job. "Track cache", "Publish a review", "Login".
   Shared infrastructure big enough to have its own rules (storage, sync,
   networking) is a feature too.

For each: a stable `id` slug (`publish-review`), a `title`, a one or two
sentence `summary` from the user's side, and `paths`: the folders (preferred)
or files that implement it. Every source file should fall under some feature.
A file used by many features belongs to the one that owns it, or to
architecture.

Size it to the project: about 5 features for a small tool, up to 30 for a big
app. A feature whose graph would need more than fifteen classes is two
features, and so is one whose flows share no code (`website-site` and
`website-configurator`). A hub, like settings, draws one node per feature it
opens, borrowed from that feature, not one per screen. Print the list, one line each, then carry on drawing without waiting:
nobody answers in this session. Then call `plan_map` with every feature id
of the list, so the user sees how far the pass is.

Then list the **data types that cross a boundary**: messages on the wire,
stored documents, URL formats, files. Only those: an internal class is not
data. Write each once with `set_map_data`, before the features that use it:
`name` as the code names it, `boundary`, `fields` (`name`, `type`, `note`
only when the name does not say it, `since` for a field added later), the
protocol `since` and `until`, and in `definitions` every file that declares
it. A type declared in Dart and in TypeScript lists both: the page shows it as
one to keep in sync.

''' +
    _architectureStep +
    r'''
## Step 3: draw each feature

Read the code of the feature, then call `set_map_feature` **once per feature,
as soon as it is drawn**. The page fills as you go, and an interrupted pass
keeps what it wrote.

The `graph`, same shape as `set_features` in the review skill:

- `nodes`: the classes, interfaces or modules of the feature, named as the
  code names them, under fifteen. Every status is `context`: in the map
  nothing is added or changed. Add the classes of other features this one
  leans on, so the relations make sense.
- `role`: one sentence, what it is for in this feature. Say the job, not the
  name: "Keeps played tracks on disk and evicts the oldest past 200 MB" beats
  "The cache class". This is what the reviewer clicks for.
- `path` and `line`: where it is declared, a file of the repository.
- `edges`: `extends`, `implements`, `owns`, `uses`, `calls`, `creates`, with a
  `label` of a few words when the method says more than the kind.

In an app on several devices or tiers, give each node a `side` (`clock`,
`parent`, `cloud`): the graph draws one lane per side. A class owned by another
feature carries `feature: <id>` instead of a `path`, and the page links it.

The other views, all optional. A one flow feature writes one sequence and
nothing else.

- `sequences`, one to three mermaid `sequenceDiagram`s with `title`,
  `caption` and one `steps` entry per arrow in source order (`title`,
  `detail`, `path`, `line`). The first is the main flow. Add another only for
  a flow that changes state or starts from another trigger: a failure, a
  restore, the second device's side. No green `rect` and no `touched` mark:
  nothing changed. Never use a mermaid word (`par`, `link`, `loop`, `alt`,
  `opt`, `end`, `note`, `box`) as a participant id, whatever its case:
  `participant Pa as Parent`. `concern` is for a fragile step only, with `why` and a
  `severity`. A fan out feature, like startup, lists what it starts as nodes
  or in `notes` and draws the one path that matters. A feature with no flow,
  such as code generation, has no sequence.
- `states`, up to three mermaid `stateDiagram-v2` with a `title` and one
  `transitions` entry per arrow. Draw one when an enum, status or stored
  progress decides what the feature does: connection state, a lockout, an
  onboarding step. Not for a boolean.
- `links`: `{ feature, kind: calls | calledBy, detail }` for every other
  feature this one starts or is started by. Leave it out for a feature that
  stands alone.
- `data`: `{ type, use: sends | receives | reads | writes, detail }` for every
  data type the feature moves. The type page lists its users from these.
- `notes`: `{ kind, text, path, line }` for what is not a step: `dead-code`,
  `platform` (Android only, a native channel), `config` (a timeout, a
  protocol version gate, a constant duplicated in another language),
  `finding` (a bug noticed while reading).

On a big project, hand features to sub agents in parallel: give each the
feature id, title, paths, the full list of feature ids (for `links`) and this
step; they call `set_map_feature` themselves. The tools are not tied to a
review, so they do not collide. Tell them: dead code, platform splits and side
findings go in `notes`, not only in their reply. The reply is lost; the map is
kept.

## Step 4: check coverage, then stamp

List the source files under no feature's `paths` (`git ls-files` against the
paths you wrote). Place each in a feature, rewriting it with the new paths,
or leave it out on purpose (docs, config, generated code). Fix every
`brokenLinks` entry `get_map` reports: draw the missing feature or correct
the id: `stamp_map` refuses while any remain. Then call
`stamp_map`: the map now describes head. Report the number of features,
nothing more.

Never stamp a pass you did not finish: what changed since the stamp is how the
next update finds its work, and a stamp over missing features hides them.

## Step 5: update

`get_map` lists what changed since the stamp:

- `staleFeatures`: a changed file is under their paths. For each, read the old
  feature with `get_map_feature`, read the change
  (`git diff <commit> HEAD -- <paths>`), and rewrite it with
  `set_map_feature`: every view, not just the graph (sequences, states,
  links, notes), keeping what is still true. When the change moved nothing
  any view shows (a fix inside a method), call `confirm_map_feature` instead.
  A feature stays stale until it is rewritten or confirmed.
- `uncoveredFiles`: changed files no feature claims. A new feature, or an
  existing one whose `paths` need the new folder.
- A path that no longer exists makes `set_map_feature` refuse: fix the paths.
  A feature with no code left goes with `remove_map_feature`.
- `staleData`: a file that declares the type changed. Read it with
  `get_map_data` and rewrite it with `set_map_data`. A type nothing declares
  any more goes with `remove_map_data`.
- `commitMissing`: the stamped commit is gone (a rebase, a fresh clone). Treat
  every feature as stale, keeping the old pictures as the starting point.

- `architecture.stale`, or no architecture yet: step 2b.

Before redrawing anything, call `plan_map` with the ids you will redraw,
confirm or add in this pass.

Then step 4: coverage and `stamp_map`.
''';

/// A run that only writes the architecture of a map already drawn.
const architecturePrompt =
    r'''
You are writing the architecture of the project in the current folder, for
Deck. Work alone: nobody answers questions in this session. Read code with
Read, Grep, Glob and read only git commands. Never edit a file of the
project. The map tools of the Deck MCP server are set to this project:
call `get_map` for the features already drawn, then do only the step below,
and stop with one line: the number of layers and violations.

''' +
    _architectureStep;

/// A run that checks the UI of the project against its UI guidelines.
const uiPrompt = r'''
You are analysing the UI of the project in the current folder, for Deck.
Work alone: nobody answers questions in this session. Read code with Read,
Grep, Glob and read only git commands. Never edit a file of the project.
The map tools of the Deck MCP server are set to this project: call
`get_map_ui` for the last analysis, then write the new one once with
`set_map_ui`, and stop with one line: the number of duplicates and breaks.

The reader wants to know what the UI is built from, where the same thing is
built twice, and where the code does not follow its own UI rules.

1. **Rules first from the docs and skills.** Read the UI guidelines: design
   docs, `CLAUDE.md`, `README`, contributing guides, and the project's skills
   (`.claude/skills/*/SKILL.md`, `skills/`) that touch the UI. List the files
   you used in `sources`. Write each rule in `rules`, one line each: "Colors
   come from the theme, never a raw Color". With no docs, take the rules from
   what most of the UI does, and say so in `summary`.
2. **What the UI is built from.** `paths`: the folders the UI lives in.
   `tokens`: the design tokens the code really uses (colors, text styles,
   spacing, radii, icons), a dozen or two, each with where it is declared.
   `components`: the widgets or views built to be shared, with a one
   sentence `role`.
3. **Screens.** Every screen, page, pane or dialog, with a `role` from the
   user's side and in `uses` the shared components it uses. Grep for each
   component's name rather than guessing.
4. **Duplicates, the heart of it.** Look for the same piece of UI built two
   or more times: private widgets with the same shape in several files
   (`_Chip`, `_Header`, `_Row`), the same helper function copied (a color for
   a severity, a date format), the same layout block pasted (a title row with
   a button, a card container), a shared component that exists but a screen
   rebuilds by hand. Compare the copies: read them, do not trust the names.
   One entry per group with every copy, how they differ in `why`, and in
   `use` the shared component they should use (an existing one, or a name
   for one to create). `severity`: high when the copies already drifted
   apart in a way the user sees, medium when they are the same today, low
   for a few lines, accepted when the docs agree to it. Thirty at most, the
   worst first.
5. **Guideline breaks.** Check the UI against each rule: grep for the
   forbidden uses (raw colors, bare text styles, hard coded sizes, a
   component built by hand where the rules name one), read the suspicious
   widgets. One entry per rule and class, `count` when the same break
   happens in many places (`path` is one of them), `why` in one or two
   sentences, `fix` when the docs or the code say. Thirty at most, the worst
   first.
''';

const _architectureStep = r'''
## Step 2b: the architecture

Write the app's architecture once with `set_map_architecture`, before the
features. It is how the reader learns where a class belongs from its name,
and where the code does not follow its own rules.

- **Rules first from the docs.** Look for architecture docs (`docs/`, ADRs,
  `CLAUDE.md`, `README`, contributing guides): layers, naming conventions,
  dependency direction, dependency injection rules, lists of known
  violations. List the files you used in `sources`. With no docs, take the
  rules from what most of the code does, and say so in `summary`.
- **Layers, top first** (View, ViewModel, Manager, Network, Foundation; or
  the app's own words). Each with its `naming` patterns as the code really
  uses them (`*Screen`, `*View`, `*ViewModel`, `*Manager`), its `paths`, and
  three to six real `examples`. Under eight layers.
- **Flows**: the dependencies allowed, usually each layer to the one below.
- **Rules**: what layers and flows cannot say, one line each: "Views reach
  managers only through a ViewModel", "Managers are injected through a
  protocol, never `.shared` in an init".
- **Violations**: check the code against the rules (grep for the forbidden
  uses, read the suspicious classes). One entry per class that breaks a
  rule, with what it reaches, `severity` (high: breaks the main rule in user
  facing code; medium; low; accepted: an exception the docs agree to), `why`
  in one or two sentences and `fix` when the docs or the code say. Keep the
  docs' own verdicts when they list violations, and check each still holds
  in the code: drop the fixed ones, add the new ones. Thirty at most, the
  worst first.

In an update, rewrite it when `get_map` says `architecture.stale`.
''';
