import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/hoverable_mixin.dart';
import 'package:engravedstudios/features/devlog/domain/dev_log_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DevLogEntryCard extends ConsumerStatefulWidget {
  final DevLogPost post;
  const DevLogEntryCard({super.key, required this.post});

  @override
  ConsumerState<DevLogEntryCard> createState() => _DevLogEntryCardState();
}

class _DevLogEntryCardState extends ConsumerState<DevLogEntryCard> with HoverableMixin {
  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/devlog/${widget.post.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          // "Hover Flash" -> Background turns Accent
          color: isHovered ? nbt.primaryAccent : nbt.surface,
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            offset: isHovered ? const Offset(0.02, 0) : Offset.zero, // Text Shift Right
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // Header Row: Category + Timestamp
                 Row(
                   children: [
                     Text(
                       "[${widget.post.category}]",
                       style: GameHUDTextStyles.terminalText.copyWith(
                         color: isHovered ? nbt.shadowColor : nbt.primaryAccent,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     const SizedBox(width: 12),
                     Text(
                       "t_${widget.post.timestamp.millisecondsSinceEpoch}", 
                       style: GameHUDTextStyles.terminalText.copyWith(
                         color: isHovered ? nbt.shadowColor.withOpacity(0.7) : nbt.textColor.withOpacity(0.6),
                         fontSize: 12,
                       ),
                     ),
                   ],
                 ),
                 
                 const SizedBox(height: 16),
                 
                 // Title
                 Text(
                   widget.post.title,
                   style: GameHUDTextStyles.titleLarge.copyWith(
                     color: isHovered ? nbt.shadowColor : nbt.textColor,
                     fontSize: 24,
                   ),
                 ),
                 
                 const SizedBox(height: 12),
                 
                 // Excerpt
                 Text(
                   widget.post.shortExcerpt,
                   style: GameHUDTextStyles.terminalText.copyWith(
                     color: isHovered ? nbt.shadowColor : nbt.textColor.withOpacity(0.8),
                     height: 1.6,
                   ),
                 ),
                 
                 const SizedBox(height: 24),
                 
                 // Footer "Command Line"
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       "[root@engraved ~] commit_v1.0.${widget.post.id}", // ID as version
                       style: GameHUDTextStyles.terminalText.copyWith(
                          color: isHovered ? nbt.shadowColor.withOpacity(0.5) : nbt.textColor.withOpacity(0.5),
                          fontSize: 12,
                       ),
                     ),
                     Opacity(
                       opacity: isHovered ? 1.0 : 0.0,
                       child: Text(
                         "[READ_LOG] >>",
                         style: GameHUDTextStyles.terminalText.copyWith(
                           color: nbt.shadowColor,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                   ],
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
