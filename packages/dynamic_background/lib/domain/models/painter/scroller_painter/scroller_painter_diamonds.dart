import 'dart:math';

import 'package:dynamic_background/domain/enums/measurement_name.dart';
import 'package:dynamic_background/domain/enums/scroll_direction.dart';
import 'package:dynamic_background/domain/enums/scroller_shape.dart';
import 'package:dynamic_background/domain/enums/scroller_shape_offset.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter.dart';
import 'package:dynamic_background/exceptions/mismatched_painter_and_data_exception.dart';
import 'package:dynamic_background/utils/math_tools.dart';
import 'package:flutter/material.dart';

/// This is the painter for animating diamonds moving around the screen.
class ScrollerPainterDiamonds extends ScrollerPainter {
  /// Creates a [ScrollerPainterDiamonds] object.
  ///
  /// This is the painter for animating diamonds moving around the screen.
  ScrollerPainterDiamonds({required super.animation, required super.data}) {
    if (!identical(data.shape, ScrollerShape.diamonds)) {
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
            _paintHorizontalDiamonds(canvas, size);
            break;
          case ScrollerShapeOffset.shift:
          case ScrollerShapeOffset.shiftAndMesh:
            _paintHorizontalDiamondsShifted(canvas, size);
            break;
        }
        break;
      case ScrollDirection.top2Bottom:
      case ScrollDirection.bottom2Top:
        switch (data.shapeOffset) {
          case ScrollerShapeOffset.none:
            _paintVerticalDiamonds(canvas, size);
            break;
          case ScrollerShapeOffset.shift:
          case ScrollerShapeOffset.shiftAndMesh:
            _paintVerticalDiamondsShifted(canvas, size);
            break;
        }
        break;
    }
  }

  /// Paints the diamonds which move horizontally.
  void _paintHorizontalDiamonds(Canvas canvas, Size size) {
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

        __paintHorizontalDiamonds(
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

  /// Paints the diamonds which move horizontally and are offset from each
  /// other.
  void _paintHorizontalDiamondsShifted(Canvas canvas, Size size) {
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

        __paintHorizontalDiamonds(
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

  /// Paints the diamonds which move horizontally.
  ///
  /// xOffset and yOffset are the center of the diamond.
  void __paintHorizontalDiamonds(
    Canvas canvas,
    Size size,
    double shapeHeight,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()
      ..color = data.color
      ..style = PaintingStyle.fill;

    final Offset left = Offset(xOffset - (shapeWidth / 2.0), yOffset);
    final Offset top = Offset(xOffset, yOffset - (shapeHeight / 2.0));
    final Offset right = Offset(xOffset + (shapeWidth / 2.0), yOffset);
    final Offset bottom = Offset(xOffset, yOffset + (shapeHeight / 2.0));

    final Path path1 = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..close();

    final Path path2 = Path()
      ..moveTo(left.dx, size.height - left.dy)
      ..lineTo(top.dx, size.height - top.dy)
      ..lineTo(right.dx, size.height - right.dy)
      ..lineTo(bottom.dx, size.height - bottom.dy)
      ..close();

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

      final Path path3 = Path()
        ..moveTo(left.dx - size.width, size.height - left.dy)
        ..lineTo(top.dx - size.width, size.height - top.dy)
        ..lineTo(right.dx - size.width, size.height - right.dy)
        ..lineTo(bottom.dx - size.width, size.height - bottom.dy)
        ..close();

      final Path path4 = Path()
        ..moveTo(left.dx + size.width, size.height - left.dy)
        ..lineTo(top.dx + size.width, size.height - top.dy)
        ..lineTo(right.dx + size.width, size.height - right.dy)
        ..lineTo(bottom.dx + size.width, size.height - bottom.dy)
        ..close();

      final Path path5 = Path()
        ..moveTo(left.dx - size.width, left.dy)
        ..lineTo(top.dx - size.width, top.dy)
        ..lineTo(right.dx - size.width, right.dy)
        ..lineTo(bottom.dx - size.width, bottom.dy)
        ..close();

      final Path path6 = Path()
        ..moveTo(left.dx + size.width, left.dy)
        ..lineTo(top.dx + size.width, top.dy)
        ..lineTo(right.dx + size.width, right.dy)
        ..lineTo(bottom.dx + size.width, bottom.dy)
        ..close();

      // Above the halfway point of the screen.
      canvas.drawPath(path3, antiPaint ?? paint);
      canvas.drawPath(path4, antiPaint ?? paint);
      if (yOffset != size.height / 2.0) {
        // Below the halfway point of the screen.
        canvas.drawPath(path5, antiPaint ?? paint);
        canvas.drawPath(path6, antiPaint ?? paint);
      }
    }

    // Above the halfway point of the screen.
    canvas.drawPath(path1, paint);
    if (yOffset != size.height / 2.0) {
      // Below the halfway point of the screen.
      canvas.drawPath(path2, paint);
    }
  }

  /// Paints the diamonds which move vertically.
  void _paintVerticalDiamonds(Canvas canvas, Size size) {
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

        __paintVerticalDiamonds(
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

  /// Paints the diamonds which move vertically and are offset from each other.
  void _paintVerticalDiamondsShifted(Canvas canvas, Size size) {
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

        __paintVerticalDiamonds(
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

  /// Paints the diamonds which move vertically.
  ///
  /// xOffset and yOffset are the center of the diamond.
  void __paintVerticalDiamonds(
    Canvas canvas,
    Size size,
    double shapeHeight,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()
      ..color = data.color
      ..style = PaintingStyle.fill;

    final Offset left = Offset(xOffset - (shapeWidth / 2.0), yOffset);
    final Offset top = Offset(xOffset, yOffset - (shapeHeight / 2.0));
    final Offset right = Offset(xOffset + (shapeWidth / 2.0), yOffset);
    final Offset bottom = Offset(xOffset, yOffset + (shapeHeight / 2.0));

    final Path path1 = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..close();

    final Path path2 = Path()
      ..moveTo(size.width - left.dx, left.dy)
      ..lineTo(size.width - top.dx, top.dy)
      ..lineTo(size.width - right.dx, right.dy)
      ..lineTo(size.width - bottom.dx, bottom.dy)
      ..close();

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

      final Path path3 = Path()
        ..moveTo(left.dx, left.dy - size.height)
        ..lineTo(top.dx, top.dy - size.height)
        ..lineTo(right.dx, right.dy - size.height)
        ..lineTo(bottom.dx, bottom.dy - size.height)
        ..close();

      final Path path4 = Path()
        ..moveTo(left.dx, left.dy + size.height)
        ..lineTo(top.dx, top.dy + size.height)
        ..lineTo(right.dx, right.dy + size.height)
        ..lineTo(bottom.dx, bottom.dy + size.height)
        ..close();

      final Path path5 = Path()
        ..moveTo(size.width - left.dx, left.dy - size.height)
        ..lineTo(size.width - top.dx, top.dy - size.height)
        ..lineTo(size.width - right.dx, right.dy - size.height)
        ..lineTo(size.width - bottom.dx, bottom.dy - size.height)
        ..close();

      final Path path6 = Path()
        ..moveTo(size.width - left.dx, left.dy + size.height)
        ..lineTo(size.width - top.dx, top.dy + size.height)
        ..lineTo(size.width - right.dx, right.dy + size.height)
        ..lineTo(size.width - bottom.dx, bottom.dy + size.height)
        ..close();

      // Above the halfway point of the screen.
      canvas.drawPath(path3, antiPaint ?? paint);
      canvas.drawPath(path4, antiPaint ?? paint);
      if (xOffset != size.width / 2.0) {
        // Below the halfway point of the screen.
        canvas.drawPath(path5, antiPaint ?? paint);
        canvas.drawPath(path6, antiPaint ?? paint);
      }
    }

    // Above the halfway point of the screen.
    canvas.drawPath(path1, paint);
    if (xOffset != size.width / 2.0) {
      // Below the halfway point of the screen.
      canvas.drawPath(path2, paint);
    }
  }

  /// The height of the diamond is calculated and returned.
  static double calcRhombusHeight(double shapeWidth) {
    double angleTheta = _getAngleTheta();

    // Return the height of the diamond.
    return 2.0 * ((shapeWidth / 2.0) / tan(angleTheta));
  }

  /// The width of the diamond is calculated and returned.
  static double calcRhombusWidth(double shapeHeight) {
    double angleTheta = _getAngleTheta();

    // Return the width of the diamond.
    return 2.0 * ((shapeHeight / 2.0) * tan(angleTheta));
  }

  /// A helper method for [calcRhombusHeight] and [calcRhombusWidth].
  ///
  /// In the future, [angleA] can be changed to make differently proportioned
  /// diamonds.
  static double _getAngleTheta() {
    /// The left and right angles of the rhombus, in degrees.
    const double angleA = 120.0;

    /// The top and bottom angles of the rhombus, in degrees.
    const double angleB = 180.0 - angleA;

    /// Half the top and bottom angles of the rhombus, in radians.
    ///
    /// This is used to calculate the height of the diamond using right triangle
    /// trigonometry.
    return deg2Rad(angleB / 2.0);
  }
}
