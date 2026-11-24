// The review tools of the Deck MCP server: the names, inputs and refusals of
// Skim's (packages/mcp), so the skim-review steps work unchanged. A session
// Deck starts for one review has it in its URL (?project=&review=); any
// other session names it with `project` and `review`.
import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import '../core/review/diff.dart';
import '../core/review/review.dart';
import '../data/review_store.dart';
import '../data/review_git.dart';
import '../sources/review_pull.dart';

abstract interface class ReviewBackend {
  /// The review [id] of [project], with its folder. Null when there is none.
  Future<ReviewService?> reviewOf(String project, String id);

  /// A review changed: the page reads it again.
  void reviewChanged(String project, String id);
}

/// Above this the diff goes out in parts: the agent asks for the rest by path.
const _maxDiffChars = 150000;

Map<String, Object?> _str([String? description]) => {'type': 'string', 'description': ?description};
Map<String, Object?> _list(Map<String, Object?> items, [String? description]) => {'type': 'array', 'items': items, 'description': ?description};
Map<String, Object?> _obj(Map<String, Object?> props, {List<String> required = const []}) => {
  'type': 'object',
  'properties': props,
  if (required.isNotEmpty) 'required': required,
};

final _scope = {
  'project': _str('The Deck project id. Optional in a session Deck started for one review.'),
  'review': _str('The review id, such as gitlab-412. Optional in a session Deck started for one review.'),
};

Tool _tool(String name, String description, [Map<String, Object?> props = const {}, List<String> required = const []]) => Tool(
  name: name,
  description: description,
  inputSchema: ObjectSchema.fromMap(_obj({..._scope, ...props}, required: required)),
);

final _place = {
  'path': _str('A file of the diff.'),
  'line': {'type': 'integer', 'description': 'The line in that file, new side.'},
};

final _feature = _obj(
  {
    'title': _str('The tab label: a few words naming the feature.'),
    'summary': _str('One or two sentences: what the feature does, for whom.'),
    'graph': _obj(
      {
        'caption': _str('One line under the graph.'),
        'nodes': _list(
          _obj(
            {
              'name': _str('The class, interface or module as the code names it. Unique in the graph.'),
              'status': {'type': 'string', 'enum': nodeStatusesForReview},
              'edited': _str('One or two sentences: what this change did to it. Empty for context.'),
              'role': _str('One sentence: what it is for in this feature.'),
              ..._place,
              'side': _str('The lane it runs in when the app spans devices or tiers.'),
            },
            required: ['name', 'status'],
          ),
        ),
        'edges': _list(
          _obj(
            {
              'from': _str('Node name.'),
              'to': _str('Node name.'),
              'kind': {
                'type': 'string',
                'enum': ['extends', 'implements', 'owns', 'uses', 'calls', 'creates'],
              },
              'label': _str('A few words on the arrow.'),
            },
            required: ['from', 'to', 'kind'],
          ),
        ),
      },
      required: ['nodes'],
    ),
    'sequence': _obj(
      {
        'mermaid': _str('sequenceDiagram source, without the ```mermaid fence.'),
        'caption': _str('One line under the picture.'),
        'steps': _list(
          _obj(
            {
              'title': _str('A few words: what happens at this step.'),
              'detail': _str('One or two sentences: how it happens, in the code.'),
              'why': _str('Why the reviewer should care, only when it is not obvious.'),
              ..._place,
              'mark': {
                'type': 'string',
                'enum': ['touched', 'concern'],
              },
              'severity': {
                'type': 'string',
                'enum': ['high', 'medium', 'low'],
              },
            },
            required: ['title'],
          ),
          'One entry per message (arrow), in source order. Not notes, loop, alt or rect lines.',
        ),
      },
      required: ['mermaid'],
    ),
  },
  required: ['title'],
);

const nodeStatusesForReview = ['added', 'changed', 'removed', 'context'];

final _getReview = _tool(
  'get_review',
  'The merge request this review is bound to (title, description, branches), the refs and shas the diff runs between, '
      'counts, how many files are hidden by default, and the tickets the change refers to.',
);

