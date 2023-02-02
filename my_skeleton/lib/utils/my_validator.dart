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
        r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";

    /// The regex object that will be compared to the possible email.
    final regExp = RegExp(pattern);

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
    if (password.contains(RegExp(r"[A-Z]"))) {
      securityFeatures++;
    }

    // Check that password contains at least one lowercase letter.
    if (password.contains(RegExp(r"[a-z]"))) {
      securityFeatures++;
    }

    // Check that password contains at least one number.
    if (password.contains(RegExp(r"[0-9]"))) {
      securityFeatures++;
    }

    // Check that password contains at least one special character.
    if (password.contains(RegExp(r"[^A-Za-z0-9]"))) {
      securityFeatures++;
    }

    // Only need 3 of the 4 security features to pass.
    return securityFeatures >= 3;
  }
}
