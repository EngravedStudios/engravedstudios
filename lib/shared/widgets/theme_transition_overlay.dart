import 'dart:math';
import 'dart:ui';

import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/theme/theme_controller.dart';
import 'package:engravedstudios/core/theme/theme_transition_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeTransitionOverlay extends ConsumerStatefulWidget {
  const ThemeTransitionOverlay({super.key});

  @override
  ConsumerState<ThemeTransitionOverlay> createState() => _ThemeTransitionOverlayState();
}

class _ThemeTransitionOverlayState extends ConsumerState<ThemeTransitionOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Transition Logic
  // 1. Expand Black Circle from Top-Right (Implosion/Coverage)
  // 2. Trigger Theme Switch
  // 3. Fade Out Circle (Explosion/Reveal)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Total duration
    );

    // Restore State if Rebuilt during transition
    final currentState = ref.read(themeTransitionProvider);
    if (currentState.status != TransitionState.idle) {
      _controller.value = currentState.transitionPercent;
      _controller.forward();
    }

    _controller.addStatusListener((status) {
      final transitionNotifier = ref.read(themeTransitionProvider.notifier);
      
      if (status == AnimationStatus.completed) {
        // Animation Done
        transitionNotifier.reset();
        _controller.reset();
      }
    });

    _controller.addListener(() {
      final transitionNotifier = ref.read(themeTransitionProvider.notifier);
      transitionNotifier.updateProgress(_controller.value);

      // Coordinate phases
      // Phase 1: Expansion (0.0 -> 0.4)
      // Phase 2: Switch (0.4)
      // Phase 3: Reveal/Fade (0.5 -> 1.0)
      
      if (_controller.value >= 0.4 && _controller.value < 0.45 ) {
        if (ref.read(themeTransitionProvider).status == TransitionState.expanding) {
           transitionNotifier.setCovered(); 
           // Trigger Switch
           ref.read(themeControllerProvider.notifier).toggle();
           transitionNotifier.startFading();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for Start Signal
    ref.listen(themeTransitionProvider, (prev, next) {
      if (prev?.status == TransitionState.idle && next.status == TransitionState.expanding) {
        _controller.forward(from: 0.0);
      }
    });

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.value == 0) return const SizedBox.shrink();

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Dynamic Origin from Provider
        // Fallback to Top-Right if missing (shouldn't happen with new Toggle)
        final origin = ref.read(themeTransitionProvider).origin ?? Offset(screenWidth - 48, 48);
        
        // Calculate Max Radius (to cover screen from origin)
        // Distance to furthest corner
        final distTL = (origin - Offset.zero).distance;
        final distTR = (origin - Offset(screenWidth, 0)).distance;
        final distBL = (origin - Offset(0, screenHeight)).distance;
        final distBR = (origin - Offset(screenWidth, screenHeight)).distance;
        final maxRadius = [distTL, distTR, distBL, distBR].reduce(max) * 1.1; // 10% buffer

        // Phase 1: Expansion (0.0 to 0.4)
        double radius = 0;
        double opacity = 1.0;
        
        if (_controller.value <= 0.4) {
          // Expansion Curve
          final t = (_controller.value) / 0.4;
          final curve = Curves.easeInExpo.transform(t);
          radius = maxRadius * curve;
        } else {
          // Phase 2: Fade Out (0.4 to 1.0)
          radius = maxRadius; // Fully covered
          final t = (_controller.value - 0.4) / 0.6;
          // Fade opacity
          opacity = 1.0 - Curves.easeOut.transform(t);
        }

        final overlayColor = GameHUDColors.hardBlack; 

        return IgnorePointer(
          child: Stack(
            children: [
               // Void Circle
               if (opacity > 0.01)
               ClipPath(
                 clipper: _CircleClipper(center: origin, radius: radius),
                 child: Container(
                   color: overlayColor,
                 ),
               ),
               
               // Gravity Wave Ring
               // Visible during entire transition
               CustomPaint(
                  painter: _ShockwavePainter(
                    center: origin, 
                    currentRadius: radius,
                    maxRadius: maxRadius,
                    opacity: opacity,
                    color: Theme.of(context).extension<NeubrutalistTheme>()?.primaryAccent ?? GameHUDColors.neonLime,
                  ),
                  size: Size.infinite,
               ),
            ],
          ),
        );
      },
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;
  _CircleClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    if (radius <= 0) return Path();
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant _CircleClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.center != center;
  }
}

class _ShockwavePainter extends CustomPainter {
  final Offset center;
  final double currentRadius;
  final double maxRadius;
  final double opacity;
  final Color color;

  _ShockwavePainter({
    required this.center, 
    required this.currentRadius, 
    required this.maxRadius,
    required this.opacity, 
    required this.color
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.01) return;
    
    final paint = Paint()
      ..color = color.withOpacity(opacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // Main Ring at edge of void
    canvas.drawCircle(center, currentRadius, paint);
    
    // Outer "Warp" Rings (Visual distortion effect)
    if (currentRadius > 0) {
      final wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
        
      for (int i = 1; i <= 3; i++) {
        final r = currentRadius + (i * 30);
        final op = (opacity * 0.3) / i;
        wavePaint.color = color.withOpacity(op.clamp(0.0, 1.0));
        canvas.drawCircle(center, r, wavePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ShockwavePainter old) => 
      old.currentRadius != currentRadius || old.opacity != opacity;
}
