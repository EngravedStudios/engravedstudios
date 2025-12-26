class DevLogPost {
  final String id;
  final String title;
  final String category; // e.g., "ENGINE", "ART", "LOGIC"
  final DateTime timestamp;
  final String shortExcerpt;

  const DevLogPost({
    required this.id,
    required this.title,
    required this.category,
    required this.timestamp,
    required this.shortExcerpt,
  });
}
