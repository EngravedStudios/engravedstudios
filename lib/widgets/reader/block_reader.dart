import 'package:flutter/material.dart';
import '../../providers/editor/editor_state.dart';
import '../editor/block_renderer.dart';

class BlockReader extends StatelessWidget {
  final String contentJson;

  const BlockReader({
    super.key,
    required this.contentJson,
  });

  @override
  Widget build(BuildContext context) {
    // Parse JSON to EditorState (reusing logic)
    final editorState = EditorState.fromJson(contentJson);
    final blocks = editorState.blocks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: BlockRenderer(
            block: block,
            isEditable: false,
          ),
        );
      }).toList(),
    );
  }
}
