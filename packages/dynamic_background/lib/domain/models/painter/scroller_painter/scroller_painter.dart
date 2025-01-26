import 'dart:math';

import 'package:dynamic_background/domain/enums/measurement_name.dart';
import 'package:dynamic_background/domain/enums/scroll_direction.dart';
import 'package:dynamic_background/domain/enums/scroller_shape_offset.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/scroller_painter_data.dart';
import 'package:dynamic_background/exceptions/illegal_shape_size_exception.dart';
import 'package:flutter/material.dart';

/// This is the painter for animating shapes moving around the screen.
abstract class ScrollerPainter extends Painter {
  /// Creates a [ScrollerPainter] object.
  ///
  /// This is the painter for animating shapes moving around the screen.
  ScrollerPainter({
    required super.animation,
    required this.data,
  }) : super(repaint: animation) {
    if (data.shapeWidth <= 0.0) {
      throw IllegalShapeSizeException(
        '`shapeWidth` must be greater than 0\nActual value: ${data.shapeWidth}',
      );
    }

    if (data.spaceBetweenShapes < 0.0) {
      throw IllegalShapeSizeException(
        '`spaceBetweenShapes` cannot be negative.\nActual value: '
        '${data.spaceBetweenShapes}',
      );
    }
  }

  /// The data needed to paint a scroller background.
  final ScrollerPainterData data;

  /// Used as the loop incrementor for the outer loop of the calculations for
  /// drawing shapes with the [ScrollerShapeOffset.shift] and
  /// [ScrollerShapeOffset.shiftAndMesh] arrangement.
  ///
  /// `shapeDimension` is the width or height of the shape depending on the
  /// [ScrollDirection]. Width in the case of horizontal (left/right) scrolling
  /// and height in the case of vertical (up/down) scrolling.
  double getShiftedOuterLoopProgressor(
    double shapeDimension,
    double spaceBetweenShapes,
  ) {
    if (identical(data.shapeOffset, ScrollerShapeOffset.shiftAndMesh)) {
      // a^2 + b^2 = c^2
      // b^2 = c^2 - a^2
      // c = shapeWidth
      // a = shapeWidth / 2
      // b = sqrt(c^2 - a^2)
      final double b =
          sqrt(pow(shapeDimension, 2) - pow(shapeDimension / 2, 2));
      return (shapeDimension - (shapeDimension - b)) + spaceBetweenShapes;
    } else {
      return shapeDimension + spaceBetweenShapes;
    }
  }

  /// Whether or not the shape as any parts that are off screen.
  ///
  /// `shapeDimension` is the width or height of the shape depending on the
  /// [ScrollDirection]. Width in the case of horizontal (left/right) scrolling
  /// and height in the case of vertical (up/down) scrolling.
  ///
  /// `screenDimension` is the width or height of the screen depending on the
  /// [ScrollDirection]. Width in the case of horizontal (left/right) scrolling
  /// and height in the case of vertical (up/down) scrolling.
  bool isOffScreen(double x, double shapeDimension, double screenDimension) {
    return x < 0 || x > screenDimension - shapeDimension;
  }

  /// The percentage of the shape that is off screen.
  ///
  /// - 0.0 means the shape is completely on screen.
  /// - 0.5 means the shape is halfway off screen.
  /// - 1.0 means the shape is completely off screen.
  ///
  /// `shapeDimension` is the width or height of the shape depending on the
  /// [ScrollDirection]. Width in the case of horizontal (left/right) scrolling
  /// and height in the case of vertical (up/down) scrolling.
  ///
  /// `screenDimension` is the width or height of the screen depending on the
  /// [ScrollDirection]. Width in the case of horizontal (left/right) scrolling
  /// and height in the case of vertical (up/down) scrolling.
  double percentOffScreen(
    double x,
    double shapeDimension,
    double screenDimension,
  ) {
    late final double amountOffScreen;

    if (x < 0) {
      amountOffScreen = x;
    } else if (x > screenDimension - shapeDimension) {
      amountOffScreen = x - (screenDimension - shapeDimension);
    } else {
      amountOffScreen = 0.0;
    }

    return (amountOffScreen / shapeDimension).abs();
  }

