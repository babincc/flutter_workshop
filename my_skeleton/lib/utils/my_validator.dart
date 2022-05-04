class MyValidator {
  /// This method checks to see if a given string is a valid email address.
  ///
  /// It will return `true` if the email provided is formatted correctly;
  /// otherwise, it will return false.
  static bool isValidEmail(String? email) {
    // If there is no string, it is not a valid email.
    if (email == null || email.isEmpty) {
      return false;
    }

    /// The regex pattern to compare the possible email to.
    const String pattern =
        r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";

    /// The regex object that will be compared to the possible email.
    final regExp = RegExp(pattern);

    // Return `true` if the email is formatted correctly; otherwise, return
    // false.
    return regExp.hasMatch(email);
  }
}
