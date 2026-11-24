// A made up feature map and merge requests for the sample project, for golden
// tests and Widgetbook.
import 'package:clock/clock.dart';
import 'package:deck/core/map/models.dart';
import 'package:deck/core/models/records.dart';

const _connectFlow = '''
sequenceDiagram
  actor U as User
  participant B as ConnectButton
  participant M as TunnelManager
  participant A as AccountStore
  participant P as PacketTunnel
  U->>B: tap Connect
  B->>M: connect()
  M->>A: token()
  A-->>M: session token
  M->>P: startTunnel(config)
  P-->>M: connected
  M-->>B: state = connected
''';

const _connectStates = '''
stateDiagram-v2
  [*] --> disconnected
  disconnected --> connecting : connect()
  connecting --> connected : tunnel up
  connecting --> disconnected : error
  connected --> disconnecting : disconnect()
  disconnecting --> disconnected
''';

final sampleMap = FeatureMap(
  root: '/Users/sam/work/vpn-ios',
  commit: 'a1b2c3d4e5f60718293a4b5c6d7e8f9012345678',
  updatedAt: '2026-10-13T16:20:00Z',
  head: 'f0e1d2c3b4a5968778695a4b3c2d1e0f12345678',
  staleFeatures: ['plan-picker'],
  architecture: const MapArchitecture(
    summary: 'MVVM in four layers. Screens show state and send intents to their ViewModel; ViewModels call managers through protocols; managers own the network and the system APIs.',
    sources: ['docs/architecture.md'],
    rules: ['Screens never reach a manager: they go through their ViewModel.', 'Managers are injected through a protocol, never .shared inside an init.'],
    layers: [
      ArchLayer(
        id: 'view',
        name: 'Views',
        role: 'SwiftUI screens and widgets. No logic, no manager calls.',
        naming: ['*Screen', '*View', '*Widget'],
        examples: ['HomeScreen', 'PlanPickerScreen', 'ConnectButton'],
      ),
      ArchLayer(
        id: 'view-model',
        name: 'ViewModels',
        role: 'Screen state and intents. Talk to managers through protocols.',
        naming: ['*ViewModel'],
        examples: ['HomeViewModel', 'PlanPickerViewModel'],
      ),
      ArchLayer(
        id: 'manager',
        name: 'Managers',
        role: 'Business rules, one per domain. Shared, injected.',
        naming: ['*Manager', '*Orchestrator'],
        examples: ['TunnelManager', 'AccountStore', 'PurchasesManager'],
      ),
      ArchLayer(
        id: 'foundation',
        name: 'Foundation',
        role: 'Network clients, keychain, logging.',
        naming: ['*Client', '*Helper'],
        examples: ['ApiClient', 'KeychainHelper', 'Log'],
      ),
    ],
    flows: [
      ArchFlow(from: 'view', to: 'view-model'),
      ArchFlow(from: 'view-model', to: 'manager', label: 'through protocols'),
      ArchFlow(from: 'manager', to: 'foundation'),
    ],
    violations: [
      ArchViolation(
        from: 'PlanPickerScreen',
        fromLayer: 'view',
        to: ['PurchasesManager'],
        toLayer: 'manager',
        severity: 'high',
        why: 'Starts the purchase itself through PurchasesManager.shared, so the purchase flow has no test.',
        fix: 'Move the purchase into PlanPickerViewModel.',
        path: 'App/Plans/PlanPicker.swift',
        line: 41,
      ),
      ArchViolation(
        from: 'SettingsScreen',
        fromLayer: 'view',
        to: ['AccountStore', 'TunnelManager'],
        toLayer: 'manager',
        severity: 'medium',
        why: 'Reads the account and the tunnel state directly to show two labels.',
        fix: 'Create a SettingsViewModel.',
      ),
      ArchViolation(
        from: 'DebugScreen',
        fromLayer: 'view',
        to: ['TunnelManager'],
        toLayer: 'manager',
        severity: 'accepted',
        why: 'Debug only screen, agreed in the docs.',
      ),
      ArchViolation(
        from: 'HomeViewModel',
        fromLayer: 'view-model',
        to: ['KeychainHelper'],
        toLayer: 'foundation',
        severity: 'low',
        why: 'Reads a flag from the keychain instead of asking AccountStore.',
      ),
    ],
  ),
  ui: const MapUi(
    summary: 'SwiftUI with one theme in Theme.swift. Screens build from the shared views in App/Shared and never set a color or a font by hand.',
    sources: ['docs/ui.md'],
    rules: ['Colors and fonts come from Theme, never a raw Color or .font(.system(...)).', 'A list row is SettingsRow; a primary action is PrimaryButton.'],
    paths: ['App'],
    tokens: [
      UiToken(kind: 'color', name: 'Theme.accent', path: 'App/Shared/Theme.swift', line: 4),
      UiToken(kind: 'color', name: 'Theme.danger', path: 'App/Shared/Theme.swift', line: 5),
      UiToken(kind: 'color', name: 'Theme.secondary', path: 'App/Shared/Theme.swift', line: 6),
      UiToken(kind: 'type', name: 'Theme.title', path: 'App/Shared/Theme.swift', line: 12),
      UiToken(kind: 'type', name: 'Theme.body', path: 'App/Shared/Theme.swift', line: 13),
      UiToken(kind: 'spacing', name: 'Spacing.s', note: '8 pt'),
      UiToken(kind: 'spacing', name: 'Spacing.m', note: '16 pt'),
    ],
    components: [
      UiComponent(name: 'PrimaryButton', role: 'The one filled button of a screen.', path: 'App/Shared/PrimaryButton.swift', line: 3),
      UiComponent(name: 'SettingsRow', role: 'A row with an icon, a label and a value.', path: 'App/Shared/SettingsRow.swift', line: 3),
      UiComponent(name: 'StatusBadge', role: 'The connection state as a colored pill.', path: 'App/Shared/StatusBadge.swift', line: 3),
    ],
    screens: [
      UiScreen(name: 'HomeScreen', role: 'Connect and see the state.', path: 'App/Home/HomeScreen.swift', uses: ['PrimaryButton', 'StatusBadge']),
      UiScreen(name: 'PlanPickerScreen', role: 'Pick a plan and pay.', path: 'App/Plans/PlanPicker.swift', uses: ['PrimaryButton']),
      UiScreen(name: 'SettingsScreen', role: 'Account, protocol and support.', path: 'App/Settings/SettingsScreen.swift', uses: ['SettingsRow', 'StatusBadge']),
    ],
    duplicates: [
      UiDuplicate(
        title: 'Plan row',
        severity: 'high',
        why: 'PlanRow and OfferRow draw the same price card; OfferRow lost the selected border, so the onboarding offer never looks picked.',
        use: 'PlanRow',
        copies: [
          UiCopy(name: 'PlanRow', path: 'App/Plans/PlanRow.swift', line: 8),
          UiCopy(name: 'OfferRow', path: 'App/Onboarding/OfferRow.swift', line: 12),
        ],
      ),
      UiDuplicate(
        title: 'Settings list row',
        severity: 'medium',
        why: 'DebugScreen builds its rows by hand with the same HStack as SettingsRow.',
        use: 'SettingsRow',
        copies: [
          UiCopy(name: 'SettingsRow', path: 'App/Shared/SettingsRow.swift'),
          UiCopy(name: 'DebugScreen.row', path: 'App/Debug/DebugScreen.swift', line: 40),
        ],
      ),
    ],
    breaks: [
      UiBreak(
        rule: 'Raw color',
        severity: 'medium',
        where: 'PlanPickerScreen',
        count: 6,
        why: 'Color(.systemBlue) instead of Theme.accent: the plan screen stays blue in the dark theme.',
        fix: 'Use Theme.accent.',
        path: 'App/Plans/PlanPicker.swift',
        line: 57,
      ),
      UiBreak(
        rule: 'System font',
        severity: 'low',
        where: 'StatusBadge',
        why: '.font(.system(size: 11)) ignores Dynamic Type.',
        path: 'App/Shared/StatusBadge.swift',
        line: 14,
      ),
    ],
  ),
  changedFiles: ['App/Plans/PlanPicker.swift', 'App/Plans/PlanRow.swift'],
  features: [
    const MapFeature(
      id: 'architecture',
      title: 'Architecture',
      summary: 'The app, the tunnel extension and the two shared kits, and which one depends on which.',
      paths: ['App', 'TunnelKit', 'AccountKit', 'PacketTunnel'],
      graph: FeatureGraph(
        nodes: [
          GraphNode(name: 'App', role: 'Screens, navigation and the purchase flow.', path: 'App'),
          GraphNode(name: 'TunnelKit', role: 'Starts and watches the VPN tunnel.', path: 'TunnelKit'),
          GraphNode(name: 'AccountKit', role: 'Sign in, session token and plan state.', path: 'AccountKit'),
          GraphNode(name: 'PacketTunnel', role: 'The system extension that carries the traffic.', path: 'PacketTunnel', side: 'extension'),
        ],
        edges: [
          GraphEdge(from: 'App', to: 'TunnelKit', kind: 'uses'),
          GraphEdge(from: 'App', to: 'AccountKit', kind: 'uses'),
          GraphEdge(from: 'TunnelKit', to: 'PacketTunnel', kind: 'calls', label: 'startTunnel'),
        ],
      ),
    ),
    const MapFeature(
      id: 'account',
      title: 'Account',
      summary: 'Sign in with email, keep the session token in the keychain and refresh it before it expires.',
      paths: ['AccountKit'],
    ),
    const MapFeature(
      id: 'plan-picker',
      title: 'Plan picker',
      summary: 'Shows the plans from the store, with the yearly one first, and starts the purchase.',
      paths: ['App/Plans'],
      sequences: [MapSequence(mermaid: 'sequenceDiagram\n  participant V as PlanPicker\n  participant S as Store\n  V->>S: products()\n  S-->>V: plans')],
    ),
    const MapFeature(
      id: 'tunnel-connect',
      title: 'Tunnel connect',
      summary: 'One tap connects: the app asks the account for a session token, then starts the tunnel extension with it.',
      paths: ['TunnelKit', 'App/Home/ConnectButton.swift'],
      graph: FeatureGraph(
        caption: 'The manager is the only class that talks to the extension.',
        nodes: [
          GraphNode(name: 'ConnectButton', role: 'The big button on the home screen.', path: 'App/Home/ConnectButton.swift', line: 12, side: 'app'),
          GraphNode(
            name: 'TunnelManager',
            role: 'Owns the system VPN profile and the connection state.',
            path: 'TunnelKit/TunnelManager.swift',
            line: 8,
            side: 'app',
          ),
          GraphNode(name: 'AccountStore', role: 'Hands out a fresh session token.', feature: 'account', side: 'app'),
          GraphNode(
            name: 'PacketTunnel',
            role: 'Builds the tunnel from the config it is given.',
            path: 'PacketTunnel/PacketTunnel.swift',
            line: 5,
            side: 'extension',
          ),
        ],
        edges: [
          GraphEdge(from: 'ConnectButton', to: 'TunnelManager', kind: 'calls', label: 'connect()'),
          GraphEdge(from: 'TunnelManager', to: 'AccountStore', kind: 'uses', label: 'token()'),
          GraphEdge(from: 'TunnelManager', to: 'PacketTunnel', kind: 'calls', label: 'startTunnel'),
        ],
      ),
      sequences: [
        MapSequence(
          title: 'Connect',
          mermaid: _connectFlow,
          caption: 'The token is fetched on every connect, never cached in the extension.',
          steps: [
            DiagramStep(title: 'Tap', detail: 'The button is disabled while connecting.'),
            DiagramStep(title: 'Connect', path: 'TunnelKit/TunnelManager.swift', line: 40),
            DiagramStep(title: 'Ask for a token', detail: 'Refreshed first when it expires within a minute.'),
            DiagramStep(title: 'Token'),
            DiagramStep(
              title: 'Start the extension',
              detail: 'The token goes in the provider configuration.',
              mark: 'concern',
              severity: 'medium',
              why: 'The configuration is stored in plain text by the system.',
            ),
            DiagramStep(title: 'Connected'),
            DiagramStep(title: 'State to the button'),
          ],
        ),
      ],
      states: [
        MapState(
          title: 'Connection',
          mermaid: _connectStates,
          transitions: [
            MapTransition(title: 'Start'),
            MapTransition(title: 'Connect', detail: 'From the button or on demand rules.'),
            MapTransition(title: 'Tunnel up'),
            MapTransition(title: 'Error', detail: 'Shown as a banner on the home screen.'),
            MapTransition(title: 'Disconnect'),
            MapTransition(title: 'Stopped'),
          ],
        ),
      ],
      links: [MapLink(feature: 'account', kind: 'calls', detail: 'session token')],
      notes: [MapNote(kind: 'platform', text: 'On macOS the extension is a system extension, approved once in System Settings.')],
      data: [MapDataUse(type: 'tunnel-config', use: 'writes', detail: 'on every connect')],
    ),
  ],
  dataTypes: [
    const MapDataType(
      id: 'tunnel-config',
      name: 'TunnelConfig',
      boundary: 'storage',
      summary: 'What the app hands to the tunnel extension through the provider configuration.',
      since: '2',
      fields: [
        MapDataField(name: 'server', type: 'String', note: 'host name'),
        MapDataField(name: 'token', type: 'SessionToken'),
        MapDataField(name: 'killSwitch', type: 'Bool', optional: true, since: '3'),
      ],
      definitions: [MapDefinition(path: 'TunnelKit/TunnelConfig.swift', line: 3)],
    ),
    const MapDataType(
      id: 'session-token',
      name: 'SessionToken',
      boundary: 'wire',
      summary: 'The token the backend gives on sign in.',
      fields: [
        MapDataField(name: 'value', type: 'String'),
        MapDataField(name: 'expiresAt', type: 'Date'),
      ],
      definitions: [MapDefinition(path: 'AccountKit/SessionToken.swift', line: 1)],
    ),
  ],
);

List<ProjectMr> sampleProjectMrs() {
  final now = clock.now();
  return [
    ProjectMr(
      iid: 412,
      title: 'Kill switch on the tunnel config',
      url: 'https://gitlab.com/acme/vpn-ios/-/merge_requests/412',
      author: 'robin',
      branch: 'feat/kill-switch',
      updatedAt: now.subtract(const Duration(hours: 2)),
      reviewer: true,
    ),
    ProjectMr(
      iid: 409,
      title: 'Yearly plan first in the picker',
      url: 'https://gitlab.com/acme/vpn-ios/-/merge_requests/409',
      author: 'sam',
      branch: 'feat/yearly-first',
      updatedAt: now.subtract(const Duration(hours: 5)),
      mine: true,
    ),
    ProjectMr(
      iid: 401,
      title: 'Draft: new onboarding',
      url: 'https://gitlab.com/acme/vpn-ios/-/merge_requests/401',
      author: 'alex',
      branch: 'feat/onboarding',
      updatedAt: now.subtract(const Duration(days: 3)),
      draft: true,
    ),
  ];
}
