import 'package:flutter/material.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/add_note/add_note_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/error/error_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashPage());
      case AppRoutes.home:
        return _page(const HomeScreen());
      case AppRoutes.addNote:
        return _page(const AddNoteScreen());
      case AppRoutes.settings:
        return _page(const SettingsScreen());
      default:
        return _page(const ErrorScreen());
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
