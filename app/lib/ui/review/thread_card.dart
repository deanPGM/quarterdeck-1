// The threads of a review, drawn: the card under its line, the form that
// opens one, and the inbox of every thread. A thread is a talk with Claude
// (never posted) and one answer (what the next publish posts). Pure widgets:
// data in, callbacks out, so goldens and Widgetbook render them without a
// review behind.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/meetings.dart' show clockTime;
import '../../core/classify/time.dart';
import '../../core/review/publish_plan.dart';
import '../../core/review/review.dart';
import '../severity.dart';
import '../common.dart';
import '../parts.dart';
import '../theme.dart';

/// One click questions, shown over the Ask Claude box. What is typed in the
/// box goes along as context.
const askShortcuts = [
  (label: 'Example', body: 'Example?', tip: 'The smallest case that goes wrong, at most five lines'),
  (label: 'More context', body: 'More context?', tip: 'Why it matters and how the code gets there'),
  (label: 'Possible fix', body: 'Possible fix?', tip: 'One way to fix it, at most three lines'),
  (label: 'Shorter', body: 'Shorter.', tip: 'Claude rewrites what will be posted, shorter'),
];

Color _authorColor(DeckColors c, String author) => switch (author) {
  'user' => c.blue,
  'agent' => c.green,
  _ => c.graphite,
};

String anchorLabel(Thread t) {
  final a = t.anchor;
  if (a == null) return 'the whole change';
  return '${a.path}:${a.line == a.endLine ? a.line : '${a.line}-${a.endLine}'}';
}

/// What still needs you: Claude's turn, or an answer to accept or reject.
int openCount(List<Thread> threads) => threads.where((t) => t.waiting || _undecided(t)).length;

bool _undecided(Thread t) => t.answer != null && t.decision == null && _live(t);

bool _rejected(Thread t) => t.state == 'dismissed' || t.decision == 'reject';

/// Still talked over: not rejected, not closed on the forge.
bool _live(Thread t) => t.state == 'open' || t.state == 'published';

String _short(String sha) => sha.substring(0, sha.length.clamp(0, 7));

typedef OnThreadState = Future<void> Function(String state);

/// The user's message to Claude: a button's or their own words.
typedef OnThreadAsk = Future<void> Function(String body);

class SeverityBadge extends StatelessWidget {
  const SeverityBadge(this.severity, {super.key});

  final String severity;

  @override
  Widget build(BuildContext context) => StatusTag(severity, threadColor(context.c, severity));
}

/// Where the fix of a thread stands, as a tag.
class FixTag extends StatelessWidget {
  const FixTag(this.fix, {super.key, this.onOpen});

  final FixStatus fix;

  /// Shows the fix commit's diff. Null: the tag is not clickable.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c, sha = fix.sha == null ? '' : _short(fix.sha!);
    final (text, color) = switch (fix.state) {
      'uncommitted' => ('fix not committed', c.orange),
      'pending' => ('fix $sha, accept to put it on the branch', c.orange),
      'queued' => ('fix $sha, on the branch when Claude is done', c.blue),
      'dropped' => ('fix $sha dropped', c.graphite),
      'local' => ('fix $sha, not pushed', c.blue),
      'pushed' => ('fix $sha pushed', c.green),
      _ => ('fix $sha not on the branch', c.red),
    };
    final tag = StatusTag(text, color, icon: Icons.build_rounded);
    if (onOpen == null || fix.sha == null) return tag;
    return Tooltip(
      message: 'Show the fix diff',
      child: InkWell(onTap: onOpen, borderRadius: BorderRadius.circular(4), child: tag),
    );
  }
}

/// Runs [f] and keeps its error for the card to show.
mixin _Busy<T extends StatefulWidget> on State<T> {
  bool busy = false;
  String? error;

  Future<void> run(Future<void> Function() f) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await f();
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}

Widget _suggestion(BuildContext context, String s) {
  final c = context.c;
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: c.card,
      border: Border.all(color: c.sep),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(s, style: mono(context.t.bodySmall!.copyWith(fontSize: 11.5, color: c.label))),
  );
}

/// One message, colored by author (you blue, Claude green). On the forge:
/// solid, tinted. Talk: faded text on a thin rail, never posted.
class _MessageView extends StatelessWidget {
  const _MessageView(this.m, {required this.own});

