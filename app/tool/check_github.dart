// Live check of the GitHub source through gh, with your own login.
// Run: dart run tool/check_github.dart
import 'dart:io';

import 'package:deck/core/classify/gitlab.dart';
import 'package:deck/sources/github_source.dart';

Future<void> main(List<String> args) async {
  final src = GithubSource();
  stdout.writeln(await src.test());
  final f = await src.fetchAll();
  for (final r in f.records) {
    final c = classifyMr(r, f.me, DateTime.now(), provider: 'github');
    stdout.writeln('${c.ref.padRight(28)} ${c.bucket.name.padRight(8)} ${r.pipeline.padRight(8)} ${c.next}');
  }
  exit(0);
}
