import 'dart:async';
import 'dart:math';

import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/dtls_data.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_color.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_packet.dart';
import 'package:flutter_hue/domain/repos/entertainment_stream_repo.dart';
import 'package:flutter_hue/exceptions/invalid_command_channel_exception.dart';

part 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_command.dart';

/// Controls the streaming of entertainment data to a bridge.
class EntertainmentStreamController {
  /// Creates a new [EntertainmentStreamController] object.
  EntertainmentStreamController(this.entertainmentConfiguration);

  /// Creates an empty [EntertainmentStreamController] object.
  EntertainmentStreamController.empty()
      : entertainmentConfiguration = EntertainmentConfiguration.empty();

  /// The entertainment configuration that this stream is for.
  final EntertainmentConfiguration entertainmentConfiguration;

  /// The ID of the entertainment configuration to send the data to.
  String get entertainmentConfigurationId => entertainmentConfiguration.id;

  /// DTLS client and connection information.
  final DtlsData _dtlsData = DtlsData();

  /// The queue of packets that need to be send to the bridge.
  ///
  /// The key is the channel that the commands are for.
  final Map<int, List<EntertainmentStreamCommand>> _queue = {};

  /// The current length of the queue in the given `channel`.
  ///
  /// This is the number of commands that are waiting to be sent to the bridge
  /// for the given `channel`.
  ///
  /// This is used to see if the queue is getting backed up. If so, you can call
  /// [flushQueue], [replaceQueue], or [replaceQueueChannel] to help deal with
  /// the backup.
  int queueLengthInChannel(int channel) => _queue[channel]?.length ?? 0;

  /// The current state of the channels.
  ///
  /// The key is the channel that the color state is for.
  final Map<int, EntertainmentStreamColor> _currentChannelStates = {};

  /// The interval at which data is sent to the bridge.
  ///
  /// This is the number of times per second that data is sent to the bridge.
  static const int sendIntervalHz = 55;

  /// The interval at which data is sent to the bridge in milliseconds.
  static int get sendIntervalMilliseconds => (1000 / sendIntervalHz).round();

  /// Sends [_currentPacket] to the bridge.
  Timer? _sendTimer;

  /// Counts the number of times a frame of time was skipped instead of sending
  /// data.
  ///
  /// If this number reaches [_maxNumSkips], 10 seconds have been skipped.
  int _numSkips = 0;

  /// The maximum number of skips before the stream is stopped.
  ///
  /// This is 10 seconds worth of skips.
  int get _maxNumSkips => (10000 / sendIntervalMilliseconds).floor();

  /// Start `this` entertainment stream.
  ///
  /// The `bridge` parameter is the bridge to establish the handshake with.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If the stream is inactive for 10 seconds, that is, if [_currentPacket] is
  /// `null` for 10 seconds, the stream will end.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  Future<bool> startStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async {
    // Init variables
    _reset();

