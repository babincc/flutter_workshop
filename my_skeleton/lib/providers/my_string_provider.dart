import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_skeleton/constants/strings/lang_code.dart';
import 'package:my_skeleton/constants/strings/strings.dart';
import 'package:my_skeleton/constants/config.dart';
import 'package:my_skeleton/utils/my_file_explorer_sdk/my_file_explorer_sdk.dart';
import 'package:provider/provider.dart';

class MyStringProvider extends ChangeNotifier {
  MyStringProvider({LangCode? langCode}) : _langCode = langCode ?? LangCode.en {
    _init();
  }

  /// Initialize the string provider.
  Future<void> _init() async {
    langCode = await _fetchLangPref();
  }

  /// The name of the local file that the language type preference is saved in.
  static final String fileName = Config.file.lang;

  /// The name of the parent directory of the language preference file.
  static final String dirName = Config.dir.preferences;

  /// The file that stores the user's theme preference.
  static Future<File> get langPref async => File(
        await MyFileExplorerSDK.createPathToFile(
          localDir: LocalDir.appSupportDir,
          subPath: dirName,
          fileName: fileName,
        ),
      );

  /// The group of strings in the selected language being used throughout the
  /// app.
  Strings get strings => _langCode.strings;

  LangCode _langCode;

  /// The currently selected language code.
  set langCode(LangCode langCode) {
    if (identical(_langCode, langCode)) return;

    _langCode = langCode;
    notifyListeners();
    _saveLangPref();
  }

  /// Reads the user's language preference from their local file directory.
  ///
  /// If there is no preference saved, or there is an error, it will default to
  /// English.
  Future<LangCode> _fetchLangPref() async {
    File langPrefFile = await langPref;

    if (!langPrefFile.existsSync()) return LangCode.en;

    String langCodeStr = langPrefFile.readAsStringSync();

    return LangCode.fromString(langCodeStr);
  }

  /// Writes the user's language preference to their local file directory.
  Future<void> _saveLangPref() async {
    final String langCodeStr = _langCode.value;

    File langPrefFile = await langPref;

    if (!langPrefFile.existsSync()) {
      langPrefFile.createSync(recursive: true);
    }

    langPrefFile.writeAsStringSync(
      langCodeStr,
      flush: true,
    );
  }

  static MyStringProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyStringProvider>(context, listen: listen);
}
