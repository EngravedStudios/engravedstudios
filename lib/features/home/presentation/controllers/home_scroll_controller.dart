import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum ScrollTarget { games, blog, contact }

/// Singleton that holds GlobalKeys for scrollable sections on the Home Page.
/// Using singleton pattern (not Riverpod) ensures same key instances everywhere.
class HomeScrollController {
  HomeScrollController._();
  static final HomeScrollController instance = HomeScrollController._();

  // Keys for scroll targets
  final GlobalKey gamesKey = GlobalKey(debugLabel: 'gamesKey');
  final GlobalKey blogKey = GlobalKey(debugLabel: 'blogKey');
  final GlobalKey contactKey = GlobalKey(debugLabel: 'contactKey');

  // Pending scroll target when navigating from another page
  ScrollTarget? _pendingTarget;
  bool _isScrolling = false;

  bool get hasPendingScroll => _pendingTarget != null;

  void setPendingScroll(ScrollTarget target) => _pendingTarget = target;

  /// Execute pending scroll if any - called by HomePage after build
  void executePendingScroll() {
    if (_pendingTarget == null || _isScrolling) return;
    
    final target = _pendingTarget!;
    _pendingTarget = null;
    
    switch (target) {
      case ScrollTarget.games:
        scrollToGames();
        break;
      case ScrollTarget.blog:
        scrollToBlog();
        break;
      case ScrollTarget.contact:
        scrollToContact();
        break;
    }
  }

  void scrollToGames() => _scrollToKey(gamesKey);
  void scrollToBlog() => _scrollToKey(blogKey);
  void scrollToContact() => _scrollToKey(contactKey, alignment: 0.0);
  
  void scrollToTop() {
    if (_isScrolling) return;
    final context = gamesKey.currentContext; // Use any valid context to get scrollable
    if (context != null) {
      final scrollable = Scrollable.of(context);
      if (scrollable != null) {
        scrollable.position.animateTo(
          0, 
          duration: const Duration(milliseconds: 1000), 
          curve: Curves.easeInOutCubic
        );
      }
    }
  }

  void _scrollToKey(GlobalKey key, {double alignment = 0.05}) {
    final context = key.currentContext;
    if (context != null && !_isScrolling) {
      _isScrolling = true;
      // Calculate distance to target for dynamic duration
      final scrollable = Scrollable.of(context);
      final renderObject = context.findRenderObject();
      final viewport = renderObject != null ? RenderAbstractViewport.of(renderObject) : null;
      double durationMs = 1000;
       
      if (scrollable != null && viewport != null && renderObject != null) {
         final maxScroll = scrollable.position.maxScrollExtent;
         final currentScroll = scrollable.position.pixels;
         final targetOffset = viewport.getOffsetToReveal(renderObject, alignment).offset;
         // Clamp target offset to valid range
         final clampedTarget = targetOffset.clamp(0.0, maxScroll);
         
         final distance = (clampedTarget - currentScroll).abs();
         
         // Speed: 500 pixels per second?
         // distance / speed = seconds
         // e.g. 2000px / 500 = 4s (too slow)
         // e.g. 2000px / 1500 = 1.3s
         
         durationMs = (distance / 1.5).clamp(500, 2000); // Min 500ms, Max 2s
      }

      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: durationMs.toInt()),
        curve: Curves.easeInOutCubic,
        alignment: alignment,
      ).then((_) {
        _isScrolling = false;
      });
    } else if (context == null) {
      debugPrint("HomeScrollController: Key ${key.toString()} context is null");
    }
  }
}



