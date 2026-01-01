import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevLogPostPage extends StatelessWidget {
  final String id;
  const DevLogPostPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    
    // Mock Data based on ID
    // In real app, fetch from repository
    final title = "DEVLOG_ENTRY_#$id";
    final content = "This is a placeholder for the full content of DevLog #$id.\n\n"
        "Here we would discuss the technical details of the implementation, "
        "show code snippets, and provide deep dives into the game mechanics.\n\n"
        "Features discussed:\n"
        "- Networking\n"
        "- Shaders\n"
        "- AI Behavior";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                TextButton.icon(
                  onPressed: () => context.go('/'),
                  icon: Icon(Icons.arrow_back, color: nbt.primaryAccent),
                  label: Text("RETURN_TO_BASE", style: GameHUDTextStyles.buttonText.copyWith(color: nbt.primaryAccent)),
                ),
                const SizedBox(height: 32),
                
                // Content
                Text(title, style: GameHUDTextStyles.headlineHeavy),
                const SizedBox(height: 24),
                Text(content, style: GameHUDTextStyles.bodyText.copyWith(height: 1.6)),
                
                const SizedBox(height: 64),
                Container(height: 1, color: nbt.borderColor),
                const SizedBox(height: 32),
                
                // Giscus / Comments Section
                Text("COMMUNICATION_UPLINK // COMMENTS", style: GameHUDTextStyles.titleLarge),
                const SizedBox(height: 24),
                
                // Placeholder for Giscus
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: nbt.borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.comment, color: nbt.primaryAccent, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        "GISCUS MODULE INITIALIZING...",
                        style: GameHUDTextStyles.terminalText.copyWith(color: nbt.primaryAccent),
                      ),
                       Text(
                        "(Requires GitHub Repository ID Configuration)",
                        style: GameHUDTextStyles.codeText.copyWith(color: GameHUDColors.ghostGray),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
