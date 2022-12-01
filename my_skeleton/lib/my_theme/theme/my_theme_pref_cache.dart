import 'package:my_skeleton/my_theme/theme/my_theme.dart';
import 'package:my_skeleton/utils/file_explorer.dart';

/// This object has the ability to check local files and manipulate them to save
/// or retrieve the user's preferred theme type.
class MyThemePrefCache {
  /// The name of the local file that the theme type preference is saved in.
  static const String fileName = "THEME_PREF.txt";

  /// The code that is written in the local files that means [ThemeType.dark].
  static const String dark = "dark";

  /// The code that is written in the local files that means [ThemeType.light].
  static const String light = "light";

  /// The object that will read and write the user's local files.
  static FileExplorer fileExplorer = FileExplorer(fileName);

  /// Reads the user's preferred theme type from their local files.
  ///
  /// Returns `null` if they do not have a preferred theme type saved to their
  /// local files.
  static Future<ThemeType?> get cachedThemeType async {
    String? themeTypeStr = await fileExplorer.read();

    if (themeTypeStr == null) {
      return null;
    } else if (themeTypeStr == dark) {
      return ThemeType.dark;
    } else {
      return ThemeType.light;
    }
  }

  /// Writes the user's preferred theme type to their local files.
  static void cacheThemeType(ThemeType themeType) {
    if (themeType == ThemeType.dark) {
      fileExplorer.write(dark);
    } else {
      fileExplorer.write(light);
    }
  }
}
