import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/devlog/application/dev_log_provider.dart';
import 'package:engravedstudios/features/devlog/presentation/scanline_painter.dart';
import 'package:engravedstudios/features/devlog/presentation/widgets/dev_log_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevLogSection extends ConsumerWidget {
  const DevLogSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(devLogPostsProvider);
    
    // We wrap everything in ScanlineOverlay? 
    // Or just the list? Let's wrap the list.
    
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 48.0), 
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             // Header with Blinking Cursor
             Container(
               constraints: const BoxConstraints(maxWidth: 900),
               padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
               child: Row(
                 children: [
                   Text("> BLOG", style: GameHUDTextStyles.titleLarge),
                   const SizedBox(width: 8),
                   Container(
                     width: 16, height: 32, 
                     color: GameHUDColors.neonLime
                   ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 500.ms).fadeOut(duration: 500.ms),
                 ],
               ),
             ),
             
             // List
             ScanlineOverlay(
               child: Container(
                 constraints: const BoxConstraints(maxWidth: 900), // Limit width for readability
                 margin: const EdgeInsets.symmetric(horizontal: 24.0),
                 decoration: BoxDecoration(
                   border: Border.all(width: 2, color: GameHUDColors.hardBlack),
                 ),
                 child: postsAsync.when(
                   loading: () => const SizedBox(height: 200, child: Center(child: Text("LOADING_FEED..."))),
                   error: (err, _) => Text("ERR: $err"),
                   data: (posts) {
                     return ListView.separated(
                       shrinkWrap: true,
                       physics: const NeverScrollableScrollPhysics(), // Let the main scroll view handle it
                       itemCount: posts.length,
                       separatorBuilder: (context, index) => Container(
                         height: 2, 
                         color: GameHUDColors.hardBlack,
                       ),
                       itemBuilder: (context, index) {
                         return DevLogEntryCard(post: posts[index])
                             .animate()
                             .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: (index * 150).ms, curve: Curves.easeOutBack)
                             .fadeIn(duration: 300.ms, delay: (index * 150).ms);
                       },
                     );
                   },
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }
}
