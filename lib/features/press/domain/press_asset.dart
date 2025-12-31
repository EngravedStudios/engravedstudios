
enum PressAssetType {
  logo,
  screenshot,
  art,
  document,
}

class PressAsset {
  final String id;
  final String title;
  final String description;
  final String assetUrl;
  final String? thumbnailUrl;
  final PressAssetType type;
  // Size in bytes, optional for display
  final int? sizeBytes;

  const PressAsset({
    required this.id,
    required this.title,
    required this.description,
    required this.assetUrl,
    this.thumbnailUrl,
    required this.type,
    this.sizeBytes,
  });

  // Helper to check if it's an image for preview
  bool get isImage => type == PressAssetType.logo || type == PressAssetType.screenshot || type == PressAssetType.art;
}
