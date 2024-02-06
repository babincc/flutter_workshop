import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/scroller_painter_data.dart';
import 'package:flutter/material.dart';

abstract class ScrollerPainter extends Painter {
  ScrollerPainter({
    required this.animation,
    required this.data,
  }) : super(repaint: animation);

  final Animation<double> animation;

  /// The data needed to paint a scroller background.
  final ScrollerPainterData data;

  bool isOffScreen(double x, double shapeWidth, double screenWidth) {
    return x < 0 || x > screenWidth - shapeWidth;
  }

  double percentOffScreen(double x, double shapeWidth, double screenWidth) {
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

  Map<MeasurementName, double> resizeShapes(
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
      MeasurementName.shapeWidth: newShapeWidth,
      MeasurementName.spaceBetweenShapes: newSpaceBetweenShapes,
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum MeasurementName {
  shapeWidth,
  spaceBetweenShapes,
}
