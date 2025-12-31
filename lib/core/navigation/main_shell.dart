import 'package:engravedstudios/core/effects/noise_overlay.dart';
import 'package:engravedstudios/core/input/cheat_code_listener.dart';
import 'package:engravedstudios/core/navigation/navbar_controller.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:engravedstudios/shared/widgets/cursor_wrapper.dart';
import 'package:engravedstudios/shared/widgets/glitch_overlay.dart';
import 'package:engravedstudios/shared/widgets/mobile_bottom_navbar.dart';
import 'package:engravedstudios/shared/widgets/neubrutalist_navbar.dart';
import 'package:engravedstudios/shared/shaders/shader_background.dart';
import 'package:engravedstudios/shared/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isNavbarVisible = ref.watch(navbarControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white, 
      resizeToAvoidBottomInset: false,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (!isMobile) {
            final controller = ref.read(navbarControllerProvider.notifier);
            if (notification.direction == ScrollDirection.reverse) {
              controller.hide();
            } else if (notification.direction == ScrollDirection.forward) {
              controller.show();
            }
          }
          return false;
        },
        child: CheatCodeListener(
          child: CursorWrapper(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Shader Background
                const Positioned.fill(child: ShaderBackground()),

                // Content Layer
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isMobile ? 80.0 : 0.0),
                    child: child,
                  ),
                ),
                
                // Noise Overlay
                const Positioned.fill(
                  child: IgnorePointer(child: NoiseOverlay()),
                ),
                
                // Floating Navbar Layer - Desktop Only (Animated)
                if (!isMobile)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    top: isNavbarVisible ? 0 : -80, // Slide up when hidden
                    left: 0, 
                    right: 60,
                    child: const NeubrutalistNavbar(),
                  ),
                
                // Mobile Bottom Navbar
                if (isMobile)
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: MobileBottomNavbar(),
                  ),

                // Theme Toggle (Always Top Right)
                const Positioned(
                  top: 24,
                  right: 24,
                  child: ThemeToggle(),
                ),
                
                // Glitch Overlay
                const GlitchOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
