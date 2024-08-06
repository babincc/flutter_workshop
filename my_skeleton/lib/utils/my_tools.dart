// @author Christian Babin
// @version 3.0.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_tools.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';

/// This is a collection of generic tools. These range from random number
/// generators to network connection checkers.
class MyTools {
  /// This method generates and returns a random integer from `min` to `max`
  /// (inclusive).
  static int randInt(int min, int max) {
    // If `min` and `max` are the same number, just return that number.
    if (min == max) {
      return min;
    }

    // If `min` is greater than `max`, swap their values.
    if (min > max) {
      int temp = min;
      min = max;
      max = temp;
    }

    // Find the random number in the range, and return it.
    return Random().nextInt((max + 1) - min) + min;
  }

  /// This method generates and returns a random integer from `min` to `max`
  /// (inclusive), excluding `exclude`.
  ///
  /// If `min`, `max`, and `exclude` are all the same number, an exception is
  /// thrown.
  static int randIntExcluding(int min, int max, int exclude) {
    // If `min`, `max`, and `exclude` are all the same number, throw an
    // exception.
    if (min == max && max == exclude) {
      throw Exception('min, max, and exclude cannot all be the same number.');
    }

    // If `min` and `max` are the same number, just return that number.
    if (min == max) {
      return min;
    }

    // If `min` is greater than `max`, swap their values.
    if (min > max) {
      int temp = min;
      min = max;
      max = temp;
    }

    // If `exclude` is less than `min` or greater than `max`, just return a
    // random number in the range.
    if (exclude < min || exclude > max) {
      return randInt(min, max);
    }

    // If `exclude` is equal to `min` or `max`, return a random number in the
    // range, excluding `exclude`.
    if (exclude == min) {
      return randInt(min + 1, max);
    } else if (exclude == max) {
      return randInt(min, max - 1);
    }

    // Random numbers on both sides of `exclude`.
    List<int> randNums = [];

    // Generate a random number in the range, excluding `exclude`.
    randNums.add(randInt(min, exclude - 1));
    randNums.add(randInt(exclude + 1, max));

    return randNums[randInt(0, 1)];
  }

  /// This method generates and returns a random double from `min` to `max`
  /// (inclusive).
  ///
  /// `roundTo` is the number of places the returned value should be rounded to.
  /// If it is `null`, no extra rounding will be done.
  static double randDouble(double min, double max) {
    // If `min` and `max` are the same number, just return that number.
    if (min == max) {
      return min;
    }

    // If `min` is greater than `max`, swap their values.
    if (min > max) {
      double temp = min;
      min = max;
      max = temp;
    }

    // Find the random number in the range.
    double toReturn = (Random().nextDouble() * (max - min)) + min;

    return toReturn;
  }

  /// This method generates and returns a random color.
  static Color randColor({bool randomizeOpacity = false}) {
    int red = randInt(0, 255);
    int green = randInt(0, 255);
    int blue = randInt(0, 255);

    return Color.fromRGBO(
        red, green, blue, randomizeOpacity ? randDouble(0.0, 1.0) : 1.0);
  }

  /// This method returns a color for text, icons, etc. based on the given
  /// `bgColor` that it will be displayed on top of.
  static Color getForegroundColor(Color bgColor) {
    int red = bgColor.red;
    int green = bgColor.green;
    int blue = bgColor.blue;

    double darkness =
        1 - (((0.299 * red) + (0.587 * green) + (0.114 * blue)) / 255);
    if (darkness < 0.5) {
      // The background is light.
      return Colors.black;
    } else {
      // The background is dark.
      return Colors.white;
    }
  }

  /// This method converts degrees to radians.
  static double deg2Rad(num deg) => deg * (pi / 180.0);

  /// This method converts radians to degrees.
  static double rad2Deg(num rad) => rad * (180.0 / pi);

