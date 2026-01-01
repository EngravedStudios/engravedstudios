import 'package:engravedstudios/core/effects/noise_overlay.dart';
import 'package:engravedstudios/core/input/cheat_code_listener.dart';
import 'package:engravedstudios/core/navigation/navbar_controller.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:engravedstudios/shared/widgets/cursor_wrapper.dart';
import 'package:engravedstudios/shared/widgets/floating_shapes_background.dart';
import 'package:engravedstudios/shared/widgets/shader_warp_overlay.dart';
import 'package:engravedstudios/shared/widgets/mobile_bottom_navbar.dart';
import 'package:engravedstudios/shared/widgets/neubrutalist_navbar.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/shared/widgets/gravity_grid_background.dart';
import 'package:engravedstudios/shared/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  final ValueNotifier<double> _scrollNotifier = ValueNotifier(0.0);

  @override
  void dispose() {
    _scrollNotifier.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    // Update scroll offset for parallax
    if (notification is ScrollUpdateNotification && notification.depth == 0) {
      if (notification.metrics.axis == Axis.vertical) {
         _scrollNotifier.value = notification.metrics.pixels;
      }
    }

    // Navbar visibility logic
    final isMobile = ResponsiveUtils.isMobile(context);
    if (!isMobile && notification is UserScrollNotification) {
      final controller = ref.read(navbarControllerProvider.notifier);
      if (notification.direction == ScrollDirection.reverse) {
        controller.hide();
      } else if (notification.direction == ScrollDirection.forward) {
        controller.show();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isNavbarVisible = ref.watch(navbarControllerProvider);

    return ShaderWarpOverlay(
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        resizeToAvoidBottomInset: false,
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: CheatCodeListener(
            child: CursorWrapper(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Solid Background
                  Positioned.fill(child: Container(color: context.nbt.surface)),

                  // Gravity Grid (Deforms on cursor)
                  const Positioned.fill(child: GravityGrid()),

                  // Floating Geometric Shapes (Parallax)
                  Positioned.fill(
                    child: FloatingShapesBackground(
                      scrollOffsetNotifier: !isMobile ? _scrollNotifier : null,
                    ),
                  ),

                  // Content Layer
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isMobile ? 80.0 : 0.0),
                      child: widget.child,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
