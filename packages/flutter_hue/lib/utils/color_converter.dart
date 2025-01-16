import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_color.dart';

/// A class for converting between color spaces.
class ColorConverter {
  /// Converts xy coordinates in the CIE 1931 color space to RGB.
  ///
  /// Returns a list of doubles representing the RGB values. [r, g, b]
  static List<double> xy2rgb(double x, double y, [double brightness = 1.0]) {
    assert(x >= 0.0 && x <= 1.0,
        "x must be greater than or equal to 0 and less than or equal to 1");
    assert(y >= 0.0 && y <= 1.0,
        "y must be greater than or equal to 0 and less than or equal to 1");
    assert(
      brightness >= 0.0 && brightness <= 1.0,
      "brightness must be greater than or equal to 0 and less than or equal to "
      "1",
    );

    final double z = 1.0 - x - y;
    final double Y = brightness;
    if (y == 0.0) y = 0.0001;
    final double X = (Y / y) * x;
    final double Z = (Y / y) * z;

    // sRGB D65 conversion
    double r = X * 1.656492 - Y * 0.354851 - Z * 0.255038;
    double g = -X * 0.707196 + Y * 1.655397 + Z * 0.036152;
    double b = X * 0.051713 - Y * 0.121364 + Z * 1.011530;

    // Apply reverse gamma correction.
    r = _reverseGammaCorrection(r);
    g = _reverseGammaCorrection(g);
    b = _reverseGammaCorrection(b);

    // If one of the values is greater than 1, the color is too saturated and
    // needs to be brought back down.
    if (r > b && r > g && r > 1.0) {
      g = g / r;
      b = b / r;
      r = 1.0;
    } else if (g > b && g > r && g > 1.0) {
      r = r / g;
      b = b / g;
      g = 1.0;
    } else if (b > r && b > g && b > 1.0) {
      r = r / b;
      g = g / b;
      b = 1.0;
    }

    // Make sure none of the values are less than 0.
    if (r < 0.0) r = 0.0;
    if (g < 0.0) g = 0.0;
    if (b < 0.0) b = 0.0;

    // Convert to 0-255 range.
    r = r * 255.0;
    g = g * 255.0;
    b = b * 255.0;

    return [r, g, b];
  }

