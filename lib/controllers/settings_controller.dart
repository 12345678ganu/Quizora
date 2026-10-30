import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
  static final SettingsController instance = SettingsController._internal();
  SettingsController._internal();

  // ValueNotifiers to notify UI when settings change
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
  final ValueNotifier<bool> hapticsEnabledNotifier = ValueNotifier(true);

  static const String _keyThemeMode = 'quizora_theme_mode';
  static const String _keyHaptics = 'quizora_haptics';

  /// Load saved settings from disk
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Theme Mode
    final themeIndex = prefs.getInt(_keyThemeMode) ?? 0;
    if (themeIndex < ThemeMode.values.length) {
      themeModeNotifier.value = ThemeMode.values[themeIndex];
    }

    // Load Haptics
    hapticsEnabledNotifier.value = prefs.getBool(_keyHaptics) ?? true;
  }

  /// Update and persist theme mode
  Future<void> updateThemeMode(ThemeMode newMode) async {
    themeModeNotifier.value = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, newMode.index);
  }

  /// Update and persist haptics preference
  Future<void> updateHaptics(bool enabled) async {
    hapticsEnabledNotifier.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptics, enabled);
  }
}