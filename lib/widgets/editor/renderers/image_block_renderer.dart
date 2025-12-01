import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/blocks/image_block.dart';

class ImageBlockRenderer extends StatelessWidget {
  final ImageBlock block;
  final bool isEditable;
  final VoidCallback? onDelete;
  final Function(ImageBlock)? onUpdate;

  const ImageBlockRenderer({
    super.key,
    required this.block,
    this.isEditable = true,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget imageWidget;
    if (block.url.isEmpty) {
      imageWidget = Container(
        height: 200,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(
                'Add an image',
                style: GoogleFonts.spaceMono(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: block.aspectRatio ?? 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (block.blurHash != null)
                BlurHash(hash: block.blurHash!),
              Image.network(
                block.url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.errorContainer,
                    child: Center(
                      child: Icon(Icons.error_outline, color: colorScheme.error),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return MouseRegion(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              imageWidget,
              if (block.caption != null || isEditable) ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: block.caption,
                  enabled: isEditable,
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                    hintStyle: GoogleFonts.spaceMono(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    if (onUpdate != null) {
                      onUpdate!(block.copyWith(caption: value));
                    }
                  },
                ),
              ],
            ],
          ),
          if (isEditable && onDelete != null)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  color: colorScheme.error,
                  tooltip: 'Remove image',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
