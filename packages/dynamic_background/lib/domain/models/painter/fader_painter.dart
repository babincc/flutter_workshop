import 'package:dynamic_background/domain/enums/fader_behavior.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/fader_painter_data.dart';
import 'package:dynamic_background/exceptions/empty_color_list_exception.dart';
import 'package:dynamic_background/utils/color_tools.dart';
import 'package:dynamic_background/utils/math_tools.dart';
import 'package:flutter/material.dart';

/// This is the painter for color fading animations.
class FaderPainter extends Painter {
  /// Creates a [FaderPainter] object.
  ///
  /// This is the painter for color fading animations.
  FaderPainter({
    required super.animation,
    required this.data,
  }) : super(repaint: animation) {
    if (data.colors.isEmpty) {
      throw const EmptyColorListException('`colors` cannot be empty.');
    }

    // Set the colors based on the behavior.
    switch (data.behavior) {
      case FaderBehavior.specifiedOrder:
        _colors = List.from(data.colors);
        break;
      case FaderBehavior.sortedOrder:
        _colors = List.from(data.colors)..sortColors();
        break;
      case FaderBehavior.reverseSortedOrder:
        _colors =
            (List<Color>.from(data.colors)..sortColors()).reversed.toList();
        break;
      case FaderBehavior.random:
        _colors = List.from(data.colors)..add(data.colors.first);
        _colors.shuffle();
        break;
      case FaderBehavior.breathe:
        final List<Color> tempColors2 = List.from(data.colors)..sortColors();
        final List<Color> tempColors1 =
            List.from(tempColors2.reversed.toList());

        tempColors1.insert(0, tempColors1.first);
        tempColors1.removeLast();

        _colors = [...tempColors1, ...tempColors2];
        break;
      case FaderBehavior.pulse:
        final List<Color> tempColors2 = List.from(data.colors)..sortColors();
        final List<Color> tempColors1 =
            List.from(tempColors2.reversed.toList());

        tempColors1.removeLast();
        final Color darkColor = tempColors2.removeLast();

        _colors = [
          ...tempColors1,
          ...tempColors2,
          ...tempColors1,
          ...tempColors2,
          darkColor,
          darkColor,
        ];

        break;
    }
  }

  /// The blueprints for painting the background.
  final FaderPainterData data;

  /// The colors to be used for the animation.
  ///
  /// This is derived from [data.colors] based on the [FaderBehavior].
  late final List<Color> _colors;

  /// The index of the color to be used in the current step of the animation.
  int get _colorIndex =>
      (animation.value * data.colors.length).floor() % data.colors.length;

  /// The fraction of the current step of the animation.
  ///
  /// This is used to calculate the color blending.
  double get _fraction => (animation.value * data.colors.length) % 1.0;

  /// The value of the previous step of the animation.
  ///
  /// This is used to determine when the animation has looped back to the
  /// beginning.
  double _previousAnimationValue = 0.9;

  @override
  void paint(Canvas canvas, Size size) {
    switch (data.behavior) {
      case FaderBehavior.random:
        _paintRandom(canvas);
        break;
      case FaderBehavior.breathe:
      case FaderBehavior.pulse:
        _paintLife(canvas);
        break;
      case FaderBehavior.specifiedOrder:
      case FaderBehavior.sortedOrder:
      case FaderBehavior.reverseSortedOrder:
        _paintStaticOrderSmooth(canvas);
        break;
    }
  }

  /// Paints the background with a random color order.
  void _paintRandom(Canvas canvas) {
    if (animation.value < _previousAnimationValue) {
      _shuffleRandomColors();
    }
    _previousAnimationValue = animation.value;

    _paintStaticOrderSmooth(canvas);
  }

  /// Paints the background with a breathing or pulsing color order.
  void _paintLife(Canvas canvas) {
    final int colorIndex =
        (animation.value * _colors.length).floor() % _colors.length;

    final Color currentColor = _colors[colorIndex];
    final Color nextColor = _colors[(colorIndex + 1) % _colors.length];

    final double fraction = (animation.value * _colors.length) % 1.0;
    final double curveValue = Curves.linear.transform(fraction);

    final Color blendedColor = Color.lerp(currentColor, nextColor, curveValue)!;

    canvas.drawPaint(Paint()..color = blendedColor);
  }

  /// Paints the background with a static color order.
  void _paintStaticOrderSmooth(Canvas canvas) {
    final int colorIndex = _colorIndex;

    final Color currentColor = _colors[colorIndex];
    final Color nextColor = _colors[(colorIndex + 1) % _colors.length];

    final double curveValue = Curves.easeInOut.transform(_fraction);

    final Color blendedColor = Color.lerp(currentColor, nextColor, curveValue)!;

    canvas.drawPaint(Paint()..color = blendedColor);
  }

  /// Shuffles the colors in [_colors] randomly.
  void _shuffleRandomColors() {
    final List<Color> randColors = [_colors.last];

    for (int i = 0; i < data.colors.length; i++) {
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
