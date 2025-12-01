import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/post_block.dart';
import '../../domain/entities/blocks/text_block.dart';
import '../../domain/entities/blocks/image_block.dart';
import '../../domain/entities/blocks/video_block.dart';
import '../../domain/entities/blocks/divider_block.dart';
import '../../domain/entities/blocks/code_block.dart';
import '../../domain/entities/block_type.dart';
import '../media_provider.dart';

part 'editor_state.g.dart';

/// State class representing the current editor content
@immutable
class EditorState {
  /// List of blocks in the editor
  final List<PostBlock> blocks;
  
  /// ID of the currently focused block (if any)
  final String? focusedBlockId;
  
  /// Whether the editor has unsaved changes
  final bool hasUnsavedChanges;

  const EditorState({
    required this.blocks,
    this.focusedBlockId,
    this.hasUnsavedChanges = false,
  });

  /// Create an empty editor state
  factory EditorState.empty() {
    const uuid = Uuid();
    return EditorState(
      blocks: [
        TextBlock.empty(uuid.v4()),
      ],
    );
  }

  /// Create editor state from JSON string (from database)
  factory EditorState.fromJson(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        return EditorState.empty();
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      final blocks = jsonList
          .map((blockJson) => PostBlock.fromJson(blockJson as Map<String, dynamic>))
          .toList();

      return EditorState(
        blocks: blocks.isEmpty ? [TextBlock.empty(const Uuid().v4())] : blocks,
      );
    } catch (e) {
      // If JSON parsing fails, treat as plain text and create single text block
      return EditorState(
        blocks: [
          TextBlock(
            id: const Uuid().v4(),
            type: BlockType.text,
            content: jsonString,
          ),
        ],
      );
    }
  }

  /// Convert editor state to JSON string for database storage
  String toJsonString() {
    final blocksList = blocks.map((block) => block.toJson()).toList();
    return json.encode(blocksList);
  }

  EditorState copyWith({
    List<PostBlock>? blocks,
    String? focusedBlockId,
    bool? hasUnsavedChanges,
  }) {
    return EditorState(
      blocks: blocks ?? this.blocks,
      focusedBlockId: focusedBlockId ?? this.focusedBlockId,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorState &&
          listEquals(blocks, other.blocks) &&
          focusedBlockId == other.focusedBlockId &&
          hasUnsavedChanges == other.hasUnsavedChanges;

  @override
  int get hashCode =>
      Object.hashAll(blocks) ^
      focusedBlockId.hashCode ^
      hasUnsavedChanges.hashCode;
}

/// Editor state notifier managing block operations
@riverpod
class EditorNotifier extends _$EditorNotifier {
  static const _uuid = Uuid();

  @override
  EditorState build() => EditorState.empty();

  /// Load content from JSON string
  void loadFromJson(String jsonString) {
    state = EditorState.fromJson(jsonString);
  }

  /// Get JSON string representation
  String toJsonString() {
    return state.toJsonString();
  }

  /// Add a new block at the specified index
  void addBlock(PostBlock block, {int? atIndex}) {
    final newBlocks = List<PostBlock>.from(state.blocks);
    if (atIndex != null && atIndex >= 0 && atIndex <= newBlocks.length) {
      newBlocks.insert(atIndex, block);
    } else {
      newBlocks.add(block);
    }
    state = state.copyWith(
      blocks: newBlocks,
      hasUnsavedChanges: true,
    );
  }

  /// Add a new text block with specific type
  void addTextBlock(BlockType type, {int? atIndex}) {
    addBlock(
      TextBlock(
        id: _uuid.v4(),
        type: type,
        content: '',
      ),
      atIndex: atIndex,
    );
  }

  /// Add a new empty text block after the specified block
  void addTextBlockAfter(String afterBlockId) {
    final index = state.blocks.indexWhere((b) => b.id == afterBlockId);
    if (index != -1) {
      addBlock(
        TextBlock.empty(_uuid.v4()),
        atIndex: index + 1,
      );
    }
  }

  /// Add a new image block with a URL and mediaId (after upload)
  void addImageBlockWithUrl(String url, {int? mediaId, int? atIndex}) {
    addBlock(
      ImageBlock(
        id: _uuid.v4(),
        url: url,
        mediaId: mediaId,
      ),
      atIndex: atIndex,
    );
  }

  /// Add a new video block with a URL and mediaId (after upload)
  void addVideoBlockWithUrl(String url, {int? mediaId, int? atIndex}) {
    addBlock(
      VideoBlock(
        id: _uuid.v4(),
        url: url,
        mediaId: mediaId,
      ),
      atIndex: atIndex,
    );
  }

  /// Add a new code block
  void addCodeBlock({String? language, int? atIndex}) {
    addBlock(
      CodeBlock(
        id: _uuid.v4(),
        code: '',
        language: language ?? 'dart',
      ),
      atIndex: atIndex,
    );
  }

  /// Add a new divider block
  void addDividerBlock({int? atIndex}) {
    addBlock(
      DividerBlock(id: _uuid.v4()),
      atIndex: atIndex,
    );
  }

  /// Remove a block by ID and delete associated media if present
  Future<void> removeBlock(String blockId) async {
    final block = state.blocks.firstWhere((b) => b.id == blockId);
    
    print('🗑️ Removing block: ${block.type} (id: $blockId)');
    
    // If it's an image or video block with mediaId, delete the media
    if (block is ImageBlock && block.mediaId != null) {
      print('🖼️ Image block has mediaId: ${block.mediaId}, deleting media...');
      try {
        await ref.read(mediaRepositoryProvider).deleteMedia(block.mediaId!);
        print('✅ Media deleted successfully: ${block.mediaId}');
      } catch (e, stack) {
        // Log error but don't prevent block deletion
        print('❌ Failed to delete media ${block.mediaId}: $e');
        print('Stack trace: $stack');
      }
    } else if (block is VideoBlock && block.mediaId != null) {
      print('🎥 Video block has mediaId: ${block.mediaId}, deleting media...');
      try {
        await ref.read(mediaRepositoryProvider).deleteMedia(block.mediaId!);
        print('✅ Media deleted successfully: ${block.mediaId}');
      } catch (e, stack) {
        // Log error but don't prevent block deletion
        print('❌ Failed to delete media ${block.mediaId}: $e');
        print('Stack trace: $stack');
      }
    } else {
      print('ℹ️ Block has no mediaId, skipping media deletion');
    }
    
    List<PostBlock> newBlocks = state.blocks.where((b) => b.id != blockId).toList();
    // Ensure at least one block remains
    if (newBlocks.isEmpty) {
      newBlocks.add(TextBlock.empty(_uuid.v4()));
    }
    state = state.copyWith(
      blocks: newBlocks,
      hasUnsavedChanges: true,
    );
  }

  /// Update an existing block
  void updateBlock(PostBlock updatedBlock) {
    final newBlocks = state.blocks.map((block) {
      return block.id == updatedBlock.id ? updatedBlock : block;
    }).toList();
    state = state.copyWith(
      blocks: newBlocks,
      hasUnsavedChanges: true,
    );
  }

  /// Reorder blocks (drag and drop support)
  void reorderBlocks(int oldIndex, int newIndex) {
    final newBlocks = List<PostBlock>.from(state.blocks);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final block = newBlocks.removeAt(oldIndex);
    newBlocks.insert(newIndex, block);
    state = state.copyWith(
      blocks: newBlocks,
      hasUnsavedChanges: true,
    );
  }

  /// Set focused block
  void setFocusedBlock(String? blockId) {
    state = state.copyWith(focusedBlockId: blockId);
  }

  /// Mark content as saved
  void markAsSaved() {
    state = state.copyWith(hasUnsavedChanges: false);
  }

  /// Clear all content
  void clear() {
    state = EditorState.empty();
  }
}
