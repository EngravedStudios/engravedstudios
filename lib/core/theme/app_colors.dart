import 'dart:ui';

class AppColors {
  // --- Raw Palette ---
  static const Color _neonLime = Color(0xFFC6FF00);
  static const Color _accentRed = Color(0xFFFF004C);
  static const Color _ghostWhite = Color(0xFFF8F8F8);
  static const Color _deepOnyx = Color(0xFF0A0A0A);
  static const Color _slate900 = Color(0xFF0F172A);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _grey = Color(0xFF888888);

  // --- LIGHT THEME TOKENS ---
  static const Color lightPrimary = _slate900;
  static const Color lightOnPrimary = _white;
  static const Color lightSecondary = _neonLime;
  static const Color lightOnSecondary = _slate900;
  static const Color lightTertiary = _grey;
  static const Color lightOnTertiary = _slate900;
  static const Color lightError = _accentRed;
  static const Color lightOnError = _white;
  static const Color lightSurface = _white;
  static const Color lightOnSurface = _slate900;
  static const Color lightBackground = _ghostWhite;
  static const Color lightOnBackground = _slate900;
  
  static const Color lightAppbarBackground = _ghostWhite;
  static const Color lightAppbarForeground = _slate900;

  // --- DARK THEME TOKENS ---
  static const Color darkPrimary = _white;
  static const Color darkOnPrimary = _slate900;
  static const Color darkSecondary = _accentRed;
  static const Color darkOnSecondary = _white;
  static const Color darkTertiary = _grey;
  static const Color darkOnTertiary = _white;
  static const Color darkError = _accentRed;
  static const Color darkOnError = _slate900;
  static const Color darkSurface = _deepOnyx;
  static const Color darkOnSurface = _white;
  static const Color darkBackground = _deepOnyx;
  static const Color darkOnBackground = _white;

  static const Color darkAppbarBackground = _deepOnyx;
  static const Color darkAppbarForeground = _white;

  // --- Legacy / Direct Access (For specific widgets if needed) ---
  static const Color neonLime = _neonLime;
  static const Color accentRed = _accentRed;
  static const Color pureBlack = _slate900;
  static const Color pureWhite = _white;
  static const Color deepOnyx = _deepOnyx;
  static const Color ghostWhite = _ghostWhite;
  static const Color ghostGray = _grey;
}