final _getDiff = _tool(
  'get_diff',
  'The parsed diff without noise. Files carrying any of hide_tags are listed under hidden but not expanded. Each hunk '
      'carries a stable ref and lines with old/new numbers, a +/-/space type and a moved flag. Output is capped; when '
      'truncated, call again with paths for the files left out.',
  {
    'hide_tags': _list({'type': 'string'}, 'Tags to hide. Default: ${hiddenByDefault.join(', ')}'),
    'paths': _list({'type': 'string'}, 'Only these paths'),
  },
);

final _getFile = _tool(
  'get_file',
  'One file of the diff with hunk refs. With whole=true also the full file content at the head sha, numbered.',
  {
    'path': _str(),
    'whole': {'type': 'boolean', 'description': 'Include the whole file at head'},
  },
  ['path'],
);

final _getTicket = _tool(
  'get_ticket',
  'The tickets this change refers to (found in the commits, the branch name and the MR text), with their text. Read it '
      'before the diff: it says what the change was supposed to do. Deck never fetches a ticket itself, so one without '
      'text asks you to fetch it with your own tools (a Jira or GitHub MCP, glab, gh) and call set_ticket.',
);

final _setTicket = _tool(
  'set_ticket',
  'Store the text of a ticket you fetched with your own tools, so the reviewer sees it in Deck. body is the ticket as '
      'plain text or markdown: description, acceptance criteria, the comments that matter. Only for references get_ticket listed.',
  {'ref': _str('The reference as get_ticket listed it, e.g. APP-231 or #42'), 'body': _str(), 'title': _str(), 'url': _str()},
  ['ref', 'body'],
);

final _setTicketCheck = _tool(
  'set_ticket_check',
  'Your verdict on whether the change does what the ticket asks, shown at the top of the review. One item per '
      'requirement or acceptance criterion the ticket states: done (with the paths that do it) or missing. One extra '
      'item per topic in the diff that no requirement explains. verdict: fulfilled, partial, not_addressed, unclear. '
      'summary: two or three sentences, the verdict first in plain words, then what is missing.',
  {
    'ref': _str('The reference as get_ticket listed it'),
    'verdict': {
      'type': 'string',
      'enum': ['fulfilled', 'partial', 'not_addressed', 'unclear'],
    },
    'summary': _str(),
    'items': _list(
      _obj(
        {
          'text': _str('The requirement in the ticket\'s words, or what the diff does beyond it'),
          'state': {
            'type': 'string',
            'enum': ['done', 'missing', 'extra'],
          },
          'paths': _list({'type': 'string'}, 'Files of the diff that carry it'),
        },
        required: ['text', 'state'],
      ),
    ),
  },
  ['ref', 'verdict', 'summary', 'items'],
);

final _fileNote = _obj(
  {
    'path': _str(),
    'summary': _str('One sentence under 120 characters: what changed and why it matters.'),
    'extra_tags': _list({'type': 'string'}, 'Kind of change, kebab-case: translations, dependency-bump, config...'),
  },
  required: ['path', 'summary'],
);

final _setFileNote = _tool(
  'set_file_note',
  'One line summary of a file of the diff, shown in the sidebar and the file header, plus extra_tags: the kind of '
      'change, each a chip that hides every file carrying it. Pass one note, or many in notes.',
  {
    'path': _str(),
    'summary': _str(),
    'extra_tags': _list({'type': 'string'}),
    'notes': _list(_fileNote, 'Many notes at once, instead of path and summary'),
  },
);

final _hunkNote = _obj({'path': _str(), 'hunk_ref': _str(), 'summary': _str()}, required: ['hunk_ref', 'summary']);

final _setHunkNote = _tool(
  'set_hunk_note',
  'One line summary for a single hunk, shown above it so the reviewer can skip it without reading. Write one for every '
      'hunk over roughly ten lines. hunk_ref comes from get_diff. Pass one note, or many in notes.',
  {'path': _str(), 'hunk_ref': _str(), 'summary': _str(), 'notes': _list(_hunkNote, 'Many notes at once')},
);

final _setGroups = _tool(
  'set_groups',
  'Replace the reading order: groups of files (optionally hunks) in the order to read them, core change first.',
  {
    'groups': _list(
      _obj(
        {
          'title': _str(),
          'overview': _str(),
          'items': _list(_obj({'path': _str(), 'hunk_ref': _str()}, required: ['path'])),
        },
        required: ['title', 'items'],
      ),
    ),
  },
  ['groups'],
);

