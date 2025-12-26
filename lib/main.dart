import 'package:engravedstudios/core/navigation/app_router.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/theme/theme_controller.dart';
import 'package:engravedstudios/shared/widgets/system_boot_preloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: EngravedApp()));
}

class EngravedApp extends ConsumerStatefulWidget {
  final bool skipBoot; // For debugging
  const EngravedApp({super.key, this.skipBoot = false});

  @override
  ConsumerState<EngravedApp> createState() => _EngravedAppState();
}

class _EngravedAppState extends ConsumerState<EngravedApp> {
  bool _bootComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.skipBoot) _bootComplete = true;
  }

  @override
  Widget build(BuildContext context) {
    // Watch Theme Mode
    final themeMode = ref.watch(themeControllerProvider);
    
    if (!_bootComplete) {
       return MaterialApp(
         home: SystemBootPreloader(
           onComplete: () => setState(() => _bootComplete = true),
         ),
         debugShowCheckedModeBanner: false,
         theme: AppTheme.lightTheme, // Boot uses Light or Dark? Usually Dark/Terminal.
         // Let's force Dark for Boot or use current.
         themeMode: themeMode,
         darkTheme: AppTheme.darkTheme,
       );
    }
    
    // Watch the router provider
    final router = ref.watch(goRouterProvider);
    
    return MaterialApp.router(
      title: 'ENGRAVED STUDIOS',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
