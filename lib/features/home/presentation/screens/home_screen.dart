import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/contact/presentation/contact_section.dart';
import 'package:engravedstudios/features/devlog/presentation/dev_log_section.dart';
import 'package:engravedstudios/features/games/games_gallery.dart';
import 'package:engravedstudios/features/hero/hero_section.dart';
import 'package:engravedstudios/features/home/presentation/controllers/home_scroll_controller.dart';
import 'package:engravedstudios/features/studio/presentation/studio_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = HomeScrollController.instance;

  @override
  void initState() {
    super.initState();
    _executePendingScrollIfNeeded();
  }
  
  void _executePendingScrollIfNeeded() {
    if (_scrollController.hasPendingScroll) {
      // Use post-frame callback to ensure layout is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasPendingScroll) {
          // Additional delay for layout stabilization (e.g. scrollbar appearance)
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _scrollController.executePendingScroll();
            }
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also check here for when widget is restored from cache
    _executePendingScrollIfNeeded();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: GameHUDColors.paperWhite,
      body: SelectionArea(
        child: DefaultSelectionStyle(
          mouseCursor: SystemMouseCursors.none,
          child: MouseRegion(
            cursor: SystemMouseCursors.none,
            child: CustomScrollView(
          slivers: [
            // 1. HERO SECTION
            const HeroSection(),
            
            // 2. GAMES GALLERY - with scroll key
            SliverToBoxAdapter(
              key: _scrollController.gamesKey,
              child: const SizedBox.shrink(),
            ),
            const GamesGallery(),
            
            // 3. DEV LOG - with scroll key
            SliverToBoxAdapter(
              key: _scrollController.blogKey,
              child: const SizedBox.shrink(),
            ),
            const DevLogSection(),
            
            // 4. STUDIO (THE FORGE)
            const StudioSection(),
            
            // 5. CONTACT (COMM-LINK) - with scroll key
            SliverToBoxAdapter(
              key: _scrollController.contactKey,
              child: const SizedBox.shrink(),
            ),
            const ContactSection(),
            
            // 6. FOOTER
            SliverToBoxAdapter(
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: GameHUDColors.hardBlack,
                  border: Border(top: BorderSide(width: 4, color: GameHUDColors.neonLime)),
                ),
                child: Center(
                  child: Text(
                    "© 2025 ENGRAVED STUDIOS. ALL SYSTEMS NORMAL.",
                    style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.paperWhite),
                  ),
                ),
              ),
            ),
          ],
        ), // CustomScrollView
      ), // MouseRegion
      ), // DefaultSelectionStyle
      ), // SelectionArea
    ); // Scaffold
  }
}

