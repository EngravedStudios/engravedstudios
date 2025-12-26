import 'package:engravedstudios/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// NEW THEME SYSTEM EXPORTS
export 'app_colors.dart';
export 'app_theme.dart';

// --- Static Colors (Deprecated for direct usage, used for definitions) ---
class GameHUDColors {
  // Light Mode Defaults
  static const Color neonLime = AppColors.neonLime;
  static const Color hardBlack = AppColors.pureBlack; 
  static const Color paperWhite = AppColors.ghostWhite; 
  static const Color ghostGray = AppColors.ghostGray;
  
  // Dark Mode Defaults
  static const Color carbonBlack = AppColors.deepOnyx;
  static const Color electricOrange = AppColors.accentRed; // Map to Red for now
  static const Color deepCyan = Color(0xFF00E5FF); // Keep legacy
  
  static const Color glitchRed = AppColors.accentRed;
  
  // Aliases for backward compatibility
  static const Color cyan = deepCyan;
  static const Color inkBlack = carbonBlack;
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
