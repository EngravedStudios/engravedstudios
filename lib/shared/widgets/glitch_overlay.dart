import 'dart:math';

import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlitchOverlay extends ConsumerStatefulWidget {
  const GlitchOverlay({super.key});

  @override
  ConsumerState<GlitchOverlay> createState() => _GlitchOverlayState();
}

class _GlitchOverlayState extends ConsumerState<GlitchOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ThemeMode? _lastMode;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch logic
    ref.listen(themeControllerProvider, (previous, next) {
       if (previous != next) {
         _controller.forward();
       }
    });

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.value == 0) return const SizedBox.shrink();

        // Random glitch slices
        return IgnorePointer(
          child: Stack(
            children: [
              // Flash
              Opacity(
                opacity: (1 - _controller.value) * 0.5,
                child: Container(color: GameHUDColors.glitchRed),
              ),
              // Random bars
              if (_controller.value < 0.5)
                ...List.generate(5, (index) {
                  final top = _random.nextDouble() * MediaQuery.of(context).size.height;
                  final height = _random.nextDouble() * 50;
                  return Positioned(
                    top: top,
                    left: 0,
                    right: 0,
                    height: height,
                    child: Container(
                      color: index % 2 == 0 ? GameHUDColors.neonLime : GameHUDColors.hardBlack,
                    ),
                  );
                })
            ],
          ),
        );
      },
    );
  }
}
