/// Exception thrown when an [EntertainmentStreamCommand] is added to a channel
/// in the queue that does not match the channel it was initialized with.
class InvalidCommandChannelException implements Exception {
  /// Creates a [InvalidCommandChannelException] object.
  const InvalidCommandChannelException([this.message])
      : commandChannel = null,
        queueChannel = null;

  /// Creates a [InvalidCommandChannelException] object that includes the values
  /// that triggered this exception.
  const InvalidCommandChannelException.withValues(
      this.commandChannel, this.queueChannel,
      [this.message]);

  /// The error message associated with this exception.
  final String? message;

  /// The channel that the command was initialized with.
  final int? commandChannel;

  /// The channel that the command was added to.
  final int? queueChannel;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer("InvalidCommandChannelException");

    if (message != null) {
      buffer.write(": $message");
    }

    if (commandChannel != null) {
      buffer.write("\n"
          "\tThe command's channel value is $commandChannel");
    }

    if (queueChannel != null) {
      buffer.write("\n"
          "\tThe command was added to the queue in channel $queueChannel");
    }

    return buffer.toString();
  }
}
