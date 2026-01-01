import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:engravedstudios/features/studio/data/team_data.dart';
import 'package:engravedstudios/features/studio/presentation/blueprint_grid_painter.dart';
import 'package:engravedstudios/features/studio/presentation/widgets/team_card.dart';
import 'package:engravedstudios/features/studio/presentation/widgets/tech_sticker.dart';
import 'package:engravedstudios/shared/widgets/glitch_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudioSection extends ConsumerWidget {
  const StudioSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamMembersProvider);
    final nbt = context.nbt;
    
    final isMobile = ResponsiveUtils.isMobile(context);
    final manifestoFontSize = context.responsive<double>(32, 48, 40);

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
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Manifesto
                  GlitchText(
                    text: "THE FORGE",
                    triggerOnLoad: true,
                    style: GameHUDTextStyles.terminalText.copyWith(color: nbt.textColor),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "WE DON'T JUST BUILD GAMES.\nWE ENGRAVE EXPERIENCES\nINTO THE DIGITAL BEDROCK.",
                    textAlign: TextAlign.center,
                    style: GameHUDTextStyles.titleLarge.copyWith(
                      fontSize: manifestoFontSize,
                      height: 1.1,
                      color: Colors.transparent,
                      shadows: [],
                      decoration: TextDecoration.none,
                    ),
                  ).copyWith(foreground: Paint()..style = PaintingStyle.stroke ..strokeWidth = 2 ..color = nbt.textColor)
                   .animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                  
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
                  ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                  
                  const SizedBox(height: 80),
                  
                  // Tech Stickers
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         TechSticker(label: "UNREAL ENGINE", color: nbt.surface),
                         const SizedBox(width: 16),
                         TechSticker(label: "GODOT", color: nbt.surface),
                         const SizedBox(width: 16),
                         TechSticker(label: "BLENDER", color: nbt.surface),
                         const SizedBox(width: 16),
                        TechSticker(label: "SUBSTANCE PAINTER", color: nbt.surface),
                         const SizedBox(width: 16),
                         TechSticker(label: "DAVINCI RESOLVE", color: nbt.surface),
                      ],
                    ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
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
