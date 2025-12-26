import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double strokeWidth;
  final Color strokeColor;

  const OutlinedText(
    this.text, {
    super.key,
    required this.style,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.black, // Defaults, overridable
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // No fill? The user requested "OutlinedText".
        // Usually this means transparent fill, or just stroke.
        // If we want FILL + OUTLINE, we uncomment the below.
        // For distinct "Brutalist" outlined text, often it's ONLY outline (transparent fill)
        // or White fill with Black outline.
        // Let's assume transparent fill (Ghost) unless style specifies color.
        // Actually, "OutlinedText" usually implies just the stroke.
        // But for better readability, a fill is often used.
        // Let's stick to STROKE ONLY as the base implementation.
        // If the user wants fill, they can stack a normal Text under it.
      ],
    );
  }
}
