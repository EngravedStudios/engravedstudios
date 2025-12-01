import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/block_type.dart';

class AddBlockMenu extends ConsumerWidget {
  final Function(BlockType) onSelected;

  const AddBlockMenu({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Add Block',
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.text_fields,
            label: 'Text',
            onTap: () => onSelected(BlockType.text),
          ),
          _MenuItem(
            icon: Icons.title,
            label: 'Heading 1',
            onTap: () => onSelected(BlockType.heading1),
          ),
          _MenuItem(
            icon: Icons.title,
            label: 'Heading 2',
            iconSize: 20,
            onTap: () => onSelected(BlockType.heading2),
          ),
          _MenuItem(
            icon: Icons.format_quote,
            label: 'Quote',
            onTap: () => onSelected(BlockType.quote),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.image_outlined,
            label: 'Image',
            onTap: () => onSelected(BlockType.image),
          ),
          _MenuItem(
            icon: Icons.video_library_outlined,
            label: 'Video',
            onTap: () => onSelected(BlockType.video),
          ),
          _MenuItem(
            icon: Icons.code,
            label: 'Code',
            onTap: () => onSelected(BlockType.code),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.horizontal_rule,
            label: 'Divider',
            onTap: () => onSelected(BlockType.divider),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: iconSize, color: colorScheme.onSurface),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
