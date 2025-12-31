import 'package:engravedstudios/core/audio/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WithSound extends ConsumerWidget {
  final Widget child;
  final bool enableClick;
  final bool enableHover;

  const WithSound({
    super.key,
    required this.child,
    this.enableClick = true,
    this.enableHover = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onEnter: enableHover
          ? (_) => ref.read(soundServiceProvider).playHover()
          : null,
      child: GestureDetector(
        onTapDown: enableClick
            ? (_) => ref.read(soundServiceProvider).playClick()
            : null,
        child: child,
      ),
    );
  }
}