  final Message m;

  /// Your own merge request: the remote author is a reviewer.
  final bool own;

  @override
  Widget build(BuildContext context) {
    final c = context.c, posted = isPosted(m);
    final who = switch (m.author) {
      'remote' => own ? 'Reviewer' : 'Author',
      'agent' => 'Claude',
      _ => 'You',
    };
    final color = _authorColor(c, m.author);
    final at = DateTime.tryParse(m.createdAt)?.toLocal();
    final when = at == null ? '' : ' · ${_when(at)}';
    final label = '$who · ${posted ? 'on the merge request' : 'chat'}$when'.toUpperCase();
    if (posted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 4, 6, 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .06),
          border: Border(left: BorderSide(color: color, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.public_rounded, size: 11, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: context.t.labelSmall!.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: .4),
                ),
              ],
            ),
            deckMarkdown(context, m.body),
            if (m.suggestion case final s? when s.isNotEmpty) _suggestion(context, s),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 2, 6, 4),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color.withValues(alpha: .5), width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.t.labelSmall!.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: .4),
          ),
          deckMarkdown(context, m.body, color: c.label2),
          if (m.suggestion case final s? when s.isNotEmpty) _suggestion(context, s),
        ],
      ),
    );
  }
}

/// What the next publish posts, tinted, editable in place, with your call
/// on it: Accept or Reject, on the right of its header.
class _AnswerBox extends StatefulWidget {
  const _AnswerBox({required this.thread, required this.onAnswer, required this.onDecide, required this.editable, required this.own, required this.canPost});

  final Thread thread;
  final Future<void> Function(String body) onAnswer;
  final Future<void> Function(String? decision) onDecide;
  final bool editable, own, canPost;

  @override
  State<_AnswerBox> createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<_AnswerBox> with _Busy {
  TextEditingController? _edit;

  @override
  void dispose() {
    _edit?.dispose();
    super.dispose();
  }

  void _save() => run(() async {
    await widget.onAnswer(_edit!.text);
    if (mounted) setState(() => _edit = null);
  });

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = widget.thread, a = t.answer, editing = _edit;
    final reply = t.remoteId != null, accepted = t.decision == 'accept', resolves = resolvesThread(t, own: widget.own);
    final label = switch ((a, accepted, widget.canPost)) {
      (null, _, true) => 'Nothing will be posted',
      (null, _, false) => 'No comment',
      (_, true, true) => reply ? (resolves ? 'Your reply, will post and resolve' : 'Your reply, will post') : 'Will post',
      (_, false, true) => reply ? 'Proposed reply' : 'Proposed comment',
      (_, true, false) => 'Accepted',
      (_, false, false) => 'Comment',
    };
    final acceptTip = accepted
        ? 'Click again to undo'
        : widget.own
        ? (widget.canPost
              ? 'You agree. Fix all fixes it if it asks for a change, then this reply posts on the next publish'
              : 'You agree. Fix all fixes it if it asks for a change. It stays in Deck: it never was on the merge request')
        : widget.canPost
        ? (reply
              ? (resolves ? 'Post this reply and resolve the thread on the next publish' : 'Post this reply on the next publish')
              : 'Post this comment on the next publish')
        : 'You agree with it';
    // Accepted: blue, it goes out. Proposed: grey until you decide.
    final tone = a == null ? c.label3 : (accepted ? c.blue : c.label2);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 4, 6, 8),
      decoration: BoxDecoration(
        color: a == null ? null : (accepted ? c.blue.withValues(alpha: .08) : c.fill),
        border: Border.all(color: a == null ? c.sep : (accepted ? c.blue.withValues(alpha: .5) : c.sep)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(a == null ? Icons.block_rounded : (accepted ? Icons.send_rounded : Icons.edit_note_rounded), size: 11, color: tone),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: context.t.labelSmall!.copyWith(color: tone, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: .4),
                ),
              ),
              if (widget.editable && editing == null)
                IconButton(
                  tooltip: a == null ? 'Write it yourself' : 'Edit',
                  visualDensity: VisualDensity.compact,
                  iconSize: 15,
                  onPressed: () => setState(() => _edit = TextEditingController(text: a?.body ?? '')),
                  icon: const Icon(Icons.edit_outlined),
                ),
              if (editing == null) ...[
                const SizedBox(width: 2),
                _DecisionButton(
                  label: accepted ? 'Accepted' : 'Accept',
                  tip: acceptTip,
                  icon: Icons.check_rounded,
                  color: c.green,
                  selected: accepted,
                  onPressed: busy || a == null || t.waiting ? null : () => run(() => widget.onDecide(accepted ? null : 'accept')),
                ),
                const SizedBox(width: 4),
                _DecisionButton(
                  label: 'Reject',
                  tip: widget.canPost ? 'Post nothing on this thread' : 'Set it aside',
                  icon: Icons.close_rounded,
                  color: c.red,
                  selected: false,
                  onPressed: busy || t.waiting ? null : () => run(() => widget.onDecide('reject')),
                ),
              ],
            ],
          ),
          if (editing != null) ...[
            const SizedBox(height: 4),
            CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter, meta: true): _save,
                const SingleActivator(LogicalKeyboardKey.escape): () => setState(() => _edit = null),
              },
              child: TextField(
                controller: editing,
                minLines: 2,
                maxLines: 10,
                autofocus: true,
                style: context.t.bodyMedium,
                decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(), hintText: 'Cmd+Enter to save. Empty: nothing is posted.'),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                  onPressed: busy ? null : _save,
                  child: const Text('Save'),
                ),
                TextButton(onPressed: busy ? null : () => setState(() => _edit = null), child: const Text('Cancel')),
              ],
            ),
          ] else if (a != null) ...[
            deckMarkdown(context, a.body),
            if (a.suggestion case final s? when s.isNotEmpty) _suggestion(context, s),
          ],
          if (error != null) Text(error!, style: context.t.bodySmall!.copyWith(color: c.red)),
        ],
      ),
    );
  }
}

