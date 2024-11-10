import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/theme/my_colors.dart';
import 'package:my_skeleton/constants/theme/my_theme.dart';
import 'package:my_skeleton/domain/enums/my_theme_type.dart';
import 'package:my_skeleton/domain/repos/my_theme_repo.dart';
import 'package:provider/provider.dart';

class MyThemeProvider extends ChangeNotifier {
  MyThemeProvider() : _themeType = MyThemeType.dark {
    initThemeType();
  }

  /// Describes the main brightness level of the UI throughout the app.
  MyThemeType _themeType;

  /// Describes the main brightness level of the UI throughout the app.
  MyThemeType get themeType => _themeType;
  set themeType(MyThemeType themeType) {
    if (identical(themeType, _themeType)) return;

    _themeType = themeType;
    MyThemeRepo.cacheThemeType(themeType);
    notifyListeners();
  }

  /// Returns the app's color scheme based on the selected [themeType].
  MyColors get colors => MyColors(themeType);

  /// Returns the app UI's theme data based on the selected [themeType].
  ThemeData get themeData => identical(_themeType, MyThemeType.light)
      ? MyTheme.lightThemeData
      : MyTheme.darkThemeData;

  /// Checks the phone for which theme it should apply to the app.
  void initThemeType() {
    // See if the user has a theme preference saved in their local files.
    final MyThemeType? tempThemeType = MyThemeRepo.cachedThemeType;
    if (tempThemeType != null) {
      themeType = tempThemeType;
      return;
    }

    // If there is no saved preference, try to match the phone's theme.
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = identical(brightness, Brightness.dark);
    if (isDarkMode) {
      themeType = MyThemeType.dark;
    } else {
      themeType = MyThemeType.light;
    }
  }

  static MyThemeProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyThemeProvider>(context, listen: listen);
}
