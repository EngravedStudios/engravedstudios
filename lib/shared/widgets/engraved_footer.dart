import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:engravedstudios/features/games/data/games_repository.dart';
import 'package:engravedstudios/features/games/domain/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class EngravedFooter extends ConsumerWidget {
  const EngravedFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(allGamesProvider);
    final isMobile = ResponsiveUtils.isMobile(context);
    final nbt = context.nbt;

    return Container(
      color: GameHUDColors.hardBlack,
      padding: const EdgeInsets.only(top: 64, bottom: 24, left: 32, right: 32),
      child: Column(
        children: [
          // Top Section: 4 Columns
          if (isMobile)
            _buildMobileLayout(context, gamesAsync)
          else
            _buildDesktopLayout(context, gamesAsync),

          const SizedBox(height: 64),

          // Separator
          Divider(color: GameHUDColors.paperWhite.withOpacity(0.3), thickness: 1),
          const SizedBox(height: 24),

          // Copyright
          Text(
            "© 2025 ENGRAVED STUDIOS. ALL SYSTEMS NORMAL.",
            style: GameHUDTextStyles.terminalText.copyWith(
              color: GameHUDColors.paperWhite.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AsyncValue<List<GameModel>> gamesAsync) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Engraved Studios
        Expanded(
          flex: 2,
          child: _FooterSection(
            title: "ENGRAVED STUDIOS",
            children: [
              Text(
                "Forging immersive digital experiences from the void.\nWe build worlds that linger in your mind.",
                style: GameHUDTextStyles.bodyText.copyWith(
                  color: GameHUDColors.paperWhite.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 48),

        // 2. Products
        Expanded(
          child: _FooterSection(
            title: "PRODUCTS",
            children: gamesAsync.when(
              data: (games) => games.take(4).map((game) => _FooterLink(
                label: game.title.toUpperCase(),
                onTap: () => context.go('/games/${game.id}'),
              )).toList(),
              loading: () => [const Text("LOADING...", style: TextStyle(color: Colors.white))],
              error: (_, __) => [const Text("ERROR", style: TextStyle(color: Colors.red))],
            ),
          ),
        ),

        // 3. Legal
        Expanded(
          child: _FooterSection(
            title: "LEGAL",
            children: [
              _FooterLink(label: "LEGAL NOTICE", onTap: () => context.go('/about')), // Impressum
              _FooterLink(label: "PRIVACY POLICY", onTap: () => context.go('/about')), // Placeholder
              _FooterLink(label: "PRESS KIT", onTap: () => context.go('/press')),
            ],
          ),
        ),

        // 4. Community
        Expanded(
          child: _FooterSection(
            title: "COMMUNITY",
            children: [
              _FooterLink(label: "ROADMAP", onTap: () => context.go('/roadmap')),
              const SizedBox(height: 8),
              _FooterLink(
                label: "SUPPORT US (KICKSTARTER)", 
                onTap: () {
                   // launchUrl(Uri.parse("https://kickstarter.com/..."));
                },
                isExternal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AsyncValue<List<GameModel>> gamesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterSection(
            title: "ENGRAVED STUDIOS",
            children: [
              Text(
                "Forging immersive digital experiences from the void.",
                style: GameHUDTextStyles.bodyText.copyWith(
                  color: GameHUDColors.paperWhite.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FooterSection(
                title: "PRODUCTS",
                children: gamesAsync.when(
                  data: (games) => games.take(4).map((game) => _FooterLink(
                    label: game.title.toUpperCase(),
                    onTap: () => context.go('/games/${game.id}'),
                  )).toList(),
                  loading: () => [], 
                  error: (_, __) => [],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _FooterSection(
                title: "LEGAL",
                children: [
                  _FooterLink(label: "LEGAL NOTICE", onTap: () => context.go('/about')),
                  _FooterLink(label: "PRIVACY POLICY", onTap: () => context.go('/about')),
                  _FooterLink(label: "PRESS KIT", onTap: () => context.go('/press')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _FooterSection(
          title: "COMMUNITY",
          children: [
             _FooterLink(label: "ROADMAP", onTap: () => context.go('/roadmap')),
             _FooterLink(
                label: "SUPPORT US (KICKSTARTER)", 
                onTap: () {},
                isExternal: true,
              ),
          ],
        ),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FooterSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GameHUDTextStyles.titleLarge.copyWith(
            color: GameHUDColors.paperWhite,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        ...children.expand((element) => [element, const SizedBox(height: 8)]).take(children.length * 2 - 1),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isExternal;

  const _FooterLink({required this.label, required this.onTap, this.isExternal = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GameHUDTextStyles.terminalText.copyWith(
              color: GameHUDColors.paperWhite.withOpacity(0.8),
              decoration: TextDecoration.underline,
              decorationColor: GameHUDColors.paperWhite.withOpacity(0.3),
            ),
          ),
          if (isExternal) ...[
            const SizedBox(width: 4),
            Icon(Icons.arrow_outward, size: 12, color: GameHUDColors.paperWhite.withOpacity(0.8)),
          ]
        ],
      ),
    );
  }
}