/// Your words to Claude, with one click questions over the box. Stays open
/// after you send, so the talk can go on.
class ChatBox extends StatefulWidget {
  const ChatBox({super.key, required this.thread, required this.onAsk, required this.onClose, this.locked});

  final Thread thread;
  final OnThreadAsk onAsk;
  final VoidCallback onClose;

  /// Why Claude cannot be asked now.
  final String? locked;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> with _Busy {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  // Cleared before the card grows: a text change after scrolls the page back
  // to the caret. Put back if the ask fails.
  Future<void> _ask(String body) => run(() async {
    final typed = _text.text;
    _text.clear();
    try {
      await widget.onAsk(body);
    } catch (_) {
      _text.text = typed;
      rethrow;
    }
  });

  void _send() {
    final body = _text.text.trim();
    if (body.isNotEmpty) _ask(body);
  }

  @override
  Widget build(BuildContext context) {
    final off = busy || widget.thread.waiting || widget.locked != null;
    // A click on Send or a chip keeps the focus in the box (macOS drops it on
    // any click outside), so the page holds this card while Claude answers.
    return TextFieldTapRegion(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final a in askShortcuts)
                Tooltip(
                  message: widget.locked ?? a.tip,
                  child: ActionChip(
                    label: Text(a.label, style: context.t.labelMedium),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: off
                        ? null
                        : () {
                            final extra = _text.text.trim();
                            _ask(extra.isEmpty ? a.body : '${a.body}\n\n$extra');
                          },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          CallbackShortcuts(
            // Enter sends, Shift+Enter is a new line.
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter): _send,
              const SingleActivator(LogicalKeyboardKey.numpadEnter): _send,
              const SingleActivator(LogicalKeyboardKey.enter, meta: true): _send,
              const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
            },
            child: TextField(
              controller: _text,
              minLines: 2,
              maxLines: 6,
              autofocus: true,
              style: context.t.bodyMedium,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'A question or context for Claude, never posted (Enter to send, Shift+Enter for a new line)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              FilledButton(
                style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: off ? null : _send,
                child: const Text('Send'),
              ),
              TextButton(onPressed: widget.onClose, child: const Text('Close')),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(error!, style: context.t.bodySmall!.copyWith(color: context.c.red)),
            ),
        ],
      ),
    );
  }
}