  /// This is used to resize the shapes and the space between the shapes to fit
  /// the screen width perfectly and proportionally.
  ///
  /// This is done because if the original `shapeSize.width` +
  /// `spaceBetweenShapes` is not a factor of the screen width, then the shapes
  /// will not fit the screen width perfectly. The will be too close together or
  /// too far apart at the beginning and end of the loop. The measurements
  /// remain very close to the original measurements.
  ///
  /// It returns a map:
  ///
  /// ```plaintext
  /// {
  ///   MeasurementName.shapeHeight: newShapeHeight,
  ///   MeasurementName.shapeWeight: newShapeWeight,
  ///   MeasurementName.spaceBetweenShapes: newSpaceBetweenShapes,
  /// }
  /// ```
  Map<MeasurementName, double> resizeShapesAlongWidth(
    Size shapeSize,
    double spaceBetweenShapes,
    Size canvasSize,
  ) {
    final double shapeHeightAndWidthProportion =
        shapeSize.height / shapeSize.width;

    final Map<MeasurementName, double> resizedMeasurements = _resizeShapes(
      shapeSize.width,
      spaceBetweenShapes,
      canvasSize.width,
      MeasurementName.shapeWidth,
    );

    final double newShapeWidth =
        resizedMeasurements[MeasurementName.shapeWidth] ?? shapeSize.width;

    resizedMeasurements[MeasurementName.shapeHeight] =
        newShapeWidth * shapeHeightAndWidthProportion;

    return resizedMeasurements;
  }

  /// This is used to resize the shapes and the space between the shapes to fit
  /// the screen width perfectly and proportionally.
  ///
  /// This is done because if the original `shapeSize.height` +
  /// `spaceBetweenShapes` is not a factor of the screen height, then the shapes
  /// will not fit the screen height perfectly. The will be too close together
  /// or too far apart at the beginning and end of the loop. The measurements
  /// remain very close to the original measurements.
  ///
  /// It returns a map:
  ///
  /// ```plaintext
  /// {
  ///   MeasurementName.shapeHeight: newShapeHeight,
  ///   MeasurementName.shapeWeight: newShapeWeight,
  ///   MeasurementName.spaceBetweenShapes: newSpaceBetweenShapes,
  /// }
  /// ```
  Map<MeasurementName, double> resizeShapesAlongHeight(
    Size shapeSize,
    double spaceBetweenShapes,
    Size canvasSize,
  ) {
    final double shapeWidthAndHeightProportion =
        shapeSize.width / shapeSize.height;

    final Map<MeasurementName, double> resizedMeasurements = _resizeShapes(
      shapeSize.height,
      spaceBetweenShapes,
      canvasSize.height,
      MeasurementName.shapeHeight,
    );

    final double newShapeHeight =
        resizedMeasurements[MeasurementName.shapeHeight] ?? shapeSize.height;

    resizedMeasurements[MeasurementName.shapeWidth] =
        newShapeHeight * shapeWidthAndHeightProportion;

    return resizedMeasurements;
  }

  /// A helper method for [resizeShapesAlongWidth] and
  /// [resizeShapesAlongHeight].
  Map<MeasurementName, double> _resizeShapes(
    double shapeDimension,
    double spaceBetweenShapes,
    double screenDimension,
    MeasurementName measurementName,
  ) {
    final double shapeAndGap = shapeDimension + spaceBetweenShapes;
    final double shapeAndGapProportion = shapeDimension / shapeAndGap;

    final double commonFactor = screenDimension / shapeAndGap;
    final int newCommonFactor = commonFactor.round();

    final double newShapeAndGap = screenDimension / newCommonFactor;

    final double newShapeDimension = newShapeAndGap * shapeAndGapProportion;
    final double newSpaceBetweenShapes =
        newShapeAndGap * (1.0 - shapeAndGapProportion);

    return {
      measurementName: newShapeDimension,
      MeasurementName.spaceBetweenShapes: newSpaceBetweenShapes,
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
