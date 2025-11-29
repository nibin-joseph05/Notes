import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool voicePermission;
  final String fontFamily;
  final bool darkMode;

  SettingsState({
    required this.voicePermission,
    required this.fontFamily,
    required this.darkMode,
  });

  SettingsState copyWith({
    bool? voicePermission,
    String? fontFamily,
    bool? darkMode,
  }) {
    return SettingsState(
      voicePermission: voicePermission ?? this.voicePermission,
      fontFamily: fontFamily ?? this.fontFamily,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(SettingsState(
    voicePermission: false,
    fontFamily: "Poppins",
    darkMode: true,
  ));

  void toggleVoicePermission(bool val) =>
      state = state.copyWith(voicePermission: val);

  void changeFont(String font) =>
      state = state.copyWith(fontFamily: font);

  void toggleTheme(bool val) =>
      state = state.copyWith(darkMode: val);
}

final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
