import 'package:my_skeleton/utils/my_tools.dart';

class DbTools {
  /// Encrypts the given `plaintext`.
  static String encrypt(String plaintext) {
    String cipherText = plaintext;

    // Step 1
    cipherText = MyTools.reverseString(cipherText);

    // Step 2
    cipherText = MyTools.scrambleString(cipherText);

    // Step 3
    cipherText = MyTools.encodeBase64(cipherText);

    return cipherText;
  }

  /// Attempts to encrypt the given `plaintext`.
  ///
  /// If the `plaintext` is `null`, this method will return `null`.
  ///
  /// Returns the ciphertext if successful; otherwise, returns `null`.
  static String? encryptOrNull(String? plaintext) {
    if (plaintext == null) return null;

    return encrypt(plaintext);
  }

  /// Decrypts the given `ciphertext`.
  ///
  /// Returns the plaintext if successful; otherwise, returns `null`.
  static String? decrypt(String ciphertext) {
    try {
      String plainText = ciphertext;

      // Step 3
      plainText = MyTools.decodeBase64(plainText)!;

      // Step 2
      plainText = MyTools.scrambleString(plainText);

      // Step 1
      plainText = MyTools.reverseString(plainText);

      return plainText;
    } catch (e) {
      return null;
    }
  }

  /// Attempts to decrypt the given `ciphertext`.
  ///
  /// If the `ciphertext` is `null`, this method will return `null`.
  ///
  /// Returns the plaintext if successful; otherwise, returns `null`.
  static String? decryptOrNull(String? ciphertext) {
    if (ciphertext == null) return null;

    return decrypt(ciphertext);
  }

  // ---------------------------------------------------------------------------
  // --------------------------- NON-STRING METHODS ----------------------------
  // ---------------------------------------------------------------------------

  // -------------------------------- NUMBERS ----------------------------------

  /// Encrypts the given `number`.
  static String encryptNum(num number) => encrypt(number.toString());

  /// Attempts to encrypt the given `number`.
  ///
  /// Returns the ciphertext if successful; otherwise, returns `null`.
  static String? encryptNumOrNull(num? number) {
    if (number == null) return null;

    return encryptNum(number);
  }

  /// Decrypts the given `ciphertext` into a number.
  ///
  /// Returns the number if successful; otherwise, returns `null`.
  static num? decryptNum(String ciphertext) {
    final String? plaintext = decrypt(ciphertext);

    if (plaintext == null) return null;

    return num.tryParse(plaintext);
  }

  /// Attempts to decrypt the given `ciphertext` into a number.
  ///
  /// Returns the number if successful; otherwise, returns `null`.
  static num? decryptNumOrNull(String? ciphertext) {
    if (ciphertext == null) return null;

    return decryptNum(ciphertext);
  }

  // ---------------------------------- BOOL -----------------------------------

  /// Encrypts the given `bool`.
  static String encryptBool(bool boolean) => encrypt(boolean.toString());

  /// Attempts to encrypt the given `bool`.
  ///
  /// Returns the ciphertext if successful; otherwise, returns `null`.
  static String? encryptBoolOrNull(bool? boolean) {
    if (boolean == null) return null;

    return encryptBool(boolean);
  }

  /// Decrypts the given `ciphertext` into a boolean.
  ///
  /// Returns the boolean if successful; otherwise, returns `null`.
  static bool? decryptBool(String ciphertext) {
    final String? plaintext = decrypt(ciphertext);

    if (plaintext == null) return null;

    return plaintext.toLowerCase() == 'true';
  }

  /// Attempts to decrypt the given `ciphertext` into a boolean.
  ///
  /// Returns the boolean if successful; otherwise, returns `null`.
  static bool? decryptBoolOrNull(String? ciphertext) {
    if (ciphertext == null) return null;

    return decryptBool(ciphertext);
  }

  // ------------------------------- DATE TIME ---------------------------------

  /// Encrypts the given `dateTime`.
  static String encryptDateTime(DateTime dateTime) =>
      encrypt(dateTime.toString());

  /// Attempts to encrypt the given `dateTime`.
  ///
  /// Returns the ciphertext if successful; otherwise, returns `null`.
  static String? encryptDateTimeOrNull(DateTime? dateTime) {
    if (dateTime == null) return null;

    return encryptDateTime(dateTime);
  }

  /// Decrypts the given `ciphertext` into a [DateTime] object.
  ///
  /// Returns the [DateTime] object if successful; otherwise, returns `null`.
  static DateTime? decryptDateTime(String ciphertext) {
    final String? plaintext = decrypt(ciphertext);

    if (plaintext == null) return null;

    return DateTime.tryParse(plaintext);
  }

  /// Attempts to decrypt the given `ciphertext` into a [DateTime] object.
  ///
  /// Returns the [DateTime] object if successful; otherwise, returns `null`.
  static DateTime? decryptDateTimeOrNull(String? ciphertext) {
    if (ciphertext == null) return null;

    return decryptDateTime(ciphertext);
  }
}
