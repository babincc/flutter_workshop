import 'dart:async';

import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/dtls_data.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream_packet.dart';
import 'package:flutter_hue/domain/repos/entertainment_stream_repo.dart';

class EntertainmentStreamController {
  /// DTLS client and connection information.
  final DtlsData _dtlsData = DtlsData();

  /// The queue of packets that need to be send to the bridge.
  final List<EntertainmentStreamPacket> _queue = [];

  /// The current length of the queue.
  ///
  /// This is the number of packets that are waiting to be sent to the bridge.
  ///
  /// This is used to see if the queue is getting backed up. If so, you can call
  /// [replaceQueue] to replace the queue with a new packet.
  int get queueLength => _queue.length;

  /// The packet that is being sent to the bridge.
  List<int>? _currentPacket;

  /// The interval at which data is sent to the bridge.
  ///
  /// This is the number of times per second that data is sent to the bridge.
  static const int _sendIntervalHz = 55;

  /// The interval at which data is sent to the bridge in milliseconds.
  int get _sendIntervalMilliseconds => (1000 / _sendIntervalHz).round();

  /// Sends [_currentPacket] to the bridge.
  Timer? _timer;

  /// Counts the number of times a frame of time was skipped instead of sending
  /// data.
  ///
  /// If this number reaches [_maxNumSkips], 10 seconds have been skipped.
  int _numSkips = 0;

  /// The maximum number of skips before the stream is stopped.
  ///
  /// This is 10 seconds worth of skips.
  int get _maxNumSkips => (10000 / _sendIntervalMilliseconds).floor();

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
    Bridge bridge,
    String entertainmentConfigurationId, {
    String Function(String ciphertext)? decrypter,
  }) async {
    // Init variables
    _reset();

    // This timer sends the data to the bridge.
    _timer = Timer.periodic(
      Duration(milliseconds: _sendIntervalMilliseconds),
      (timer) async {
        if (!__isHandlingQueue) {
          __isHandlingQueue = true;
          _handleQueue();
        }

        if (_currentPacket == null) {
          _numSkips++;

          if (_numSkips >= _maxNumSkips) {
            await stopStreaming(
              bridge,
              entertainmentConfigurationId,
              decrypter: decrypter,
            );
          }

          return;
        }

        try {
          await EntertainmentStreamRepo.sendData(
            _dtlsData,
            _currentPacket!,
          );
        } catch (e) {
          // If we end up here, then [_currentPacket] was changed to `null` in
          // the middle of this method call.
          return;
        }

        _numSkips = 0;
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
    Bridge bridge,
    String entertainmentConfigurationId, {
    String Function(String ciphertext)? decrypter,
  }) async {
    // Reset variables
    _reset();
    _currentPacket = null;

    return await EntertainmentStreamRepo.stopStreaming(
      bridge,
      entertainmentConfigurationId,
      _dtlsData,
      decrypter: decrypter,
    );
  }

  /// Add a packet to the queue.
  void addToQueue(EntertainmentStreamPacket packet) {
    _queue.add(packet);
  }

  /// Add multiple packets to the queue.
  void addAllToQueue(List<EntertainmentStreamPacket> packets) {
    _queue.addAll(packets);
  }

  /// Empty the queue and replace it with `packets`.
  Future<void> replaceQueue(List<EntertainmentStreamPacket> packets) async {
    _queue.clear();
    _queue.addAll(packets);
  }

  /// Whether or not [_handleQueue] is currently handling the queue.
  bool __isHandlingQueue = false;

  /// Handles the next packet in the queue.
  Future<void> _handleQueue() async {
    if (_queue.isEmpty) {
      __isHandlingQueue = false;
      return;
    }

    final EntertainmentStreamPacket packet = _queue.removeAt(0);

    if (packet.packets.isEmpty) {
      __isHandlingQueue = false;
      return;
    }

    if (packet.animationDuration == null) {
      // If there is no animation duration, send the last packet in the list,
      // and move on.
      _currentPacket = packet.packets.last;
    } else {
      // If there is an animation duration, send the packets in order, for the
      // duration of the animation.

      final Timer animationTimer = Timer.periodic(
        packet.animationDuration!,
        (timer) {
          try {
            // TODO
          } catch (e) {
            // This is for the rare case where the timer starts after the
            // following Future.delayed call. In this case, we catch a few
            // milliseconds of errors and move on.
          }
        },
      );

      await Future.delayed(packet.animationDuration!);

      animationTimer.cancel();
    }

    // Wait after the animation is done.
    if (packet.waitAfterAnimation != null) {
      await Future.delayed(packet.waitAfterAnimation!);
    }

    // Signal that we are ready to handle the next packet.
    __isHandlingQueue = false;
  }

  /// Resets the stream controlling data to its initial state.
  void _reset() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
    }

    _numSkips = 0;
  }
}
