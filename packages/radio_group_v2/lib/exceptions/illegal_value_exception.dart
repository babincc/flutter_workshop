/// The exception that is thrown when the [RadioGroupController] tries to set a
/// value that is not part of the [RadioGroup]'s value list.
class IllegalValueException implements Exception {
  /// Throws an exception when the [RadioGroupController] tries to set a value
  /// that is not part of the [RadioGroup]'s value list.
  ///
  /// `radioGroupController` is the controller that is throwing the error.
  IllegalValueException({Object? value}) {
    // Check to see if the value that caused `this` exception to be thrown was
    // provided.
    if (value == null) {
      // If no value was provided, throw the default error message.
      throw (_cause);
    } else {
      // If the value was provided, include it in the error message to help with
      // debugging.
      throw ("$_errMsgPt1 ${value.runtimeType}:${value.toString()} $_errMsgPt2");
    }
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The last part of the error message.
  static const String _errMsgPt2 =
      "is not a value in the radio group's values list!";

  /// The default error message.
  static const String _cause = "$_errMsgPt1 This value $_errMsgPt2";
}
