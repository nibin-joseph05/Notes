import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FontAwesomeIcons.noteSticky,
            size: 90,
            color: Colors.white24,
          ),
          SizedBox(height: 22),
          Text(
            "There is no notes",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "✎ Make a new one",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

}
