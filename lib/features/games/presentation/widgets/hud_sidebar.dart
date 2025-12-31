import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:engravedstudios/features/games/presentation/widgets/store_button.dart';
import 'package:engravedstudios/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class HudSidebar extends StatelessWidget {
  final GameModel game;
  const HudSidebar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: context.nbt.borderColor)),
        color: context.nbt.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / ID
          Text(
            "ARCHIVE_ID // ${game.id.toUpperCase()}",
            style: GameHUDTextStyles.terminalText.copyWith(
              color: GameHUDColors.ghostGray,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
             game.title.toUpperCase(),
             style: GameHUDTextStyles.titleLarge.copyWith(height: 1.0),
          ),
          const SizedBox(height: 8),
          
          // Genre
          Text(
            game.genre.toUpperCase(),
            style: GameHUDTextStyles.terminalText.copyWith(color: game.accentColor),
          ),

          const SizedBox(height: 32),
          
          // Technical Specs
          _buildSpecRow("STATUS", game.releaseStatus.name.toUpperCase()),
          _buildSpecRow("ENGINE", game.engine.toUpperCase()),
          _buildSpecRow("PLATFORM", game.platforms.join(" // ").toUpperCase()),
          
          const Spacer(),
          
          // Action Button (Placeholder)
          // Action Buttons
          if (game.steamAppId != null) ...[
            StoreButton(
              appId: game.steamAppId!,
              url: 'https://store.steampowered.com/app/${game.steamAppId}',
              label: "STEAM",
            ),
            const SizedBox(height: 12),
          ],
          if (game.itchUrl != null) ...[
             StoreButton(
              appId: '', // No API for Itch yet
              url: game.itchUrl!,
              label: "ITCH.IO",
              color: const Color(0xFFFA5C5C), // Itch Red
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.ghostGray)),
          Text(value, style: GameHUDTextStyles.terminalText),
        ],
      ),
    );
  }
}
