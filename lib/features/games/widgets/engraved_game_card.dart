import 'package:engravedstudios/core/audio/sound_service.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/hoverable_mixin.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:engravedstudios/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EngravedGameCard extends ConsumerStatefulWidget {
  final GameModel game;

  const EngravedGameCard({super.key, required this.game});

  @override
  ConsumerState<EngravedGameCard> createState() => _EngravedGameCardState();
}

class _EngravedGameCardState extends ConsumerState<EngravedGameCard> with HoverableMixin {
  @override
  Widget build(BuildContext context) {
    // Shadow logic: 8 -> 12 on hover
    // Color logic: Grayscale -> Color on hover (using ColorFiltered)

    final nbt = context.nbt;
    final currentOffset = isHovered ? 12.0 : 8.0;

    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onTap: () {
          ref.read(soundServiceProvider).playTransition();
          context.go('/games/${widget.game.id}');
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Shadow Block
            Positioned.fill(
               child: Transform.translate(
                 offset: Offset(currentOffset, currentOffset),
                 child: Container(color: nbt.shadowColor),
               ),
            ),
            
            // Main Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.translationValues(
                isHovered ? -4 : 0, 
                isHovered ? -4 : 0, 
                0,
              ),
              decoration: BoxDecoration(
                color: nbt.surface,
                border: Border.all(color: nbt.textColor, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image / Content Area
                  Expanded(
                    flex: 3,
                    child: ColorFiltered(
                      colorFilter: isHovered 
                          ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                          : const ColorFilter.matrix(<double>[
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0,      0,      0,      1, 0,
                            ]),
                      child: Container(
                         color: widget.game.accentColor.withOpacity(0.3), // Fallback/Tint
                         child: Center(
                           child: Hero(
                             tag: 'game-icon-${widget.game.id}',
                             child: Icon(Icons.gamepad, size: 48, color: nbt.textColor),
                           ),
                         ),
                      ),
                    ),
                  ),
                  
                  // Info Area
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.game.title.toUpperCase(),
                            style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 20, color: nbt.textColor),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.game.genre.toUpperCase(),
                            style: GameHUDTextStyles.terminalText.copyWith(color: nbt.textColor.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Status Badge (Absolute)
            Positioned(
              top: -10,
              left: -10,
              child: StatusBadge(status: widget.game.releaseStatus, colorOverride: widget.game.accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
