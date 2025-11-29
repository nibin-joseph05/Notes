import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const HomeDeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff151515),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: const Text(
        "Delete Note?",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        "Are you sure you want to delete this note?\nThis action cannot be undone.",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            HapticFeedback.heavyImpact();
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
