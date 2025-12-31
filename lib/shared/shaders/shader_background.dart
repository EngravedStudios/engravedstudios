import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ShaderBackground extends StatefulWidget {
  final Widget? child;
  const ShaderBackground({super.key, this.child});

  @override
  State<ShaderBackground> createState() => _ShaderBackgroundState();
}

class _ShaderBackgroundState extends State<ShaderBackground> with SingleTickerProviderStateMixin {
  FragmentProgram? _program;
  late Ticker _ticker;
  double _time = 0.0;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      setState(() {
        _time = elapsed.inMilliseconds / 1000.0;
      });
    });
    _ticker.start();
  }

  Future<void> _loadShader() async {
    try {
       // Note: Verify the path matches pubspec.yaml
       _program = await FragmentProgram.fromAsset('assets/shaders/nebula.frag');
       if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Shader error: $e");
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_program == null) {
      // Fallback
      return Container(
        color: const Color(0xFF0F172A), 
        child: widget.child,
      );
    }

    return CustomPaint(
      painter: _ShaderPainter(_program!, _time),
      child: widget.child,
    );
  }
}

class _ShaderPainter extends CustomPainter {
  final FragmentProgram program;
  final double time;

  _ShaderPainter(this.program, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();
    // uSize (vec2) covers index 0, 1
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    // uTime (float) covers index 2
    shader.setFloat(2, time);
    
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant _ShaderPainter oldDelegate) => 
      oldDelegate.time != time || oldDelegate.program != program;
}