/// Accept or Reject: outlined, or filled once chosen.
class _DecisionButton extends StatelessWidget {
  const _DecisionButton({required this.label, required this.tip, required this.icon, required this.color, required this.selected, this.onPressed});

  final String label, tip;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tip,
    child: selected
        ? FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: color).merge(smallButton(context)),
            onPressed: onPressed,
            icon: Icon(icon, size: 14),
            label: Text(label),
          )
        : OutlinedButton(
            style: smallButton(context, color: color),
            onPressed: onPressed,
            child: Text(label),
          ),
  );
}

/// The card under the anchored line: what is on the merge request, the talk
/// with Claude, and the answer that goes out. The talk folds once there is an
/// answer. A thread that asks nothing of you (rejected, resolved, outdated,
/// or [quiet]) starts folded to one line that says what it is about.
class ThreadCard extends StatefulWidget {
  const ThreadCard({
    super.key,
    required this.thread,
    required this.onAsk,
    required this.onAnswer,
    required this.onState,
    required this.onDecide,
    this.thinking = false,
    this.outdated = false,
    this.own = false,
    this.fix,
    this.onShowFix,
    this.locked,
    this.onTerminal,
    this.quiet = false,
    this.canPost = true,
  });

  final Thread thread;

  /// The review has a merge request to publish to. Without one (a local
  /// branch), nothing talks about posting.
  final bool canPost;
  final OnThreadAsk onAsk;

  /// Opens the review's Claude session in a terminal, about this thread.
  final VoidCallback? onTerminal;

  /// On the merge request and asking nothing of you: starts folded.
  final bool quiet;
  final Future<void> Function(String body) onAnswer;
  final OnThreadState onState;
  final Future<void> Function(String? decision) onDecide;

  /// A session is answering it now.
  final bool thinking;

  /// Its line is gone from the current diff.
  final bool outdated;

  /// The review is of your own merge request.
  final bool own;
  final FixStatus? fix;

  /// Opens the diff of fix commit sha.
  final ValueChanged<String>? onShowFix;

  /// Why Claude cannot be asked now.
  final String? locked;

  @override
  State<ThreadCard> createState() => _ThreadCardState();
}

class _ThreadCardState extends State<ThreadCard> {
  /// Null: the default, folded once there is an answer.
  bool? _chat;

  /// Null: the default, folded when the thread asks nothing of you.
  bool? _folded;

  /// The chat box was opened with Ask Claude.
  var _asking = false;

