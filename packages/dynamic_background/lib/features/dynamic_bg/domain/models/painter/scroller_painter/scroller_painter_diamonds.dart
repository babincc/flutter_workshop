import 'dart:math';

import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/scroller_painter/scroller_painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/scroller_painter_data.dart';
import 'package:flutter/material.dart';

class ScrollerPainterDiamonds extends ScrollerPainter {
  ScrollerPainterDiamonds({required super.animation, required super.data}) {
    if (!identical(data.shape, ScrollerShape.diamonds)) {
      // TODO throw custom exception
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = data.backgroundColor);

    switch (data.direction) {
      case ScrollDirection.left2Right:
      case ScrollDirection.right2Left:
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
      case ScrollDirection.top2Bottom:
      case ScrollDirection.bottom2Top:
        switch (data.shapeOffset) {
          case ScrollerShapeOffset.none:
            _paintHorizontalDiamonds(canvas, size);
            break;
          case ScrollerShapeOffset.shift:
          case ScrollerShapeOffset.shiftAndMesh:
            _paintHorizontalCirclesDiamonds(canvas, size);
            break;
        }
        break;
    }
  }

  void _paintVerticalDiamonds(Canvas canvas, Size size) {
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

    final double endLoop =
        (size.height / 2.0) + ((shapeWidth + spaceBetweenShapes) / 2.0);

    for (double i = 0.0; i < endLoop; i += shapeWidth + spaceBetweenShapes) {
      for (double ii = 0.0;
          ii < size.width;
          ii += shapeWidth + spaceBetweenShapes) {
        late final double xOffset;
        late final double yOffset;

        if (i + shapeWidth + spaceBetweenShapes >= endLoop) {
          yOffset = (size.height / 2.0) - (i - 1);
        } else {
          yOffset = (i - size.height / 2.0) % size.height;
        }

        if (identical(data.direction, ScrollDirection.left2Right)) {
          xOffset = (ii + animation.value * size.width) % size.width;
        } else {
          xOffset = (ii - animation.value * size.width) % size.width;
        }

        __paintVerticalDiamonds(
          canvas,
          size,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }
    }
  }

  void _paintVerticalDiamondsShifted(Canvas canvas, Size size) {
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

    final double endLoop =
        (size.height / 2.0) + ((shapeWidth + spaceBetweenShapes) / 2.0);

    late final double progressor;
    if (identical(data.shapeOffset, ScrollerShapeOffset.shiftAndMesh)) {
      // a^2 + b^2 = c^2
      // b^2 = c^2 - a^2
      // c = shapeWidth
      // a = shapeWidth / 2
      // b = sqrt(c^2 - a^2)
      final double b = sqrt(pow(shapeWidth, 2) - pow(shapeWidth / 2, 2));
      progressor = (shapeWidth - (shapeWidth - b)) + spaceBetweenShapes;
    } else {
      progressor = shapeWidth + spaceBetweenShapes;
    }

    int rowCounter = 0;
    for (double i = 0.0; i < endLoop; i += progressor) {
      for (double ii = 0.0;
          ii < size.width;
          ii += shapeWidth + spaceBetweenShapes) {
        late final double xOffset;
        late final double yOffset;

        if (i + shapeWidth + spaceBetweenShapes >= endLoop) {
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

        __paintVerticalDiamonds(
          canvas,
          size,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }

      rowCounter++;
    }
  }

  void __paintVerticalDiamonds(
    Canvas canvas,
    Size size,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()..color = data.color;

    if (isOffScreen(xOffset - (shapeWidth / 2.0), shapeWidth, size.width)) {
      Paint? antiPaint;

      if (data.fadeEdges) {
        final double alpha = percentOffScreen(
            xOffset - (shapeWidth / 2.0), shapeWidth, size.width);

        paint.color = data.color.withOpacity(1.0 - alpha);

        antiPaint = Paint()..color = data.color.withOpacity(alpha);
      }

      canvas.drawCircle(
        Offset(xOffset, yOffset),
        shapeWidth / 2,
        paint,
      );
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
        canvas.drawCircle(
          Offset(xOffset, size.height - yOffset),
          shapeWidth / 2,
          paint,
        );
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
    } else {
      canvas.drawCircle(
        Offset(xOffset, yOffset),
        shapeWidth / 2,
        paint,
      );

      canvas.drawCircle(
        Offset(xOffset, size.height - yOffset),
        shapeWidth / 2,
        paint,
      );
    }
  }

  void _paintHorizontalDiamonds(Canvas canvas, Size size) {
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

    final double endLoop =
        (size.width / 2.0) + ((shapeWidth + spaceBetweenShapes) / 2.0);

    for (double i = 0.0; i < endLoop; i += shapeWidth + spaceBetweenShapes) {
      for (double ii = 0.0;
          ii < size.height;
          ii += shapeWidth + spaceBetweenShapes) {
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

        __paintHorizontalDiamonds(
          canvas,
          size,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }
    }
  }

  void _paintHorizontalCirclesDiamonds(Canvas canvas, Size size) {
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

    final double endLoop =
        (size.width / 2.0) + ((shapeWidth + spaceBetweenShapes) / 2.0);

    late final double progressor;
    if (identical(data.shapeOffset, ScrollerShapeOffset.shiftAndMesh)) {
      // a^2 + b^2 = c^2
      // b^2 = c^2 - a^2
      // c = shapeWidth
      // a = shapeWidth / 2
      // b = sqrt(c^2 - a^2)
      final double b = sqrt(pow(shapeWidth, 2) - pow(shapeWidth / 2, 2));
      progressor = (shapeWidth - (shapeWidth - b)) + spaceBetweenShapes;
    } else {
      progressor = shapeWidth + spaceBetweenShapes;
    }

    int rowCounter = 0;
    for (double i = 0.0; i < endLoop; i += progressor) {
      for (double ii = 0.0;
          ii < size.height;
          ii += shapeWidth + spaceBetweenShapes) {
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
                    ((shapeWidth / 2.0) + (spaceBetweenShapes / 2.0))) %
                size.height;
          } else {
            yOffset = (ii + animation.value * size.height) % size.height;
          }
        } else {
          if (rowCounter % 2 == 0) {
            yOffset = ((ii - animation.value * size.height) -
                    ((shapeWidth / 2.0) + (spaceBetweenShapes / 2.0))) %
                size.height;
          } else {
            yOffset = (ii - animation.value * size.height) % size.height;
          }
        }

        __paintHorizontalDiamonds(
          canvas,
          size,
          shapeWidth,
          spaceBetweenShapes,
          xOffset,
          yOffset,
        );
      }

      rowCounter++;
    }
  }

  void __paintHorizontalDiamonds(
    Canvas canvas,
    Size size,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()..color = data.color;

    if (isOffScreen(yOffset - (shapeWidth / 2.0), shapeWidth, size.height)) {
      Paint? antiPaint;

      if (data.fadeEdges) {
        final double alpha = percentOffScreen(
            yOffset - (shapeWidth / 2.0), shapeWidth, size.height);

        paint.color = data.color.withOpacity(1.0 - alpha);

        antiPaint = Paint()..color = data.color.withOpacity(alpha);
      }

      canvas.drawCircle(
        Offset(xOffset, yOffset),
        shapeWidth / 2,
        paint,
      );
      canvas.drawCircle(
        Offset(xOffset, yOffset - size.height),
        shapeWidth / 2,
        antiPaint ?? paint,
      );
      canvas.drawCircle(
        Offset(xOffset, yOffset + size.height),
        shapeWidth / 2,
        antiPaint ?? paint,
      );
      if (xOffset != size.width / 2.0) {
        canvas.drawCircle(
          Offset(size.width - xOffset, yOffset),
          shapeWidth / 2,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width - xOffset, yOffset - size.height),
          shapeWidth / 2,
          antiPaint ?? paint,
        );
        canvas.drawCircle(
          Offset(size.width - xOffset, yOffset + size.height),
          shapeWidth / 2,
          antiPaint ?? paint,
        );
      }
    } else {
      canvas.drawCircle(
        Offset(xOffset, yOffset),
        shapeWidth / 2,
        paint,
      );

      canvas.drawCircle(
        Offset(size.width - xOffset, yOffset),
        shapeWidth / 2,
        paint,
      );
    }
  }
}
