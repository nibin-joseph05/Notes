import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/add_note/add_note_background.dart';
import '../../widgets/add_note/add_note_appbar.dart';
import '../../widgets/add_note/add_note_fields.dart';
import '../../widgets/add_note/add_note_footer.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController bodyCtrl = TextEditingController();
  bool isPinned = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),  //  Keyboard dismiss
      child: Scaffold(
        resizeToAvoidBottomInset: false, //  Prevent UI from moving up
        body: Stack(
          children: [
            const AddNoteBackground(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Column(
                      children: [
                        AddNoteAppBar(
                          isPinned: isPinned,
                          onBack: () => Navigator.pop(context),
                          onPinToggle: () => setState(() => isPinned = !isPinned),
                          onSave: () {
                            // TODO: Save note logic
                          },
                        ),
                        const SizedBox(height: 20),

                        //  Scrollable only for fields
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

                        const AddNoteFooter(), // Fixed position always
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
