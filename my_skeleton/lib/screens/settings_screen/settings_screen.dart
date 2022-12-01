import 'package:flutter/material.dart';
import 'package:my_skeleton/my_theme/colors/my_dark_theme_colors.dart';
import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/screens/components/my_safe_area.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: MySafeArea(
        child: TextButton(
          onPressed: () {
            if (MyTheme.of(context).themeType == ThemeType.light) {
              MyTheme.of(context).themeType = ThemeType.dark;
            } else {
              MyTheme.of(context).themeType = ThemeType.light;
            }
          },
          child: Text(
            "Toggle Theme",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: MyDarkThemeColors().background,
                ),
          ),
          style: MyTheme.of(context).myButtonStyle,
        ),
      ),
    );
  }
}
