import 'dart:math';

import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/responsive_utils.dart';
import 'package:engravedstudios/shared/widgets/glitch_text.dart';
import 'package:engravedstudios/shared/widgets/parallax_effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:async';

class HeroSection extends StatelessWidget {
  final ScrollController? scrollController;
  const HeroSection({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final nbt = context.nbt;
    
    // Full viewport height
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Asymmetrical Layout: 60/40 on Desktop, Stack/Column on Mobile
    return SliverToBoxAdapter(
      child: Container(
        height: screenHeight, // Full Screen
        decoration: const BoxDecoration(), // Removed clean border
        child: isDesktop 
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 6, child: _HeroContentLeft()),
                  // Removed divider
                  // Container(width: GameHUDLayout.borderWidth, color: nbt.borderColor),
                  Expanded(
                    flex: 4, 
                    child: scrollController != null 
                        ? ScrollParallax(
                            scrollController: scrollController!,
                            factor: 0.15, // Subtle parallax
                            child: _HeroVisualRight(),
                          )
                        : _HeroVisualRight(),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                   // Navbar spacing handled by alignment/padding now
                   Expanded(child: _HeroContentLeft()),
                   SizedBox(
                     height: screenHeight * 0.4, 
                     child: _HeroVisualRight()
                   ),
                ],
              ),
      ),
    );
  }
}

class _HeroContentLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    final fontSize = context.responsive<double>(48, 120, 80);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "Terminal" Header
          // "Terminal" Header
          GlitchText(
            text: "// SYSTEM.READY :: 120Hz",
            triggerOnLoad: true, // Glitch on load
            style: GameHUDTextStyles.terminalText.copyWith(
               color: nbt.primaryAccent,
               backgroundColor: nbt.shadowColor,
            ),
          ).animate().fadeIn(duration: 300.ms).shimmer().then(delay: 300.ms),
          
          const SizedBox(height: 32),
          
          _KineticLine(text: "WE ENGRAVE", fontSize: fontSize, delay: 0),
          _KineticLine(text: "DIGITAL", fontSize: fontSize, delay: 150, color: GameHUDColors.glitchRed),
          _KineticLine(text: "WORLDS.", fontSize: fontSize, delay: 300, outline: true),

          const SizedBox(height: 48),

          Container(
            padding: const EdgeInsets.only(left: 24.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: GameHUDLayout.borderWidth,
                  color: nbt.primaryAccent,
                ),
              ),
            ),
            child: Text(
              "FORGING AVANT-GARDE EXPERIENCES.\nWHERE HIGH-FASHION MEETS HARDCORE GAMING.",
              style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 24, color: nbt.textColor),
            ),
          ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.05, duration: 400.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

class _KineticLine extends StatelessWidget {
  final String text;
  final double fontSize;
  final int delay;
  final Color? color;
  final bool outline;

  const _KineticLine({
    required this.text,
    required this.fontSize,
    required this.delay,
    this.color,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    
    TextStyle style = GameHUDTextStyles.headlineHeavy.copyWith(
      fontSize: fontSize,
      color: color ?? nbt.textColor,
    );
    
    if (outline) {
      style = style.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color ?? nbt.textColor,
      );
    }

    // Letters "drop in" -> SlideY from negative + Fade + small bounce
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: style,
      ).animate().fadeIn(delay: delay.ms, duration: 400.ms)
      .slideY(begin: -0.5, end: 0, curve: Curves.easeOutCubic),
    );
  }
}

class _HeroVisualRight extends StatefulWidget {
  @override
  State<_HeroVisualRight> createState() => _HeroVisualRightState();
}

class _HeroVisualRightState extends State<_HeroVisualRight> {
  YoutubePlayerController? _controller;
  StreamSubscription? _playerStateSubscription;
  bool _isHovered = false;
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    try {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: 'Y2VYlRB6I6o',
        autoPlay: true,
        params: const YoutubePlayerParams(
          mute: true,
          showControls: false,
          showFullscreenButton: false,
          loop: true,
          playsInline: true, // Important for iOS/Web
          enableCaption: false,
        ),
      );
      
      // Listen for state changes
      _playerStateSubscription = _controller!.stream.listen(
        (value) {
          // Player is ready
          if (value.playerState == PlayerState.playing && _isLoading) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          }
          // Manual loop
          if (value.playerState == PlayerState.ended) {
            _controller?.seekTo(seconds: 0);
            _controller?.playVideo();
          }
        },
        onError: (error) {
          debugPrint('YouTube player error: $error');
          if (mounted) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        },
      );

      // Timeout for loading
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isLoading) {
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      debugPrint('Failed to init YouTube player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    
    // Hover Animation Values (Pop Effect)
    final double shadowSize = _isHovered ? 14 : 8;
    final Matrix4 transform = _isHovered 
        ? Matrix4.translationValues(-4, -4, 0) 
        : Matrix4.identity();

    return Center(
      child: Transform.rotate(
        angle: 3 * pi / 180, // 3 degrees tilt
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            transform: transform,
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: nbt.surface,
              border: Border.all(width: 3, color: nbt.borderColor),
              boxShadow: [
                BoxShadow(
                  color: nbt.shadowColor,
                  offset: Offset(shadowSize, shadowSize),
                )
              ]
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // YouTube Player or Fallback
                if (!_hasError && _controller != null)
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 1600,
                      height: 900,
                      child: IgnorePointer(
                        child: YoutubePlayer(
                          controller: _controller!,
                          aspectRatio: 16/9,
                        ),
                      ),
                    ),
                  )
                else
                  // Fallback: Animated gradient or static visual
                  _FallbackVisual(),

                // Loading Indicator
                if (_isLoading)
                  Container(
                    color: nbt.surface,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_outline, size: 48, color: nbt.primaryAccent),
                          const SizedBox(height: 12),
                          Text(
                            "LOADING_FEED...",
                            style: GameHUDTextStyles.terminalText.copyWith(color: nbt.textColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Interaction Blocker
                Positioned.fill(
                  child: PointerInterceptor(
                    intercepting: true,
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
      .moveY(begin: -10, end: 10, duration: 2000.ms, curve: Curves.easeInOutQuad),
    );
  }
}

/// Fallback visual when YouTube fails to load
class _FallbackVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nbt = context.nbt;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            nbt.primaryAccent.withOpacity(0.3),
            nbt.surface,
            GameHUDColors.glitchRed.withOpacity(0.2),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videogame_asset, size: 64, color: nbt.primaryAccent),
            const SizedBox(height: 16),
            Text(
              "ENGRAVED\nSTUDIOS",
              textAlign: TextAlign.center,
              style: GameHUDTextStyles.headlineHeavy.copyWith(
                fontSize: 28,
                color: nbt.textColor,
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
    .shimmer(duration: 3000.ms, color: nbt.primaryAccent.withOpacity(0.1));
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 1;
    
    // Draw simple grid
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => oldDelegate.color != color;
}
