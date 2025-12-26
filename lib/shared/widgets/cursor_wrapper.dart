import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

/// High-performance cursor wrapper using direct ValueNotifiers
/// and a singleton controller to bypass Riverpod overhead.
class CursorWrapper extends StatefulWidget {
  final Widget child;
  const CursorWrapper({super.key, required this.child});

  @override
  State<CursorWrapper> createState() => _CursorWrapperState();
}

class _CursorWrapperState extends State<CursorWrapper> {
  final ValueNotifier<Offset> _position = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      // Use Listener instead of MouseRegion for lower overhead
      onPointerHover: (event) => _position.value = event.position,
      onPointerMove: (event) => _position.value = event.position,
      child: MouseRegion(
        cursor: SystemMouseCursors.none,
        child: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Main content - completely isolated from cursor updates
              RepaintBoundary(child: widget.child),
              // Cursor overlay - uses dedicated listenable builders
              _CursorOverlay(positionNotifier: _position),
            ],
          ),
        ),
      ),
    );
  }
}

class _CursorOverlay extends StatelessWidget {
  final ValueNotifier<Offset> positionNotifier;
  const _CursorOverlay({required this.positionNotifier});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([positionNotifier, CursorController.instance]),
      builder: (context, _) {
        final position = positionNotifier.value;
        final cursorType = CursorController.instance.type;
        final isHover = cursorType == CursorType.hover;
        final size = isHover ? 40.0 : 20.0;

        return Positioned(
          left: position.dx - size / 2,
          top: position.dy - size / 2,
          child: IgnorePointer(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: isHover 
                    ? GameHUDColors.neonLime.withOpacity(0.2) 
                    : Colors.transparent,
                border: Border.all(
                  color: isHover ? GameHUDColors.neonLime : GameHUDColors.hardBlack,
                  width: 2,
                ),
                shape: isHover ? BoxShape.rectangle : BoxShape.circle,
              ),
              child: isHover 
                  ? Center(child: Container(width: 4, height: 4, color: GameHUDColors.neonLime)) 
                  : null,
            ),
          ),
        );
      },
    );
  }
}

