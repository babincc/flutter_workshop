/// The exception that is thrown when the [RadioGroupController] tries to set a
/// value at an index that is outside of the [RadioGroup]'s value list's range.
class IndexOutOfBoundsException implements Exception {
  /// Throws an exception when the [RadioGroupController] tries to set a value
  /// at an index that is outside of the [RadioGroup]'s value list's range.
  ///
  /// `index` is the index that is throwing the error.
  ///
  /// `iterable` is the value list for the radio group.
  IndexOutOfBoundsException({int? index, Iterable? iterable}) {
    throw ("$_errMsgPt1 "
        "${index ?? '[index not provided to exception thrower]'} $_errMsgPt2 "
        "${iterable?.length ?? '[iterable length not provided to exception thrower]'}"
        "$_errMsgPt3");
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The middle part of the error message.
  static const String _errMsgPt2 = "is out of bounds for iterable of length";

  /// The last part of the error message.
  static const String _errMsgPt3 = "!";
}
