import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/community/data/roadmap_repository.dart';
import 'package:engravedstudios/features/community/domain/roadmap_item.dart';
import 'package:engravedstudios/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoadmapPage extends ConsumerWidget {
  const RoadmapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmap = ref.watch(roadmapRepositoryProvider).getRoadmap();
    final nbt = context.nbt;
    
    // Group by status? Or just list? 
    // Let's do a vertical timeline-ish list.

    return Scaffold(
      backgroundColor: nbt.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  "DEVELOPMENT_LOG // ROADMAP", 
                  style: GameHUDTextStyles.headlineHeavy,
                ).animate().fadeIn().slideY(begin: -0.2),
                const SizedBox(height: 16),
                Text(
                  "Following the signal into the future.",
                  style: GameHUDTextStyles.terminalText.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 24),
                
                // Discord Widget / Button
                InkWell(
                  onTap: () {
                    // Open Discord Link
                    // launchUrl(Uri.parse("https://discord.gg/engravedstudios"));
                  },
                  child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                     decoration: BoxDecoration(
                       color: const Color(0xFF5865F2), // Discord Blurple
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         const Icon(Icons.discord, color: Colors.white),
                         const SizedBox(width: 12),
                         Text(
                           "JOIN COMMUNICATION UPLINK", 
                           style: GameHUDTextStyles.buttonText.copyWith(color: Colors.white)
                         ),
                       ],
                     ),
                  ),
                ),

                const SizedBox(height: 48),

                // Roadmap Items
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: roadmap.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 32),
                  itemBuilder: (context, index) {
                    return _RoadmapItemCard(item: roadmap[index]);
                  },
                ),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoadmapItemCard extends StatelessWidget {
  final RoadmapItem item;
  const _RoadmapItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;

    Color statusColor;
    switch(item.status) {
      case RoadmapStatus.completed: statusColor = GameHUDColors.neonLime; break;
      case RoadmapStatus.inProgress: statusColor = GameHUDColors.cyan; break;
      case RoadmapStatus.planned: statusColor = GameHUDColors.ghostGray; break;
      case RoadmapStatus.onHold: statusColor = GameHUDColors.glitchRed; break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: nbt.surface,
        border: Border(
          left: BorderSide(width: 4, color: statusColor),
          top: BorderSide(width: 1, color: nbt.borderColor),
          right: BorderSide(width: 1, color: nbt.borderColor),
          bottom: BorderSide(width: 1, color: nbt.borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: statusColor.withOpacity(0.1),
                child: Text(
                  item.status.name.toUpperCase(),
                  style: GameHUDTextStyles.codeText.copyWith(
                    color: statusColor, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              // ETA
              Text(
                "ETA: ${item.eta}",
                style: GameHUDTextStyles.codeText.copyWith(color: nbt.textColor.withOpacity(0.6)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            item.description,
            style: GameHUDTextStyles.bodyText.copyWith(color: nbt.textColor.withOpacity(0.8)),
          ),
          const SizedBox(height: 16),
          // Tags
          Wrap(
            spacing: 8,
            children: item.tags.map((tag) => Text(
              "#${tag.toUpperCase()}", 
              style: GameHUDTextStyles.codeText.copyWith(
                fontSize: 10, 
                color: nbt.primaryAccent
              )
            )).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1);
  }
}
