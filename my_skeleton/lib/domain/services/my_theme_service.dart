import 'dart:io';

import 'package:my_skeleton/constants/config.dart';
import 'package:my_skeleton/domain/enums/my_theme_type.dart';
import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer.dart';

/// This object has the ability to check local files and manipulate them to save
/// or retrieve the user's preferred theme type.
class MyThemeService {
  /// The name of the local file that the theme type preference is saved in.
  static final String fileName = Config.file.theme;

  /// The name of the parent directory of the theme preference file.
  static final String dirName = Config.dir.preferences;

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
  static Future<MyThemeType?> get cachedThemeType async {
    await MyFileExplorer().ensureInitialized();

    File themePrefFile = themePref;

    if (!themePrefFile.existsSync()) return null;

    String themeTypeStr = themePrefFile.readAsStringSync();

    return MyThemeType.fromString(themeTypeStr);
  }

  /// Writes the user's preferred theme type to their local files.
  static void cacheThemeType(MyThemeType themeType) {
    File themePrefFile = themePref;

    if (!themePrefFile.existsSync()) {
      themePrefFile.createSync(recursive: true);
    }

    themePrefFile.writeAsStringSync(
      themeType.value,
      flush: true,
    );
  }
}
