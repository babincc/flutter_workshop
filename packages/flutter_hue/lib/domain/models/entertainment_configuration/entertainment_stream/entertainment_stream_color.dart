import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hue/utils/color_converter.dart';

/// Represents a color that can be sent as a command to the bridge.
abstract class EntertainmentStreamColor {
  const EntertainmentStreamColor(this.colorMode);

  final ColorMode colorMode;

  /// Whether or not the given `brightness` is valid.
  ///
  /// The `brightness` must be greater than or equal to `0.0` and less than or
  /// equal to `1.0`.
  static bool isValidBrightness(double brightness) =>
      brightness >= 0.0 && brightness <= 1.0;

  /// The error message that is shown when the brightness is invalid.
  static const String invalidBrightnessMessage =
      'brightness must be greater than or equal to 0 and less than or equal to '
      '1';

  /// Whether or not this color would turn the lights off.
  bool get isOff;

  /// Whether or not this color would not turn the lights off.
  bool get isNotOff => !isOff;

  /// Returns a copy of this object.
  EntertainmentStreamColor copy();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  EntertainmentStreamColor copyWith();

  /// Converts this color to the given `colorMode`.
  EntertainmentStreamColor to(ColorMode colorMode, [double? brightness]);

  /// {@template lerp}
  /// Linearly interpolate between two colors.
  ///
  /// The `t` parameter is the interpolation value. It must be between `0.0` and
  /// `1.0`.
  /// {@endtemplate}
  ///
  /// If `a` and `b` are the same [Type], the result will be the same [Type]. If
  /// `a` and `b` are different [Type]s, the result will be a [ColorXy].
  static EntertainmentStreamColor lerp(
    EntertainmentStreamColor a,
    EntertainmentStreamColor b,
    double t,
  ) {
    if (a is ColorXy && b is ColorXy) {
      return ColorXy.lerp(a, b, t);
    }

    if (a is ColorRgb && b is ColorRgb) {
      return ColorRgb.lerp(a, b, t);
    }

    final ColorXy aXy;
    if (a is ColorXy) {
      aXy = a;
    } else {
      aXy = a.to(ColorMode.xy) as ColorXy;
    }

    final ColorXy bXy;
    if (b is ColorXy) {
      bXy = b;
    } else {
      bXy = b.to(ColorMode.xy) as ColorXy;
    }

    return ColorXy.lerp(aXy, bXy, t);
  }
}

/// A class representing a color in the CIE 1931 color space.
class ColorXy extends EntertainmentStreamColor {
  const ColorXy(this.x, this.y, this.brightness)
      : assert(
          x >= 0.0 && x <= 1.0,
          'x must be greater than or equal to 0 and less than or equal to 1',
        ),
        assert(
          y >= 0.0 && y <= 1.0,
          'y must be greater than or equal to 0 and less than or equal to 1',
        ),
        assert(
          brightness >= 0.0 && brightness <= 1.0,
          EntertainmentStreamColor.invalidBrightnessMessage,
        ),
        super(ColorMode.xy);

  /// Creates a new [ColorXy] instance from the given `r`, `g`, and `b` values.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to the calculated brightness of the color. Note,
  /// this is typically a bit dim.
  factory ColorXy.fromRgb(int r, int g, int b, [double? brightness]) {
    if (brightness != null) {
      assert(
        EntertainmentStreamColor.isValidBrightness(brightness),
        EntertainmentStreamColor.invalidBrightnessMessage,
      );
    }

    final List<double> xyList = ColorConverter.rgb2xy(r, g, b);

    return ColorXy(xyList[0], xyList[1], brightness ?? xyList[2]);
  }

  /// Creates a new [ColorXy] instance from the given `color`.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to whatever is calculated from `color`. Note, this
  /// is usually a bit dim.
  factory ColorXy.fromColor(Color color, [double? brightness]) {
    final ColorXy toReturn = color.toColorXy();

    if (brightness == null) return toReturn;

    return toReturn.copyWith(brightness: brightness);
  }

  /// The x value of the color.
  final double x;

  /// The y value of the color.
  final double y;

  /// The brightness of the color.
  final double brightness;

  @override
  bool get isOff => x == 0.0 && y == 0.0 && brightness == 0.0;

  @override
  ColorXy copy() => copyWith();

  @override
  ColorXy copyWith({
    double? x,
    double? y,
    double? brightness,
  }) =>
      ColorXy(
        x ?? this.x,
        y ?? this.y,
        brightness ?? this.brightness,
      );

