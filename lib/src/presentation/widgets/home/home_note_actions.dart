import 'package:flutter/material.dart';

class HomeNoteActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPinToggle;
  final bool isPinned;

  const HomeNoteActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onPinToggle,
    required this.isPinned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(Icons.edit, "Edit", onEdit),
          _item(Icons.delete_outline, "Delete", onDelete),
          _item(Icons.push_pin, isPinned ? "Unpin" : "Pin", onPinToggle),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String text, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