  /// Runs [f], which may shrink this card. When its top was above the screen
  /// (you scrolled down to its buttons), the list keeps that top in place, so
  /// the whole card ended up out of sight: keep its bottom edge where it was.
  Future<void> _steady(FutureOr<void> Function() f) async {
    final view = Scrollable.maybeOf(context);
    double? edge(BuildContext c, {bool bottom = false}) {
      final box = c.mounted ? c.findRenderObject() : null;
      if (box is! RenderBox || !box.attached || !box.hasSize) return null;
      return box.localToGlobal(Offset(0, bottom ? box.size.height : 0)).dy;
    }

    final top = edge(context), viewTop = view == null ? null : edge(view.context), was = edge(context, bottom: true);
    await f();
    if (top == null || viewTop == null || was == null || top >= viewTop) return;
    // The decision is saved, then the page and this card rebuild.
    for (var i = 0; i < 3; i++) {
      await WidgetsBinding.instance.endOfFrame;
    }
    final now = mounted ? edge(context, bottom: true) : null;
    if (now == null || now == was || !view!.position.hasPixels) return;
    final pos = view.position;
    pos.jumpTo((pos.pixels + now - was).clamp(pos.minScrollExtent, pos.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.thread, c = context.c;
    final frame = BoxDecoration(
      color: c.card,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: c.sep),
      boxShadow: context.c.cardShadow,
    );
    final severity = t.authorType == 'remote' ? null : SeverityBadge(t.severity);
    // Waits on Claude, or on your Accept or Reject: stays open.
    final needsYou = t.waiting || (t.answer != null && t.decision == null && !_rejected(t));
    final settled = _rejected(t) || widget.quiet || t.state == 'resolved' || widget.outdated;
    if (_folded ?? (settled && !needsYou)) {
      final label = _rejected(t)
          ? 'rejected'
          : t.state == 'resolved'
          ? 'resolved'
          : t.state == 'published'
          ? 'on the merge request'
          : (t.decision == 'accept' ? 'accepted' : null);
      // What it is about: the opening comment, not the last reply.
      final topic = (t.messages.firstOrNull?.body ?? t.answer?.body ?? '').trim().split('\n').first;
      final replies = t.messages.length - 1;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: frame.copyWith(boxShadow: const []),
        child: Row(
          children: [
            ?severity,
            const SizedBox(width: 8),
            if (label != null) ...[StatusTag(label, c.graphite), const SizedBox(width: 6)],
            if (widget.outdated) ...[StatusTag('outdated', c.orange), const SizedBox(width: 6)],
            if (widget.fix case final f?) ...[FixTag(f, onOpen: f.sha == null ? null : () => widget.onShowFix?.call(f.sha!)), const SizedBox(width: 6)],
            const SizedBox(width: 2),
            Expanded(
              child: Text(topic, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.t.bodyMedium),
            ),
            if (replies > 0) Text('  $replies ${replies == 1 ? 'reply' : 'replies'}', style: context.t.bodySmall),
            TextButton(onPressed: () => setState(() => _folded = false), child: const Text('Show')),
          ],
        ),
      );
    }
    final talk = [
      for (final m in t.messages)
        if (!isPosted(m)) m,
    ];
    final chatOpen = _chat ?? (t.answer == null || t.waiting || _asking);
    final live = _live(t) && !_rejected(t);
    // Once you talk with Claude, the box stays open under the chat.
    final asking = live && (_asking || (chatOpen && talk.isNotEmpty));
    final tag = switch (t.state) {
      _ when _rejected(t) => 'rejected',
      'resolved' => 'resolved',
      'published' => 'on the merge request',
      _ => null,
    };
    Future<void> ask(String b) async {
      await widget.onAsk(b);
      // You are talking here: a thread that waits on the author stays open
      // when Claude is done, instead of folding to one line.
      if (mounted) {
        setState(() {
          _chat = true;
          _folded = false;
        });
      }
    }

    // Top to bottom: what is on the merge request, what goes out with your
    // call on it, then the talk with Claude and the box to write in, last,
    // where a chat has it.
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: frame,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // The tags take the free space and wrap, so long ones never
              // push the buttons off the card.
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ?severity,
                    if (tag != null) StatusTag(tag, c.graphite),
                    if (widget.outdated) StatusTag('outdated', c.orange),
                    if (widget.fix case final f?) FixTag(f, onOpen: f.sha == null ? null : () => widget.onShowFix?.call(f.sha!)),
                  ],
                ),
              ),
              if (_rejected(t))
                TextButton(onPressed: () => t.state == 'dismissed' ? widget.onState('open') : widget.onDecide(null), child: const Text('Restore')),
              if (widget.onTerminal case final open?)
                IconButton(
                  tooltip: 'Talk about this thread with Claude in a terminal',
                  visualDensity: VisualDensity.compact,
                  onPressed: t.waiting ? null : open,
                  icon: const Icon(Icons.terminal_rounded, size: 16),
                ),
              IconButton(
                tooltip: 'Fold to one line',
                visualDensity: VisualDensity.compact,
                onPressed: () => _steady(() => setState(() => _folded = true)),
                icon: const Icon(Icons.unfold_less_rounded, size: 16),
              ),
            ],
          ),
          for (final m in t.messages)
            if (isPosted(m)) ...[const SizedBox(height: 6), _MessageView(m, own: widget.own)],
          if (live && (t.answer != null || t.messages.isNotEmpty)) ...[
            const SizedBox(height: 8),
            _AnswerBox(
              thread: t,
              editable: !t.waiting,
              own: widget.own,
              canPost: widget.canPost,
              onAnswer: widget.onAnswer,
              onDecide: (d) => _steady(() async {
                await widget.onDecide(d);
                if (d != null && mounted) {
                  setState(() {
                    _chat = false;
                    _asking = false;
                  });
                }
              }),
            ),
          ],
          if (talk.isNotEmpty && chatOpen) ...[
            const SizedBox(height: 4),
            TextButton.icon(
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact, textStyle: context.t.labelMedium),
              onPressed: () => _steady(() => setState(() => _chat = !chatOpen)),
              icon: Icon(chatOpen ? Icons.expand_less_rounded : Icons.chat_bubble_outline_rounded, size: 14),
              label: Text(chatOpen ? 'Hide the chat' : 'Chat with Claude (${talk.length})'),
            ),
          ],
          if (chatOpen)
            for (final m in talk) ...[const SizedBox(height: 6), _MessageView(m, own: widget.own)],
          if (t.waiting) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (widget.thinking) ...[
                  SizedBox.square(dimension: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: c.green)),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    widget.thinking ? 'Claude is answering' : (widget.locked ?? 'Waiting for Claude'),
                    style: context.t.bodySmall!.copyWith(color: c.green),
                  ),
                ),
              ],
            ),
          ],
          if (asking) ...[
            const SizedBox(height: 8),
            ChatBox(
              thread: t,
              locked: widget.locked,
              onAsk: ask,
              onClose: () => _steady(
                () => setState(() {
                  _asking = false;
                  _chat = false;
                }),
              ),
            ),
          ] else if (live || (talk.isNotEmpty && !chatOpen)) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                if (live)
                  Tooltip(
                    message: widget.locked ?? 'A question or context for Claude, never posted',
                    child: TextButton.icon(
                      style: TextButton.styleFrom(visualDensity: VisualDensity.compact, textStyle: context.t.labelMedium),
                      onPressed: t.waiting || widget.locked != null ? null : () => setState(() => _asking = true),
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                      label: const Text('Ask Claude…'),
                    ),
                  ),
                if (talk.isNotEmpty && !chatOpen)
                  TextButton.icon(
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact, textStyle: context.t.labelMedium),
                    onPressed: () => _steady(() => setState(() => _chat = true)),
                    icon: const Icon(Icons.expand_more_rounded, size: 14),
                    label: Text('Show the chat (${talk.length})'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// One comment, one severity. [label] says where it goes: a line, a range,
/// or the whole change.
class NewThreadForm extends StatefulWidget {
  const NewThreadForm({super.key, required this.label, required this.onSubmit, required this.onCancel});

  final String label;
  final Future<void> Function(String body, String severity, bool askAgent) onSubmit;
  final VoidCallback onCancel;

  @override
  State<NewThreadForm> createState() => _NewThreadFormState();
}

class _NewThreadFormState extends State<NewThreadForm> with _Busy {
  final _text = TextEditingController();
  var _severity = 'suggestion';

  // A question for Claude: talk, nothing goes to the merge request until Claude writes an answer.
  var _ask = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit() {
    final body = _text.text.trim();
    if (body.isEmpty) return;
    run(() => widget.onSubmit(body, _severity, _ask));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_ask ? '${widget.label}, for Claude' : widget.label, style: context.t.bodySmall),
          const SizedBox(height: 6),
          CallbackShortcuts(
            bindings: {const SingleActivator(LogicalKeyboardKey.enter, meta: true): _submit, const SingleActivator(LogicalKeyboardKey.escape): widget.onCancel},
            child: TextField(
              controller: _text,
              autofocus: true,
              minLines: 3,
              maxLines: 8,
              style: context.t.bodyMedium,
              decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(), hintText: 'Cmd+Enter to add, Esc to cancel'),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final s in severities)
                ChoiceChip(
                  label: Text(s, style: context.t.labelMedium),
                  showCheckmark: false,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  selected: _severity == s,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => setState(() => _severity = s),
                ),
              const SizedBox(width: 4),
              FilterChip(
                label: Text('Ask Claude', style: context.t.labelMedium),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                tooltip: 'Claude answers it in a chat here. Nothing goes to the merge request unless Claude writes a comment.',
                selected: _ask,
                visualDensity: VisualDensity.compact,
                onSelected: (v) => setState(() {
                  _ask = v;
                  if (v) _severity = 'question';
                }),
              ),
              const SizedBox(width: 4),
              FilledButton(
                style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: busy ? null : _submit,
                child: Text(_ask ? 'Ask' : 'Add comment'),
              ),
              TextButton(onPressed: widget.onCancel, child: const Text('Cancel')),
            ],
          ),
          if (error != null) Text(error!, style: context.t.bodySmall!.copyWith(color: c.red)),
        ],
      ),
    );
  }
}

