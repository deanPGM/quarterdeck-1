import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ui_memory.dart';
import 'settings.dart';

export '../data/ui_memory.dart';

part 'ui_memory.g.dart';

@Riverpod(keepAlive: true)
UiMemory uiMemory(Ref ref) => UiMemory(File(p.join(ref.watch(homeProvider).cache.path, 'ui.json')));
