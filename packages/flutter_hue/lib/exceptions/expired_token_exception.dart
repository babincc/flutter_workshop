/// Exception thrown when an expired token is encountered.
abstract class ExpiredTokenException implements Exception {
  /// Creates a [ExpiredTokenException] object.
  const ExpiredTokenException([this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// Constructs the error message for this exception.
  String getErrorMessage({
    required String exceptionType,
    required String hint,
  }) {
    final StringBuffer buffer = StringBuffer(exceptionType);

    if (message != null) {
      buffer.write(": $message");
    }

    buffer.write("\n$hint");

    return buffer.toString();
  }
}

/// Exception thrown when an expired access token is encountered.
///
/// That is the token that is meant to be used to access the bridge remotely.
class ExpiredAccessTokenException extends ExpiredTokenException {
  /// Creates a [ExpiredAccessTokenException] object.
  const ExpiredAccessTokenException([super.message]);

  @override
  String toString() => getErrorMessage(
        exceptionType: "ExpiredAccessTokenException",
        hint: "Try refreshing the token. See "
            "[TokenRepo.refreshRemoteToken]",
      );
}

/// Exception thrown when an expired refresh token is encountered.
///
/// That is the token that is meant to be used to refresh the access token.
class ExpiredRefreshTokenException extends ExpiredTokenException {
  /// Creates a [ExpiredRefreshTokenException] object.
  const ExpiredRefreshTokenException([super.message]);

  @override
  String toString() => getErrorMessage(
        exceptionType: "ExpiredRefreshTokenException",
        hint: "Try having the user grant access to the app again. See "
            "[TokenRepo.remoteAuthRequest]",
      );
}
