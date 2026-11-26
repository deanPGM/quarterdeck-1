// Sample data and fake state for golden tests and Widgetbook. Not used by the
// app itself.
import 'package:clock/clock.dart';
import 'package:deck/core/classify/gitlab.dart';
import 'package:deck/core/classify/jira.dart';
import 'package:deck/core/classify/message.dart';
import 'package:deck/core/classify/todo.dart';
import 'package:deck/core/models/activity.dart';
import 'package:deck/core/models/card.dart';
import 'package:deck/core/models/claude_run.dart';
import 'package:deck/core/models/config.dart';
import 'package:deck/core/models/overview.dart';
import 'package:deck/core/models/records.dart';
import 'package:deck/core/models/session_progress.dart';
import 'package:deck/core/models/snapshot.dart';
import 'package:deck/data/deck_home.dart';
import 'package:deck/mcp/http_host.dart';
import 'package:deck/state/activity.dart';
import 'package:deck/state/alarms.dart';
import 'package:deck/state/board.dart';
import 'package:deck/state/forges.dart';
import 'package:deck/state/mcp_host.dart';
import 'package:deck/state/notices.dart';
import 'package:deck/data/permission_log.dart';
import 'package:deck/state/project_map.dart';
import 'package:deck/state/project_mrs.dart';
import 'package:deck/state/project_overview.dart';
import 'package:deck/state/project_talks.dart';
import 'package:deck/state/reviews.dart';
import 'package:deck/state/sessions.dart';
import 'package:deck/state/settings.dart';
import 'package:deck/state/ui_memory.dart';
import 'package:deck/state/updates.dart';
import 'package:deck/state/worktrees.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import 'package:deck/dev/map_fixtures.dart';
import 'package:deck/dev/review_fixtures.dart';

export 'package:deck/dev/map_fixtures.dart';
export 'package:deck/dev/review_fixtures.dart';

class FakeSettings extends Settings {
  FakeSettings(this.cfg);

  final DeckConfig cfg;

  @override
  Future<DeckConfig> build() async => cfg;

  @override
  Future<void> save(DeckConfig c) async => state = AsyncData(c);
}

class FakeBoard extends Board {
  FakeBoard(this.initial);

  final BoardState initial;

  @override
  Future<BoardState> build() async => initial;

  @override
  Future<void> refresh() async {}
}

