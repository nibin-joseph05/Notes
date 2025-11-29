import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/note_entity.dart';
import '../../providers/note_provider.dart';
import '../../widgets/add_note/add_note_background.dart';
import '../../widgets/add_note/add_note_appbar.dart';
import '../../widgets/add_note/add_note_fields.dart';
import '../../widgets/add_note/add_note_footer.dart';
import '../../widgets/common/app_background.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  children: [
                    AddNoteAppBar(
                      isPinned: isPinned,
                      onBack: () => Navigator.pop(context),
                      onPinToggle: () => setState(() => isPinned = !isPinned),


                      onSave: () {
                        final title = titleCtrl.text.trim();
                        final body = bodyCtrl.text.trim();

                        if (widget.note == null) {
                          final newNote = NoteEntity(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: title.isEmpty ? "Untitled" : title,
                            body: body,
                            isPinned: isPinned,
                            imageUrl: selectedImage?.path,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          ref.read(notesProvider.notifier).addNote(newNote);
                        } else {
                          final updatedNote = widget.note!.copyWith(
                            title: title.isEmpty ? "Untitled" : title,
                            body: body,
                            isPinned: isPinned,
                            imageUrl: selectedImage?.path,
                            updatedAt: DateTime.now(),
                          );
                          ref.read(notesProvider.notifier).addNote(updatedNote);
                        }

                        Navigator.pop(context);

                      },
                    ),

                    const SizedBox(height: 20),


                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: IntrinsicHeight(
                          child: AddNoteFields(
                            titleController: titleCtrl,
                            bodyController: bodyCtrl,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),


                    AddNoteFooter(
                      onImageSelected: (image) {
                        setState(() => selectedImage = image);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
