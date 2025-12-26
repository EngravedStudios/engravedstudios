import 'package:engravedstudios/features/games/data/games_repository.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:engravedstudios/shared/widgets/neubrutalist_loader.dart';
import 'package:engravedstudios/features/games/presentation/widgets/hud_sidebar.dart';
import 'package:engravedstudios/features/games/presentation/widgets/project_depo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engravedstudios/core/theme/design_system.dart';

class GameDetailScreen extends ConsumerStatefulWidget {
  final String gameId;
  const GameDetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends ConsumerState<GameDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(allGamesProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      backgroundColor: context.nbt.surface,
      body: gamesAsync.when(
        loading: () => const Center(child: NeubrutalistLoader()),
        error: (err, s) => Center(child: Text("ERROR LOADING ARCHIVE: $err", style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.glitchRed))),
        data: (games) {
          final game = games.firstWhere(
            (g) => g.id == widget.gameId, 
            orElse: () => GameModel(
              id: '0', 
              title: 'DATA CORRUPTED', 
              genre: 'UNKNOWN', 
              thumbnailUrl: '', 
              releaseStatus: GameStatus.concept, 
              accentColor: Colors.grey,
              description: "The requested archive entry could not be found.",
              engine: "N/A",
              platforms: [],
              techStack: [],
              images: []
            )
          );

          if (game.id == '0') {
             return Center(child: Text("ARCHIVE ENTRY #${widget.gameId} NOT FOUND", style: GameHUDTextStyles.terminalText));
          }

          if (isDesktop) {
            // DESKTOP LAYOUT (Sidebar + Content)
            return Row(
              children: [
                // Fixed Sidebar
                SizedBox(
                  width: 350,
                  height: double.infinity,
                  child: HudSidebar(game: game),
                ),
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: ProjectDepo(game: game),
                  ),
                ),
              ],
            );
          } else {
            // MOBILE LAYOUT (Sliver Header + Stacked Content)
            return CustomScrollView(
              slivers: [
                 SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: context.nbt.surface,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      game.title.toUpperCase(),
                      style: GameHUDTextStyles.titleLarge.copyWith(
                         color: Colors.white, 
                         shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                         fontSize: 16,
                      ),
                    ),
                    centerTitle: true,
                    background: Stack(
                       fit: StackFit.expand,
                       children: [
                          Container(color: game.accentColor.withOpacity(0.2)),
                          Center(
                            child: Hero(
                              tag: 'game-icon-${game.id}',
                              child: Icon(Icons.gamepad, size: 80, color: game.accentColor),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, context.nbt.surface],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                       ],
                    ),
                  ),
                 ),
                 SliverToBoxAdapter(
                   child: ProjectDepo(game: game),
                 ),
              ],
            );
          }
        },
      ),
    );
  }
}
