import 'package:flutter/material.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';

class MyColors {
  const MyColors(this.themeType);

  /// The type of theme to use.
  ///
  /// Dark or light mode.
  final ThemeType themeType;

  // ///////////////////////////// Color Scheme ///////////////////////////// //

  /// A color scheme designed to have light background elements and dark
  /// foreground elements.
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(0, 127, 195, 1.0),
    brightness: Brightness.light,
  );

  /// A color scheme designed to have dark background elements and light
  /// foreground elements.
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(0, 127, 195, 1.0),
    brightness: Brightness.dark,
  );

  /// Returns the color scheme for the current [themeType].
  ColorScheme get colorScheme =>
      themeType == ThemeType.light ? lightColorScheme : darkColorScheme;

  // ////////////////////////////// Container /////////////////////////////// //

  /// A light container color.
  static const Color lightContainer = Color.fromRGBO(240, 240, 245, 1.0);

  /// A dark container color.
  static const Color darkContainer = Color.fromRGBO(39, 39, 40, 1.0);

  /// Returns the container color for the current [themeType].
  Color get container =>
      themeType == ThemeType.light ? lightContainer : darkContainer;

  // ///////////////////////// Secondary Container ////////////////////////// //

  /// A light container color.
  static const Color lightSecondaryContainer =
      Color.fromRGBO(246, 246, 246, 1.0);

  /// A dark container color.
  static const Color darkSecondaryContainer = Color.fromRGBO(40, 40, 39, 1.0);

  /// Returns the secondary container color for the current [themeType].
  Color get secondaryContainer => themeType == ThemeType.light
      ? lightSecondaryContainer
      : darkSecondaryContainer;

  // ////////////////////////////// Text Field ////////////////////////////// //

  /// A light text field color.
  static const Color lightTextField = Color.fromRGBO(230, 230, 231, 1.0);

  /// A dark text field color.
  static const Color darkTextField = Color.fromRGBO(50, 50, 54, 1.0);

  /// Returns the text field color for the current [themeType].
  Color get textField =>
      themeType == ThemeType.light ? lightTextField : darkTextField;
}
