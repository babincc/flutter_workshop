import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer.dart';

/// The directory and file names used throughout the app.
class Config {
  Config._();

  static Dirs get dir => Dirs._();

  static Files get file => Files._();
}

/// The names of the directories used throughout the app.
class Dirs {
  Dirs._();

  /// The name of the images directory.
  final String images = 'images';

  /// The name of the preferences directory.
  final String preferences = 'preferences';

  /// The name of the QR codes directory.
  ///
  /// This is just an example with the path separator. This folder does not
  /// actually exist.
  String get qrCodes => '$images${MyFileExplorer.pathSeparator}qr_codes';
}

/// The names of the files used throughout the app.
class Files {
  Files._();

  /// The name of the language preference file.
  final String lang = 'lang.txt';

  /// The name of the logo file.
  final String logo = 'logo.png';

  /// The name of the theme preference file.
  final String theme = 'theme.txt';
}
