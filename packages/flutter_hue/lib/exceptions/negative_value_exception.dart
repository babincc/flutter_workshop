/// Exception thrown when a value is negative when it's not supposed to be.
class NegativeValueException implements Exception {
  /// Creates a [NegativeValueException] object.
  const NegativeValueException([this.message]) : value = null;

  /// Creates a [NegativeValueException] object that includes the value that
  /// triggered this exception.
  const NegativeValueException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final num? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("NegativeValueException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: value >= 0\n"
          "\tActual: $value");
    }

    return buffer.toString();
  }
}
