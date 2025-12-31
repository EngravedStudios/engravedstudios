import 'package:engravedstudios/features/home/presentation/controllers/home_scroll_controller.dart';
import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:engravedstudios/core/audio/sound_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class NeubrutalistNavbar extends ConsumerWidget {
  const NeubrutalistNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.0 : 48.0, 
        vertical: 24.0
      ),
      child: Center(
        heightFactor: 1.0, 
        child: Container(
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
                    buttonType: NavButtonType.logo,
                  ),
                  
                  const SizedBox(width: 32),
                  
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
                      buttonType: NavButtonType.middle,
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
                      buttonType: NavButtonType.middle,
                    ),
                    const SizedBox(width: 16),
                    _NavbarButton(
                      label: "ABOUT US",
                      onTap: () => context.go('/about'),
                      buttonType: NavButtonType.middle,
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
                    buttonType: NavButtonType.primary,
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

enum NavButtonType { logo, middle, primary }

class _NavbarButton extends ConsumerStatefulWidget {
  final String label;
  final VoidCallback onTap;
  final NavButtonType buttonType;

  const _NavbarButton({
    required this.label,
    required this.onTap,
    required this.buttonType,
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
    final isMiddle = widget.buttonType == NavButtonType.middle;
    final isLogo = widget.buttonType == NavButtonType.logo;
    final isPrimary = widget.buttonType == NavButtonType.primary;
    
    // Animation values (ThemeToggle style for logo/primary)
    double translateX = 0;
    double translateY = 0;
    double shadowX = 4;
    double shadowY = 4;

    if (isMiddle) {
      // Middle buttons: translate on hover (transform doesn't affect layout)
      shadowX = 0;
      shadowY = 0;
      if (_isHovered && !_isPressed) {
        translateX = -4;
        translateY = -4;
      }
    } else {
      // Logo and Primary: ThemeToggle style animation
      if (_isPressed) {
         translateX = 0;
         translateY = 0;
         shadowX = 0;
         shadowY = 0;
      } else if (_isHovered) {
         translateX = -4;
         translateY = -4;
         shadowX = 10;
         shadowY = 10;
      } else {
         translateX = 0;
         translateY = 0;
         shadowX = 4;
         shadowY = 4;
      }
    }
    
    // Colors
    Color bgColor;
    Color textColor;
    
    if (isPrimary) {
      bgColor = nbt.primaryAccent;
      textColor = nbt.shadowColor;
    } else if (isLogo) {
      bgColor = nbt.borderColor;
      textColor = nbt.primaryAccent;
    } else {
      // Middle buttons: white background for readability
      bgColor = GameHUDColors.paperWhite;
      textColor = nbt.textColor;
    }
    
    // Border - ALWAYS present to prevent layout shift, just change color
    Border border;
    if (isPrimary || isLogo) {
      border = Border.all(width: 3, color: nbt.borderColor);
    } else {
      // Middle buttons: always have border, transparent when not hovered
      border = Border.all(
        width: 2, 
        color: _isHovered ? nbt.borderColor : Colors.transparent,
      );
    }
    
    // Shadow (only for logo and primary)
    List<BoxShadow>? boxShadow;
    if (!isMiddle) {
      boxShadow = [
        BoxShadow(
          color: nbt.shadowColor,
          offset: Offset(shadowX, shadowY),
          blurRadius: 0,
        )
      ];
    }

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
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(translateX, translateY, 0.0),
          decoration: BoxDecoration(
            color: bgColor,
            border: border,
            boxShadow: boxShadow,
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
    );
  }
}
