// The subset of mermaid that agents write in a feature map: sequenceDiagram
// and stateDiagram-v2. Deck draws them natively, so it reads the source itself.
// Lenient on purpose: an unknown line is skipped and kept in `skipped`, the
// rest still draws. Nothing here throws.

/// How an arrow ends: `->>` filled, `->` none, `-x` cross, `-)` async.
enum SeqArrow { filled, open, cross, async, both }

class SeqParticipant {
  SeqParticipant(this.id, this.label, {this.actor = false});
  final String id;
  String label;
  bool actor;
}

sealed class SeqItem {}

class SeqMessage extends SeqItem {
  SeqMessage({required this.index, required this.from, required this.to, required this.text, this.dashed = false, this.arrow = SeqArrow.filled});

  /// Its place among the arrows, which is the step it carries.
  final int index;
  final String from, to, text;

  /// A reply (`-->>`) rather than a call.
  final bool dashed;
  final SeqArrow arrow;
  bool get self => from == to;
}

class SeqNote extends SeqItem {
  SeqNote({required this.side, required this.over, required this.text});

  /// left, right or over.
  final String side;

  /// One participant, or two for a note over both.
  final List<String> over;
  final String text;
}

/// Opens a frame: rect, loop, alt, opt, par, critical, break.
class SeqBlockStart extends SeqItem {
  SeqBlockStart(this.kind, this.label, {this.color});
  final String kind, label;

  /// 0xAARRGGBB, rect only.
  final int? color;
}

/// `else` in an alt, `and` in a par, `option` in a critical.
class SeqBlockSplit extends SeqItem {
  SeqBlockSplit(this.label);
  final String label;
}

class SeqBlockEnd extends SeqItem {}

class SequenceDiagram {
  SequenceDiagram({this.title = '', required this.participants, required this.items, required this.skipped});
  final String title;
  final List<SeqParticipant> participants;

  /// In source order. Every start has its end, even when the source forgot it.
  final List<SeqItem> items;
  final List<String> skipped;

  List<SeqMessage> get messages => items.whereType<SeqMessage>().toList();
}

final _blank = RegExp(r'^\s*(%%.*)?$');
final _participant = RegExp(r'^(?:create\s+)?(participant|actor)\s+(.+?)(?:\s+as\s+(.+))?$', caseSensitive: false);
// Longest arrows first, so `-->>` is not read as `--` then `>>`.
final _message = RegExp(r'^(.+?)\s*(<<-->>|<<->>|-->>|->>|-->|->|--x|-x|--\)|-\))\s*([+-]?)\s*(.+?)\s*(?::(.*))?$');
final _note = RegExp(r'^note\s+(left of|right of|over)\s+([^:]+?)\s*:\s*(.*)$', caseSensitive: false);
// A keyword counts only before a space or the line end: `Alt->>B` is a message.
final _block = RegExp(r'^(loop|alt|opt|par|critical|break|rect)(?:\s+(.*))?$', caseSensitive: false);
final _split = RegExp(r'^(else|and|option)(?:\s+(.*))?$', caseSensitive: false);
final _ignored = RegExp(
  r'^(autonumber|activate|deactivate|destroy|title|acctitle|accdescr|link|links|properties|details|classdef|class|style|direction)(\s|:|$)',
  caseSensitive: false,
);
final _color = RegExp(r'rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([\d.]+)\s*)?\)', caseSensitive: false);

/// Mermaid's escapes in a label: `<br>` breaks the line, `#59;` is a character.
String _text(String s) =>
    s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n').replaceAllMapped(RegExp(r'#(\d+);'), (m) => String.fromCharCode(int.parse(m[1]!))).trim();

String _unquote(String s) {
  s = s.trim();
  return s.length >= 2 && s.startsWith('"') && s.endsWith('"') ? s.substring(1, s.length - 1) : s;
}

