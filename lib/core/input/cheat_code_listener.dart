import 'package:engravedstudios/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheatCodeListener extends ConsumerStatefulWidget {
  final Widget child;
  const CheatCodeListener({super.key, required this.child});

  @override
  ConsumerState<CheatCodeListener> createState() => _CheatCodeListenerState();
}

class _CheatCodeListenerState extends ConsumerState<CheatCodeListener> {
  final List<LogicalKeyboardKey> _buffer = [];
  // Konami: Up Up Down Down Left Right Left Right B A
  final List<LogicalKeyboardKey> _konami = [
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyB,
    LogicalKeyboardKey.keyA,
  ];

  // _onKey removed in favor of Focus onKeyEvent


  void _checkCode() {
    if (_buffer.length != _konami.length) return;
    
    bool match = true;
    for (int i = 0; i < _konami.length; i++) {
        if (_buffer[i] != _konami[i]) {
            match = false;
            break;
        }
    }
    
    if (match) {
        // Unlock Blood Mode
        ref.read(themeControllerProvider.notifier).toggleBloodMode();
        _buffer.clear();
        
        // Show Feedback
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("CHEAT CODE ACTIVATED: BLOOD MODE")),
        );
    }
  }

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus once on mount to enable keyboard listening without jumping later
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: false, // Prevent scroll-on-build issues
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          _buffer.add(event.logicalKey);
          if (_buffer.length > _konami.length) {
            _buffer.removeAt(0); 
          }
          _checkCode();
        }
        return KeyEventResult.ignored; 
      },
      child: widget.child,
    );
  }
}

