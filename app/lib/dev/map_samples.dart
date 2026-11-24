// Made up feature map pieces for Widgetbook and the golden tests of the map's
// diagrams: a garden watering app. Never real work data.
import '../core/map/models.dart';

const sampleSequence = MapSequence(
  title: 'Watering',
  caption: 'A dry sensor reading ends with the valve open and the log written.',
  mermaid: '''
sequenceDiagram
  actor G as Gardener
  participant S as SoilSensor
  participant P as WateringPlanner
  participant V as ValveDriver
  participant L as GardenLog
  S->>P: reading(moisture 12%)
  P->>P: compare with bed threshold
  Note right of P: thresholds per bed
  rect rgb(218, 251, 225)
    P->>V: open(bed 3, 40 s)
    V-->>P: opened
  end
  alt rain expected
    P->>L: skip(rain)
  else dry week
    P->>L: write(watered bed 3)
  end
  loop every 10 s
    V->>V: check flow
  end
  P-->>G: notify(watered)
''',
  steps: [
    DiagramStep(
      title: 'The sensor reports a dry bed',
      detail: 'SoilSensor pushes a reading every minute over the local bus.',
      path: 'lib/sensor/soil_sensor.dart',
      line: 42,
    ),
    DiagramStep(
      title: 'The planner checks the threshold',
      detail: 'Each bed has its own threshold, set in the bed settings.',
      path: 'lib/plan/watering_planner.dart',
      line: 88,
    ),
    DiagramStep(
      title: 'The valve opens',
      detail: 'The planner asks the driver to open the valve for a time computed from the bed size.',
      why: 'A valve left open floods the bed: the driver closes it on its own after the time.',
      path: 'lib/valve/valve_driver.dart',
      line: 17,
      mark: 'touched',
    ),
    DiagramStep(title: 'The driver confirms', detail: 'The answer comes back once the flow meter sees water.', mark: 'touched'),
    DiagramStep(title: 'Skip when rain comes', detail: 'The forecast says rain in the next six hours.', path: 'lib/plan/forecast.dart', line: 9),
    DiagramStep(
      title: 'Log the watering',
      detail: 'The log keeps one line per bed and day.',
      why: 'Two writes on the same day replace each other.',
      path: 'lib/log/garden_log.dart',
      line: 51,
      mark: 'concern',
      severity: 'medium',
    ),
    DiagramStep(title: 'Watch the flow', detail: 'The driver checks the flow meter while the valve is open.'),
    DiagramStep(title: 'Tell the gardener', detail: 'A push notification with the bed and the amount.', path: 'lib/notify/push.dart', line: 30),
  ],
);

const sampleState = MapState(
  title: 'Valve',
  caption: 'The valve is closed unless a watering runs.',
  mermaid: '''
stateDiagram-v2
  [*] --> Closed
  Closed --> Opening : open(bed, time)
  Opening --> Open : flow seen
  Opening --> Fault : no flow after 5 s
  Open --> Closed : time is up
  Open --> Fault : flow too high
  Fault --> Closed : gardener resets
  Closed --> [*]
''',
  transitions: [
    MapTransition(title: 'Start', detail: 'The driver starts closed.'),
    MapTransition(title: 'Open asked', detail: 'The planner asks for a watering.', path: 'lib/valve/valve_driver.dart', line: 17),
    MapTransition(title: 'Water flows', detail: 'The flow meter sees water.', path: 'lib/valve/valve_driver.dart', line: 33),
    MapTransition(title: 'No flow', detail: 'Nothing after five seconds: the pipe is empty or blocked.', path: 'lib/valve/valve_driver.dart', line: 40),
    MapTransition(title: 'Done', detail: 'The time computed from the bed size is over.', path: 'lib/valve/valve_driver.dart', line: 58),
    MapTransition(title: 'Leak', detail: 'More flow than the bed can take: a pipe broke.', path: 'lib/valve/valve_driver.dart', line: 61),
    MapTransition(title: 'Reset', detail: 'The gardener confirms the fault in the app.', path: 'lib/ui/fault_banner.dart', line: 12),
    MapTransition(title: 'Shut down', detail: 'The app stops the driver.'),
  ],
);

