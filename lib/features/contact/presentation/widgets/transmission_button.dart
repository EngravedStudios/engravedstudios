import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/contact/application/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransmissionButton extends ConsumerWidget {
  const TransmissionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactState = ref.watch(contactProvider);
    final notifier = ref.read(contactProvider.notifier);

    return GestureDetector(
      onTap: contactState.status == ContactStatus.idle ? notifier.submitForm : null,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: GameHUDColors.hardBlack,
          border: Border.all(width: 2, color: GameHUDColors.neonLime),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Progress Bar
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              widthFactor: contactState.progress,
              heightFactor: 1.0,
              child: Container(color: GameHUDColors.neonLime),
            ),
            
            // Text Label
            Center(
              child: Text(
                _getLabel(contactState.status),
                style: GameHUDTextStyles.terminalText.copyWith(
                  fontWeight: FontWeight.bold,
                  // Inverse color if overlapping lime? Complex clipping. 
                  // Simple hack: Hard black text always looks okay on Lime or Black bg with outline/shadow?
                  // Let's use MixBlendMode if we could, but standard text is safer.
                  color: contactState.status == ContactStatus.sending ? GameHUDColors.hardBlack : GameHUDColors.paperWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getLabel(ContactStatus status) {
    switch (status) {
      case ContactStatus.idle:
        return "[ INITIATE_TRANSMISSION ]";
      case ContactStatus.sending:
        return "UPLOADING_DATA...";
      case ContactStatus.success:
        return "HANDSHAKE CONFIRMED";
      case ContactStatus.error:
        return "CRITICAL_ERROR";
    }
  }
}
