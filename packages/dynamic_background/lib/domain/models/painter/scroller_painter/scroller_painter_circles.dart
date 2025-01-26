import 'package:dynamic_background/domain/enums/measurement_name.dart';
import 'package:dynamic_background/domain/enums/scroll_direction.dart';
import 'package:dynamic_background/domain/enums/scroller_shape.dart';
import 'package:dynamic_background/domain/enums/scroller_shape_offset.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter.dart';
import 'package:dynamic_background/exceptions/mismatched_painter_and_data_exception.dart';
import 'package:flutter/material.dart';

/// This is the painter for animating circles moving around the screen.
class ScrollerPainterCircles extends ScrollerPainter {
  /// Creates a [ScrollerPainterCircles] object.
  ///
  /// This is the painter for animating circles moving around the screen.
  ScrollerPainterCircles({required super.animation, required super.data}) {
    if (!identical(data.shape, ScrollerShape.circles)) {
      throw MismatchedPainterAndDataException(
        'The provided data is not compatible with this painter. Invalid shape.',
        this,
        data,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background color.
    canvas.drawPaint(Paint()..color = data.backgroundColor);

    switch (data.direction) {
      case ScrollDirection.left2Right:
      case ScrollDirection.right2Left:
        switch (data.shapeOffset) {
          case ScrollerShapeOffset.none:
            _paintHorizontalCircles(canvas, size);
            break;
          case ScrollerShapeOffset.shift:
          case ScrollerShapeOffset.shiftAndMesh:
            _paintHorizontalCirclesShifted(canvas, size);
            break;
        }
        break;
      case ScrollDirection.top2Bottom:
      case ScrollDirection.bottom2Top:
        switch (data.shapeOffset) {
          case ScrollerShapeOffset.none:
            _paintVerticalCircles(canvas, size);
            break;
          case ScrollerShapeOffset.shift:
          case ScrollerShapeOffset.shiftAndMesh:
            _paintVerticalCirclesShifted(canvas, size);
            break;
        }
        break;
    }
  }

  /// Paints the circles which move horizontally.
  void _paintHorizontalCircles(Canvas canvas, Size size) {
    /// The new measurements for the shapes.
    final Map<MeasurementName, double> newMeasurements = resizeShapesAlongWidth(
      Size(data.shapeWidth, data.shapeHeight),
      data.spaceBetweenShapes,
      size,
    );

    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double shapeHeight =
        newMeasurements[MeasurementName.shapeHeight] ?? data.shapeHeight;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    /// When to stop the loop, since all shapes should be drawn.
    final double endLoop =
        (size.height / 2.0) + ((shapeHeight + spaceBetweenShapes) / 2.0);

    // Loop through half the height of the screen and draw the shapes.
    for (double i = 0.0; i < endLoop; i += shapeHeight + spaceBetweenShapes) {
      // Loop through the width of the screen and draw the shapes.
      for (double ii = 0.0;
          ii < size.width;
          ii += shapeWidth + spaceBetweenShapes) {
        late final double xOffset;
        late final double yOffset;

        if (i + shapeHeight + spaceBetweenShapes >= endLoop) {
          yOffset = (size.height / 2.0) - (i - 1);
        } else {
          yOffset = (i - size.height / 2.0) % size.height;
        }

        if (identical(data.direction, ScrollDirection.left2Right)) {
          xOffset = (ii + animation.value * size.width) % size.width;
        } else {
          xOffset = (ii - animation.value * size.width) % size.width;
        }

        __paintHorizontalCircles(
          canvas,
          size,
          shapeHeight,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }
    }
  }

  /// Paints the circles which move horizontally and are offset from each other.
  void _paintHorizontalCirclesShifted(Canvas canvas, Size size) {
    /// The new measurements for the shapes.
    final Map<MeasurementName, double> newMeasurements = resizeShapesAlongWidth(
      Size(data.shapeWidth, data.shapeHeight),
      data.spaceBetweenShapes,
      size,
    );

    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double shapeHeight =
        newMeasurements[MeasurementName.shapeHeight] ?? data.shapeHeight;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    /// When to stop the loop, since all shapes should be drawn.
    final double endLoop =
        (size.height / 2.0) + ((shapeHeight + spaceBetweenShapes) / 2.0);

    /// How much the outer loop should increment.
    final double progressor = getShiftedOuterLoopProgressor(
      shapeHeight,
      spaceBetweenShapes,
    );

    /// How many rows have been drawn.
    int rowCounter = 0;

    // Loop through half the height of the screen and draw the shapes.
    for (double i = 0.0; i < endLoop; i += progressor) {
      // Loop through the width of the screen and draw the shapes.
      for (double ii = 0.0;
          ii < size.width;
          ii += shapeWidth + spaceBetweenShapes) {
        late final double xOffset;
        late final double yOffset;

        if (i + shapeHeight + spaceBetweenShapes >= endLoop) {
          yOffset = (size.height / 2.0) - (i - 1);
        } else {
          yOffset = (i - size.height / 2.0) % size.height;
        }

        if (identical(data.direction, ScrollDirection.left2Right)) {
          if (rowCounter % 2 == 0) {
            xOffset = ((ii + animation.value * size.width) -
                    ((shapeWidth / 2.0) + (spaceBetweenShapes / 2.0))) %
                size.width;
          } else {
            xOffset = (ii + animation.value * size.width) % size.width;
          }
        } else {
          if (rowCounter % 2 == 0) {
            xOffset = ((ii - animation.value * size.width) -
                    ((shapeWidth / 2.0) + (spaceBetweenShapes / 2.0))) %
                size.width;
          } else {
            xOffset = (ii - animation.value * size.width) % size.width;
          }
        }

        __paintHorizontalCircles(
          canvas,
          size,
          shapeHeight,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }

      rowCounter++;
    }
  }

  /// Paints the circles which move horizontally.
  ///
  /// xOffset and yOffset are the center of the circle.
  void __paintHorizontalCircles(
    Canvas canvas,
    Size size,
    double shapeHeight,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()..color = data.color;

    // If the shape is partially or completely off screen, do this.
    if (isOffScreen(xOffset - (shapeWidth / 2.0), shapeWidth, size.width)) {
      Paint? antiPaint;

      if (data.fadeEdges) {
        final double alpha = percentOffScreen(
            xOffset - (shapeWidth / 2.0), shapeWidth, size.width);

        paint.color = data.color.withAlpha((255.0 * (1.0 - alpha)).round());

        antiPaint = Paint()
          ..color = data.color.withAlpha((255.0 * alpha).round());
      }

      // Above the halfway point of the screen.
      canvas.drawCircle(
        Offset(xOffset - size.width, yOffset),
        shapeWidth / 2,
        antiPaint ?? paint,
      );
      canvas.drawCircle(
        Offset(xOffset + size.width, yOffset),
        shapeWidth / 2,
        antiPaint ?? paint,
      );
      if (yOffset != size.height / 2.0) {
        // Below the halfway point of the screen.
        canvas.drawCircle(
          Offset(xOffset - size.width, size.height - yOffset),
          shapeWidth / 2,
          antiPaint ?? paint,
        );
        canvas.drawCircle(
          Offset(xOffset + size.width, size.height - yOffset),
          shapeWidth / 2,
          antiPaint ?? paint,
        );
      }
    }

    // Above the halfway point of the screen.
    canvas.drawCircle(
      Offset(xOffset, yOffset),
      shapeWidth / 2,
      paint,
    );
    if (yOffset != size.height / 2.0) {
      // Below the halfway point of the screen.
      canvas.drawCircle(
        Offset(xOffset, size.height - yOffset),
        shapeWidth / 2,
        paint,
      );
    }
  }

  /// Paints the circles which move vertically.
  void _paintVerticalCircles(Canvas canvas, Size size) {
    /// The new measurements for the shapes.
    final Map<MeasurementName, double> newMeasurements =
        resizeShapesAlongHeight(
      Size(data.shapeWidth, data.shapeHeight),
      data.spaceBetweenShapes,
      size,
    );

    final double shapeHeight =
        newMeasurements[MeasurementName.shapeHeight] ?? data.shapeHeight;
    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    /// When to stop the loop, since all shapes should be drawn.
    final double endLoop =
        (size.width / 2.0) + ((shapeWidth + spaceBetweenShapes) / 2.0);

    // Loop through half the width of the screen and draw the shapes.
    for (double i = 0.0; i < endLoop; i += shapeWidth + spaceBetweenShapes) {
      // Loop through the height of the screen and draw the shapes.
      for (double ii = 0.0;
          ii < size.height;
          ii += shapeHeight + spaceBetweenShapes) {
        late final double xOffset;
        late final double yOffset;

        if (i + shapeWidth + spaceBetweenShapes >= endLoop) {
          xOffset = (size.width / 2.0) - (i - 1);
        } else {
          xOffset = (i - size.width / 2.0) % size.width;
        }

        if (identical(data.direction, ScrollDirection.top2Bottom)) {
          yOffset = (ii + animation.value * size.height) % size.height;
        } else {
          yOffset = (ii - animation.value * size.height) % size.height;
        }

        __paintVerticalCircles(
          canvas,
          size,
          shapeHeight,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }
    }
  }

  /// Paints the circles which move vertically and are offset from each other.
  void _paintVerticalCirclesShifted(Canvas canvas, Size size) {
    /// The new measurements for the shapes.
    final Map<MeasurementName, double> newMeasurements =
        resizeShapesAlongHeight(
      Size(data.shapeWidth, data.shapeHeight),
      data.spaceBetweenShapes,
      size,
    );

    final double shapeHeight =
        newMeasurements[MeasurementName.shapeHeight] ?? data.shapeHeight;
    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    /// When to stop the loop, since all shapes should be drawn.
    final double endLoop =
        (size.width / 2.0) + ((shapeWidth + spaceBetweenShapes) / 2.0);

    /// How much the outer loop should increment.
    final double progressor = getShiftedOuterLoopProgressor(
      shapeWidth,
      spaceBetweenShapes,
    );

    /// How many rows have been drawn.
    int rowCounter = 0;

    // Loop through half the width of the screen and draw the shapes.
    for (double i = 0.0; i < endLoop; i += progressor) {
      // Loop through the height of the screen and draw the shapes.
      for (double ii = 0.0;
          ii < size.height;
          ii += shapeHeight + spaceBetweenShapes) {
        late final double xOffset;
        late final double yOffset;

        if (i + shapeWidth + spaceBetweenShapes >= endLoop) {
          xOffset = (size.width / 2.0) - (i - 1);
        } else {
          xOffset = (i - size.width / 2.0) % size.width;
        }

        if (identical(data.direction, ScrollDirection.top2Bottom)) {
          if (rowCounter % 2 == 0) {
            yOffset = ((ii + animation.value * size.height) -
                    ((shapeHeight / 2.0) + (spaceBetweenShapes / 2.0))) %
                size.height;
          } else {
            yOffset = (ii + animation.value * size.height) % size.height;
          }
        } else {
          if (rowCounter % 2 == 0) {
            yOffset = ((ii - animation.value * size.height) -
                    ((shapeHeight / 2.0) + (spaceBetweenShapes / 2.0))) %
                size.height;
          } else {
            yOffset = (ii - animation.value * size.height) % size.height;
          }
        }

        __paintVerticalCircles(
          canvas,
          size,
          shapeHeight,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }

      rowCounter++;
    }
  }

  /// Paints the circles which move vertically.
  ///
  /// xOffset and yOffset are the center of the circle.
  void __paintVerticalCircles(
    Canvas canvas,
    Size size,
    double shapeHeight,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()..color = data.color;

    // If the shape is partially or completely off screen, do this.
    if (isOffScreen(yOffset - (shapeHeight / 2.0), shapeHeight, size.height)) {
      Paint? antiPaint;

      if (data.fadeEdges) {
        final double alpha = percentOffScreen(
            yOffset - (shapeHeight / 2.0), shapeHeight, size.height);

        paint.color = data.color.withAlpha((255.0 * (1.0 - alpha)).round());

        antiPaint = Paint()
          ..color = data.color.withAlpha((255.0 * alpha).round());
      }

      // Above the halfway point of the screen.
      canvas.drawCircle(
        Offset(xOffset, yOffset - size.height),
        shapeHeight / 2,
        antiPaint ?? paint,
      );
      canvas.drawCircle(
        Offset(xOffset, yOffset + size.height),
        shapeHeight / 2,
        antiPaint ?? paint,
      );
      if (xOffset != size.width / 2.0) {
        // Below the halfway point of the screen.
        canvas.drawCircle(
          Offset(size.width - xOffset, yOffset - size.height),
          shapeHeight / 2,
          antiPaint ?? paint,
        );
        canvas.drawCircle(
          Offset(size.width - xOffset, yOffset + size.height),
          shapeHeight / 2,
          antiPaint ?? paint,
        );
      }
    }

    // Above the halfway point of the screen.
    canvas.drawCircle(
      Offset(xOffset, yOffset),
      shapeHeight / 2,
      paint,
    );
    if (xOffset != size.width / 2.0) {
      // Below the halfway point of the screen.
      canvas.drawCircle(
        Offset(size.width - xOffset, yOffset),
        shapeHeight / 2,
        paint,
      );
    }
  }
}
