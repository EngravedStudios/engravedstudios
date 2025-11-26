import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../responsive/responsive_builder.dart';
import 'home_strategies.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(
      mobileStrategy: MobileHomeStrategy(),
      desktopStrategy: DesktopHomeStrategy(),
      // We can add a TabletStrategy later if needed, or reuse Mobile/Desktop
      tabletStrategy: MobileHomeStrategy(), 
    );
  }
}
