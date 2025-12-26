import 'package:engravedstudios/core/navigation/main_shell.dart';
import 'package:engravedstudios/features/home/presentation/screens/home_screen.dart';
import 'package:engravedstudios/features/games/presentation/screens/game_detail_screen.dart';
import 'package:engravedstudios/features/studio/presentation/screens/about_us_screen.dart';
import 'package:engravedstudios/features/demo/demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/games',
            builder: (context, state) => const Scaffold(body: Center(child: Text("GAMES LIST PLACEHOLDER"))),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return GameDetailScreen(gameId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/devlog',
            builder: (context, state) => const Scaffold(body: Center(child: Text("DEVLOG PLACEHOLDER"))),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutUsScreen(),
          ),
          GoRoute(
            path: '/demo',
            builder: (context, state) => const DemoPage(),
          ),
        ],
      ),
    ],
  );
}
