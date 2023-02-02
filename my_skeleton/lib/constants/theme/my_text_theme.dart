import 'package:flutter/material.dart';

/// These are all of the text stylizations that are used throughout the app.
class MyTextTheme {
  /// The style of text within the [appBar] of the app.
  static TextStyle appBar = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: MyTextSize.medium,
  );

  /// The style of title or header text throughout the app.
  static TextStyle title = const TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: MyTextSize.large,
  );

  /// The style of sub-title text throughout the app.
  static TextStyle subTitle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontSize: MyTextSize.medium,
    color: Colors.grey,
  );

  /// The style of caption text throughout the app.
  static TextStyle caption = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: MyTextSize.small,
  );

  /// The style of regular text throughout the app.
  static TextStyle body = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: MyTextSize.medium,
  );
}

/// This is a standardization of text sizes to be used throughout the app.
class MyTextSize {
  /// The largest standard size.
  static const double extraLarge = 30.0;

  /// The second largest standard size.
  static const double large = 25.0;

  /// The middle of all the standard sizes.
  static const double medium = 19.0;

  /// The second smallest standard size.
  static const double small = 15.0;

  /// The smallest standard size.
  static const double extraSmall = 8.0;
}
