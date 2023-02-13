import 'dart:io';

import 'package:my_skeleton/constants/config.dart';
import 'package:my_skeleton/providers/my_theme_provider.dart';
import 'package:my_skeleton/utils/my_file_explorer_sdk/my_file_explorer_sdk.dart';

/// This object has the ability to check local files and manipulate them to save
/// or retrieve the user's preferred theme type.
class MyThemeService {
  /// The name of the local file that the theme type preference is saved in.
  static final String fileName = Config.file.theme;

  /// The name of the parent directory of the theme preference file.
  static final String dirName = Config.dir.preferences;

  /// The code that is written in the local files that means [ThemeType.dark].
  static const String dark = "dark";

  /// The code that is written in the local files that means [ThemeType.light].
  static const String light = "light";

  /// The file that stores the user's theme preference.
  static Future<File> get themePref async => File(
        await MyFileExplorerSDK.createPathToFile(
          localDir: LocalDir.appSupportDir,
          subPath: dirName,
          fileName: fileName,
        ),
      );

  /// Reads the user's preferred theme type from their local files.
  ///
  /// Returns `null` if they do not have a preferred theme type saved to their
  /// local files.
  static Future<ThemeType?> get cachedThemeType async {
    File themePrefFile = await themePref;

    if (!themePrefFile.existsSync()) return null;

    String themeTypeStr = await themePrefFile.readAsString();

    if (themeTypeStr == dark) {
      return ThemeType.dark;
    } else {
      return ThemeType.light;
    }
  }

  /// Writes the user's preferred theme type to their local files.
  static Future<void> cacheThemeType(ThemeType themeType) async {
    String theme;

    if (themeType == ThemeType.dark) {
      theme = dark;
    } else {
      theme = light;
    }

    File themePrefFile = await themePref;

    if (!themePrefFile.existsSync()) {
      await themePrefFile.create(recursive: true);
    }

    await themePrefFile.writeAsString(
      theme,
      flush: true,
    );
  }
}
