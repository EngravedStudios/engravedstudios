import 'package:engravedstudios/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// NEW THEME SYSTEM EXPORTS
export 'app_colors.dart';
export 'app_theme.dart';

// --- Static Colors (Legacy compatibility layer) ---
// --- Static Colors (Mapped to new AppColors) ---
class GameHUDColors {
  // Primary Styles
  static const Color neonLime = AppColors.lightPrimary; // Signature Green
  static const Color hardBlack = AppColors.lightOnSurface; // #1A1A1A
  static const Color paperWhite = AppColors.lightSurface; // #F4EFE6
  static const Color ghostGray = AppColors.lightTertiary; // #6B5E4C
  
  // Dark/Accent Styles
  static const Color carbonBlack = AppColors.darkSurface;
  static const Color electricOrange = AppColors.lightSecondary; // Red/Orange accent
  static const Color deepCyan = AppColors.darkPrimary; // Tan replacing Cyan in dark mode? Or keep legacy? 
  // User said "use my new color themed", so let's use darkPrimary (Tan) as the secondary accent in dark mode.
  
  static const Color glitchRed = AppColors.lightSecondary;
  
  // Aliases 
  static const Color cyan = deepCyan;
  static const Color inkBlack = hardBlack;
}

// --- Borders & Spacing ---
class GameHUDLayout {
  static const double borderWidth = 3.0; 
  static const double cardBorderWidth = 3.0;
  static const double shadowOffset = 4.0;
  static const double gridSpacing = 24.0;
}

// --- Typography ---
class GameHUDTextStyles {
  // We will need to adapt colors dynamically too, but usually text is Hard Black or White depending on bg
  static TextStyle get headlineHeavy => GoogleFonts.syncopate(
     fontSize: 64, fontWeight: FontWeight.w900, height: 0.9, letterSpacing: -2.0,
  );

  static TextStyle get titleLarge => GoogleFonts.spaceGrotesk(
    fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1.0,
  );

  static TextStyle get terminalText => GoogleFonts.jetBrainsMono(
    fontSize: 14, fontWeight: FontWeight.w500,
  );
  
  static TextStyle get body => GoogleFonts.spaceGrotesk(
    fontSize: 16, height: 1.5,
  );

  static TextStyle get bodyText => body;

  static TextStyle get buttonText => GoogleFonts.spaceGrotesk(
     fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0,
  );

  static TextStyle get codeText => GoogleFonts.jetBrainsMono(
    fontSize: 12, fontWeight: FontWeight.w400,
  );
}
