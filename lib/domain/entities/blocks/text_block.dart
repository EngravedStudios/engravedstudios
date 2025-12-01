import '../block_type.dart';
import '../post_block.dart';

/// Text block supporting various text styles (paragraph, headings, quotes)
/// 
/// This is the most common block type, used for all text content.
/// Supports different styling through the BlockType (text, heading1-3, quote).
class TextBlock extends PostBlock {
  /// The actual text content
  final String content;
  
  /// Optional text alignment (left, center, right)
  final TextAlignment alignment;

  const TextBlock({
    required super.id,
    required super.type,
    required this.content,
    this.alignment = TextAlignment.left,
  }) : assert(
         type == BlockType.text ||
         type == BlockType.heading1 ||
         type == BlockType.heading2 ||
         type == BlockType.heading3 ||
         type == BlockType.quote,
         'TextBlock must use a text-based BlockType'
       );

  /// Create a default empty text block
  factory TextBlock.empty(String id) {
    return TextBlock(
      id: id,
      type: BlockType.text,
      content: '',
    );
  }

  /// Create from JSON representation
  factory TextBlock.fromJson(Map<String, dynamic> json) {
    return TextBlock(
      id: json['id'] as String,
      type: BlockType.fromJson(json['type'] as String),
      content: json['content'] as String? ?? '',
      alignment: TextAlignment.fromJson(json['alignment'] as String?),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'content': content,
      'alignment': alignment.toJson(),
    };
  }

  @override
  TextBlock copyWith({
    String? id,
    BlockType? type,
    String? content,
    TextAlignment? alignment,
  }) {
    return TextBlock(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is TextBlock &&
          content == other.content &&
          alignment == other.alignment;

  @override
  int get hashCode => super.hashCode ^ content.hashCode ^ alignment.hashCode;
}

/// Text alignment options for text blocks
enum TextAlignment {
  left,
  center,
  right;

  String toJson() => name;

  static TextAlignment fromJson(String? value) {
    if (value == null) return TextAlignment.left;
    return TextAlignment.values.firstWhere(
      (a) => a.name == value,
      orElse: () => TextAlignment.left,
    );
  }
}
