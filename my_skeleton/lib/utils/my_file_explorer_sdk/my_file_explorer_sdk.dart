// @author Christian Babin
// @version 1.0.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_file_explorer_sdk.dart

import 'dart:io';

import 'libraries/directories.dart';
import 'libraries/paths.dart';

/// This class allows for the easy exploration of this app's working directory.
class MyFileExplorerSDK {
  /// Fetches the local directory that matches the given `localDir`.
  static Future<Directory> fetchDir(LocalDir localDir) {
    switch (localDir) {
      case LocalDir.appDocsDir:
        return appDocsDir;
      case LocalDir.tempDir:
        return tempDir;
      default:
        return appSupportDir;
    }
  }

  /// Fetches the local directory path that matches the given `localDir`.
  static Future<String> fetchPath(LocalDir localDir) {
    switch (localDir) {
      case LocalDir.appDocsDir:
        return appDocsPath;
      case LocalDir.tempDir:
        return tempPath;
      default:
        return appSupportPath;
    }
  }

  /// Returns the file that is found with the given `filePath`.
  ///
  /// Throws [FileSystemException] if the file does not exist.
  static Future<File> fetchFile(String filePath) async {
    if (File(filePath).existsSync()) {
      return File(filePath);
    } else {
      throw const FileSystemException("File does not exist!");
    }
  }

  /// Like [fetchFile] except that this function returns `null` where a similar
  /// call to [fetchFile] would throw a [FileSystemException].
  static Future<File?> tryFetchFile(String filePath) async {
    try {
      return fetchFile(filePath);
    } on FileSystemException {
      return null;
    }
  }

  /// Returns the file extension of `fileName`.
  ///
  /// Throws [FormatException] if `fileName` does not end with a file extension.
  ///
  /// ```dart
  /// fileExt("my_image.jpg") == ".jpg"
  /// fileExt("/path/to/my_image.png") == ".png"
  /// fileExt("my_doc.info.pdf") == ".pdf"
  /// fileExt("my_undefined") => throws FormatException
  /// fileExt("my_unfinished.") => throws FormatException
  /// ```
  static String parseFileExt(String fileName) {
    try {
      String fileExt = fileName.substring(fileName.lastIndexOf("."));

      if (_isValidFileExt(fileExt)) {
        return fileExt;
      } else {
        throw FormatException("$fileExt is not a valid file extension.");
      }
    } on RangeError {
      throw const FormatException("File names must contain a \".\" character.");
    }
  }

  /// Like [parseFileExt] except that this function returns `null` where a
  /// similar call to [parseFileExt] would throw a [FormatException].
  static String? tryParseFileExt(String fileName) {
    try {
      return parseFileExt(fileName);
    } on FormatException {
      return null;
    }
  }

  /// This method checks to see if a file extension is formatted correctly.
  ///
  /// Note: It does not check to see if the extension belongs to a valid file
  /// type, or if it is attached to a file of the proper type. The only purpose
  /// of this method is to make sure it is formatted in the proper way.
  ///
  /// ```dart
  /// _isValidFileExt(".png") == true
  /// _isValidFileExt(".jpg") == true
  /// _isValidFileExt(".jpEgg") == true
  /// _isValidFileExt(".c") == true
  /// _isValidFileExt("gif") == false
  /// _isValidFileExt(".") == false
  /// _isValidFileExt(".jpeg.jpg") == false
  /// _isValidFileExt("") == false
  /// ```
  static bool _isValidFileExt(String fileExt) {
    // Check for empty string.
    if (fileExt.isEmpty) {
      return false;
    }

    // Make sure it has a dot.
    if (!fileExt.contains(".")) {
      return false;
    }

    // Check for more than one dot.
    if (fileExt.indexOf(".") != fileExt.lastIndexOf(".")) {
      return false;
    }

    // Make sure the dot is the first character.
    if (fileExt.indexOf(".") != 0) {
      return false;
    }

    // Make sure there are characters after the dot.
    if (fileExt.length <= 1) {
      return false;
    }

    // Check to make sure there are just letters or numbers in the file
    // extension.
    if (!RegExp(r"^\.([a-z]|[A-Z]|[0-9])+$").hasMatch(fileExt)) {
      return false;
    }

    return true;
  }

  /// Whether the giving `fileName` is valid.
  ///
  /// ```dart
  /// isValidFileName("my_image.jpg") == true
  /// isValidFileName("info.pdf") == true
  /// isValidFileName("my_file") == false
  /// isValidFileName("/path/to/my_image.jpg") == false
  /// isValidFileName(".jpg") == false
  /// ```
  static bool isValidFileName(String fileName) {
    // Check for empty string.
    if (fileName.isEmpty) {
      return false;
    }

    // Check for path separators.
    if (fileName.contains(Platform.pathSeparator)) {
      return false;
    }

    String? baseName = getBaseName(fileName);
    String? fileExt = tryParseFileExt(fileName);

    // Check for a valid file name.
    if (baseName == null) {
      return false;
    }

    // Check for a valid file extension.
    if (fileExt == null || !_isValidFileExt(fileExt)) {
      return false;
    }

    return true;
  }

