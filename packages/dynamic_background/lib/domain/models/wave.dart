import 'package:dynamic_background/domain/enums/wave_direction.dart';
import 'package:dynamic_background/domain/enums/wave_gravity_direction.dart';
import 'package:flutter/material.dart';

class Wave {
  /// Creates a new [Wave] object.
  const Wave({
    this.direction = WaveDirection.right2Left,
    this.gravityDirection = WaveGravityDirection.down,
    this.amplitude = 40.0,
    this.frequency = 1,
    this.phase = 0.0,
    this.offset = 0.75,
    this.useScaledOffset = true,
    required this.color,
    this.lineColor,
    this.lineThickness = 2.0,
  })  : assert(amplitude >= 0.0),
        assert(frequency >= 0.0),
        assert(phase >= 0.0 && phase <= 1.0),
        assert(
          useScaledOffset ? offset >= 0.0 && offset <= 1.0 : offset >= 0.0,
        ),
        assert(lineThickness >= 0.0),
        assert(
          identical(direction, WaveDirection.left2Right) ||
                  identical(direction, WaveDirection.right2Left)
              ? identical(gravityDirection, WaveGravityDirection.down) ||
                  identical(gravityDirection, WaveGravityDirection.up) == true
              : identical(gravityDirection, WaveGravityDirection.right) ||
                  identical(gravityDirection, WaveGravityDirection.left) ==
                      true,
          'If the wave is horizontal, gravity can only be up or down. If the '
          'wave is vertical, gravity can only be left or right.',
        );

  /// The direction the wave should move.
  final WaveDirection direction;

  /// The direction that should be considered the bottom of the wave.
  ///
  /// Certain values for [direction] are not compatible with certain values
  /// here. For example, if [direction] is [WaveDirection.left2Right], this
  /// should be [WaveGravityDirection.down] or [WaveGravityDirection.up].
  final WaveGravityDirection gravityDirection;

  /// The amplitude of the wave.
  ///
  /// This is the height from the center of the wave to the top or bottom of the
  /// wave.
  final double amplitude;

  /// The frequency of the wave.
  ///
  /// This is how many times the wave will complete a full cycle in during the
  /// duration of the animation. The higher the number, the faster the wave will
  /// move.
  final int frequency;

  /// The phase of the wave.
  ///
  /// This is will shift the wave left or right. This value should be between
  /// `0.0` and `1.0` (inclusive).
  final double phase;

  /// The x or y coordinate of the center line of the wave, depending on the
  /// [direction].
  ///
  /// If [useScaledOffset] is `true`, this value needs to be between `0.0` and
  /// `1.0` (inclusive). If [useScaledOffset] is `false`, this value needs to be
  /// between `0.0` and the available canvas size (inclusive).
  final double offset;

  /// Whether of not the [offset] should be scaled to the available canvas size.
  ///
  /// If this is `true`, the [offset] values will need to be between `0.0` and
  /// `1.0` (inclusive). If this is `false`, the [offset] values will need to be
  /// between `0.0` and the available canvas size (inclusive).
  final bool useScaledOffset;

  /// The color of the space below the wave.
  ///
  /// To have the wave just be a line, set this to [Colors.transparent] and set
  /// [lineColor] to the color of the line.
  final Color color;

  /// The color of the line.
  ///
  /// If this is null, 'color' will be used.
  ///
  /// To have the wave just be a line, set [color] to [Colors.transparent] and
  /// set this to the color of the line.
  final Color? lineColor;

  /// The thickness of the line.
  final double lineThickness;

  /// Returns a copy of this object.
  Wave copy() => copyWith();

  static const Color _sentinelValue = Color(0x00000000);

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  ///
  /// Since [lineColor] is nullable, it is defaulted to an empty object in this
  /// method. If left as an empty object, its current value in this [Wave]
  /// object will be used. This way, if it is `null`, the program will know that
  /// it is intentionally being set to `null`.
  Wave copyWith({
    WaveDirection? direction,
    WaveGravityDirection? gravityDirection,
    double? amplitude,
    int? frequency,
    double? phase,
    double? offset,
    bool? useScaledOffset,
    Color? color,
    Color? lineColor = _sentinelValue,
    double? lineThickness,
  }) {
    return Wave(
      direction: direction ?? this.direction,
      gravityDirection: gravityDirection ?? this.gravityDirection,
      amplitude: amplitude ?? this.amplitude,
      frequency: frequency ?? this.frequency,
      phase: phase ?? this.phase,
      offset: offset ?? this.offset,
      useScaledOffset: useScaledOffset ?? this.useScaledOffset,
      color: color ?? this.color,
      lineColor:
          identical(lineColor, _sentinelValue) ? this.lineColor : lineColor,
      lineThickness: lineThickness ?? this.lineThickness,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Wave &&
        identical(other.direction, direction) &&
        identical(other.gravityDirection, gravityDirection) &&
        identical(other.amplitude, amplitude) &&
        identical(other.frequency, frequency) &&
        identical(other.phase, phase) &&
        identical(other.offset, offset) &&
        identical(other.useScaledOffset, useScaledOffset) &&
        other.color == color &&
        other.lineColor == lineColor &&
        identical(other.lineThickness, lineThickness);
  }

  @override
  int get hashCode => Object.hash(
        direction,
        gravityDirection,
        amplitude,
        frequency,
        phase,
        offset,
        useScaledOffset,
        color,
        lineColor,
        lineThickness,
      );

  @override
  String toString() => 'Instance of Wave: {'
      'direction: $direction, '
      'gravityDirection: $gravityDirection, '
      'amplitude: $amplitude, '
      'frequency: $frequency, '
      'phase: $phase, '
      'offset: $offset, '
      'useScaledOffset: $useScaledOffset, '
      'color: $color, '
      'lineColor: $lineColor, '
      'lineThickness: $lineThickness'
      '}';
}
