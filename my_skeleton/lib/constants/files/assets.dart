import 'package:my_skeleton/constants/files/config.dart';

class Assets {
  // -------------------------------- FOLDERS ------------------------------- //

  /// The path to the assets directory.
  static final String assetsPath = Config.dir.assets;

  /// The path to the images directory.
  static final String imagesPath = '$assetsPath/${Config.dir.images}';

  // --------------------------------- FILES -------------------------------- //

  /// The path to the logo image.
  static final String logo = '$imagesPath/${Config.file.logo}';
}
