import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_packet.dart';

class EntertainmentStreamBundle {
  const EntertainmentStreamBundle({
    required this.packets,
    this.animationDuration,
    this.waitAfterAnimation,
  })  : assert(packets.length > 0),
        assert(animationDuration == null || animationDuration > Duration.zero),
        assert(
            waitAfterAnimation == null || waitAfterAnimation > Duration.zero);

  /// A list of packets to send to the bridge.
  ///
  /// These will be sent in the order they are in the list, over the course of
  /// [animationDuration].
  final List<EntertainmentStreamPacket> packets;

  /// The duration of the animation.
  ///
  /// The amount of time between sending the first element of [packets] and the
  /// last element of [packets].
  final Duration? animationDuration;

  /// The duration to wait after the animation has finished.
  final Duration? waitAfterAnimation;

  /// The amount of time to spend on each color in a linear curve from the
  /// first color to the last color.
  double get timePerColor => animationDuration!.inMilliseconds / packets.length;
}
