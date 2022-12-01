import 'package:flutter/material.dart';

/// These are the colors that are used throughout the app.
abstract class MyColorInterface {
  /// The main background color throughout the app.
  ///
  /// Currently set as black.
  Color background = Colors.black;

  /// The main color used throughout the app.
  ///
  /// Currently set as white.
  Color foreground = Colors.white;

  /// The main accent color used throughout the app.
  ///
  /// Currently set as grey.
  Color secondary = Colors.grey;

  /// The rare accent color used throughout the app.
  ///
  /// Currently set as a light blue.
  Color tertiary = Colors.lightBlueAccent;

  /// The color used to indicate failure or something important.
  ///
  /// Currently set as a bright red.
  Color failure = const Color(0xFFC91B08);

  /// The color used to indicate something important.
  ///
  /// Currently set as a bright yellow.
  Color notice = Colors.yellowAccent;

  /// The color used to indicate success or completion.
  ///
  /// Currently set as a bright green.
  Color success = const Color(0xFF2FBA31);
}
