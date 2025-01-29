import 'package:dynamic_background/domain/enums/scroll_direction.dart';
import 'package:dynamic_background/domain/enums/scroller_shape.dart';
import 'package:dynamic_background/domain/enums/scroller_shape_offset.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_circles.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_diamonds.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_squares.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_stripes.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_stripes_diagonal_backward.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_stripes_diagonal_forward.dart';
import 'package:dynamic_background/domain/models/painter_data/painter_data.dart';
import 'package:flutter/material.dart';

/// The data needed to paint a scroller background.
///
/// A scroller background is a background that has shapes that move across the
/// screen in a certain direction.
class ScrollerPainterData extends PainterData {
  /// Creates a new [ScrollerPainterData] object.
  ///
  /// A scroller background is a background that has shapes that move across the
  /// screen in a certain direction.
  const ScrollerPainterData({
    this.direction = ScrollDirection.right2Left,
    this.shape = ScrollerShape.circles,
    required this.backgroundColor,
    required this.color,
    this.shapeWidth = 24.0,
    this.spaceBetweenShapes = 24.0,
    this.fadeEdges = true,
    this.shapeOffset = ScrollerShapeOffset.none,
  })  : assert(shapeWidth > 0.0),
        assert(spaceBetweenShapes >= 0.0);

  /// The direction the scroller should move in.
  final ScrollDirection direction;

  /// The shapes that will be scrolling across the screen.
  final ScrollerShape shape;

  /// The color of the background behind the scrolling shapes.
  final Color backgroundColor;

  /// The color of the shapes that will be scrolling.
  final Color color;

  /// The width of the shapes that will be scrolling.
  ///
  /// This will be recalculated to make the shapes fit to the screen size. It
  /// will remain very close to this value though.
  final double shapeWidth;

  /// The height of the shapes that will be scrolling.
  ///
  /// This will be recalculated to make the shapes fit to the screen size. It
  /// will remain very close to this value though.
  double get shapeHeight {
    switch (shape) {
      case ScrollerShape.circles:
      case ScrollerShape.squares:
      case ScrollerShape.stripes:
      case ScrollerShape.stripesDiagonalBackward:
      case ScrollerShape.stripesDiagonalForward:
        return shapeWidth;
      case ScrollerShape.diamonds:
        return ScrollerPainterDiamonds.calcRhombusHeight(shapeWidth);
    }
  }

  /// The width of the space between the shapes that will be scrolling.
  ///
  /// This will be recalculated to make the shapes fit to the screen size. It
  /// will remain very close to this value though.
  final double spaceBetweenShapes;

  /// Whether or not to fade the shapes that are entering or exiting the screen.
  final bool fadeEdges;

  /// How to align the shapes that will be scrolling.
  ///
  /// Note: This is ignored when [shape] is [ScrollerShape.stripes].
  final ScrollerShapeOffset shapeOffset;

  @override
  Painter getPainter(Animation<double> animation) {
    switch (shape) {
      case ScrollerShape.circles:
        return ScrollerPainterCircles(
          animation: animation,
          data: this,
        );
      case ScrollerShape.diamonds:
        return ScrollerPainterDiamonds(
          animation: animation,
          data: this,
        );
      case ScrollerShape.squares:
        return ScrollerPainterSquares(
          animation: animation,
          data: this,
        );
      case ScrollerShape.stripes:
        return ScrollerPainterStripes(
          animation: animation,
          data: this,
        );
      case ScrollerShape.stripesDiagonalBackward:
        return ScrollerPainterStripesDiagonalBackward(
          animation: animation,
          data: this,
        );
      case ScrollerShape.stripesDiagonalForward:
        return ScrollerPainterStripesDiagonalForward(
          animation: animation,
          data: this,
        );
    }
  }

  @override
  ScrollerPainterData copy() => copyWith();

  @override
  ScrollerPainterData copyWith({
    ScrollDirection? direction,
    ScrollerShape? shape,
    Color? backgroundColor,
    Color? color,
    double? shapeWidth,
    double? spaceBetweenShapes,
    bool? fadeEdges,
    ScrollerShapeOffset? shapeOffset,
  }) {
    return ScrollerPainterData(
      direction: direction ?? this.direction,
      shape: shape ?? this.shape,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      color: color ?? this.color,
      shapeWidth: shapeWidth ?? this.shapeWidth,
      spaceBetweenShapes: spaceBetweenShapes ?? this.spaceBetweenShapes,
      fadeEdges: fadeEdges ?? this.fadeEdges,
      shapeOffset: shapeOffset ?? this.shapeOffset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScrollerPainterData &&
        identical(other.direction, direction) &&
        identical(other.shape, shape) &&
        other.backgroundColor == backgroundColor &&
        other.color == color &&
        other.shapeWidth == shapeWidth &&
        other.spaceBetweenShapes == spaceBetweenShapes &&
        other.fadeEdges == fadeEdges &&
        identical(other.shapeOffset, shapeOffset);
  }

  @override
  int get hashCode => Object.hash(
        direction,
        shape,
        backgroundColor,
        color,
        shapeWidth,
        spaceBetweenShapes,
        fadeEdges,
        shapeOffset,
      );

  @override
  String toString() => 'Instance of ScrollerPainterData: {'
      'direction: $direction, '
      'shape: $shape, '
      'backgroundColor: $backgroundColor, '
      'color: $color, '
      'shapeWidth: $shapeWidth, '
      'spaceBetweenShapes: $spaceBetweenShapes, '
      'fadeEdges: $fadeEdges, '
      'shapeOffset: $shapeOffset'
      '}';
}
