import 'package:flutter/material.dart';

/// These are all of the text stylizations that are used throughout the app.
class MyTextTheme {
  /// The style of text within the [AppBar] of the app.
  static const TextStyle AppBar = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: MyTextSize.Medium,
  );

  /// The style of title or header text throughout the app.
  static const TextStyle Title = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: MyTextSize.Large,
  );

  /// The style of sub-title text throughout the app.
  static const TextStyle SubTitle = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontSize: MyTextSize.Medium,
    color: Colors.grey,
  );

  /// The style of caption text throughout the app.
  static const TextStyle Caption = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: MyTextSize.Small,
  );

  /// The style of regular text throughout the app.
  static const TextStyle Body = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: MyTextSize.Medium,
  );
}

/// This is a standardization of text sizes to be used throughout the app.
class MyTextSize {
  /// The largest standard size.
  static const double ExtraLarge = 30.0;

  /// The second largest standard size.
  static const double Large = 25.0;

  /// The middle of all the standard sizes.
  static const double Medium = 19.0;

  /// The second smallest standard size.
  static const double Small = 15.0;

  /// The smallest standard size.
  static const double ExtraSmall = 8.0;
}
