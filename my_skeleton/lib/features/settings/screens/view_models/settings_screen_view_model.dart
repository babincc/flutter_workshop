import 'package:flutter/material.dart';
import 'package:my_skeleton/domain/enums/my_theme_type.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';

/// This is used to control all of the logic on the settings screen.
class SettingsScreenViewModel extends ChangeNotifier {
  void toggleTheme(MyThemeProvider currentTheme) {
    if (identical(currentTheme.themeType, MyThemeType.light)) {
      currentTheme.themeType = MyThemeType.dark;
    } else {
      currentTheme.themeType = MyThemeType.light;
    }
  }
}
