/// Exception thrown when a value is not within the unit interval of 0 to 1
/// (inclusive).
class UnitIntervalException implements Exception {
  /// Creates a [UnitIntervalException] object.
  const UnitIntervalException([this.message]) : value = null;

  /// Creates a [UnitIntervalException] object that includes the value that
  /// triggered this exception.
  const UnitIntervalException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final num? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("UnitIntervalException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: a number between 0 and 1 (inclusive)\n"
          "\tActual: $value");
    }

    return buffer.toString();
  }
}
