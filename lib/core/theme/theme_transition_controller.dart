import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransitionState { idle, expanding, covered, fading }

class ThemeTransitionState {
  final TransitionState status;
  final double transitionPercent; // 0.0 to 1.0 (Expansion progress)
  final Offset? origin; // Start position of the warp

  const ThemeTransitionState({
    this.status = TransitionState.idle,
    this.transitionPercent = 0.0,
    this.origin,
  });

  ThemeTransitionState copyWith({
    TransitionState? status,
    double? transitionPercent,
    Offset? origin,
  }) {
    return ThemeTransitionState(
      status: status ?? this.status,
      transitionPercent: transitionPercent ?? this.transitionPercent,
      origin: origin ?? this.origin,
    );
  }
}

class ThemeTransitionController extends Notifier<ThemeTransitionState> {
  @override
  ThemeTransitionState build() {
    return const ThemeTransitionState();
  }

  void startExpansion(Offset origin) {
    state = state.copyWith(
       status: TransitionState.expanding, 
       transitionPercent: 0.0,
       origin: origin,
    );
  }

  void updateProgress(double percent) {
    state = state.copyWith(transitionPercent: percent);
  }

  void setCovered() {
    state = state.copyWith(status: TransitionState.covered, transitionPercent: 1.0);
  }

  void startFading() {
    state = state.copyWith(status: TransitionState.fading);
  }

  void reset() {
    state = state.copyWith(status: TransitionState.idle, transitionPercent: 0.0);
  }
}

final themeTransitionProvider = NotifierProvider<ThemeTransitionController, ThemeTransitionState>(ThemeTransitionController.new);
