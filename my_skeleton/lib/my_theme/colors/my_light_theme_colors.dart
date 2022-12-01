import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/colors/my_color_interface.dart';

/// These are the colors that are used throughout the app.
class MyLightThemeColors implements MyColorInterface {
  /// The main background color throughout the app.
  ///
  /// Currently set as white.
  @override
  Color background = Colors.white;

  /// The main color used throughout the app.
  ///
  /// Currently set as black.
  @override
  Color foreground = Colors.black;

  /// The main accent color used throughout the app.
  ///
  /// Currently set as grey.
  @override
  Color secondary = Colors.grey;

  /// The rare accent color used throughout the app.
  ///
  /// Currently set as a light blue.
  @override
  Color tertiary = Colors.lightBlueAccent;

  /// The color used to indicate failure or something important.
  ///
  /// Currently set as a bright red.
  @override
  Color failure = const Color(0xFFC91B08);

  /// The color used to indicate something important.
  ///
  /// Currently set as a bright yellow.
  @override
  Color notice = Colors.yellowAccent;

  /// The color used to indicate success or completion.
  ///
  /// Currently set as a bright green.
  @override
  Color success = const Color(0xFF2FBA31);
}
