import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:flutter/material.dart';

class ProjectDepo extends StatelessWidget {
  final GameModel game;
  const ProjectDepo({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [        // Description Block
        Text(
          "MISSION BRIEFING",
          style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.neonLime),
        ),
        const SizedBox(height: 16),
        Text(
          game.description,
          style: GameHUDTextStyles.bodyText.copyWith(fontSize: 18, height: 1.6),
        ),
        
        const SizedBox(height: 64),

        // Gallery Placeholder (Parallax later)
        if (game.images.isNotEmpty) ...[
           SizedBox(
             height: 400,
             child: ListView.separated(
               scrollDirection: Axis.horizontal,
               itemCount: game.images.length,
               separatorBuilder: (c, i) => const SizedBox(width: 24),
               itemBuilder: (context, index) {
                 return Container(
                   width: 600,
                   color: Colors.grey[900],
                   alignment: Alignment.center,
                   child: Text("IMG_0${index+1}"),
                 );
               },
             ),
           ),
           const SizedBox(height: 64),
        ],

        // Tech Stack
        Text(
          "TECH_STACK_MATRIX",
          style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.neonLime),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: game.techStack.map((tech) => 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: context.nbt.textColor.withOpacity(0.3)),
              ),
              child: Text(tech.toUpperCase(), style: GameHUDTextStyles.terminalText),
            )
          ).toList(),
        ),

        const SizedBox(height: 64),

        // Latest Commits / DevLogs (Placeholder)
         Text(
          "LATEST_COMMITS",
          style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.neonLime),
        ),
        const SizedBox(height: 24),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: context.nbt.surface,
            border: Border.all(color: context.nbt.borderColor),
          ),
          alignment: Alignment.center,
          child: Text("NO RECENT TRANSMISSIONS FOUND", style: GameHUDTextStyles.codeText),
        ),

        const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ],
    );
  }
}
