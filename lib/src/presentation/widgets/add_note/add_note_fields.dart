import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNoteFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final Color textColor;
  final String? fontFamily;

  const AddNoteFields({
    super.key,
    required this.titleController,
    required this.bodyController,
    required this.textColor,
    required this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    final font = fontFamily ?? "Poppins";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: titleController,
          style: GoogleFonts.getFont(
            font,
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
          style: GoogleFonts.getFont(font, fontSize: 17, color: textColor),
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
