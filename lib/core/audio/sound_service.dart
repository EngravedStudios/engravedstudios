import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _isMuted = false;

  SoundService() {
    _loadMute();
  }

  Future<void> _loadMute() async {
    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool('mute_audio') ?? false;
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mute_audio', _isMuted);
  }
  
  bool get isMuted => _isMuted;

  Future<void> playHover() async {
    if (_isMuted) return;
    try {
      if (_effectPlayer.state == PlayerState.playing) await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource('sounds/hover.mp3'), volume: 0.5);
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }
  
  Future<void> playClick() async {
    if (_isMuted) return;
    try {
      if (_effectPlayer.state == PlayerState.playing) await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource('sounds/klick.mp3'));
    } catch (e) {
       debugPrint("Audio Error: $e");
    }
  }

  Future<void> playTransition() async {
    if (_isMuted) return;
    try {
      await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource('sounds/transition.mp3'));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  Future<void> playGlitch() async {
    if (_isMuted) return;
    try {
      await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource('sounds/glitch.mp3'));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  Future<void> playBoot() async {
    if (_isMuted) return;
    try {
       // Boot sound might be longer/ambience
       if (_effectPlayer.state == PlayerState.playing) await _effectPlayer.stop();
       await _effectPlayer.play(AssetSource('sounds/boot.mp3'));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  void dispose() {
    _effectPlayer.dispose();
    // _musicPlayer.dispose();
  }
}
