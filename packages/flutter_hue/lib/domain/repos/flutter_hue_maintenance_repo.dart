import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/repos/bridge_discovery_repo.dart';
import 'package:flutter_hue/domain/repos/token_repo.dart';
import 'package:flutter_hue/exceptions/corrupt_token_data_exception.dart';
import 'package:flutter_hue/exceptions/reauth_required_exception.dart';

class FlutterHueMaintenanceRepo {
  /// This is the general method to maintain all of the data that is stored
  /// locally.
  ///
  /// `clientId` Identifies the client that is making the request. The value
  /// passed in this parameter must exactly match the value you receive from
  /// hue.
  ///
  /// `clientSecret` The client secret you have received from Hue when
  /// registering for the Hue Remote API.
  ///
  /// `redirectUri` This parameter must exactly match the one configured in your
  /// hue developer account.
  ///
  /// `deviceName` The device name should be the name of the app or device
  /// accessing the remote API. The `deviceName` is used in the user’s “My Apps”
  /// overview in the Hue Account (visualized as: “[appName] on [deviceName]”).
  ///
  /// `state` Provides any state that might be useful to your application upon
  /// receipt of the response. The Hue Authorization Server round-trips this
  /// parameter, so your application receives the same value it sent. To
  /// mitigate against cross-site request forgery (CSRF), a long (30+ digit),
  /// random number is prepended to `state`. When the response is received from
  /// Hue, it is recommended that you compare the string returned from this
  /// method, to the one that is returned from Hue.
  ///
  /// `savedBridgesDir` The directory where the bridge data will be saved. If
  /// this is not provided, the default directory will be used.
  ///
  /// `stateEncrypter` When the state value is stored locally, it is encrypted.
  /// This parameter allows you to provide your own encryption method. This will
  /// be used in addition to the default encryption method. This will be
  /// performed before the default encryption method.
  ///
  /// `tokenEncrypter` When the token is stored locally, it is encrypted. This
  /// parameter allows you to provide your own encryption method. This will be
  /// used in addition to the default encryption method. This will be performed
  /// before the default encryption method.
  ///
  /// `tokenDecrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// `bridgeDecrypter` When the bridge data is read from local storage, it is
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// `reAuthOnFail` If this is set to true, then if the token is expired, then
  /// the user will be re-authenticated. If this is set to false, then the
  /// [ReauthRequiredException] will be thrown.
  static Future<void> maintain({
    required String clientId,
    required String clientSecret,
    required String redirectUri,
    String? deviceName,
    String? state,
    Directory? savedBridgesDir,
    String Function(String plaintext)? stateEncrypter,
    String Function(String plaintext)? tokenEncrypter,
    String Function(String ciphertext)? tokenDecrypter,
    String Function(String ciphertext)? bridgeDecrypter,
    bool reAuthOnFail = true,
  }) async {
    await maintainToken(
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUri: redirectUri,
      deviceName: deviceName,
      state: state,
      stateEncrypter: stateEncrypter,
      tokenEncrypter: tokenEncrypter,
      tokenDecrypter: tokenDecrypter,
      reAuthOnFail: reAuthOnFail,
    );

    await maintainBridges(
      savedBridgesDir: savedBridgesDir,
      decrypter: bridgeDecrypter,
    );
  }

