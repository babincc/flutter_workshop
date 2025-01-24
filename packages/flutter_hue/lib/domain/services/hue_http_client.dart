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
    required String? token,
  }) async =>
      await _submitRequestForBody(
        url: url,
        applicationKey: applicationKey,
        token: token,
        body: null,
        requestType: _RequestType.get,
      );

  /// Fetch the headers of a resource call.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  static Future<Map<String, String>?> getHeaders({
    required String url,
    required String applicationKey,
    required String? token,
  }) async =>
      await _submitRequestForHeaders(
        url: url,
        applicationKey: applicationKey,
        token: token,
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
    required String? token,
    required String body,
  }) async =>
      await _submitRequestForBody(
        url: url,
        applicationKey: applicationKey,
        token: token,
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
    required String? token,
    required String body,
  }) async =>
      await _submitRequestForBody(
        url: url,
        applicationKey: applicationKey,
        token: token,
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
    required String? token,
  }) async =>
      await _submitRequestForBody(
        url: url,
        applicationKey: applicationKey,
        token: token,
        body: null,
        requestType: _RequestType.delete,
      );

  /// HTTP request logic that focuses on the body of the message.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// `body` is the actual content being sent to the bridge.
  ///
  /// `requestType` the type of HTTP request being made.
  static Future<Map<String, dynamic>?> _submitRequestForBody({
    required String url,
    required String? applicationKey,
    required String? token,
    required String? body,
    required _RequestType requestType,
  }) async {
    final Response response = await _submitRequest(
      url: url,
      applicationKey: applicationKey,
      token: token,
      body: body,
      requestType: requestType,
    );

    final List<Map<String, dynamic>> responseArr =
        JsonTool.readJsonOr(response.body) ?? [];

    if (responseArr.isEmpty) return null;

    return responseArr.first;
  }

  /// HTTP request logic that focuses on the headers of the message.
  ///
  /// `url` is the target.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// `body` is the actual content being sent to the bridge.
  ///
  /// `requestType` the type of HTTP request being made.
  static Future<Map<String, String>?> _submitRequestForHeaders({
    required String url,
    required String? applicationKey,
    required String? token,
    required String? body,
    required _RequestType requestType,
  }) async {
    final Response response = await _submitRequest(
      url: url,
      applicationKey: applicationKey,
      token: token,
      body: body,
      requestType: requestType,
    );

    if (response.headers.isEmpty) return null;

    return response.headers;
  }

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
  static Future<Response> _submitRequest({
    required String url,
    required String? applicationKey,
    required String? token,
    required String? body,
    required _RequestType requestType,
  }) async {
    final _HuePacket huePacket = _HuePacket(
      type: requestType,
      url: url,
      appKey: applicationKey,
      token: token,
    );

    switch (requestType) {
      case _RequestType.post:
        return await client.post(huePacket.uri,
            headers: huePacket.headers, body: body);
      case _RequestType.put:
        return await client.put(huePacket.uri,
            headers: huePacket.headers, body: body);
      case _RequestType.delete:
        return await client.delete(huePacket.uri, headers: huePacket.headers);
      case _RequestType.get:
        return await client.get(huePacket.uri, headers: huePacket.headers);
    }
  }
}

/// Data sent in all HTTP requests.
///
/// It is included in its own class to reduce boilerplate.
class _HuePacket {
  const _HuePacket({
    required this.type,
    required this.url,
    required this.appKey,
    required this.token,
  });

  final _RequestType type;
  final String url;
  final String? appKey;
  final String? token;

  Uri get uri => Uri.parse(url);
  Map<String, String>? get headers {
    Map<String, String> toReturn = {};

    if (token != null) {
      toReturn["Authorization"] = "Bearer ${token!}";
    }

    if (appKey != null) {
      toReturn["hue-application-key"] = appKey!;
    }

    if (identical(type, _RequestType.put) ||
        identical(type, _RequestType.post)) {
      toReturn["Content-Type"] = "application/json";
    }

    if (toReturn.isEmpty) return null;

    return toReturn;
  }
}

/// The type of HTTP request being made.
enum _RequestType {
  get,
  post,
  put,
  delete,
}
