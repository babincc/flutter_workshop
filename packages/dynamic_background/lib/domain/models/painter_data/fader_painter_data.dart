import 'package:dynamic_background/domain/models/painter/fader_painter.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/painter_data.dart';
import 'package:flutter/material.dart';

/// The data needed to paint a fader background.
///
/// A fader background is a background that fades between a set of colors.
class FaderPainterData extends PainterData {
  /// Creates a new [FaderPainterData] object.
  ///
  /// A fader background is a background that fades between a set of colors.
  const FaderPainterData({
    this.behavior = FaderBehavior.specifiedOrder,
    required this.colors,
  }) : assert(colors.length > 0, true);

  /// The behavior of the fader.
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

  @override
  FaderPainterData copyWith({
    FaderBehavior? behavior,
    List<Color>? colors,
  }) {
    return FaderPainterData(
      behavior: behavior ?? this.behavior,
      colors: colors ?? List.from(this.colors),
    );
  }
}

/// The behavior of the fader.
enum FaderBehavior {
  /// The colors will cycle in the order they were set when the
  /// [FaderPainterData] object was initiated.
  specifiedOrder,

  /// The colors will be sorted and cycle in the order of the sorted list.
  sortedOrder,

  /// The colors will be sorted in reverse and cycle in the order of the
  /// reverse sorted list.
  reverseSortedOrder,

  /// The colors will cycle randomly, like a playlist on shuffle.
  random,

  /// The colors will cycle in such a way to imitate breathing.
  breathe,

  /// The colors will cycle in such a way to imitate a heartbeat.
  pulse,
}
