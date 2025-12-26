import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/studio/data/team_data.dart';
import 'package:engravedstudios/features/studio/presentation/blueprint_grid_painter.dart';
import 'package:engravedstudios/features/studio/presentation/widgets/team_card.dart';
import 'package:engravedstudios/features/studio/presentation/widgets/tech_sticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudioSection extends ConsumerWidget {
  const StudioSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamMembersProvider);
    
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          // Background: Blueprint Grid
          Positioned.fill(
            child: CustomPaint(
              painter: BlueprintGridPainter(),
            ),
          ),
          
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Manifesto
                  Text(
                    "THE FORGE",
                    style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.cyan),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "WE DON'T JUST BUILD GAMES.\nWE ENGRAVE EXPERIENCES\nINTO THE DIGITAL BEDROCK.",
                    textAlign: TextAlign.center,
                    style: GameHUDTextStyles.titleLarge.copyWith(
                      fontSize: 48,
                      height: 1.1,
                      color: Colors.transparent,
                      shadows: [],
                      decoration: TextDecoration.none,
                    ),
                  ).copyWith(foreground: Paint()..style = PaintingStyle.stroke ..strokeWidth = 2 ..color = GameHUDColors.hardBlack),
                  
                  const SizedBox(height: 80),
                  
                  // Team Scatter
                  Wrap(
                    spacing: 32,
                    runSpacing: 48,
                    alignment: WrapAlignment.center,
                    children: team.map((member) {
                      final angle = (member.name.length % 5) - 2.0; 
                      return TeamCard(member: member, angle: angle);
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Tech Stickers
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                         TechSticker(label: "FLUTTER", color: Color(0xFF54C5F8)),
                         SizedBox(width: 16),
                         TechSticker(label: "DART", color: Color(0xFF00B4AB)),
                         SizedBox(width: 16),
                         TechSticker(label: "BLENDER", color: Color(0xFFE87D0D)),
                         SizedBox(width: 16),
                         TechSticker(label: "VULKAN", color: Color(0xFFA80000)),
                         SizedBox(width: 16),
                         TechSticker(label: "RIVERPOD", color: Color(0xFF2D2D2D)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper to apply stroke to text
extension TextStyleStroke on Text {
  Text copyWith({Paint? foreground}) {
    return Text(
      data!,
      style: style?.copyWith(foreground: foreground),
      textAlign: textAlign,
    );
  }
}
