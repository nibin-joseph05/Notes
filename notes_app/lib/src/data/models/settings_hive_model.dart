import 'package:hive/hive.dart';

part 'settings_hive_model.g.dart';

@HiveType(typeId: 1)
class SettingsHiveModel extends HiveObject {
  @HiveField(0)
  bool voicePermission;

  @HiveField(1)
  String fontFamily;

  @HiveField(2)
  bool darkMode;

  @HiveField(3)
  String wallpaperPath;

  SettingsHiveModel({
    required this.voicePermission,
    required this.fontFamily,
    required this.darkMode,
    required this.wallpaperPath,
  });
}
