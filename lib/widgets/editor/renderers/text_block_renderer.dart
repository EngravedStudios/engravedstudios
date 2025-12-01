import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/blocks/text_block.dart';
import '../../../domain/entities/block_type.dart';

/// Renderer for text blocks with editable content and style switching
class TextBlockRenderer extends StatefulWidget {
  final TextBlock block;
  final bool isEditable;
  final VoidCallback? onDelete;
  final VoidCallback? onAddBlockAfter;
  final Function(TextBlock)? onUpdate;
  final bool isFocused;

  const TextBlockRenderer({
    super.key,
    required this.block,
    this.isEditable = true,
    this.onDelete,
    this.onAddBlockAfter,
    this.onUpdate,
    this.isFocused = false,
  });

  @override
  State<TextBlockRenderer> createState() => _TextBlockRendererState();
}

class _TextBlockRendererState extends State<TextBlockRenderer> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.content);
    _focusNode = FocusNode();
    
    if (widget.isFocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(TextBlockRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.content != _controller.text) {
      _controller.text = widget.block.content;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateContent() {
    if (widget.onUpdate != null) {
      widget.onUpdate!(widget.block.copyWith(content: _controller.text));
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.block.type) {
      case BlockType.heading1:
        return GoogleFonts.merriweather(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        );
      case BlockType.heading2:
        return GoogleFonts.merriweather(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        );
      case BlockType.heading3:
        return GoogleFonts.merriweather(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        );
      case BlockType.quote:
        return GoogleFonts.merriweather(
          fontSize: 18,
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface.withValues(alpha: 0.8),
          height: 1.6,
        );
      case BlockType.text:
      default:
        return GoogleFonts.merriweather(
          fontSize: 16,
          color: colorScheme.onSurface,
          height: 1.6,
        );
    }
  }

  String _getPlaceholder() {
    switch (widget.block.type) {
      case BlockType.heading1:
        return 'Heading 1';
      case BlockType.heading2:
        return 'Heading 2';
      case BlockType.heading3:
        return 'Heading 3';
      case BlockType.quote:
        return 'Quote...';
      case BlockType.text:
      default:
        return 'Type \'/\' for commands...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.isEditable,
      maxLines: null,
      style: _getTextStyle(context),
      decoration: InputDecoration(
        hintText: _getPlaceholder(),
        hintStyle: _getTextStyle(context).copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          vertical: widget.block.type == BlockType.text ? 8 : 12,
          horizontal: widget.block.type == BlockType.quote ? 16 : 0,
        ),
      ),
      onChanged: (_) => _updateContent(),
      onSubmitted: (_) {
        if (widget.onAddBlockAfter != null) {
          widget.onAddBlockAfter!();
        }
      },
    );

    // Add quote border if it's a quote block
    if (widget.block.type == BlockType.quote) {
      textField = Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colorScheme.primary,
              width: 4,
            ),
          ),
        ),
        child: textField,
      );
    }

    // Wrap in hover menu container if editable
    if (widget.isEditable) {
      return MouseRegion(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Opacity(
              opacity: 0.3,
              child: IconButton(
                icon: const Icon(Icons.drag_indicator, size: 20),
                onPressed: null,
                padding: const EdgeInsets.all(4),
              ),
            ),
            // Text content
            Expanded(child: textField),
            // Action buttons
            if (widget.onDelete != null)
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20),
                onPressed: widget.onDelete,
                color: colorScheme.error,
                padding: const EdgeInsets.all(4),
              ),
          ],
        ),
      );
    }

    return textField;
  }
}
