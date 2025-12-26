import 'package:flutter/material.dart';

class HeavyScrollPhysics extends ScrollPhysics {
  const HeavyScrollPhysics({super.parent});

  @override
  HeavyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HeavyScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 5.0; // Harder to flick

  @override
  double get dragStartDistanceMotionThreshold => 4.0; 

  @override
  double get maxFlingVelocity => 6000.0; 
  
  // Custom spring description could go here via createBallisticSimulation for advanced feel
}
