import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes/src/presentation/widgets/add_note/add_note_reminder_dialog.dart';

class AddNoteFooter extends StatelessWidget {
  final void Function(File?) onImageSelected;
  final DateTime createdAt;
  final VoidCallback? onShare;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDeleteImage;

  const AddNoteFooter({
    super.key,
    required this.onImageSelected,
    required this.createdAt,
    this.onShare,
    this.onDuplicate,
    this.onDeleteImage,
  });

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  String get formattedDate {
    return DateFormat('hh:mm a • MMM dd, yyyy').format(createdAt);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 480;

    return Row(
      children: [
        IconButton(
          onPressed: () => pickImage(ImageSource.gallery),
          tooltip: "Choose from gallery",
          icon: const Icon(FontAwesomeIcons.image, size: 22, color: Colors.white),
        ),
        IconButton(
          onPressed: () => pickImage(ImageSource.camera),
          tooltip: "Take a photo",
          icon: const Icon(FontAwesomeIcons.camera, size: 22, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          tooltip: "Record voice (coming soon)",
          icon: const Icon(FontAwesomeIcons.microphone, size: 22, color: Colors.white),
        ),

        const Spacer(),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('hh:mm a').format(DateTime.now()),
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(createdAt),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        PopupMenuButton(
          color: const Color(0xff1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          icon: const Icon(FontAwesomeIcons.ellipsisVertical, size: 20, color: Colors.white),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: const Text("Set Reminder", style: TextStyle(color: Colors.white)),
              onTap: () {
                Future.microtask(() {
                  showDialog(
                    context: context,
                    builder: (_) => ReminderDialog(
                      onSetReminder: (dateTime) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Reminder set for: $dateTime")),
                        );
                      },
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
