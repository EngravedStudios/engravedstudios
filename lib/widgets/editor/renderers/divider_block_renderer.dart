import 'package:flutter/material.dart';
import '../../../domain/entities/blocks/divider_block.dart';

class DividerBlockRenderer extends StatelessWidget {
  final DividerBlock block;
  final VoidCallback? onDelete;

  const DividerBlockRenderer({
    super.key,
    required this.block,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 24,
            alignment: Alignment.center,
            child: Divider(
              color: colorScheme.outlineVariant,
              thickness: 1,
            ),
          ),
          if (onDelete != null)
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, size: 16, color: colorScheme.onSurfaceVariant),
                onPressed: onDelete,
                tooltip: 'Remove divider',
              ),
            ),
        ],
      ),
    );
  }
}
