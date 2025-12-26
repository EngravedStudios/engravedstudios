import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0

  const StatBar({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GameHUDTextStyles.terminalText.copyWith(fontSize: 10, color: GameHUDColors.ghostGray),
        ),
        const SizedBox(height: 4),
        // [|||||----] Style
        Row(
          children: List.generate(10, (index) {
            final isActive = (index / 10) < value;
            return Expanded(
              child: Container(
                height: 8,
                margin: const EdgeInsets.only(right: 2),
                color: isActive ? GameHUDColors.neonLime : GameHUDColors.hardBlack.withOpacity(0.2),
              ),
            );
          }),
        ),
      ],
    );
  }
}
