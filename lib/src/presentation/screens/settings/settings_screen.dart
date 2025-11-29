import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

import '../../widgets/common/app_background.dart';
import '../../widgets/settings/settings_font_selector.dart';
import '../../widgets/settings/settings_permission.dart';
import '../../widgets/settings/settings_theme_mode.dart';
import '../../widgets/settings/settings_wallpaper_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 700;
    final horizontalPadding = size.width * (isTablet ? 0.08 : 0.045);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AppBackground(),

          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isTablet ? 700 : size.width),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isTablet ? 24 : 16,
                ),
                children: [

                  /// GENERAL
                  _sectionCard(
                    title: "General",
                    subtitle: "Permissions & system access",
                    icon: Icons.tune_rounded,
                    children: const [
                      PermissionWidget(),
                    ],
                  ),

                  SizedBox(height: isTablet ? 28 : 22),

                  /// APPEARANCE
                  _sectionCard(
                    title: "Appearance",
                    subtitle: "Customize look & feel",
                    icon: Icons.palette_rounded,
                    children: [
                      _settingsTile(child: const FontSelectorWidget()),
                      SizedBox(height: isTablet ? 16 : 12),
                      _settingsTile(child: const WallpaperSelectorWidget()),
                      SizedBox(height: isTablet ? 16 : 12),
                      _settingsTile(child: const ThemeModeWidget()),
                    ],
                  ),

                  SizedBox(height: isTablet ? 28 : 22),

                  _footerInfo(fontSize: isTablet ? 14 : 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION CARD
  static Widget _sectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        return Container(
          padding: EdgeInsets.fromLTRB(
            isWide ? 26 : 22,
            isWide ? 22 : 20,
            isWide ? 26 : 22,
            isWide ? 28 : 24,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.42),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white.withOpacity(0.9), size: isWide ? 26 : 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isWide ? 20 : 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: isWide ? 14 : 13,
                            color: Colors.white.withOpacity(0.70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ...children,
            ],
          ),
        );
      },
    );
  }

  // SETTINGS TILE
  static Widget _settingsTile({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
  }

  // FOOTER
  static Widget _footerInfo({required double fontSize}) {
    return Center(
      child: Opacity(
        opacity: 0.80,
        child: Text(
          "Version 1.0.0 • AiBi Notes",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white.withOpacity(0.72),
          ),
        ),
      ),
    );
  }
}
