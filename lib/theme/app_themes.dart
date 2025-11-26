import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme_schema.dart';

// ==============================================================================
// Default Themes
// ==============================================================================

class DefaultLightTheme extends AppThemeColorSchema {
  @override
  Color get primary => const Color(0xFF3E7D5B);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get primaryContainer => const Color(0xFFD8ECE0);
  @override
  Color get onPrimaryContainer => const Color(0xFF122B1D);
  @override
  Color get secondary => const Color(0xFF22201E);
  @override
  Color get onSecondary => const Color(0xFFF8F4E3);
  @override
  Color get secondaryContainer => const Color(0xFFE6DBC5);
  @override
  Color get onSecondaryContainer => const Color(0xFF22201E);
  @override
  Color get tertiary => const Color(0xFF3E7D5B); // Fallback to primary if not specified
  @override
  Color get onTertiary => const Color(0xFFFFFFFF);
  @override
  Color get tertiaryContainer => const Color(0xFFD8ECE0);
  @override
  Color get onTertiaryContainer => const Color(0xFF122B1D);
  @override
  Color get error => const Color(0xFFBA1A1A);
  @override
  Color get onError => const Color(0xFFFFFFFF);
  @override
  Color get errorContainer => const Color(0xFFFFDAD6);
  @override
  Color get onErrorContainer => const Color(0xFF410002);
  @override
  Color get background => const Color(0xFFF8F4E3); // Surface color used as background
  @override
  Color get onBackground => const Color(0xFF22201E);
  @override
  Color get surface => const Color(0xFFF8F4E3);
  @override
  Color get onSurface => const Color(0xFF22201E);
  @override
  Color get surfaceVariant => const Color(0xFFDBE5DE); // Derived approximate
  @override
  Color get onSurfaceVariant => const Color(0xFF404943); // Derived approximate
  @override
  Color get outline => const Color(0xFF78857C);
  @override
  Color get outlineVariant => const Color(0xFFC0C9C2);
  @override
  Color get shadow => const Color(0xFF000000);
  @override
  Color get scrim => const Color(0xFF000000);
  @override
  Color get inverseSurface => const Color(0xFF2F312D);
  @override
  Color get onInverseSurface => const Color(0xFFF0F1EB);
  @override
  Color get inversePrimary => const Color(0xFF5FB57D);
  @override
  Brightness get brightness => Brightness.light;
}

class DefaultDarkTheme extends AppThemeColorSchema {
  @override
  Color get primary => const Color(0xFF5FB57D);
  @override
  Color get onPrimary => const Color(0xFF122B1D);
  @override
  Color get primaryContainer => const Color(0xFF2C523A);
  @override
  Color get onPrimaryContainer => const Color(0xFFD8ECE0);
  @override
  Color get secondary => const Color(0xFFF8F4E3);
  @override
  Color get onSecondary => const Color(0xFF22201E);
  @override
  Color get secondaryContainer => const Color(0xFF4A4642);
  @override
  Color get onSecondaryContainer => const Color(0xFFF8F4E3);
  @override
  Color get tertiary => const Color(0xFF5FB57D);
  @override
  Color get onTertiary => const Color(0xFF122B1D);
  @override
  Color get tertiaryContainer => const Color(0xFF2C523A);
  @override
  Color get onTertiaryContainer => const Color(0xFFD8ECE0);
  @override
  Color get error => const Color(0xFFFFB4AB);
  @override
  Color get onError => const Color(0xFF690005);
  @override
  Color get errorContainer => const Color(0xFF93000A);
  @override
  Color get onErrorContainer => const Color(0xFFFFDAD6);
  @override
  Color get background => const Color(0xFF22201E);
  @override
  Color get onBackground => const Color(0xFFF8F4E3);
  @override
  Color get surface => const Color(0xFF22201E);
  @override
  Color get onSurface => const Color(0xFFF8F4E3);
  @override
  Color get surfaceVariant => const Color(0xFF404943);
  @override
  Color get onSurfaceVariant => const Color(0xFFC0C9C2);
  @override
  Color get outline => const Color(0xFF8D9990);
  @override
  Color get outlineVariant => const Color(0xFF404943);
  @override
  Color get shadow => const Color(0xFF000000);
  @override
  Color get scrim => const Color(0xFF000000);
  @override
  Color get inverseSurface => const Color(0xFFE2E3DD);
  @override
  Color get onInverseSurface => const Color(0xFF2F312D);
  @override
  Color get inversePrimary => const Color(0xFF3E7D5B);
  @override
  Brightness get brightness => Brightness.dark;
}

