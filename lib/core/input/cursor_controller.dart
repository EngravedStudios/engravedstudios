import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Cursor types for the custom cursor overlay
enum CursorType { defaultCursor, hover, click }

/// Singleton controller for cursor state - bypasses Riverpod for performance.
/// 
/// Using a singleton with ValueNotifier ensures:
/// - No Riverpod watch/rebuild overhead
/// - Direct, synchronous state updates
/// - Minimal memory allocation on hover events
class CursorController extends ChangeNotifier {
  CursorController._();
  static final CursorController instance = CursorController._();
  
  // Separate ValueNotifier for high-frequency position updates
  final ValueNotifier<Offset> position = ValueNotifier(Offset.zero);

  CursorType _type = CursorType.defaultCursor;
  CursorType get type => _type;

  void setHover() {
    if (_type != CursorType.hover) {
      _type = CursorType.hover;
      notifyListeners();
    }
  }

  void setDefault() {
    if (_type != CursorType.defaultCursor) {
      _type = CursorType.defaultCursor;
      notifyListeners();
    }
  }

  void setClick() {
    if (_type != CursorType.click) {
      _type = CursorType.click;
      notifyListeners();
    }
  }
}
