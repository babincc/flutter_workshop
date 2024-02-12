// @author Christian Babin
// @version 1.5.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_tools.dart

import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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

  /// Capitalizes the first letter of the given `text`.
  ///
  /// ```dart
  /// capitalizeFirstLetter('howdy') == "Howdy"
  /// capitalizeFirstLetter('hello world') == "Hello world"
  /// ```
  static String capitalizeFirstLetter(String text) {
    if (text.length > 1) {
      return text[0].toUpperCase() + text.substring(1);
    } else {
      return text[0].toUpperCase();
    }
  }

  /// Capitalizes the first letter of each word in the given `text`.
  ///
  /// ```dart
  /// capitalizeEachWord('howdy') == "Howdy"
  /// capitalizeEachWord('hello world') == "Hello World"
  /// ```
  static String capitalizeEachWord(String text) {
    final words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      words[i] = capitalizeFirstLetter(words[i]);
    }

    return words.join(' ');
  }

  /// Returns `true` if the given lists contain all the same values.
  static bool listsMatch(List list1, List list2) =>
      const DeepCollectionEquality.unordered().equals(list1, list2);

  /// Returns `true` if the given lists contain all the same keys and values.
  static bool mapsMatch(Map map1, Map map2) =>
      const DeepCollectionEquality.unordered().equals(map1, map2);

  /// This method puts a zero width space in between every character in the
  /// given `text`.
  ///
  /// This is useful when you want a string that wraps to the next line at the
  /// character that hit the overflow limit rather than taking that whole word
  /// to the next line.
  ///
  /// ```
  /// Without this method:
  /// aaaaaaaaaa-bbbbbbbbbb-
  /// cccccccccc-dddddddddd
  ///
  /// With this method:
  /// aaaaaaaaaa-bbbbbbbbbb-cccccc
  /// cccc-dddddddddd
  /// ```
  static String wordBreak(String text) {
    StringBuffer buffer = StringBuffer();

    for (var element in text.runes) {
      buffer.write(String.fromCharCode(element));
      buffer.write("\u200B");
    }

    return buffer.toString();
  }
}
