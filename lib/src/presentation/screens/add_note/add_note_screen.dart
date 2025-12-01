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

  Color get textColor {
    if (selectedImage != null) return Colors.white;
    if (selectedColor != null) return Colors.black;
    return Colors.white;
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const AppBackground(),
            if (selectedImage != null)
              AddNoteBackground(imagePath: selectedImage!.path),

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
                        onBack: () => Navigator.pop(context),
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
                                            color: selectedColor != null
                                                ? Color(selectedColor!)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
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
    );
  }

  void saveNote() {
    final title = titleCtrl.text.trim();
    final body = bodyCtrl.text.trim();

    final noteToSave = widget.note == null
        ? NoteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? "Untitled" : title,
      body: body,
      isPinned: isPinned,
      imageUrl: selectedImage?.path,
      bgColor: selectedColor,
      fontFamily: selectedFont,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    )
        : widget.note!.copyWith(
      title: title.isEmpty ? "Untitled" : title,
      body: body,
      isPinned: isPinned,
      imageUrl: selectedImage?.path,
      bgColor: selectedColor,
      fontFamily: selectedFont,
      updatedAt: DateTime.now(),
    );

    ref.read(notesProvider.notifier).addNote(noteToSave);
    Navigator.pop(context);
  }
}