List<Override> overrides(DeckConfig cfg, BoardState board, {EventRecord? ringing, NoticesState notices = const NoticesState(), UpdateState? update}) => [
  updatesProvider.overrideWith(() => FakeUpdates(update ?? sampleUpdate())),
  // A made up Deck folder: screenshots never show where yours is.
  homeProvider.overrideWith(FakeHome.new),
  ringingProvider.overrideWith(() => FakeRinging(ringing)),
  noticesProvider.overrideWith(() => FakeNotices(notices)),
  permissionHistoryProvider.overrideWith((ref) async => samplePermissionHistory()),
  settingsProvider.overrideWith(() => FakeSettings(cfg)),
  boardProvider.overrideWith(() => FakeBoard(board)),
  mcpHostProvider.overrideWith((ref) async => HttpMcpHost((_, _) => throw UnimplementedError())),
  chromeProfileListProvider.overrideWithValue(const [(dir: 'Default', name: 'Work'), (dir: 'Profile 1', name: 'Personal')]),
  // Starts on the board, and never reads or writes your ui.json.
  uiMemoryProvider.overrideWith((ref) => UiMemory()),
  // No alarm timers in tests and Widgetbook.
  alarmsProvider.overrideWith((ref) {}),
  activityProvider.overrideWith(
    (ref, r) async => [
      for (final e in sampleActivity())
        if (!e.at.isBefore(r.$1) && e.at.isBefore(r.$2.add(const Duration(days: 1)))) e,
    ],
  ),
  activitySummaryProvider.overrideWithBuild((ref, _) async => sampleSummary),
  projectMapProvider.overrideWith((ref, id) async => sampleMap),
  projectMrsProvider.overrideWith((ref, id) async => sampleProjectMrs()),
  projectCheckoutsProvider.overrideWith(
    (ref, id) async => [(path: '~/code/vpn-ios/.claude/worktrees/onboarding-copy', branch: 'claude/onboarding-copy', ahead: 2, uncommitted: 3)],
  ),
  worktreesProvider.overrideWith(
    (ref) async => [
      (
        project: 'vpn-ios',
        root: '/Users/sam/work/vpn-ios',
        path: '/Users/sam/work/vpn-ios/.claude/worktrees/onboarding-copy',
        branch: 'feat/onboarding-copy',
        uncommitted: 3,
      ),
      (
        project: 'backend',
        root: '/Users/sam/work/backend',
        path: '/Users/sam/work/backend/.claude/worktrees/API-88',
        branch: 'worktree-API-88',
        uncommitted: 0,
      ),
    ],
  ),
  projectOverviewStateProvider.overrideWith2((_) => FakeOverview()),
  projectNewCountProvider.overrideWith((ref, id) async => id == 'vpn-ios' ? 2 : 0),
  projectTalksProvider.overrideWith((ref, id) async => id == 'vpn-ios' ? [(id: 'talk-1', at: _now.subtract(const Duration(hours: 1)))] : []),
  projectReviewsProvider.overrideWith((ref, id) async => [sampleReview()]),
  // A local branch with no merge request: the review shows Push, not Publish.
  reviewProvider.overrideWith(
    (ref, key) async => key.id.startsWith('local-')
        ? sampleReview().copyWith(id: key.id, mr: null, local: true, headRef: 'feat/VPN-310-split-tunnel', folder: '/Users/sam/work/vpn-ios')
        : sampleReview(),
  ),
  reviewDiffProvider.overrideWith((ref, key) async => sampleReviewDiff()),
  reviewStatusProvider.overrideWith((ref, key) async => sampleMrStatus),
  // Every card with a session shows Claude waiting, with no transcript to read.
  sessionProgressProvider.overrideWith(
    (ref, id) => Stream.value(SessionProgress(status: SessionStatus.waiting, last: 'Two threads answered. Push the fix?', at: clock.now())),
  ),
];

final _now = clock.now();
DateTime _ago(int d) => _now.subtract(Duration(days: d));

const sampleConfig = DeckConfig(
  claude: ClaudeConfig(allowedTools: ['Bash(npm test:*)']),
  providers: {
    'gitlab': ProviderConfig(access: Access.cli),
    'jira': ProviderConfig(),
    'slack': ProviderConfig(options: {'queries': 'in:#acme-releases'}),
    'calendar': ProviderConfig(),
    'mail': ProviderConfig(options: {'notesName': 'Sam Rivera'}),
  },
  projects: [
    ProjectConfig(
      id: 'vpn-ios',
      name: 'VPN iOS',
      dir: '/Users/sam/work/vpn-ios',
      repo: 'gitlab:acme/vpn-ios',
      board: 'jira:VPN',
      channels: ['#vpn-team'],
      ide: 'xed',
      description: 'Acme VPN for iPhone and Mac.',
      aliases: ['Acme VPN', 'com.acme.vpn', 'VPN'],
      platforms: ['apple'],
      tech: 'Swift, SwiftUI, Xcode',
    ),
    ProjectConfig(id: 'backend', name: 'Backend', dir: '/Users/sam/work/backend', repo: 'gitlab:acme/backend', board: 'jira:API'),
  ],
);

