import 'dart:async';
import 'dart:math';

import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_color.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_controller.dart';
import 'package:flutter_hue/flutter_hue.dart';

class EntertainmentStreamCommand {
  EntertainmentStreamCommand({
    required this.channel,
    required this.color,
    this.animationDuration,
    this.waitAfterAnimation,
    this.animationType = AnimationType.none,
  })  : assert(animationDuration == null || animationDuration > Duration.zero),
        assert(
            waitAfterAnimation == null || waitAfterAnimation > Duration.zero),
        _currentColor = null;

  /// The channel that this command is for.
  final int channel;

  /// The color command to send on the given [channel].
  final EntertainmentStreamColor color;

  /// The current color of the command based on the animation.
  EntertainmentStreamColor? _currentColor;

  /// The current color of the command based on the animation.
  EntertainmentStreamColor? get currentColor => _currentColor;

  /// The duration of the animation.
  ///
  /// The amount of time between sending the first element of [packets] and the
  /// last element of [packets].
  final Duration? animationDuration;

  /// The duration to wait after the animation has finished.
  ///
  /// If there is no animation, this will be the time to wait after this command
  /// has been sent.
  final Duration? waitAfterAnimation;

  /// How to animate into this command from the last one that was sent.
  final AnimationType animationType;

  /// Whether or not this command is currently running.
  bool _isRunning = false;

  /// Whether or not this command has been run.
  bool get didRun => _currentColor != null && !_isRunning;

  /// Runs this command.
  void run(EntertainmentStreamColor? previousColor) {
    if (_isRunning) return;

    // This is done synchronously to avoid race conditions.
    _isRunning = true;

    // Now run the async part of the command.
    _run(previousColor);
  }

  /// Runs this command.
  Future<void> _run(EntertainmentStreamColor? previousColor) async {
    if (animationDuration == null || animationDuration == Duration.zero) {
      _currentColor = color;
    } else {
      // Start a timer for animationDuration.
      final Timer timer = Timer.periodic(
        Duration(
          milliseconds: EntertainmentStreamController.sendIntervalMilliseconds,
        ),
        (timer) {
          /// How many milliseconds have elapsed since the start of the timer.
          final int elapsedMilliseconds = (timer.tick - 1) *
              EntertainmentStreamController.sendIntervalMilliseconds;

          // Calculate and set [_currentColor] based on animation type.
          switch (animationType) {
            case AnimationType.ease:
              if (previousColor == null) {
                __getCurrentColorNoAnimation();
                break;
              }

              __getCurrentColorEase(previousColor, elapsedMilliseconds);
              break;
            case AnimationType.none:
              __getCurrentColorNoAnimation();
              break;
          }
        },
      );

      // Wait for the animation to finish.
      await Future.delayed(animationDuration!);

      timer.cancel();
    }

    // Wait after animation.
    if (waitAfterAnimation != null && waitAfterAnimation != Duration.zero) {
      await Future.delayed(waitAfterAnimation!);
    }

    _isRunning = false;
  }

  void __getCurrentColorEase(
    EntertainmentStreamColor previousColor,
    int elapsedMilliseconds,
  ) {
    final double elapsedTimeRatio =
        min(elapsedMilliseconds / animationDuration!.inMilliseconds, 1.0);

    _currentColor =
        EntertainmentStreamColor.lerp(previousColor, color, elapsedTimeRatio);
  }

  void __getCurrentColorNoAnimation() {
    _currentColor = color;
  }

  /// Returns a copy of this object.
  EntertainmentStreamCommand copy() => copyWith();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  EntertainmentStreamCommand copyWith({
    int? channel,
    EntertainmentStreamColor? color,
    Duration? animationDuration = const Duration(seconds: -1),
    Duration? waitAfterAnimation = const Duration(seconds: -1),
    AnimationType? animationType,
  }) {
    return EntertainmentStreamCommand(
      channel: channel ?? this.channel,
      color: color ?? this.color.copy(),
      animationDuration:
          (animationDuration == null || animationDuration < Duration.zero)
              ? this.animationDuration
              : animationDuration,
      waitAfterAnimation:
          (waitAfterAnimation == null || waitAfterAnimation < Duration.zero)
              ? this.waitAfterAnimation
              : waitAfterAnimation,
      animationType: animationType ?? this.animationType,
    );
  }

  @override
  String toString() =>
      'Instance of EntertainmentStreamCommand: {channel: $channel, color: '
      '$color, animationDuration: $animationDuration, waitAfterAnimation: '
      '$waitAfterAnimation, animationType: $animationType}';
}

/// How to animate between packets in a bundle.
enum AnimationType {
  /// Gently fade from the previous command's color to the one in the current
  /// command, resting on the specified color for a moment.
  ///
  /// Prolong the amount of time on the specified color by setting the command's
  /// [waitAfterAnimation] property.
  ease,

  /// Instantly switch from the previous command's color to the one in the
  /// current command.
  none;
}
