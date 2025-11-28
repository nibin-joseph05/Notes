import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddNoteFooter extends StatelessWidget {
  const AddNoteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(FontAwesomeIcons.image, size: 24),
        SizedBox(width: 24),
        Icon(FontAwesomeIcons.camera, size: 24),
        SizedBox(width: 24),
        Icon(FontAwesomeIcons.microphone, size: 24),
        Spacer(),
        Text(
          "Created: Mar 1, 2023",
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        SizedBox(width: 12),
        Icon(FontAwesomeIcons.ellipsisVertical, size: 20),
      ],
    );
  }
}
