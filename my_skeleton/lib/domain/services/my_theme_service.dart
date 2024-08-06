import 'dart:io';

import 'package:my_skeleton/constants/config.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer.dart';

/// This object has the ability to check local files and manipulate them to save
/// or retrieve the user's preferred theme type.
class MyThemeService {
  /// The name of the local file that the theme type preference is saved in.
  static final String fileName = Config.file.theme;

  /// The name of the parent directory of the theme preference file.
  static final String dirName = Config.dir.preferences;

  /// The code that is written in the local files that means [ThemeType.dark].
  static const String dark = 'dark';

  /// The code that is written in the local files that means [ThemeType.light].
  static const String light = 'light';

  /// The file that stores the user's theme preference.
  static File get themePref => File(
        MyFileExplorer().createPathToFile(
          localDir: LocalDir.appSupportDir,
          subPath: dirName,
          fileName: fileName,
        ),
      );

  /// Reads the user's preferred theme type from their local files.
  ///
  /// Returns `null` if they do not have a preferred theme type saved to their
  /// local files.
  static ThemeType? get cachedThemeType {
    File themePrefFile = themePref;

    if (!themePrefFile.existsSync()) return null;

    String themeTypeStr = themePrefFile.readAsStringSync();

    if (themeTypeStr == dark) {
      return ThemeType.dark;
    } else {
      return ThemeType.light;
    }
  }

  /// Writes the user's preferred theme type to their local files.
  static void cacheThemeType(ThemeType themeType) {
    String theme;

    if (themeType == ThemeType.dark) {
      theme = dark;
    } else {
      theme = light;
    }

    File themePrefFile = themePref;

    if (!themePrefFile.existsSync()) {
      themePrefFile.createSync(recursive: true);
    }

    themePrefFile.writeAsStringSync(
      theme,
      flush: true,
    );
  }
}