  /// This method checks to see if the device is connected to the internet.
  ///
  /// It returns `true` if the device is connected to the internet; otherwise,
  /// it returns `false`.
  ///
  /// WARNING: This method will not work in China, North Korea, or any place
  /// where the government censors "google.com".
  static Future<bool> isConnectedToNetwork() async {
    bool isConnected = false;

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }

    return isConnected;
  }

  /// This method scrambles the characters in a string. A scrambled string can
  /// be run through again to be unscrambled.
  static String scrambleString(String data) {
    // Split the data string into an array of each individual letter.
    List<String> dataAsArray = data.split('');

    // Loop through the array of letters and swap every pair of letters.
    // ex. Given two strings (the first one having an even amount of letters and
    //     the second one having an odd amount), this is what we expect from the
    //     loop:
    //     Given:
    //          a, b, c, d, e, f
    //            - and -
    //          l, m, n, o, p
    //     this loop would change them to be:
    //          b, a, d, c, f, e
    //            - and -
    //          m, l, o, n, p
    for (int i = 0; i < dataAsArray.length; i++) {
      // Don't swap if we are on the last letter.
      if (i + 1 >= dataAsArray.length) {
        continue;
      }

      // Insert the current letter to the right of the next letter.
      // ex. Given current index is 2
      //     a, b, c, d, e
      //     would become:
      //     a, b, c, d, c, e
      dataAsArray.insert(i + 2, dataAsArray[i]);

      // Delete the current letter.
      // ex. Given current index is 2
      //     a, b, c, d, c, e
      //     would become:
      //     a, b, d, c, e
      dataAsArray.removeAt(i);

      // Move the current index up by one. If we did not do this, then all this
      // method would do is just put the first letter at the end and nothing
      // else would change.
      i++;
    }

    // Put all the letters together as one string and return it.
    return dataAsArray.join();
  }

  /// Reverse the given `data`.
  static String reverseString(String data) =>
      String.fromCharCodes(data.runes.toList().reversed);

  /// This method encodes plaintext in base64.
  static String encodeBase64(String plaintext) {
    // First, convert the plaintext string to bytes.
    List<int> dataBytes = utf8.encode(plaintext);

    // Then, encode those bytes.
    return base64.encode(dataBytes);
  }

  /// This method decodes a string that was encrypted in base64.
  ///
  /// If it fails, `null` is returned.
  static String? decodeBase64(String ciphertext) {
    // Convert the ciphertext string into bytes and decode the string at the
    // same time.
    List<int> dataBytes;
    try {
      dataBytes = base64.decode(ciphertext);
    } on Exception {
      // This string was not encoded in base64, thus it cannot be decoded.
      return null;
    }

    // Finally, convert the bytes into a readable string and return that.
    return utf8.decode(dataBytes);
  }

  /// This method returns the line height of a specific style of text.
  static double getLineHeight(TextStyleType styleType) {
    late final double textHeight;
    late final double fontSize;

    switch (styleType) {
      case TextStyleType.displayLarge:
        textHeight = MyMeasurements.defaultHeightDisplayLarge;
        fontSize = MyMeasurements.defaultFontSizeDisplayLarge;
        break;
      case TextStyleType.displayMedium:
        textHeight = MyMeasurements.defaultHeightDisplayMedium;
        fontSize = MyMeasurements.defaultFontSizeDisplayMedium;
        break;
      case TextStyleType.displaySmall:
        textHeight = MyMeasurements.defaultHeightDisplaySmall;
        fontSize = MyMeasurements.defaultFontSizeDisplaySmall;
        break;
      case TextStyleType.headlineLarge:
        textHeight = MyMeasurements.defaultHeightHeadlineLarge;
        fontSize = MyMeasurements.defaultFontSizeHeadlineLarge;
        break;
      case TextStyleType.headlineMedium:
        textHeight = MyMeasurements.defaultHeightHeadlineMedium;
        fontSize = MyMeasurements.defaultFontSizeHeadlineMedium;
        break;
      case TextStyleType.headlineSmall:
        textHeight = MyMeasurements.defaultHeightHeadlineSmall;
        fontSize = MyMeasurements.defaultFontSizeHeadlineSmall;
        break;
      case TextStyleType.titleLarge:
        textHeight = MyMeasurements.defaultHeightTitleLarge;
        fontSize = MyMeasurements.defaultFontSizeTitleLarge;
        break;
      case TextStyleType.titleMedium:
        textHeight = MyMeasurements.defaultHeightTitleMedium;
        fontSize = MyMeasurements.defaultFontSizeTitleMedium;
        break;
      case TextStyleType.titleSmall:
        textHeight = MyMeasurements.defaultHeightTitleSmall;
        fontSize = MyMeasurements.defaultFontSizeTitleSmall;
        break;
      case TextStyleType.bodyLarge:
        textHeight = MyMeasurements.defaultHeightBodyLarge;
        fontSize = MyMeasurements.defaultFontSizeBodyLarge;
        break;
      case TextStyleType.bodyMedium:
        textHeight = MyMeasurements.defaultHeightBodyMedium;
        fontSize = MyMeasurements.defaultFontSizeBodyMedium;
        break;
      case TextStyleType.bodySmall:
        textHeight = MyMeasurements.defaultHeightBodySmall;
        fontSize = MyMeasurements.defaultFontSizeBodySmall;
        break;
      case TextStyleType.labelLarge:
        textHeight = MyMeasurements.defaultHeightLabelLarge;
        fontSize = MyMeasurements.defaultFontSizeLabelLarge;
        break;
      case TextStyleType.labelMedium:
        textHeight = MyMeasurements.defaultHeightLabelMedium;
        fontSize = MyMeasurements.defaultFontSizeLabelMedium;
        break;
      case TextStyleType.labelSmall:
        textHeight = MyMeasurements.defaultHeightLabelSmall;
        fontSize = MyMeasurements.defaultFontSizeLabelSmall;
        break;
    }

    return textHeight * fontSize;
  }

  /// This method measures the size of the given `widget`.
  static Future<Size?> measureWidgetSize(
    BuildContext context,
    Widget widget,
  ) async {
    final GlobalKey<_SizeMeasureWidgetState> key = GlobalKey();
    final Completer<Size?> completer = Completer<Size?>();

    // Create an Offstage widget and add it to the Overlay
    final overlayEntry = OverlayEntry(
      builder: (_) => Offstage(
        child: _SizeMeasureWidget(key: key, child: widget),
      ),
    );

    // Delay the insertion until the current frame is complete.
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Overlay.of(context).insert(overlayEntry);

        // Schedule a frame to ensure the widget is fully laid out.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final Size? size = _SizeMeasureWidget.getSize(key);

          // Complete the future with the size.
          completer.complete(size);

          // Remove the widget from the Overlay.
          overlayEntry.remove();
        });
      },
    );

    return completer.future;
  }
}

