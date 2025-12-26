import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

class NeubrutalistGameCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget child; // e.g., an Image or a colored container
  final VoidCallback? onTap;

  const NeubrutalistGameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.onTap,
  });

  @override
  State<NeubrutalistGameCard> createState() => _NeubrutalistGameCardState();
}

class _NeubrutalistGameCardState extends State<NeubrutalistGameCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Current offset based on state
    final double currentOffset = _isPressed 
        ? 0 
        : (_isHovered ? GameHUDLayout.shadowOffset + 2 : GameHUDLayout.shadowOffset);
    
    // Background color of the "shadow" (static)
    // Actually, for a neubrutalist card, the shadow is usually a solid block behind the main card.
    // We can achieve this with a Stack or manual transform.
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        CursorController.instance.setHover();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        CursorController.instance.setDefault();
      },
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: SizedBox(
          // Ensure enough space for the offset
          width: double.infinity,
          height: 300, // Fixed height for uniformity in grid for now, or flexible
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // The "Shadow" Container
              Positioned(
                top: GameHUDLayout.shadowOffset,
                left: GameHUDLayout.shadowOffset,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: GameHUDColors.hardBlack,
                    border: Border.all(
                      width: 0, // Solid block
                      color: Colors.transparent, 
                    ),
                  ),
                ),
              ),
              // The Main Card Container
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                top: _isPressed ? GameHUDLayout.shadowOffset : 0,
                left: _isPressed ? GameHUDLayout.shadowOffset : 0,
                right: _isPressed ? 0 : GameHUDLayout.shadowOffset,
                bottom: _isPressed ? 0 : GameHUDLayout.shadowOffset,
                child: Container(
                  decoration: BoxDecoration(
                    color: GameHUDColors.paperWhite,
                    border: Border.all(
                      width: GameHUDLayout.cardBorderWidth,
                      color: GameHUDColors.hardBlack,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image/Content Area
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: GameHUDLayout.cardBorderWidth,
                                color: GameHUDColors.hardBlack,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            // Strict square corners
                            borderRadius: BorderRadius.zero, 
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.matrix(<double>[
                                // High contrast B&W / Threshold-like effect
                                0.2126 * 5, 0.7152 * 5, 0.0722 * 5, 0, -255 * 2,
                                0.2126 * 5, 0.7152 * 5, 0.0722 * 5, 0, -255 * 2,
                                0.2126 * 5, 0.7152 * 5, 0.0722 * 5, 0, -255 * 2,
                                0,          0,          0,          1, 0,
                              ]),
                              child: widget.child
                            ), 
                          ),
                        ),
                      ),
                      // Text Area
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title.toUpperCase(),
                                    style: GameHUDTextStyles.titleLarge.copyWith(
                                      fontSize: 24,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.subtitle.toUpperCase(),
                                    style: GameHUDTextStyles.terminalText.copyWith(
                                      color: GameHUDColors.ghostGray,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              // "Playable" UI element usually found in HUDs
                              Container(
                                width: double.infinity,
                                height: 4,
                                color: _isHovered 
                                    ? GameHUDColors.neonLime 
                                    : GameHUDColors.hardBlack,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
