import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/editor/editor_state.dart';
import '../../providers/media_provider.dart';

import '../../domain/entities/block_type.dart';
import 'block_renderer.dart';
import 'add_block_menu.dart';

class BlockEditorView extends ConsumerStatefulWidget {
  const BlockEditorView({super.key});

  @override
  ConsumerState<BlockEditorView> createState() => _BlockEditorViewState();
}

class _BlockEditorViewState extends ConsumerState<BlockEditorView> {
  final ScrollController _scrollController = ScrollController();

  void _showAddBlockMenu(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AddBlockMenu(
          onSelected: (type) {
            Navigator.of(context).pop();
            _addBlock(type, index);
          },
        ),
      ),
    );
  }

  void _addBlock(BlockType type, int index) async {
    final notifier = ref.read(editorNotifierProvider.notifier);
    final uploadUseCase = ref.read(uploadMediaUseCaseProvider);
    switch (type) {
      case BlockType.text:
      case BlockType.heading1:
      case BlockType.heading2:
      case BlockType.heading3:
      case BlockType.quote:
        notifier.addTextBlock(type, atIndex: index);
        break;
      case BlockType.image:
        try {
          // Pick image file
          final result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            withData: true,
          );
          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            if (file.bytes == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to read file data')),
                );
              }
              return;
            }
            
            // Show loading indicator
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Uploading image...')),
              );
            }
            
            final mime = 'image/${file.extension ?? "jpg"}';
            final media = await uploadUseCase(file.bytes!, file.name, mime);
            
            // Add image block with uploaded URL and mediaId
            notifier.addImageBlockWithUrl(
              media.fileUrl, 
              mediaId: media.mediaId,
              atIndex: index,
            );
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image uploaded successfully!')),
              );
            }
          }
        } catch (e, stack) {
          print('Error uploading image: $e');
          print('Stack trace: $stack');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload image: $e')),
            );
          }
        }
        break;
      case BlockType.video:
        try {
          // Pick video file
          final result = await FilePicker.platform.pickFiles(
            type: FileType.video,
            withData: true,
          );
          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            if (file.bytes == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to read file data')),
                );
              }
              return;
            }
            
            // Show loading indicator
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Uploading video...')),
              );
            }
            
            final mime = 'video/${file.extension ?? "mp4"}';
            final media = await uploadUseCase(file.bytes!, file.name, mime);
            
            // Add video block with uploaded URL and mediaId
            notifier.addVideoBlockWithUrl(
              media.fileUrl,
              mediaId: media.mediaId,
              atIndex: index,
            );
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video uploaded successfully!')),
              );
            }
          }
        } catch (e, stack) {
          print('Error uploading video: $e');
          print('Stack trace: $stack');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload video: $e')),
            );
          }
        }
        break;
      case BlockType.code:
        notifier.addCodeBlock(atIndex: index);
        break;
      case BlockType.divider:
        notifier.addDividerBlock(atIndex: index);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorNotifierProvider);
    final blocks = editorState.blocks;

    return ReorderableListView.builder(
      scrollController: _scrollController,
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: blocks.length,
      onReorder: (oldIndex, newIndex) {
        ref.read(editorNotifierProvider.notifier).reorderBlocks(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final block = blocks[index];
        return Padding(
          key: ValueKey(block.id),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle & Add Button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.drag_indicator, size: 20, color: Colors.grey),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () => _showAddBlockMenu(context, index + 1),
                      color: Colors.grey,
                      tooltip: 'Add block below',
                    ),
                  ],
                ),
              ),
              
              // Block Content
              Expanded(
                child: BlockRenderer(
                  block: block,
                  isEditable: true,
                  isFocused: editorState.focusedBlockId == block.id,
                  onDelete: () async {
                    await ref.read(editorNotifierProvider.notifier).removeBlock(block.id);
                  },
                  onUpdate: (updatedBlock) {
                    ref.read(editorNotifierProvider.notifier).updateBlock(updatedBlock);
                  },
                  onAddBlockAfter: () {
                    ref.read(editorNotifierProvider.notifier).addTextBlockAfter(block.id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


