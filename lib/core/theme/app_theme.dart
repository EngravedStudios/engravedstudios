import 'dart:ui';
import 'package:engravedstudios/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color weirdBorder;
  final Color highlight;
  final double borderWidth;

  const AppCustomColors({
    required this.weirdBorder,
    required this.highlight,
    this.borderWidth = 2.0,
  });

  @override
  AppCustomColors copyWith({Color? weirdBorder, Color? highlight, double? borderWidth}) {
    return AppCustomColors(
      weirdBorder: weirdBorder ?? this.weirdBorder,
      highlight: highlight ?? this.highlight,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      weirdBorder: Color.lerp(weirdBorder, other.weirdBorder, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
    );
  }
}

// Helper to access custom colors easily: context.appColors
extension AppThemeContext on BuildContext {
  AppCustomColors get appColors => Theme.of(this).extension<AppCustomColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

// --- Legacy Support (NeubrutalistTheme) ---
@immutable
class NeubrutalistTheme extends ThemeExtension<NeubrutalistTheme> {
  final Color primaryAccent;
  final Color secondaryAccent;
  final Color surface;
  final Color borderColor;
  final Color textColor;
  final Color inverseText;
  final Color shadowColor;
  final double borderWidth;
  final double shadowDepth;

  const NeubrutalistTheme({
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.surface,
    required this.borderColor,
    required this.textColor,
    required this.inverseText,
    required this.shadowColor,
    required this.borderWidth,
    required this.shadowDepth,
  });

  @override
  NeubrutalistTheme copyWith({Color? primaryAccent, Color? secondaryAccent, Color? surface, Color? borderColor, Color? textColor, Color? inverseText, Color? shadowColor, double? borderWidth, double? shadowDepth}) {
    return NeubrutalistTheme(
      primaryAccent: primaryAccent ?? this.primaryAccent,
      secondaryAccent: secondaryAccent ?? this.secondaryAccent,
      surface: surface ?? this.surface,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      inverseText: inverseText ?? this.inverseText,
      shadowColor: shadowColor ?? this.shadowColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowDepth: shadowDepth ?? this.shadowDepth,
    );
  }

  @override
  NeubrutalistTheme lerp(ThemeExtension<NeubrutalistTheme>? other, double t) {
    if (other is! NeubrutalistTheme) return this;
    return NeubrutalistTheme(
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      secondaryAccent: Color.lerp(secondaryAccent, other.secondaryAccent, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      inverseText: Color.lerp(inverseText, other.inverseText, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      shadowDepth: lerpDouble(shadowDepth, other.shadowDepth, t)!,
    );
  }
}

extension NeubrutalistContext on BuildContext {
  NeubrutalistTheme get nbt => Theme.of(this).extension<NeubrutalistTheme>() ?? 
    // Fallback if extension missing (shouldn't happen)
    (Theme.of(this).brightness == Brightness.light 
        ? const NeubrutalistTheme(primaryAccent: AppColors.neonLime, secondaryAccent: AppColors.neonLime, surface: AppColors.ghostWhite, borderColor: AppColors.pureBlack, textColor: AppColors.pureBlack, inverseText: AppColors.pureWhite, shadowColor: AppColors.pureBlack, borderWidth: 2, shadowDepth: 4)
        : const NeubrutalistTheme(primaryAccent: AppColors.accentRed, secondaryAccent: AppColors.accentRed, surface: AppColors.deepOnyx, borderColor: AppColors.pureWhite, textColor: AppColors.pureWhite, inverseText: AppColors.pureBlack, shadowColor: AppColors.pureBlack, borderWidth: 2, shadowDepth: 4));
}

// --- Theme Builders ---

// --- Theme Configuration Class ---
class AppTheme {
  
  // --- LIGHT THEME ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnTertiary,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightAppbarBackground,
      foregroundColor: AppColors.lightAppbarForeground,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        side: BorderSide(width: 2.0, color: AppColors.lightPrimary),
        borderRadius: BorderRadius.zero,
      ),
    ),
    // Extensions and Defaults
    extensions: [
      const AppCustomColors(
        weirdBorder: AppColors.lightPrimary,
        highlight: AppColors.lightSecondary,
        borderWidth: 2.0,
      ),
      const NeubrutalistTheme(
        primaryAccent: AppColors.lightSecondary,
        secondaryAccent: AppColors.lightSecondary,
        surface: AppColors.lightBackground,
        borderColor: AppColors.lightPrimary,
        textColor: AppColors.lightPrimary,
        inverseText: AppColors.lightOnPrimary,
        shadowColor: AppColors.lightPrimary,
        borderWidth: 2.0,
        shadowDepth: 4.0,
      ),
    ],
    textTheme: _buildTextTheme(AppColors.lightPrimary),
  );

  // --- DARK THEME ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkAppbarBackground,
      foregroundColor: AppColors.darkAppbarForeground,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        side: BorderSide(width: 2.0, color: AppColors.darkPrimary),
        borderRadius: BorderRadius.zero,
      ),
    ),
    // Extensions and Defaults
    extensions: [
      const AppCustomColors(
        weirdBorder: AppColors.darkPrimary,
        highlight: AppColors.darkSecondary,
        borderWidth: 2.0,
      ),
      const NeubrutalistTheme(
        primaryAccent: AppColors.darkSecondary,
        secondaryAccent: AppColors.neonLime,
        surface: AppColors.darkSurface,
        borderColor: AppColors.darkPrimary,
        textColor: AppColors.darkPrimary,
        inverseText: AppColors.darkOnPrimary,
        shadowColor: AppColors.pureBlack, // Keep black shadow for dark mode visibility?
        borderWidth: 2.0,
        shadowDepth: 4.0,
      ),
    ],
    textTheme: _buildTextTheme(AppColors.darkPrimary),
  );
}

TextTheme _buildTextTheme(Color color) {
  return TextTheme(
    // Headlines: Inter/Montserrat (Black/ExtraBold) -> We'll use Inter
    displayLarge: GoogleFonts.inter(
      fontSize: 56, fontWeight: FontWeight.w900, color: color, height: 1.0, letterSpacing: -2.0,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 40, fontWeight: FontWeight.w800, color: color, height: 1.0, letterSpacing: -1.0,
    ),
    // System Text: JetBrains Mono / Roboto Mono
    bodyLarge: GoogleFonts.jetBrainsMono(
      fontSize: 16, fontWeight: FontWeight.w500, color: color,
    ),
    bodyMedium: GoogleFonts.jetBrainsMono(
      fontSize: 14, fontWeight: FontWeight.w400, color: color,
    ),
    labelLarge: GoogleFonts.jetBrainsMono(
      fontSize: 14, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.0,
    ),
  );
}
