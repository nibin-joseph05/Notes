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
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController bodyCtrl = TextEditingController();
  bool isPinned = false;
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [

            AddNoteBackground(imagePath: selectedImage?.path),

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

                        if (title.isEmpty && body.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Note is empty")),
                          );
                          return;
                        }

                        final note = NoteEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: title.isEmpty ? "Untitled" : title,
                          body: body,
                          isPinned: isPinned,
                          imageUrl: selectedImage?.path,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        ref.read(notesProvider.notifier).addNote(note);

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
