import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/dtls_data.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_color.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_stream/entertainment_stream_controller.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';
import 'package:flutter_hue/domain/services/entertainment_stream_service.dart';
import 'package:flutter_hue/utils/json_tool.dart';

class EntertainmentStreamRepo {
  /// Start streaming for the givin `entertainmentConfiguration`.
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
  static Future<bool> startStreaming(
    Bridge bridge,
    String entertainmentConfigurationId,
    DtlsData dtlsData, {
    String Function(String ciphertext)? decrypter,
  }) async {
    final bool isStarted = await _startStreaming(
      bridge,
      entertainmentConfigurationId,
      decrypter: decrypter,
    );

    if (!isStarted) return false;

    return await EntertainmentStreamRepo._establishDtlsHandshake(
      bridge: bridge,
      dtlsData: dtlsData,
      decrypter: decrypter,
    );
  }

  /// Start streaming for the givin `entertainmentConfiguration`.
  static Future<bool> _startStreaming(
    Bridge bridge,
    String entertainmentConfigurationId, {
    String Function(String ciphertext)? decrypter,
  }) async {
    final String body = JsonTool.writeJson(
      {ApiFields.action: ApiFields.start},
    );

    return await __setStreamingState(
      bridge,
      entertainmentConfigurationId,
      decrypter,
      body,
    );
  }

  /// Stop streaming for the givin `entertainmentConfiguration`.
  static Future<bool> stopStreaming(
    Bridge bridge,
    String entertainmentConfigurationId,
    DtlsData dtlsData, {
    String Function(String ciphertext)? decrypter,
  }) async {
    await dtlsData.tryDisconnect();

    return await _stopStreaming(
      bridge,
      entertainmentConfigurationId,
      decrypter: decrypter,
    );
  }

  /// Stop streaming for the givin `entertainmentConfiguration`.
  static Future<bool> _stopStreaming(
    Bridge bridge,
    String entertainmentConfigurationId, {
    String Function(String ciphertext)? decrypter,
  }) async {
    final String body = JsonTool.writeJson(
      {ApiFields.action: ApiFields.stop},
    );

    return await __setStreamingState(
      bridge,
      entertainmentConfigurationId,
      decrypter,
      body,
    );
  }

  /// Set the streaming state for the given `entertainmentConfiguration`.
  static Future<bool> __setStreamingState(
    Bridge bridge,
    String entertainmentConfigurationId,
    String Function(String ciphertext)? decrypter,
    String body,
  ) async {
    final String? bridgeIpAddr = bridge.ipAddress;
    final String? appKey = bridge.applicationKey;

    if (bridgeIpAddr == null) return false;
    if (appKey == null) return false;

    final Map<String, dynamic>? result = await HueHttpRepo.put(
      bridgeIpAddr: bridgeIpAddr,
      applicationKey: appKey,
      resourceType: ResourceType.entertainmentConfiguration,
      pathToResource: entertainmentConfigurationId,
      body: body,
      decrypter: decrypter,
    );

    if (result == null) return false;
    if (result[ApiFields.errors] != null) {
      if (result[ApiFields.errors] is List ||
          result[ApiFields.errors] is String) {
        if (result[ApiFields.errors].isNotEmpty) {
          return false;
        }
      } else {
        return false;
      }
    }

    return true;
  }

