import 'package:dynamic_background/domain/models/painter/fader_painter.dart';

/// The exception that is thrown when an empty list is used to initialize a
/// [FaderPainter].
class EmptyColorListException implements Exception {
  /// Creates a [EmptyColorListException] with the provided [message].
  const EmptyColorListException([this.message]);

  /// The message that describes the error.
  final String? message;

  @override
  String toString() {
    StringBuffer messageBuffer = StringBuffer('EmptyColorListException');

    if (message != null) {
      messageBuffer.write(': $message');
    }

    return messageBuffer.toString();
  }
}