  /// Converts xy coordinates in the CIE 1931 color space to HSV.
  ///
  /// Returns a list of doubles representing the HSV values. [h, s, v]
  static List<double> xy2hsv(double x, double y) {
    assert(x >= 0.0 && x <= 1.0,
        "x must be greater than or equal to 0 and less than or equal to 1");
    assert(y >= 0.0 && y <= 1.0,
        "y must be greater than or equal to 0 and less than or equal to 1");

    final List<double> rgb = xy2rgb(x, y);
    return rgb2hsv(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts xy coordinates in the CIE 1931 color space to a hex string.
  ///
  /// Returns a string representing the hex value. ffffffff
  static String xy2hex(double x, double y) {
    assert(x >= 0.0 && x <= 1.0,
        "x must be greater than or equal to 0 and less than or equal to 1");
    assert(y >= 0.0 && y <= 1.0,
        "y must be greater than or equal to 0 and less than or equal to 1");

    final List<double> rgb = xy2rgb(x, y);
    return rgb2hex(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts xy coordinates in the CIE 1931 color space to HSL.
  ///
  /// Returns a list of doubles representing the HSL values. [h, s, l]
  static List<double> xy2hsl(double x, double y) {
    assert(x >= 0.0 && x <= 1.0,
        "x must be greater than or equal to 0 and less than or equal to 1");
    assert(y >= 0.0 && y <= 1.0,
        "y must be greater than or equal to 0 and less than or equal to 1");

    final List<double> rgb = xy2rgb(x, y);
    return rgb2hsl(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts xy coordinates in the CIE 1931 color space to a Flutter Color.
  static Color xy2color(double x, double y) {
    assert(x >= 0.0 && x <= 1.0,
        "x must be greater than or equal to 0 and less than or equal to 1");
    assert(y >= 0.0 && y <= 1.0,
        "y must be greater than or equal to 0 and less than or equal to 1");

    final List<double> rgb = xy2rgb(x, y);
    return Color.fromARGB(255, rgb[0].round(), rgb[1].round(), rgb[2].round());
  }

  /// Converts xy coordinates in the CIE 1931 color space to an integer.
  static int xy2int(double x, double y) {
    assert(x >= 0.0 && x <= 1.0,
        "x must be greater than or equal to 0 and less than or equal to 1");
    assert(y >= 0.0 && y <= 1.0,
        "y must be greater than or equal to 0 and less than or equal to 1");

    final List<double> rgb = xy2rgb(x, y);
    return rgb2int(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts RGB values to xy coordinates in the CIE 1931 color space.
  ///
  /// Returns a list of doubles representing the xy values. [x, y, brightness]
  static List<double> rgb2xy(double r, double g, double b) {
    if (r == 0.0 && g == 0.0 && b == 0.0) return [0.0, 0.0, 0.0];

    // Convert to a linear RGB color space.
    double R = r / 255.0;
    double G = g / 255.0;
    double B = b / 255.0;

    // Apply gamma correction.
    R = _gammaCorrection(R);
    G = _gammaCorrection(G);
    B = _gammaCorrection(B);

    // Convert to XYZ using the Wide RGB D65 conversion formula.
    final double X = R * 0.4124 + G * 0.3576 + B * 0.1805;
    final double Y = R * 0.2126 + G * 0.7152 + B * 0.0722;
    final double Z = R * 0.0193 + G * 0.1192 + B * 0.9505;

    // Calculate the xy values from the XYZ values.
    final double x = X / (X + Y + Z);
    final double y = Y / (X + Y + Z);

    return [x, y, Y];
  }

  /// Converts RGB values to HSV values.
  ///
  /// Returns a list of doubles representing the HSV values. [h, s, v]
  static List<double> rgb2hsv(double r, double g, double b) {
    final double R = r / 255.0;
    final double G = g / 255.0;
    final double B = b / 255.0;

    final double maximum = max(R, max(G, B));
    final double minimum = min(R, min(G, B));
    final double delta = maximum - minimum;

    double h = 0.0;
    double s = 0.0;
    double v = maximum;

    if (delta != 0.0) {
      s = delta / maximum;

      if (R == maximum) {
        h = (G - B) / delta;
      } else if (G == maximum) {
        h = 2.0 + (B - R) / delta;
      } else if (B == maximum) {
        h = 4.0 + (R - G) / delta;
      }

      h *= 60.0;

      if (h < 0.0) {
        h += 360.0;
      }
    }

    return [h, s, v];
  }

  /// Converts RGB values to a hex string.
  ///
  /// Returns a string representing the hex value. ffffffff
  static String rgb2hex(double r, double g, double b) {
    final int integer = rgb2int(r, g, b);
    return int2hex(integer);
  }

  /// Converts RGB values to HSL values.
  ///
  /// Returns a list of doubles representing the HSL values. [h, s, l]
  static List<double> rgb2hsl(double r, double g, double b) {
    final double R = r / 255.0;
    final double G = g / 255.0;
    final double B = b / 255.0;

    final double maximum = max(R, max(G, B));
    final double minimum = min(R, min(G, B));
    final double delta = maximum - minimum;

    double h = 0.0;
    double s = 0.0;
    double l = (maximum + minimum) / 2.0;

    if (delta != 0.0) {
      if (l < 0.5) {
        s = delta / (maximum + minimum);
      } else {
        s = delta / (2.0 - maximum - minimum);
      }

      if (R == maximum) {
        h = (G - B) / delta;
      } else if (G == maximum) {
        h = 2.0 + (B - R) / delta;
      } else if (B == maximum) {
        h = 4.0 + (R - G) / delta;
      }

      h *= 60.0;

      if (h < 0.0) {
        h += 360.0;
      }
    }

    return [h, s, l];
  }

  /// Converts RGB values to a Flutter Color object.
  static Color rgb2color(double r, double g, double b) {
    return Color.fromRGBO(r.round(), g.round(), b.round(), 1.0);
  }

  /// Converts RGB values to an integer.
  static int rgb2int(double r, double g, double b) {
    return (255 << 24) | (r.round() << 16) | (g.round() << 8) | b.round();
  }

  /// Converts HSV values to xy coordinates in the CIE 1931 color space.
  ///
  /// Returns a list of doubles representing the xy values. [x, y, brightness]
  static List<double> hsv2xy(int h, double s, double v) {
    final List<double> rgb = hsv2rgb(h, s, v);
    return rgb2xy(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSV values to RGB values.
  ///
  /// Returns a list of doubles representing the RGB values. [r, g, b]
  static List<double> hsv2rgb(int h, double s, double v) {
    if (h < 0) {
      h = 0;
    } else if (h > 360) {
      h = 360;
    }

    double S;
    if (s > 1.0) {
      S = s / 100.0;
    } else {
      S = s;
    }

    double V;
    if (v > 1.0) {
      V = v / 100.0;
    } else {
      V = v;
    }

    double c = V * S;
    double x = c * (1 - (((h / 60) % 2) - 1).abs());
    double m = V - c;

    double r = 0;
    double g = 0;
    double b = 0;

    // Calculate RGB values based on hue.
    if (h >= 0 && h < 60) {
      r = c;
      g = x;
      b = 0.0;
    } else if (h >= 60 && h < 120) {
      r = x;
      g = c;
      b = 0.0;
    } else if (h >= 120 && h < 180) {
      r = 0.0;
      g = c;
      b = x;
    } else if (h >= 180 && h < 240) {
      r = 0.0;
      g = x;
      b = c;
    } else if (h >= 240 && h < 300) {
      r = x;
      g = 0.0;
      b = c;
    } else if (h >= 300 && h < 360) {
      r = c;
      g = 0.0;
      b = x;
    }

    // Convert to a linear RGB color space.
    r = (r + m) * 255.0;
    g = (g + m) * 255.0;
    b = (b + m) * 255.0;

    return [r, g, b];
  }

  /// Converts HSV values to a hex string.
  ///
  /// Returns a string representing the hex value. ffffffff
  static String hsv2hex(int h, double s, double v) {
    final List<double> rgb = hsv2rgb(h, s, v);
    return rgb2hex(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSV values to HSL values.
  ///
  /// Returns a list of doubles representing the HSL values. [h, s, l]
  static List<double> hsv2hsl(int h, double s, double v) {
    final List<double> rgb = hsv2rgb(h, s, v);
    return rgb2hsl(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSV values to a Flutter Color object.
  static Color hsv2color(int h, double s, double v) {
    final List<double> rgb = hsv2rgb(h, s, v);
    return rgb2color(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSV values to an integer.
  static int hsv2int(int h, double s, double v) {
    final List<double> rgb = hsv2rgb(h, s, v);
    return rgb2int(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a hex string to xy coordinates in the CIE 1931 color space.
  ///
  /// Returns a list of doubles representing the xy values. [x, y, brightness]
  static List<double> hex2xy(hex) {
    final List<double> rgb = hex2rgb(hex);
    return rgb2xy(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a hex string to RGB values.
  ///
  /// Returns a list of doubles representing the RGB values. [r, g, b]
  static List<double> hex2rgb(hex) {
    String hexString = hex.toString().replaceAll("#", "");
    hexString = hexString.replaceAll("0x", "");

    if (hexString.length == 3) {
      hexString = hexString.replaceAllMapped(
          RegExp(r'(.)(.)'), (Match m) => '${m[1]}${m[1]}${m[2]}${m[2]}');
    }

    if (hexString.length == 8) {
      hexString = hexString.substring(2);
    }

    final int r = int.parse(hexString.substring(0, 2), radix: 16);
    final int g = int.parse(hexString.substring(2, 4), radix: 16);
    final int b = int.parse(hexString.substring(4, 6), radix: 16);

    return [r.toDouble(), g.toDouble(), b.toDouble()];
  }

  /// Converts a hex string to HSV values.
  ///
  /// Returns a list of doubles representing the HSV values. [h, s, v]
  static List<double> hex2hsv(hex) {
    final List<double> rgb = hex2rgb(hex);
    return rgb2hsv(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a hex string to HSL values.
  ///
  /// Returns a list of doubles representing the HSL values. [h, s, l]
  static List<double> hex2hsl(hex) {
    final List<double> rgb = hex2rgb(hex);
    return rgb2hsl(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a hex string to a Flutter Color object.
  static Color hex2color(hex) {
    final List<double> rgb = hex2rgb(hex);
    return rgb2color(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a hex string to an integer.
  static int hex2int(hex) {
    final List<double> rgb = hex2rgb(hex);
    return rgb2int(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSL values to xy coordinates in the CIE 1931 color space.
  ///
  /// Returns a list of doubles representing the xy values. [x, y, brightness]
  static List<double> hsl2xy(int h, double s, double l) {
    final List<double> rgb = hsl2rgb(h, s, l);
    return rgb2xy(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSL values to RGB values.
  ///
  /// Returns a list of doubles representing the RGB values. [r, g, b]
  static List<double> hsl2rgb(int h, double s, double l) {
    if (h < 0) {
      h = 0;
    } else if (h > 360) {
      h = 360;
    }

    double S;
    if (s > 1.0) {
      S = s / 100;
    } else {
      S = s;
    }

    double L;
    if (l > 1.0) {
      L = l / 100;
    } else {
      L = l;
    }

    double c = (1 - (2 * L - 1).abs()) * S;
    double x = c * (1 - (((h / 60) % 2) - 1).abs());
    double m = L - c / 2;

    double r = 0;
    double g = 0;
    double b = 0;

    // Calculate RGB values based on hue.
    if (h >= 0 && h < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (h >= 60 && h < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (h >= 120 && h < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (h >= 180 && h < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (h >= 240 && h < 300) {
      r = x;
      g = 0;
      b = c;
    } else if (h >= 300 && h < 360) {
      r = c;
      g = 0;
      b = x;
    }

    // Convert to a linear RGB color space.
    r = (r + m) * 255;
    g = (g + m) * 255;
    b = (b + m) * 255;

    return [r, g, b];
  }

  /// Converts HSL values to HSV values.
  ///
  /// Returns a list of doubles representing the HSV values. [h, s, v]
  static List<double> hsl2hsv(int h, double s, double l) {
    final List<double> rgb = hsl2rgb(h, s, l);
    return rgb2hsv(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSL values to a hex string.
  ///
  /// Returns a string representing the hex value. ffffffff
  static String hsl2hex(int h, double s, double l) {
    final List<double> rgb = hsl2rgb(h, s, l);
    return rgb2hex(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSL values to a Flutter Color object.
  static Color hsl2color(int h, double s, double l) {
    final List<double> rgb = hsl2rgb(h, s, l);
    return rgb2color(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts HSL values to an integer.
  static int hsl2int(int h, double s, double l) {
    final List<double> rgb = hsl2rgb(h, s, l);
    return rgb2int(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a Flutter Color object to xy coordinates in the CIE 1931 color
  /// space.
  ///
  /// Returns a list of doubles representing the xy values. [x, y, brightness]
  static List<double> color2xy(Color color) {
    return rgb2xy(color.r, color.g, color.b);
  }

  /// Converts a Flutter Color object to RGB values.
  ///
  /// Returns a list of integers representing the RGB values. [r, g, b]
  static List<double> color2rgb(Color color) {
    return [color.r, color.g, color.b];
  }

  /// Converts a Flutter Color object to HSV values.
  ///
  /// Returns a list of doubles representing the HSV values. [h, s, v]
  static List<double> color2hsv(Color color) {
    final List<double> rgb = color2rgb(color);
    return rgb2hsv(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a Flutter Color object to a hex string.
  ///
  /// Returns a string representing the hex value. ffffffff
  static String color2hex(Color color) {
    return rgb2hex(color.r, color.g, color.b);
  }

  /// Converts a Flutter Color object to HSL values.
  ///
  /// Returns a list of doubles representing the HSL values. [h, s, l]
  static List<double> color2hsl(Color color) {
    final List<double> rgb = color2rgb(color);
    return rgb2hsl(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a Flutter Color object to an integer.
  static int color2int(Color color) {
    return rgb2int(color.r, color.g, color.b);
  }

  /// Converts an integer to xy coordinates in the CIE 1931 color space.
  ///
  /// Returns a list of doubles representing the xy values. [x, y, brightness]
  static List<double> int2xy(int integer) {
    final List<double> rgb = int2rgb(integer);
    return rgb2xy(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts an integer to RGB values.
  ///
  /// Returns a list of double representing the RGB values. [r, g, b]
  static List<double> int2rgb(int integer) {
    return [
      (integer >> 16 & 0xFF).toDouble(),
      (integer >> 8 & 0xFF).toDouble(),
      (integer & 0xFF).toDouble(),
    ];
  }

  /// Converts an integer to HSV values.
  ///
  /// Returns a list of doubles representing the HSV values. [h, s, v]
  static List<double> int2hsv(int integer) {
    final List<double> rgb = int2rgb(integer);
    return rgb2hsv(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts an integer to a hex string.
  ///
  /// Returns a string representing the hex value. ffffffff
  static String int2hex(int integer) {
    String hex = integer.toRadixString(16);

    while (hex.length < 6) {
      hex = "0$hex";
    }

    return hex;
  }

  /// Converts an integer to HSL values.
  ///
  /// Returns a list of doubles representing the HSL values. [h, s, l]
  static List<double> int2hsl(int integer) {
    final List<double> rgb = int2rgb(integer);
    return rgb2hsl(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts an integer to a Flutter Color object.
  static Color int2color(int integer) {
    return Color(integer);
  }

  /// Makes colors appear more natural on a screen.
  static double _gammaCorrection(double c) {
    double toReturn;

    if (c > 0.04045) {
      toReturn = pow((c + 0.055) / (1.0 + 0.055), 2.4).toDouble();
    } else {
      toReturn = c / 12.92;
    }

    return toReturn;
  }

  /// Makes colors appear more natural on a screen.
  static double _reverseGammaCorrection(double c) {
    double toReturn;

    if (c <= 0.0031308) {
      toReturn = 12.92 * c;
    } else {
      toReturn = (1.0 + 0.055) * pow(c, (1.0 / 2.4)) - 0.055;
    }

    return toReturn;
  }
}

/// A class that contains all the conversions for the [Color] object as
/// extensions.
extension Converters on Color {
  /// Converts a Flutter Color object to xy coordinates in the CIE 1931 color
  /// space.
  ///
  /// Returns a list of doubles representing the xy values. [x, y, brightness]
  List<double> toXy() {
    return ColorConverter.color2xy(this);
  }

  /// Converts a Flutter Color object to RGB values.
  ///
  /// Returns a list of integers representing the RGB values. [r, g, b]
  List<double> toRgb() {
    return ColorConverter.color2rgb(this);
  }

  /// Converts a Flutter Color object to HSV values.
  ///
  /// Returns a list of doubles representing the HSV values. [h, s, v]
  List<double> toHsv() {
    return ColorConverter.color2hsv(this);
  }

  /// Converts a Flutter Color object to a hex string.
  ///
  /// Returns a string representing the hex value. ffffffff
  String toHex() {
    return ColorConverter.color2hex(this);
  }

  /// Converts a Flutter Color object to HSL values.
  ///
  /// Returns a list of doubles representing the HSL values. [h, s, l]
  List<double> toHsl() {
    return ColorConverter.color2hsl(this);
  }

  /// Converts a Flutter Color object to an integer.
  int toInt() {
    return ColorConverter.color2int(this);
  }

  /// Converts a Flutter Color object to a [ColorXy] object.
  ColorXy toColorXy() {
    final List<double> xy = ColorConverter.color2xy(this);
    return ColorXy(xy[0], xy[1], xy[2]);
  }

  /// Converts a Flutter Color object to a [ColorRgb] object.
  ColorRgb toColorRgb() {
    final List<double> rgb = ColorConverter.color2rgb(this);
    return ColorRgb(rgb[0], rgb[1], rgb[2]);
  }
}
