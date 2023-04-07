/// Exception thrown when a value is not within the valid percentage range of
/// 0 - 100 (inclusive).
class PercentageException implements Exception {
  /// Creates a [PercentageException] object.
  const PercentageException([this.message]) : value = null;

  /// Creates a [PercentageException] object that includes the value that
  /// triggered this exception.
  const PercentageException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final num? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("PercentageException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: a number between 0 and 100 (inclusive)\n"
          "\tActual: $value");
    }

    return buffer.toString();
  }
}