MrRecord _mr(
  String repo,
  int iid,
  String title,
  MrRole role, {
  List<ThreadRecord> threads = const [],
  String pipeline = 'SUCCESS',
  bool approved = false,
  List<String> approvers = const [],
  bool draft = false,
  int age = 3,
  int idle = 1,
  String branch = '',
}) => MrRecord(
  path: 'acme/$repo',
  iid: iid,
  title: title,
  url: 'https://gitlab.com/acme/$repo/-/merge_requests/$iid',
  author: role == MrRole.mine ? 'sam' : 'alex',
  role: role,
  pipeline: pipeline,
  approved: approved,
  approvers: approvers,
  draft: draft,
  createdAt: _ago(age),
  updatedAt: _ago(idle),
  threads: threads,
  branch: branch,
);

BoardState sampleBoard() {
  final mrs = [
    _mr(
      'vpn-ios',
      412,
      'Fix cold launch sync of the tunnel state',
      MrRole.review,
      threads: const [
        ThreadRecord(start: 'sam', last: 'alex'),
        ThreadRecord(start: 'sam', last: 'alex'),
      ],
      branch: 'fix/VPN-120-cold-launch',
    ),
    _mr('vpn-ios', 418, 'Add the paywall A/B test flag', MrRole.review, age: 2),
    _mr('backend', 77, 'Rate limit the license endpoint', MrRole.mine, approved: true, approvers: ['alex']),
    _mr('backend', 81, 'Move bandwidth jobs to Cloud Tasks', MrRole.mine, idle: 4),
    _mr('vpn-ios', 399, 'Draft: new onboarding', MrRole.mine, draft: true, idle: 9),
  ];
  final issues = [
    IssueRecord(
      key: 'VPN-120',
      summary: 'Customer cannot connect on hotel Wi-Fi',
      url: 'https://acme.atlassian.net/browse/VPN-120',
      status: 'In Progress',
      statusCategory: 'indeterminate',
      type: 'Customer Escalation',
      created: _ago(20),
      updated: _ago(1),
      lastComment: CommentRecord(author: 'Jo Carter', at: _ago(1)),
    ),
    IssueRecord(
      key: 'API-88',
      summary: 'Expose usage stats per device',
      url: 'https://acme.atlassian.net/browse/API-88',
      status: 'To Do',
      statusCategory: 'new',
      type: 'Story',
      created: _ago(10),
      updated: _ago(3),
    ),
    IssueRecord(
      key: 'VPN-131',
      summary: 'Kill switch survives reboot',
      url: 'https://acme.atlassian.net/browse/VPN-131',
      status: 'In Review',
      statusCategory: 'indeterminate',
      type: 'Story',
      created: _ago(8),
      updated: _ago(2),
    ),
  ];
  final msgs = [
    MessageRecord(
      id: 'D1/1',
      url: 'https://slack.com/archives/D1/p1',
      from: 'Jordan',
      where: 'DM',
      at: _ago(0),
      title: 'Joining the daily?',
      ask: true,
      need: 'Reply whether you join the daily.',
    ),
    MessageRecord(
      id: 'C1/2',
      url: 'https://slack.com/archives/C1/p2',
      from: 'Mo',
      where: '#vpn-team',
      at: _ago(1),
      title: 'Deploy only from develop?',
      ask: true,
      need: 'Decide if deploys run only on develop.',
      about: 'backend!81',
    ),
    MessageRecord(
      id: 'C1/3',
      url: 'https://slack.com/archives/C1/p3',
      from: 'Mo',
      where: '#vpn-team',
      at: _ago(2),
      title: 'Crash report on the connect screen',
      ask: true,
      need: 'Check the crash log Mo shared and file a ticket.',
      task: true,
      done: true,
    ),
  ];
  MessageRecord mail(String id, String kind, String from, String where, String title, {int ago = 0}) =>
      MessageRecord(id: id, url: 'https://mail.google.com/mail/u/0/#inbox/$id', from: from, where: where, at: _ago(ago), title: title, kind: kind);
  final mails = [
    mail('m1', 'noise', 'Boardly', 'digest@boardly.example', 'Your weekly board digest'),
    mail('m2', 'noise', 'Boardly', 'digest@boardly.example', 'Your weekly board digest', ago: 7),
    mail('m3', 'noise', 'Boardly', 'digest@boardly.example', 'New templates for your team', ago: 9),
    mail('m4', 'fyi', 'Lee', 'lee@acme.example', 'Office closed on Friday', ago: 1),
    mail('m5', 'phishing', 'Mail Admin', 'admin@acme-mailbox.example', 'Your mailbox is full, verify now'),
  ];
  Snapshot snap(List<DeckCard> cards) => Snapshot(state: SourceState.ok, message: '${cards.length} open', at: _now, me: 'sam', cards: cards);
  DateTime at(int minutes) => _now.add(Duration(minutes: minutes));
  final meetings = [
    EventRecord(id: 'e1', title: 'VPN daily', start: at(-10), end: at(5), going: true, attendees: 6, join: 'https://meet.google.com/abc-defg-hij'),
    EventRecord(id: 'e2', title: 'Paywall test review', start: at(25), end: at(55), going: true, attendees: 4, join: 'https://meet.google.com/klm-nopq-rst'),
    EventRecord(id: 'e3', title: 'Backend 1:1 with Jo', start: at(90), end: at(120), going: true, attendees: 2, join: 'https://zoom.us/j/123'),
    EventRecord(id: 'e4', title: 'Company all hands', start: at(240), end: at(300), attendees: 120),
  ];
  return BoardState(
    runs: [
      ClaudeRun(
        at: _now.subtract(const Duration(minutes: 64)),
        providers: const ['jira', 'slack', 'mail', 'calendar'],
        seconds: 41,
        costUsd: 0.031,
        sessionId: 's-a',
      ),
      ClaudeRun(
        at: _now.subtract(const Duration(minutes: 4)),
        providers: const ['slack'],
        seconds: 23,
        sessionId: 's-b',
        error: 'Claude did not send results.',
      ),
    ],
    triage: {
      'calendar:e3': const Triage(silent: true),
      'todo:2': Triage(done: true, doneReason: 'MR merged', doneAt: _now.subtract(const Duration(hours: 1))),
      mrKey('gitlab', 'acme/backend', 77): Triage(session: 's1', startedAt: _now.subtract(const Duration(hours: 2))),
      'slack:C1/3': Triage(startedAt: _now.subtract(const Duration(minutes: 30))),
    },
    snapshots: {
      'mail': Snapshot(state: SourceState.ok, message: '0 open', at: _now),
      'notes': Snapshot(state: SourceState.ok, message: '2 notes, 1 new step', at: _now),
      'calendar': Snapshot(state: SourceState.ok, message: '4 meetings', at: _now, events: meetings),
      'gitlab': snap([for (final m in mrs) classifyMr(m, 'sam', _now)]),
      'jira': snap([for (final i in issues) classifyIssue(i, _now)]),
      'slack': snap([for (final m in msgs) ?classifyMessage(m, 'slack', _now)]),
      'mail': snap(mergeMessages([], mails, 'mail', _now).cards),
      'todo': snap([
        classifyTodo({
          'title': 'Prepare the VPN retro',
          'need': 'Collect notes from the team before Friday.',
          'source': 'slack',
          'from': '#vpn-team',
          'url': 'https://acme.slack.com/archives/C1/p3',
        }, _now).copyWith(key: 'todo:1'),
        classifyTodo({
          'title': 'Ship the license rate limit',
          'need': 'Merge the rate limit MR.',
          'source': 'gitlab',
          'from': 'backend!77',
          'url': 'https://gitlab.com/acme/backend/-/merge_requests/77',
        }, _now).copyWith(key: 'todo:2'),
      ]),
    },
  );
}

