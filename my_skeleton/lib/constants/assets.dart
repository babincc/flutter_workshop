import 'package:my_skeleton/constants/config.dart';
import 'package:my_skeleton/utils/my_tools.dart';

class Assets {
  /// The path separator for the current platform.
  static String get pathSeparator => MyTools.pathSeparator;

  // -------------------------------- FOLDERS ------------------------------- //

  /// The path to the assets directory.
  static final String assetsPath = Config.dir.assets;

  /// The path to the images directory.
  static final String imagesPath =
      '$assetsPath$pathSeparator${Config.dir.images}';

  // --------------------------------- FILES -------------------------------- //

  /// The path to the logo image.
  ///
  /// This is the Puppy Petter logo.
  static final String logo = '$imagesPath$pathSeparator${Config.file.logo}';
}
