import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/enums/my_theme_type.dart';

class MyColors {
  const MyColors(this.themeType);

  /// The type of theme to use.
  ///
  /// Dark or light mode.
  final MyThemeType themeType;

  // ///////////////////////////// Color Scheme ///////////////////////////// //

  /// A color scheme designed to have light background elements and dark
  /// foreground elements.
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    surface: lightBackground,
    onSurface: onLightBackground,
    seedColor: lightPrimary,
    onPrimary: onLightPrimary,
    primaryContainer: lightContainer,
    onPrimaryContainer: onLightContainer,
    secondaryContainer: lightSecondaryContainer,
    onSecondaryContainer: onLightSecondaryContainer,
  );

  /// A color scheme designed to have dark background elements and light
  /// foreground elements.
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    surface: darkBackground,
    onSurface: onDarkBackground,
    seedColor: darkPrimary,
    onPrimary: onDarkPrimary,
    primaryContainer: darkContainer,
    onPrimaryContainer: onDarkContainer,
    secondaryContainer: darkSecondaryContainer,
    onSecondaryContainer: onDarkSecondaryContainer,
  );

  /// Returns the color scheme for the current [themeType].
  ColorScheme get colorScheme => identical(themeType, MyThemeType.light)
      ? lightColorScheme
      : darkColorScheme;

  // ///////////////////////////// Background /////////////////////////////// //

  /// The background color of the app in light mode.
  static const Color lightBackground = Color.fromRGBO(235, 235, 235, 1.0);

  /// The background color of the app in dark mode.
  static const Color darkBackground = Color.fromRGBO(28, 28, 28, 1.0);

  /// Returns the background color for the current [themeType].
  Color get background => identical(themeType, MyThemeType.light)
      ? lightBackground
      : darkBackground;

  /// The color of the text on the background in light mode.
  static Color onLightBackground = Colors.black;

  /// The color of the text on the background in dark mode.
  static Color onDarkBackground = Colors.white;

  /// Returns the color of the text on the background for the current
  /// [themeType].
  Color get onBackground => identical(themeType, MyThemeType.light)
      ? onLightBackground
      : onDarkBackground;

  // ////////////////////////////// Primary ///////////////////////////////// //

  /// The primary color of the app in light mode.
  static const Color lightPrimary = Color.fromRGBO(0, 127, 195, 1.0);

  /// The primary color of the app in dark mode.
  static const Color darkPrimary = Color.fromRGBO(0, 127, 195, 1.0);

  /// Returns the primary color for the current [themeType].
  Color get primary =>
      identical(themeType, MyThemeType.light) ? lightPrimary : darkPrimary;

  /// The color of the text on primary elements in light mode.
  static Color onLightPrimary = Colors.white;

  /// The color of the text on primary elements in dark mode.
  static Color onDarkPrimary = Colors.white;

  /// Returns the color of the text on primary elements for the current
  /// [themeType].
  Color get onPrimary =>
      identical(themeType, MyThemeType.light) ? onLightPrimary : onDarkPrimary;

  // ////////////////////////////// Secondary /////////////////////////////// //

  /// The secondary color of the app in light mode.
  static const Color lightSecondary = Color.fromRGBO(31, 168, 242, 1.0);

  /// The secondary color of the app in dark mode.
  static const Color darkSecondary = Color.fromRGBO(31, 168, 242, 1.0);

  /// Returns the secondary color for the current [themeType].
  Color get secondary =>
      identical(themeType, MyThemeType.light) ? lightSecondary : darkSecondary;

  /// The color of the text on secondary elements in light mode.
  static Color onLightSecondary = Colors.black;

  /// The color of the text on secondary elements in dark mode.
  static Color onDarkSecondary = Colors.black;

  /// Returns the color of the text on secondary elements for the current
  /// [themeType].
  Color get onSecondary => identical(themeType, MyThemeType.light)
      ? onLightSecondary
      : onDarkSecondary;

  // ////////////////////////////// Container /////////////////////////////// //

  /// The primary container color in light mode.
  static const Color lightContainer = Color.fromRGBO(240, 240, 245, 1.0);

  /// The primary container color in dark mode.
  static const Color darkContainer = Color.fromRGBO(39, 39, 40, 1.0);

  /// Returns the primary container color for the current [themeType].
  Color get container =>
      identical(themeType, MyThemeType.light) ? lightContainer : darkContainer;

  /// The color of the text on primary containers in light mode.
  static Color onLightContainer = Colors.black;

  /// The color of the text on primary containers in dark mode.
  static Color onDarkContainer = Colors.white;

  /// Returns the color of the text on primary containers for the current
  /// [themeType].
  Color get onContainer => identical(themeType, MyThemeType.light)
      ? onLightContainer
      : onDarkContainer;

  // ///////////////////////// Secondary Container ////////////////////////// //

  /// The secondary container color in light mode.
  static const Color lightSecondaryContainer =
      Color.fromRGBO(246, 246, 246, 1.0);

  /// The secondary container color in dark mode.
  static const Color darkSecondaryContainer = Color.fromRGBO(40, 40, 39, 1.0);

  /// Returns the secondary container color for the current [themeType].
  Color get secondaryContainer => identical(themeType, MyThemeType.light)
      ? lightSecondaryContainer
      : darkSecondaryContainer;

  /// The color of the text on secondary containers in light mode.
  static Color onLightSecondaryContainer = Colors.black;

  /// The color of the text on secondary containers in dark mode.
  static Color onDarkSecondaryContainer = Colors.white;

  /// Returns the color of the text on secondary containers for the current
  /// [themeType].
  Color get onSecondaryContainer => identical(themeType, MyThemeType.light)
      ? onLightSecondaryContainer
      : onDarkSecondaryContainer;

  // ////////////////////////////// Text Field ////////////////////////////// //

  /// The text field color in light mode.
  static const Color lightTextField = Color.fromRGBO(230, 230, 231, 1.0);

  /// The text field color in dark mode.
  static const Color darkTextField = Color.fromRGBO(50, 50, 54, 1.0);

  /// Returns the text field color for the current [themeType].
  Color get textField =>
      identical(themeType, MyThemeType.light) ? lightTextField : darkTextField;

  /// The color of the hint on text fields in light mode.
  static const Color lightHint = Color.fromRGBO(100, 100, 100, 1.0);

  /// The color of the hint on text fields in dark mode.
  static const Color darkHint = Color.fromRGBO(170, 170, 170, 1.0);

  /// Returns the color of the hint on text fields for the current [themeType].
  Color get hint =>
      identical(themeType, MyThemeType.light) ? lightHint : darkHint;

  // /////////////////////////////// Status ///////////////////////////////// //

  /// The color of success in light mode.
  static const Color lightSuccess = Color.fromRGBO(19, 114, 8, 1.0);

  /// The color of success in dark mode.
  static const Color darkSuccess = Color.fromRGBO(19, 114, 8, 1.0);

  /// Returns the color of success for the current [themeType].
  Color get success =>
      identical(themeType, MyThemeType.light) ? lightSuccess : darkSuccess;

  /// The color of warnings in light mode.
  static const Color lightWarning = Color.fromRGBO(184, 155, 7, 1.0);

  /// The color of warnings in dark mode.
  static const Color darkWarning = Color.fromRGBO(184, 155, 7, 1.0);

  /// Returns the color of warnings for the current [themeType].
  Color get warning =>
      identical(themeType, MyThemeType.light) ? lightWarning : darkWarning;

  /// The color of errors in light mode.
  static const Color lightError = Color.fromRGBO(114, 8, 8, 1.0);

  /// The color of errors in dark mode.
  static const Color darkError = Color.fromRGBO(114, 8, 8, 1.0);

  /// Returns the color of errors for the current [themeType].
  Color get error =>
      identical(themeType, MyThemeType.light) ? lightError : darkError;

  /// The color of disabled elements in light mode.
  static const Color lightDisabled = Color.fromRGBO(200, 200, 200, 1.0);

  /// The color of disabled elements in dark mode.
  static const Color darkDisabled = Color.fromRGBO(50, 50, 50, 1.0);

  /// Returns the color of disabled elements for the current [themeType].
  Color get disabled =>
      identical(themeType, MyThemeType.light) ? lightDisabled : darkDisabled;

  /// The color of the text on disabled elements in light mode.
  static const Color onLightDisabled = Color.fromRGBO(100, 100, 100, 1.0);

  /// The color of the text on disabled elements in dark mode.
  static const Color onDarkDisabled = Color.fromRGBO(170, 170, 170, 1.0);

  /// Returns the color of the text on disabled elements for the current
  /// [themeType].
  Color get onDisabled => identical(themeType, MyThemeType.light)
      ? onLightDisabled
      : onDarkDisabled;

  // /////////////////////////////// Divider //////////////////////////////// //

  /// The color of dividers in light mode.
  static const Color lightDivider = Color.fromRGBO(203, 203, 203, 1.0);

  /// The color of dividers in dark mode.
  static const Color darkDivider = Color.fromRGBO(203, 203, 203, 1.0);

  /// Returns the color of dividers for the current [themeType].
  Color get divider =>
      identical(themeType, MyThemeType.light) ? lightDivider : darkDivider;

  // //////////////////////////////// Misc. ///////////////////////////////// //

  /// A color near black to use throughout the app.
  static const Color nearBlack = Color.fromRGBO(25, 25, 25, 1.0);

  /// A color near white to use throughout the app.
  static const Color nearWhite = Color.fromRGBO(246, 246, 246, 1.0);
}