// ==============================================================================
// Catppuccin Themes
// ==============================================================================

// Catppuccin Latte (Light)
class CatppuccinLatteTheme extends AppThemeColorSchema {
  @override
  Color get primary => const Color(0xFF1e66f5); // Blue
  @override
  Color get onPrimary => const Color(0xFFeff1f5); // Base
  @override
  Color get primaryContainer => const Color(0xFF7287fd); // Lavender
  @override
  Color get onPrimaryContainer => const Color(0xFFeff1f5); // Base
  @override
  Color get secondary => const Color(0xFFea76cb); // Pink
  @override
  Color get onSecondary => const Color(0xFFeff1f5); // Base
  @override
  Color get secondaryContainer => const Color(0xFFdc8a78); // Rosewater
  @override
  Color get onSecondaryContainer => const Color(0xFFeff1f5); // Base
  @override
  Color get tertiary => const Color(0xFF179299); // Teal
  @override
  Color get onTertiary => const Color(0xFFeff1f5); // Base
  @override
  Color get tertiaryContainer => const Color(0xFF04a5e5); // Sky
  @override
  Color get onTertiaryContainer => const Color(0xFFeff1f5); // Base
  @override
  Color get error => const Color(0xFFd20f39); // Red
  @override
  Color get onError => const Color(0xFFeff1f5); // Base
  @override
  Color get errorContainer => const Color(0xFFfe640b); // Peach
  @override
  Color get onErrorContainer => const Color(0xFFeff1f5); // Base
  @override
  Color get background => const Color(0xFFeff1f5); // Base
  @override
  Color get onBackground => const Color(0xFF4c4f69); // Text
  @override
  Color get surface => const Color(0xFFeff1f5); // Base
  @override
  Color get onSurface => const Color(0xFF4c4f69); // Text
  @override
  Color get surfaceVariant => const Color(0xFFe6e9ef); // Mantle
  @override
  Color get onSurfaceVariant => const Color(0xFF5c5f77); // Subtext1
  @override
  Color get outline => const Color(0xFF9ca0b0); // Overlay0
  @override
  Color get outlineVariant => const Color(0xFFbcc0cc); // Surface1
  @override
  Color get shadow => const Color(0xFFdce0e8); // Crust
  @override
  Color get scrim => const Color(0xFFdce0e8); // Crust
  @override
  Color get inverseSurface => const Color(0xFF4c4f69); // Text
  @override
  Color get onInverseSurface => const Color(0xFFeff1f5); // Base
  @override
  Color get inversePrimary => const Color(0xFF8caaee); // Frappe Blue (approx inverse)
  @override
  Brightness get brightness => Brightness.light;
}

