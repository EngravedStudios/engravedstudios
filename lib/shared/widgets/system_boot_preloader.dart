import 'dart:async';
import 'dart:math';

import 'package:engravedstudios/core/audio/sound_service.dart';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemBootPreloader extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  const SystemBootPreloader({super.key, required this.onComplete});

  @override
  ConsumerState<SystemBootPreloader> createState() => _SystemBootPreloaderState();
}

class _SystemBootPreloaderState extends ConsumerState<SystemBootPreloader> {
  double _progress = 0.0;
  String _currentTask = "INITIALIZING_SYSTEM...";
  
  final List<String> _bootTasks = [
    "LOADING_SHADERS...",
    "CALIBRATING_GRAVITY_WELLS...",
    "ENGRAVING_ASSETS...",
    "ESTABLISHING_UPLINK...",
    "SYNCING_NEURAL_NET...",
    "OPTIMIZING_FLUX_CAPACITORS...",
    "SYSTEM_READY."
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    // Attempt to play boot sound (May fail due to autoplay policy)
    // ref.read(soundServiceProvider).playBoot(); // Disabled by user request

    // Start Animation
    for (int i = 0; i < _bootTasks.length; i++) {
        await Future.delayed(Duration(milliseconds: Random().nextInt(300) + 200));
        if (!mounted) return;
        setState(() {
          _currentTask = _bootTasks[i];
          _progress = (i + 1) / _bootTasks.length;
        });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    widget.onComplete();
  }

  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    // Removed "Click to Start" screen
    return Scaffold(
      backgroundColor: GameHUDColors.hardBlack,
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: GameHUDColors.neonLime, width: 2),
            color: GameHUDColors.inkBlack,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SYSTEM_BOOT // ENGRAVED_OS",
                style: GameHUDTextStyles.terminalText.copyWith(
                  color: GameHUDColors.neonLime,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Progress Bar
              Container(
                height: 4,
                width: double.infinity,
                color: GameHUDColors.hardBlack,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _progress.clamp(0.0, 1.0),
                  child: Container(color: GameHUDColors.neonLime),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                "${(_progress * 100).toInt()}% :: $_currentTask",
                 style: GameHUDTextStyles.terminalText.copyWith(
                  color: GameHUDColors.ghostGray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
