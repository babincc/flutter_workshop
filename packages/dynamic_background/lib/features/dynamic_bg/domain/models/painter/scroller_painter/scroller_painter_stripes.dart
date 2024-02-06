import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/scroller_painter/scroller_painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/scroller_painter_data.dart';
import 'package:flutter/material.dart';

class ScrollerPainterStripes extends ScrollerPainter {
  ScrollerPainterStripes({required super.animation, required super.data}) {
    if (!identical(data.shape, ScrollerShape.stripes)) {
      // TODO throw custom exception
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
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

  void _paintVerticalStripes(Canvas canvas, Size size) {
    final Map<MeasurementName, double> newMeasurements = resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.width,
    );

    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    for (double i = 0.0; i < size.width; i += shapeWidth + spaceBetweenShapes) {
      late final double xOffset;

      if (identical(data.direction, ScrollDirection.left2Right)) {
        xOffset = (i + animation.value * size.width) % size.width;
      } else {
        xOffset = (i - animation.value * size.width) % size.width;
      }

      final Paint paint = Paint()..color = data.color;

      if (isOffScreen(xOffset, shapeWidth, size.width)) {
        Paint? antiPaint;

        if (data.fadeEdges) {
          final double alpha =
              percentOffScreen(xOffset, shapeWidth, size.width);

          paint.color = data.color.withOpacity(1.0 - alpha);

          antiPaint = Paint()..color = data.color.withOpacity(alpha);
        }

        canvas.drawRect(
          Rect.fromLTWH(xOffset, 0.0, shapeWidth, size.height),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(
            xOffset - size.width,
            0.0,
            shapeWidth,
            size.height,
          ),
          antiPaint ?? paint,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(xOffset, 0.0, shapeWidth, size.height),
          paint,
        );
      }
    }
  }

  void _paintHorizontalStripes(Canvas canvas, Size size) {
    final Map<MeasurementName, double> newMeasurements = resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.height,
    );

    final double shapeWidth =
        newMeasurements[MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    for (double i = 0.0;
        i < size.height;
        i += shapeWidth + spaceBetweenShapes) {
      late final double yOffset;

      if (identical(data.direction, ScrollDirection.top2Bottom)) {
        yOffset = (i + animation.value * size.height) % size.height;
      } else {
        yOffset = (i - animation.value * size.height) % size.height;
      }

      final Paint paint = Paint()..color = data.color;

      if (isOffScreen(yOffset, shapeWidth, size.height)) {
        Paint? antiPaint;

        if (data.fadeEdges) {
          final double alpha =
              percentOffScreen(yOffset, shapeWidth, size.height);

          paint.color = data.color.withOpacity(1.0 - alpha);

          antiPaint = Paint()..color = data.color.withOpacity(alpha);
        }

        canvas.drawRect(
          Rect.fromLTWH(0.0, yOffset, size.width, shapeWidth),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(
            0.0,
            yOffset - size.height,
            size.width,
            shapeWidth,
          ),
          antiPaint ?? paint,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(0.0, yOffset, size.width, shapeWidth),
          paint,
        );
      }
    }
  }
}
