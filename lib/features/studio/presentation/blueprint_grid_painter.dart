import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

class BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GameHUDColors.cyan.withOpacity(0.05)
      ..strokeWidth = 1.0;

    const double cellSize = 40.0;
    
    // Vertical Lines
    for (double x = 0; x < size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Horizontal Lines
    for (double y = 0; y < size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Crosshairs
    final crossPaint = Paint()
      ..color = GameHUDColors.cyan.withOpacity(0.2)
      ..strokeWidth = 2.0;

    // Draw a few random "technical" marks
    canvas.drawLine(Offset(100, 100), Offset(120, 100), crossPaint);
    canvas.drawLine(Offset(110, 90), Offset(110, 110), crossPaint);
    
    canvas.drawLine(Offset(size.width - 100, size.height - 100), Offset(size.width - 120, size.height - 100), crossPaint);
    canvas.drawLine(Offset(size.width - 110, size.height - 90), Offset(size.width - 110, size.height - 110), crossPaint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
