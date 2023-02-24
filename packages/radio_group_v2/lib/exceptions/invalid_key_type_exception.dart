import 'package:flutter/material.dart';

/// The exception that is thrown when a key with a type other than
/// `GlobalKey<RadioGroupState>` is assigned to a [RadioGroup].
class InvalidKeyTypeException implements Exception {
  /// Throws an exception for a [RadioGroup] is given a key that is not of the
  /// type `GlobalKey<RadioGroupState>`
  ///
  /// `key` is the mistyped key that was used.
  InvalidKeyTypeException({Key? key}) {
    if (key == null) {
      // If no key was provided, throw the default error message.
      throw (_cause);
    } else {
      // If the key was provided, include it in the error message to help with
      // debugging.
      throw ("$_errMsgPt1 "
          "${key.runtimeType}:${key.toString()} is not a valid key for a "
          "`RadioGroup` $_errMsgPt2");
    }
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The last part of the error message.
  static const String _errMsgPt2 =
      "Keys assigned to `RadioGroup` objects must be of the type "
      "`GlobalKey<RadioGroupState>`!";

  /// The default error message.
  static const String _cause = "$_errMsgPt1 $_errMsgPt2";
}