  @override
  EntertainmentStreamColor to(ColorMode colorMode, [double? brightness]) {
    switch (colorMode) {
      case ColorMode.xy:
        return copyWith(brightness: brightness);
      case ColorMode.rgb:
        return toRgb(brightness);
    }
  }

  /// Converts this color to an RGB color.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to the [brightness] of this XY color.
  ColorRgb toRgb([double? brightness]) =>
      ColorRgb.fromXy(x, y, brightness ?? this.brightness);

  @override
  String toString() =>
      'Instance of ColorXy: x=$x, y=$y, brightness=$brightness';

  /// {@macro lerp}
  static ColorXy lerp(
    ColorXy a,
    ColorXy b,
    double t,
  ) {
    final double x = clampDouble(
      a.x + (b.x - a.x) * t,
      0.0,
      1.0,
    );
    final double y = clampDouble(
      a.y + (b.y - a.y) * t,
      0.0,
      1.0,
    );
    final double brightness = clampDouble(
      a.brightness + (b.brightness - a.brightness) * t,
      0.0,
      1.0,
    );

    return ColorXy(x, y, brightness);
  }
}

/// A class representing a color in the RGB color space.
class ColorRgb extends EntertainmentStreamColor {
  const ColorRgb(this.r, this.g, this.b)
      : assert(
          r >= 0 && r <= 255,
          'r must be greater than or equal to 0 and less than or equal to 255',
        ),
        assert(
          g >= 0 && g <= 255,
          'g must be greater than or equal to 0 and less than or equal to 255',
        ),
        assert(
          b >= 0 && b <= 255,
          'b must be greater than or equal to 0 and less than or equal to 255',
        ),
        super(ColorMode.rgb);

  /// Creates a new [ColorRgb] instance from the given `x` and `y` values.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to `1.0`.
  factory ColorRgb.fromXy(double x, double y, [double? brightness]) {
    if (brightness != null) {
      assert(
        EntertainmentStreamColor.isValidBrightness(brightness),
        EntertainmentStreamColor.invalidBrightnessMessage,
      );
    }

    final List<int> rgbList = ColorConverter.xy2rgb(x, y, brightness ?? 1.0);
    // final List<double> rgbList = ColorConverter.xy2rgb(x, y, brightness ?? 1.0);

    return ColorRgb(rgbList[0], rgbList[1], rgbList[2]);
  }

  /// Creates a new [ColorRgb] instance from the given `color`.
  factory ColorRgb.fromColor(Color color) => color.toColorRgb();

  /// The red value of the color.
  final int r;

  /// The green value of the color.
  final int g;

  /// The blue value of the color.
  final int b;

  @override
  bool get isOff => r == 0 && g == 0 && b == 0;

  @override
  ColorRgb copy() => copyWith();

  @override
  ColorRgb copyWith({
    int? r,
    int? g,
    int? b,
  }) =>
      ColorRgb(
        r ?? this.r,
        g ?? this.g,
        b ?? this.b,
      );

  @override
  EntertainmentStreamColor to(ColorMode colorMode, [double? brightness]) {
    switch (colorMode) {
      case ColorMode.xy:
        return toXy(brightness);
      case ColorMode.rgb:
        if (brightness == null) return this;
        return toXy(brightness).toRgb();
    }
  }

  /// Converts this color to an XY color.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to the calculated brightness of the color. Note,
  /// this is typically a bit dim.
  ColorXy toXy([double? brightness]) => ColorXy.fromRgb(r, g, b, brightness);

  @override
  String toString() => 'Instance of ColorRgb: r=$r, g=$g, b=$b';

  /// {@macro lerp}
  static ColorRgb lerp(
    ColorRgb a,
    ColorRgb b,
    double t,
  ) {
    final double red = (a.r + (b.r - a.r) * t)
        .clamp(
          0.0,
          255.0,
        )
        .toDouble();
    final double green = (a.g + (b.g - a.g) * t)
        .clamp(
          0.0,
          255.0,
        )
        .toDouble();
    final double blue = (a.b + (b.b - a.b) * t)
        .clamp(
          0.0,
          255.0,
        )
        .toDouble();

    return ColorRgb(red.round(), green.round(), blue.round());
  }
}

/// An enum representing the color mode of the entertainment stream.
enum ColorMode {
  /// The color mode is XY and uses the CIE 1931 color space.
  xy,

  /// The color mode is RGB and uses the RGB color space.
  rgb;
}
