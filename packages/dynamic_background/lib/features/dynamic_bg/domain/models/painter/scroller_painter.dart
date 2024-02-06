import 'dart:math';

import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/scroller_painter_data.dart';
import 'package:flutter/material.dart';

class ScrollerPainter extends Painter {
  ScrollerPainter({
    required this.animation,
    required this.data,
  }) : super(repaint: animation);

  final Animation<double> animation;

  /// The data needed to paint a scroller background.
  final ScrollerPainterData data;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = data.backgroundColor);

    switch (data.shape) {
      case ScrollerShape.stripes:
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
        break;
      case ScrollerShape.circles:
        switch (data.direction) {
          case ScrollDirection.left2Right:
          case ScrollDirection.right2Left:
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
          case ScrollDirection.top2Bottom:
          case ScrollDirection.bottom2Top:
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
        }

        break;
      case ScrollerShape.diamonds:
        _paintDiamonds(canvas, size);
        break;
    }
  }

  void _paintVerticalStripes(Canvas canvas, Size size) {
    final Map<_MeasurementName, double> newMeasurements = _resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.width,
    );

    final double shapeWidth =
        newMeasurements[_MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[_MeasurementName.spaceBetweenShapes] ??
            data.spaceBetweenShapes;

    for (double i = 0.0; i < size.width; i += shapeWidth + spaceBetweenShapes) {
      late final double xOffset;

      if (identical(data.direction, ScrollDirection.left2Right)) {
        xOffset = (i + animation.value * size.width) % size.width;
      } else {
        xOffset = (i - animation.value * size.width) % size.width;
      }

      final Paint paint = Paint()..color = data.color;

      if (_isOffScreen(xOffset, shapeWidth, size.width)) {
        Paint? antiPaint;

        if (data.fadeEdges) {
          final double alpha =
              _percentOffScreen(xOffset, shapeWidth, size.width);

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
    final Map<_MeasurementName, double> newMeasurements = _resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.height,
    );

    final double shapeWidth =
        newMeasurements[_MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[_MeasurementName.spaceBetweenShapes] ??
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

      if (_isOffScreen(yOffset, shapeWidth, size.height)) {
        Paint? antiPaint;

        if (data.fadeEdges) {
          final double alpha =
              _percentOffScreen(yOffset, shapeWidth, size.height);

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

  void _paintVerticalCircles(Canvas canvas, Size size) {
    final Map<_MeasurementName, double> newMeasurements = _resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.width,
    );

    final double shapeWidth =
        newMeasurements[_MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[_MeasurementName.spaceBetweenShapes] ??
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

        __paintVerticalCircles(
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

  void _paintVerticalCirclesShifted(Canvas canvas, Size size) {
    final Map<_MeasurementName, double> newMeasurements = _resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.width,
    );

    final double shapeWidth =
        newMeasurements[_MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[_MeasurementName.spaceBetweenShapes] ??
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

        __paintVerticalCircles(
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

  void __paintVerticalCircles(
    Canvas canvas,
    Size size,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()..color = data.color;

    if (_isOffScreen(xOffset - (shapeWidth / 2.0), shapeWidth, size.width)) {
      Paint? antiPaint;

      if (data.fadeEdges) {
        final double alpha = _percentOffScreen(
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

  void _paintHorizontalCircles(Canvas canvas, Size size) {
    final Map<_MeasurementName, double> newMeasurements = _resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.height,
    );

    final double shapeWidth =
        newMeasurements[_MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[_MeasurementName.spaceBetweenShapes] ??
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

        __paintHorizontalCircles(
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

  void _paintHorizontalCirclesShifted(Canvas canvas, Size size) {
    final Map<_MeasurementName, double> newMeasurements = _resizeShapes(
      data.shapeWidth,
      data.spaceBetweenShapes,
      size.height,
    );

    final double shapeWidth =
        newMeasurements[_MeasurementName.shapeWidth] ?? data.shapeWidth;
    final double spaceBetweenShapes =
        newMeasurements[_MeasurementName.spaceBetweenShapes] ??
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

        __paintHorizontalCircles(
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

  void __paintHorizontalCircles(
    Canvas canvas,
    Size size,
    double shapeWidth,
    double spaceBetweenShapes,
    double xOffset,
    double yOffset,
  ) {
    final Paint paint = Paint()..color = data.color;

    if (_isOffScreen(yOffset - (shapeWidth / 2.0), shapeWidth, size.height)) {
      Paint? antiPaint;

      if (data.fadeEdges) {
        final double alpha = _percentOffScreen(
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

  void _paintDiamonds(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // Adjust the color as needed
      ..strokeWidth = 2.0;

    const double diamondWidth = 20.0;
    const double spaceBetweenDiamonds = 10.0;

    for (double i = -diamondWidth;
        i < size.width;
        i += diamondWidth + spaceBetweenDiamonds) {
      final double progress =
          (i / (size.width - diamondWidth + spaceBetweenDiamonds) +
                  animation.value) %
              1.0;
      final double startY = size.height * (1 - progress);
      final double endY = size.height * progress;

      canvas.drawLine(
        Offset(i, startY),
        Offset(i + diamondWidth, size.height / 2),
        paint,
      );
      canvas.drawLine(
        Offset(i + diamondWidth, size.height / 2),
        Offset(i, endY),
        paint,
      );
      canvas.drawLine(
        Offset(i, endY),
        Offset(i - diamondWidth, size.height / 2),
        paint,
      );
      canvas.drawLine(
        Offset(i - diamondWidth, size.height / 2),
        Offset(i, startY),
        paint,
      );
    }
  }

  bool _isOffScreen(double x, double shapeWidth, double screenWidth) {
    return x < 0 || x > screenWidth - shapeWidth;
  }

  double _percentOffScreen(double x, double shapeWidth, double screenWidth) {
    late final double amountOffScreen;

    if (x < 0) {
      amountOffScreen = x;
    } else if (x > screenWidth - shapeWidth) {
      amountOffScreen = x - (screenWidth - shapeWidth);
    } else {
      amountOffScreen = 0.0;
    }

    return (amountOffScreen / shapeWidth).abs();
  }

  Map<_MeasurementName, double> _resizeShapes(
    double shapeWidth,
    double spaceBetweenShapes,
    double screenWidth,
  ) {
    final double shapeAndGap = shapeWidth + spaceBetweenShapes;
    final double shapeAndGapProportion = shapeWidth / shapeAndGap;

    final double commonFactor = screenWidth / shapeAndGap;
    final int newCommonFactor = commonFactor.round();

    final double newShapeAndGap = screenWidth / newCommonFactor;

    final double newShapeWidth = newShapeAndGap * shapeAndGapProportion;
    final double newSpaceBetweenShapes =
        newShapeAndGap * (1.0 - shapeAndGapProportion);

    return {
      _MeasurementName.shapeWidth: newShapeWidth,
      _MeasurementName.spaceBetweenShapes: newSpaceBetweenShapes,
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum _MeasurementName {
  shapeWidth,
  spaceBetweenShapes,
}
