import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/constants/theme/my_color_schemes.dart';
import 'package:my_skeleton/constants/theme/my_spacing.dart';
import 'package:my_skeleton/domain/services/my_theme_pref.dart';
import 'package:provider/provider.dart';

/// The main brightness level of the app's UI.
enum ThemeType {
  /// All of the main background colors will be dark with lighter foreground
  /// colors for contrast.
  dark,

  /// All of the main background colors will be light with darker foreground
  /// colors for contrast.
  light,
}

class MyThemeProvider extends ChangeNotifier {
  MyThemeProvider() : _themeType = ThemeType.dark {
    initThemeType();
  }

  /// Describes the main brightness level of the UI throughout the app.
  ThemeType _themeType;

  set themeType(ThemeType themeType) {
    _themeType = themeType;
    MyThemePref.cacheThemeType(themeType).then((value) => notifyListeners());
  }

  ThemeType get themeType => _themeType;

  /// Returns the app UI's theme data based on the selected [_themeType].
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: _themeType == ThemeType.light
            ? MyColorSchemes.lightColorScheme
            : MyColorSchemes.darkColorScheme,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
      );

  /// The decoration for all of the text fields used in this app.
  static InputDecoration myInputDecoration({
    String? label,
    String? hint,
    Icon? prefixIcon,
    String? errorText,
  }) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySpacing.borderRadius),
      gapPadding: MySpacing.textPadding,
    );

    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: prefixIcon,
      hintText: hint,
      errorText: errorText,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MySpacing.textPadding * 2,
        vertical: MySpacing.textPadding,
      ),
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
    );
  }

  /// Checks the phone for which theme it should apply to the app.
  Future<void> initThemeType() async {
    // See if the user has a theme preference saved in their local files.
    ThemeType? tempThemeType = await MyThemePref.cachedThemeType;
    if (tempThemeType != null) {
      themeType = tempThemeType;
      return;
    }

    // If there is no saved preference, try to match the phone's theme.
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      themeType = ThemeType.dark;
    } else {
      themeType = ThemeType.light;
    }
  }

  static MyThemeProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyThemeProvider>(context, listen: listen);
}
