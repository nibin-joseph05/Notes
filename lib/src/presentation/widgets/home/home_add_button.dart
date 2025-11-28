import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAddButton extends StatelessWidget {
  const HomeAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xff4C7CFD),
            Color(0xffA338FD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {},
        child: const Icon(
          FontAwesomeIcons.fileCirclePlus,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
