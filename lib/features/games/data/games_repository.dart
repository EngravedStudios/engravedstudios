import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'games_repository.g.dart';

class GamesRepository {
  Future<List<GameModel>> fetchGames() async {
    // Static data - no network delay needed
    return const [
      GameModel(
        id: '1',
        title: 'Mistbound',
        genre: 'First Person Horror Extraction Friend Slop',
        thumbnailUrl: 'assets/images/games/voidfall_thumb.png', // Placeholder
        releaseStatus: GameStatus.alpha,
        accentColor: GameHUDColors.neonLime,
        aspectRatio: 1.0, 
        description: "First Person Horror Extraction Shooter, where every move as an Witch-Hunter counts.",
        engine: "Unreal Engine",
        platforms: ["Steam", "Epic Games"],
        techStack: ["C++", "Unreal Engine", "Blender", "Substance Painter"],
        images: [
           "https://placehold.co/800x450/1a1a1a/00FF9C?text=Voidfall+Alpha",
           "https://placehold.co/800x450/1a1a1a/00FF9C?text=Combat+System",
           "https://placehold.co/800x450/1a1a1a/00FF9C?text=Character+Art"
        ],
      ),
      GameModel(
        id: '2',
        title: 'Heavens Fall',
        genre: 'Soulslike Rougelite',
        thumbnailUrl: 'assets/images/games/cyberink_thumb.png',
        releaseStatus: GameStatus.concept,
        accentColor: GameHUDColors.cyan,
        aspectRatio: 0.7, 
        description: "Third Person Action-Soulslike, where you fight demons and not only the one inside of you.",
        engine: "Unreal Engine",
        platforms: ["Steam", "Epic Games"],
        techStack: ["C++", "Unreal Engine", "Blender", "Substance Painter"],
        images: [
           "https://placehold.co/600x800/1a1a1a/00E5FF?text=Tactical+Map",
           "https://placehold.co/600x800/1a1a1a/00E5FF?text=Unit+Design"
        ],
      ),
      GameModel(
        id: '3',
        title: 'Syfris',
        genre: '2D Platformer',
        thumbnailUrl: 'assets/images/games/neongrave_thumb.png',
        releaseStatus: GameStatus.released,
        accentColor: GameHUDColors.glitchRed,
        aspectRatio: 1.3, 
        description: "Pixelart 2D Platformer.",
        engine: "Godot",
        platforms: ["Steam", "Epic"],
        techStack: ["C#", "Godot", "Aseprite"],
        images: [
           "https://placehold.co/1200x600/1a1a1a/FF2A2A?text=Neon+City",
           "https://placehold.co/1200x600/1a1a1a/FF2A2A?text=Weapon+Showcase"
        ],
      ),
       GameModel(
        id: '4',
        title: 'Game Template',
        genre: 'Template Genre',
        thumbnailUrl: 'assets/images/games/depo_thumb.png',
        releaseStatus: GameStatus.concept,
        accentColor: Colors.white,
        aspectRatio: 1.0, 
        description: "Template description.",
        engine: "Unreal Engine",
        platforms: ["PC"],
        techStack: ["C++", "Unreal Engine", "Blender", "Substance Painter"],
        images: [
           "https://placehold.co/800x800/1a1a1a/FFFFFF?text=Terminal+Interface",
           "https://placehold.co/800x800/1a1a1a/FFFFFF?text=Star+Map"
        ],
      ),
    ];
  }

  Future<GameModel?> getGameById(String id) async {
    final games = await fetchGames();
    try {
      return games.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}

@riverpod
GamesRepository gamesRepository(Ref ref) {
  return GamesRepository();
}

@riverpod
Future<List<GameModel>> allGames(Ref ref) {
  return ref.watch(gamesRepositoryProvider).fetchGames();
}
