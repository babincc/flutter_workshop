import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/fader_painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/painter_data.dart';
import 'package:flutter/material.dart';

/// The data needed to paint a fader background.
///
/// A fader background is a background that fades between a set of colors.
class FaderPainterData extends PainterData {
  /// Creates a new [FaderPainterData] object.
  ///
  /// A fader background is a background that fades between a set of colors.
  FaderPainterData({
    this.behavior = FaderBehavior.random,
    required this.colors,
  });

  final FaderBehavior behavior;

  /// The colors the fader will go through.
  final List<Color> colors;

  @override
  Painter getPainter(Animation<double> animation) {
    return FaderPainter(
      animation: animation,
      data: this,
    );
  }
}

/// The behavior of the fader.
enum FaderBehavior {
  /// The colors will cycle randomly, like a playlist on shuffle.
  random,

  /// The colors will cycle in such a way to imitate breathing.
  breathe,

  /// The colors will cycle in the order they were set when the
  /// [FaderPainterData] object was initiated.
  specifiedOrder,

  /// The colors will be sorted and cycle in the order of the sorted list.
  sortedOrder,

  /// The colors will be sorted in reverse and cycle in the order of the
  /// reverse sorted list.
  reverseSortedOrder,
}