  /// This method maintains the token that is stored locally.
  ///
  /// `clientId` Identifies the client that is making the request. The value
  /// passed in this parameter must exactly match the value you receive from
  /// hue.
  ///
  /// `clientSecret` The client secret you have received from Hue when
  /// registering for the Hue Remote API.
  ///
  /// `redirectUri` This parameter must exactly match the one configured in your
  /// hue developer account.
  ///
  /// `deviceName` The device name should be the name of the app or device
  /// accessing the remote API. The `deviceName` is used in the user’s “My Apps”
  /// overview in the Hue Account (visualized as: “[appName] on [deviceName]”).
  ///
  /// `state` Provides any state that might be useful to your application upon
  /// receipt of the response. The Hue Authorization Server round-trips this
  /// parameter, so your application receives the same value it sent. To
  /// mitigate against cross-site request forgery (CSRF), a long (30+ digit),
  /// random number is prepended to `state`. When the response is received from
  /// Hue, it is recommended that you compare the string returned from this
  /// method, to the one that is returned from Hue.
  ///
  /// `tokenEncrypter` When the token is stored locally, it is encrypted. This
  /// parameter allows you to provide your own encryption method. This will be
  /// used in addition to the default encryption method. This will be performed
  /// before the default encryption method.
  ///
  /// `stateEncrypter` When the state value is stored locally, it is encrypted.
  /// This parameter allows you to provide your own encryption method. This will
  /// be used in addition to the default encryption method. This will be
  /// performed before the default encryption method.
  ///
  /// `tokenDecrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// `reAuthOnFail` If this is set to true, then if the token is expired, then
  /// the user will be re-authenticated. If this is set to false, then the
  /// [ReauthRequiredException] will be thrown.
  static Future<void> maintainToken({
    required String clientId,
    required String clientSecret,
    required String redirectUri,
    String? deviceName,
    String? state,
    String Function(String plaintext)? stateEncrypter,
    String Function(String plaintext)? tokenEncrypter,
    String Function(String ciphertext)? tokenDecrypter,
    bool reAuthOnFail = true,
  }) async {
    Map<String, dynamic>? tokenData =
        await TokenRepo.fetchTokenData(decrypter: tokenDecrypter);

    if (tokenData == null) return;

    String? token = tokenData[ApiFields.accessToken];
    String? expirationDateStr = tokenData[ApiFields.expirationDate];
    String? refreshToken = tokenData[ApiFields.refreshToken];

    DateTime? expirationDate = DateTime.tryParse(expirationDateStr ?? "");

    try {
      if (token == null ||
          expirationDate == null ||
          expirationDate.difference(DateTime.now()).inDays <= 1) {
        await _refreshToken(
          refreshToken: refreshToken,
          clientId: clientId,
          clientSecret: clientSecret,
          encrypter: tokenEncrypter,
          decrypter: tokenDecrypter,
        );
      }
    } catch (_) {
      if (reAuthOnFail) {
        await BridgeDiscoveryRepo.remoteAuthRequest(
          clientId: clientId,
          redirectUri: redirectUri,
          deviceName: deviceName,
          state: state,
          encrypter: stateEncrypter,
        );
      } else {
        throw const ReauthRequiredException();
      }
    }
  }

  /// Attempt to refresh the token.
  ///
  /// This could fail, resulting in [CorruptTokenDataException] or
  /// [ExpiredRefreshTokenException].
  static Future<void> _refreshToken({
    String? refreshToken,
    required String clientId,
    required String clientSecret,
    String Function(String plaintext)? encrypter,
    String Function(String ciphertext)? decrypter,
  }) async {
    if (refreshToken == null) {
      throw const CorruptTokenDataException(
          "${ApiFields.refreshToken} is null}");
    }

    await TokenRepo.refreshRemoteToken(
      clientId: clientId,
      clientSecret: clientSecret,
      encrypter: encrypter,
      decrypter: decrypter,
    );
  }

  /// This method maintains the bridges that are stored locally.
  ///
  /// If the IP addresses where to change, then the locally saved bridges would
  /// be updated.
  ///
  /// `savedBridgesDir` The directory where the bridge data will be saved. If
  /// this is not provided, the default directory will be used.
  ///
  /// `decrypter` When the bridge data is read from local storage, it is
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  static Future<void> maintainBridges({
    Directory? savedBridgesDir,
    String Function(String ciphertext)? decrypter,
  }) async {
    /// The bridges already saved to this device.
    List<Bridge> savedBridges;

    if (kIsWeb) {
      // cookies instead of local storage (not yet implemented)
      savedBridges = [];
    } else {
      savedBridges = await BridgeDiscoveryRepo.fetchSavedBridges(
        decrypter: decrypter,
        directory: savedBridgesDir,
      );
    }

    // All of the ip addresses that are saved locally.
    List<String> ipAddresses = savedBridges
        .where((bridge) => bridge.ipAddress != null)
        .map((bridge) => bridge.ipAddress!)
        .toList();

    for (String ip in ipAddresses) {
      // This will go through each of the bridges who's IP address have just
      // been collected and tries to connect to them. If there is a successful
      // connection, then this isn't the first time contact has been made with
      // the bridge. In this case, the file will be overridden with the new IP
      // address.
      await BridgeDiscoveryRepo.firstContact(
        bridgeIpAddr: ip,
        savedBridgesDir: savedBridgesDir,
        controller: DiscoveryTimeoutController(timeoutSeconds: 1),
      );
    }
  }
}
