import 'package:collection/collection.dart';
import 'package:dynamic_background/domain/models/lava.dart';
import 'package:dynamic_background/domain/models/painter/lava_painter.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/painter_data.dart';
import 'package:flutter/material.dart';

/// The data needed to paint a wave background.
///
/// A wave background is a background that has gently flowing sine waves that
/// move across the screen in a certain direction.
class LavaPainterData extends PainterData {
  /// Creates a new [LavaPainterData] object.
  ///
  /// A wave background is a background that has gently flowing sine waves that
  /// move across the screen in a certain direction.
  ///
  /// Duration will not affect this painter in the same way it does others. The
  /// speed of the lava blobs is determined by the [speed] parameter. The
  /// [speedTolerance] parameter is used to give the lava blobs a bit of
  /// randomness in their movement speed. The duration will only affect the rate
  /// at which the blobs change color.
  LavaPainterData({
    this.width = 150.0,
    this.widthTolerance = 0.0,
    this.growAndShrink = true,
    this.blurLevel = 20.0,
    this.numBlobs = 5,
    required List<Color> colors,
    this.allSameColor = false,
    this.fadeBetweenColors = false,
    this.changeColorsTogether = false,
    this.speed = 5,
    this.speedTolerance = 0,
  })  : assert(width > 0.0),
        assert(width - widthTolerance > 0.0),
        assert(blurLevel >= 0.0),
        assert(numBlobs > 0),
        assert(colors.isNotEmpty, true),
        assert(speed > 0),
        assert(speed - speedTolerance > 0),
        _colors = colors,
        _blobs = [] {
    for (int i = 0; i < numBlobs; i++) {
      _blobs.add(
        Lava(
          width: width,
          widthTolerance: widthTolerance,
          growAndShrink: growAndShrink,
          blurLevel: blurLevel,
          colors: colors,
          allSameColor: allSameColor,
          fadeBetweenColors: fadeBetweenColors,
          changeColorsTogether: changeColorsTogether,
          speed: speed,
          speedTolerance: speedTolerance,
        ),
      );
    }
  }

  /// The width of the circles that will be moving on the screen.
  final double width;

  /// The amount more or less than the set [width] that the circles can be.
  ///
  /// This is used to give the circles a bit of randomness in their size.
  ///
  /// For example, if [width] is `24.0` and [widthTolerance] is `4.0`, the
  /// circles can be anywhere from `20.0` to `28.0` pixels wide.
  ///
  /// The default value is `0.0`.
  final double widthTolerance;

  /// Whether or not the circles should grow and shrink.
  ///
  /// If this is `true`, the circles will grow and shrink. If this is `false`,
  /// the circles will remain a static size.
  final bool growAndShrink;

  /// How extreme the blur effect should be. The higher the number, the more
  /// extreme the blur effect.
  final double blurLevel;

  /// The number of circles that will be moving on the screen.
  ///
  /// The default value is `5`.
  final int numBlobs;

  /// The colors of the circles that will be moving on the screen.
  ///
  /// Note: There is no guarantee that all colors will be used. If the list is
  /// too long, some colors may be skipped.
  ///
  /// Note: If [allSameColor] is `true`, the order of this list matter;
  /// otherwise, the order does not matter.
  final List<Color> _colors;

  /// The colors of the circles that will be moving on the screen.
  ///
  /// Note: There is no guarantee that all colors will be used. If the list is
  /// too long, some colors may be skipped.
  ///
  /// Note: If [allSameColor] is `true`, the order of this list matter;
  /// otherwise, the order does not matter.
  List<Color> get colors => List<Color>.unmodifiable(_colors);

  /// Whether or not all circles should be the same color.
  ///
  /// If this is `true`, all circles will be the same color. If this is `false`,
  /// the circles will randomly select their colors from the [colors] list.
  final bool allSameColor;

  /// Whether or not each circle should fade between colors.
  final bool fadeBetweenColors;

  /// Whether or not the circles should change colors together.
  ///
  /// If this is `true`, all circles will change colors at the same time. If
  /// this is `false`, each circle will change colors at its own pace.
  final bool changeColorsTogether;

