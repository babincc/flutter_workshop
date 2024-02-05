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
        _paintCircles(canvas, size);
        break;
      case ScrollerShape.diamonds:
        _paintDiamonds(canvas, size);
        break;
    }
  }

  void _paintVerticalStripes(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = data.backgroundColor);

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
    canvas.drawPaint(Paint()..color = data.backgroundColor);

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

  void _paintCircles(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // Adjust the color as needed
      ..strokeWidth = 2.0;

    const double circleRadius = 10.0;
    const double spaceBetweenCircles = 20.0;

    for (double i = -circleRadius;
        i < size.width;
        i += circleRadius * 2 + spaceBetweenCircles) {
      final double progress =
          (i / (size.width - circleRadius * 2 + spaceBetweenCircles) +
                  animation.value) %
              1.0;
      final double startY = size.height * (1 - progress);

      canvas.drawCircle(
        Offset(i, startY),
        circleRadius,
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

    return amountOffScreen / shapeWidth;
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
