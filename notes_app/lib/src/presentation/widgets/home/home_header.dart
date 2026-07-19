import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routes/app_routes.dart';
import '../../providers/note_provider.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xff1e1e1e),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
            child: const Icon(
              FontAwesomeIcons.bars,
              size: 22,
              color: Colors.white70,
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search your notes...",
                hintStyle: TextStyle(color: Colors.white38, fontSize: 15),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            child: const Icon(FontAwesomeIcons.user, size: 22, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