const sampleGraph = FeatureGraph(
  caption: 'The planner decides, the driver acts, the log remembers.',
  nodes: [
    GraphNode(
      name: 'WateringPlanner',
      status: 'changed',
      edited: 'Skips a watering when rain is due.',
      role: 'Decides which bed gets water and for how long.',
      path: 'lib/plan/watering_planner.dart',
      line: 12,
      side: 'hub',
    ),
    GraphNode(name: 'Planner', role: 'What every planner offers: plan(reading).', path: 'lib/plan/planner.dart', line: 3, side: 'hub'),
    GraphNode(
      name: 'Forecast',
      status: 'added',
      edited: 'New: reads the rain forecast.',
      role: 'Says whether rain is due in the next hours.',
      path: 'lib/plan/forecast.dart',
      line: 5,
      side: 'hub',
    ),
    GraphNode(name: 'BedSettings', role: 'Threshold and size per bed.', path: 'lib/plan/bed_settings.dart', line: 8, side: 'hub'),
    GraphNode(
      name: 'ValveDriver',
      status: 'changed',
      edited: 'Closes on its own after the time.',
      role: 'Opens and closes one valve.',
      path: 'lib/valve/valve_driver.dart',
      line: 10,
      side: 'garden',
    ),
    GraphNode(name: 'SoilSensor', role: 'Reads soil moisture every minute.', path: 'lib/sensor/soil_sensor.dart', line: 20, side: 'garden'),
    GraphNode(name: 'FlowMeter', role: 'Counts the water that went through.', path: 'lib/valve/flow_meter.dart', line: 4, side: 'garden'),
    GraphNode(name: 'OldTimer', status: 'removed', edited: 'Removed: the driver keeps time now.', role: 'Closed the valve after a delay.', side: 'garden'),
    GraphNode(name: 'GardenLog', role: 'One line per bed and day.', side: 'hub', feature: 'history'),
  ],
  edges: [
    GraphEdge(from: 'WateringPlanner', to: 'Planner', kind: 'implements'),
    GraphEdge(from: 'WateringPlanner', to: 'Forecast', kind: 'uses', label: 'rainDue()'),
    GraphEdge(from: 'WateringPlanner', to: 'BedSettings', kind: 'owns'),
    GraphEdge(from: 'WateringPlanner', to: 'ValveDriver', kind: 'calls', label: 'open(bed, time)'),
    GraphEdge(from: 'SoilSensor', to: 'WateringPlanner', kind: 'calls', label: 'reading'),
    GraphEdge(from: 'ValveDriver', to: 'FlowMeter', kind: 'owns'),
    GraphEdge(from: 'ValveDriver', to: 'OldTimer', kind: 'uses'),
    GraphEdge(from: 'WateringPlanner', to: 'GardenLog', kind: 'creates', label: 'entry'),
  ],
);

/// Left to right, with a composite state, a choice and a self transition.
const sampleStateLr = MapState(
  title: 'Season',
  mermaid: '''
stateDiagram-v2
  direction LR
  [*] --> Dormant
  Dormant --> check : spring
  state check <<choice>>
  check --> Growing : soil warm
  check --> Dormant : frost
  state Growing {
    [*] --> Sprout
    Sprout --> Leaf : two weeks
  }
  Growing --> Growing : watered
  Growing --> Harvest : ripe
  Harvest : picked by hand
  Harvest --> [*]
''',
  transitions: [
    MapTransition(title: 'Winter start'),
    MapTransition(title: 'Spring comes', detail: 'The calendar reaches the first spring day.'),
    MapTransition(title: 'Warm enough', detail: 'Soil above 8 degrees.'),
    MapTransition(title: 'Too cold', detail: 'A frost night sends it back.'),
    MapTransition(title: 'Sprouts'),
    MapTransition(title: 'Leaves'),
    MapTransition(title: 'Watered', detail: 'Each watering keeps it growing.'),
    MapTransition(title: 'Ripe', detail: 'The gardener marks the bed ripe.', path: 'lib/season/season.dart', line: 77),
    MapTransition(title: 'Done'),
  ],
);

