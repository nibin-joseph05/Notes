import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

class AppBackground extends ConsumerWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final path = settings.wallpaperPath;
    final hasCustom = path.isNotEmpty;

    return Stack(
      children: [
        Positioned.fill(
          child: hasCustom
              ? Image.file(File(path), fit: BoxFit.cover)
              : Image.asset("assets/add-note-bg/default-bg.png", fit: BoxFit.cover),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.28),
                Colors.black.withOpacity(0.46),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
