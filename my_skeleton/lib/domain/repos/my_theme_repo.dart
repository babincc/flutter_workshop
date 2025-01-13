import 'package:my_skeleton/domain/enums/my_theme_type.dart';
import 'package:my_skeleton/domain/services/my_theme_service.dart';

class MyThemeRepo {
  /// Reads the user's preferred theme type from their local files.
  ///
  /// Returns `null` if they do not have a preferred theme type saved to their
  /// local files.
  static Future<MyThemeType?> get cachedThemeType async =>
      await MyThemeService.cachedThemeType;

  /// Writes the user's preferred theme type to their local files.
  static void cacheThemeType(MyThemeType themeType) =>
      MyThemeService.cacheThemeType(themeType);
}
