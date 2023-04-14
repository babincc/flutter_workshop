import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_hue/exceptions/expired_token_exception.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:http/http.dart';

/// This class is used to fetch and refresh the remote token that allows the
/// user to connect to the bridge remotely.
///
/// It is advised that you use [TokenRepo] instead of this class.
class TokenService {
  /// Fetches the remote token that allows the user to connect to the bridge
  /// remotely.
  ///
  /// This is step 2. Step 1 is [BridgeDiscoveryService.remoteAuthRequest].
  static Future<Map<String, dynamic>?> fetchRemoteToken({
    required String clientId,
    required String clientSecret,
    required String pkce,
    required String code,
  }) async {
    final Map<String, String> body = {
      "grant_type": "authorization_code",
      "code": code,
      "code_verifier": pkce,
    };

    return _fetchRemoteToken(
      clientId: clientId,
      clientSecret: clientSecret,
      body: body,
    );
  }

  /// Refreshes the remote token that allows the user to connect to the bridge
  /// remotely.
  ///
  /// May throw [ExpiredRefreshTokenException] if the refresh token is expired.
  /// If this happens, get the user to grand access to the app again by using
  /// [BridgeDiscoveryRepo.remoteAuthRequest].
  static Future<Map<String, dynamic>?> refreshRemoteToken({
    required String clientId,
    required String clientSecret,
    required String refreshToken,
  }) async {
    final Map<String, String> body = {
      "grant_type": "refresh_token",
      "refresh_token": refreshToken,
    };

    return _fetchRemoteToken(
      clientId: clientId,
      clientSecret: clientSecret,
      body: body,
    );
  }

  /// Eliminates boilerplate code for [fetchRemoteToken] and
  /// [refreshRemoteToken].
  ///
  /// May throw [ExpiredRefreshTokenException] if the refresh token is expired.
  /// If this happens, get the user to grand access to the app again by using
  /// [BridgeDiscoveryRepo.remoteAuthRequest].
  static Future<Map<String, dynamic>?> _fetchRemoteToken({
    required String clientId,
    required String clientSecret,
    required Map<String, String> body,
  }) async {
    final Client client = Client();

    const String uri = "https://api.meethue.com/v2/oauth2/token";

    // Generate a single use number.
    int nonceNum = DateTime.now().millisecondsSinceEpoch;
    nonceNum = (nonceNum / 2).floor();
    nonceNum = nonceNum *
        (pow(MiscTools.randInt(50, 200), MiscTools.randInt(1, 3)) as int);
    nonceNum = (nonceNum / 3).ceil();
    final String nonce = nonceNum.toString();

    // Calculate digest response.
    final String hash1 = md5
        .convert(utf8
            .encode("$clientId:oauth2_client@api.meethue.com:$clientSecret"))
        .toString();
    final String hash2 =
        md5.convert(utf8.encode('POST:/v2/oauth2/token')).toString();
    final String response =
        md5.convert(utf8.encode('$hash1:$nonce:$hash2')).toString();

    final Map<String, String> headers = {
      "Authorization":
          'Digest username="$clientId", realm="oauth2_client@api.meethue.com", nonce="$nonce", uri="/v2/oauth2/token", response="$response"',
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final Response res = await client.post(
      Uri.parse(uri),
      headers: headers,
      body: body,
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }

    // In the event that the refresh token is expired, throw an exception.
    if (body.containsKey("refresh_token")) {
      if (res.statusCode == 400 && res.statusCode == 401) {
        throw const ExpiredRefreshTokenException();
      }
    }

    return null;
  }
}
