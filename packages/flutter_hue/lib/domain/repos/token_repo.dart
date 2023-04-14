import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/repos/bridge_discovery_repo.dart';
import 'package:flutter_hue/domain/repos/local_storage_repo.dart';
import 'package:flutter_hue/domain/services/token_service.dart';
import 'package:flutter_hue/exceptions/expired_token_exception.dart';
import 'package:flutter_hue/utils/date_time_tool.dart';
import 'package:flutter_hue/utils/json_tool.dart';

class TokenRepo {
  /// The name of the file that stores the remote tokens and their data.
  static const String remoteTokenFile = "at_rt_and_data";

  /// This method fetches the token that grants temporary access to the bridge.
  ///
  /// This is step 2. Step 1 is [BridgeDiscoveryRepo.remoteAuthRequest].
  ///
  /// `clientId` Identifies the client that is making the request. The value
  /// passed in this parameter must exactly match the value you receive from
  /// hue.
  ///
  /// `clientSecret` The client secret you have received from Hue when
  /// registering for the Hue Remote API.
  ///
  /// `pkce` The code verifier that was generated in
  /// [BridgeDiscoveryRepo.remoteAuthRequest]. This is returned and captured
  /// from the deep link.
  ///
  /// `code` The code that was returned from the deep link. This is what is
  /// being traded for the token.
  ///
  /// `stateSecret` The state secret that was generated in
  /// [BridgeDiscoveryRepo.remoteAuthRequest]. This method can either take the
  /// full state value, or just the secret part.
  ///
  /// `encrypter` When the token is stored locally, it is encrypted. This
  /// parameter allows you to provide your own encryption method. This will be
  /// used in addition to the default encryption method. This will be performed
  /// before the default encryption method.
  ///
  /// `decrypter` When the state value is read from local storage, it is
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  static Future<void> fetchRemoteToken({
    required String clientId,
    required String clientSecret,
    required String pkce,
    required String code,
    required String stateSecret,
    String Function(String plaintext)? encrypter,
    String Function(String ciphertext)? decrypter,
  }) async {
    // Only use the secret part of the state.
    if (stateSecret.contains("-")) {
      stateSecret = stateSecret.substring(0, stateSecret.indexOf("-"));
    } else {
      stateSecret = stateSecret;
    }

    /// The state secret that is stored in local storage.
    String storedStateSecret;

    // Read the state secret from local storage.
    storedStateSecret = await LocalStorageRepo.read(
          folder: Folder.tmp,
          fileName: BridgeDiscoveryRepo.stateSecretFile,
          decrypter: decrypter,
        ) ??
        "";

    // If the state secret does not match, return.
    if (storedStateSecret != stateSecret) return;

    // Call the service.
    Map<String, dynamic>? res = await TokenService.fetchRemoteToken(
      clientId: clientId,
      clientSecret: clientSecret,
      pkce: pkce,
      code: code,
    );

    if (res == null) return;

    await _writeRemoteTokensToLocal(res, encrypter);
  }

  /// This method fetches the token that grants temporary access to the bridge.
  ///
  /// This is step 2. Step 1 is [BridgeDiscoveryRepo.remoteAuthRequest].
  ///
  /// `clientId` Identifies the client that is making the request. The value
  /// passed in this parameter must exactly match the value you receive from
  /// hue.
  ///
  /// `clientSecret` The client secret you have received from Hue when
  /// registering for the Hue Remote API.
  ///
  /// `encrypter` When the token is stored locally, it is encrypted. This
  /// parameter allows you to provide your own encryption method. This will be
  /// used in addition to the default encryption method. This will be performed
  /// before the default encryption method.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredRefreshTokenException] if the refresh token is expired.
  /// If this happens, get the user to grand access to the app again by using
  /// [BridgeDiscoveryRepo.remoteAuthRequest].
  static Future<void> refreshRemoteToken({
    required String clientId,
    required String clientSecret,
    String Function(String plaintext)? encrypter,
    String Function(String ciphertext)? decrypter,
  }) async {
    /// The state token data that is stored in local storage.
    String storedTokenDataStr;

    // Read the state secret from local storage.
    storedTokenDataStr = await LocalStorageRepo.read(
          folder: Folder.remoteTokens,
          fileName: remoteTokenFile,
          decrypter: decrypter,
        ) ??
        "";

    Map<String, dynamic> storedTokenData =
        JsonTool.readJson(storedTokenDataStr);

    String? oldRefreshToken = storedTokenData[ApiFields.refreshToken];

    if (oldRefreshToken == null) return;

    // Call the service.
    Map<String, dynamic>? res = await TokenService.refreshRemoteToken(
      clientId: clientId,
      clientSecret: clientSecret,
      refreshToken: oldRefreshToken,
    );

    if (res == null) return;

    await _writeRemoteTokensToLocal(res, encrypter);
  }

