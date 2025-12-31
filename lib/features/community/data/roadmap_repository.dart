import 'package:engravedstudios/features/community/domain/roadmap_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoadmapRepository {
  List<RoadmapItem> getRoadmap() {
    return const [
      RoadmapItem(
        id: '1',
        title: "VOIDFALL: ALPHA PROTOCOL",
        description: "Initial public testing phase for the core extraction loop.",
        status: RoadmapStatus.inProgress,
        eta: "Q1 2025",
        tags: ["Game Dev", "Multiplayer"],
      ),
      RoadmapItem(
        id: '2',
        title: "STUDIO WEBSITE: PHASE 2",
        description: "Implementing 'Game Juice', interactive shaders, and community features.",
        status: RoadmapStatus.completed,
        eta: "Q4 2024",
        tags: ["Web", "Design"],
      ),
      RoadmapItem(
        id: '3',
        title: "HEAVENS FALL: COMBAT PROTOTYPE",
        description: "Refining the soulslike combat mechanics and enemy AI.",
        status: RoadmapStatus.planned,
        eta: "Q2 2025",
        tags: ["Game Dev", "AI"],
      ),
      RoadmapItem(
        id: '4',
        title: "COMMUNITY HUB LAUNCH",
        description: "Integration of Discord and forum systems directly into the site.",
        status: RoadmapStatus.planned,
        eta: "Q2 2025",
        tags: ["Community", "Web"],
      ),
      RoadmapItem(
        id: '5',
        title: "MERCH STORE",
        description: "Official Engraved Studios appetite apparel drop.",
        status: RoadmapStatus.onHold,
        eta: "TBA",
        tags: ["Merch"],
      ),
    ];
  }
}

final roadmapRepositoryProvider = Provider<RoadmapRepository>((ref) {
  return RoadmapRepository();
});
