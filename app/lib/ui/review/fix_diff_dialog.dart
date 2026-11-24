import 'package:flutter/material.dart';

import '../../core/review/diff.dart';
import 'file_diff.dart';

/// What a fix commit changed, so you read it before it is pushed.
class FixDiffDialog extends StatelessWidget {
  const FixDiffDialog({super.key, required this.sha, required this.files});

  final String sha;
  final Future<List<DiffFile>> files;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Fix ${sha.substring(0, sha.length.clamp(0, 8))}'),
    content: SizedBox(
      width: 900,
      height: 600,
      child: FutureBuilder(
        future: files,
        builder: (context, s) => switch (s) {
          AsyncSnapshot(:final error?) => Text('Could not read the commit: $error'),
          AsyncSnapshot(data: final files?) when files.isEmpty => const Text('The commit changes no file.'),
          // FileDiffView is a sliver, with its own gap below.
          AsyncSnapshot(data: final files?) => CustomScrollView(slivers: [for (final f in files) FileDiffView(file: f)]),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    ),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
  );
}
