import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'responsive_layout_strategy.dart';

/// A widget that builds the UI using the appropriate [ResponsiveLayoutStrategy]
/// based on the current screen width.
class ResponsiveBuilder extends ConsumerWidget {
  final ResponsiveLayoutStrategy mobileStrategy;
  final ResponsiveLayoutStrategy? tabletStrategy;
  final ResponsiveLayoutStrategy desktopStrategy;

  const ResponsiveBuilder({
    super.key,
    required this.mobileStrategy,
    this.tabletStrategy,
    required this.desktopStrategy,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktopStrategy.build(context, ref);
        } else if (constraints.maxWidth >= 600 && tabletStrategy != null) {
          return tabletStrategy!.build(context, ref);
        } else {
          return mobileStrategy.build(context, ref);
        }
      },
    );
  }
}