/// Date and local time, as Nov 3 13:06.
String _when(DateTime at) => '${shortDate(at)} ${clockTime(at)}';

/// The "**@name**" line a forge comment pulled into Deck starts with.
final _byline = RegExp(r'^\*\*@([\w.-]+)\*\*\s*');

/// Markdown as one line of plain text, for a preview.
String _plain(String md) => md.replaceAll(RegExp(r'[*`#>]|\[|\]\([^)]*\)'), '').replaceAll(RegExp(r'\s+'), ' ').trim();

/// File name and line: the folder is what gets cut in a narrow panel.
String _shortAnchor(Thread t) {
  final a = t.anchor;
  if (a == null) return 'Whole change';
  return '${a.path.split('/').last}:${a.line == a.endLine ? a.line : '${a.line}-${a.endLine}'}';
}

/// The inbox section a thread sits in. [canFix]: the branch is yours, Fix
/// all can change it. [canPost]: there is a merge request to publish to.
String inboxSection(Thread t, {bool canFix = false, bool canPost = true}) => switch (t) {
  Thread(waiting: true) => 'Waiting on Claude',
  _ when _rejected(t) => 'Rejected',
  _ when t.state == 'resolved' => 'Resolved',
  _ when _undecided(t) => 'To decide',
  _ when canFix && needsFix(t) => 'To fix',
  _ when goesOut(t) => canPost ? 'Will post' : 'Accepted',
  _ when t.state == 'open' => canPost ? 'Nothing to post' : 'Open',
  _ => 'On the merge request',
};

