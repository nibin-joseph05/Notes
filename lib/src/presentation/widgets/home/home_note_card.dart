import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/screens/add_note/add_note_screen.dart';
import 'package:notes/src/presentation/widgets/home/home_delete_dialog.dart';

import '../../providers/note_provider.dart';
import 'home_note_actions.dart';
import '../../widgets/common/global_loader.dart';
class HomeNoteCard extends ConsumerWidget {
  final dynamic note;
  const HomeNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (note == null) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xff111111),
        ),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final hasImage = note.imageUrl != null && note.imageUrl!.isNotEmpty;
    final hasColor = note.bgColor != null;
    final font = note.fontFamily ?? "Poppins";

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.mediumImpact();

        showDialog(
          context: context,
          barrierColor: Colors.black54,
          builder: (context) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 260,
              ),
              backgroundColor: Colors.transparent,
              child: HomeNoteActions(
                isPinned: note.isPinned,
                onEdit: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddNoteScreen(note: note)),
                  );
                },
                onDelete: () {
                  // Close actions dialog
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();

                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return HomeDeleteDialog(
                        onConfirm: () async {
                          Navigator.pop(context);

                          final rootContext = Navigator.of(context, rootNavigator: true).context;

                          if (!context.mounted) return;
                          showGlobalLoader(rootContext);
                          await ref.read(notesProvider.notifier).deleteNote(note.id);
                          if (!context.mounted) return;
                          hideGlobalLoader(rootContext);
                        },
                      );
                    },
                  );
                },

                onPinToggle: () {
                  final notes = ref.read(notesProvider);
                  final pinnedCount = notes.where((n) => n.isPinned).length;
                  final isCurrentlyPinned = note.isPinned == true;

                  if (!isCurrentlyPinned && pinnedCount >= 4) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You can pin up to 4 notes only.'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  ref.read(notesProvider.notifier).togglePin(note.id);
                },
              ),
            );
          },
        );
      },

      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: hasImage
                  ? _AnimatedNoteImage(path: note.imageUrl!)
                  : hasColor
                  ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(note.bgColor!).withOpacity(0.75),
                      Color(note.bgColor!),
                      Color(note.bgColor!).withOpacity(0.75),
                    ],
                  ),
                ),
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
                color: hasImage ? Colors.black.withOpacity(0.22) : Colors.transparent,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.getFont(
                      font,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note.body ?? "",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.getFont(
                      font,
                      fontSize: 14,
                      height: 1.32,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Updated: ${note.updatedAt.toString().substring(0, 10)}",
                    style: GoogleFonts.getFont(
                      font,
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            if (note.isPinned == true)
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

class _AnimatedNoteImage extends StatelessWidget {
  final String path;
  const _AnimatedNoteImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final file = File(path);

    if (!file.existsSync()) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1c1c1c), Color(0xff000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        if (frame == null) {
          return Container(
            color: const Color(0xff111111),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              ),
            ),
          );
        }

        return AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1c1c1c), Color(0xff000000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white38,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
