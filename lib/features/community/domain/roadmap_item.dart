enum RoadmapStatus {
  planned,
  inProgress,
  completed,
  onHold,
}

class RoadmapItem {
  final String id;
  final String title;
  final String description;
  final RoadmapStatus status;
  final String eta; // e.g., "Q1 2025"
  final List<String> tags;

  const RoadmapItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.eta,
    this.tags = const [],
  });
}