SequenceDiagram parseSequence(String source) {
  final parts = <String, SeqParticipant>{};
  final items = <SeqItem>[];
  final skipped = <String>[];
  // What each `end` closes: a frame (true) or a box of participants (false).
  final open = <bool>[];
  var title = '';
  var arrows = 0;
  var header = false;

  SeqParticipant part(String id) => parts.putIfAbsent(id, () => SeqParticipant(id, id));

  for (final raw in source.split('\n')) {
    final line = raw.trim();
    if (_blank.hasMatch(line)) continue;
    if (!header && line.startsWith('sequenceDiagram')) {
      header = true;
      continue;
    }
    final lower = line.toLowerCase();
    if (lower == 'end') {
      if (open.isEmpty) {
        skipped.add(raw);
      } else if (open.removeLast()) {
        items.add(SeqBlockEnd());
      }
      continue;
    }
    if (RegExp(r'^box(\s|$)').hasMatch(lower)) {
      open.add(false);
      continue;
    }
    if (RegExp(r'^title(\s|:|$)').hasMatch(lower)) {
      title = line.substring(5).replaceFirst(RegExp(r'^\s*:?\s*'), '');
      continue;
    }
    if (_participant.firstMatch(line) case final m?) {
      final p = part(_unquote(m[2]!));
      if (m[3] != null) p.label = _text(_unquote(m[3]!));
      p.actor = m[1]!.toLowerCase() == 'actor';
      continue;
    }
    if (_note.firstMatch(line) case final m?) {
      final over = m[2]!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      if (over.isEmpty) {
        skipped.add(raw);
        continue;
      }
      over.forEach(part);
      items.add(SeqNote(side: m[1]!.toLowerCase().split(' ').first, over: over, text: _text(m[3]!)));
      continue;
    }
    if (_block.firstMatch(line) case final m?) {
      final kind = m[1]!.toLowerCase();
      int? color;
      if (kind == 'rect') {
        if (_color.firstMatch(m[2] ?? '') case final c?) {
          final a = c[4] == null ? 255 : (double.parse(c[4]!).clamp(0, 1) * 255).round();
          color = a << 24 | int.parse(c[1]!).clamp(0, 255) << 16 | int.parse(c[2]!).clamp(0, 255) << 8 | int.parse(c[3]!).clamp(0, 255);
        }
      }
      items.add(SeqBlockStart(kind, kind == 'rect' ? '' : _text(m[2] ?? ''), color: color));
      open.add(true);
      continue;
    }
    if (_split.firstMatch(line) case final m? when open.isNotEmpty) {
      items.add(SeqBlockSplit(_text(m[2] ?? '')));
      continue;
    }
    if (_ignored.hasMatch(line)) continue;
    if (_message.firstMatch(line) case final m?) {
      final from = m[1]!.trim(), to = m[4]!.trim();
      if (from.contains(' ') && !parts.containsKey(from) || to.contains(' ') && !parts.containsKey(to)) {
        skipped.add(raw);
        continue;
      }
      final a = m[2]!;
      part(from);
      part(to);
      items.add(
        SeqMessage(
          index: arrows++,
          from: from,
          to: to,
          text: _text(m[5] ?? ''),
          dashed: a.contains('--'),
          arrow: a.startsWith('<<')
              ? SeqArrow.both
              : a.endsWith('>>')
              ? SeqArrow.filled
              : a.endsWith('x')
              ? SeqArrow.cross
              : a.endsWith(')')
              ? SeqArrow.async
              : SeqArrow.open,
        ),
      );
      continue;
    }
    skipped.add(raw);
  }
  for (final keep in open.reversed) {
    if (keep) items.add(SeqBlockEnd());
  }
  return SequenceDiagram(title: title, participants: parts.values.toList(), items: items, skipped: skipped);
}

enum StateKind { normal, start, end, choice, fork, join }

class StateNode {
  StateNode(this.id, this.label, {this.kind = StateKind.normal, this.parent});
  final String id;
  String label;

  /// Can change once: `state x <<choice>>` may come after a transition named x.
  StateKind kind;

  /// The composite state it sits in, null at the top.
  final String? parent;
  final List<String> description = [];

  /// Has states inside: drawn as a state, its inner start hangs off it.
  bool composite = false;
}

class StateTransition {
  StateTransition(this.from, this.to, this.label);
  final String from, to, label;
}

