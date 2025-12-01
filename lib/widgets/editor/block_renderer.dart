import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post_block.dart';
import '../../domain/entities/blocks/text_block.dart';
import '../../domain/entities/blocks/image_block.dart';
import '../../domain/entities/blocks/video_block.dart';
import '../../domain/entities/blocks/divider_block.dart';
import '../../domain/entities/blocks/code_block.dart';
import 'renderers/text_block_renderer.dart';
import 'renderers/image_block_renderer.dart';
import 'renderers/video_block_renderer.dart';
import 'renderers/divider_block_renderer.dart';
import 'renderers/code_block_renderer.dart';

/// Factory widget that renders the appropriate widget for a given block type
/// 
/// This is the main entry point for block rendering. It routes blocks to
/// their specific renderer implementations.
class BlockRenderer extends ConsumerWidget {
  final PostBlock block;
  final bool isEditable;
  final VoidCallback? onDelete;
  final VoidCallback? onAddBlockAfter;
  final Function(PostBlock)? onUpdate;
  final bool isFocused;

  const BlockRenderer({
    super.key,
    required this.block,
    this.isEditable = true,
    this.onDelete,
    this.onAddBlockAfter,
    this.onUpdate,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Route to the appropriate renderer based on block type
    if (block is TextBlock) {
      return TextBlockRenderer(
        block: block as TextBlock,
        isEditable: isEditable,
        onDelete: onDelete,
        onAddBlockAfter: onAddBlockAfter,
        onUpdate: onUpdate != null ? (b) => onUpdate!(b) : null,
        isFocused: isFocused,
      );
    } else if (block is ImageBlock) {
      return ImageBlockRenderer(
        block: block as ImageBlock,
        isEditable: isEditable,
        onDelete: onDelete,
        onUpdate: onUpdate != null ? (b) => onUpdate!(b) : null,
      );
    } else if (block is VideoBlock) {
      return VideoBlockRenderer(
        block: block as VideoBlock,
        isEditable: isEditable,
        onDelete: onDelete,
        onUpdate: onUpdate != null ? (b) => onUpdate!(b) : null,
      );
    } else if (block is CodeBlock) {
      return CodeBlockRenderer(
        block: block as CodeBlock,
        isEditable: isEditable,
        onDelete: onDelete,
        onUpdate: onUpdate != null ? (b) => onUpdate!(b) : null,
      );
    } else if (block is DividerBlock) {
      return DividerBlockRenderer(
        block: block as DividerBlock,
        onDelete: onDelete,
      );
    }

    // Fallback for unknown block types
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text('Unknown block type: ${block.type}'),
    );
  }
}
