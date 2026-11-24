import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../state/project_info.dart';
import '../common.dart';
import '../theme.dart';

const platformIcons = {
  'apple': Icons.apple,
  'android': Icons.android,
  'windows': Icons.window,
  'linux': Icons.terminal_rounded,
  'web': Icons.language_rounded,
  'backend': Icons.dns_outlined,
  'extension': Icons.extension_outlined,
  'other': Icons.category_outlined,
};

/// A project's app icon, rounded like a macOS icon, with a badge per
/// platform (two at most) in its corner. [fallback] (or nothing) when the
/// project has no logo or the file is gone.
class ProjectLogo extends StatelessWidget {
  const ProjectLogo({super.key, required this.file, this.size = 18, this.fallback, this.platforms = const []});

  /// Absolute path of the image.
  final String? file;
  final double size;
  final Widget? fallback;
  final List<String> platforms;

  @override
  Widget build(BuildContext context) {
    final none = fallback ?? SizedBox.square(dimension: size);
    final f = file;
    final image = f == null
        ? none
        : ClipRRect(
            borderRadius: BorderRadius.circular(size * .22),
            child: f.toLowerCase().endsWith('.svg')
                ? SvgPicture.file(File(f), width: size, height: size, placeholderBuilder: (_) => none)
                : Image.file(File(f), width: size, height: size, fit: BoxFit.cover, cacheWidth: (size * 3).round(), errorBuilder: (_, _, _) => none),
          );
    final badges = [for (final p in platforms) ?platformIcons[p]].take(2).toList();
    if (badges.isEmpty || (f == null && fallback == null)) return image;
    final b = (size * .55).clamp(9.0, 18.0);
    final c = context.c;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          image,
          for (final (i, icon) in badges.indexed)
            Positioned(
              right: -b * .3 + i * b * .8,
              bottom: -b * .3,
              child: Container(
                width: b,
                height: b,
                decoration: BoxDecoration(
                  color: c.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.fill, width: .5),
                ),
                child: Icon(icon, size: b * .72, color: c.label),
              ),
            ),
        ],
      ),
    );
  }
}

/// Asks, then runs the project info session on [project]: it may replace
/// what Settings holds.
Future<void> analyzeProject(BuildContext context, WidgetRef ref, String project) async {
  final ok = await confirm(
    context,
    title: 'Read the folder again?',
    text:
        'Claude reads the project folder, with the model for pulling data. What it finds replaces the name, '
        'description, other names, logo, platforms, tech, task board, Slack channels and IDE set here. '
        'What it does not find stays as it is.',
    action: 'Analyze',
  );
  if (ok) await ref.read(projectInfosProvider.notifier).analyze(project);
}