final _setChecklist = _tool(
  'set_checklist',
  'The triage, shown on the overview above the chapters: one item per question a reviewer asks before they start '
      'reading. text is the question in a few words. evidence is what you found, in one line. state is ok when the '
      'evidence settles it, concern when it does not, unclear when the diff cannot say. Six items at most. Replaces the '
      'whole list. Skip it on a change too small to triage.',
  {
    'items': _list(
      _obj(
        {
          'text': _str(),
          'state': {
            'type': 'string',
            'enum': ['ok', 'concern', 'unclear'],
          },
          'evidence': _str(),
          'paths': _list({'type': 'string'}, 'Files of the diff that back it'),
        },
        required: ['text', 'state'],
      ),
    ),
  },
  ['items'],
);

final _setFeatures = _tool(
  'set_features',
  'The features of the change, one tab each above the chapters, replaced whole by every call. A feature carries up to '
      'two pictures: `graph`, the classes it touches as data, and `sequence`, mermaid sequenceDiagram source with one '
      'step per arrow; mark the new or changed calls inside a `rect rgb(218, 251, 225)` block. Draw the code as it '
      'stands after the change. Skip the call when the change has nothing to draw.',
  {'features': _list(_feature)},
  ['features'],
);

final _int = {'type': 'integer', 'minimum': 1};

final _listThreads = _tool(
  'list_threads',
  'Threads with their talk (messages; the ones with a remoteId or author remote are on the forge, the others are never '
      'posted) and their answer: the one message the next publish posts. waiting: true when the user asked you something '
      'there and you have not answered. Filter by state, path or waiting.',
  {
    'state': {'type': 'string', 'enum': threadStates},
    'path': _str(),
    'waiting': {'type': 'boolean'},
  },
);

final _addThread = _tool(
  'add_thread',
  'Add a finding anchored to a diff line. body is the comment as it would be posted: it becomes the thread answer, and '
      'goes out when the reviewer publishes unless they reject it. The line must be part of a hunk on the given side. Leave '
      'path and line out for a finding about the whole change (scope, a missing test, the branch itself): it publishes as a '
      'discussion on the merge request rather than on a line.',
  {
    'path': _str(),
    'line': _int,
    'end_line': _int,
    'side': {
      'type': 'string',
      'enum': ['old', 'new'],
      'default': 'new',
    },
    'body': _str(),
    'severity': {'type': 'string', 'enum': severities},
    'suggestion': _str('The replacement text for the anchored lines, posted as a suggestion. Only a complete, compiling one.'),
  },
  ['body', 'severity'],
);

final _reply = _tool(
  'reply',
  'Talk with the user on a thread: your answer to their question, an example, an explanation. Never posted anywhere. '
      'Hands a waiting thread back to the user. When the talk changes what should go out, also call set_answer.',
  {'thread_id': _str(), 'body': _str(), 'suggestion': _str('A patch for the anchored lines, shown in the talk.')},
  ['thread_id', 'body'],
);

final _setAnswer = _tool(
  'set_answer',
  'Write the one message the next publish posts on a thread: the opening comment of a thread not on the forge yet, or '
      'the reply on one that is. Replaces the answer there, so write it whole, as it should read on the merge request. '
      'An empty body clears it: nothing goes out. Hands a waiting thread back to the user.',
  {'thread_id': _str(), 'body': _str(), 'suggestion': _str('The replacement text for the anchored lines, posted as a suggestion.')},
  ['thread_id', 'body'],
);

final _markFixed = _tool(
  'mark_fixed',
  'Record the fix you made for a thread: commit is its sha, a commit on the reviewed head made in this review, usually '
      'the last one (a merge request review follows its local source branch first, so a local commit on it is enough). '
      'Deck takes it off the branch and keeps it aside until the user accepts the answer; commits above it stay, replayed '
      'on its parent. One they need, or one already pushed, stays on the branch and is recorded as there. Leave commit out '
      'only when the change could not be committed. body becomes the thread answer, such as "Fixed in <short sha>: <one line>".',
  {'thread_id': _str(), 'commit': _str(), 'body': _str()},
  ['thread_id', 'body'],
);

