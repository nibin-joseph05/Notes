import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddNoteAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onPinToggle;
  final VoidCallback onSave;
  final bool isPinned;

  const AddNoteAppBar({
    super.key,
    required this.onBack,
    required this.onPinToggle,
    required this.onSave,
    required this.isPinned,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back, size: 26),
          color: Colors.white,
        ),
        const Spacer(),
        IconButton(
          onPressed: onPinToggle,
          icon: Icon(
            FontAwesomeIcons.thumbtack,
            size: 20,
            color: isPinned ? Colors.white : Colors.white60,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onSave,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(.8),
                width: 1.2,
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.save_alt, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
