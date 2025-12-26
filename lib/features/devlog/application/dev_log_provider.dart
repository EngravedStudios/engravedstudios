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
      title: 'VULKAN RENDERER OPTIMIZATION',
      category: 'ENGINE',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      shortExcerpt: 'Implemented Isolate Pools for geometry processing. Frame times reduced by 4ms on low-end hardware.',
    ),
    DevLogPost(
      id: '2',
      title: 'PROCEDURAL CITY GENERATION',
      category: 'LOGIC',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      shortExcerpt: 'Wave Function Collapse algorithm deployed for Aethelgard map layout. Seeds are now deterministic.',
    ),
    DevLogPost(
      id: '3',
      title: 'AUDIO SPATIALIZATION',
      category: 'AUDIO',
      timestamp: DateTime.now().subtract(const Duration(days: 12)),
      shortExcerpt: 'Integrated FMOD for 3D occlusion paths. Reverb zones added to the "Underground" sector.',
    ),
    DevLogPost(
      id: '4',
      title: 'NEON SHADER COMPILATION',
      category: 'ART',
      timestamp: DateTime.now().subtract(const Duration(days: 15)),
      shortExcerpt: 'Fixed fragment shader overflow on mobile GPUs. Neon bleed effect now uses optimized gaussian pass.',
    ),
  ];
}
