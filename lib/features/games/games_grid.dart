import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/shared/widgets/neubrutalist_game_card.dart';
import 'package:flutter/material.dart';

class GamesGrid extends StatelessWidget {
  const GamesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // "Asymmetrical" manually handled by SliverList for now for precise control, 
    // or we could use StaggeredGrid if we added the package. 
    // For simplicity and "canvas" feel, we'll use a SliverList with Rows containing different flex factors.

    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
           // Section Header
           Padding(
             padding: const EdgeInsets.only(bottom: 48.0),
             child: Row(
               children: [
                 Container(width: 20, height: 20, color: GameHUDColors.hardBlack),
                 const SizedBox(width: 12),
                 Text("DEPLOYED PROJECTS", style: GameHUDTextStyles.titleLarge),
               ],
             ),
           ),
           
           // Easy helper for spacing
           const SizedBox(height: GameHUDLayout.gridSpacing),

           // ROW 1: Asymmetrical (Large Left, Small Right)
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Expanded(
                 flex: 7, 
                 child: NeubrutalistGameCard(
                   title: "Heavens Fall",
                   subtitle: "Tactical RPG // v1.0.4",
                   child: Container(
                     color: Colors.grey[300], // Placeholder Image
                     child: const Center(child: Icon(Icons.shield, size: 64, color: GameHUDColors.hardBlack)),
                   ),
                 ),
               ),
               const SizedBox(width: GameHUDLayout.gridSpacing),
               // Spacer or empty block for that "whitespace" feel
               const Spacer(flex: 3), 
             ],
           ),

           const SizedBox(height: GameHUDLayout.gridSpacing * 2),

           // ROW 2: Asymmetrical (Small Left, Large Right)
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                const Spacer(flex: 2),
                const SizedBox(width: GameHUDLayout.gridSpacing),
                Expanded(
                 flex: 8, 
                 child: NeubrutalistGameCard(
                   title: "Mistbound",
                   subtitle: "Cyberpunk Shooter // Alpha",
                   child: Container(
                     color: GameHUDColors.cyan.withOpacity(0.5), // Placeholder
                     child: const Center(child: Icon(Icons.bolt, size: 64, color: GameHUDColors.hardBlack)),
                   ),
                 ),
               ),
             ],
           ),
           
           const SizedBox(height: GameHUDLayout.gridSpacing * 2),
        ]),
      ),
    );
  }
}
