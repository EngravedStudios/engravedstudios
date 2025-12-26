import 'package:engravedstudios/core/theme/app_colors.dart';
import 'package:engravedstudios/core/theme/app_theme.dart';
import 'package:engravedstudios/core/theme/theme_controller.dart';
import 'package:engravedstudios/shared/widgets/brutalist_button.dart';
import 'package:engravedstudios/shared/widgets/outlined_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DemoPage extends ConsumerWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = context.isDark;

    return Scaffold(
      // Background handled by Theme (GhostWhite vs DeepOnyx)
      body: Stack(
        children: [
          // Content
          Column(
            children: [
              // HEADER
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 48),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 2, color: appColors.weirdBorder)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LOGO / BRAND
                    Text(
                      "ENGRAVED STUDIOS",
                      style: GoogleFonts.inter(
                        fontSize: 24, fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    
                    // THEME TOGGLE
                    Row(
                      children: [
                        Text(
                          isDark ? "SYSTEM: DARK" : "SYSTEM: LIGHT",
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(width: 16),
                        BrutalistButton(
                          text: "TOGGLE",
                          isPrimary: true, // Lime/Red accent
                          onTap: () => ref.read(themeControllerProvider.notifier).toggle(),
                          width: 120,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              
              // MAIN CONTENT SPLIT
              Expanded(
                child: Row(
                  children: [
                    // LEFT COLUMN (Info/Nav)
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(48),
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(width: 2, color: appColors.weirdBorder)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              color: appColors.highlight,
                              child: Text(
                                "SYSTEM.READY",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              "WE ENGRAVE",
                              style: theme.textTheme.displayLarge, 
                            ),
                            // Outlined Text for "WORLDS"
                            OutlinedText(
                              "WORLDS:",
                              strokeWidth: 2,
                              strokeColor: theme.colorScheme.onSurface,
                              style: theme.textTheme.displayLarge!,
                            ),
                            const SizedBox(height: 48),
                            BrutalistButton(
                              text: "INITIATE SEQUENCE",
                              onTap: () {},
                              width: 250,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // RIGHT COLUMN (Visual/Video)
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: isDark ? AppColors.pureBlack : AppColors.ghostGray.withOpacity(0.1),
                        child: Center(
                          child: Container(
                            width: 400,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: appColors.weirdBorder),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Placeholder for Video
                                Text(
                                  "VIDEO_SIGNAL_LOST",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: appColors.weirdBorder.withOpacity(0.5),
                                  ),
                                ),
                                // Glitch Effect layer?
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
