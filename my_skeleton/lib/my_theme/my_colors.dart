import 'package:flutter/material.dart';

/// These are the colors that are used throughout the app.
class MyColors {
  /// The main background color throughout the app.
  ///
  /// Currently set as black.
  static const Color background = Color.fromARGB(255, 255, 255, 255);

  /// The main color used throughout the app.
  ///
  /// Currently set as white.
  static const Color primary = Color.fromARGB(255, 0, 0, 0);

  /// The main accent color used throughout the app.
  ///
  /// Currently set as grey.
  static const Color secondary = Colors.grey;

  /// The rare accent color used throughout the app.
  ///
  /// Currently set as a light blue.
  static const Color tertiary = Colors.lightBlueAccent;

  /// The color used to indicate failure or something important.
  ///
  /// Currently set as a bright red.
  static const Color failure = Color(0xFFC91B08);

  /// The color used to indicate something important.
  ///
  /// Currently set as a bright yellow.
  static const Color notice = Colors.yellowAccent;

  /// The color used to indicate success or completion.
  ///
  /// Currently set as a bright green.
  static const Color success = Color(0xFF2FBA31);
}
