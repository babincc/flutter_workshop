/// Exception thrown when a gradient is being submitted with an invalid number
/// of points.
class GradientException implements Exception {
  /// Creates a [GradientException] object.
  const GradientException([this.message]) : value = null;

  /// Creates a [GradientException] object that includes the value that
  /// triggered this exception.
  const GradientException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final int? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("GradientException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: num points == 0 OR num points == 2 to 5 (inclusive)\n"
          "\tActual: num points == $value");
    }

    return buffer.toString();
  }
}
