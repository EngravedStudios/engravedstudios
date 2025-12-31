import 'package:engravedstudios/core/audio/widgets/with_sound.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/games/data/store_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreButton extends ConsumerWidget {
  final String appId;
  final String url;
  final String label; // "STEAM", "ITCH.IO"
  final Color? color;

  const StoreButton({
    super.key,
    required this.appId,
    required this.url,
    this.label = "STEAM",
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only fetch if we have an app ID (Steam)
    final storeDataAsync = appId.isNotEmpty && label.toUpperCase() == 'STEAM' 
        ? ref.watch(steamDataProvider(appId)) 
        : const AsyncValue.data(null);

    return WithSound(
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(4), // Slight rounding or 0
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.onSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GameHUDTextStyles.buttonText.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              const SizedBox(width: 12),
              // Price Tag / Data
              storeDataAsync.when(
                data: (data) {
                  if (data == null) return const SizedBox.shrink();
                  return Row(
                    children: [
                      Container(width: 1, height: 24, color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5)),
                      const SizedBox(width: 12),
                      if (data.isDiscounted) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          color: GameHUDColors.neonLime, // Highlight
                          child: Text(
                            '-${data.discountPercent}%',
                            style: GameHUDTextStyles.codeText.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GameHUDColors.hardBlack,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data.formattedPrice,
                          style: GameHUDTextStyles.buttonText.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ] else
                        Text(
                          data.formattedPrice,
                          style: GameHUDTextStyles.buttonText.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                    ],
                  );
                },
                error: (_, __) => const SizedBox.shrink(),
                loading: () => SizedBox(
                  width: 16, height: 16, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.onSecondary)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
