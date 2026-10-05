import 'package:flutter/material.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/widgets/views/my_elevated_button/my_elevated_button_base.dart';

class MyElevatedButtonSecondary extends StatelessWidget {
  const MyElevatedButtonSecondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.isExpanded = false,
  });

  final String text;

  final void Function()? onPressed;

  final bool isEnabled;

  // If true, the button will take up all available horizontal space.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return MyElevatedButtonBase(
      text: text,
      onPressed: onPressed,
      isEnabled: isEnabled,
      isExpanded: isExpanded,
      backgroundColor: MyThemeProvider.of(context).colors.secondary,
      textColor: MyThemeProvider.of(context).colors.onSecondary,
    );
  }
}
