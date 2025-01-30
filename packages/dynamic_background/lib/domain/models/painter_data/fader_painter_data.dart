import 'package:collection/collection.dart';
import 'package:dynamic_background/domain/enums/fader_behavior.dart';
import 'package:dynamic_background/domain/models/painter/fader_painter.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/painter_data.dart';
import 'package:flutter/material.dart';

/// The data needed to paint a fader background.
///
/// A fader background is a background that fades between a set of colors.
class FaderPainterData extends PainterData {
  /// Creates a new [FaderPainterData] object.
  ///
  /// A fader background is a background that fades between the given list of
  /// `colors`.
  const FaderPainterData({
    this.behavior = FaderBehavior.specifiedOrder,
    required List<Color> colors,
  })  : assert(colors.length > 0, true),
        _colors = colors;

  /// The behavior of the fader.
  final FaderBehavior behavior;

  /// The colors the fader will go through.
  final List<Color> _colors;

  /// The colors the fader will go through.
  ///
  /// This list is not directly modifiable. Call the add, insert, and remove
  /// methods to modify the list.
  List<Color> get colors => List.unmodifiable(_colors);

  /// Adds a `color` to the end of the list of [colors] the fader will go
  /// through.
  ///
  /// ```dart
  /// List<Color> colors = [red, blue];
  /// addColor(green); // [red, blue, green]
  /// ```
  void addColor(Color color) => _colors.add(color);

  /// Adds a list of `colors` to the end of the list of [colors] the fader will
  /// go through.
  ///
  /// ```dart
  /// List<Color> colors = [red, blue];
  /// addAllColors([green, yellow]); // [red, blue, green, yellow]
  /// ```
  void addAllColors(List<Color> colors) => _colors.addAll(colors);

  /// Adds a `color` at the given `index` in the list of [colors] the fader will
  /// go through.
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

  /// Adds a list of `colors` at the given `index` in the list of [colors] the
  /// fader will go through.
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
  /// [colors] the fader will go through.
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

  /// Removes the `color` at the given `index` from the list of [colors] the
  /// fader will go through.
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

  /// Removes all occurrences of the given `color` from the list of [colors] the
  /// fader will go through.
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
    return FaderPainter(
      animation: animation,
      data: this,
    );
  }

  @override
  FaderPainterData copy() => copyWith();

  @override
  FaderPainterData copyWith({
    FaderBehavior? behavior,
    List<Color>? colors,
  }) {
    return FaderPainterData(
      behavior: behavior ?? this.behavior,
      colors: colors ?? List<Color>.from(_colors),
    );
  }

  /// Note: The order of the elements in the [colors] list is important—if the
  /// two objects have the same colors but in a different order, they will not
  /// be considered equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is FaderPainterData &&
        identical(other.behavior, behavior) &&
        const DeepCollectionEquality().equals(other._colors, _colors);
  }

  /// Note: The order of the elements in the [colors] list is important—if the
  /// two objects have the same colors but in a different order, they will not
  /// have the same hash code.
  @override
  int get hashCode => Object.hash(
        behavior,
        const DeepCollectionEquality().hash(_colors),
      );

  @override
  String toString() => 'Instance of FaderPainterData: {'
      'behavior: $behavior, '
      'colors: $_colors'
      '}';
}
