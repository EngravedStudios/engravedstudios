import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_themes.dart';
import '../theme/theme_schema.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _themeKey = 'selected_theme';

  @override
  Future<AppThemeType> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt(_themeKey);
    
    if (savedThemeIndex != null && savedThemeIndex >= 0 && savedThemeIndex < AppThemeType.values.length) {
      return AppThemeType.values[savedThemeIndex];
    }
    
    // Default to Light theme if no preference is saved
    return AppThemeType.defaultLight;
  }

  Future<void> setTheme(AppThemeType theme) async {
    state = AsyncData(theme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }
}

// Provider to easily access the current theme schema
@riverpod
AppThemeColorSchema currentThemeSchema(CurrentThemeSchemaRef ref) {
  final themeTypeAsync = ref.watch(themeNotifierProvider);
  return themeTypeAsync.valueOrNull?.schema ?? DefaultLightTheme();
}
