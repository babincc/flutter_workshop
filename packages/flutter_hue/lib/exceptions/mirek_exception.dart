/// Exception thrown when a value is not within the valid mirek range of 153 -
/// 500 (inclusive).
class MirekException implements Exception {
  /// Creates a [MirekException] object.
  const MirekException([this.message]) : value = null;

  /// Creates a [MirekException] object that includes the value that
  /// triggered this exception.
  const MirekException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final int? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("MirekException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: a number between 153 and 500 (inclusive)\n"
          "\tActual: $value");
    }

    return buffer.toString();
  }
}
