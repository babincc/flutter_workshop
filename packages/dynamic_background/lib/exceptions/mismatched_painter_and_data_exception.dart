import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter_data/painter_data.dart';

/// The exception that is thrown when a [Painter] is initialized with
/// [PainterData] that is not compatible with it.
class MismatchedPainterAndDataException implements Exception {
  /// Creates a [MismatchedPainterAndDataException] with the provided [message].
  const MismatchedPainterAndDataException(
      [this.message, this.painter, this.data]);

  /// The message that describes the error.
  final String? message;

  /// The [Painter] that was initialized with the mismatched [PainterData].
  final Painter? painter;

  /// The [PainterData] that was used to initialize the mismatched [Painter].
  final PainterData? data;

  @override
  String toString() {
    StringBuffer messageBuffer =
        StringBuffer('MismatchedPainterAndDataException');

    if (painter != null || data != null || message != null) {
      messageBuffer.write(':');
    }

    if (painter != null) {
      messageBuffer.write('\n\tPainter - $painter');
    }

    if (data != null) {
      messageBuffer.write('\n\tData - $data');
    }

    if (message != null) {
      messageBuffer.write('\n$message');
    }

    return messageBuffer.toString();
  }
}
