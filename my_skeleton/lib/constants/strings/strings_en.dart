import 'package:my_skeleton/constants/strings/lang_code.dart';

import 'strings.dart';

/// A collection of all of the strings within the app.
///
/// This is the English version.
class StringsEN implements Strings {
  const StringsEN();

  @override
  LangCode get langCode => LangCode.en;

  @override
  String get confirmPassword => "confirm password";

  @override
  String get back => "back";

  @override
  String get cancel => "cancel";

  @override
  String get createAccount => "create account";

  @override
  String get email => "email";

  @override
  String get emailAlreadyExists => "email already exists";

  @override
  String get emailDoesNotExist => "email does not exist";

  @override
  String get error => "error";

  @override
  String get existingAccount => "already have an account";

  @override
  String get failedAccountCreation => "failed to create account";

  @override
  String get failedPasswordReset => "failed to send password reset link";

  @override
  String get forgotPassword => "forgot password";

  @override
  String get help => "help";

  @override
  String get invalidEmail => "invalid email";

  @override
  String get invalidPassword => "invalid password";

  @override
  String get logIn => "log in";

  @override
  String get logOut => "log out";

  @override
  String get ok => "ok";

  @override
  String get password => "password";

  @override
  String get passwordResetLinkSent => "password reset link sent";

  @override
  String get passwordsDontMatch => "passwords do not match";

  @override
  String get passwordTooWeak => "password too weak";

  @override
  String get profile => "profile";

  @override
  String get required => "required";

  @override
  String get reset => "reset";

  @override
  String get resetPasswordInstructions =>
      "enter your email and a password reset link will be sent to you";

  @override
  String get search => "search";

  @override
  String get settings => "settings";

  @override
  String get somethingWentWrong => "something went wrong";

  @override
  String get tryAgainLater => "please try again later";
}
