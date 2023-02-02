import 'package:my_skeleton/constants/strings/lang_code.dart';

/// A collection of all of the strings within the app.
///
/// This abstract class allows each language to implement it and there will
/// never be a language that is missing strings.
abstract class Strings {
  /// The [LangCode] associated with this specific language.
  LangCode get langCode;

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
