import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import 'settings_toggle.dart';

class ThemeModeWidget extends ConsumerWidget {
  const ThemeModeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return SettingsToggle(
      title: "Dark Mode",
      value: settings.darkMode,
      onToggle: (val) {
        ref.read(settingsProvider.notifier).toggleTheme(val);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dark mode feature coming soon..."),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
