import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/studio/data/team_data.dart';
import 'package:engravedstudios/features/studio/domain/team_model.dart';
import 'package:engravedstudios/features/studio/presentation/widgets/flippable_team_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nbt = context.nbt;
    final teamMembers = ref.watch(teamMembersProvider);

    return Scaffold(
      backgroundColor: nbt.surface,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 120, bottom: 60),
              child: Center(
                child: Column(
                  children: [
                    Text("ENGRAVED_STUDIOS_HQ", style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 48)),
                    const SizedBox(height: 16),
                    Container(height: 2, width: 60, color: nbt.primaryAccent),
                    const SizedBox(height: 16),
                    Text("FORGING REALITIES FROM THE VOID", style: GameHUDTextStyles.terminalText.copyWith(letterSpacing: 2)),
                  ],
                ),
              ),
            ),
          ),

          // Team Section Title
          SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
               child: Center(
                 child: Text("ACTIVE_OPERATIVES", style: GameHUDTextStyles.headlineHeavy),
               ),
             ),
          ),

          // Team Cards (Wrap for centering)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: Center(
                child: Wrap(
                  spacing: 32,
                  runSpacing: 32,
                  alignment: WrapAlignment.center,
                  children: teamMembers.map((member) => SizedBox(
                    width: 350, // Fixed width for cards
                    height: 350, // Fixed height required for Spacer() inside card
                    child: FlippableTeamCard(member: member),
                  )).toList(),
                ),
              ),
            ),
          ),

           // Work Day Photos
          SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                    Text("DAILY_OPERATIONS_LOG", style: GameHUDTextStyles.headlineHeavy),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (context, index) {
                           return Container(
                             width: 400,
                             color: Colors.grey[900],
                             alignment: Alignment.center,
                             child: Text("IMG_LOG_00${index+1}_PLACEHOLDER"),
                           );
                        },
                      ),
                    ),
                 ],
               ),
             ),
          ),

          // Map Section (Self Made Map Placeholder)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("BASE_COORDINATES", style: GameHUDTextStyles.headlineHeavy),
                  const SizedBox(height: 24),
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: GameHUDColors.inkBlack,
                      border: Border.all(color: nbt.primaryAccent, width: 2),
                    ),
                    child: Stack(
                      children: [
                        // Grid lines
                        Positioned.fill(child: GridPaper(color: nbt.borderColor.withOpacity(0.1), interval: 50)),
                        // Marker
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, size: 48, color: nbt.primaryAccent),
                              Text("HQ_LOCATION", style: GameHUDTextStyles.terminalText.copyWith(color: nbt.primaryAccent)),
                            ],
                          ),
                        ),
                        // Corner decorations
                        Positioned(
                          bottom: 16, right: 16,
                          child: Text("LAT: 52.5200 N | LON: 13.4050 E", style: GameHUDTextStyles.codeText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Impressum Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("IMPRESSUM / LEGAL_DATA", style: GameHUDTextStyles.headlineHeavy),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(32),
                    constraints: const BoxConstraints(maxWidth: 800),
                    decoration: BoxDecoration(
                      border: Border.all(color: nbt.textColor, width: 2),
                      color: nbt.surface,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "ENGRAVED STUDIOS UG (haftungsbeschränkt)",
                          style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Musterstraße 123\n48159 Muenster\nDeutschland",
                          style: GameHUDTextStyles.terminalText,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "CONTACT_UPLINK:",
                          style: GameHUDTextStyles.codeText.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "contact@engravedstudios.com\n+49 30 12345678",
                          style: GameHUDTextStyles.terminalText,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "AUTHORIZED_REPRESENTATIVE:",
                          style: GameHUDTextStyles.codeText.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Pascal Dohle",
                          style: GameHUDTextStyles.terminalText,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "COMMERCIAL_REGISTER: HRB 123456 B\nREGISTER_COURT: Amtsgericht Muenster\nVAT_ID: DE 123 456 789",
                          style: GameHUDTextStyles.codeText.copyWith(fontSize: 10, color: nbt.textColor.withOpacity(0.7)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
            // Press Kit Link
            SliverToBoxAdapter(
              child: Padding(
                 padding: const EdgeInsets.only(bottom: 48),
                 child: Center(
                   child: TextButton.icon(
                      onPressed: () => context.go('/press'),
                      icon: Icon(Icons.download, color: nbt.primaryAccent),
                      label: Text(
                        "ACCESS_PRESS_KIT // MEDIA_ASSETS",
                        style: GameHUDTextStyles.buttonText.copyWith(
                          color: nbt.primaryAccent,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                   ),
                 ),
              ),
            ),
 
             // Bottom Spacer
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
