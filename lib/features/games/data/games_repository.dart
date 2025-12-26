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
        genre: 'Rougelike Soulslike',
        thumbnailUrl: 'assets/images/games/voidfall_thumb.png', // Placeholder
        releaseStatus: GameStatus.alpha,
        accentColor: GameHUDColors.neonLime,
        aspectRatio: 1.0, 
        description: "",
        engine: "Unreal Engine",
        platforms: ["Steam", "Epic Games"],
        techStack: ["C++", "Unreal Engine", "Blender"],
        images: [
           "https://placehold.co/800x450/1a1a1a/00FF9C?text=Voidfall+Alpha",
           "https://placehold.co/800x450/1a1a1a/00FF9C?text=Combat+System",
           "https://placehold.co/800x450/1a1a1a/00FF9C?text=Character+Art"
        ],
      ),
      GameModel(
        id: '2',
        title: 'Havens Fall',
        genre: 'Soulslike Rougelite',
        thumbnailUrl: 'assets/images/games/cyberink_thumb.png',
        releaseStatus: GameStatus.concept,
        accentColor: GameHUDColors.cyan,
        aspectRatio: 0.7, 
        description: "Ink-based strategy game where every move costs 'Ink'. Run out, and you fade from existence. Features a unique hand-drawn neobrutalist art style.",
        engine: "Flutter",
        platforms: ["Steam", "Epic Games"],
        techStack: ["Dart", "Flame", "Riverpod"],
        images: [
           "https://placehold.co/600x800/1a1a1a/00E5FF?text=Tactical+Map",
           "https://placehold.co/600x800/1a1a1a/00E5FF?text=Unit+Design"
        ],
      ),
      GameModel(
        id: '3',
        title: 'Syfris',
        genre: 'FPS / Horror',
        thumbnailUrl: 'assets/images/games/neongrave_thumb.png',
        releaseStatus: GameStatus.released,
        accentColor: GameHUDColors.glitchRed,
        aspectRatio: 1.3, 
        description: "High-octane retro FPS. You are a gravedigger in a neon-lit cyberpunk sensory overload. Survive the night.",
        engine: "Unreal Engine 5",
        platforms: ["Steam", "Epic"],
        techStack: ["C++", "Blueprints", "Lumen"],
        images: [
           "https://placehold.co/1200x600/1a1a1a/FF2A2A?text=Neon+City",
           "https://placehold.co/1200x600/1a1a1a/FF2A2A?text=Weapon+Showcase"
        ],
      ),
       GameModel(
        id: '4',
        title: 'Echoes of Depo',
        genre: 'Narrative Sim',
        thumbnailUrl: 'assets/images/games/depo_thumb.png',
        releaseStatus: GameStatus.concept,
        accentColor: Colors.white,
        aspectRatio: 1.0, 
        description: "A mysterious narrative simulation about managing a derelict space depot. Decode signals, trade with nomads, and uncover the truth.",
        engine: "Custom (C++)",
        platforms: ["PC"],
        techStack: ["C++", "OpenGL", "Lua"],
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