  /// This method writes the remote tokens to local storage.
  static Future<void> _writeRemoteTokensToLocal(
    Map<String, dynamic> res,
    String Function(String plaintext)? encrypter,
  ) async {
    String? accessToken = res[ApiFields.accessToken];
    int? expiresIn = res[ApiFields.expiresIn];
    String? refreshToken = res[ApiFields.refreshToken];
    String? tokenType = res[ApiFields.tokenType];

    if (accessToken == null ||
        expiresIn == null ||
        refreshToken == null ||
        tokenType == null) {
      return;
    }

    // Calculate the expiration date.
    DateTime expirationDate = DateTime.now().add(
      Duration(seconds: expiresIn),
    );

    // Add the expiration date to the map.
    res[ApiFields.expirationDate] = DateTimeTool.toHueString(expirationDate);

    // Write the tokens to local storage.
    await LocalStorageRepo.write(
      content: JsonTool.writeJson(res),
      folder: Folder.remoteTokens,
      fileName: remoteTokenFile,
      encrypter: encrypter,
    );
  }

  /// Returns a token for remote access.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If the token is not found, returns `null`.
  ///
  /// May throw [ExpiredAccessTokenException] if the token is expired. If this
  /// happens, refresh the token with [refreshRemoteToken].
  static Future<String?> fetchToken({
    String Function(String ciphertext)? decrypter,
  }) async {
    Map<String, dynamic>? storedTokenData =
        await fetchTokenData(decrypter: decrypter);

    if (storedTokenData == null) return null;

    String? token = storedTokenData[ApiFields.accessToken];
    String? expirationDateStr = storedTokenData[ApiFields.expirationDate];

    if (token == null || expirationDateStr == null) return null;

    DateTime? expirationDate = DateTime.tryParse(expirationDateStr);

    if (expirationDate == null) return null;

    // If the token is expired, throw an exception.
    if (DateTime.now().isAfter(expirationDate)) {
      throw const ExpiredAccessTokenException();
    }

    return token;
  }

  /// Returns a token for remote access.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If the token is not found, returns `null`.
  ///
  /// May throw [ExpiredAccessTokenException] if the token is expired. If this
  /// happens, refresh the token with [refreshRemoteToken].
  @Deprecated('Use fetchToken instead')
  static Future<String?> getToken({
    String Function(String ciphertext)? decrypter,
  }) async =>
      fetchToken(decrypter: decrypter);

  /// Returns a token for remote access along with its refresh token, expiration
  /// date, and type.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If the token is not found, returns `null`.
  static Future<Map<String, dynamic>?> fetchTokenData({
    String Function(String ciphertext)? decrypter,
  }) async {
    /// The state token data that is stored in local storage.
    String? storedTokenDataStr = await LocalStorageRepo.read(
      folder: Folder.remoteTokens,
      fileName: remoteTokenFile,
      decrypter: decrypter,
    );

    if (storedTokenDataStr == null) return null;

    return JsonTool.readJson(storedTokenDataStr);
  }
}
