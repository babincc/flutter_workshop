/// Exception thrown when the user needs to re-authenticate.
class ReauthRequiredException implements Exception {
  /// Creates a [ReauthRequiredException] object.
  const ReauthRequiredException([this.message]);

  /// The error message associated with this exception.
  final String? message;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("ReauthRequiredException");

    if (message != null) {
      buffer.write(": $message");
    }

    return buffer.toString();
  }
}
