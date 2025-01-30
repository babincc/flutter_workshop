import 'package:dynamic_background/domain/models/painter/wave_painter.dart';

/// The exception that is thrown when an empty list is used to initialize a
/// [WavePainter].
class EmptyWaveListException implements Exception {
  /// Creates a [EmptyWaveListException] with the provided [message].
  const EmptyWaveListException([this.message]);

  /// The message that describes the error.
  final String? message;

  @override
  String toString() {
    StringBuffer messageBuffer = StringBuffer('EmptyWaveListException');

    if (message != null) {
      messageBuffer.write(': $message');
    }

    return messageBuffer.toString();
  }
}