    // This timer sends the data to the bridge.
    _sendTimer = Timer.periodic(
      Duration(milliseconds: sendIntervalMilliseconds),
      (timer) async {
        try {
          if (_numSkips >= _maxNumSkips) {
            await stopStreaming(
              bridge,
              decrypter: decrypter,
            );
          }

          if (!__isHandlingQueue) {
            __isHandlingQueue = true;
            int startChannel = 0;
            while (true) {
              final int endChannel = _handleQueue(startChannel);

              if (endChannel == startChannel) {
                break;
              } else {
                startChannel = endChannel + 1;
              }
            }
          }

          if (_currentChannelStates.isEmpty) {
            _numSkips++;
            return;
          }

          // Send packets based on groups of up to 20 commands.
          for (int i = 0; i < _currentChannelStates.keys.length; i += 20) {
            // The current group of 20 channels to send data for.
            final List<int> channels =
                _currentChannelStates.keys.toList().sublist(
                      i,
                      min(i + 20, _currentChannelStates.keys.length),
                    );

            /// The color mode of the first channel.
            final ColorMode colorMode =
                _currentChannelStates[channels.first]!.colorMode;

            /// The commands to send to the bridge.
            final List<EntertainmentStreamCommand> commands = [];

            // Go through the current channels and add the commands to the
            // packet that will be sent to the bridge.
            for (final int channel in channels) {
              /// The command color in the same type as colorMode.
              final EntertainmentStreamColor color;
              if (identical(
                  _currentChannelStates[channel]!.colorMode, colorMode)) {
                color = _currentChannelStates[channel]!;
              } else {
                color = _currentChannelStates[channel]!.to(colorMode);
              }

              commands.add(
                EntertainmentStreamCommand(channel: channel, color: color),
              );
            }

            // Create the packet to send to the bridge.
            final EntertainmentStreamPacket packet = EntertainmentStreamPacket(
              entertainmentConfiguration: entertainmentConfiguration,
              colorMode: colorMode,
              commands: commands,
            );

            try {
              await EntertainmentStreamRepo.sendData(
                _dtlsData,
                packet.toBytes(),
              );
            } catch (e) {
              _numSkips++;
              return;
            }
          }

          _numSkips = 0;
        } catch (e) {
          // If we get here, then the stream has ended.
          _numSkips++;
        }
      },
    );

