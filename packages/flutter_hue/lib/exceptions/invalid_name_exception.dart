/// Exception thrown when a an object is named with a string that does not have
/// a length within the range of 1 to 32 (inclusive).
class InvalidNameException implements Exception {
  /// Creates a [InvalidNameException] object.
  const InvalidNameException([this.message]) : value = null;

  /// Creates a [InvalidNameException] object that includes the value that
  /// triggered this exception.
  const InvalidNameException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final String? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("InvalidNameException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: a string with length == 1 to 32 (inclusive)\n"
          "\tActual: $value -> length == ${value!.length}");
    }

    return buffer.toString();
  }
}
