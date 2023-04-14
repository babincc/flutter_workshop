import 'package:flutter_hue/constants/api_fields.dart';

/// Exception thrown when the data in a stored token is corrupt.
class CorruptTokenDataException implements Exception {
  /// Creates a [CorruptTokenDataException] object.
  const CorruptTokenDataException([this.message]) : value = null;

  /// Creates a [CorruptTokenDataException] object that includes the value that
  /// triggered this exception.
  const CorruptTokenDataException.withValue(this.value, [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The number that caused this exception to be thrown.
  final Map<String, dynamic>? value;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("CorruptTokenDataException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (value != null) {
      buffer.write('\n'
          '\tExpected: {"${ApiFields.accessToken}": [access_token], '
          '"${ApiFields.expiresIn}": [seconds], "${ApiFields.expirationDate}": '
          '[date], "${ApiFields.refreshToken}": [refresh_token], '
          '"${ApiFields.tokenType}": "bearer"}\n'
          '\tActual: ${value.toString()}');
    }

    return buffer.toString();
  }
}
