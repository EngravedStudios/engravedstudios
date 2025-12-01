import 'block_type.dart';
import 'blocks/text_block.dart';
import 'blocks/image_block.dart';
import 'blocks/video_block.dart';
import 'blocks/code_block.dart';
import 'blocks/divider_block.dart';

/// Abstract base class for all post content blocks
/// 
/// Each block represents a discrete piece of content (text, image, video, etc.)
/// that can be edited, reordered, and serialized to JSON for storage.
abstract class PostBlock {
  /// Unique identifier for this block instance
  final String id;
  
  /// Type of block (text, image, video, etc.)
  final BlockType type;

  const PostBlock({required this.id, required this.type});

  /// Convert block to JSON for database storage
  Map<String, dynamic> toJson();

  /// Factory method to create appropriate block type from JSON
  /// 
  /// This is the main deserialization entry point that routes to
  /// the correct block implementation based on the 'type' field.
  static PostBlock fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = BlockType.fromJson(typeStr);

    switch (type) {
      case BlockType.text:
      case BlockType.heading1:
      case BlockType.heading2:
      case BlockType.heading3:
      case BlockType.quote:
        return TextBlock.fromJson(json);
      
      case BlockType.image:
        return ImageBlock.fromJson(json);
      
      case BlockType.video:
        return VideoBlock.fromJson(json);
      
      case BlockType.code:
        return CodeBlock.fromJson(json);
      
      case BlockType.divider:
        return DividerBlock.fromJson(json);
    }
  }

  /// Create a copy of this block with updated fields
  PostBlock copyWith();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostBlock &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
