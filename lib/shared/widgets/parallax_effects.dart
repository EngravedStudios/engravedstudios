import 'package:flutter/material.dart';

class MouseParallax extends StatefulWidget {
  final Widget child;
  final double factor;

  const MouseParallax({super.key, required this.child, this.factor = 10.0});

  @override
  State<MouseParallax> createState() => _MouseParallaxState();
}

class _MouseParallaxState extends State<MouseParallax> {
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        // Calculate offset relative to center of screen for best effect
        // or just local center?
        // Local center is safer for simpler widgets.
        final size = context.size;
        if (size != null) {
          final center = Offset(size.width / 2, size.height / 2);
          final local = event.localPosition;
          setState(() {
            _mousePos = (local - center);
          });
        }
      },
      child: Transform.translate(
        offset: Offset(
          (_mousePos.dx / 100) * widget.factor,
          (_mousePos.dy / 100) * widget.factor,
        ),
        child: widget.child,
      ),
    );
  }
}

class ScrollParallax extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final double factor;

  const ScrollParallax({
    super.key,
    required this.child,
    required this.scrollController,
    this.factor = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final offset = scrollController.hasClients ? scrollController.offset : 0.0;
        return Transform.translate(
          offset: Offset(0, offset * factor),
          child: child,
        );
      },
      child: child,
    );
  }
}