  /// Establish a DTLS handshake with the bridge.
  ///
  /// Returns `true` if the handshake was successful, `false` otherwise.
  ///
  /// The `bridge` parameter is the bridge to establish the handshake with.
  ///
  /// The `dtlsData` parameter is the DTLS data to establish the handshake with.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  static Future<bool> _establishDtlsHandshake({
    required Bridge bridge,
    required DtlsData dtlsData,
    String Function(String)? decrypter,
  }) async =>
      EntertainmentStreamService.establishDtlsHandshake(
        bridge: bridge,
        dtlsData: dtlsData,
        decrypter: decrypter,
      );

  static List<int> _getPacketBase(
    ColorMode colorMode,
    String entertainmentConfigurationId,
  ) {
    /// The first part of the packet.
    List<dynamic> part1 = [
      'H', 'u', 'e', 'S', 't', 'r', 'e', 'a', 'm', // Protocol

      0x02, 0x00, // Version 2.0

      0x00, // Sequence number 0

      0x00, 0x00, // Reserved write 0’s
    ];

    /// The value of the color mode.
    ///
    /// - 0x00 for RGB
    /// - 0x01 for XY
    final int colorModeValue = colorMode == ColorMode.xy ? 0x01 : 0x00;

    /// The second part of the packet.
    List<dynamic> part2 = [
      0x00, // Reserved, write 0’s

      entertainmentConfigurationId, // Entertainment configuration ID
    ];

    return [
      ...__listToBytes(part1),
      colorModeValue,
      ...__listToBytes(part2),
    ];
  }

  static List<int> __listToBytes(List<dynamic> list) {
    final List<int> toReturn = [];

    for (final dynamic item in list) {
      if (item is String) {
        toReturn.addAll(utf8.encode(item));
      } else if (item is int) {
        toReturn.add(item);
      } else if (item is num) {
        toReturn.add(item.toInt());
      }
    }

    return toReturn;
  }

  /// Creates a packet to send to the bridge, using XY+brightness color space
  /// encoding.
  ///
  /// The `entertainmentConfigurationId` parameter is the ID of the
  /// entertainment configuration to send the data to.
  ///
  /// The `channels` are the channels that are having their colors set, and what
  /// color they are being set to. Note, any channel that is using RGB instead
  /// of XY will be ignored.
  ///
  /// Returns a list of bytes representing the packet.
  static List<int> getDataAsXy(
    String entertainmentConfigurationId,
    List<EntertainmentStreamCommand> commands,
  ) {
    final List<int> packet =
        _getPacketBase(ColorMode.xy, entertainmentConfigurationId);

    // Add every command to the packet.
    int counter = 0;
    for (final EntertainmentStreamCommand command in commands) {
      // Skip any commands that are not using XY color space.
      if (command.color is! ColorXy) continue;

      // Only allow 20 commands per packet.
      if (counter >= 20) break;

      packet.add(command.channel);

      packet.addAll(
        _formatXy(
          (command.color as ColorXy).x,
          (command.color as ColorXy).y,
          (command.color as ColorXy).brightness,
        ),
      );

      counter++;
    }

    return packet;
  }

  /// Creates a packet to send to the bridge, using RGB color space encoding.
  ///
  /// The `entertainmentConfigurationId` parameter is the ID of the
  /// entertainment configuration to send the data to. Note, any channel that is
  /// using XY instead of RGB will be ignored.
  ///
  /// The `channels` are the channels that are having their colors set, and what
  /// color they are being set to.
  ///
  /// Returns a list of bytes representing the packet.
  static List<int> getDataAsRgb(
    String entertainmentConfigurationId,
    List<EntertainmentStreamCommand> commands,
  ) {
    final List<int> packet =
        _getPacketBase(ColorMode.rgb, entertainmentConfigurationId);

    // Add every command to the packet.
    int counter = 0;
    for (final EntertainmentStreamCommand command in commands) {
      // Skip any commands that are not using XY color space.
      if (command.color is! ColorRgb) continue;

      // Only allow 20 commands per packet.
      if (counter >= 20) break;

      packet.add(command.channel);

      packet.addAll(
        _formatRgb(
          (command.color as ColorRgb).r,
          (command.color as ColorRgb).g,
          (command.color as ColorRgb).b,
        ),
      );

      counter++;
    }

    return packet;
  }

  /// Sends the `packet` through the DTLS connection in `dtlsData`.
  ///
  /// Returns `true` if the data was send successfully; otherwise, false.
  static Future<bool> sendData(DtlsData dtlsData, List<int> packet) async {
    try {
      dtlsData.connection!.send(packet);
    } catch (e) {
      // Connection has been cut at this point.
      return false;
    }

    return true;
  }

  /// Formats the given `x`, `y`, and `brightness` values into a list of bytes.
  static List<int> _formatXy(double x, double y, double brightness) =>
      __colorToBytes(x, y, brightness);

  /// Formats the given `r`, `g`, and `b` values into a list of bytes.
  static List<int> _formatRgb(int r, int g, int b) =>
      __colorToBytes(r / 255.0, g / 255.0, b / 255.0);

  /// Formats the given `a`, `b`, and `c` values into a list of bytes.
  static List<int> __colorToBytes(num a, num b, num c) {
    int a16bit = (a * 65535).round().clamp(0, 65535);
    int b16bit = (b * 65535).round().clamp(0, 65535);
    int c16bit = (c * 65535).round().clamp(0, 65535);

    return [
      ...__int16BigEndianBytes(a16bit),
      ...__int16BigEndianBytes(b16bit),
      ...__int16BigEndianBytes(c16bit),
    ];
  }

  /// Returns a list of bytes representing the given `value` as a 16-bit big
  /// endian integer.
  static Uint8List __int16BigEndianBytes(int value) =>
      Uint8List(2)..buffer.asByteData().setInt16(0, value, Endian.big);
}
