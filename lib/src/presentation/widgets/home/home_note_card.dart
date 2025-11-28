import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

class HomeNoteCard extends StatelessWidget {
  final dynamic note;
  const HomeNoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    final hasImage = note.imageUrl != null && note.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [

            Positioned.fill(
              child: hasImage
                  ? Image.file(
                File(note.imageUrl!),
                fit: BoxFit.cover,
              )
                  : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff1c1c1c), Color(0xff000000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),


            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.15),
              ),
            ),


            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.001, sigmaY: 0.001),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.32),
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note.body,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.32,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Updated: ${note.updatedAt.toString().substring(0, 10)}",
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),


            if (note.isPinned)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.push_pin,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