const _sections = [
  (title: 'Waiting on Claude', folded: false),
  (title: 'To decide', folded: false),
  (title: 'To fix', folded: false),
  (title: 'Will post', folded: false),
  (title: 'Accepted', folded: false),
  (title: 'Nothing to post', folded: false),
  (title: 'Open', folded: false),
  (title: 'On the merge request', folded: false),
  (title: 'Rejected', folded: true),
  (title: 'Resolved', folded: true),
];

/// Every thread of the review, in the order you deal with them: decide each
/// one, fix the accepted ones in one go (on a branch that is yours), then
/// publish. A click on one goes to its line.
class ThreadInbox extends StatefulWidget {
  const ThreadInbox({
    super.key,
    required this.threads,
    required this.onOpen,
    required this.onClose,
    this.fixes = const {},
    this.onShowFix,
    this.publish,
    this.onFixAll,
    this.canPost = true,
    this.own = false,
    this.locked,
  });

  final List<Thread> threads;
  final ValueChanged<Thread> onOpen;
  final VoidCallback onClose;
  final Map<String, FixStatus> fixes;

  /// Shows a fix commit's diff, from its tag.
  final ValueChanged<String>? onShowFix;

  /// The publish button at the bottom, when the review has a merge request.
  final Widget? publish;

  /// Asks Claude to fix these threads. Null: the branch is not yours.
  final Future<void> Function(List<String> ids)? onFixAll;
  final bool canPost;

  /// Your own merge request: only replies to reviewers post.
  final bool own;

  /// Why Claude cannot be asked now.
  final String? locked;

  @override
  State<ThreadInbox> createState() => _ThreadInboxState();
}

class _ThreadInboxState extends State<ThreadInbox> with _Busy {
  final _toggled = <String>{};

