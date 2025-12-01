import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_themes.dart';

import '../../providers/auth_provider.dart';
import 'user_settings_tab.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeType =
        ref.watch(themeNotifierProvider).valueOrNull ??
        AppThemeType.defaultLight;
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Appearance Section
              Text(
                'Appearance',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  children: AppThemeType.values.map((type) {
                    final isSelected = currentThemeType == type;
                    return RadioGroup(
                      groupValue: currentThemeType,
                      onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(themeNotifierProvider.notifier)
                                .setTheme(value);
                          }
                        },
                      child: RadioListTile<AppThemeType>(
                        value: type,
                        title: Text(
                          type.displayName,
                          style: GoogleFonts.inter(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        activeColor: theme.colorScheme.primary,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),

              // User Settings Section (if logged in)
              if (user != null) ...[const UserSettingsTab()],
            ],
          ),
        ),
      ),
    );
  }

  // Helper method removed as it's now inlined
}
