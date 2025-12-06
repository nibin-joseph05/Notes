import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/note_entity.dart';
import '../../providers/note_provider.dart';
import '../../widgets/add_note/add_note_background.dart';
import '../../widgets/add_note/add_note_appbar.dart';
import '../../widgets/add_note/add_note_fields.dart';
import '../../widgets/add_note/add_note_font_selector.dart';
import '../../widgets/add_note/add_note_footer.dart';
import '../../widgets/common/app_background.dart';
import '../../widgets/add_note/add_note_color_selector.dart';
import '../../widgets/common/audio_player_widget.dart';
import '../../widgets/common/global_loader.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  final NoteEntity? note;
  const AddNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController bodyCtrl = TextEditingController();
  bool isPinned = false;
  File? selectedImage;
  int? selectedColor;
  String? selectedFont;
  File? selectedAudio;
  String? savedAudio;
  bool _audioDeleted = false;
  bool _hasInitialized = false;

  Color get textColor {
    if (selectedImage != null && selectedImage!.existsSync()) {
      try {
        final bytes = selectedImage!.readAsBytesSync();
        if (bytes.length > 3000) {
          int mid = bytes.length ~/ 2;
          int r = bytes[mid];
          int g = bytes[mid + 1];
          int b = bytes[mid + 2];
          final brightness = (r * 299 + g * 587 + b * 114) / 1000;
          return brightness > 150 ? Colors.black : Colors.white;
        }
      } catch (_) {}
      return Colors.white;
    }

    if (selectedColor != null) {
      final c = Color(selectedColor!);
      final brightness = (c.red * 299 + c.green * 587 + c.blue * 114) / 1000;
      return brightness > 150 ? Colors.black : Colors.white;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor ?? const Color(0xff1E1E1E),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 120,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeNoteData();
  }

  void _initializeNoteData() {
    if (widget.note != null) {
      titleCtrl.text = widget.note!.title;
      bodyCtrl.text = widget.note!.body;
      isPinned = widget.note!.isPinned;

      // Fix: Check if image exists before setting it
      if (widget.note!.imageUrl != null && widget.note!.imageUrl!.isNotEmpty) {
        final imageFile = File(widget.note!.imageUrl!);
        if (imageFile.existsSync()) {
          selectedImage = imageFile;
          selectedColor = null;
        } else {
          selectedImage = null;
          selectedColor = widget.note?.bgColor;
        }
      } else {
        selectedColor = widget.note?.bgColor;
        selectedImage = null;
      }

      selectedFont = widget.note?.fontFamily;

      // Fix: Only set savedAudio if the file exists
      if (widget.note?.audioUrl != null && widget.note!.audioUrl!.isNotEmpty) {
        final audioFile = File(widget.note!.audioUrl!);
        if (audioFile.existsSync()) {
          savedAudio = widget.note!.audioUrl;
        }
      }

      _audioDeleted = false;
    }
    _hasInitialized = true;
  }

  Future<void> _removeAudio() async {
    final oldAudioPath = savedAudio;

    setState(() {
      selectedAudio = null;
      savedAudio = null;
      _audioDeleted = true;
    });

    if (widget.note != null) {
      showGlobalLoader(context);

      final updatedNote = widget.note!.copyWith(
        audioUrl: null,
        updatedAt: DateTime.now(),
      );

      await ref.read(notesProvider.notifier).addNote(updatedNote);

      if (oldAudioPath != null && oldAudioPath.isNotEmpty) {
        try {
          final file = File(oldAudioPath);
          if (file.existsSync()) {
            await file.delete();
          }
        } catch (e) {
          print('Error deleting audio file: $e');
        }
      }

      hideGlobalLoader(context);

      await ref.read(notesProvider.notifier).loadNotes();

      if (mounted) {
        _showSnackBar("Audio removed successfully.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 700;

    return WillPopScope(
      onWillPop: () async {
        handleBackPress();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              const AppBackground(),

              SafeArea(
                child: Center(
                  child: Container(
                    width: isTablet ? 650 : double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 18,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        AddNoteAppBar(
                          isPinned: isPinned,
                          onBack: handleBackPress,
                          onPinToggle: () =>
                              setState(() => isPinned = !isPinned),
                          onSave: saveNote,
                        ),

                        const SizedBox(height: 16),

                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: IntrinsicHeight(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              image: selectedImage != null
                                                  ? DecorationImage(
                                                      image: FileImage(
                                                        selectedImage!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                              color:
                                                  selectedImage == null &&
                                                      selectedColor == null
                                                  ? Colors.transparent
                                                  : null,
                                              gradient:
                                                  selectedImage == null &&
                                                      selectedColor != null
                                                  ? LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color(
                                                          selectedColor!,
                                                        ).withOpacity(0.75),
                                                        Color(selectedColor!),
                                                        Color(
                                                          selectedColor!,
                                                        ).withOpacity(0.75),
                                                      ],
                                                    )
                                                  : null,
                                            ),
                                            foregroundDecoration:
                                                selectedImage != null
                                                ? BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.black
                                                            .withOpacity(0.65),
                                                        Colors.black
                                                            .withOpacity(0.65),
                                                      ],
                                                    ),
                                                  )
                                                : null,
                                            padding: const EdgeInsets.all(14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                AddNoteFields(
                                                  titleController: titleCtrl,
                                                  bodyController: bodyCtrl,
                                                  textColor: textColor,
                                                  fontFamily: selectedFont,
                                                ),

                                                const SizedBox(height: 10),

                                                if (selectedAudio != null)
                                                  _buildAudioPlayerWidget(
                                                    audioFile: selectedAudio,
                                                    onRemove: () =>
                                                        _removeAudio(),
                                                  )
                                                else if (savedAudio != null &&
                                                    savedAudio!.isNotEmpty)
                                                  _buildAudioPlayerWidget(
                                                    audioPath: savedAudio,
                                                    onRemove: () =>
                                                        _removeAudio(),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 14),

                                        AddNoteFontSelector(
                                          selectedFont: selectedFont,
                                          onFontSelected: (font) {
                                            setState(() => selectedFont = font);
                                          },
                                        ),

                                        const SizedBox(height: 14),

                                        AddNoteColorSelector(
                                          selectedColor: selectedColor,
                                          onColorSelected: (color) {
                                            setState(() {
                                              selectedColor = color;
                                              if (color != null) {
                                                selectedImage = null;
                                              }
                                            });
                                          },
                                          hasImage: selectedImage != null,
                                        ),

                                        const SizedBox(height: 14),

                                        AddNoteFooter(
                                          createdAt:
                                              widget.note?.createdAt ??
                                              DateTime.now(),
                                          onImageSelected: (image) {
                                            setState(() {
                                              selectedImage = image;
                                              selectedColor = null;
                                            });
                                          },
                                          onAudioSelected: (audioFile) {
                                            setState(() {
                                              selectedAudio = audioFile;
                                              savedAudio = null;
                                              _audioDeleted = false;
                                            });
                                          },
                                          currentAudioFile: selectedAudio,
                                          currentAudioPath: savedAudio,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleBackPress() {
    print('=== DEBUG: Checking for changes ===');
    print('Original audio URL: ${widget.note?.audioUrl}');
    print('Saved audio: $savedAudio');
    print('Selected audio: ${selectedAudio?.path}');
    print('Audio deleted flag: $_audioDeleted');

    bool titleChanged =
        titleCtrl.text.trim() != (widget.note?.title ?? "").trim();
    bool bodyChanged = bodyCtrl.text.trim() != (widget.note?.body ?? "").trim();
    bool pinChanged = isPinned != (widget.note?.isPinned ?? false);
    bool fontChanged = selectedFont != widget.note?.fontFamily;
    bool colorChanged = selectedColor != widget.note?.bgColor;
    bool imageChanged = false;

    // Fix for image change detection
    final currentImagePath = selectedImage?.path ?? "";
    final originalImagePath = widget.note?.imageUrl ?? "";
    imageChanged = currentImagePath != originalImagePath;

    bool audioChanged = false;

    // Fix for audio change detection
    if (widget.note == null) {
      // Creating new note - any audio selected is a change
      audioChanged = selectedAudio != null || savedAudio != null;
    } else {
      // Editing existing note
      if (_audioDeleted) {
        // Audio was deleted in this session
        audioChanged = widget.note?.audioUrl != null;
      } else if (selectedAudio != null) {
        // New audio was selected
        audioChanged = true;
      } else if (savedAudio != widget.note?.audioUrl) {
        // Saved audio doesn't match original
        audioChanged = savedAudio != widget.note?.audioUrl;
      }
      // If savedAudio matches widget.note?.audioUrl, no change
    }

    bool hasChanges =
        titleChanged ||
        bodyChanged ||
        pinChanged ||
        fontChanged ||
        colorChanged ||
        imageChanged ||
        audioChanged;

    print('Has changes: $hasChanges');

    if (!hasChanges) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: const Color(0xff1E1E1E),
        title: const Text(
          "Discard changes?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "You have unsaved changes. If you go back now, they will be lost.",
          style: TextStyle(color: Colors.white70, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Discard", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> saveNote() async {
    final title = titleCtrl.text.trim();
    final body = bodyCtrl.text.trim();

    if (title.isEmpty && body.isEmpty) {
      _showSnackBar("Write something before saving.");
      return;
    }

    final notes = ref.read(notesProvider);
    final pinnedCount = notes.where((n) => n.isPinned).length;

    final isEditing = widget.note != null;
    final wasPinnedBefore = widget.note?.isPinned ?? false;
    final isTryingToPinNow = isPinned && !wasPinnedBefore;

    if ((!isEditing && isPinned && pinnedCount >= 4) ||
        (isEditing && isTryingToPinNow && pinnedCount >= 4)) {
      _showSnackBar("You can pin only up to 4 notes.");
      return;
    }

    showGlobalLoader(context);

    String? finalAudioUrl;
    if (_audioDeleted) {
      finalAudioUrl = null;
    } else if (selectedAudio != null) {
      finalAudioUrl = selectedAudio!.path;
    } else {
      finalAudioUrl = savedAudio;
    }

    final noteToSave = isEditing
        ? widget.note!.copyWith(
            title: title.isEmpty ? "Untitled" : title,
            body: body,
            isPinned: isPinned,
            imageUrl: selectedImage?.path,
            bgColor: selectedColor,
            fontFamily: selectedFont,
            audioUrl: finalAudioUrl,
            updatedAt: DateTime.now(),
          )
        : NoteEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title.isEmpty ? "Untitled" : title,
            body: body,
            isPinned: isPinned,
            imageUrl: selectedImage?.path,
            bgColor: selectedColor,
            fontFamily: selectedFont,
            audioUrl: finalAudioUrl,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

    await ref.read(notesProvider.notifier).addNote(noteToSave);

    hideGlobalLoader(context);

    Navigator.pop(context);
  }

  Widget _buildAudioPlayerWidget({
    File? audioFile,
    String? audioPath,
    required VoidCallback onRemove,
  }) {
    if (audioFile != null) {
      if (audioFile.existsSync()) {
        return AudioPlayerWidget(audioPath: audioFile.path, onRemove: onRemove);
      } else {
        return _buildErrorAudioWidget(() {
          setState(() {
            selectedAudio = null;
            savedAudio = null;
            _audioDeleted = true;
          });
        });
      }
    }

    if (audioPath != null && audioPath.isNotEmpty) {
      final file = File(audioPath);
      if (file.existsSync()) {
        return AudioPlayerWidget(audioPath: audioPath, onRemove: onRemove);
      } else {
        return _buildErrorAudioWidget(() {
          setState(() {
            selectedAudio = null;
            savedAudio = null;
            _audioDeleted = true;
          });

          if (widget.note != null) {
            ref
                .read(notesProvider.notifier)
                .addNote(
                  widget.note!.copyWith(
                    audioUrl: null,
                    updatedAt: DateTime.now(),
                  ),
                );
          }
        });
      }
    }

    return const SizedBox();
  }

  Widget _buildErrorAudioWidget(VoidCallback onRemove) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onRemove();
      }
    });

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Audio file not found. Cleaning up...',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _resetAudioState() {
    setState(() {
      selectedAudio = null;
      savedAudio = null;
      _audioDeleted = true;
    });
  }
}
