import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract base class defining the contract for responsive layout strategies.
/// Each concrete strategy (Mobile, Tablet, Desktop) must implement the `build` method.
abstract class ResponsiveLayoutStrategy {
  Widget build(BuildContext context, WidgetRef ref);
}