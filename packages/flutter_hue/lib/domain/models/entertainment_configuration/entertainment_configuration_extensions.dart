import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/repos/entertainment_stream_repo.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Entertainment configuration streaming methods.
extension Streaming on EntertainmentConfiguration {
  /// Start streaming for `this` entertainment configuration.
  Future<bool> startStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async {
    final bool isStarted = await _startStreaming(bridge, decrypter: decrypter);

    if (!isStarted) return false;

    await EntertainmentStreamRepo.establishDtlsHandshake(bridge);

    return true;
  }

  /// Start streaming for `this` entertainment configuration.
  Future<bool> _startStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async {
    final String body = JsonTool.writeJson(
      {ApiFields.action: ApiFields.start},
    );

    return await _setStreamingState(bridge, decrypter, body);
  }

  /// Stop streaming for `this` entertainment configuration.
  Future<bool> stopStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async {
    return await _stopStreaming(bridge, decrypter: decrypter);

    // TODO
  }

  /// Stop streaming for `this` entertainment configuration.
  Future<bool> _stopStreaming(
    Bridge bridge, {
    String Function(String ciphertext)? decrypter,
  }) async {
    final String body = JsonTool.writeJson(
      {ApiFields.action: ApiFields.stop},
    );

    return await _setStreamingState(bridge, decrypter, body);
  }

  /// Set the streaming state for `this` entertainment configuration.
  Future<bool> _setStreamingState(
    Bridge bridge,
    String Function(String ciphertext)? decrypter,
    String body,
  ) async {
    if (bridge.ipAddress == null) return false;
    if (bridge.applicationKey == null) return false;

    final Map<String, dynamic>? result = await HueHttpRepo.put(
      bridgeIpAddr: bridge.ipAddress!,
      applicationKey: bridge.applicationKey!,
      resourceType: ResourceType.entertainmentConfiguration,
      pathToResource: id,
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
}
