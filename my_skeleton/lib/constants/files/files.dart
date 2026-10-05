import 'package:my_skeleton/constants/files/config.dart';
import 'package:my_skeleton/utils/my_file_explorer.dart';

class Files {
  // -------------------------------- FOLDERS ------------------------------- //

  /// The path to the preferences folder.
  static final String preferencesPath =
      '${MyFileExplorer().appSupportDir.path}/${Config.dir.preferences}';

  // --------------------------------- FILES -------------------------------- //

  /// The path to the theme preferences file.
  static final String theme = '$preferencesPath/${Config.file.theme}';
}
