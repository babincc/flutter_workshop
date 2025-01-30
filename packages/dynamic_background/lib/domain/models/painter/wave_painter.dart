import 'dart:math';

import 'package:dynamic_background/domain/enums/wave_direction.dart';
import 'package:dynamic_background/domain/enums/wave_gravity_direction.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/wave_painter_data.dart';
import 'package:dynamic_background/domain/models/wave.dart';
import 'package:dynamic_background/exceptions/empty_wave_list_exception.dart';
import 'package:dynamic_background/exceptions/invalid_wave_offset_exception.dart';
import 'package:flutter/material.dart';

/// This is the painter for wave animations.
class WavePainter extends Painter {
  /// Creates a [WavePainter] object.
  ///
  /// This is the painter for wave animations.
  WavePainter({
    required super.animation,
    required this.data,
  }) : super(repaint: animation) {
    if (data.waves.isEmpty) {
      throw const EmptyWaveListException('`waves` cannot be empty.');
    }
  }

  /// The blueprints for painting the background.
  final WavePainterData data;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Wave wave in data.waves) {
      _validateOffset(wave, size);

      switch (wave.direction) {
        case WaveDirection.right2Left:
        case WaveDirection.left2Right:
          _paintHorizontal(canvas, size, wave);
          break;
        case WaveDirection.bottom2Top:
        case WaveDirection.top2Bottom:
          _paintVertical(canvas, size, wave);
          break;
      }
    }
  }

  /// Validates the offset of the wave.
  ///
  /// Throws an [InvalidWaveOffsetException] if the offset is not valid.
  void _validateOffset(Wave wave, Size size) {
    if (wave.useScaledOffset) {
      if (wave.offset < 0.0 || wave.offset > 1.0) {
        throw InvalidWaveOffsetException(
          '`offset` must be between 0.0 and 1.0 (inclusive) because '
          '`useScaledOffset` was set to true for this wave. Actual value: '
          '${wave.offset}',
        );
      }
    } else {
      switch (wave.direction) {
        case WaveDirection.right2Left:
        case WaveDirection.left2Right:
          if (wave.offset < 0.0 || wave.offset > size.height) {
            throw InvalidWaveOffsetException(
              '`offset` must be between 0.0 and the available height '
              '[${size.height}] (inclusive). Actual value: ${wave.offset}',
            );
          }
          break;
        case WaveDirection.bottom2Top:
        case WaveDirection.top2Bottom:
          if (wave.offset < 0.0 || wave.offset > size.width) {
            throw InvalidWaveOffsetException(
              '`offset` must be between 0.0 and the available width '
              '[${size.width}] (inclusive). Actual value: ${wave.offset}',
            );
          }
          break;
      }
    }
  }

  /// Paints the waves that are moving from right to left or left to right.
  void _paintHorizontal(Canvas canvas, Size size, Wave wave) {
    /// Whether or not the wave is moving from left to right.
    ///
    /// If this is `true`, the wave is moving from left to right. If this is
    /// `false`, the wave is moving from right to left.
    final bool isLeftToRight =
        identical(wave.direction, WaveDirection.left2Right);

    /// The y-coordinate of the center line of the wave.
    final double centerLineY;
    if (wave.useScaledOffset) {
      centerLineY = wave.offset * size.height;
    } else {
      centerLineY = wave.offset;
    }

    /// The leftmost point of the wave.
    final Offset origin;

    /// The control point for the wave.
    final Offset controlPoint;

    /// The rightmost point of the wave.
    final Offset endPoint;

    final double rawPhase = animation.value + wave.phase;
    final double phase = rawPhase == 1.0 ? 1.0 : rawPhase % 1.0;
    final double animationValue = phase * wave.frequency * 2.0 * pi;

    origin = Offset(
      0.0,
      centerLineY + (wave.amplitude * sin(animationValue)),
    );
    endPoint = Offset(
      size.width,
      centerLineY + (wave.amplitude * sin(animationValue + pi)),
    );

    if (isLeftToRight) {
      controlPoint = Offset(
        size.width * 0.5,
        centerLineY +
            (wave.amplitude * sin(animationValue + (0.5 * (3.0 * pi)))),
      );
    } else {
      controlPoint = Offset(
        size.width * 0.5,
        centerLineY + (wave.amplitude * sin(animationValue + (0.5 * pi))),
      );
    }

    /// The paint that fills in the space below the wave.
    final Paint fillPaint = Paint()
      ..color = wave.color
      ..style = PaintingStyle.fill
      ..strokeWidth = wave.lineThickness;

    /// The paint that draws the line of the wave.
    final Paint linePaint = Paint()
      ..color = wave.lineColor ?? Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = wave.lineThickness;

    final Path fillPath = Path();
    final Path linePath = Path();

    fillPath.moveTo(origin.dx, origin.dy);
    fillPath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    linePath.moveTo(origin.dx, origin.dy);
    linePath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    if (identical(wave.gravityDirection, WaveGravityDirection.down)) {
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0.0, size.height);
      fillPath.close();
    } else {
      fillPath.lineTo(size.width, 0.0);
      fillPath.lineTo(0.0, 0.0);
      fillPath.close();
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  /// Paints the waves that are moving from top to bottom or bottom to top.
  void _paintVertical(Canvas canvas, Size size, Wave wave) {
    /// Whether or not the wave is moving from top to bottom.
    ///
    /// If this is `true`, the wave is moving from top to bottom. If this is
    /// `false`, the wave is moving from bottom to top.
    final bool isTopToBottom =
        identical(wave.direction, WaveDirection.top2Bottom);

    /// The x-coordinate of the center line of the wave.
    final double centerLineX;
    if (wave.useScaledOffset) {
      centerLineX = wave.offset * size.width;
    } else {
      centerLineX = wave.offset;
    }

    /// The topmost point of the wave.
    final Offset origin;

    /// The control point for the wave.
    final Offset controlPoint;

    /// The bottommost point of the wave.
    final Offset endPoint;

    final double rawPhase = animation.value + wave.phase;
    final double phase = rawPhase == 1.0 ? 1.0 : rawPhase % 1.0;
    final double animationValue = phase * wave.frequency * 2.0 * pi;

    origin = Offset(
      centerLineX + (wave.amplitude * sin(animationValue)),
      0.0,
    );
    endPoint = Offset(
      centerLineX + (wave.amplitude * sin(animationValue + pi)),
      size.height,
    );

    if (isTopToBottom) {
      controlPoint = Offset(
        centerLineX +
            (wave.amplitude * sin(animationValue + (0.5 * (3.0 * pi)))),
        size.height * 0.5,
      );
    } else {
      controlPoint = Offset(
        centerLineX + (wave.amplitude * sin(animationValue + (0.5 * pi))),
        size.height * 0.5,
      );
    }

    /// The paint that fills in the space below the wave.
    final Paint fillPaint = Paint()
      ..color = wave.color
      ..style = PaintingStyle.fill
      ..strokeWidth = wave.lineThickness;

    /// The paint that draws the line of the wave.
    final Paint linePaint = Paint()
      ..color = wave.lineColor ?? Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = wave.lineThickness;

    final Path fillPath = Path();
    final Path linePath = Path();

    fillPath.moveTo(origin.dx, origin.dy);
    fillPath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    linePath.moveTo(origin.dx, origin.dy);
    linePath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    if (identical(wave.gravityDirection, WaveGravityDirection.left)) {
      fillPath.lineTo(0.0, size.height);
      fillPath.lineTo(0.0, 0.0);
      fillPath.close();
    } else {
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(size.width, 0.0);
      fillPath.close();
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
