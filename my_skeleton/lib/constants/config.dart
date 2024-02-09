/// The directory and file names used throughout the app.
class Config {
  Config._();

  static Dirs get dir => Dirs._();

  static Files get file => Files._();
}

/// The names of the directories used throughout the app.
class Dirs {
  Dirs._();

  final String preferences = 'preferences';
}

/// The names of the files used throughout the app.
class Files {
  Files._();

  final String lang = 'lang.txt';

  final String theme = 'theme.txt';
}
