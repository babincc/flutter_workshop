import 'dart:convert';
import 'dart:io';

import 'package:flutter_hue/constants/folders.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/my_file_explorer_sdk/my_file_explorer_sdk.dart';

/// This repo is used to store and retrieve data locally.
class LocalStorageRepo {
  /// Write the file.
  ///
  /// `content` is the data to write to the file.
  ///
  /// `folder` is the folder to write the file to.
  ///
  /// `fileName` is the name of the file.
  ///
  /// `encrypter` is an additional function to encrypt the data.
  static Future<void> write({
    required String content,
    required Folder folder,
    required String fileName,
    String Function(String plaintext)? encrypter,
  }) async {
    try {
      (await _initFile(
        folder: folder,
        fileName: fileName,
      ))
          .writeAsStringSync(encrypt(content, encrypter));
    } catch (_) {
      // Do nothing
    }
  }

  /// Read the file.
  ///
  /// `folder` is the folder to read the file from.
  ///
  /// `fileName` is the name of the file.
  ///
  /// `decrypter` is an additional function to decrypt the data.
  static Future<String?> read({
    required Folder folder,
    required String fileName,
    String Function(String ciphertext)? decrypter,
  }) async {
    File file = await _initFile(
      folder: folder,
      fileName: fileName,
    );

    if (file.existsSync()) {
      return decrypt(file.readAsStringSync(), decrypter);
    }

    return null;
  }