  /// The list of circles that will be moving on the screen.
  final List<Lava> _blobs;

  /// The list of circles that will be moving on the screen.
  List<Lava> get blobs => List<Lava>.unmodifiable(_blobs);

  /// The speed that the lava blobs will move across the screen.
  ///
  /// The higher the number, the faster the blobs will move.
  final double speed;

  /// The tolerance for the speed of the lava blobs.
  ///
  /// This is used to give the circles a bit of randomness in their movement
  /// speed.
  ///
  /// For example, if [speed] is `5.0` and [speedTolerance] is `4.0`, the
  /// circles can have a speed anywhere from `1.0` to `9.0`.
  ///
  /// The default value is `0`.
  final double speedTolerance;

  /// Adds a `color` to the end of the list of [colors].
  ///
  /// ```dart
  /// List<Color> colors = [red, blue];
  /// addColor(green); // [red, blue, green]
  /// ```
  void addColor(Color color) => _colors.add(color);

  /// Adds a list of `colors` to the end of the list of [colors].
  ///
  /// ```dart
  /// List<Color> colors = [red, blue];
  /// addAllColors([green, yellow]); // [red, blue, green, yellow]
  /// ```
  void addAllColors(List<Color> colors) => _colors.addAll(colors);

  /// Adds a `color` at the given `index` in the list of [colors].
  ///
  /// Throws a [RangeError] if the `index` is out of bounds.
  ///
  /// ```dart
  /// List<Color> colors = [red, blue, green];
  /// insertColor(1, pink); // [red, pink, blue, green]
  /// ```
  void insertColor(int index, Color color) {
    if (index < 0 || index > _colors.length) {
      throw RangeError.range(index, 0, _colors.length);
    }

    _colors.insert(index, color);
  }

  /// Adds a list of `colors` at the given `index` in the list of [colors].
  ///
  /// Throws a [RangeError] if the `index` is out of bounds.
  ///
  /// ```dart
  /// List<Color> colors = [red, blue, green];
  /// insertAllColors(1, [pink, white]); // [red, pink, white, blue, green]
  /// ```
  void insertAllColors(int index, List<Color> colors) {
    if (index < 0 || index > _colors.length) {
      throw RangeError.range(index, 0, _colors.length);
    }

    _colors.insertAll(index, colors);
  }

  /// Removes the first occurrence of the given `color` from the list of
  /// [colors].
  ///
  /// Returns `true` if the `color` was in the list, `false` otherwise.
  ///
  /// If the list of [colors] has only one color, this method will return
  /// `false` and the `color` will not be removed. The list must never be empty.
  ///
  /// ```dart
  /// List<Color> colors = [red, blue, green];
  ///
  /// bool removed = removeColor(orange); // false
  /// print(colors); // [red, blue, green]
  ///
  /// removed = removeColor(blue); // true
  /// print(colors); // [red, green]
  ///
  /// removed = removeColor(red); // true
  /// print(colors); // [green]
  ///
  /// removed = removeColor(green); // false
  /// print(colors); // [green]
  /// ```
  bool removeColor(Color color) {
    if (_colors.length == 1) return false;

    return _colors.remove(color);
  }

  /// Removes the `color` at the given `index` from the list of [colors].
  ///
  /// Throws a [RangeError] if the `index` is out of bounds.
  ///
  /// If the list of [colors] has only one color, this method will return `null`
  /// and the color will not be removed. The list must never be empty.
  ///
  /// ```dart
  /// List<Color> colors = [red, blue, green];
  /// Color? removed = removeColorAt(1); // blue
  /// print(colors); // [red, green]
  ///
  /// removed = removeColorAt(1); // green
  /// print(colors); // [red]
  ///
  /// removed = removeColorAt(0); // null
  /// print(colors); // [red]
  /// ```
  Color? removeColorAt(int index) {
    if (index < 0 || index >= _colors.length) {
      throw RangeError.range(index, 0, _colors.length - 1);
    }

    if (_colors.length == 1) return null;

    return _colors.removeAt(index);
  }