/// The Overview of every project in the samples. Visiting reads nothing.
class FakeOverview extends ProjectOverviewState {
  @override
  Future<OverviewView> build(String id) async =>
      (overview: sampleOverview, updates: sampleUpdates(), docs: sampleDocs(), lastSeen: _now.subtract(const Duration(hours: 3)), writing: false, error: null);

  @override
  Future<void> visit() async {}
}

const sampleOverview = Overview(
  facts: [
    Fact(section: 'release', text: 'Code freeze on Nov 12, release 2.4 on Nov 19', source: '#vpn-team, Oct 14', was: 'Nov 5'),
    Fact(section: 'decisions', text: 'Deploys run only from develop', source: '#vpn-team, Oct 13'),
    Fact(section: 'people', text: 'Jo owns the paywall test, Mo the tunnel', source: 'Mail from Jo, Oct 9', edited: true),
    Fact(section: 'questions', text: 'Detect captive portals, or ask users to log in first?', source: '#vpn-team, Oct 14'),
  ],
);

List<ProjectDoc> sampleDocs() => [
  ProjectDoc(
    url: 'https://docs.google.com/spreadsheets/d/sample-release',
    title: 'Release 2.4 checklist',
    provider: 'slack',
    source: '#vpn-team',
    at: _now.subtract(const Duration(hours: 1)),
  ),
  ProjectDoc(url: 'https://grafana.example.com/d/vpn-tunnel', title: 'Tunnel health dashboard', provider: 'mail', source: 'Sam Rivera', at: _ago(2)),
  ProjectDoc(url: 'https://www.figma.com/design/sample/paywall', title: 'Paywall designs', provider: 'you', at: _ago(5)),
];

