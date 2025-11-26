import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/theme_provider.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current theme schema
    final themeSchema = ref.watch(currentThemeSchemaProvider);

    return MaterialApp(
      title: 'Noted - Engraved Studios',
      debugShowCheckedModeBanner: false,
      theme: themeSchema.themeData.copyWith(
        textTheme: GoogleFonts.merriweatherTextTheme(
          themeSchema.themeData.textTheme,
        ).copyWith(
          // Use Space Mono for specific UI elements (Labels, Buttons, etc.)
          labelLarge: GoogleFonts.spaceMono(
            textStyle: themeSchema.themeData.textTheme.labelLarge,
          ),
          labelMedium: GoogleFonts.spaceMono(
            textStyle: themeSchema.themeData.textTheme.labelMedium,
          ),
          labelSmall: GoogleFonts.spaceMono(
            textStyle: themeSchema.themeData.textTheme.labelSmall,
          ),
          titleSmall: GoogleFonts.spaceMono(
            textStyle: themeSchema.themeData.textTheme.titleSmall,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
