/// Exception thrown when a value is not within the related array of valid
/// values.
class InvalidValueException<T> implements Exception {
  /// Creates a [InvalidValueException] object.
  const InvalidValueException([this.message])
      : value = null,
        validValues = null;

  /// Creates a [InvalidValueException] object that includes the value that
  /// triggered this exception.
  const InvalidValueException.withValue(this.value, this.validValues,
      [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The value that caused this exception to be thrown.
  final T? value;

  /// All of the valid values.
  final List<T>? validValues;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("InvalidValueException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: one of ${validValues.toString()}\n"
          "\tActual: $value");
    }

    return buffer.toString();
  }
}