List<ProjectUpdate> sampleUpdates() => [
  ProjectUpdate(
    id: 'slack:C1/9',
    at: _now.subtract(const Duration(hours: 1)),
    provider: 'slack',
    source: '#vpn-team',
    text: 'Code freeze moved to Nov 12',
    added: _now,
  ),
  ProjectUpdate(
    id: 'gitlab:acme/vpn-ios!410',
    at: _now.subtract(const Duration(hours: 2)),
    provider: 'gitlab',
    source: 'Sam Rivera',
    text: 'Merged !410: Retry the tunnel probe on captive portals',
    url: 'https://gitlab.com/acme/vpn-ios/-/merge_requests/410',
    added: _now,
  ),
  ProjectUpdate(id: 'mail:t9', at: _ago(1), provider: 'mail', source: 'Jo Carter', text: 'Paywall test starts Monday with 10% of users', added: _ago(1)),
  ProjectUpdate(
    id: 'slack:C1/8',
    at: _ago(2),
    provider: 'slack',
    source: '#vpn-team',
    text: 'Two reports of the tunnel dropping on hotel Wi-Fi',
    added: _ago(2),
  ),
];

class FakeRinging extends Ringing {
  FakeRinging(this.initial);

  final EventRecord? initial;

  @override
  EventRecord? build() => initial;

  @override
  void stop() => state = null;
}

class FakeHome extends Home {
  @override
  DeckHome build() => DeckHome('/Users/sam/.deck');
}

class FakeUpdates extends Updates {
  FakeUpdates(this.initial);

  final UpdateState initial;

  @override
  UpdateState build() => initial;

  @override
  Future<void> check() async {}
}

/// A released build, checked this morning. [latest] newer than 0.1.0 offers it.
UpdateState sampleUpdate({String latest = '0.1.0', UpdateStep step = UpdateStep.idle, String? error}) => UpdateState(
  current: '0.1.0',
  latest: Release(version: latest, notes: 'Faster board.', url: 'https://github.com/acme/quarterdeck/releases/tag/v$latest'),
  checkedAt: DateTime(2026, 10, 15, 9, 5),
  step: step,
  error: error,
);

class FakeNotices extends Notices {
  FakeNotices(this.initial);

  final NoticesState initial;

  @override
  NoticesState build() => initial;
}

