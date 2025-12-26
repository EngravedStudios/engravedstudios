import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/contact/presentation/widgets/neubrutalist_square.dart';
import 'package:engravedstudios/features/contact/presentation/widgets/terminal_input.dart';
import 'package:engravedstudios/features/contact/presentation/widgets/transmission_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: GameHUDColors.paperWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Massive CTA
            Text(
              "READY TO\nENGRAVE\nTHE FUTURE?",
              style: GameHUDTextStyles.titleLarge.copyWith(
                fontSize: 64, // Massive
                height: 0.9,
                color: Colors.transparent, // Outline style
                // Provide stroke via Paint
              ),
            ).copyWith(foreground: Paint()..style = PaintingStyle.stroke ..strokeWidth = 2 ..color = GameHUDColors.hardBlack)
            .animate().fadeIn(duration: 800.ms),
            
            const SizedBox(height: 64),
            
            // Terminal Form
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              margin: const EdgeInsets.symmetric(horizontal: 0), // Left align or center? Let's keep left for rugged look
              child: Column(
                children: const [
                  TerminalInput(label: "USER_ID"),
                  SizedBox(height: 32),
                  TerminalInput(label: "COMM_CHANNEL (EMAIL)"),
                  SizedBox(height: 32),
                  TerminalInput(label: "TRANSMISSION_DATA", maxLines: 4),
                  SizedBox(height: 48),
                  TransmissionButton(),
                ],
              ),
            ),
            
            const SizedBox(height: 120),
            
            // Kinetic Footer
            const Divider(color: GameHUDColors.hardBlack, thickness: 4),
            const SizedBox(height: 48),
            
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                // Socials
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    NeubrutalistSquare(icon: Icons.discord),
                    SizedBox(width: 16),
                    NeubrutalistSquare(icon: Icons.code), // Github
                    SizedBox(width: 16),
                    NeubrutalistSquare(icon: Icons.alternate_email), // X / Twitter
                  ],
                ),
                
                // Seal / Signature
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: GameHUDColors.hardBlack),
                  ),
                  child: Center(
                    child: Text(
                      "ENGRAVED\nEST. 2025",
                      textAlign: TextAlign.center,
                      style: GameHUDTextStyles.terminalText.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat()).rotate(duration: 10.seconds),
              ],
            ),
             const SizedBox(height: 24),
             Text(
               "// END OF LINE.",
               style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.ghostGray),
             ),
          ],
        ),
      ),
    );
  }
}

extension TextStyleStroke on Text {
  Text copyWith({Paint? foreground}) {
    return Text(
      data!,
      style: style?.copyWith(foreground: foreground),
      textAlign: textAlign,
    );
  }
}
