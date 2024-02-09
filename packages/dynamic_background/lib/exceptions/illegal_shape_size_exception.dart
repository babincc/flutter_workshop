/// The exception that is thrown when a shape that is to be drawn is given
/// illegal dimensions.
class IllegalShapeSizeException implements Exception {
  /// Creates a [IllegalShapeSizeException] with the provided [message].
  const IllegalShapeSizeException([this.message]);

  /// The message that describes the error.
  final String? message;

  @override
  String toString() {
    StringBuffer messageBuffer = StringBuffer('IllegalShapeSizeException');

    if (message != null) {
      messageBuffer.write(': $message');
    }

    return messageBuffer.toString();
  }
}
