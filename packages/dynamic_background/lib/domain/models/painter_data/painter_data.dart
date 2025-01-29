import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:flutter/material.dart';

/// This is an abstract class that is used to create blueprints for drawing the
/// background.
abstract class PainterData {
  /// Creates a [PainterData] object.
  ///
  /// This is an abstract class that is used to create blueprints for drawing
  /// the background.
  const PainterData();

  /// Returns a [Painter] object that will paint the background.
  Painter getPainter(Animation<double> animation);

  /// Returns a copy of this object.
  PainterData copy();

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  PainterData copyWith();
}
