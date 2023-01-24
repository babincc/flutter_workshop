import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:my_skeleton/my_theme/colors/my_color_interface.dart';
import 'package:my_skeleton/my_theme/theme/my_dark_theme.dart';
import 'package:my_skeleton/my_theme/colors/my_dark_theme_colors.dart';
import 'package:my_skeleton/my_theme/theme/my_light_theme.dart';
import 'package:my_skeleton/my_theme/colors/my_light_theme_colors.dart';
import 'package:my_skeleton/my_theme/theme/my_theme_interface.dart';
import 'package:my_skeleton/my_theme/theme/my_theme_pref_cache.dart';

/// The main brightness level of the app's UI.
enum ThemeType {
  /// All of the main background colors will be dark with lighter foreground
  /// colors for contrast.
  dark,

  /// All of the main background colors will be light with darker foreground
  /// colors for contrast.
  light,
}

class MyTheme extends ChangeNotifier implements MyThemeInterface {
  MyTheme() : _themeType = ThemeType.dark {
    initThemeType();
  }

  /// Describes the main brightness level of the UI throughout the app.
  ThemeType _themeType;

  set themeType(ThemeType themeType) {
    _themeType = themeType;
    MyThemePrefCache.cacheThemeType(themeType)
        .then((value) => notifyListeners());
  }

  ThemeType get themeType => _themeType;

  /// Returns the app UI's theme data based on the selected [_themeType].
  @override
  ThemeData get themeData {
    if (_themeType == ThemeType.dark) {
      return MyDarkTheme().themeData;
    } else {
      return MyLightTheme().themeData;
    }
  }

  @override
  InputDecoration myInputDecoration(
    BuildContext context,
    TextEditingController controller, {
    String? label,
    String? hint,
    Icon? prefixIcon,
    String? errorText,
    bool hasClearAllBtn = false,
  }) {
    if (_themeType == ThemeType.dark) {
      return MyDarkTheme().myInputDecoration(
        context,
        controller,
        label: label,
        hint: hint,
        prefixIcon: prefixIcon,
        errorText: errorText,
        hasClearAllBtn: hasClearAllBtn,
      );
    } else {
      return MyLightTheme().myInputDecoration(
        context,
        controller,
        label: label,
        hint: hint,
        prefixIcon: prefixIcon,
        errorText: errorText,
        hasClearAllBtn: hasClearAllBtn,
      );
    }
  }

  @override
  ButtonStyle get myButtonStyle {
    if (_themeType == ThemeType.dark) {
      return MyDarkTheme().myButtonStyle;
    } else {
      return MyLightTheme().myButtonStyle;
    }
  }

  @override
  ButtonStyle get myDisabledButtonStyle {
    if (_themeType == ThemeType.dark) {
      return MyDarkTheme().myDisabledButtonStyle;
    } else {
      return MyLightTheme().myDisabledButtonStyle;
    }
  }

  _ColorFetcher get color => _ColorFetcher(_themeType);

  /// Checks the phone for which theme it should apply to the app.
  Future<void> initThemeType() async {
    // See if the user has a theme preference saved in their local files.
    ThemeType? tempThemeType = await MyThemePrefCache.cachedThemeType;
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

  static MyTheme of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyTheme>(context, listen: listen);
}

class _ColorFetcher implements MyColorInterface {
  _ColorFetcher(this.themeType)
      : background = themeType == ThemeType.dark
            ? MyDarkThemeColors().background
            : MyLightThemeColors().background,
        foreground = themeType == ThemeType.dark
            ? MyDarkThemeColors().foreground
            : MyLightThemeColors().foreground,
        secondary = themeType == ThemeType.dark
            ? MyDarkThemeColors().secondary
            : MyLightThemeColors().secondary,
        tertiary = themeType == ThemeType.dark
            ? MyDarkThemeColors().tertiary
            : MyLightThemeColors().tertiary,
        failure = themeType == ThemeType.dark
            ? MyDarkThemeColors().failure
            : MyLightThemeColors().failure,
        notice = themeType == ThemeType.dark
            ? MyDarkThemeColors().notice
            : MyLightThemeColors().notice,
        success = themeType == ThemeType.dark
            ? MyDarkThemeColors().success
            : MyLightThemeColors().success;

  final ThemeType themeType;

  @override
  Color background;

  @override
  Color foreground;

  @override
  Color secondary;

  @override
  Color tertiary;

  @override
  Color failure;

  @override
  Color notice;

  @override
  Color success;
}
