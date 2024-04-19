import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/dtls_data.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';
import 'package:flutter_hue/domain/services/entertainment_stream_service.dart';
import 'package:flutter_hue/utils/color_converter.dart';
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
    _ColorMode colorMode,
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
    final int colorModeValue = colorMode == _ColorMode.xy ? 0x01 : 0x00;

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
  /// The `channel0` through `channel19` parameters are the channels that are
  /// having their colors set. If a channel is `null`, it will be skipped.
  ///
  /// Returns a list of bytes representing the packet.
  static List<int> getDataAsXy(
    String entertainmentConfigurationId, {
    ColorXy? channel0,
    ColorXy? channel1,
    ColorXy? channel2,
    ColorXy? channel3,
    ColorXy? channel4,
    ColorXy? channel5,
    ColorXy? channel6,
    ColorXy? channel7,
    ColorXy? channel8,
    ColorXy? channel9,
    ColorXy? channel10,
    ColorXy? channel11,
    ColorXy? channel12,
    ColorXy? channel13,
    ColorXy? channel14,
    ColorXy? channel15,
    ColorXy? channel16,
    ColorXy? channel17,
    ColorXy? channel18,
    ColorXy? channel19,
  }) {
    List<ColorXy?> channels = [
      channel0,
      channel1,
      channel2,
      channel3,
      channel4,
      channel5,
      channel6,
      channel7,
      channel8,
      channel9,
      channel10,
      channel11,
      channel12,
      channel13,
      channel14,
      channel15,
      channel16,
      channel17,
      channel18,
      channel19,
    ];

    final List<int> packet =
        _getPacketBase(_ColorMode.xy, entertainmentConfigurationId);

    for (int i = 0; i < channels.length; i++) {
      if (channels[i] == null) continue;

      packet.add(i);

      packet.addAll(
        _formatXy(
          channels[i]!.x,
          channels[i]!.y,
          channels[i]!.brightness,
        ),
      );
    }

    return packet;
  }

  /// Creates a packet to send to the bridge, using RGB color space encoding.
  ///
  /// The `entertainmentConfigurationId` parameter is the ID of the
  /// entertainment configuration to send the data to.
  ///
  /// The `channel0` through `channel19` parameters are the channels that are
  /// having their colors set. If a channel is `null`, it will be skipped.
  ///
  /// Returns a list of bytes representing the packet.
  static List<int> getDataAsRgb(
    DtlsData dtlsData,
    String entertainmentConfigurationId, {
    ColorRgb? channel0,
    ColorRgb? channel1,
    ColorRgb? channel2,
    ColorRgb? channel3,
    ColorRgb? channel4,
    ColorRgb? channel5,
    ColorRgb? channel6,
    ColorRgb? channel7,
    ColorRgb? channel8,
    ColorRgb? channel9,
    ColorRgb? channel10,
    ColorRgb? channel11,
    ColorRgb? channel12,
    ColorRgb? channel13,
    ColorRgb? channel14,
    ColorRgb? channel15,
    ColorRgb? channel16,
    ColorRgb? channel17,
    ColorRgb? channel18,
    ColorRgb? channel19,
  }) {
    List<ColorRgb?> channels = [
      channel0,
      channel1,
      channel2,
      channel3,
      channel4,
      channel5,
      channel6,
      channel7,
      channel8,
      channel9,
      channel10,
      channel11,
      channel12,
      channel13,
      channel14,
      channel15,
      channel16,
      channel17,
      channel18,
      channel19,
    ];

    final List<int> packet =
        _getPacketBase(_ColorMode.rgb, entertainmentConfigurationId);

    for (int i = 0; i < channels.length; i++) {
      if (channels[i] == null) continue;

      packet.add(i);

      packet.addAll(
        _formatRgb(
          channels[i]!.r,
          channels[i]!.g,
          channels[i]!.b,
        ),
      );
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
  static List<int> _formatRgb(int r, int g, int b) => __colorToBytes(r, g, b);

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

/// A class representing a color in the CIE 1931 color space.
class ColorXy {
  const ColorXy(this.x, this.y, this.brightness)
      : assert(
          x >= 0.0 && x <= 1.0,
          'x must be greater than or equal to 0 and less than or equal to 1',
        ),
        assert(
          y >= 0.0 && y <= 1.0,
          'y must be greater than or equal to 0 and less than or equal to 1',
        ),
        assert(
          brightness >= 0.0 && brightness <= 1.0,
          'brightness must be greater than or equal to 0 and less than or '
          'equal to 1',
        );

  /// Creates a new [ColorXy] instance from the given `r`, `g`, and `b` values.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to the calculated brightness of the color. Note,
  /// this is typically a bit dim.
  factory ColorXy.fromRgb(int r, int g, int b, [double? brightness]) {
    if (brightness != null) {
      assert(
        brightness >= 0.0 && brightness <= 1.0,
        'brightness must be greater than or equal to 0 and less than or equal '
        'to 1',
      );
    }

    final List<double> xyList = ColorConverter.rgb2xy(r, g, b);

    return ColorXy(xyList[0], xyList[1], brightness ?? xyList[2]);
  }

  /// The x value of the color.
  final double x;

  /// The y value of the color.
  final double y;

  /// The brightness of the color.
  final double brightness;

  /// Converts this color to an RGB color.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to the [brightness] of this XY color.
  ColorRgb toRgb([double? brightness]) =>
      ColorRgb.fromXy(x, y, brightness ?? this.brightness);
}

/// A class representing a color in the RGB color space.
class ColorRgb {
  const ColorRgb(this.r, this.g, this.b)
      : assert(
          r >= 0 && r <= 255,
          'r must be greater than or equal to 0 and less than or equal to 255',
        ),
        assert(
          g >= 0 && g <= 255,
          'g must be greater than or equal to 0 and less than or equal to 255',
        ),
        assert(
          b >= 0 && b <= 255,
          'b must be greater than or equal to 0 and less than or equal to 255',
        );

  /// Creates a new [ColorRgb] instance from the given `x` and `y` values.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to `1.0`.
  factory ColorRgb.fromXy(double x, double y, [double? brightness]) {
    if (brightness != null) {
      assert(
        brightness >= 0.0 && brightness <= 1.0,
        'brightness must be greater than or equal to 0 and less than or equal '
        'to 1',
      );
    }

    final List<int> rgbList = ColorConverter.xy2rgb(x, y, brightness ?? 1.0);

    return ColorRgb(rgbList[0], rgbList[1], rgbList[2]);
  }

  /// The red value of the color.
  final int r;

  /// The green value of the color.
  final int g;

  /// The blue value of the color.
  final int b;

  /// Converts this color to an XY color.
  ///
  /// The `brightness` parameter is the brightness of the color. If not
  /// provided, it defaults to the calculated brightness of the color. Note,
  /// this is typically a bit dim.
  ColorXy toXy([double? brightness]) => ColorXy.fromRgb(r, g, b, brightness);
}

/// An enum representing the color mode of the entertainment stream.
enum _ColorMode {
  /// The color mode is XY and uses the CIE 1931 color space.
  xy,

  /// The color mode is RGB and uses the RGB color space.
  rgb,
}
