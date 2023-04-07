import 'dart:io';

import 'package:flutter_hue/utils/json_tool.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

/// The Flutter Hue HTTP services.
///
/// It is advised that you use [HueHttpRepo] instead of this class.
class HueHttpClient {
  /// The HTTP client that is used to talk to the Philips Hue bridge.
  static final client = IOClient(HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) =>
        cert.issuer.contains("Philips Hue") ||
        cert.issuer.contains("root-bridge"));

  /// Fetch an existing resource.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  static Future<Map<String, dynamic>?> get({
    required String url,
    required String applicationKey,
  }) async =>
      _submitRequest(
        url: url,
        applicationKey: applicationKey,
        body: null,
        requestType: _RequestType.get,
      );

  /// Create a new resource.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// `body` is the actual content being sent to the bridge.
  static Future<Map<String, dynamic>?> post({
    required String url,
    required String? applicationKey,
    required String body,
  }) async =>
      _submitRequest(
        url: url,
        applicationKey: applicationKey,
        body: body,
        requestType: _RequestType.post,
      );

  /// Update an existing resource.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// `body` is the actual content being sent to the bridge.
  static Future<Map<String, dynamic>?> put({
    required String url,
    required String applicationKey,
    required String body,
  }) async =>
      _submitRequest(
        url: url,
        applicationKey: applicationKey,
        body: body,
        requestType: _RequestType.put,
      );

  /// Delete an existing resource.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  static Future<Map<String, dynamic>?> delete({
    required String url,
    required String applicationKey,
  }) async =>
      _submitRequest(
        url: url,
        applicationKey: applicationKey,
        body: null,
        requestType: _RequestType.delete,
      );

  /// Actual logic for HTTP request.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// `body` is the actual content being sent to the bridge.
  ///
  /// `requestType` the type of HTTP request being made.
  static Future<Map<String, dynamic>?> _submitRequest({
    required String url,
    required String? applicationKey,
    required String? body,
    required _RequestType requestType,
  }) async {
    _HuePacket huePacket = _HuePacket(url: url, appKey: applicationKey);

    Response response;
    switch (requestType) {
      case _RequestType.post:
        response = await client.post(huePacket.uri,
            headers: huePacket.headers, body: body);
        break;
      case _RequestType.put:
        response = await client.put(huePacket.uri,
            headers: huePacket.headers, body: body);
        break;
      case _RequestType.delete:
        response =
            await client.delete(huePacket.uri, headers: huePacket.headers);
        break;
      case _RequestType.get:
      default:
        response = await client.get(huePacket.uri, headers: huePacket.headers);
    }

    List<Map<String, dynamic>> responseArr =
        JsonTool.readJsonOr(response.body) ?? [];

    if (responseArr.isEmpty) return null;

    return responseArr.first;
  }
}

/// Data sent in all HTTP requests.
///
/// It is included in its own class to reduce boilerplate.
class _HuePacket {
  const _HuePacket({
    required this.url,
    required this.appKey,
  });

  final String url;
  final String? appKey;

  Uri get uri => Uri.parse(url);
  Map<String, String>? get headers => appKey == null
      ? null
      : {
          "hue-application-key": appKey!,
        };
}

/// The type of HTTP request being made.
enum _RequestType {
  get,
  post,
  put,
  delete,
}
