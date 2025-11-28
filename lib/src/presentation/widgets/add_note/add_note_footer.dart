import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddNoteFooter extends StatelessWidget {
  final void Function(File?) onImageSelected;

  const AddNoteFooter({
    super.key,
    required this.onImageSelected,
  });

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        IconButton(
          onPressed: () => pickImage(ImageSource.gallery),
          icon: const Icon(FontAwesomeIcons.image, size: 24, color: Colors.white),
        ),


        IconButton(
          onPressed: () => pickImage(ImageSource.camera),
          icon: const Icon(FontAwesomeIcons.camera, size: 24, color: Colors.white),
        ),


        IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.microphone, size: 24, color: Colors.white),
        ),

        const Spacer(),


        Text(
          "Created: Mar 1, 2023",
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(width: 12),


        const Icon(FontAwesomeIcons.ellipsisVertical, size: 20, color: Colors.white),
      ],
    );
  }
}
