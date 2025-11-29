import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool voicePermission;
  final String fontFamily;
  final bool darkMode;
  final String wallpaperPath; // ⬅ new field

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
  SettingsNotifier()
      : super(SettingsState(
    voicePermission: false,
    fontFamily: "Poppins",
    darkMode: true, wallpaperPath: '',
  ));

  void toggleVoicePermission(bool val) =>
      state = state.copyWith(voicePermission: val);

  void changeFont(String font) =>
      state = state.copyWith(fontFamily: font);

  void toggleTheme(bool val) =>
      state = state.copyWith(darkMode: val);

  void setWallpaper(String path) =>
      state = state.copyWith(wallpaperPath: path);

}

final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
