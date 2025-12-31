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
      onEnter: (_) {
        setState(() {}); // Rebuild for hover state if we tracked it, but we can rely on AnimatedContainer if using a local var. 
        // Oh wait, ThemeToggle doesn't track hover state in a variable. Let's add it.
        CursorController.instance.setHover();
      },
      onExit: (_) {
        CursorController.instance.setDefault();
      },
      // We need to track hover state locally for the animation logic
      // Let's wrap in HoverableMixin-like logic or just add a bool. 
      // Since we can't easily add a mixin to an existing State class without changing the file structure significantly,
      // let's just use MouseRegion's onEnter/Exit with a local state variable.
      child: _ThemeToggleBtn(
        onTap: _onTap, 
        isDark: isDark, 
        controller: _controller
      ),
    );
  }
}

class _ThemeToggleBtn extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;
  final AnimationController controller;

  const _ThemeToggleBtn({
    required this.onTap, 
    required this.isDark,
    required this.controller,
  });

  @override
  State<_ThemeToggleBtn> createState() => _ThemeToggleBtnState();
}

class _ThemeToggleBtnState extends State<_ThemeToggleBtn> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    
    // Logic matching NeubrutalistSquare
    double translateX = 0;
    double translateY = 0;
    double shadowX = 4; // Base shadow
    double shadowY = 4;

    if (_isPressed) {
       translateX = 0;
       translateY = 0;
       shadowX = 0;
       shadowY = 0;
    } else if (_isHovered) {
       translateX = -4; 
       translateY = -4; 
       shadowX = 10; // 4 (base) + 6 (pop)
       shadowY = 10;
    } else {
       // Idle
       translateX = 0;
       translateY = 0;
       shadowX = 4;
       shadowY = 4;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          transform: Matrix4.translationValues(translateX, translateY, 0),
          decoration: BoxDecoration(
            color: nbt.surface,
            border: Border.all(width: 3, color: nbt.borderColor),
            boxShadow: [
              BoxShadow(
                color: nbt.shadowColor, 
                offset: Offset(shadowX, shadowY),
                blurRadius: 0
              )
            ],
          ),
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
               return Transform.rotate(
                 angle: widget.controller.value * pi,
                 child: Icon(
                   widget.isDark ? Icons.light_mode : Icons.dark_mode_outlined,
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