  /// Allows for the easy creation of a path string.
  ///
  /// ```dart
  /// createPath(
  ///   localDir: LocalDir.tempDir,
  ///   subPath: "/images",
  /// ) == "/path/to/tmp/images"
  /// ```
  ///
  /// Throws a [FormatException] if `subPath` is not a valid path. Below are
  /// some invalid paths:
  ///
  /// ```dart
  /// subPath: "@image" => throws FormatException
  /// subPath: "../image" => throws FormatException
  /// subPath: "~" => throws FormatException
  /// subPath: "" => throws FormatException
  /// ```
  static Future<String> createPath({
    required LocalDir localDir,
    required String subPath,
  }) async {
    final String localDirPath =
        "${await fetchPath(localDir)}${Platform.pathSeparator}";
    final String subPathSterile = sterilizePath(subPath);

    // Check for valid sub-path.
    if (subPathSterile.isEmpty) {
      throw FormatException("$subPath is not a valid sub-path!");
    }

    return "$localDirPath$subPathSterile";
  }

  /// Allows for the easy creation of a path string containing a file at the
  /// end.
  ///
  /// ```dart
  /// createPathToFile(
  ///   localDir: LocalDir.tempDir,
  ///   subPath: "/images",
  ///   fileName: "smile.jpg"
  /// ) == "/path/to/tmp/images/smile.jpg"
  /// ```
  ///
  /// Throws a [FormatException] if `subPath` is not a valid path or if
  /// `fileName` is not a valid file name. See [createPath] and
  /// [isValidFileName] for examples of invalid inputs.
  static Future<String> createPathToFile({
    required LocalDir localDir,
    String? subPath,
    required String fileName,
  }) async {
    String path;
    final String fileNameSterile = sterilizeFileName(fileName);

    if (subPath != null) {
      path = await createPath(localDir: localDir, subPath: subPath);
    } else {
      path = await fetchPath(localDir);
    }

    // Check for valid file name.
    if (!isValidFileName(fileName)) {
      throw FormatException("$fileName is not a valid file name!");
    }

    return "$path${Platform.pathSeparator}$fileNameSterile";
  }

  /// Returns a new file path by combining the given `filePath` and
  /// `newFileName`.
  ///
  /// Throws [FormatException] if `filePath` is not formatted correctly.
  ///
  /// ```dart
  /// getNewNameWithPath("/path/to/file/img_2.jpg", "my_image.jpg") == "/path/to/file/my_image.jpg"
  /// getNewNameWithPath("/path/to/file/", "info.txt") == "/path/to/file/info.txt"
  /// getNewNameWithPath("my_file.pdf", "my_doc.pdf") => throws FormatException
  /// ```
  static String getNewNameWithPath(String filePath, String newFileName) {
    try {
      return "${filePath.substring(0, filePath.lastIndexOf(Platform.pathSeparator) + 1)}"
          "$newFileName";
    } catch (e) {
      throw FormatException("$filePath is not a valid file path.");
    }
  }

  /// Like [getNewNameWithPath] except that this function returns `null` where a
  /// similar call to [getNewNameWithPath] would throw a [FormatException].
  static String? tryGetNewNameWithPath(String filePath, String newFileName) {
    try {
      return getNewNameWithPath(filePath, newFileName);
    } on FormatException {
      return null;
    }
  }

  /// This method gets the file name from a path.
  ///
  /// ```dart
  /// getFileName("/path/to/file/my_file.jpg") == "my_file.jpg"
  /// getFileName("/path/to/file/my_file") == null
  /// getFileName("/path/to/file/.jpg") == null
  /// ```
  ///
  /// Returns `null` if `filePath` is not formatted in a valid way.
  ///
  /// Hint:
  ///   - `filePath` must include a file extension.
  ///   - If the path contains separators, there must be characters between the
  ///       last separator and the dot in the file extension.
  ///
  /// Note: This method will not work on hidden files. It will view them as a
  /// file extension since hidden files like ".gitconfig" look like file
  /// extensions to this program and not valid file names.
  static String? getFileName(String filePath) {
    String? baseName = getBaseName(filePath);
    String? fileExt = tryParseFileExt(filePath);

    if (baseName == null || fileExt == null) return null;

    return baseName + fileExt;
  }

