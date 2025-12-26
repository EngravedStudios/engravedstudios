import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AchievementToast extends StatelessWidget {
  final String title;
  final String subtitle;

  const AchievementToast({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GameHUDColors.hardBlack,
        border: Border.all(width: 2, color: GameHUDColors.neonLime),
        boxShadow: [
          BoxShadow(
            color: GameHUDColors.neonLime.withOpacity(0.5),
            blurRadius: 10,
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: GameHUDColors.neonLime,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: GameHUDColors.hardBlack),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("ACHIEVEMENT UNLOCKED", style: GameHUDTextStyles.terminalText.copyWith(fontSize: 10, color: GameHUDColors.neonLime)),
                Text(title, style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 16, color: GameHUDColors.paperWhite)),
                Text(subtitle, style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.ghostGray)),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutBack).fadeIn();
  }
}
