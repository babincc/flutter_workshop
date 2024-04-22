import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_color.dart';

class EntertainmentStreamCommand {
  const EntertainmentStreamCommand({
    required this.channel,
    required this.color,
  });

  /// The channel that this command is for.
  final int channel;

  /// The color command to send on the given [channel].
  final EntertainmentStreamColor color;

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  EntertainmentStreamCommand copyWith({
    int? channel,
    EntertainmentStreamColor? color,
  }) {
    return EntertainmentStreamCommand(
      channel: channel ?? this.channel,
      color: color ?? this.color,
    );
  }
}
