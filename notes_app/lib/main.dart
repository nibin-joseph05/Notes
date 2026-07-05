import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/src/data/models/settings_hive_model.dart';

import 'firebase_options.dart';
import 'src/core/config/app_config.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/routes/app_router.dart';
import 'src/core/routes/app_routes.dart';
import 'src/data/models/note_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  print('[INIT] .env loaded — API base: ${AppConfig.baseUrl}');

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (_) {}

  await Hive.initFlutter();
  Hive.registerAdapter(NoteHiveModelAdapter());
  await Hive.openBox('notesBox');

  Hive.registerAdapter(SettingsHiveModelAdapter());
  await Hive.openBox<SettingsHiveModel>('settingsBox');

  print('[INIT] App ready — starting Notes');
  runApp(const ProviderScope(child: NotesApp()));
}

class NotesApp extends ConsumerWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(ref),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
