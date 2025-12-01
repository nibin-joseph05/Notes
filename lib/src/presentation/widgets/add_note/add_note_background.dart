import 'dart:io';
import 'package:flutter/material.dart';

class AddNoteBackground extends StatelessWidget {
  final String? imagePath;

  const AddNoteBackground({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final bool hasCustomImage = imagePath != null && imagePath!.isNotEmpty;

    return Stack(
      children: [
        Positioned.fill(
          child: hasCustomImage
              ? Image.file(File(imagePath!), fit: BoxFit.cover)
              : Image.asset("assets/bg-image/bg.webp", fit: BoxFit.cover),
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
