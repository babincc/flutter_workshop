import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_circles.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_diamonds.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_squares.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter_stripes.dart';
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
      case ScrollerShape.stripes:
      case ScrollerShape.circles:
      case ScrollerShape.squares:
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
      case ScrollerShape.stripes:
        return ScrollerPainterStripes(
          animation: animation,
          data: this,
        );
      case ScrollerShape.circles:
        return ScrollerPainterCircles(
          animation: animation,
          data: this,
        );
      case ScrollerShape.squares:
        return ScrollerPainterSquares(
          animation: animation,
          data: this,
        );
      case ScrollerShape.diamonds:
        return ScrollerPainterDiamonds(
          animation: animation,
          data: this,
        );
    }
  }

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
}

/// The direction the scroller should move in.
enum ScrollDirection {
  /// The scroller should move from left to right.
  left2Right,

  /// The scroller should move from right to left.
  right2Left,

  /// The scroller should move from top to bottom.
  top2Bottom,

  /// The scroller should move from bottom to top.
  bottom2Top,
}

/// The shapes that will be scrolling across the screen.
enum ScrollerShape {
  /// The shapes will be stripes.
  stripes,

  /// The shapes will be circles.
  circles,

  /// The shapes will be squares.
  squares,

  /// The shapes will be diamonds.
  diamonds,
}

/// How to align the shapes that will be scrolling.
enum ScrollerShapeOffset {
  /// No offset.
  ///
  /// The shapes will form a perfect grid.
  none,

  /// The shapes will be offset, and form a diagonal grid.
  shift,

  /// Similar to [shift]; however, the shapes will also be moved closer
  /// together along the plane perpendicular to the direction of movement.
  shiftAndMesh,
}
