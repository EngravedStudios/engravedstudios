import 'package:engravedstudios/core/theme/app_colors.dart';
import 'package:engravedstudios/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BrutalistButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary; // If true, uses Main Accent (Lime) as base, else Surface
  final double width;

  const BrutalistButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = false,
    this.width = double.infinity,
  });

  @override
  State<BrutalistButton> createState() => _BrutalistButtonState();
}

class _BrutalistButtonState extends State<BrutalistButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    // Base Colors
    // Primary: Lime (or Red in Dark)
    // Secondary: Transparent/White
    
    Color baseBg = widget.isPrimary 
        ? appColors.highlight // Lime or Red
        : (isDark ? AppColors.deepOnyx : AppColors.ghostWhite);
        
    Color baseText = widget.isPrimary 
        ? AppColors.pureBlack 
        : (isDark ? AppColors.pureWhite : AppColors.pureBlack);
        
    Color baseBorder = isDark ? AppColors.pureWhite : AppColors.pureBlack;

    if (widget.isPrimary) {
       // Primary Button always black text on Lime/Red?
       // Dark Mode: Red Bg, White Text? Or Black Text?
       // Let's stick to high contrast. Lime -> Black. Red -> White.
       if (isDark) baseText = AppColors.pureWhite; 
    }

    // Hover Colors (Swapped)
    final bg = _isHovered ? baseText : baseBg;
    final text = _isHovered ? baseBg : baseText;
    final border = baseBorder;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: widget.width == double.infinity ? null : widget.width, // Allow intrinsic if not max
          constraints: widget.width == double.infinity ? const BoxConstraints(minWidth: 120) : null,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(width: 2.0, color: border),
            // No shadow/elevation as per flat brutalist style? Or maybe simple offset?
            // "Geometry: 0px border radius" requested.
          ),
          child: Text(
            widget.text.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: text,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
