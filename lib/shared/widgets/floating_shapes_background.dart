import 'dart:math';
import 'dart:ui';
import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

class FloatingShapesBackground extends StatelessWidget {
  final ValueNotifier<double>? scrollOffsetNotifier;
  const FloatingShapesBackground({super.key, this.scrollOffsetNotifier});

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    final screenSize = MediaQuery.sizeOf(context);
    
    // Define shapes with positions, sizes, colors, parallax factors
    final shapes = [
      _ShapeConfig(
        type: ShapeType.circle,
        x: 0.1, y: 0.2,
        size: 120,
        color: nbt.primaryAccent.withOpacity(0.7),
        blur: 20,
        parallaxFactor: 0.3,
      ),
      _ShapeConfig(
        type: ShapeType.square,
        x: 0.85, y: 0.15,
        size: 80,
        color: nbt.borderColor.withOpacity(0.6),
        blur: 20,
        parallaxFactor: 0.5,
      ),
      _ShapeConfig(
        type: ShapeType.circle,
        x: 0.7, y: 0.6,
        size: 200,
        color: nbt.primaryAccent.withOpacity(0.5),
        blur: 20,
        parallaxFactor: 0.2,
      ),
      _ShapeConfig(
        type: ShapeType.triangle,
        x: 0.2, y: 0.7,
        size: 100,
        color: nbt.borderColor.withOpacity(0.7),
        blur: 20,
        parallaxFactor: 0.4,
      ),
      _ShapeConfig(
        type: ShapeType.square,
        x: 0.5, y: 0.4,
        size: 60,
        color: nbt.primaryAccent.withOpacity(0.5),
        blur: 20,
        parallaxFactor: 0.6,
      ),
      _ShapeConfig(
        type: ShapeType.circle,
        x: 0.3, y: 1.2,
        size: 150,
        color: nbt.borderColor.withOpacity(0.6),
        blur: 20,
        parallaxFactor: 0.35,
      ),
      _ShapeConfig(
        type: ShapeType.triangle,
        x: 0.8, y: 1.5,
        size: 90,
        color: nbt.primaryAccent.withOpacity(0.4),
        blur: 20,
        parallaxFactor: 0.45,
      ),
    ];

    return IgnorePointer(
      child: ListenableBuilder(
        listenable: Listenable.merge([
           if (scrollOffsetNotifier != null) scrollOffsetNotifier!,
           CursorController.instance.position,
        ]),
        builder: (context, _) {
          final scrollOffset = scrollOffsetNotifier?.value ?? 0.0;
          final mousePos = CursorController.instance.position.value;
          
          return Stack(
            children: shapes.map((shape) {
              final parallaxOffset = scrollOffset * shape.parallaxFactor;
              final baseY = shape.y * screenSize.height;
              final adjustedY = baseY - parallaxOffset;
              
              // Use sigma = blur / 2 for smooth gaussian blur
              final sigma = shape.blur / 2;
              
              // We pass the global mouse position to the painter,
              // but the painter paints in local coordinates.
              // We must account for the shape's usage of Offset specific logic.
              // Actually easier: Pass global mouse pos and shape global offset
              // OR transform mouse pos to local.
              final shapePos = Offset(
                  shape.x * screenSize.width - shape.size / 2, 
                  adjustedY - shape.size / 2
              );
              
              // Transform global mouse pos to local coordinates for the warping logic
              final localMousePos = mousePos - shapePos;

              return Positioned(
                left: shapePos.dx,
                top: shapePos.dy,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                  child: CustomPaint(
                    size: Size(shape.size, shape.size),
                    painter: _DeformableShapePainter(
                      config: shape,
                      localMousePos: localMousePos,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

enum ShapeType { circle, square, triangle }

class _ShapeConfig {
  final ShapeType type;
  final double x; 
  final double y; 
  final double size;
  final Color color;
  final double blur;
  final double parallaxFactor;

  const _ShapeConfig({
    required this.type,
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.blur,
    required this.parallaxFactor,
  });
}

class _DeformableShapePainter extends CustomPainter {
  final _ShapeConfig config;
  final Offset localMousePos;

  _DeformableShapePainter({required this.config, required this.localMousePos});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = config.color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Helper to deform a point
    Offset deform(Offset p) {
      final delta = p - localMousePos;
      final dist = delta.distance;
      const effectRadius = 400.0; // Same as grid radius
      const strength = 50.0; 

      if (dist < effectRadius) {
         final factor = (1 - (dist / effectRadius)) * (1 - (dist / effectRadius)); 
         if (dist > 0) {
             final normalized = delta / dist;
             final displacement = min(factor * strength, dist * 0.8);
             return p - (normalized * displacement);
         }
      }
      return p;
    }

    // Generate vertices based on shape type
    List<Offset> vertices = [];
    
    if (config.type == ShapeType.circle) {
      const steps = 40;
      for (int i = 0; i < steps; i++) {
        final angle = (i / steps) * 2 * pi;
        final x = center.dx + radius * cos(angle);
        final y = center.dy + radius * sin(angle);
        vertices.add(deform(Offset(x, y)));
      }
    } else if (config.type == ShapeType.square) {
      const stepsPerSide = 10;
      // Top
      for (int i = 0; i < stepsPerSide; i++) vertices.add(deform(Offset((i/stepsPerSide)*size.width, 0)));
      // Right
      for (int i = 0; i < stepsPerSide; i++) vertices.add(deform(Offset(size.width, (i/stepsPerSide)*size.height)));
      // Bottom
      for (int i = 0; i < stepsPerSide; i++) vertices.add(deform(Offset(size.width - (i/stepsPerSide)*size.width, size.height)));
      // Left
      for (int i = 0; i < stepsPerSide; i++) vertices.add(deform(Offset(0, size.height - (i/stepsPerSide)*size.height)));

    } else if (config.type == ShapeType.triangle) {
      const stepsPerSide = 15;
      final p1 = Offset(size.width / 2, 0); // Top
      final p2 = Offset(size.width, size.height); // Bottom Right
      final p3 = Offset(0, size.height); // Bottom Left
      
      // P1 -> P2
      for (int i = 0; i < stepsPerSide; i++) {
         double t = i / stepsPerSide;
         vertices.add(deform(Offset.lerp(p1, p2, t)!));
      }
      // P2 -> P3
      for (int i = 0; i < stepsPerSide; i++) {
         double t = i / stepsPerSide;
         vertices.add(deform(Offset.lerp(p2, p3, t)!));
      }
      // P3 -> P1
      for (int i = 0; i < stepsPerSide; i++) {
         double t = i / stepsPerSide;
         vertices.add(deform(Offset.lerp(p3, p1, t)!));
      }
    }

    if (vertices.isNotEmpty) {
      path.moveTo(vertices[0].dx, vertices[0].dy);
      for (int i = 1; i < vertices.length; i++) {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DeformableShapePainter oldDelegate) {
    return oldDelegate.localMousePos != localMousePos || oldDelegate.config != config;
  }
}
