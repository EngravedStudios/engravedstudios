import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:engravedstudios/features/games/data/games_repository.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:engravedstudios/features/games/widgets/engraved_game_card.dart';
import 'package:engravedstudios/shared/widgets/neubrutalist_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GamesGallery extends ConsumerWidget {
  const GamesGallery({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(allGamesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    // Constrain to 1200px max width
    final horizontalPadding = (screenWidth > 1200) ? (screenWidth - 1200) / 2 : 24.0;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 48.0),
      sliver: gamesAsync.when(
        loading: () => const SliverFillRemaining(
          hasScrollBody: false,
          child: NeubrutalistLoader(),
        ),
        error: (err, stack) => SliverToBoxAdapter(
          child: Center(child: Text("ERROR: $err", style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.glitchRed))),
        ),
        data: (games) {
          final columnCount = context.responsive(1, 3, 2); 
          
          return SliverGrid(
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: columnCount,
               mainAxisSpacing: 32,
               crossAxisSpacing: 32,
               childAspectRatio: 0.7, // Taller, more cinematic cards
             ),
             delegate: SliverChildBuilderDelegate(
               (context, index) {
                 final game = games[index];
                 return EngravedGameCard(game: game)
                   .animate()
                   .fade(duration: 500.ms)
                   .moveY(begin: 50, end: 0, curve: Curves.easeOutQuad);
               },
               childCount: games.length,
             ),
          );
        },
      ),
    );
  }
}
