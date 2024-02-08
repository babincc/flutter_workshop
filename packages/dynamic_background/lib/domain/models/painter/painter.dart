import 'package:flutter/material.dart';

/// An abstract class that uses the blueprints for drawing the background.
abstract class Painter extends CustomPainter {
  /// Creates a [Painter] object.
  ///
  /// An abstract class that uses the blueprints for drawing the background.
  Painter({required this.animation, super.repaint});

  /// The animation that controls the painter.
  final Animation<double> animation;
}
