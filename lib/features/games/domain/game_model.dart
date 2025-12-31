import 'package:flutter/material.dart';

enum GameStatus {
  concept,
  alpha,
  released,
}

class GameModel {
  final String id;
  final String title;
  final String genre;
  final String thumbnailUrl; // Local asset or network
  final GameStatus releaseStatus;
  final Color accentColor;
  final double aspectRatio; // For staggered grid logic (e.g. 1.0 for square, 0.7 for tall)

  const GameModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.thumbnailUrl,
    required this.releaseStatus,
    required this.accentColor,
    this.aspectRatio = 1.0, 
    // Detailed Fields for Archive View
    this.description = "A mysterious project engraved into the digital void.",
    this.engine = "Unknown Engine",
    this.platforms = const ["PC"],
    this.techStack = const ["Flutter"],
    this.images = const [],
    this.steamAppId,
    this.itchUrl,
  });
  
  final String description;
  final String engine;
  final List<String> platforms;
  final List<String> techStack;
  final List<String> images; // URLs for parallax gallery
  
  final String? steamAppId;
  final String? itchUrl;
}