// Catppuccin Frappe (Dark - Low Contrast)
class CatppuccinFrappeTheme extends AppThemeColorSchema {
  @override
  Color get primary => const Color(0xFF8caaee); // Blue
  @override
  Color get onPrimary => const Color(0xFF303446); // Base
  @override
  Color get primaryContainer => const Color(0xFFbabbf1); // Lavender
  @override
  Color get onPrimaryContainer => const Color(0xFF303446); // Base
  @override
  Color get secondary => const Color(0xFFf4b8e4); // Pink
  @override
  Color get onSecondary => const Color(0xFF303446); // Base
  @override
  Color get secondaryContainer => const Color(0xFFf2d5cf); // Rosewater
  @override
  Color get onSecondaryContainer => const Color(0xFF303446); // Base
  @override
  Color get tertiary => const Color(0xFF81c8be); // Teal
  @override
  Color get onTertiary => const Color(0xFF303446); // Base
  @override
  Color get tertiaryContainer => const Color(0xFF99d1db); // Sky
  @override
  Color get onTertiaryContainer => const Color(0xFF303446); // Base
  @override
  Color get error => const Color(0xFFe78284); // Red
  @override
  Color get onError => const Color(0xFF303446); // Base
  @override
  Color get errorContainer => const Color(0xFFef9f76); // Peach
  @override
  Color get onErrorContainer => const Color(0xFF303446); // Base
  @override
  Color get background => const Color(0xFF303446); // Base
  @override
  Color get onBackground => const Color(0xFFc6d0f5); // Text
  @override
  Color get surface => const Color(0xFF303446); // Base
  @override
  Color get onSurface => const Color(0xFFc6d0f5); // Text
  @override
  Color get surfaceVariant => const Color(0xFF292c3c); // Mantle
  @override
  Color get onSurfaceVariant => const Color(0xFFa5adce); // Subtext1
  @override
  Color get outline => const Color(0xFF737994); // Overlay0
  @override
  Color get outlineVariant => const Color(0xFF51576d); // Surface1
  @override
  Color get shadow => const Color(0xFF232634); // Crust
  @override
  Color get scrim => const Color(0xFF232634); // Crust
  @override
  Color get inverseSurface => const Color(0xFFc6d0f5); // Text
  @override
  Color get onInverseSurface => const Color(0xFF303446); // Base
  @override
  Color get inversePrimary => const Color(0xFF1e66f5); // Latte Blue (approx inverse)
  @override
  Brightness get brightness => Brightness.dark;
}

// Catppuccin Macchiato (Dark - Medium Contrast)
class CatppuccinMacchiatoTheme extends AppThemeColorSchema {
  @override
  Color get primary => const Color(0xFF8aadf4); // Blue
  @override
  Color get onPrimary => const Color(0xFF24273a); // Base
  @override
  Color get primaryContainer => const Color(0xFFb7bdf8); // Lavender
  @override
  Color get onPrimaryContainer => const Color(0xFF24273a); // Base
  @override
  Color get secondary => const Color(0xFFf5bde6); // Pink
  @override
  Color get onSecondary => const Color(0xFF24273a); // Base
  @override
  Color get secondaryContainer => const Color(0xFFf4dbd6); // Rosewater
  @override
  Color get onSecondaryContainer => const Color(0xFF24273a); // Base
  @override
  Color get tertiary => const Color(0xFF8bd5ca); // Teal
  @override
  Color get onTertiary => const Color(0xFF24273a); // Base
  @override
  Color get tertiaryContainer => const Color(0xFF91d7e3); // Sky
  @override
  Color get onTertiaryContainer => const Color(0xFF24273a); // Base
  @override
  Color get error => const Color(0xFFed8796); // Red
  @override
  Color get onError => const Color(0xFF24273a); // Base
  @override
  Color get errorContainer => const Color(0xFFf5a97f); // Peach
  @override
  Color get onErrorContainer => const Color(0xFF24273a); // Base
  @override
  Color get background => const Color(0xFF24273a); // Base
  @override
  Color get onBackground => const Color(0xFFcad3f5); // Text
  @override
  Color get surface => const Color(0xFF24273a); // Base
  @override
  Color get onSurface => const Color(0xFFcad3f5); // Text
  @override
  Color get surfaceVariant => const Color(0xFF1e2030); // Mantle
  @override
  Color get onSurfaceVariant => const Color(0xFFa5adcb); // Subtext1
  @override
  Color get outline => const Color(0xFF6e738d); // Overlay0
  @override
  Color get outlineVariant => const Color(0xFF494d64); // Surface1
  @override
  Color get shadow => const Color(0xFF181926); // Crust
  @override
  Color get scrim => const Color(0xFF181926); // Crust
  @override
  Color get inverseSurface => const Color(0xFFcad3f5); // Text
  @override
  Color get onInverseSurface => const Color(0xFF24273a); // Base
  @override
  Color get inversePrimary => const Color(0xFF1e66f5); // Latte Blue (approx inverse)
  @override
  Brightness get brightness => Brightness.dark;
}

