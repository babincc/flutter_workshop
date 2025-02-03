import 'package:dynamic_background/domain/models/lava.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/lava_painter_data.dart';
import 'package:flutter/material.dart';

/// This is the painter for animating blobs moving around the screen like a lava
/// lamp.
class LavaPainter extends Painter {
  /// Creates a [LavaPainter] object.
  ///
  /// This is the painter for animating blobs moving around the screen like a
  /// lava lamp.
  LavaPainter({
    required super.animation,
    required this.data,
  }) : super(repaint: animation);

  /// The blueprints for painting the background.
  final LavaPainterData data;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Lava lava in data.blobs) {
      _paintBlob(canvas, size, lava);
    }
  }

  void _paintBlob(Canvas canvas, Size size, Lava lava) {
    lava.stepForward(animation.value);

    __correctOutOfBoundsIssues(lava, size);

    final Paint paint = Paint()
      ..color = lava.color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, lava.blurLevel);

    canvas.drawCircle(lava.position, lava.width, paint);
  }

  void __correctOutOfBoundsIssues(Lava lava, Size size) {
    if (lava.position.dx <= 0.0) {
      lava.position = Offset(0.0, lava.position.dy);
      lava.direction = lava.direction.bounceOffWall(true);
    } else if (lava.position.dx >= size.width) {
      lava.position = Offset(size.width, lava.position.dy);
      lava.direction = lava.direction.bounceOffWall(true);
    }

    if (lava.position.dy <= 0.0) {
      lava.position = Offset(lava.position.dx, 0.0);
      lava.direction = lava.direction.bounceOffWall(false);
    } else if (lava.position.dy >= size.height) {
      lava.position = Offset(lava.position.dx, size.height);
      lava.direction = lava.direction.bounceOffWall(false);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
