import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_controller.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    // We can't be async in build for ThemeMode comfortably in MaterialApp without a loading state,
    // so we start with system or light and load async.
    _loadTheme();
    return ThemeMode.light;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setString(_key, 'dark');
    } else {
      state = ThemeMode.light;
      await prefs.setString(_key, 'light');
    }
  }

  // Alias for Cheat Code (Konami)
  void toggleBloodMode() {
    // Force Dark Mode ("Blood Mode")
    if (state != ThemeMode.dark) {
      toggle();
    }
  }
}
