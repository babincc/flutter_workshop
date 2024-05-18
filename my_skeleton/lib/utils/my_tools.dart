// @author Christian Babin
// @version 1.6.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_tools.dart

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/utils/debug_log.dart';

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
  static double randDouble(double min, double max, {int? roundTo}) {
    // If `roundTo` is greater than 18, this method will break. Let the
    // developer know this, and set it to 18.
    try {
      assert(roundTo == null || roundTo <= 18);
    } on AssertionError catch (_) {
      DebugLog.out(
        'WARNING: `roundTo` must be less than or equal to 18! It has been '
        'automatically switched to 18.',
        logType: LogType.warning,
      );
    }

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

    // Round the return value (if applicable).
    if (roundTo != null) {
      if (roundTo > 18) {
        roundTo = 18;
      }

      toReturn = roundDouble(toReturn, roundTo);

      // Check to see if the rounding has pushed the return value outside of the
      // range. If so, fix it.
      if (toReturn < min) {
        String absMinStr = min.toStringAsFixed(roundTo);
        toReturn = double.parse(absMinStr);
      } else if (toReturn > max) {
        String absMaxStr = min.toStringAsFixed(roundTo + 1);
        absMaxStr = absMaxStr.substring(0, absMaxStr.length - 1);
        toReturn = double.parse(absMaxStr);
      }
    }

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

  /// This method rounds a double to a certain number of places after the
  /// decimal.
  ///
  /// The double being rounded is `value`.
  ///
  /// `maxPlaces` is the number of places that `value` will be rounded to. If
  /// there are trailing zeros, they will be removed (excluding a solitary zero
  /// if that is all that follows the decimal). This behavior is why the word
  /// "max" as included in the parameter name.
  ///
  /// ### Examples
  ///
  /// The below example will return 3.2.
  ///
  /// ```dart
  /// roundDouble(3.2000, 4);
  /// ```
  ///
  /// The below example will return 3.2001.
  ///
  /// ```dart
  /// roundDouble(3.2001, 4);
  /// ```
  ///
  /// **Note:** This method does fall victim to "broken double math". Since some
  /// fractions can't be represented by binary numbers, this method could have
  /// slightly incorrect return values.
  ///
  /// Ex.
  ///
  /// roundDouble(73.4750, 2) returns 73.47 instead of 73.48.
  static double roundDouble(double value, int maxPlaces) {
    // If `places` is less than 0, let the developer know that 0 will be used
    // instead.
    try {
      assert(maxPlaces >= 0);
    } on AssertionError catch (_) {
      DebugLog.out(
        'WARNING: `places` must be greater than or equal to 0! To avoid '
        'returning `null`, 0 will be used instead of '
        '"${maxPlaces.toString()}".',
        logType: LogType.warning,
      );
    }

    // If `places` is less than 0, change it to 0.
    if (maxPlaces < 0) {
      maxPlaces = 0;
    }

    /// This value is how the algorithm knows how many places to round the
    /// `value` to.
    double mod = pow(10.0, maxPlaces).toDouble();

    // Round the `value`, and return it.
    return ((value * mod).round().toDouble() / mod);
  }

  /// This method converts degrees to radians.
  static double deg2Rad(num deg) => deg * (pi / 180.0);

  /// This method converts radians to degrees.
  static double rad2Deg(num rad) => rad * (180.0 / pi);

  /// This method determines if a given string is a number.
  ///
  /// Returns `true` if the string is a number.
  static bool isNumber(String string) => double.tryParse(string) != null;

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
