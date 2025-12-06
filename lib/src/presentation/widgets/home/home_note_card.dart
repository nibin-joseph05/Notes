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
import '../../widgets/common/audio_player_widget.dart';

class HomeNoteCard extends ConsumerWidget {
  final dynamic note;
  const HomeNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (note == null) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
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
    final hasAudio = note.audioUrl != null && note.audioUrl!.isNotEmpty;
    final font = note.fontFamily ?? "Poppins";
    final bgColor = hasColor ? Color(note.bgColor!) : const Color(0xff1a1a1a);

    final isDarkBackground = bgColor.computeLuminance() < 0.5;
    final textColor = isDarkBackground ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkBackground
        ? Colors.white70
        : Colors.black87;
    final audioWaveColor = isDarkBackground
        ? Colors.tealAccent
        : Colors.teal[700]!;
    final audioBgColor = isDarkBackground
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.05);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
        color: Colors.transparent,
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.mediumImpact();
            showDialog(
              context: context,
              barrierColor: Colors.black54,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15,
                    vertical: MediaQuery.of(context).size.height * 0.25,
                  ),
                  backgroundColor: Colors.transparent,
                  child: HomeNoteActions(
                    isPinned: note.isPinned,
                    onEdit: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddNoteScreen(note: note),
                        ),
                      );
                      ref.read(notesProvider.notifier).loadNotes();
                    },
                    onDelete: () {
                      Navigator.pop(context);
                      HapticFeedback.lightImpact();
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return HomeDeleteDialog(
                            onConfirm: () async {
                              Navigator.pop(context);
                              final rootContext = Navigator.of(
                                context,
                                rootNavigator: true,
                              ).context;
                              if (!context.mounted) return;
                              showGlobalLoader(rootContext);
                              await ref
                                  .read(notesProvider.notifier)
                                  .deleteNote(note.id);
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
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 130,
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: Stack(
              children: [
                if (hasImage)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(note.imageUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                    ),
                  ),

                if (hasImage)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (note.title?.isNotEmpty == true)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  note.title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.getFont(
                                    font,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                    height: 1.3,
                                  ),
                                ),
                              ),

                            if (note.body?.isNotEmpty == true)
                              Flexible(
                                child: Text(
                                  note.body!,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.getFont(
                                    font,
                                    fontSize: 13,
                                    color: secondaryTextColor,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (hasAudio)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: _buildAudioSection(
                            note.audioUrl!,
                            audioWaveColor,
                            audioBgColor,
                          ),
                        ),

                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: textColor.withOpacity(0.1),
                      ),

                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                _formatDate(note.updatedAt),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.getFont(
                                  font,
                                  fontSize: 11,
                                  color: secondaryTextColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (note.isPinned == true)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.push_pin,
                                        size: 14,
                                        color: textColor.withOpacity(0.8),
                                      ),
                                    ),

                                  if (note.isPinned != true)
                                    Flexible(
                                      child: Text(
                                        "Long press for options",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.getFont(
                                          font,
                                          fontSize: 10,
                                          color: secondaryTextColor.withOpacity(
                                            0.5,
                                          ),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioSection(String audioPath, Color waveColor, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: waveColor.withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.audio_file_outlined, color: waveColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: AudioPlayerWidget(
              audioPath: audioPath,
              waveColor: waveColor,
              backgroundColor: Colors.transparent,
              onRemove: null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";

    if (difference.inDays == 0) {
      return "Today • $formattedDate";
    } else if (difference.inDays == 1) {
      return "Yesterday • $formattedDate";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago • $formattedDate";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()}w ago • $formattedDate";
    } else {
      return formattedDate;
    }
  }
}
