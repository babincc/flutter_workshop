import 'package:my_skeleton/constants/config.dart';
import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer.dart';

class Assets {
  /// The path separator for the current platform.
  static String get pathSeparator => MyFileExplorer.pathSeparator;

  // -------------------------------- FOLDERS ------------------------------- //

  /// The path to the assets directory.
  static const String assetsPath = 'assets';

  /// The path to the images directory.
  static final String imagesPath =
      '$assetsPath$pathSeparator${Config.dir.images}';

  // --------------------------------- FILES -------------------------------- //

  /// The path to the logo image.
  ///
  /// This is the Puppy Petter logo.
  static final String logo = '$imagesPath$pathSeparator${Config.file.logo}';
}
