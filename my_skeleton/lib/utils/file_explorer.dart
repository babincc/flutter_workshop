import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// This object is used to interact with the user's local files to quickly read
/// and write local files.
class FileExplorer {
  /// Creates an object that can read and write to the user's local files.
  FileExplorer(this.fileName);

  /// This is the name of the file.
  String fileName;

  /// This method gets the path to the app's phone files.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  /// This method gets the file.
  Future<File> get _localFile async {
    final path = await _localPath;

    return File("$path/$fileName");
  }

  /// This method writes the given information to the phone's files.
  Future<File> write(String contentsToWrite) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(contentsToWrite);
  }

  /// This method reads the contents from the local file.
  ///
  /// It will return `null` if the file does not exist.
  Future<String?>? read() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return null
      return null;
    }
  }
}
