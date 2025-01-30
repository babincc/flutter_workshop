/// The exception that is thrown when an invalid wave offset is provided.
class InvalidWaveOffsetException implements Exception {
  /// Creates a [InvalidWaveOffsetException] with the provided [message].
  const InvalidWaveOffsetException([this.message]);

  /// The message that describes the error.
  final String? message;

  @override
  String toString() {
    StringBuffer messageBuffer = StringBuffer('InvalidWaveOffsetException');

    if (message != null) {
      messageBuffer.write(': $message');
    }

    return messageBuffer.toString();
  }
}
