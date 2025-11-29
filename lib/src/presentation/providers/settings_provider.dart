import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/models/settings_hive_model.dart';

class SettingsState {
  final bool voicePermission;
  final String fontFamily;
  final bool darkMode;
  final String wallpaperPath;

  SettingsState({
    required this.voicePermission,
    required this.fontFamily,
    required this.darkMode,
    required this.wallpaperPath,
  });

  SettingsState copyWith({
    bool? voicePermission,
    String? fontFamily,
    bool? darkMode,
    String? wallpaperPath,
  }) {
    return SettingsState(
      voicePermission: voicePermission ?? this.voicePermission,
      fontFamily: fontFamily ?? this.fontFamily,
      darkMode: darkMode ?? this.darkMode,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  late Box<SettingsHiveModel> _box;

  SettingsNotifier() : super(SettingsState(
    voicePermission: false,
    fontFamily: "Poppins",
    darkMode: true,
    wallpaperPath: '',
  )) {
    _init();
  }

  Future<void> _init() async {
    _box = Hive.box<SettingsHiveModel>('settingsBox');

    if (_box.isNotEmpty) {
      final s = _box.getAt(0)!;
      state = SettingsState(
        voicePermission: s.voicePermission,
        fontFamily: s.fontFamily,
        darkMode: s.darkMode,
        wallpaperPath: s.wallpaperPath,
      );
    }
  }

  Future<void> _save() async {
    final data = SettingsHiveModel(
      voicePermission: state.voicePermission,
      fontFamily: state.fontFamily,
      darkMode: state.darkMode,
      wallpaperPath: state.wallpaperPath,
    );

    if (_box.isEmpty) {
      await _box.add(data);
    } else {
      await _box.putAt(0, data);
    }
  }

  void toggleVoicePermission(bool val) {
    state = state.copyWith(voicePermission: val);
    _save();
  }

  void changeFont(String font) {
    state = state.copyWith(fontFamily: font);
    _save();
  }

  void toggleTheme(bool val) {
    state = state.copyWith(darkMode: val);
    _save();
  }

  void setWallpaper(String path) {
    state = state.copyWith(wallpaperPath: path);
    _save();
  }
}


final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
