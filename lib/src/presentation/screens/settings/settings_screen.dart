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
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AppBackground(),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isTablet = width >= 700;
                final isDesktop = width >= 1100;


                final double maxContentWidth = isDesktop
                    ? 900
                    : isTablet
                    ? 750
                    : width;


                final double horizontalPadding = width >= 1100
                    ? width * 0.12
                    : width >= 700
                    ? width * 0.08
                    : width * 0.045;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: isTablet ? 26 : 18,
                      ),
                      children: [

                        _sectionCard(
                          title: "General",
                          subtitle: "Permissions & system access",
                          icon: Icons.tune_rounded,
                          children: const [
                            PermissionWidget(),
                          ],
                        ),

                        SizedBox(height: isTablet ? 30 : 22),


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

                        SizedBox(height: isTablet ? 30 : 22),

                        _footerInfo(fontSize: isTablet ? 14 : 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  static Widget _sectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 540;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.fromLTRB(
            isWide ? 28 : 22,
            isWide ? 22 : 20,
            isWide ? 28 : 22,
            isWide ? 30 : 24,
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
                  Icon(
                    icon,
                    color: Colors.white.withOpacity(0.9),
                    size: isWide ? 28 : 24,
                  ),
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
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: isWide ? 14 : 13,
                            color: Colors.white.withOpacity(0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        );
      },
    );
  }


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


  static Widget _footerInfo({required double fontSize}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
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
      ),
    );
  }
}
