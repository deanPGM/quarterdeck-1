// Live check of the GitLab source through glab, with your own login.
// Run: dart run tool/check_gitlab.dart
import 'dart:io';

import 'package:deck/core/classify/gitlab.dart';
import 'package:deck/sources/gitlab_source.dart';

Future<void> main(List<String> args) async {
  final src = GitlabSource();
  stdout.writeln(await src.test());
  final f = await src.fetchAll();
  final w = Stopwatch()..start();
  await src.fetchAll();
  stdout.writeln('second fetch (unchanged MRs reused): ${w.elapsedMilliseconds} ms');
  for (final r in f.records) {
    final c = classifyMr(r, f.me, DateTime.now());
    stdout.writeln('${c.ref.padRight(28)} ${c.bucket.name.padRight(8)} ${c.next}');
  }
  exit(0);
}