// Catppuccin Mocha (Dark - High Contrast)
class CatppuccinMochaTheme extends AppThemeColorSchema {
  @override
  Color get primary => const Color(0xFF89b4fa); // Blue
  @override
  Color get onPrimary => const Color(0xFF1e1e2e); // Base
  @override
  Color get primaryContainer => const Color(0xFFb4befe); // Lavender
  @override
  Color get onPrimaryContainer => const Color(0xFF1e1e2e); // Base
  @override
  Color get secondary => const Color(0xFFf5c2e7); // Pink
  @override
  Color get onSecondary => const Color(0xFF1e1e2e); // Base
  @override
  Color get secondaryContainer => const Color(0xFFf5e0dc); // Rosewater
  @override
  Color get onSecondaryContainer => const Color(0xFF1e1e2e); // Base
  @override
  Color get tertiary => const Color(0xFF94e2d5); // Teal
  @override
  Color get onTertiary => const Color(0xFF1e1e2e); // Base
  @override
  Color get tertiaryContainer => const Color(0xFF89dceb); // Sky
  @override
  Color get onTertiaryContainer => const Color(0xFF1e1e2e); // Base
  @override
  Color get error => const Color(0xFFf38ba8); // Red
  @override
  Color get onError => const Color(0xFF1e1e2e); // Base
  @override
  Color get errorContainer => const Color(0xFFfab387); // Peach
  @override
  Color get onErrorContainer => const Color(0xFF1e1e2e); // Base
  @override
  Color get background => const Color(0xFF1e1e2e); // Base
  @override
  Color get onBackground => const Color(0xFFcdd6f4); // Text
  @override
  Color get surface => const Color(0xFF1e1e2e); // Base
  @override
  Color get onSurface => const Color(0xFFcdd6f4); // Text
  @override
  Color get surfaceVariant => const Color(0xFF181825); // Mantle
  @override
  Color get onSurfaceVariant => const Color(0xFFbac2de); // Subtext1
  @override
  Color get outline => const Color(0xFF6c7086); // Overlay0
  @override
  Color get outlineVariant => const Color(0xFF45475a); // Surface1
  @override
  Color get shadow => const Color(0xFF11111b); // Crust
  @override
  Color get scrim => const Color(0xFF11111b); // Crust
  @override
  Color get inverseSurface => const Color(0xFFcdd6f4); // Text
  @override
  Color get onInverseSurface => const Color(0xFF1e1e2e); // Base
  @override
  Color get inversePrimary => const Color(0xFF1e66f5); // Latte Blue (approx inverse)
  @override
  Brightness get brightness => Brightness.dark;
}

enum AppThemeType {
  defaultLight,
  defaultDark,
  catppuccinLatte,
  catppuccinFrappe,
  catppuccinMacchiato,
  catppuccinMocha;

  String get displayName {
    switch (this) {
      case AppThemeType.defaultLight:
        return 'Default Light';
      case AppThemeType.defaultDark:
        return 'Default Dark';
      case AppThemeType.catppuccinLatte:
        return 'Catppuccin Latte';
      case AppThemeType.catppuccinFrappe:
        return 'Catppuccin Frappé';
      case AppThemeType.catppuccinMacchiato:
        return 'Catppuccin Macchiato';
      case AppThemeType.catppuccinMocha:
        return 'Catppuccin Mocha';
    }
  }

  AppThemeColorSchema get schema {
    switch (this) {
      case AppThemeType.defaultLight:
        return DefaultLightTheme();
      case AppThemeType.defaultDark:
        return DefaultDarkTheme();
      case AppThemeType.catppuccinLatte:
        return CatppuccinLatteTheme();
      case AppThemeType.catppuccinFrappe:
        return CatppuccinFrappeTheme();
      case AppThemeType.catppuccinMacchiato:
        return CatppuccinMacchiatoTheme();
      case AppThemeType.catppuccinMocha:
        return CatppuccinMochaTheme();
    }
  }
}