final _setThreadState = _tool(
  'set_thread_state',
  'Withdraw one of your own findings before it is posted (dismissed). Publishing and resolving belong to the reviewer.',
  {
    'thread_id': _str(),
    'state': {
      'type': 'string',
      'enum': ['dismissed'],
    },
  },
  ['thread_id', 'state'],
);

final _getRoundDelta = _tool(
  'get_round_delta',
  'Next round input: the diff since the last published round (files, hunks, numbered lines) and every open thread '
      '(published, awaiting_agent, draft) re-anchored on the current head with a status: exact, moved, outdated or general. '
      'Before the first publish, delta is null and threads are still listed.',
);

final _pullDiscussions = _tool(
  'pull_discussions',
  'Fetch the merge request discussions into the review: author and colleague replies land on the matching threads, '
      'unknown inline discussions become remote threads.',
);

/// Adds the review tools to [server]. [project] and [review] are the
/// session's own.
void registerReviewTools(ToolsSupport server, ReviewBackend backend, {String? project, String? review}) {
  CallToolResult json(Object? data) => CallToolResult(content: [TextContent(text: jsonEncode(data))]);
  CallToolResult fail(String message) => CallToolResult(isError: true, content: [TextContent(text: message)]);

  FutureOr<CallToolResult> Function(CallToolRequest) on(Future<Object?> Function(ReviewService s, Map<String, Object?> args) fn, {bool write = false}) {
    return (r) async {
      final args = r.arguments ?? const <String, Object?>{};
      final p = (args['project'] as String?) ?? project;
      final id = (args['review'] as String?) ?? review;
      if (p == null || id == null) return fail('Name the review with project and review: Deck shows both on the review page.');
      final s = await backend.reviewOf(p, id);
      if (s == null) return fail('No review "$id" in project "$p".');
      try {
        final out = await fn(s, args);
        if (write) backend.reviewChanged(p, id);
        return json(out);
      } on ReviewError catch (e) {
        return fail(e.message);
      }
    };
  }

  List<Map<String, Object?>> notesOf(Map<String, Object?> a, List<String> keys) {
    final many = a['notes'];
    if (many is List)
      return [
        for (final n in many)
          if (n is Map) n.cast<String, Object?>(),
      ];
    if (keys.every((k) => a[k] != null)) return [a];
    throw ReviewError('Pass ${keys.join(', ')}, or notes');
  }

  server.registerTool(
    _getReview,
    on((s, _) async {
      final snap = await s.snapshot();
      final refs = await s.ticketRefs();
      final r = s.review;
      return {
        'id': r.id,
        'project': r.project,
        if (r.mr != null) 'mr': r.mr!.toJson(),
        'baseRef': r.baseRef,
        'headRef': r.headRef,
        'baseSha': snap.baseSha,
        'headSha': snap.headSha,
        'stats': {'files': snap.files.length, 'additions': snap.additions, 'deletions': snap.deletions, 'hiddenByDefault': snap.hiddenCount},
        'tickets': [for (final t in refs) t.ref],
        // What an earlier session already wrote, so a resumed one skips it.
        'written': {
          'fileNotes': [for (final n in r.fileNotes) n.path],
          'hunkNotes': r.hunkNotes.length,
          'groups': r.groups.length,
          'features': r.features.length,
          'checklist': r.checklist.length,
          'ticketChecks': [for (final t in r.ticketChecks) t.ref],
        },
      };
    }),
  );
  server.registerTool(
    _getDiff,
    on((s, a) async {
      final snap = await s.snapshot();
      final hide = {...((a['hide_tags'] as List?)?.cast<String>() ?? snap.hidden)};
      final wanted = (a['paths'] as List?)?.cast<String>().toSet();
      final hidden = <Map<String, Object?>>[], files = <Map<String, Object?>>[], omitted = <String>[];
      var size = 0;
      for (final f in snap.files) {
        if (wanted != null && !wanted.contains(f.path)) continue;
        if (wanted == null && f.tags.any(hide.contains)) {
          hidden.add({'path': f.path, 'tags': f.tags});
          continue;
        }
        final shaped = forAgent(f);
        final len = jsonEncode(shaped).length;
        if (size + len > _maxDiffChars && files.isNotEmpty) {
          omitted.add(f.path);
          continue;
        }
        size += len;
        files.add(shaped);
      }
      return {
        'baseSha': snap.baseSha,
        'headSha': snap.headSha,
        'stats': {'files': snap.files.length, 'additions': snap.additions, 'deletions': snap.deletions, 'hiddenByDefault': snap.hiddenCount},
        'files': files,
        'hidden': hidden,
        if (omitted.isNotEmpty) ...{
          'truncated': true,
          'omitted': omitted,
          'note': 'Output capped at $_maxDiffChars chars. Call get_diff with paths for the omitted files.',
        },
      };
    }),
  );
  server.registerTool(
    _getFile,
    on((s, a) async {
      final snap = await s.snapshot();
      final f = snap.files.where((f) => f.path == a['path']).firstOrNull;
      if (f == null) throw ReviewError('Path not in diff: ${a['path']}');
      final out = {'headSha': snap.headSha, ...forAgent(f)};
      if (a['whole'] == true && f.status != 'deleted') {
        final lines = (await showFile(s.root, snap.headSha, f.path)).split('\n');
        out['content'] = [for (final (i, l) in lines.indexed) '${i + 1}\t$l'].join('\n');
      }
      return out;
    }),
  );
  server.registerTool(
    _getTicket,
    on((s, _) async {
      final refs = await s.ticketRefs();
      if (refs.isEmpty) {
        return {'status': 'none', 'message': 'No ticket reference in the commits of this change, its branch name, or the merge request title and description.'};
      }
      final stored = {for (final t in s.review.tickets) t.ref: t};
      final missing = refs.where((t) => stored[t.ref] == null).toList();
      return {
        'status': missing.isEmpty ? 'fetched' : (missing.length == refs.length ? 'no_text' : 'partial'),
        'tickets': [
          for (final t in refs) {'ref': t.ref, 'url': t.url ?? stored[t.ref]?.url, 'title': stored[t.ref]?.title, 'body': stored[t.ref]?.body},
        ],
        if (missing.isNotEmpty)
          'todo': [
            for (final t in missing)
              '${t.ref}: no text yet. Fetch it with your own tools${t.url == null ? '' : ' (${t.url})'} and call set_ticket(ref: "${t.ref}", body, title). '
                  'If you have no tool that reaches it either, say so in one line and review without it.',
          ],
      };
    }),
  );
  server.registerTool(_setTicket, on((s, a) async => (await s.setTicket('${a['ref']}', a)).toJson(), write: true));
  server.registerTool(_setTicketCheck, on((s, a) async => (await s.setTicketCheck('${a['ref']}', a)).toJson(), write: true));
  server.registerTool(
    _setFileNote,
    on(
      (s, a) async => {
        'written': (await s.setFileNotes(notesOf(a, ['path', 'summary']))).length,
      },
      write: true,
    ),
  );
  server.registerTool(
    _setHunkNote,
    on(
      (s, a) async => {
        'written': (await s.setHunkNotes(notesOf(a, ['hunk_ref', 'summary']))).length,
      },
      write: true,
    ),
  );
  server.registerTool(
    _setGroups,
    on(
      (s, a) async => {
        'groups': (await s.setGroups([
          for (final g in (a['groups'] as List?) ?? const [])
            if (g is Map) g.cast<String, Object?>(),
        ])).length,
      },
      write: true,
    ),
  );
  server.registerTool(
    _setChecklist,
    on(
      (s, a) async => {
        'items': (await s.setChecklist([
          for (final g in (a['items'] as List?) ?? const [])
            if (g is Map) g.cast<String, Object?>(),
        ])).length,
      },
      write: true,
    ),
  );
  server.registerTool(
    _setFeatures,
    on(
      (s, a) async => {
        'features': (await s.setFeatures([
          for (final g in (a['features'] as List?) ?? const [])
            if (g is Map) g.cast<String, Object?>(),
        ])).length,
      },
      write: true,
    ),
  );
  String need(Map<String, Object?> a, String key) {
    final v = a[key];
    if (v is! String || v.trim().isEmpty) throw ReviewError('$key must not be empty');
    return v;
  }

  String? opt(Map<String, Object?> a, String key) => a[key] is String && (a[key]! as String).isNotEmpty ? a[key]! as String : null;
  int? integer(Map<String, Object?> a, String key) => a[key] is num ? (a[key]! as num).toInt() : null;

  server.registerTool(
    _getRoundDelta,
    on((s, _) async {
      final d = await s.roundDelta();
      final files = <Map<String, Object?>>[], omitted = <String>[];
      var size = 0;
      for (final f in d.delta?.files ?? const <DiffFile>[]) {
        final shaped = forAgent(f);
        final len = jsonEncode(shaped).length;
        if (size + len > _maxDiffChars && files.isNotEmpty) {
          omitted.add(f.path);
          continue;
        }
        size += len;
        files.add(shaped);
      }
      return {
        'since': d.since?.toJson(),
        'headSha': d.headSha,
        'delta': d.delta == null ? null : {'baseSha': d.delta!.baseSha, 'headSha': d.delta!.headSha, 'files': files},
        'threads': [
          for (final (t, status, anchor) in d.threads) {...t.toJson(), 'anchor': anchor?.toJson(), 'reanchorStatus': status},
        ],
        if (omitted.isNotEmpty) ...{
          'truncated': true,
          'omitted': omitted,
          'note': 'Output capped at $_maxDiffChars chars. Call get_file for the omitted files.',
        },
      };
    }),
  );
  server.registerTool(
    _pullDiscussions,
    on((s, _) async {
      final r = await pullDiscussions(s);
      return {'threadsCreated': r.threadsCreated, 'threadsUpdated': r.threadsUpdated, 'messagesAdded': r.messagesAdded, 'skipped': r.skipped};
    }, write: true),
  );
  server.registerTool(
    _listThreads,
    on(
      (s, a) async => [
        for (final t in s.listThreads(state: opt(a, 'state'), path: opt(a, 'path')))
          if (a['waiting'] is! bool || t.waiting == a['waiting']) t.toJson(),
      ],
    ),
  );
  server.registerTool(
    _addThread,
    on(
      (s, a) async => (await s.addThread(
        path: opt(a, 'path'),
        line: integer(a, 'line'),
        endLine: integer(a, 'end_line'),
        side: opt(a, 'side') ?? 'new',
        body: need(a, 'body'),
        severity: '${a['severity']}',
        suggestion: opt(a, 'suggestion'),
        author: 'agent',
      )).toJson(),
      write: true,
    ),
  );
  server.registerTool(
    _reply,
    on((s, a) async => (await s.reply(need(a, 'thread_id'), body: need(a, 'body'), suggestion: opt(a, 'suggestion'), author: 'agent')).toJson(), write: true),
  );
  server.registerTool(
    _setAnswer,
    on(
      (s, a) async => (await s.setAnswer(need(a, 'thread_id'), body: '${a['body'] ?? ''}', suggestion: opt(a, 'suggestion'), author: 'agent')).toJson(),
      write: true,
    ),
  );
  server.registerTool(
    _markFixed,
    on((s, a) async => (await s.markFixed(need(a, 'thread_id'), body: need(a, 'body'), commit: opt(a, 'commit'))).toJson(), write: true),
  );
  server.registerTool(_setThreadState, on((s, a) async => (await s.setThreadState(need(a, 'thread_id'), '${a['state']}', 'agent')).toJson(), write: true));
}

/// A file the way the tools hand it to an agent: Skim's compact shape.
Map<String, Object?> forAgent(DiffFile f) => {
  'path': f.path,
  if (f.oldPath != f.newPath) 'oldPath': f.oldPath,
  'status': f.status,
  'tags': f.tags,
  'additions': f.additions,
  'deletions': f.deletions,
  'realAdditions': f.realAdditions,
  'realDeletions': f.realDeletions,
  'isBinary': f.isBinary,
  'hunks': [
    for (final h in f.hunks)
      {
        'ref': h.ref,
        'header': h.header,
        'lines': [
          for (final l in h.lines)
            {
              't': l.type == lineAdd ? '+' : (l.type == lineDelete ? '-' : ' '),
              'old': l.oldLine,
              'new': l.newLine,
              'content': l.content,
              if (l.moved) 'moved': true,
            },
        ],
      },
  ],
};
