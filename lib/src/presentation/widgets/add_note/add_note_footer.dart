import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes/src/presentation/widgets/add_note/add_note_reminder_dialog.dart';
import './add_note_audio_recorder.dart';

class AddNoteFooter extends StatelessWidget {
  final void Function(File?) onImageSelected;
  final DateTime createdAt;
  final void Function(File?) onAudioSelected;
  final File? currentAudioFile;
  final String? currentAudioPath;

  const AddNoteFooter({
    super.key,
    required this.onImageSelected,
    required this.createdAt,
    required this.onAudioSelected,
    this.currentAudioFile,
    this.currentAudioPath,
  });

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  bool get hasAudio => currentAudioFile != null || (currentAudioPath != null && currentAudioPath!.isNotEmpty);

  void _handleAudioRecorderPressed(BuildContext context) {
    if (hasAudio) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please delete the existing audio first to record a new one. This helps save your phone's storage space.",
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff1E1E1E),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 120,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Got it',
            textColor: Colors.tealAccent,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(createdAt);
    final formattedDate = DateFormat('MMM dd, yyyy').format(createdAt);

    return Row(
      children: [
        IconButton(
          onPressed: () => pickImage(ImageSource.gallery),
          tooltip: "Choose from gallery",
          icon: const Icon(
            FontAwesomeIcons.image,
            size: 22,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => pickImage(ImageSource.camera),
          tooltip: "Take a photo",
          icon: const Icon(
            FontAwesomeIcons.camera,
            size: 22,
            color: Colors.white,
          ),
        ),


        if (!hasAudio)
          AddNoteAudioRecorder(
            onFinished: (file) => onAudioSelected(file),
            buttonColor: Colors.white,
          )
        else
          IconButton(
            onPressed: () => _handleAudioRecorderPressed(context),
            tooltip: "Delete existing audio first",
            icon: const Icon(
              Icons.mic,
              size: 26,
              color: Colors.white38,
            ),
          ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedTime,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),

        PopupMenuButton(
          color: const Color(0xff1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          icon: const Icon(
            FontAwesomeIcons.ellipsisVertical,
            size: 20,
            color: Colors.white,
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: const Text(
                "Set Reminder",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Future.microtask(() {
                  showDialog(
                    context: context,
                    builder: (_) => ReminderDialog(
                      onSetReminder: (dateTime) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Reminder set for: $dateTime"),
                          ),
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