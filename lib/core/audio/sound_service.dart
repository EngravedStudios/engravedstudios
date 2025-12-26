import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_service.g.dart';

@riverpod
SoundService soundService(Ref ref) {
  return SoundService();
}

class SoundService {
  final AudioPlayer _effectPlayer = AudioPlayer();
  //final AudioPlayer _musicPlayer = AudioPlayer(); // Ambience

  // Click sound removed by user request
  // Future<void> playClick() async {}

  Future<void> playTransition() async {
    try {
      await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource('sounds/transition.mp3'));
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playGlitch() async {
    try {
      await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource('sounds/glitch.mp3'));
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  Future<void> playBoot() async {
    try {
       // Boot sound might be longer/ambience
       if (_effectPlayer.state == PlayerState.playing) await _effectPlayer.stop();
       await _effectPlayer.play(AssetSource('sounds/boot.mp3'));
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  void dispose() {
    _effectPlayer.dispose();
    // _musicPlayer.dispose();
  }
}
