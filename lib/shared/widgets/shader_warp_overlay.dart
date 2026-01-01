import 'dart:math';

import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/theme/theme_controller.dart';
import 'package:engravedstudios/core/theme/theme_transition_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Optimized ripple-based theme transition.
class ShaderWarpOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const ShaderWarpOverlay({super.key, required this.child});

  @override
  ConsumerState<ShaderWarpOverlay> createState() => _ShaderWarpOverlayState();
}

class _ShaderWarpOverlayState extends ConsumerState<ShaderWarpOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _origin = Offset.zero;
  bool _isAnimating = false;
  double _maxRadius = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Faster = less frames
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isAnimating = false);
        _controller.reset();
        ref.read(themeTransitionProvider.notifier).reset();
      }
    });

    _controller.addListener(() {
      if (_controller.value >= 0.38 && _controller.value < 0.42) {
        final state = ref.read(themeTransitionProvider);
        if (state.status == TransitionState.expanding) {
          ref.read(themeTransitionProvider.notifier).setCovered();
          
          // Defer theme toggle to after current frame to avoid animation jank
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(themeControllerProvider.notifier).toggle();
          });
          
          ref.read(themeTransitionProvider.notifier).startFading();
        }
      }
    });
  }

  void _startTransition(Offset origin) {
    if (_isAnimating) return;
    _origin = origin;
    setState(() => _isAnimating = true);
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(themeTransitionProvider, (prev, next) {
      if (prev?.status == TransitionState.idle &&
          next.status == TransitionState.expanding &&
          next.origin != null) {
        _startTransition(next.origin!);
      }
    });

    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final nbt = context.nbt;

    return Stack(
      children: [
        widget.child,

        if (_isAnimating)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final distTL = (_origin - Offset.zero).distance;
              final distTR = (_origin - Offset(size.width, 0)).distance;
              final distBL = (_origin - Offset(0, size.height)).distance;
              final distBR = (_origin - Offset(size.width, size.height)).distance;
              _maxRadius = [distTL, distTR, distBL, distBR].reduce(max) * 1.05;

              final progress = _controller.value;
              final isCovering = progress <= 0.4;
              final phaseProgress = isCovering 
                  ? progress / 0.4 
                  : (progress - 0.4) / 0.6;

              double coveredRadius;
              double revealRadius = 0;

              if (isCovering) {
                coveredRadius = _maxRadius * Curves.easeOut.transform(phaseProgress);
              } else {
                coveredRadius = _maxRadius;
                revealRadius = _maxRadius * Curves.easeOut.transform(phaseProgress);
              }

              return IgnorePointer(
                child: Stack(
                  children: [
                    // OPTIMIZED: Use ClipPath for GPU-accelerated clipping
                    if (isCovering)
                      // Phase 1: Simple expanding circle
                      ClipOval(
                        clipper: _CenteredOvalClipper(center: _origin, radius: coveredRadius),
                        child: Container(color: colorScheme.onSurface),
                      )
                    else
                      // Phase 2: Full screen with circular hole (inverted clip)
                      ClipPath(
                        clipper: _InvertedCircleClipper(center: _origin, radius: revealRadius),
                        child: Container(color: colorScheme.onSurface),
                      ),

                    // Ripple rings (reduced to 3 for performance)
                    CustomPaint(
                      painter: _RipplePainter(
                        center: _origin,
                        edgeRadius: isCovering ? coveredRadius : revealRadius,
                        phaseProgress: phaseProgress,
                        color: nbt.primaryAccent,
                      ),
                      size: Size.infinite,
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Clips to an oval centered at a point
class _CenteredOvalClipper extends CustomClipper<Rect> {
  final Offset center;
  final double radius;

  _CenteredOvalClipper({required this.center, required this.radius});

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(center: center, radius: radius);
  }

  @override
  bool shouldReclip(_CenteredOvalClipper old) => old.radius != radius;
}

/// Clips everything EXCEPT a circle (creates a hole)
class _InvertedCircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  _InvertedCircleClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldReclip(_InvertedCircleClipper old) => old.radius != radius;
}

/// Simplified ripple painter - only 3 rings
class _RipplePainter extends CustomPainter {
  final Offset center;
  final double edgeRadius;
  final double phaseProgress;
  final Color color;

  _RipplePainter({
    required this.center,
    required this.edgeRadius,
    required this.phaseProgress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (edgeRadius <= 0) return;

    // Main edge ring
    canvas.drawCircle(
      center, 
      edgeRadius, 
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = color.withOpacity(0.7),
    );

    // Only 3 trailing ripples
    for (int i = 1; i <= 3; i++) {
      final r = edgeRadius - (i * 40);
      if (r > 0) {
        canvas.drawCircle(
          center, 
          r, 
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = max(1.0, 4.0 - i)
            ..color = color.withOpacity((0.4 / i).clamp(0.0, 1.0)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.edgeRadius != edgeRadius;
}
