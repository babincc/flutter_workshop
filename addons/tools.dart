// @author Christian Babin
// @version 1.0.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/tools.dart

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

/// This is a collection of generic tools. These range from random number
/// generators to network connection checkers.
class Tools {
  /// This method generates and returns a random integer from `min` to `max`
  /// (inclusive).
  static int randInt(int min, int max) {
    // If `min` is greater than `max` let the developer know that their values
    // will be swapped.
    try {
      assert(min <= max);
    } on AssertionError catch (e) {
      print("WARNING: \`min\` must be less than or equal to \`max\`! To " +
          "avoid returning \`null\`, the values of \`min\` and \`max\` have " +
          "been swapped.");
      print(e);
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

    // Find the random number in the range, and return it.
    return Random().nextInt((max + 1) - min) + min;
  }

  /// This method generates and returns a random double from `min` to `max`
  /// (inclusive).
  ///
  /// `roundTo` is the number of places the returned value should be rounded to.
  /// If it is `null`, no extra rounding will be done.
  static double randDouble(double min, double max, {int? roundTo}) {
    // If `min` is greater than `max` let the developer know that their values
    // will be swapped.
    try {
      assert(min <= max);
    } on AssertionError catch (e) {
      print("WARNING: \`min\` must be less than or equal to \`max\`! To " +
          "avoid returning \`null\`, the values of \`min\` and \`max\` have " +
          "been swapped.");
      print(e);
    }

    // If `roundTo` is greater than 18, this method will break. Let the
    // developer know this, and set it to 18.
    try {
      assert(min <= max);
    } on AssertionError catch (e) {
      print("WARNING: \`roundTo\` must be less than or equal to 18! It has " +
          "been automatically switched to 18.");
      print(e);
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
    } on AssertionError catch (e) {
      print("WARNING: \`places\` must be greater than or equal to 0! To " +
          "avoid returning \`null\`, 0 will be used instead of " +
          "\"${maxPlaces.toString()}\".");
      print(e);
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
  static double degToRad(num deg) => deg * (pi / 180.0);

  /// This method converts radians to degrees.
  static double radToDeg(num rad) => rad * (180.0 / pi);

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
}