/// The bell panel open on a few notices, one floating as a toast.
NoticesState sampleNotices({bool open = false}) {
  final at = clock.now();
  return NoticesState(
    open: open,
    unread: open ? 0 : 2,
    toasts: open ? const {} : const {3},
    all: [
      Notice(
        id: 3,
        at: at,
        kind: NoticeKind.session,
        title: 'Review ready',
        body: 'Fix cold launch sync of the tunnel state',
        route: '/project/vpn-ios/review/gitlab-412',
      ),
      Notice(
        id: 2,
        at: at.subtract(const Duration(minutes: 12)),
        kind: NoticeKind.permission,
        title: 'Always allowed Bash(npm test:*)',
        body: 'npm test -- --watch=false',
      ),
      Notice(
        id: 1,
        at: at.subtract(const Duration(minutes: 40)),
        kind: NoticeKind.session,
        title: 'Background run failed',
        body: 'slack: Claude did not send results.',
        error: true,
      ),
      Notice(id: 0, at: at.subtract(const Duration(hours: 1)), kind: NoticeKind.meeting, title: 'VPN daily', body: 'Starts at 9:20.'),
    ],
  );
}

List<PermissionEntry> samplePermissionHistory() => [
  PermissionEntry(at: _now.subtract(const Duration(minutes: 5)), tool: 'Bash', input: {'command': 'rtk git diff main...HEAD -- src/'}, answer: 'allow'),
  PermissionEntry(at: _now.subtract(const Duration(minutes: 20)), tool: 'Bash', input: {'command': 'npm test -- --watch=false'}, answer: 'always'),
  PermissionEntry(at: _now.subtract(const Duration(hours: 2)), tool: 'WebFetch', input: {'url': 'https://example.com/docs'}, answer: 'deny'),
];

/// A few days of activity log, relative to the clock.
List<Activity> sampleActivity() {
  final d = DateTime(_now.year, _now.month, _now.day);
  DateTime at(int days, int h, [int m = 0]) => DateTime(d.year, d.month, d.day - days, h, m);
  return [
    Activity(at: at(0, 9, 5), kind: 'session', title: 'Fix the login retry loop', source: 'claude', project: 'VPN iOS', detail: '08:20–09:05, 6 prompts'),
    Activity(at: at(1, 9, 30), kind: 'meeting', title: 'Daily standup', source: 'calendar', detail: '15 min, 7 people'),
    Activity(at: at(1, 10, 12), kind: 'approved', title: 'Rate limit the license endpoint', source: 'gitlab', ref: 'backend!212', project: 'Backend'),
    Activity(
      at: at(1, 11, 40),
      kind: 'session',
      title: 'Kill switch on network change',
      source: 'claude',
      project: 'VPN iOS',
      detail: '10:30–11:40, 14 prompts',
    ),
    Activity(at: at(1, 14, 2), kind: 'merged', title: 'Kill switch survives a network change', source: 'gitlab', ref: 'vpn-ios!341', project: 'VPN iOS'),
    Activity(
      at: at(1, 14, 3),
      kind: 'done',
      title: 'Kill switch survives a network change',
      source: 'gitlab',
      ref: 'vpn-ios!341',
      project: 'VPN iOS',
      detail: 'Merged',
    ),
    Activity(at: at(1, 16, 20), kind: 'todo', title: 'Answer Alex about the release date', source: 'slack', ref: '#vpn-team'),
    Activity(at: at(2, 10), kind: 'meeting', title: 'Sprint planning', source: 'calendar', detail: '60 min, 9 people'),
    Activity(at: at(2, 15, 30), kind: 'note', title: 'Found the cause of the double charge: webhook retried twice', source: 'claude', project: 'Backend'),
  ];
}

final sampleSummary = ActivitySummary(
  at: DateTime(_now.year, _now.month, _now.day, 8, 50),
  lines: 8,
  text:
      'VPN iOS\n- Merged the kill switch fix (vpn-ios!341)\n- Started on the login retry loop\n'
      'Backend\n- Approved the rate limit on the license endpoint (backend!212)\n- Found the double charge cause: webhook retried twice',
);