  /// Delete the file.
  ///
  /// `folder` is the folder to delete the file from.
  ///
  /// `fileName` is the name of the file.
  static Future<void> delete({
    required Folder folder,
    required String fileName,
  }) async {
    File file = await _initFile(
      folder: folder,
      fileName: fileName,
    );

    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  /// Initialize the file.
  static Future<File> _initFile({
    required Folder folder,
    required String fileName,
  }) async {
    LocalDir localDir;
    if (identical(folder, Folder.tmp)) {
      localDir = LocalDir.tempDir;
    } else {
      localDir = LocalDir.appSupportDir;

      final Directory dir = Directory(
        await MyFileExplorerSDK.createPath(
          localDir: localDir,
          subPath: _fetchPath(folder: folder) ?? "",
        ),
      );

      /// Create the directory if it does not exist.
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    }

    return File(
      await MyFileExplorerSDK.createPathToFile(
        localDir: localDir,
        subPath: _fetchPath(folder: folder),
        fileName: fileName,
        validateFileName: false,
      ),
    );
  }

  /// Fetch the path based on `folder`.
  static String? _fetchPath({
    required Folder folder,
  }) {
    switch (folder) {
      case Folder.bridges:
        return Folders.bridgesSubPath;
      case Folder.remoteTokens:
        return Folders.remoteTokensSubPath;
      case Folder.tmp:
        return null;
    }
  }

  /// Encrypt the data to store locally.
  ///
  /// `plaintext` is the data to encrypt.
  ///
  /// `encrypter` is an optional function to encrypt the data with. This will be
  /// used in addition to the default encryption. This will be performed before
  /// the default encryption.
  static String encrypt(String plaintext,
      [String Function(String plaintext)? encrypter]) {
    String semiPlaintext;

    // Encrypt the data with addition encrypter if provided.
    if (encrypter != null) {
      semiPlaintext = encrypter(plaintext);
    } else {
      semiPlaintext = plaintext;
    }

    // First, convert the data string to bytes.
    List<int> dataBytes = utf8.encode(semiPlaintext);

    // Then, encode those bytes.
    String base64Data = base64.encode(dataBytes);

    // Finally, return a scrambled version of that encoding.
    String scrambled = _scramble(base64Data);

    // Add salt to the scrambled data.
    String salted = _addSalt(scrambled);

    // Encode the salted data.
    base64Data = base64.encode(utf8.encode(salted));

    // Scramble the encoded data.
    scrambled = _scramble(base64Data);

    return scrambled;
  }

  /// Decrypt the locally stored data.
  ///
  /// `ciphertext` is the data to decrypt.
  ///
  /// `decrypter` is an optional function to decrypt the data with. This will be
  /// used in addition to the default decryption. This will be performed after
  /// the default decryption.
  ///
  /// Returns `null` if the ciphertext data is invalid or corrupt.
  static String? decrypt(String ciphertext,
      [String Function(String ciphertext)? decrypter]) {
    try {
      // First, unscramble the data string.
      String unscrambledData = _scramble(ciphertext);

      // Then, convert that data string into bytes and decode the string at the
      // same time.
      List<int> dataBytes = base64.decode(unscrambledData);

      // Remove the salt from the data.
      String unsalted = _removeSalt(utf8.decode(dataBytes));

      // Then, unscramble the data string.
      unscrambledData = _scramble(unsalted);

      // Finally, convert the data string into bytes and decode the string at
      // the same time.
      dataBytes = base64.decode(unscrambledData);

      // Return the decoded data.
      String semiPlaintext = utf8.decode(dataBytes);

      // Decrypt the data with addition decrypter if provided.
      if (decrypter != null) {
        return decrypter(semiPlaintext);
      } else {
        return semiPlaintext;
      }
    } catch (e) {
      return null;
    }
  }

  /// This method scrambles the data. It also unscrambles the data.
  static String _scramble(String data) {
    // Split the data string into an array of each individual letter.
    List<String> dataAsArray = data.split("");

    // Loop through the array of letters and swap every pair of letters.
    // ex. Given two strings (the first one having an even amount of letters and
    //     the second one having an odd amount), this is what we expect from the
    //     loop:
    //     Given:
    //          a, b, c, d, e, f
    //            - and -
    //          l, m, n, o, p
    //     this loop would change them to be:
    //          b, a, d, c, f, e
    //            - and -
    //          m, l, o, n, p
    for (int i = 0; i < dataAsArray.length; i++) {
      // Don't swap if we are on the last letter.
      if (i + 1 >= dataAsArray.length) {
        continue;
      }

      // Insert the current letter to the right of the next letter.
      // ex. Given current index is 2
      //     a, b, c, d, e
      //     would become:
      //     a, b, c, d, c, e
      dataAsArray.insert(i + 2, dataAsArray[i]);

      // Delete the current letter.
      // ex. Given current index is 2
      //     a, b, c, d, c, e
      //     would become:
      //     a, b, d, c, e
      dataAsArray.removeAt(i);

      // Move the current index up by one. If we did not do this, then all this
      // method would do is just put the first letter at the end and nothing
      // else would change.
      i++;
    }

    // Put all the letters together as one string and return it.
    return dataAsArray.join();
  }

  /// Pad the real data with useless data.
  static String _addSalt(String data) {
    const chars =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890`~!@#\$%^&*()_+-=[]{}\\|;:'\",<.>/?`";

    StringBuffer prefixSalt = StringBuffer();
    StringBuffer suffixSalt = StringBuffer();

    for (int i = 0; i < MiscTools.randInt(401, 972); i++) {
      prefixSalt
          .write(chars.codeUnitAt(MiscTools.randInt(0, chars.length - 1)));
    }

    for (int i = 0; i < MiscTools.randInt(401, 972); i++) {
      suffixSalt
          .write(chars.codeUnitAt(MiscTools.randInt(0, chars.length - 1)));
    }

    return "${prefixSalt.toString()}\n$data\n${suffixSalt.toString()}";
  }

  /// Remove the salt from the data.
  static String _removeSalt(String data) =>
      data.substring(data.indexOf("\n") + 1, data.lastIndexOf("\n"));
}

/// The folders that can be used.
enum Folder {
  /// The folder that contains the bridge files.
  bridges,

  /// The folder that contains the remote token files.
  remoteTokens,

  /// The folder that contains the temporary files.
  tmp,
}
