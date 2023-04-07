import 'dart:io';

class Folders {
  static const top = "flutter_hue";

  static const bridges = "bridges";

  static String get bridgesSubPath =>
      "$top${Platform.pathSeparator}$bridges${Platform.pathSeparator}";
}
