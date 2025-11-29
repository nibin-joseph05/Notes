import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/settings/settings_font_selector.dart';
import '../../widgets/settings/settings_permission.dart';
import '../../widgets/settings/settings_theme_mode.dart';
import '../../widgets/settings/settings_wallpaper_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isTablet ? 650 : double.infinity),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 26 : 18,
              vertical: 16,
            ),
            children: [
              _sectionCard(
                title: "General",
                icon: Icons.tune_rounded,
                children: [
                  PermissionWidget(),
                ],
              ),
              const SizedBox(height: 18),
              _sectionCard(
                title: "Appearance",
                icon: Icons.palette_rounded,
                children: const [
                  FontSelectorWidget(),
                  SizedBox(height: 10),
                  WallpaperSelectorWidget(),
                  SizedBox(height: 10),
                  ThemeModeWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.85), size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