class StateDiagram {
  StateDiagram({required this.direction, required this.states, required this.transitions, required this.skipped});

  /// TB or LR (RL and BT read as those).
  final String direction;

  /// In the order the source first names them.
  final List<StateNode> states;
  final List<StateTransition> transitions;
  final List<String> skipped;
}

final _transition = RegExp(r'^(\S+)\s*-->\s*(\S+?)\s*(?::(.*))?$');
final _stateAs = RegExp(r'^state\s+"([^"]*)"\s+as\s+(\S+?)\s*(\{)?$');
final _stateDecl = RegExp(r'^state\s+(\S+?)(?:\s*<<(choice|fork|join)>>)?\s*(\{)?$');
final _describe = RegExp(r'^([^\s:]+)\s*:\s*(.+)$');

StateDiagram parseState(String source) {
  final states = <String, StateNode>{};
  final transitions = <StateTransition>[];
  final skipped = <String>[];
  final scope = <String>[];
  var direction = 'TB';
  var header = false;
  var inNote = false;

  String? parent() => scope.isEmpty ? null : scope.last;
  // `:::class` styles a state, it does not name one.
  String clean(String id) => id.replaceFirst(RegExp(r':::.*$'), '');

  StateNode node(String raw, {required bool from}) {
    final id = clean(raw);
    if (id == '[*]') {
      final at = parent();
      final key = '${at ?? ''}[*]${from ? 'start' : 'end'}';
      return states.putIfAbsent(key, () => StateNode(key, '', kind: from ? StateKind.start : StateKind.end, parent: at));
    }
    return states.putIfAbsent(id, () => StateNode(id, id, parent: parent()));
  }

  for (final raw in source.split('\n')) {
    final line = raw.trim();
    if (inNote) {
      if (line.toLowerCase() == 'end note') inNote = false;
      continue;
    }
    if (_blank.hasMatch(line)) continue;
    if (!header && line.startsWith('stateDiagram')) {
      header = true;
      continue;
    }
    final lower = line.toLowerCase();
    if (lower.startsWith('note ')) {
      // A note on one line ends with its text; one without a colon runs to `end note`.
      inNote = !line.contains(':');
      continue;
    }
    if (lower.startsWith('direction ')) {
      final d = line.substring(10).trim().toUpperCase();
      direction = d == 'LR' || d == 'RL' ? 'LR' : 'TB';
      continue;
    }
    if (line == '}') {
      if (scope.isNotEmpty) {
        scope.removeLast();
      } else {
        skipped.add(raw);
      }
      continue;
    }
    if (line == '--' || _ignored.hasMatch(line)) continue;
    if (_transition.firstMatch(line) case final m?) {
      final a = node(m[1]!, from: true), b = node(m[2]!, from: false);
      transitions.add(StateTransition(a.id, b.id, _text(m[3] ?? '')));
      continue;
    }
    if (_stateAs.firstMatch(line) case final m?) {
      final s = node(m[2]!, from: false)..label = _text(m[1]!);
      if (m[3] != null) scope.add((s..composite = true).id);
      continue;
    }
    if (_stateDecl.firstMatch(line) case final m?) {
      final id = clean(m[1]!);
      final kind = switch (m[2]) {
        'choice' => StateKind.choice,
        'fork' => StateKind.fork,
        'join' => StateKind.join,
        _ => StateKind.normal,
      };
      final s = states.putIfAbsent(id, () => StateNode(id, id, parent: parent()));
      if (kind != StateKind.normal) {
        s
          ..kind = kind
          ..label = '';
      }
      if (m[3] != null) scope.add((s..composite = true).id);
      continue;
    }
    if (_describe.firstMatch(line) case final m?) {
      // Drawn under the name, so the name the transitions use stays visible.
      node(m[1]!, from: false).description.add(_text(m[2]!));
      continue;
    }
    if (RegExp(r'^[\w.-]+$').hasMatch(line)) {
      node(line, from: false);
      continue;
    }
    skipped.add(raw);
  }
  return StateDiagram(direction: direction, states: states.values.toList(), transitions: transitions, skipped: skipped);
}
