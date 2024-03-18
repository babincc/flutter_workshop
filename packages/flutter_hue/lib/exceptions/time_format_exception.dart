/// Exception thrown when an invalid time format is encountered.
abstract class TimeFormatException implements Exception {
  /// Creates a [TimeFormatException] object.
  const TimeFormatException([this.message]) : value = null;

  /// Creates a [TimeFormatException] object that includes the value that
  /// triggered this exception.
  const TimeFormatException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final int? value;

  /// Constructs the error message for this exception.
  String getErrorMessage({
    required String exceptionType,
    required int? min,
    required int? max,
  }) {
    final StringBuffer buffer = StringBuffer(exceptionType);

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write("\n"
          "\tExpected: number between $min to $max (inclusive)\n"
          "\tActual: $value");
    }

    return buffer.toString();
  }
}

/// Exception thrown when an invalid hour is encountered.
class InvalidHourException extends TimeFormatException {
  /// Creates a [InvalidHourException] object.
  const InvalidHourException([super.message]);

  /// Creates a [InvalidHourException] object that includes the value that
  /// triggered this exception.
  const InvalidHourException.withValue(int super.value, [super.message])
      : super.withValue();

  @override
  String toString() => getErrorMessage(
        exceptionType: "InvalidHourException",
        min: 0,
        max: 23,
      );
}

/// Exception thrown when an invalid minute is encountered.
class InvalidMinuteException extends TimeFormatException {
  /// Creates a [InvalidMinuteException] object.
  const InvalidMinuteException([super.message]);

  /// Creates a [InvalidMinuteException] object that includes the value that
  /// triggered this exception.
  const InvalidMinuteException.withValue(int super.value, [super.message])
      : super.withValue();

  @override
  String toString() => getErrorMessage(
        exceptionType: "InvalidMinuteException",
        min: 0,
        max: 59,
      );
}

/// Exception thrown when an invalid second is encountered.
class InvalidSecondException extends TimeFormatException {
  /// Creates a [InvalidSecondException] object.
  const InvalidSecondException([super.message]);

  /// Creates a [InvalidSecondException] object that includes the value that
  /// triggered this exception.
  const InvalidSecondException.withValue(int super.value, [super.message])
      : super.withValue();

  @override
  String toString() => getErrorMessage(
        exceptionType: "InvalidSecondException",
        min: 0,
        max: 59,
      );
}
