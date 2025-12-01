import 'package:flutter/material.dart';

class AddNoteFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final Color textColor;

  const AddNoteFields({
    super.key,
    required this.titleController,
    required this.bodyController,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: titleController,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: "Title",
            hintStyle: TextStyle(color: textColor.withOpacity(0.55)),
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: bodyController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: "Start typing...",
            hintStyle: TextStyle(color: textColor.withOpacity(0.55)),
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
