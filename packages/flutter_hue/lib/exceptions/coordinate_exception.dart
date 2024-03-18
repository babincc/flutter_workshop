/// Exception thrown when an invalid coordinate is encountered.
abstract class CoordinateException implements Exception {
  /// Creates a [CoordinateException] object.
  const CoordinateException([this.message]) : value = null;

  /// Creates a [CoordinateException] object that includes the value that
  /// triggered this exception.
  const CoordinateException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final double? value;

  /// Constructs the error message for this exception.
  String getErrorMessage({
    required String exceptionType,
    required double? min,
    required double? max,
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

/// Exception thrown when an invalid latitude is encountered.
class InvalidLatitudeException extends CoordinateException {
  /// Creates a [InvalidLatitudeException] object.
  const InvalidLatitudeException([super.message]);

  /// Creates a [InvalidLatitudeException] object that includes the value that
  /// triggered this exception.
  const InvalidLatitudeException.withValue(double super.value, [super.message])
      : super.withValue();

  @override
  String toString() => getErrorMessage(
        exceptionType: "InvalidLatitudeException",
        min: -90,
        max: 90,
      );
}

/// Exception thrown when an invalid longitude is encountered.
class InvalidLongitudeException extends CoordinateException {
  /// Creates a [InvalidLongitudeException] object.
  const InvalidLongitudeException([super.message]);

  /// Creates a [InvalidLongitudeException] object that includes the value that
  /// triggered this exception.
  const InvalidLongitudeException.withValue(double super.value, [super.message])
      : super.withValue();

  @override
  String toString() => getErrorMessage(
        exceptionType: "InvalidLongitudeException",
        min: -180,
        max: 180,
      );
}