  /// Removes all occurrences of the given `color` from the list of [colors].
  ///
  /// Returns `true` if the `color` was in the list, `false` otherwise.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<Color> colors = [red, red, blue, red, green];
  /// bool removed = removeColorCompletely(red); // true
  /// print(colors); // [blue, green]
  /// ```
  ///
  /// If the list of [colors] has only one color (this also goes for multiple
  /// instances of the one color), this method will return `false` and the
  /// `color` will be removed, expect for one instance of it. The list must
  /// never be empty.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<Color> colors = [red, red, red];
  /// bool removed = removeColorCompletely(red); // false
  /// print(colors); // [red]
  /// ```
  bool removeColorCompletely(Color color) {
    while (_colors.contains(color)) {
      _colors.remove(color);
    }

    if (_colors.isNotEmpty) return true;

    _colors.add(color);

    return false;
  }

  @override
  Painter getPainter(Animation<double> animation) {
    return LavaPainter(
      animation: animation,
      data: this,
    );
  }

  @override
  LavaPainterData copy() => copyWith();

  @override
  LavaPainterData copyWith({
    double? width,
    double? widthTolerance,
    bool? growAndShrink,
    double? blurLevel,
    int? numBlobs,
    List<Color>? colors,
    bool? allSameColor,
    bool? fadeBetweenColors,
    bool? changeColorsTogether,
    double? speed,
    double? speedTolerance,
  }) {
    return LavaPainterData(
      width: width ?? this.width,
      widthTolerance: widthTolerance ?? this.widthTolerance,
      growAndShrink: growAndShrink ?? this.growAndShrink,
      blurLevel: blurLevel ?? this.blurLevel,
      numBlobs: numBlobs ?? this.numBlobs,
      colors: colors ?? List<Color>.from(_colors),
      allSameColor: allSameColor ?? this.allSameColor,
      fadeBetweenColors: fadeBetweenColors ?? this.fadeBetweenColors,
      changeColorsTogether: changeColorsTogether ?? this.changeColorsTogether,
      speed: speed ?? this.speed,
      speedTolerance: speedTolerance ?? this.speedTolerance,
    );
  }

  /// Note: The order of the elements in the [colors] list is important—if the
  /// two objects have the same colors but in a different order, they will not
  /// be considered equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LavaPainterData &&
        identical(other.width, width) &&
        identical(other.widthTolerance, widthTolerance) &&
        identical(other.growAndShrink, growAndShrink) &&
        identical(other.blurLevel, blurLevel) &&
        identical(other.numBlobs, numBlobs) &&
        const DeepCollectionEquality().equals(other._colors, _colors) &&
        identical(other.allSameColor, allSameColor) &&
        identical(other.fadeBetweenColors, fadeBetweenColors) &&
        identical(other.changeColorsTogether, changeColorsTogether) &&
        const DeepCollectionEquality().equals(other._blobs, _blobs) &&
        identical(other.speed, speed) &&
        identical(other.speedTolerance, speedTolerance);
  }

  /// Note: The order of the elements in the [colors] list is important—if the
  /// two objects have the same colors but in a different order, they will not
  /// have the same hash code.
  @override
  int get hashCode => Object.hash(
        width,
        widthTolerance,
        growAndShrink,
        blurLevel,
        numBlobs,
        const DeepCollectionEquality().hash(_colors),
        allSameColor,
        fadeBetweenColors,
        changeColorsTogether,
        const DeepCollectionEquality().hash(_blobs),
        speed,
        speedTolerance,
      );

  @override
  String toString() => 'Instance of LavaPainterData: {'
      'width: $width, '
      'widthTolerance: $widthTolerance, '
      'growAndShrink: $growAndShrink, '
      'blurLevel: $blurLevel, '
      'numBlobs: $numBlobs, '
      'colors: $_colors'
      'allSameColor: $allSameColor, '
      'fadeBetweenColors: $fadeBetweenColors, '
      'changeColorsTogether: $changeColorsTogether, '
      'speed: $speed, '
      'speedTolerance: $speedTolerance'
      '}';
}
