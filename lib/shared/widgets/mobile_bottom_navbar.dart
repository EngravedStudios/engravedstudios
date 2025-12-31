import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/home/presentation/controllers/home_scroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MobileBottomNavbar extends ConsumerWidget {
  const MobileBottomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nbt = context.nbt;
    
    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 12),
      decoration: BoxDecoration(
        color: nbt.surface,
        border: Border(
          top: BorderSide(width: 3, color: nbt.borderColor),
        ),
        boxShadow: [
          BoxShadow(
            color: nbt.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MobileNavItem(
              icon: Icons.home,
              label: 'HOME',
              onTap: () {
                final currentPath = GoRouterState.of(context).uri.toString();
                if (currentPath == '/') {
                  HomeScrollController.instance.scrollToTop();
                } else {
                  context.go('/');
                }
              },
            ),
             _MobileNavItem(
              icon: Icons.gamepad,
              label: 'GAMES',
              onTap: () {
                final currentPath = GoRouterState.of(context).uri.toString();
                if (currentPath == '/') {
                  HomeScrollController.instance.scrollToGames();
                } else {
                  HomeScrollController.instance.setPendingScroll(ScrollTarget.games);
                  context.go('/');
                }
              },
            ),
             _MobileNavItem(
              icon: Icons.article,
              label: 'BLOG',
              onTap: () {
                final currentPath = GoRouterState.of(context).uri.toString();
                if (currentPath == '/') {
                  HomeScrollController.instance.scrollToBlog();
                } else {
                  HomeScrollController.instance.setPendingScroll(ScrollTarget.blog);
                  context.go('/');
                }
              },
            ),
            _MobileNavItem(
              icon: Icons.info,
              label: 'ABOUT',
              onTap: () => context.go('/about'),
            ),
             _MobileNavItem(
              icon: Icons.mail,
              label: 'CONTACT',
              onTap: () {
                final currentPath = GoRouterState.of(context).uri.toString();
                if (currentPath == '/') {
                  HomeScrollController.instance.scrollToContact();
                } else {
                  HomeScrollController.instance.setPendingScroll(ScrollTarget.contact);
                  context.go('/');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: nbt.textColor, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GameHUDTextStyles.codeText.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: nbt.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
