import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint; // Treat tablet landscape as desktop-ish for this design
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  T resolve(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return mobile;
    }
    if (ResponsiveUtils.isTablet(context)) {
      return tablet ?? desktop;
    }
    return desktop;
  }
}

// Extension to make it easier to use
extension ResponsiveExtension on BuildContext {
  T responsive<T>(T mobile, [T? desktop, T? tablet]) {
    // If desktop is null, use mobile (or maybe we should require desktop? 
    // For this tailored helper, let's assume if you call this you want responsiveness.
    // If you only provide mobile, it returns mobile.
    
    // Adjusted logic:
    // If width < 600 -> mobile
    // If width < 900 -> tablet ?? desktop ?? mobile
    // Else -> desktop ?? mobile
    
    final width = MediaQuery.of(this).size.width;
    if (width < ResponsiveUtils.mobileBreakpoint) {
      return mobile;
    }
    if (width < ResponsiveUtils.tabletBreakpoint) {
      return tablet ?? desktop ?? mobile;
    }
    return desktop ?? mobile;
  }
}
