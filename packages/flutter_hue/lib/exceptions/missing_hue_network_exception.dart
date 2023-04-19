/// Exception thrown when a resource attempts to access its linked resources
/// when it does not have a [HueNetwork] object, or if a linked resource is not
/// found in the [HueNetwork].
class MissingHueNetworkException implements Exception {
  /// Creates a [MissingHueNetworkException] object.
  const MissingHueNetworkException([this.message]);

  /// The error message associated with this exception.
  final String? message;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("MissingHueNetworkException");

    if (message != null) {
      buffer.write(": $message");
    }

    return buffer.toString();
  }
}
