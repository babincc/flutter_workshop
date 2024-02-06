import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/painter_data.dart';
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
    this.shape = ScrollerShape.stripes,
    required this.backgroundColor,
    required this.color,
    this.shapeWidth = 24.0,
    this.spaceBetweenShapes = 24.0,
    this.fadeEdges = true,
    this.shapeOffset = ScrollerShapeOffset.none,
  }) : super(type: PainterType.scroller);

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
  /// This will be rounded to make the shapes fit to the screen size.
  final double shapeWidth;

  /// The width of the space between the shapes that will be scrolling.
  ///
  /// This will be rounded to make the shapes fit to the screen size.
  final double spaceBetweenShapes;

  /// Whether or not to fade the shapes that are entering or exiting the screen.
  final bool fadeEdges;

  /// How to align the shapes that will be scrolling.
  ///
  /// Note: This is ignored when [shape] is [ScrollerShape.stripes].
  final ScrollerShapeOffset shapeOffset;
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

  /// Similar to [shift]; however, the shapes will also be moved closer,
  /// together along the plane perpendicular to the direction of movement.
  shiftAndMesh,
}
