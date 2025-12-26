import 'dart:async';
import 'dart:math';

import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const GlitchText(this.text, {super.key, required this.style});

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> with SingleTickerProviderStateMixin {
  late Timer _timer;
  bool _isGlitch = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scheduleGlitch();
  }

  void _scheduleGlitch() {
    _timer = Timer(Duration(seconds: 3 + _random.nextInt(5)), () {
      if (mounted) {
        setState(() => _isGlitch = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() => _isGlitch = false);
            _scheduleGlitch(); // Loop
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGlitch) {
      return Text(widget.text, style: widget.style);
    }

    // Glitch effect: RGB Split
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(2, 0),
          child: Text(widget.text, style: widget.style.copyWith(color: GameHUDColors.glitchRed)),
        ),
        Transform.translate(
          offset: const Offset(-2, 0),
          child: Text(widget.text, style: widget.style.copyWith(color: GameHUDColors.cyan)),
        ),
        Text(widget.text, style: widget.style),
      ],
    );
  }
}
