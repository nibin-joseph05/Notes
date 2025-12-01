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
      final brightness =
          (c.red * 299 + c.green * 587 + c.blue * 114) / 1000;
      return brightness > 150 ? Colors.black : Colors.white;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleCtrl.text = widget.note!.title;
      bodyCtrl.text = widget.note!.body;
      isPinned = widget.note!.isPinned;
      if (widget.note!.imageUrl != null) {
        selectedImage = File(widget.note!.imageUrl!);
      }
      selectedColor = widget.note?.bgColor;
      selectedFont = widget.note?.fontFamily;
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
                          onPinToggle: () => setState(() => isPinned = !isPinned),
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
                                              borderRadius: BorderRadius.circular(14),

                                              image: selectedImage != null
                                                  ? DecorationImage(
                                                image: FileImage(selectedImage!),
                                                fit: BoxFit.cover,
                                              )
                                                  : null,
                                              gradient: selectedImage == null && selectedColor != null
                                                  ? LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(selectedColor!).withOpacity(0.75),
                                                  Color(selectedColor!),
                                                  Color(selectedColor!).withOpacity(0.75),
                                                ],
                                              )
                                                  : null,
                                            ),
                                            foregroundDecoration: selectedImage != null
                                                ? BoxDecoration(
                                              borderRadius: BorderRadius.circular(14),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.65),
                                                  Colors.black.withOpacity(0.65),
                                                ],
                                              ),
                                            )
                                                : null,

                                            padding: const EdgeInsets.all(14),
                                            child: AddNoteFields(
                                              titleController: titleCtrl,
                                              bodyController: bodyCtrl,
                                              textColor: textColor,
                                              fontFamily: selectedFont,
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
                                              if (color != null) selectedImage = null;
                                            });
                                          },
                                        ),

                                        const SizedBox(height: 14),

                                        AddNoteFooter(
                                          createdAt: widget.note?.createdAt ?? DateTime.now(),
                                          onImageSelected: (image) {
                                            setState(() {
                                              selectedImage = image;
                                              selectedColor = null;
                                            });
                                          },
                                          onAudioSelected: (audioFile) {
                                            setState(() {
                                              selectedAudio = audioFile;
                                            });
                                          },
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
    bool hasChanges =
        titleCtrl.text.trim() != (widget.note?.title ?? "").trim() ||
            bodyCtrl.text.trim() != (widget.note?.body ?? "").trim() ||
            isPinned != (widget.note?.isPinned ?? false) ||
            selectedFont != (widget.note?.fontFamily) ||
            selectedColor != (widget.note?.bgColor) ||
            (selectedImage?.path ?? "") != (widget.note?.imageUrl ?? "");

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
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Write something before saving."),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 120,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final notes = ref.read(notesProvider);
    final pinnedCount = notes.where((n) => n.isPinned).length;

    final isEditing = widget.note != null;
    final wasPinnedBefore = widget.note?.isPinned ?? false;
    final isTryingToPinNow = isPinned && !wasPinnedBefore;


    if ((!isEditing && isPinned && pinnedCount >= 4) ||
        (isEditing && isTryingToPinNow && pinnedCount >= 4)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("You can pin only up to 4 notes."),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 120,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      return;
    }

    showGlobalLoader(context);

    final noteToSave = isEditing
        ? widget.note!.copyWith(
      title: title.isEmpty ? "Untitled" : title,
      body: body,
      isPinned: isPinned,
      imageUrl: selectedImage?.path,
      bgColor: selectedColor,
      fontFamily: selectedFont,
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
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(notesProvider.notifier).addNote(noteToSave);

    hideGlobalLoader(context);

    Navigator.pop(context);
  }

}
