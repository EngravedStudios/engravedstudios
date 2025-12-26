import 'package:engravedstudios/features/devlog/domain/dev_log_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dev_log_provider.g.dart';

@riverpod
Future<List<DevLogPost>> devLogPosts(Ref ref) async {
  // Simulate delay
  // Simulate delay
  // await Future.delayed(const Duration(milliseconds: 800)); // REMOVED to prevent layout shift during scroll

  return [
    DevLogPost(
      id: '1',
      title: 'NEW MAJOR UPDATE',
      category: 'GAME',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      shortExcerpt: 'Major Update for Mistbound',
    ),
    DevLogPost(
      id: '2',
      title: 'PROCEDURAL Map GENERATION',
      category: 'LOGIC',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      shortExcerpt: 'Wave Function Collapse algorithm deployed for Heavens Fall map layout. Seeds are now deterministic.',
    ),
    DevLogPost(
      id: '3',
      title: 'Soundtracks released',
      category: 'AUDIO',
      timestamp: DateTime.now().subtract(const Duration(days: 12)),
      shortExcerpt: 'Soundtracks for Mistbound and Heavens Fall are now available on Spotify.',
    ),
  ];
}
