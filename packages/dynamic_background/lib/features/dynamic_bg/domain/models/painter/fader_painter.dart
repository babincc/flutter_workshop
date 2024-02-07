import 'package:dynamic_background/features/dynamic_bg/domain/models/painter/painter.dart';
import 'package:dynamic_background/features/dynamic_bg/domain/models/painter_data/fader_painter_data.dart';
import 'package:dynamic_background/utils/color_tools.dart';
import 'package:dynamic_background/utils/math_tools.dart';
import 'package:flutter/material.dart';

class FaderPainter extends Painter {
  FaderPainter({
    required this.animation,
    required this.data,
  }) : super(repaint: animation) {
    switch (data.behavior) {
      case FaderBehavior.random:
        _colors = List.from(data.colors)..add(data.colors.first);
        _colors.shuffle();
        break;
      case FaderBehavior.specifiedOrder:
        _colors = List.from(data.colors);
        break;
      case FaderBehavior.breathe:
      case FaderBehavior.sortedOrder:
        _colors = List.from(data.colors)..sortColors();
        break;
      case FaderBehavior.reverseSortedOrder:
        _colors =
            (List<Color>.from(data.colors)..sortColors()).reversed.toList();
        break;
    }
  }

  final Animation<double> animation;

  /// The data needed to paint a fader background.
  final FaderPainterData data;

  late final List<Color> _colors;

  int get _colorIndex =>
      (animation.value * data.colors.length).floor() % data.colors.length;

  double get _fraction => (animation.value * data.colors.length) % 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    switch (data.behavior) {
      case FaderBehavior.random:
        _paintRandom(canvas);
        break;
      case FaderBehavior.breathe:
        _paintBreathe(canvas);
        break;
      case FaderBehavior.specifiedOrder:
      case FaderBehavior.sortedOrder:
      case FaderBehavior.reverseSortedOrder:
        _paintStaticOrderSmooth(canvas);
        break;
    }
  }

  double _previousAnimationValue = 0.9;
  void _paintRandom(Canvas canvas) {
    if (animation.value < _previousAnimationValue) {
      _shuffleRandomColors();
    }
    _previousAnimationValue = animation.value;

    _paintStaticOrderSmooth(canvas);
  }

  void _paintBreathe(Canvas canvas) {
    // TODO
  }

  void _paintStaticOrderSmooth(Canvas canvas) {
    int colorIndex = _colorIndex;

    Color currentColor = _colors[colorIndex];
    Color nextColor = _colors[(colorIndex + 1) % _colors.length];

    double curveValue = Curves.easeInOut.transform(_fraction);

    Color blendedColor = Color.lerp(currentColor, nextColor, curveValue)!;

    canvas.drawPaint(Paint()..color = blendedColor);
  }

  void _shuffleRandomColors() {
    List<Color> randColors = [_colors.last];

    for (int i = 0; i < _colors.length; i++) {
      randColors.add(data.colors[randInt(0, data.colors.length - 1)]);
    }

    _colors
      ..clear()
      ..addAll(randColors);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