    return await EntertainmentStreamRepo.startStreaming(
      bridge,
      entertainmentConfigurationId,
      _dtlsData,
      decrypter: decrypter,
    );
  }

  /// Stop `this` entertainment stream.
  ///
  /// The `bridge` parameter is the bridge to establish the handshake with.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  Future<bool> stopStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async {
    // Reset variables
    _reset();
    _currentChannelStates.clear();

    return await EntertainmentStreamRepo.stopStreaming(
      bridge,
      entertainmentConfigurationId,
      _dtlsData,
      decrypter: decrypter,
    );
  }

  /// Add a command to the queue.
  void addToQueue(EntertainmentStreamCommand command) {
    if (_queue[command.channel] == null) {
      _queue[command.channel] = [];
    }

    if (_queue[command.channel]!.isNotEmpty) {
      command._previousCommand = _queue[command.channel]!.last;
    }

    _queue[command.channel]!.add(command);
  }

  /// Add multiple commands to the queue.
  void addAllToQueue(List<EntertainmentStreamCommand> commands) {
    for (final command in commands) {
      addToQueue(command);
    }
  }

  void flushQueueChannel(int channel) {
    if (_queue[channel] == null || _queue[channel]!.isEmpty) return;

    final List<EntertainmentStreamCommand> oldCommands =
        List.from(_queue[channel]!);

    _queue[channel]!.clear();

    for (final EntertainmentStreamCommand command in oldCommands) {
      command.dispose();
    }
  }

  /// Empties the queue.
  void flushQueue() {
    for (final int key in _queue.keys) {
      flushQueueChannel(key);
    }

    _queue.clear();
  }

  /// Empty the queue and replace it with `newQueue`.
  ///
  /// The keys in `newQueue` are the channels that the commands are for.
  ///
  /// The values in `newQueue` are the commands to send to the bridge.
  ///
  /// Throws [InvalidCommandChannelException] if a command in `newQueue` map is
  /// not in the same channel as the channel it was initialized with.
  void replaceQueue(Map<int, List<EntertainmentStreamCommand>> newQueue) {
    flushQueue();

    final Map<int, List<EntertainmentStreamCommand>> verifiedQueue = {};

    for (final int key in newQueue.keys) {
      verifiedQueue[key] = _verifyCommandsInProperChannel(key, newQueue[key]!);
    }

    for (final int key in verifiedQueue.keys) {
      addAllToQueue(verifiedQueue[key]!);
    }
  }

  /// Empty the queue only in the given 'channel' and replace that data with
  /// `newQueue`.
  ///
  /// Throws [InvalidCommandChannelException] if a command in `newQueue` is does
  /// not have the same channel as the `channel` parameter provided to this
  /// method.
  void replaceQueueChannel(
    int channel,
    List<EntertainmentStreamCommand> newChannelQueue,
  ) {
    final List<EntertainmentStreamCommand> verifiedChannel =
        _verifyCommandsInProperChannel(channel, newChannelQueue);

    flushQueueChannel(channel);

    addAllToQueue(verifiedChannel);
  }

  /// Checks to make sure each command in `commands` has the same channel as
  /// `channel`.
  ///
  /// Returns a copied version of `commands` if all is well; otherwise, throws
  /// [InvalidCommandChannelException].
  List<EntertainmentStreamCommand> _verifyCommandsInProperChannel(
    int channel,
    List<EntertainmentStreamCommand> commands,
  ) {
    final List<EntertainmentStreamCommand> verifiedCommands = [];

    for (final EntertainmentStreamCommand command in commands) {
      if (!identical(channel, command.channel)) {
        throw InvalidCommandChannelException.withValues(
          command.channel,
          channel,
        );
      }

      verifiedCommands.add(command);
    }

    return verifiedCommands;
  }

  /// Whether or not [_handleQueue] is currently handling the queue.
  bool __isHandlingQueue = false;

  /// Handles the queue and builds packets to be sent to the bridge.
  ///
  /// The `startChannel` parameter is the channel in the queue to start at. This
  /// method will start there and go up to 20 channels ahead, only counting
  /// channels with data in them.
  ///
  /// Returns the channel that the method stopped at. That means, the return
  /// value is a channel that has been handled.
  ///
  /// If the `startChannel` value is returned, then the queue has been handled
  /// in its entirety.
  int _handleQueue(int startChannel) {
    if (_queue.isEmpty) {
      __isHandlingQueue = false;
      return startChannel;
    }

    /// All of the channels in the queue.
    final List<int> channels = _queue.keys.toList()..sort();

    // Ignore channels with no data.
    for (final int key in _queue.keys) {
      if (_queue[key]!.isEmpty) {
        channels.remove(key);
      }
    }

    if (channels.isEmpty || startChannel > channels.last) {
      __isHandlingQueue = false;
      return startChannel;
    }

    int startChannelIndex = -1;

    /// Find the channel range to handle.
    for (int i = 0; i < channels.length; i++) {
      if (channels[i] >= startChannel) {
        startChannelIndex = i;
        break;
      }
    }

    if (startChannelIndex < 0) {
      __isHandlingQueue = false;
      return startChannel;
    }

    final List<int> handledChannels = channels.sublist(
      startChannelIndex,
      min(startChannelIndex + 20, channels.length),
    );

    // Up to this point, everything has been done synchronously to prevent race
    // conditions. Now, we can handle the queue asynchronously.
    __handleQueue(handledChannels);

    return handledChannels.last;
  }

  /// Handles the queue and builds packets to be sent to the bridge.
  ///
  /// `channels` is the list of channels to handle.
  Future<void> __handleQueue(List<int> channels) async {
    for (final int channel in channels) {
      if (_queue[channel] == null || _queue[channel]!.isEmpty) continue;

      final EntertainmentStreamCommand command = _queue[channel]!.first;

      if (command.currentColor == null) {
        command.run(_currentChannelStates[channel]);
        continue;
      }

      _currentChannelStates[channel] = command.currentColor!;

      if (command.didRun) {
        _queue[channel]!.removeAt(0).dispose();
      }
    }

    __isHandlingQueue = false;
  }

  /// Resets the stream controlling data to its initial state.
  void _reset() {
    if (_sendTimer != null && _sendTimer!.isActive) {
      _sendTimer?.cancel();
      _sendTimer = null;
    }

    _numSkips = 0;

    flushQueue();
  }

  @override
  String toString() => 'Instance of EntertainmentStreamController: {'
      'entertainmentConfigurationId: $entertainmentConfigurationId}';
}
