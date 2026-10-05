import 'package:flutter/material.dart';

class MyColors {
  // ///////////////////////////// Color Scheme ///////////////////////////// //

  /// The color scheme for the app.
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    surface: background,
    onSurface: onBackground,
    seedColor: primary,
    onPrimary: onPrimary,
    primaryContainer: container,
    onPrimaryContainer: onContainer,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
  );

  // ///////////////////////////// Background /////////////////////////////// //

  /// The background color of the app.
  static const Color background = Color.fromRGBO(20, 20, 20, 1.0);

  /// The color of the text on the [background].
  static const Color onBackground = Color.fromRGBO(214, 214, 214, 1.0);

  // ////////////////////////////// Primary ///////////////////////////////// //

  /// The primary color of the app.
  static const Color primary = Color.fromRGBO(91, 155, 213, 1.0);

  /// The color of the text on [primary] elements.
  static const Color onPrimary = Colors.black;

  // ////////////////////////////// Secondary /////////////////////////////// //

  /// The secondary color of the app.
  static const Color secondary = Color.fromRGBO(68, 114, 196, 1.0);

  /// The color of the text on [secondary] elements.
  static const Color onSecondary = Colors.white;

  // ////////////////////////////// Container /////////////////////////////// //

  /// The primary container color.
  static const Color container = Color.fromRGBO(32, 32, 32, 1.0);

  /// The color of the text on primary [container]s.
  static const Color onContainer = Color.fromRGBO(214, 214, 214, 1.0);

  // ///////////////////////// Secondary Container ////////////////////////// //

  /// The secondary container color.
  static const Color secondaryContainer = Color.fromRGBO(41, 41, 41, 1.0);

  /// The color of the text on [secondaryContainer]s.
  static const Color onSecondaryContainer = Color.fromRGBO(214, 214, 214, 1.0);

  // ////////////////////////////// Text Field ////////////////////////////// //

  /// The text field color.
  static const Color textField = Color.fromRGBO(41, 41, 41, 1.0);

  /// The text field color when hovered over.
  static const Color textFieldHover = Color.fromRGBO(50, 50, 50, 1.0);

  /// The color of the hint on [textField]s.
  static const Color hint = Color.fromRGBO(214, 214, 214, 1.0);

  // /////////////////////////////// Status ///////////////////////////////// //

  /// The color of success.
  static const Color success = Color.fromRGBO(107, 160, 43, 1.0);

  /// The color of warnings.
  static const Color warning = Color.fromRGBO(234, 163, 0, 1.0);

  /// The color of errors.
  static const Color error = Color.fromRGBO(183, 84, 87, 1.0);

  /// The color of disabled elements.
  static const Color disabled = Color.fromRGBO(83, 83, 83, 1.0);

  /// The color of the text on [disabled] elements.
  static const Color onDisabled = Color.fromRGBO(142, 142, 142, 1.0);

  // /////////////////////////////// Divider //////////////////////////////// //

  /// The color of dividers.
  static const Color divider = Color.fromRGBO(102, 102, 102, 1.0);

  // //////////////////////////////// Border //////////////////////////////// //

  /// The color of borders.
  static const Color border = Color.fromRGBO(102, 102, 102, 1.0);

  /// The color of focused borders.
  static const Color borderFocused = Color.fromRGBO(122, 122, 122, 1.0);
}
