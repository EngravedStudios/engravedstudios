import 'package:flutter/material.dart';

class ScanlinePainter extends CustomPainter {
  final Color color;
  final double opacity;

  ScanlinePainter({this.color = Colors.black, this.opacity = 0.1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.0;

    // Draw lines every 4 pixels
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Vignette for extra CRT feel (simplified radial gradient)
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [Colors.transparent, color.withOpacity(opacity * 2)],
      stops: const [0.6, 1.0],
    );
    
    final paintGradient = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paintGradient);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScanlineOverlay extends StatelessWidget {
  final Widget child;
  const ScanlineOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ScanlinePainter(color: Colors.black, opacity: 0.1),
            ),
          ),
        ),
      ],
    );
  }
}
