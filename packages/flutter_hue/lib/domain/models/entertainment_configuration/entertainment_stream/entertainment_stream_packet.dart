import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_color.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_controller.dart';
import 'package:flutter_hue/domain/repos/entertainment_stream_repo.dart';

class EntertainmentStreamPacket {
  const EntertainmentStreamPacket({
    required this.entertainmentConfiguration,
    this.colorMode = ColorMode.xy,
    required this.commands,
  });

  /// The entertainment configuration to send the data to.
  final EntertainmentConfiguration entertainmentConfiguration;

  /// The ID of the entertainment configuration to send the data to.
  String get entertainmentConfigurationId => entertainmentConfiguration.id;

  /// The color mode of the data.
  final ColorMode colorMode;

  /// The commands to send to the bridge.
  final List<EntertainmentStreamCommand> commands;

  /// Returns a byte list representation of this packet object.
  ///
  /// Note: If [commands] has more than 20 elements, only the first 20 elements
  /// will be included in the byte list. The bridge only accepts 20 commands at
  /// a time.
  List<int> toBytes() {
    final List<int> availableChannels = entertainmentConfiguration.channels
        .map((channel) => channel.channelId)
        .toList();

    final List<EntertainmentStreamCommand> formattedCommands = [];

    int counter = 0;
    for (final EntertainmentStreamCommand command in commands) {
      if (counter >= 20) break;

      if (!availableChannels.contains(command.channel)) continue;

      if (identical(command.color.colorMode, colorMode)) {
        formattedCommands.add(command);
      } else {
        formattedCommands.add(
          command.copyWith(color: command.color.to(colorMode, 1.0)),
        );
      }

      counter++;
    }

    // Return the properly encoded data.
    switch (colorMode) {
      case ColorMode.xy:
        return EntertainmentStreamRepo.getDataAsXy(
          entertainmentConfigurationId,
          formattedCommands,
        );
      case ColorMode.rgb:
        return EntertainmentStreamRepo.getDataAsRgb(
          entertainmentConfigurationId,
          formattedCommands,
        );
    }
  }

  @override
  String toString() => 'Instance of EntertainmentStreamPacket: {'
      'entertainmentConfigurationId: $entertainmentConfigurationId, '
      'colorMode: ${colorMode.name}, '
      'commands: $commands}';
}
