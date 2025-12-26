import 'dart:math';

import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final nbt = context.nbt;
    
    // Full viewport height
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Asymmetrical Layout: 60/40 on Desktop, Stack/Column on Mobile
    return SliverToBoxAdapter(
      child: Container(
        height: screenHeight, // Full Screen
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: GameHUDLayout.borderWidth,
              color: nbt.borderColor,
            ),
          ),
        ),
        child: isDesktop 
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 6, child: _HeroContentLeft()),
                  Container(width: GameHUDLayout.borderWidth, color: nbt.borderColor),
                  Expanded(flex: 4, child: _HeroVisualRight()),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                   // Navbar spacing handled by alignment/padding now
                   Expanded(child: _HeroContentLeft()),
                   SizedBox(height: screenHeight * 0.4, child: _HeroVisualRight()), // 40% height for visual
                ],
              ),
      ),
    );
  }
}

class _HeroContentLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    final fontSize = context.responsive<double>(48, 120, 80);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "Terminal" Header
          Text(
            "// SYSTEM.READY :: 120Hz",
            style: GameHUDTextStyles.terminalText.copyWith(
               color: nbt.primaryAccent,
               backgroundColor: nbt.shadowColor, // Black bg
            ),
          ).animate().fadeIn(duration: 400.ms).shimmer().then(delay: 500.ms),
          
          const SizedBox(height: 32),
          
          _KineticLine(text: "WE ENGRAVE", fontSize: fontSize, delay: 0),
          _KineticLine(text: "DIGITAL", fontSize: fontSize, delay: 200, color: GameHUDColors.glitchRed), // Glitch red is universal? Or secondary accent?
          _KineticLine(text: "WORLDS.", fontSize: fontSize, delay: 400, outline: true),

          const SizedBox(height: 48),

          Container(
            padding: const EdgeInsets.only(left: 24.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: GameHUDLayout.borderWidth,
                  color: nbt.primaryAccent,
                ),
              ),
            ),
            child: Text(
              "FORGING AVANT-GARDE EXPERIENCES.\nWHERE HIGH-FASHION MEETS HARDCORE GAMING.",
              style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 24, color: nbt.textColor),
            ),
          ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.05),
        ],
      ),
    );
  }
}

class _KineticLine extends StatelessWidget {
  final String text;
  final double fontSize;
  final int delay;
  final Color? color;
  final bool outline;

  const _KineticLine({
    required this.text,
    required this.fontSize,
    required this.delay,
    this.color,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    
    TextStyle style = GameHUDTextStyles.headlineHeavy.copyWith(
      fontSize: fontSize,
      color: color ?? nbt.textColor,
    );
    
    if (outline) {
      style = style.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color ?? nbt.textColor,
      );
    }

    // Letters "drop in" -> SlideY from negative + Fade + small bounce
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: style,
      ).animate().fadeIn(delay: delay.ms, duration: 600.ms)
      .slideY(begin: -0.5, end: 0, curve: Curves.easeOutBack), // Bounce effect
    );
  }
}

class _HeroVisualRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    // Tilted container
    return Center(
      child: Transform.rotate(
        angle: 3 * pi / 180, // 3 degrees tilt
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: nbt.surface,
            border: Border.all(width: 3, color: nbt.borderColor),
            boxShadow: [
              BoxShadow(
                color: nbt.shadowColor,
                offset: const Offset(8, 8),
              )
            ]
          ),
          child: Stack(
            children: [
              // Placeholder for "Game Clip"
              Positioned.fill(
                child: Container(
                  color: nbt.borderColor.withOpacity(0.1),
                  child: Center(
                    child: Icon(Icons.play_circle_outline, size: 64, color: nbt.textColor),
                  ),
                ),
              ),
              // Overlay Lines/Grid
               Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(nbt.borderColor),
                ),
              ),
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
      .moveY(begin: -10, end: 10, duration: 2000.ms, curve: Curves.easeInOutQuad), // Floating animation
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 1;
    
    // Draw simple grid
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => oldDelegate.color != color;
}
