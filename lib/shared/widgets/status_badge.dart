import 'dart:math';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final GameStatus status;
  final Color? colorOverride;

  const StatusBadge({super.key, required this.status, this.colorOverride});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;

    switch (status) {
      case GameStatus.concept:
        bg = GameHUDColors.ghostGray;
        label = "CONCEPT";
        break;
      case GameStatus.alpha:
        bg = colorOverride ?? GameHUDColors.neonLime;
        label = "ALPHA BUILD";
        break;
      case GameStatus.released:
        bg = colorOverride ?? GameHUDColors.cyan;
        label = "RELEASED";
        break;
    }

    // Tilted sticker look
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(width: 2, color: GameHUDColors.hardBlack),
          boxShadow: const [
            BoxShadow(
              color: GameHUDColors.hardBlack,
              offset: Offset(2, 2),
            )
          ]
        ),
        child: Text(
          label,
          style: GameHUDTextStyles.terminalText.copyWith(
            fontWeight: FontWeight.bold,
            color: GameHUDColors.hardBlack,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
