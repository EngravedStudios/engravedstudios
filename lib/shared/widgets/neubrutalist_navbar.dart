import 'package:engravedstudios/features/home/presentation/controllers/home_scroll_controller.dart';
import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:engravedstudios/core/audio/sound_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart'; // For PointerEvents
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class NeubrutalistNavbar extends ConsumerWidget {
  const NeubrutalistNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On mobile, maybe we show a condensed version or just the logo?
    // For now, let's implement the desktop "floating shell".
    final isMobile = ResponsiveUtils.isMobile(context);

    // Padding for the floating effect
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.0 : 48.0, 
        vertical: 24.0
      ),
      child: Center(
        heightFactor: 1.0, 
        child: Container(
          // Allow width to shrinkwrap content on desktop, expand on mobile?
          constraints: const BoxConstraints(maxWidth: 800),
          alignment: Alignment.center,
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // LOGO / HOME
                  _NavbarButton(
                    label: "ENGRAVED",
                    onTap: () {
                         final currentPath = GoRouterState.of(context).uri.toString();
                         if (currentPath == '/') {
                           HomeScrollController.instance.scrollToTop();
                         } else {
                           context.go('/');
                         }
                    },
                    isLogo: true,
                  ),
                  
                  const SizedBox(width: 32), // Spacer replacement
                  
                  if (!isMobile) ...[
                    _NavbarButton(
                      label: "GAMES",
                      onTap: () {
                         final currentPath = GoRouterState.of(context).uri.toString();
                         if (currentPath == '/') {
                           HomeScrollController.instance.scrollToGames();
                         } else {
                           HomeScrollController.instance.setPendingScroll(ScrollTarget.games);
                           context.go('/');
                         }
                      },
                    ),
                    const SizedBox(width: 16),
                    _NavbarButton(
                      label: "BLOG",
                      onTap: () {
                        final currentPath = GoRouterState.of(context).uri.toString();
                        if (currentPath == '/') {
                          HomeScrollController.instance.scrollToBlog();
                        } else {
                          HomeScrollController.instance.setPendingScroll(ScrollTarget.blog);
                          context.go('/');
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    _NavbarButton(
                      label: "ABOUT US",
                      onTap: () => context.go('/about'),
                    ),
                    const SizedBox(width: 32),
                  ],

                  // CTA / Contact
                  _NavbarButton(
                    label: isMobile ? "CONTACT" : "CONTACT US",
                    onTap: () {
                       final currentPath = GoRouterState.of(context).uri.toString();
                       if (currentPath == '/') {
                         HomeScrollController.instance.scrollToContact();
                       } else {
                         HomeScrollController.instance.setPendingScroll(ScrollTarget.contact);
                         context.go('/');
                       }
                    }, 
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavbarButton extends ConsumerStatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLogo;
  final bool isPrimary;

  const _NavbarButton({
    required this.label,
    required this.onTap,
    this.isLogo = false,
    this.isPrimary = false,
  });

  @override
  ConsumerState<_NavbarButton> createState() => _NavbarButtonState();
}

class _NavbarButtonState extends ConsumerState<_NavbarButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _onEnter(PointerEnterEvent event) {
    setState(() => _isHovered = true);
    CursorController.instance.setHover();
  }

  void _onExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    CursorController.instance.setDefault();
  }

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    final baseOffset = widget.isPrimary || widget.isLogo ? 4.0 : 0.0;
    // Lift on hover (increase offset), depress on press (0 offset)
    final double? currentOffset = _isPressed 
        ? 0 
        : (_isHovered ? baseOffset + 2 : baseOffset);
        
    final Color bgColor = widget.isPrimary 
        ? nbt.primaryAccent 
        : (widget.isLogo ? nbt.borderColor : Colors.transparent);
    
    final Color textColor = widget.isPrimary 
        ? nbt.shadowColor 
        : (widget.isLogo ? nbt.primaryAccent : nbt.textColor);

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          ref.read(soundServiceProvider).playTransition();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: 100.ms,
          transform: Matrix4.translationValues(
             -(_isPressed ? 0.0 : (_isHovered ? 2.0 : 0.0)),
             -(_isPressed ? 0.0 : (_isHovered ? 2.0 : 0.0)), 
             0.0
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              border: (widget.isPrimary || widget.isLogo) 
                  ? Border.all(width: 3, color: nbt.borderColor)
                  : (_isHovered ? Border.all(width: 3, color: nbt.borderColor) : null), 
              boxShadow: (widget.isPrimary || widget.isLogo)
                  ? [
                      BoxShadow(
                        color: nbt.shadowColor,
                        offset: Offset(currentOffset!, currentOffset),
                        blurRadius: 0,
                      )
                    ]
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              widget.label,
              style: GameHUDTextStyles.terminalText.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
