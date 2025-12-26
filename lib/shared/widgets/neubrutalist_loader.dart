import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NeubrutalistLoader extends StatelessWidget {
  const NeubrutalistLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: GameHUDColors.hardBlack,
          border: Border.all(color: GameHUDColors.neonLime, width: 2),
        ),
      ).animate(onPlay: (c) => c.repeat())
       .rotate(duration: 1200.ms, curve: Curves.easeInOutBack),
    );
  }
}
