import 'package:engravedstudios/core/input/cursor_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin for widgets that need hover state tracking with cursor feedback.
mixin HoverableMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool isHovered = false;

  void onEnter(PointerEnterEvent event) {
    setState(() => isHovered = true);
    CursorController.instance.setHover();
  }

  void onExit(PointerExitEvent event) {
    if (!mounted) return;
    setState(() => isHovered = false);
    CursorController.instance.setDefault();
  }
}