  @override
  Widget build(BuildContext context) {
    final c = context.c, ts = widget.threads, canFix = widget.onFixAll != null;
    String section(Thread t) => inboxSection(
      t,
      canFix: canFix,
      canPost: widget.canPost && postsOnForge(t, own: widget.own),
    );
    final toFix = [
      for (final t in ts)
        if (section(t) == 'To fix') t.id,
    ];
    final undecided = ts.where((t) => section(t) == 'To decide').length;
    final out = ts.where((t) => section(t) == 'Will post').length;
    final counts = [
      if (undecided > 0) '$undecided to decide',
      if (toFix.isNotEmpty) '${toFix.length} to fix',
      if (widget.canPost && out > 0) '$out will post',
      '${ts.length} total',
    ];
    return Material(
      color: c.sidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 6, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Threads', style: context.t.titleMedium),
                      Text(counts.join(', '), style: context.t.bodySmall),
                    ],
                  ),
                ),
                IconButton(tooltip: 'Close', visualDensity: VisualDensity.compact, onPressed: widget.onClose, icon: const Icon(Icons.close, size: 18)),
              ],
            ),
          ),
          Divider(height: 1, color: c.sep),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                if (ts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("No threads yet. Claude's findings and your own comments land here.", style: context.t.bodySmall),
                  ),
                for (final s in _sections)
                  if (ts.where((t) => section(t) == s.title).toList() case final items when items.isNotEmpty) ...[
                    InkWell(
                      onTap: () => setState(() => _toggled.contains(s.title) ? _toggled.remove(s.title) : _toggled.add(s.title)),
                      child: Container(
                        color: c.fill,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        child: Row(
                          children: [
                            Text(s.title.toUpperCase(), style: context.t.labelSmall!.copyWith(fontWeight: FontWeight.w700, letterSpacing: .4)),
                            const SizedBox(width: 6),
                            Text('${items.length}', style: context.t.labelSmall),
                          ],
                        ),
                      ),
                    ),
                    if (s.folded == _toggled.contains(s.title))
                      for (final t in items) _InboxItem(thread: t, fix: widget.fixes[t.id], onOpen: widget.onOpen, onShowFix: widget.onShowFix),
                  ],
              ],
            ),
          ),
          if (toFix.isNotEmpty || widget.publish != null) ...[
            Divider(height: 1, color: c.sep),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (toFix.isNotEmpty)
                    Tooltip(
                      message:
                          widget.locked ??
                          'Claude fixes each accepted thread that asks for a change, one local commit each, never pushed. '
                              'You read each fix and its reply after.',
                      child: FilledButton.icon(
                        style: const ButtonStyle(visualDensity: VisualDensity.compact),
                        onPressed: busy || widget.locked != null ? null : () => run(() => widget.onFixAll!(toFix)),
                        icon: const Icon(Icons.build_rounded, size: 16),
                        label: Text('Fix ${toFix.length} accepted'),
                      ),
                    ),
                  if (toFix.isNotEmpty && widget.publish != null) const SizedBox(height: 8),
                  ?widget.publish,
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(error!, style: context.t.bodySmall!.copyWith(color: c.red)),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InboxItem extends StatelessWidget {
  const _InboxItem({required this.thread, required this.onOpen, this.fix, this.onShowFix});

  final Thread thread;
  final FixStatus? fix;
  final ValueChanged<Thread> onOpen;
  final ValueChanged<String>? onShowFix;

  @override
  Widget build(BuildContext context) {
    final c = context.c, t = thread;
    // The opening comment, without the forge's "**@name**" line: the name
    // goes in the header.
    // Not on the forge yet: the answer is the comment, the messages only talk.
    final opening = t.remoteId != null ? t.messages.where(isPosted).firstOrNull : null;
    final tagged = opening == null ? null : _byline.firstMatch(opening.body);
    final first = tagged == null ? opening?.body : opening!.body.substring(tagged.end);
    final who = tagged?.group(1);
    final at = DateTime.tryParse(opening?.createdAt ?? '')?.toLocal();
    return InkWell(
      onTap: () => onOpen(t),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.sep, width: .5)),
        ),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (t.authorType != 'remote') ...[SeverityBadge(t.severity), const SizedBox(width: 8)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [_shortAnchor(t), ?who, if (at != null) _when(at)].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.t.bodySmall!.copyWith(fontSize: 11),
                  ),
                  Text(_plain(first ?? t.answer?.body ?? ''), maxLines: 2, overflow: TextOverflow.ellipsis, style: context.t.bodyMedium),
                  if (t.answer != null && first != null)
                    Row(
                      children: [
                        Icon(Icons.subdirectory_arrow_right_rounded, size: 12, color: c.label3),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _plain(t.answer!.body),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.t.bodySmall!.copyWith(color: c.label2),
                          ),
                        ),
                      ],
                    ),
                  if (fix case final f?) ...[
                    const SizedBox(height: 4),
                    FixTag(f, onOpen: f.sha == null || onShowFix == null ? null : () => onShowFix!(f.sha!)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
