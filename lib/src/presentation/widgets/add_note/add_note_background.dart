import 'package:flutter/material.dart';

class AddNoteBackground extends StatelessWidget {
  final String? imagePath;

  const AddNoteBackground({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imagePath ?? "assets/add-note-bg/splash.png",
            fit: BoxFit.cover,
          ),
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
