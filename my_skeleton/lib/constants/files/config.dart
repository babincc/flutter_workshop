// ignore_for_file: library_private_types_in_public_api

/// The directory and file names used throughout the app.
class Config {
  Config._();

  static _Dirs get dir => _Dirs._();

  static _Files get file => _Files._();
}

/// The names of the directories used throughout the app.
class _Dirs {
  _Dirs._();

  /// The name of the assets directory.
  final String assets = 'assets';

  /// The name of the images directory.
  final String images = 'images';

  /// The name of the preferences directory.
  final String preferences = 'preferences';
}

/// The names of the files used throughout the app.
class _Files {
  _Files._();

  /// The name of the logo file.
  final String logo = 'logo.png';

  /// The name of the theme preference file.
  final String theme = 'theme.txt';
}
