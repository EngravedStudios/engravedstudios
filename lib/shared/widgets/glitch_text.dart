import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that displays text with a glitch effect (RGB split + letter scramble).
/// Trigger modes: onLoad, onHover (controlled externally via `trigger`)
class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool triggerOnLoad;
  final bool isGlitching; // External trigger for hover

  const GlitchText({
    super.key,
    required this.text,
    this.style,
    this.triggerOnLoad = false,
    this.isGlitching = false,
  });

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> with SingleTickerProviderStateMixin {
  late String _displayText;
  bool _showGlitch = false;
  Timer? _glitchTimer;
  Timer? _scrambleTimer;
  final Random _random = Random();
  
  static const _glitchChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#\$%&*!?';

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
    if (widget.triggerOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _triggerGlitch());
    }
  }

  @override
  void didUpdateWidget(GlitchText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGlitching && !oldWidget.isGlitching) {
      _triggerGlitch();
    }
    if (widget.text != oldWidget.text) {
      _displayText = widget.text;
    }
  }

  void _triggerGlitch() {
    if (_showGlitch) return;
    
    setState(() => _showGlitch = true);
    
    // Scramble letters
    int scrambleCount = 0;
    _scrambleTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (scrambleCount >= 6) {
        timer.cancel();
        setState(() => _displayText = widget.text);
        return;
      }
      setState(() {
        _displayText = widget.text.split('').map((char) {
          if (char == ' ') return char;
          return _random.nextBool() ? _glitchChars[_random.nextInt(_glitchChars.length)] : char;
        }).join();
      });
      scrambleCount++;
    });
    
    // End glitch after duration
    _glitchTimer = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _showGlitch = false;
        _displayText = widget.text;
      });
    });
  }

  @override
  void dispose() {
    _glitchTimer?.cancel();
    _scrambleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showGlitch) {
      return Text(_displayText, style: widget.style);
    }

    // Simplified Glitch: Just text scramble, no RGB split
    return Text(_displayText, style: widget.style);
  }
}
