import '../block_type.dart';
import '../post_block.dart';

/// Divider block representing a horizontal line separator
/// 
/// Simple visual separator between content sections.
class DividerBlock extends PostBlock {
  const DividerBlock({
    required super.id,
  }) : super(type: BlockType.divider);

  /// Create from JSON representation
  factory DividerBlock.fromJson(Map<String, dynamic> json) {
    return DividerBlock(
      id: json['id'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
    };
  }

  @override
  DividerBlock copyWith({String? id}) {
    return DividerBlock(
      id: id ?? this.id,
    );
  }
}
