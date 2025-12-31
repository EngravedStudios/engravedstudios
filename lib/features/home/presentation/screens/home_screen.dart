import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/contact/presentation/contact_section.dart';
import 'package:engravedstudios/features/devlog/presentation/dev_log_section.dart';
import 'package:engravedstudios/features/games/games_gallery.dart';
import 'package:engravedstudios/features/hero/hero_section.dart';
import 'package:engravedstudios/features/home/presentation/controllers/home_scroll_controller.dart';
import 'package:engravedstudios/features/studio/presentation/studio_section.dart';
import 'package:engravedstudios/shared/widgets/engraved_footer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = HomeScrollController.instance;
  late final ScrollController _mainScrollController;

  @override
  void initState() {
    super.initState();
    _mainScrollController = ScrollController();
    _executePendingScrollIfNeeded();
  }
  
  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
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
          controller: _mainScrollController,
          slivers: [
            // 1. HERO SECTION
            HeroSection(scrollController: _mainScrollController),
            
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
            const SliverToBoxAdapter(
              child: EngravedFooter(),
            ),
          ],
        ), // CustomScrollView
      ), // MouseRegion
      ), // DefaultSelectionStyle
      ), // SelectionArea
    ); // Scaffold
  }
}

