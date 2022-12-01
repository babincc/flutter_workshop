import 'package:flutter/material.dart';

/// These are the fields that are needed to make a new theme. Light, dark, etc.
abstract class MyThemeInterface {
  ThemeData get themeData => ThemeData();

  InputDecoration myInputDecoration(
    BuildContext context,
    TextEditingController controller, {
    String? label,
    String? hint,
    Icon? prefixIcon,
    String? errorText,
    bool hasClearAllBtn = false,
  });

  ButtonStyle get myButtonStyle;

  ButtonStyle get myDisabledButtonStyle;
}
