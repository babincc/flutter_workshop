import 'package:my_skeleton/constants/strings/lang_code.dart';

/// A collection of all of the strings within the app.
///
/// This abstract class allows each language to implement it and there will
/// never be a language that is missing strings.
abstract class Strings {
  /// The [LangCode] associated with this specific language.
  LangCode get langCode;

  String get back;

  String get cancel;

  String get confirmPassword;

  String get createAccount;

  String get email;

  String get emailAlreadyExists;

  String get emailDoesNotExist;

  String get error;

  String get existingAccount;

  String get failedAccountCreation;

  String get failedPasswordReset;

  String get forgotPassword;

  String get help;

  String get invalidEmail;

  String get invalidPassword;

  String get logIn;

  String get logOut;

  String get ok;

  String get password;

  String get passwordResetLinkSent;

  String get passwordsDontMatch;

  String get passwordTooWeak;

  String get profile;

  String get required;

  String get reset;

  String get resetPasswordInstructions;

  String get search;

  String get settings;

  String get somethingWentWrong;

  String get tryAgainLater;
}

extension StringTools on String {
  /// This method determines if a given string is a number.
  ///
  /// Returns `true` if the string is a number.
  bool isNumber() => double.tryParse(this) != null;

  /// Capitalizes the first letter of the given `text`.
  ///
  /// ```dart
  /// 'howdy'.capitalizeFirstLetter() == "Howdy"
  /// 'hello world'.capitalizeFirstLetter() == "Hello world"
  /// ```
  String capitalizeFirstLetter() {
    if (length > 1) {
      return this[0].toUpperCase() + substring(1);
    } else {
      return this[0].toUpperCase();
    }
  }

  /// Capitalizes the first letter of each word in the given `text`.
  ///
  /// ```dart
  /// 'howdy'.capitalizeEachWord() == "Howdy"
  /// 'hello world'.capitalizeEachWord() == "Hello World"
  /// ```
  String capitalizeEachWord() {
    final words = split(' ');

    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].capitalizeFirstLetter();
    }

    return words.join(' ');
  }

  /// This method puts a zero width space in between every character in the
  /// given `text`.
  ///
  /// This is useful when you want a string that wraps to the next line at the
  /// character that hit the overflow limit rather than taking that whole word
  /// to the next line.
  ///
  /// ```
  /// Without this method:
  /// aaaaaaaaaa-bbbbbbbbbb-
  /// cccccccccc-dddddddddd
  ///
  /// With this method:
  /// aaaaaaaaaa-bbbbbbbbbb-cccccc
  /// cccc-dddddddddd
  /// ```
  String wordBreak() {
    StringBuffer buffer = StringBuffer();

    for (var element in runes) {
      buffer.write(String.fromCharCode(element));
      buffer.write("\u200B");
    }

    return buffer.toString();
  }
}
