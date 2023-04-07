/// Exception thrown when a an object is given an ID that does not match the
/// proper regex.
class InvalidIdException implements Exception {
  /// Creates a [InvalidIdException] object.
  const InvalidIdException([this.message]) : value = null;

  /// Creates a [InvalidIdException] object that includes the value that
  /// triggered this exception.
  const InvalidIdException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The ID that caused this exception to be thrown.
  final String? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("InvalidIdException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write('\n'
          '\t"$value" does not match the regex pattern associated with its ID type.');
    }

    return buffer.toString();
  }
}
