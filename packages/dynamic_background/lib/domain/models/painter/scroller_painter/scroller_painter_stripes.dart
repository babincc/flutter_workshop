import 'package:dynamic_background/domain/enums/measurement_name.dart';
import 'package:dynamic_background/domain/enums/scroll_direction.dart';
import 'package:dynamic_background/domain/enums/scroller_shape.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter.dart';
import 'package:dynamic_background/exceptions/mismatched_painter_and_data_exception.dart';
import 'package:flutter/material.dart';

/// This is the painter for animating stripes moving around the screen.
class ScrollerPainterStripes extends ScrollerPainter {
  /// Creates a [ScrollerPainterStripes] object.
  ///
  /// This is the painter for animating stripes moving around the screen.
  ScrollerPainterStripes({required super.animation, required super.data}) {
    if (!identical(data.shape, ScrollerShape.stripes)) {
      throw MismatchedPainterAndDataException(
        'The provided data is not compatible with this painter. Invalid shape.',
        this,
        data,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint the background color.
    canvas.drawPaint(Paint()..color = data.backgroundColor);

    switch (data.direction) {
      case ScrollDirection.left2Right:
      case ScrollDirection.right2Left:
        _paintVerticalStripes(canvas, size);
        break;
      case ScrollDirection.top2Bottom:
      case ScrollDirection.bottom2Top:
        _paintHorizontalStripes(canvas, size);
        break;
    }
  }

  /// Paints the vertical stripes which move horizontally.
  void _paintVerticalStripes(Canvas canvas, Size size) {
    /// The new measurements for the shapes.
    final Map<MeasurementName, double> newMeasurements = resizeShapesAlongWidth(
      Size(data.shapeWidth, data.shapeHeight),
      data.spaceBetweenShapes,
      size,
    );

    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    // Loop through the width of the screen and draw the shapes.
    for (double i = 0.0; i < size.width; i += shapeWidth + spaceBetweenShapes) {
      late final double xOffset;

      if (identical(data.direction, ScrollDirection.left2Right)) {
        xOffset = (i + animation.value * size.width) % size.width;
      } else {
        xOffset = (i - animation.value * size.width) % size.width;
      }

      final Paint paint = Paint()..color = data.color;

      // If the shape is partially or completely off screen, do this.
      if (isOffScreen(xOffset, shapeWidth, size.width)) {
        Paint? antiPaint;

        if (data.fadeEdges) {
          final double alpha =
              percentOffScreen(xOffset, shapeWidth, size.width);

          paint.color = data.color.withAlpha((255.0 * (1.0 - alpha)).round());

          antiPaint = Paint()
            ..color = data.color.withAlpha((255.0 * alpha).round());
        }

        canvas.drawRect(
          Rect.fromLTWH(
            xOffset - size.width,
            0.0,
            shapeWidth,
            size.height,
          ),
          antiPaint ?? paint,
        );
      }

      canvas.drawRect(
        Rect.fromLTWH(xOffset, 0.0, shapeWidth, size.height),
        paint,
      );
    }
  }

  /// Paints the horizontal stripes which move vertically.
  void _paintHorizontalStripes(Canvas canvas, Size size) {
    /// The new measurements for the shapes.
    final Map<MeasurementName, double> newMeasurements =
        resizeShapesAlongHeight(
      Size(data.shapeWidth, data.shapeHeight),
      data.spaceBetweenShapes,
      size,
    );

    final double shapeHeight =
        newMeasurements[MeasurementName.shapeHeight] ?? data.shapeHeight;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    // Loop through the height of the screen and draw the shapes.
    for (double i = 0.0;
        i < size.height;
        i += shapeHeight + spaceBetweenShapes) {
      late final double yOffset;

      if (identical(data.direction, ScrollDirection.top2Bottom)) {
        yOffset = (i + animation.value * size.height) % size.height;
      } else {
        yOffset = (i - animation.value * size.height) % size.height;
      }

      final Paint paint = Paint()..color = data.color;

      // If the shape is partially or completely off screen, do this.
      if (isOffScreen(yOffset, shapeHeight, size.height)) {
        Paint? antiPaint;

        if (data.fadeEdges) {
          final double alpha =
              percentOffScreen(yOffset, shapeHeight, size.height);

          paint.color = data.color.withAlpha((255.0 * (1.0 - alpha)).round());

          antiPaint = Paint()
            ..color = data.color.withAlpha((255.0 * alpha).round());
        }

        canvas.drawRect(
          Rect.fromLTWH(
            0.0,
            yOffset - size.height,
            size.width,
            shapeHeight,
          ),
          antiPaint ?? paint,
        );
      }

      canvas.drawRect(
        Rect.fromLTWH(0.0, yOffset, size.width, shapeHeight),
        paint,
      );
    }
  }
}
