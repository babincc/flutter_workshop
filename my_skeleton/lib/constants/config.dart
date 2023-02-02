// ignore_for_file: library_private_types_in_public_api

/// The directory and file names used throughout the app.
class Config {
  Config._();

  static _Dirs get dir => _Dirs();

  static _Files get file => _Files();
}

/// The names of the directories used throughout the app.
class _Dirs {
  final String preferences = "preferences";
}

/// The names of the files used throughout the app.
class _Files {
  final String lang = "lang.txt";

  final String theme = "theme.txt";
}