  /// This method gets the file base name from a path.
  ///
  /// ```dart
  /// getBaseName("/path/to/file/my_file.jpg") == "my_file"
  /// getBaseName("/path/to/file/my_file") == null
  /// getBaseName("/path/to/file/.jpg") == null
  /// ```
  ///
  /// Returns `null` if `filePath` is not formatted in a valid way.
  ///
  /// Hint:
  ///   - `filePath` must include a file extension.
  ///   - If the path contains separators, there must be characters between the
  ///       last separator and the dot in the file extension.
  ///
  /// Note: This method will not work on hidden files. It will view them as a
  /// file extension since hidden files like ".gitconfig" look like file
  /// extensions to this program and not valid file names.
  static String? getBaseName(String filePath) {
    // Check for empty string.
    if (filePath.isEmpty) {
      return null;
    }

    String? fileExt = tryParseFileExt(filePath);

    // Check for a valid file extension.
    if (fileExt == null || !_isValidFileExt(fileExt)) {
      return null;
    }

    String fileName;

    if (filePath.contains(Platform.pathSeparator)) {
      fileName = filePath.substring(
          filePath.lastIndexOf(Platform.pathSeparator) + 1,
          filePath.lastIndexOf("."));
    } else {
      fileName = filePath.substring(0, filePath.lastIndexOf("."));
    }

    if (fileName.isEmpty || fileName == Platform.pathSeparator) {
      return null;
    }

    return fileName;
  }

  /// Removes leading and trailing path separators from the given `filePath`.
  static String cleanPath(String filePath) {
    String filePathClean;

    // Remove leading path separator.
    if (filePath.startsWith(Platform.pathSeparator)) {
      filePathClean = filePath.substring(1);
    } else {
      filePathClean = filePath;
    }

    // Remove trailing path separator.
    if (filePathClean.endsWith(Platform.pathSeparator)) {
      filePathClean = filePathClean.substring(0, filePathClean.length - 1);
    }

    return filePathClean;
  }

  static const List<String> _illegalChars = [
    "#",
    "%",
    "&",
    "{",
    "}",
    "<",
    ">",
    "*",
    "?",
    " ",
    "\$",
    "!",
    "'",
    "\"",
    ":",
    "@",
    "+",
    "`",
    "|",
    "=",
  ];

  static final List<String> _illegalFileNameChars = [
    "\\",
    "/",
    Platform.pathSeparator,
  ];

  static const List<String> _illegalPathChars = [
    "..",
  ];

  /// Removes illegal characters from the givin `fileName`.
  static String sterilizeFileName(String fileName) {
    final List<String> illegalChars = _illegalFileNameChars + _illegalChars;
    String fileNameSterile = fileName;

    for (String char in illegalChars) {
      fileNameSterile = fileNameSterile.replaceAll(char, "");
    }

    // Remove improper leading chars.
    while (fileNameSterile.startsWith("_") || fileNameSterile.startsWith("-")) {
      if (fileNameSterile.length > 1) {
        fileNameSterile = fileNameSterile.substring(1);
      } else {
        fileNameSterile = "";
        break;
      }
    }

    return fileNameSterile;
  }

  /// Whether the given `fileName` is legal or not.
  static bool isSterileFileName(String fileName) {
    final List<String> illegalChars = _illegalFileNameChars + _illegalChars;

    for (String char in illegalChars) {
      if (fileName.contains(char)) {
        return false;
      }
    }

    return true;
  }

  /// Removes illegal characters from the givin `filePath`.
  ///
  /// It also cleans the `filePath` with [cleanPath].
  static String sterilizePath(String filePath) {
    final List<String> illegalChars = _illegalPathChars + _illegalChars;
    String filePathSterile = filePath;

    for (String char in illegalChars) {
      filePathSterile = filePathSterile.replaceAll(char, "");
    }

    // Remove double path separators.
    while (filePathSterile
        .contains("${Platform.pathSeparator}${Platform.pathSeparator}")) {
      filePathSterile.replaceAll(
          "${Platform.pathSeparator}${Platform.pathSeparator}",
          Platform.pathSeparator);
    }

    // Remove improper leading chars.
    while (filePathSterile.startsWith("~") || filePathSterile.startsWith("-")) {
      if (filePathSterile.length > 1) {
        filePathSterile = filePathSterile.substring(1);
      } else {
        filePathSterile = "";
        break;
      }
    }

    return filePathSterile;
  }

  /// Whether the given `filePath` is legal or not.
  static bool isSterilePath(String filePath) {
    final List<String> illegalChars = _illegalPathChars + _illegalChars;

    for (String char in illegalChars) {
      if (filePath.contains(char)) {
        return false;
      }
    }

    // Check for double path separators.
    if (filePath
        .contains("${Platform.pathSeparator}${Platform.pathSeparator}")) {
      return false;
    }

    return true;
  }
}

/// All of the local directories used by this program.
enum LocalDir {
  /// {@macro myFileExplorerSdk.directories.appDocsDir}
  appDocsDir,

  /// {@macro myFileExplorerSdk.directories.appSupportDir}
  appSupportDir,

  /// {@macro myFileExplorerSdk.directories.tempDir}
  tempDir,
}
