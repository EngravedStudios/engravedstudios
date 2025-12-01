import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import '../theme/app_themes.dart';
import '../theme/theme_schema.dart';
import '../core/logging/logger_provider.dart';
import '../domain/repositories/auth_repository_interface.dart';
import '../providers/auth_provider.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _themeKey = 'selected_theme';

  @override
  Future<AppThemeType> build() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Check for Appwrite preference if logged in
    final authState = ref.watch(authStateProvider);
    if (authState.valueOrNull != null) {
      try {
        final userPrefs = await ref.read(authRepositoryProvider).getPrefs(); // Need to expose getPrefs
        if (userPrefs['theme'] != null) {
           final themeIndex = userPrefs['theme'] as int;
           if (themeIndex >= 0 && themeIndex < AppThemeType.values.length) {
             // Sync local storage
             await prefs.setInt(_themeKey, themeIndex);
             return AppThemeType.values[themeIndex];
           }
        }
      } catch (e) {
        ref.read(appLoggerProvider).warning('Failed to fetch theme from Appwrite', e);
      }
    }

    // 2. Check local storage
    final savedThemeIndex = prefs.getInt(_themeKey);
    if (savedThemeIndex != null && savedThemeIndex >= 0 && savedThemeIndex < AppThemeType.values.length) {
      return AppThemeType.values[savedThemeIndex];
    }
    
    // 3. Default to System Theme
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? AppThemeType.defaultDark : AppThemeType.defaultLight;
  }

  Future<void> setTheme(AppThemeType theme) async {
    state = AsyncData(theme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
    
    // Sync with Appwrite if logged in
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      try {
        await ref.read(authRepositoryProvider).updatePrefs({'theme': theme.index});
      } catch (e) {
        ref.read(appLoggerProvider).warning('Failed to sync theme to Appwrite', e);
      }
    }
  }
}

// Provider to easily access the current theme schema
@riverpod
AppThemeColorSchema currentThemeSchema(Ref ref) {
  final themeTypeAsync = ref.watch(themeNotifierProvider);
  return themeTypeAsync.valueOrNull?.schema ?? DefaultLightTheme();
}
