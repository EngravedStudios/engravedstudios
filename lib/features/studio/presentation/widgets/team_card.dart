import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/hoverable_mixin.dart';
import 'package:engravedstudios/features/studio/domain/team_model.dart';
import 'package:engravedstudios/features/studio/presentation/widgets/stat_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamCard extends ConsumerStatefulWidget {
  final TeamMember member;
  final double angle; // Random rotation angle

  const TeamCard({super.key, required this.member, this.angle = 0});

  @override
  ConsumerState<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends ConsumerState<TeamCard> with HoverableMixin {
  bool _showSecret = false;
  
  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    // Hover scale logic
    final transform = Matrix4.identity()
      ..rotateZ(widget.angle * 3.14159 / 180)
      ..scale(isHovered ? 1.05 : 1.0);

    return MouseRegion(
      onEnter: (e) {
        onEnter(e);
        // Start "Secret" timer
        Future.delayed(const Duration(seconds: 2), () {
          if (isHovered && mounted) {
            setState(() => _showSecret = true);
          }
        });
      },
      onExit: (e) {
        onExit(e);
        setState(() => _showSecret = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: transform,
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: nbt.surface,
          border: Border.all(width: 4, color: nbt.borderColor),
          boxShadow: [
            BoxShadow(color: nbt.shadowColor, offset: const Offset(8, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Placeholder
            Container(
              height: 150,
              width: double.infinity,
              color: nbt.borderColor.withOpacity(0.1),
              child: Stack(
                children: [
                   Center(child: Icon(Icons.person, size: 64, color: nbt.textColor)),
                   if (_showSecret)
                     Container(
                       color: GameHUDColors.glitchRed.withOpacity(0.9), // Keep glitch red for secret
                       alignment: Alignment.center,
                       child: Text(
                         "SECRET UNLOCKED",
                         style: GameHUDTextStyles.terminalText.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                       ),
                     ).animate().shake(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Name & Role
            Text(
              widget.member.name,
              style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 18, color: nbt.textColor),
            ),
            Text(
              widget.member.role,
              style: GameHUDTextStyles.terminalText.copyWith(color: nbt.textColor.withOpacity(0.6)),
            ),
            
            Divider(color: nbt.borderColor, thickness: 2, height: 24),
            
            // Stats or Secret
            if (_showSecret)
              Text(
                widget.member.secretTrait,
                style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.glitchRed, fontWeight: FontWeight.bold),
              ).animate().shimmer()
            else
              ...widget.member.stats.entries.map((e) =>  Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: StatBar(label: e.key, value: e.value),
              )),
          ],
        ),
      ),
    );
  }
}
