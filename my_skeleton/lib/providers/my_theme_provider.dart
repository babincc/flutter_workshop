import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/constants/theme/my_colors.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';
import 'package:my_skeleton/domain/services/my_theme_service.dart';
import 'package:provider/provider.dart';

class MyThemeProvider extends ChangeNotifier {
  MyThemeProvider() : _themeType = ThemeType.dark {
    initThemeType();
  }

  /// Describes the main brightness level of the UI throughout the app.
  ThemeType _themeType;

  set themeType(ThemeType themeType) {
    _themeType = themeType;
    MyThemeService.cacheThemeType(themeType).then((value) => notifyListeners());
  }

  ThemeType get themeType => _themeType;

  MyColors get colors => MyColors(themeType);

  /// Returns the app UI's theme data based on the selected [_themeType].
  ThemeData get themeData {
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(MyMeasurements.borderRadius),
      gapPadding: MyMeasurements.textPadding,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors.colorScheme,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: _themeType == ThemeType.light
              ? Brightness.dark
              : Brightness.light, // For Android (dark == dark icons)
          statusBarBrightness: _themeType == ThemeType.light
              ? Brightness.light
              : Brightness.dark, // For iOS (light == dark icons)
        ),
      ),
      canvasColor: colors.colorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MyMeasurements.textPadding * 2,
          vertical: MyMeasurements.textPadding,
        ),
        filled: true,
        fillColor: colors.textField,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateColor.resolveWith(
            (states) => colors.colorScheme.onPrimary,
          ),
          backgroundColor: WidgetStateColor.resolveWith(
            (states) => colors.colorScheme.primary,
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      dividerTheme: const DividerThemeData(
        space: MyMeasurements.textPadding * 2.0,
        thickness: 2.0,
      ),
    );
  }

  /// Checks the phone for which theme it should apply to the app.
  Future<void> initThemeType() async {
    // See if the user has a theme preference saved in their local files.
    ThemeType? tempThemeType = await MyThemeService.cachedThemeType;
    if (tempThemeType != null) {
      themeType = tempThemeType;
      return;
    }

    // If there is no saved preference, try to match the phone's theme.
    var brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
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

/// The main brightness level of the app's UI.
enum ThemeType {
  /// All of the main background colors will be dark with lighter foreground
  /// colors for contrast.
  dark,

  /// All of the main background colors will be light with darker foreground
  /// colors for contrast.
  light,
}
