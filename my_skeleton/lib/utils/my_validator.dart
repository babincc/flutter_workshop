// @author Christian Babin
// @version 0.1.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_validator.dart
library;

/// Contains methods that check different inputs to see if they are valid.
class MyValidator {
  /// This method checks to see if a given string is a valid email address.
  ///
  /// It will return `true` if the email provided is formatted correctly.
  static bool isValidEmail(String? email) {
    // If there is no string, it is not a valid email.
    if (email == null || email.isEmpty) return false;

    /// The regex pattern to compare the possible email to.
    const String pattern =
        '^([-!#-\'*+/-9=?A-Z^-~]+(\\.[-!#-\'*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \\t]|(\\\\[\\t -~]))+")' // user name
        '@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?' // @domain
        '(\\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+\$'; // .top-level-domain

    /// The regex object that will be compared to the possible email.
    final RegExp regExp = RegExp(pattern);

    // Return `true` if the email is formatted correctly; otherwise, return
    // false.
    return regExp.hasMatch(email);
  }

  /// This method checks to see if a given string is a valid password.
  ///
  /// It will return `true` if the password provided is good and strong.
  static bool isValidPassword(String? password) {
    // If there is no string, it is not a valid password.
    if (password == null || password.isEmpty) return false;

    /// The number of security levels are in the given password.
    int securityFeatures = 0;

    // Check that password is long enough
    if (password.length < 8) return false;

    // Check that password contains at least one uppercase letter.
    if (password.contains(RegExp(r'[A-Z]'))) {
      securityFeatures++;
    }

    // Check that password contains at least one lowercase letter.
    if (password.contains(RegExp(r'[a-z]'))) {
      securityFeatures++;
    }

    // Check that password contains at least one number.
    if (password.contains(RegExp(r'[0-9]'))) {
      securityFeatures++;
    }

    // Check that password contains at least one special character.
    if (password.contains(RegExp(r'[^A-Za-z0-9]'))) {
      securityFeatures++;
    }

    // Only need 3 of the 4 security features to pass.
    return securityFeatures >= 3;
  }

  /// This method checks to see if a given string is a valid phone number.
  ///
  /// It will return `true` if the phone number provided is formatted correctly.
  static bool isValidPhone(String? phone) {
    // If there is no string, it is not a valid phone number.
    if (phone == null || phone.isEmpty) return false;

    /// The regex pattern to compare the possible phone number to.
    const String pattern =
        r'^(?:\+\d{1,3}|0\d{1,3}|00\d{1,2})?(?:\s?\(\d+\))?(?:[-\/\s.]|\d)+$';

    /// The regex object that will be compared to the possible phone number.
    final RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(phone);
  }

  /// This method checks to see if a given string is a valid US zip code.
  ///
  /// It will return `true` if the zip code provided is formatted correctly.
  static bool isValidZipCode(String? zip) {
    // If there is no string, it is not a valid zip code.
    if (zip == null || zip.isEmpty) return false;

    /// The regex pattern to compare the possible zip code to.
    const String pattern = r'^\d{5}([-]?\d{4})?$';

    /// The regex object that will be compared to the possible zip code.
    final RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(zip);
  }
}