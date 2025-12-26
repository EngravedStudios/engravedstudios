import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/hoverable_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NeubrutalistSquare extends ConsumerStatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const NeubrutalistSquare({super.key, required this.icon, this.onTap});

  @override
  ConsumerState<NeubrutalistSquare> createState() => _NeubrutalistSquareState();
}

class _NeubrutalistSquareState extends ConsumerState<NeubrutalistSquare> with HoverableMixin {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 48,
          height: 48,
          transform: Matrix4.translationValues(
              isHovered ? -4 : 0, 
              isHovered ? -4 : 0, 
              0
          ),
          decoration: BoxDecoration(
            color: GameHUDColors.paperWhite,
            border: Border.all(width: 3, color: GameHUDColors.hardBlack),
            boxShadow: [
              BoxShadow(
                color: GameHUDColors.hardBlack,
                offset: isHovered ? const Offset(6, 6) : const Offset(0, 0), // Pop on hover
                blurRadius: 0,
              )
            ]
          ),
          child: Icon(widget.icon, color: GameHUDColors.hardBlack),
        ),
      ),
    );
  }
}
