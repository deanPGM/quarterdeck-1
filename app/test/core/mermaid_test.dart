import 'package:deck/core/map/mermaid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sequence', () {
    test('participants with aliases, actors and the ones only messages name', () {
      final d = parseSequence('''
sequenceDiagram
  %% who takes part
  actor U as Gardener
  participant P as Planter
  participant "Seed Bank"
  U->>P: sow(seed)
  P->>Store: keep it
''');
      expect(d.participants.map((p) => (p.id, p.label, p.actor)), [
        ('U', 'Gardener', true),
        ('P', 'Planter', false),
        ('Seed Bank', 'Seed Bank', false),
        ('Store', 'Store', false),
      ]);
      expect(d.skipped, isEmpty);
    });

    test('arrows: kind, dashed, activation signs and self calls', () {
      final d = parseSequence('''
sequenceDiagram
  autonumber
  A->>B: call
  B-->>A: reply
  A->B: plain
  A-->B: dotted
  A-xB: lost
  A--xB: lost reply
  A-)B: async
  A->>+B: opens
  B-->>-A: closes
  A->>A: think
  A<<->>B: both ways
  activate A
  deactivate A
''');
      final m = d.messages;
      expect(m.map((m) => m.arrow), [
        SeqArrow.filled,
        SeqArrow.filled,
        SeqArrow.open,
        SeqArrow.open,
        SeqArrow.cross,
        SeqArrow.cross,
        SeqArrow.async,
        SeqArrow.filled,
        SeqArrow.filled,
        SeqArrow.filled,
        SeqArrow.both,
      ]);
      expect(m.map((m) => m.dashed), [false, true, false, true, false, true, false, false, true, false, false]);
      expect(m.map((m) => m.index), List.generate(11, (i) => i));
      expect((m[7].to, m[8].to), ('B', 'A'));
      expect(m[9].self, isTrue);
      expect(d.participants.map((p) => p.id), ['A', 'B']);
      expect(d.skipped, isEmpty);
    });

    test('labels keep colons and arrows, break on <br>, decode #59;', () {
      final m = parseSequence('sequenceDiagram\n  A->>B: GET /items/:id -> 200<br/>cached#59; done').messages.single;
      expect(m.text, 'GET /items/:id -> 200\ncached; done');
    });

    test('notes left, right and over two', () {
      final d = parseSequence('''
sequenceDiagram
  Note left of A: first
  note right of B: second
  Note over A,B: both
''');
      final n = d.items.cast<SeqNote>();
      expect(n.map((n) => (n.side, n.over.join(','), n.text)), [('left', 'A', 'first'), ('right', 'B', 'second'), ('over', 'A,B', 'both')]);
    });

    test('rect blocks carry their colour, frames their label and splits', () {
      final d = parseSequence('''
sequenceDiagram
  rect rgb(218, 251, 225)
    A->>B: new
  end
  rect rgba(0, 0, 255, 0.5)
    A->>B: other
  end
  alt cache hit
    B-->>A: cached
  else miss
    B->>C: fetch
  end
  loop every minute
    par
      A->>B: one
    and
      A->>C: two
    end
  end
  opt
    A->>B: maybe
  end
''');
      final starts = d.items.whereType<SeqBlockStart>().toList();
      expect(starts.map((s) => (s.kind, s.label)), [('rect', ''), ('rect', ''), ('alt', 'cache hit'), ('loop', 'every minute'), ('par', ''), ('opt', '')]);
      expect(starts[0].color, 0xFFDAFBE1);
      expect(starts[1].color, 0x800000FF);
      expect(d.items.whereType<SeqBlockSplit>().map((s) => s.label), ['miss', '']);
      expect(d.items.whereType<SeqBlockEnd>().length, 6);
      expect(d.messages.length, 7);
      expect(d.skipped, isEmpty);
    });

    test('critical, break and boxes; a missing end is closed', () {
      final d = parseSequence('''
sequenceDiagram
  box Aqua Front
    participant A
  end
  critical connect
    A->>B: open
  option timeout
    A->>A: retry
  end
  break when closed
    A->>B: stop
''');
      expect(d.items.whereType<SeqBlockStart>().map((s) => s.kind), ['critical', 'break']);
      expect(d.items.whereType<SeqBlockSplit>().single.label, 'timeout');
      expect(d.items.last, isA<SeqBlockEnd>());
      expect(d.items.whereType<SeqBlockEnd>().length, 2);
      expect(d.skipped, isEmpty);
    });

    test('a keyword glued to an arrow is a participant, title is kept', () {
      final d = parseSequence('sequenceDiagram\n  title: Watering\n  Alt->>Style: go');
      expect(d.title, 'Watering');
      expect(d.messages.single.from, 'Alt');
      expect(d.messages.single.to, 'Style');
    });

    test('unknown lines are skipped, never thrown', () {
      final d = parseSequence('sequenceDiagram\n  A->>B: ok\n  this is not mermaid\n  end\n  }}}');
      expect(d.messages.length, 1);
      expect(d.skipped.map((s) => s.trim()), ['this is not mermaid', 'end', '}}}']);
      expect(parseSequence('').items, isEmpty);
    });
  });

  group('state', () {
    test('start, end, transitions with labels in source order', () {
      final d = parseState('''
stateDiagram-v2
  [*] --> Idle
  Idle --> Watering : soil dry
  Watering --> Idle : soil wet: stop
  Watering --> [*]
''');
      expect(d.states.map((s) => (s.id, s.kind)), [
        ('[*]start', StateKind.start),
        ('Idle', StateKind.normal),
        ('Watering', StateKind.normal),
        ('[*]end', StateKind.end),
      ]);
      expect(d.transitions.map((t) => (t.from, t.to, t.label)), [
        ('[*]start', 'Idle', ''),
        ('Idle', 'Watering', 'soil dry'),
        ('Watering', 'Idle', 'soil wet: stop'),
        ('Watering', '[*]end', ''),
      ]);
      expect(d.direction, 'TB');
      expect(d.skipped, isEmpty);
    });

    test('labels, descriptions, pseudo states, direction and styles', () {
      final d = parseState('''
stateDiagram-v2
  direction LR
  state "Waiting for rain" as Wait
  Dry : Soil is dry
  Dry : below 20 percent
  Wait --> check
  state check <<choice>>
  state split <<fork>>
  check --> Dry:::warn : no rain
  classDef warn fill:#f00
  class Dry warn
  note right of Dry : looked at hourly
  note left of Wait
    several lines
    of note
  end note
  Lonely
''');
      final by = {for (final s in d.states) s.id: s};
      expect(d.direction, 'LR');
      expect(by['Wait']!.label, 'Waiting for rain');
      expect(by['Dry']!.label, 'Dry');
      expect(by['Dry']!.description, ['Soil is dry', 'below 20 percent']);
      expect(by['check']!.kind, StateKind.choice);
      expect(by['split']!.kind, StateKind.fork);
      expect(by.containsKey('Lonely'), isTrue);
      expect(d.transitions.last.to, 'Dry');
      expect(d.skipped, isEmpty);
    });

    test('composite states keep their parent and scope their start', () {
      final d = parseState('''
stateDiagram-v2
  [*] --> Growing
  state Growing {
    [*] --> Sprout
    Sprout --> Leaf
    --
    Leaf --> [*]
  }
  Growing --> Harvest
''');
      final by = {for (final s in d.states) s.id: s};
      expect(by['Growing']!.composite, isTrue);
      expect(by['Sprout']!.parent, 'Growing');
      expect(by['Growing[*]start']!.kind, StateKind.start);
      expect(by['Growing[*]end']!.parent, 'Growing');
      expect(by['Harvest']!.parent, isNull);
      expect(d.transitions.length, 5);
      expect(d.skipped, isEmpty);
    });

    test('unknown lines are skipped', () {
      final d = parseState('stateDiagram-v2\n  A --> B\n  what is this\n  }');
      expect(d.transitions.length, 1);
      expect(d.skipped.map((s) => s.trim()), ['what is this', '}']);
    });
  });
}