/// Text style types.
enum TextStyleType {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

/// This is a collection of tools for working with percentages.
extension PercentageTools on num {
  /// This method returns what `this` percent of the given `num` is.
  ///
  /// This uses the formula: `is`/`of` == `%`/`100`
  ///
  /// So, `is` = (`of` * `%)` / `100`
  ///
  /// ```dart
  /// // For example, 50% of 10 is what?
  /// // is/10 == 50/100
  /// // is = (10 * 50) / 100
  /// // is = 5
  /// 50.percentOf(10) == 5 // So, 50% of 10 is 5.
  /// ```
  num percentOf(num num) => (num * this) / 100;

  /// This method returns what the given `num` is `this` percent of.
  ///
  /// This uses the formula: `is`/`of` == `%`/`100`
  ///
  /// So, `of` = (`is` * `100`) / `%`
  ///
  /// ```dart
  /// // For example, 50% of what is 5?
  /// // 5/of == 50/100
  /// // of = (5 * 100) / 50
  /// // of = 10
  /// 50.percentOfWhatIs(5) == 10 // So, 50% of 10 is 5.
  /// ```
  num percentOfWhatIs(num num) => (num * 100) / this;

  /// This method returns the percentage of the given `num` that `this` number
  /// is.
  ///
  /// This uses the formula: `is`/`of` == `%`/`100`
  ///
  /// So, `%` = (`100` * `is`) / `of`
  ///
  /// ```dart
  /// // For example, 5 is what percent of 10?
  /// // 5/10 == %/100
  /// // % = (100 * 5) / 10
  /// // % = 50
  /// 5.isWhatPercentOf(10) == 50 // So, 5 is 50% of 10.
  /// ```
  num isWhatPercentOf(num num) => (100 * this) / num;
}

/// This is a collection of tools for working with numbers.
extension NumTools on num {
  /// This method rounds `this` number to the given number of decimal `places`.
  double roundTo(int places) {
    final num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }

