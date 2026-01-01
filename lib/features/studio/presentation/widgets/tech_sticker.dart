import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/hoverable_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TechSticker extends ConsumerStatefulWidget {
  final String label;
  final Color color;

  const TechSticker({super.key, required this.label, required this.color});

  @override
  ConsumerState<TechSticker> createState() => _TechStickerState();
}

class _TechStickerState extends ConsumerState<TechSticker> with HoverableMixin {
  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      cursor: SystemMouseCursors.none,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
           ..rotateZ(isHovered ? -0.1 : 0) // Peel
           ..translate(0.0, isHovered ? -4.0 : 0.0), // Lift
           
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: widget.color, // Sticker color is explicit? Or theme dependent?
          // Requirement: "TechSticker... use Theme.of". But TechSticker passes specific colors (like yellow, blue).
          // If the colors passed are static, we might want to check the parent.
          // For now, retaining explicitly passed sticker color, but replacing border/shadow.
          border: Border.all(width: 2, color: nbt.borderColor),
          borderRadius: BorderRadius.circular(50), 
          boxShadow: [
            BoxShadow(
              color: nbt.shadowColor.withValues(alpha: 0.5),
              offset: isHovered ? const Offset(4, 8) : const Offset(2, 2),
              blurRadius: 0,
            )
          ],
        ),
        child: Text(
          widget.label,
          style: GameHUDTextStyles.terminalText.copyWith(
            fontWeight: FontWeight.bold,
            color: nbt.primaryAccent, // Sticker text usually black/dark on color
          ),
        ),
      ),
    );
  }
}
