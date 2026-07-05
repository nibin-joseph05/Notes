import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/providers/settings_provider.dart';

class AppTheme {
  static ThemeData darkTheme(WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff0F0F0F),
      textTheme: GoogleFonts.getTextTheme(settings.fontFamily),
      useMaterial3: true,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        fillColor: Colors.transparent,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        isCollapsed: true,
      ),
    );
  }
}
