import 'package:flutter/material.dart';

class AddNoteFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;

  const AddNoteFields({
    super.key,
    required this.titleController,
    required this.bodyController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: titleController,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            hintText: "Title",
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: bodyController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            hintText: "Start typing...",
            border: InputBorder.none,
          ),
        ),

      ],
    );
  }
}
