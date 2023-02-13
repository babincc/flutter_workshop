import 'package:flutter/material.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';

class MyColors {
  const MyColors(this.themeType);

  final ThemeType themeType;

  //////////////////////////////// Color Scheme ////////////////////////////////

  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(0, 127, 195, 1.0),
    brightness: Brightness.light,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(0, 127, 195, 1.0),
    brightness: Brightness.dark,
  );

  ColorScheme get colorScheme =>
      themeType == ThemeType.light ? lightColorScheme : darkColorScheme;

  ///////////////////////////////// Container //////////////////////////////////

  static const Color lightContainer = Color.fromRGBO(240, 240, 245, 1.0);

  static const Color darkContainer = Color.fromRGBO(39, 39, 40, 1.0);

  Color get container =>
      themeType == ThemeType.light ? lightContainer : darkContainer;

  //////////////////////////// Secondary Container /////////////////////////////

  static const Color lightSecondaryContainer =
      Color.fromRGBO(246, 246, 246, 1.0);

  static const Color darkSecondaryContainer = Color.fromRGBO(40, 40, 39, 1.0);

  Color get secondaryContainer => themeType == ThemeType.light
      ? lightSecondaryContainer
      : darkSecondaryContainer;

  ///////////////////////////////// Text Field /////////////////////////////////

  static const Color lightTextField = Color.fromRGBO(230, 230, 231, 1.0);

  static const Color darkTextField = Color.fromRGBO(50, 50, 54, 1.0);

  Color get textField =>
      themeType == ThemeType.light ? lightTextField : darkTextField;
}
