import 'dart:math';
import 'dart:ui' as ui;
import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

class GravityGrid extends StatelessWidget {
  const GravityGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: CursorController.instance.position,
      builder: (context, mousePos, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _GravityGridPainter(
            mousePos: mousePos,
            color: context.nbt.borderColor.withOpacity(0.35),
          ),
        );
      },
    );
  }
}

class _GravityGridPainter extends CustomPainter {
  final Offset mousePos;
  final Color color;

  _GravityGridPainter({required this.mousePos, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Black Hole Effect: Fade out lines near the cursor
    final double holeRadius = 15.0;
    final double fadeRadius = 100.0; // Fade begins here
    
    paint.shader = ui.Gradient.radial(
      mousePos, 
      fadeRadius, 
      [Colors.transparent, color], 
      [holeRadius / fadeRadius, 1.0], 
      TileMode.clamp
    );

    const gridSize = 60.0;
    final cols = (size.width / gridSize).ceil() + 1;
    final rows = (size.height / gridSize).ceil() + 1;

    // Helper to deform a point
    Offset deform(Offset p) {
      final delta = p - mousePos;
      final dist = delta.distance;
      const radius = 400.0; // Affected radius
      const strength = 50.0; // Max displacement

      if (dist < radius) {
        final factor = (1 - (dist / radius)) * (1 - (dist / radius)); // Quadratic fallout
        
        if (dist > 0) {
            final normalized = delta / dist;
            // Prevent crossover: clamp displacement to be less than distance
            // so points don't cross through the center.
            final displacement = min(factor * strength, dist * 0.8); 
            return p - (normalized * displacement);
        } 
      }
      return p;
    }

    // Draw vertical lines
    for (int i = 0; i < cols; i++) {
        final x = i * gridSize;
        final path = Path();
        bool started = false;
        
        // Subdivide line for smooth curve
        for (int j = 0; j <= rows * 2; j++) { // Double resolution
           final y = j * (gridSize / 2);
           final p = deform(Offset(x, y));
           if (!started) {
             path.moveTo(p.dx, p.dy);
             started = true;
           } else {
             path.lineTo(p.dx, p.dy);
           }
        }
        canvas.drawPath(path, paint);
    }

    // Draw horizontal lines
    for (int j = 0; j < rows; j++) {
        final y = j * gridSize;
        final path = Path();
        bool started = false;

        for (int i = 0; i <= cols * 2; i++) {
           final x = i * (gridSize / 2);
           final p = deform(Offset(x, y));
           if (!started) {
             path.moveTo(p.dx, p.dy);
             started = true;
           } else {
             path.lineTo(p.dx, p.dy);
           }
        }
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GravityGridPainter oldDelegate) {
    return oldDelegate.mousePos != mousePos || oldDelegate.color != color;
  }
}
