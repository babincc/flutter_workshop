import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/painter.dart';
import 'package:flutter/material.dart';

abstract class PainterData {
  PainterData();

  /// Returns a [Painter] object that will paint the background.
  Painter getPainter(Animation<double> animation);
}