  /// This method converts `this` number to a currency string.
  ///
  /// If `withCents` is `true`, the cents will be included in the string.
  ///
  /// ```dart
  /// 1.toCurrencyString() == '1'
  /// 1000.toCurrencyString() == '1,000'
  /// 500.25.toCurrencyString() == '500'
  ///
  /// 1.toCurrencyStringWithCents(true) == '1.00'
  /// 1000.toCurrencyStringWithCents(true) == '1,000.00'
  /// 500.25.toCurrencyStringWithCents(true) == '500.25'
  /// ```
  String toCurrencyString([bool withCents = false]) {
    final NumberFormat currency;
    if (withCents) {
      currency = NumberFormat('#,##0.00', 'en_US');
    } else {
      currency = NumberFormat('#,##0', 'en_US');
    }

    return currency.format(this);
  }
}

/// A widget that measures the size of its child.
class _SizeMeasureWidget extends StatefulWidget {
  const _SizeMeasureWidget({super.key, required this.child});

  final Widget child;

  static Size? getSize(
      // ignore: library_private_types_in_public_api
      GlobalKey<_SizeMeasureWidgetState> key) {
    if (key.currentState != null && key.currentState!.mounted) {
      return key.currentState!.calculateSize();
    }

    return null;
  }

  @override
  State<_SizeMeasureWidget> createState() => _SizeMeasureWidgetState();
}

class _SizeMeasureWidgetState extends State<_SizeMeasureWidget> {
  final GlobalKey _sizeKey1 = GlobalKey();
  final GlobalKey _sizeKey2 = GlobalKey();

  Size? _screenSize;

  // double? _availableWidth;
  // double? _availableHeight;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: _screenSize!.height),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: _screenSize!.width),
              child: Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: _screenSize!.width),
                    child: widget.child,
                  ),
                  // TODO Making this "Expanded" will make the width of the widget
                  //  cut in half if the widget we are measuring is also an
                  //  "Expanded" widget.
                  Expanded(
                    child: Container(
                      key: _sizeKey1,
                    ),
                  ),
                ],
              ),
            ),
            // TODO Making this "Expanded" will make the height of the widget cut
            //  in half if the widget we are measuring is also an "Expanded"
            //  widget.
            Expanded(
              child: Container(
                key: _sizeKey2,
              ),
            )
          ],
        ),
      ),
    );
  }

  Size? calculateSize() {
    if (_screenSize == null) return null;

    final BuildContext? currentContext1 = _sizeKey1.currentContext;
    final BuildContext? currentContext2 = _sizeKey2.currentContext;

    if (currentContext1 == null) return null;
    if (currentContext2 == null) return null;

    final RenderObject? renderBox1 = currentContext1.findRenderObject();
    final RenderObject? renderBox2 = currentContext2.findRenderObject();

    if (renderBox1 == null) return null;
    if (renderBox2 == null) return null;

    if (renderBox1 is! RenderBox) return null;
    if (renderBox2 is! RenderBox) return null;

    final double width = _screenSize!.width - renderBox1.size.width;
    final double height = _screenSize!.height - renderBox2.size.height;

    return Size(width, height);
  }
}
