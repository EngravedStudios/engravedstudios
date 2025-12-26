import 'dart:math';

import 'package:flutter/material.dart';

class NoiseOverlay extends StatelessWidget {
  const NoiseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _NoisePainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    // Draw random specks
    // Optimization: Don't draw too many or it lags. 
    // A better way is a Tiled Pattern but CustomPainter is acceptable for MVP.
    // Let's draw 2000 points.
    
    for (int i = 0; i < 2000; i++) {
        paint.color = (i % 2 == 0 ? Colors.white : Colors.black).withOpacity(0.05);
        canvas.drawCircle(
          Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          0.5,
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // Static noise for perf
}
