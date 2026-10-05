import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_colors.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/utils/my_tools.dart';
import 'package:my_skeleton/widgets/views/my_text.dart';

class MyElevatedButtonBase extends StatelessWidget {
  const MyElevatedButtonBase({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isEnabled = true,
    this.isExpanded = false,
    this.myTextStyle = MyTextStyle.body,
    this.isBold = true,
  });

  final String text;

  final void Function()? onPressed;

  final Color? backgroundColor;

  final Color? textColor;

  final bool isEnabled;

  // If true, the button will take up all available horizontal space.
  final bool isExpanded;

  final MyTextStyle myTextStyle;

  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final MyColors colors = MyThemeProvider.of(context).colors;

    final Color finalBgColor = isEnabled
        ? (backgroundColor ?? colors.primary)
        : colors.disabled;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: finalBgColor),
      onPressed: isEnabled ? onPressed : null,
      child: isExpanded
          ? SizedBox(
              width: double.infinity,
              child: Center(child: _buildText(context, colors)),
            )
          : _buildText(context, colors),
    );
  }

  Widget _buildText(BuildContext context, MyColors colors) {
    final Color finalTextColor = isEnabled
        ? (textColor ??
              (backgroundColor == null
                  ? colors.onPrimary
                  : MyTools.getForegroundColor(backgroundColor!)))
        : colors.onDisabled;

    return MyText(
      text,
      color: finalTextColor,
      style: MyText.getStyle(
        context,
        myTextStyle,
      )?.copyWith(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
