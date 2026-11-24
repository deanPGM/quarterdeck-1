// Tests draw text with a box font. Load the macOS system fonts when present,
// so golden screenshots look like the app.
import 'dart:io';

import 'package:flutter/services.dart';

Future<bool> loadFonts() async {
  const files = {'Roboto': '/System/Library/Fonts/SFNS.ttf', 'Menlo': '/System/Library/Fonts/SFNSMono.ttf'};
  final icons =
      '${Platform.environment['FLUTTER_ROOT'] ?? '${Platform.environment['HOME']}/Library/flutter'}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
  if (!files.values.every((f) => File(f).existsSync()) || !File(icons).existsSync()) return false;
  for (final e in {...files, 'MaterialIcons': icons}.entries) {
    final bytes = File(e.value).readAsBytesSync();
    await (FontLoader(e.key)..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
  }
  return true;
}
