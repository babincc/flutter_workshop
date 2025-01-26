import 'dart:math';

import 'package:dynamic_background/domain/enums/measurement_name.dart';
import 'package:dynamic_background/domain/enums/scroll_direction.dart';
import 'package:dynamic_background/domain/enums/scroller_shape.dart';
import 'package:dynamic_background/domain/models/painter/scroller_painter/scroller_painter.dart';
import 'package:dynamic_background/exceptions/mismatched_painter_and_data_exception.dart';
import 'package:flutter/material.dart';

/// This is the painter for animating stripes moving around the screen.
class ScrollerPainterStripesDiagonalForward extends ScrollerPainter {
  /// Creates a [ScrollerPainterStripesDiagonalForward] object.
  ///
  /// This is the painter for animating stripes moving around the screen.
  ScrollerPainterStripesDiagonalForward({
    required super.animation,
    required super.data,
  }) {
    if (!identical(data.shape, ScrollerShape.stripesDiagonalForward)) {
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

    final double skewedShapeWidth = sqrt(pow(data.shapeWidth, 2) * 2.0);
    final double skewedSpaceBetweenShapes =
        sqrt(pow(data.spaceBetweenShapes, 2) * 2.0);

    /// The new measurements for the shapes.
    final Map<MeasurementName, double> newMeasurements = resizeShapesAlongWidth(
      Size(skewedShapeWidth, skewedShapeWidth),
      skewedSpaceBetweenShapes,
      Size(size.longestSide + size.width, size.height),
    );

    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? skewedShapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            skewedSpaceBetweenShapes;

    // Loop through the width of the screen and draw the shapes.
    for (double i = 0.0 - (size.longestSide + shapeWidth + spaceBetweenShapes);
        i < (size.longestSide + size.width + shapeWidth + spaceBetweenShapes);
        i += shapeWidth + spaceBetweenShapes) {
      late final double tempXOffset;
      late final double xOffset;

      if (identical(data.direction, ScrollDirection.left2Right) ||
          identical(data.direction, ScrollDirection.top2Bottom)) {
        tempXOffset = i +
            animation.value *
                (size.longestSide +
                    size.width +
                    shapeWidth +
                    spaceBetweenShapes);

        if (tempXOffset > size.width) {
          xOffset = tempXOffset -
              (size.longestSide + size.width + shapeWidth + spaceBetweenShapes);
        } else {
          xOffset = tempXOffset;
        }
      } else {
        tempXOffset = i -
            animation.value *
                (size.longestSide +
                    size.width +
                    shapeWidth +
                    spaceBetweenShapes);

        if (tempXOffset <
            0.0 - (size.longestSide + shapeWidth + spaceBetweenShapes)) {
          xOffset = tempXOffset +
              (size.longestSide + size.width + shapeWidth + spaceBetweenShapes);
        } else {
          xOffset = tempXOffset;
        }
      }

      final Paint paint = Paint()
        ..color = data.color
        ..style = PaintingStyle.fill;

      final Offset topLeft = Offset(xOffset + size.height, 0.0);
      final Offset topRight = Offset(xOffset + shapeWidth + size.height, 0.0);
      final Offset bottomRight = Offset(xOffset + shapeWidth, size.height);
      final Offset bottomLeft = Offset(xOffset, size.height);

      final Path path = Path()
        ..moveTo(topLeft.dx, topLeft.dy)
        ..lineTo(topRight.dx, topRight.dy)
        ..lineTo(bottomRight.dx, bottomRight.dy)
        ..lineTo(bottomLeft.dx, bottomLeft.dy)
        ..close();

      canvas.drawPath(path, paint);
    }

    if (data.fadeEdges) {
      final double fadeWidth = data.shapeWidth;

      if (identical(data.direction, ScrollDirection.left2Right) ||
          identical(data.direction, ScrollDirection.right2Left)) {
        // Left fade.
        canvas.drawRect(
          Rect.fromLTWH(0.0, 0.0, fadeWidth, size.height),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                data.backgroundColor.withAlpha(175),
                data.backgroundColor.withAlpha(0),
              ],
            ).createShader(
              Rect.fromLTWH(0.0, 0.0, fadeWidth, size.height),
            ),
        );

        // Right fade.
        canvas.drawRect(
          Rect.fromLTWH(size.width - fadeWidth, 0.0, fadeWidth, size.height),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                data.backgroundColor.withAlpha(0),
                data.backgroundColor.withAlpha(175),
              ],
            ).createShader(
              Rect.fromLTWH(
                  size.width - fadeWidth, 0.0, fadeWidth, size.height),
            ),
        );
      } else {
        // Top fade.
        canvas.drawRect(
          Rect.fromLTWH(0.0, 0.0, size.width, fadeWidth),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                data.backgroundColor.withAlpha(175),
                data.backgroundColor.withAlpha(0),
              ],
            ).createShader(
              Rect.fromLTWH(0.0, 0.0, size.width, fadeWidth),
            ),
        );

        // Bottom fade.
        canvas.drawRect(
          Rect.fromLTWH(0.0, size.height - fadeWidth, size.width, fadeWidth),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                data.backgroundColor.withAlpha(0),
                data.backgroundColor.withAlpha(175),
              ],
            ).createShader(
              Rect.fromLTWH(
                  0.0, size.height - fadeWidth, size.width, fadeWidth),
            ),
        );
      }
    }
  }
}