/// A bigger map graph, every class context, to check a busy picture reads.
const sampleBigGraph = FeatureGraph(
  caption: 'From the app shell to the bed storage.',
  nodes: [
    GraphNode(name: 'GardenApp', role: 'Starts the services and shows the home screen.'),
    GraphNode(name: 'HomeScreen', role: 'Lists the beds with their moisture.'),
    GraphNode(name: 'BedCard', role: 'One bed: name, moisture, last watering.'),
    GraphNode(name: 'BedScreen', role: 'Settings and history of one bed.'),
    GraphNode(name: 'BedController', role: 'Loads a bed and saves its settings.'),
    GraphNode(name: 'BedRepository', role: 'Reads and writes beds on disk.'),
    GraphNode(name: 'Store', role: 'Key value storage on the device.'),
    GraphNode(name: 'FileStore', role: 'Store backed by a JSON file.'),
    GraphNode(name: 'MemoryStore', role: 'Store for tests.'),
    GraphNode(name: 'SyncService', role: 'Sends bed changes to the cloud.'),
    GraphNode(name: 'CloudClient', role: 'HTTP client of the garden cloud.'),
    GraphNode(name: 'AuthToken', role: 'The signed in gardener token.'),
    GraphNode(name: 'Scheduler', role: 'Runs the watering plan every hour.'),
    GraphNode(name: 'WateringPlanner', role: 'Decides which bed gets water.', feature: 'watering'),
    GraphNode(name: 'Notifier', role: 'Shows local notifications.'),
    GraphNode(name: 'Settings', role: 'App wide settings: units, quiet hours.'),
  ],
  edges: [
    GraphEdge(from: 'GardenApp', to: 'HomeScreen', kind: 'creates'),
    GraphEdge(from: 'GardenApp', to: 'Scheduler', kind: 'owns'),
    GraphEdge(from: 'GardenApp', to: 'SyncService', kind: 'owns'),
    GraphEdge(from: 'HomeScreen', to: 'BedCard', kind: 'creates'),
    GraphEdge(from: 'BedCard', to: 'BedScreen', kind: 'calls', label: 'open on tap'),
    GraphEdge(from: 'BedScreen', to: 'BedController', kind: 'uses'),
    GraphEdge(from: 'HomeScreen', to: 'BedController', kind: 'uses', label: 'watch all'),
    GraphEdge(from: 'BedController', to: 'BedRepository', kind: 'calls', label: 'load / save'),
    GraphEdge(from: 'BedRepository', to: 'Store', kind: 'uses'),
    GraphEdge(from: 'FileStore', to: 'Store', kind: 'implements'),
    GraphEdge(from: 'MemoryStore', to: 'Store', kind: 'implements'),
    GraphEdge(from: 'SyncService', to: 'BedRepository', kind: 'uses', label: 'changes'),
    GraphEdge(from: 'SyncService', to: 'CloudClient', kind: 'calls', label: 'PUT /beds/:id'),
    GraphEdge(from: 'CloudClient', to: 'AuthToken', kind: 'uses'),
    GraphEdge(from: 'Scheduler', to: 'WateringPlanner', kind: 'calls', label: 'plan()'),
    GraphEdge(from: 'WateringPlanner', to: 'Notifier', kind: 'calls', label: 'watered'),
    GraphEdge(from: 'Notifier', to: 'Settings', kind: 'uses', label: 'quiet hours'),
    GraphEdge(from: 'BedScreen', to: 'Settings', kind: 'uses', label: 'units'),
  ],
);
