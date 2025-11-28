import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xff1e1e1e),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.bars, size: 22, color: Colors.white70),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search your note...",
                hintStyle: TextStyle(color: Colors.white38, fontSize: 15),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(FontAwesomeIcons.user, size: 22, color: Colors.white70),
        ],
      ),
    );
  }
}
