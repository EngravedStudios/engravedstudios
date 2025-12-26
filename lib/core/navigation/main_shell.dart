import 'package:engravedstudios/core/effects/noise_overlay.dart';
import 'package:engravedstudios/core/input/cheat_code_listener.dart';
import 'package:engravedstudios/shared/widgets/cursor_wrapper.dart';
import 'package:engravedstudios/shared/widgets/glitch_overlay.dart';
import 'package:engravedstudios/shared/widgets/neubrutalist_navbar.dart';
import 'package:engravedstudios/shared/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure the background is visible if child is transparent (though child is Scaffold)
      backgroundColor: Colors.white, 
      body: CheatCodeListener(
        child: CursorWrapper(
          child: Stack(
          fit: StackFit.expand,
          children: [
            // Content Layer
            Positioned.fill(
              child: child,
            ),
            
            // Noise Overlay
            const Positioned.fill(
              child: IgnorePointer(child: NoiseOverlay()),
            ),
            
            // Floating Navbar Layer
            const Positioned(
              top: 0,
              left: 0, 
              right: 60, // Make room for toggle
              child: NeubrutalistNavbar(),
            ),
            
            // Theme Toggle
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
    );
  }
}
