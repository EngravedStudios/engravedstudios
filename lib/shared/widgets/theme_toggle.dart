import 'dart:math';

import 'package:engravedstudios/core/audio/sound_service.dart';
import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerStatefulWidget {
  const ThemeToggle({super.key});

  @override
  ConsumerState<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends ConsumerState<ThemeToggle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       vsync: this, 
       duration: const Duration(milliseconds: 400),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    ref.read(soundServiceProvider).playGlitch();
    
    // Animate rotation
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    // Toggle Theme
    ref.read(themeControllerProvider.notifier).toggle();
  }

  @override
  Widget build(BuildContext context) {
    // Current Theme State
    final mode = ref.watch(themeControllerProvider);
    final isDark = mode == ThemeMode.dark;
    final nbt = context.nbt; // Dynamic access

    return MouseRegion(
      onEnter: (_) => CursorController.instance.setHover(),
      onExit: (_) => CursorController.instance.setDefault(),
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          transform: Matrix4.translationValues(
              _isPressed ? 2 : 0, 
              _isPressed ? 2 : 0, 
              0,
          ),
          decoration: BoxDecoration(
            color: nbt.surface,
            border: Border.all(width: 3, color: nbt.borderColor),
            boxShadow: _isPressed 
              ? [] 
              : [BoxShadow(color: nbt.shadowColor, offset: const Offset(4, 4))],
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
               return Transform.rotate(
                 angle: _controller.value * pi,
                 child: Icon(
                   isDark ? Icons.light_mode : Icons.dark_mode_outlined, // Icon represents target or current?
                   // Usually showing "Moon" means "Click for Dark". Showing "Sun" means "Click for Light".
                   // Let's assume icon reflects CURRENT state for clarity in toggle, or potential action.
                   // Let's do: Show SUN in Dark Mode, Show MOON in Light Mode.
                   color: nbt.primaryAccent,
                   size: 24,
                 ),
               );
            },
          ),
        ),
      ),
    );
  }
}
