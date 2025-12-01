/// Enum representing all supported block types in the editor
enum BlockType {
  text,
  image,
  video,
  heading1,
  heading2,
  heading3,
  quote,
  code,
  divider;

  /// Convert enum to string for JSON serialization
  String toJson() => name;

  /// Create enum from string for JSON deserialization
  static BlockType fromJson(String value) {
    return BlockType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => BlockType.text,
    );
  }
}
