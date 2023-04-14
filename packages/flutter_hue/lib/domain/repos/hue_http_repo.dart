import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/repos/token_repo.dart';
import 'package:flutter_hue/domain/services/hue_http_client.dart';
import 'package:flutter_hue/exceptions/expired_token_exception.dart';

/// This is the way to communicate with Flutter Hue HTTP services.
class HueHttpRepo {
  /// Returns a properly formatted target URL.
  ///
  /// `bridgeIpAddr` is the IP address of the target bridge.
  ///
  /// The `resourceType` is used to let the bridge know what type of resource is
  /// being queried.
  ///
  /// If a specific resource is being queried, include `pathToResource`. This is
  /// most likely the resource's ID.
  ///
  /// If `isRemote` is `true`, the URL will be formatted for remote access.
  static String getTargetUrl({
    required String bridgeIpAddr,
    ResourceType? resourceType,
    String? pathToResource,
    bool isRemote = false,
  }) {
    String domain = isRemote ? "api.meethue.com/route" : bridgeIpAddr;

    String resourceTypeStr = resourceType?.value ?? "";

    if (resourceTypeStr.isNotEmpty) {
      resourceTypeStr = "/$resourceTypeStr";
    }

    String subPath = pathToResource ?? "";

    if (subPath.isNotEmpty && !subPath.startsWith("/")) {
      subPath = "/$subPath";
    }

    return "https://$domain/clip/v2/resource$resourceTypeStr$subPath";
  }

  /// Fetch an existing resource.
  ///
  /// `bridgeIpAddr` is the IP address of the target bridge.
  ///
  /// If a specific resource is being queried, include `pathToResource`. This is
  /// most likely the resource's ID.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// The `resourceType` is used to let the bridge know what type of resource is
  /// being queried.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  static Future<Map<String, dynamic>?> get({
    required String bridgeIpAddr,
    String? pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
    String Function(String ciphertext)? decrypter,
  }) async {
    return await HueHttpClient.get(
      url: getTargetUrl(
        bridgeIpAddr: bridgeIpAddr,
        resourceType: resourceType,
        pathToResource: pathToResource,
        isRemote: false,
      ),
      applicationKey: applicationKey,
      token: null,
    ).timeout(
      const Duration(seconds: 1),
      onTimeout: () async {
        String? token = await TokenRepo.getToken(decrypter: decrypter);

        return await HueHttpClient.get(
          url: getTargetUrl(
            bridgeIpAddr: bridgeIpAddr,
            resourceType: resourceType,
            pathToResource: pathToResource,
            isRemote: true,
          ),
          applicationKey: applicationKey,
          token: token,
        );
      },
    );
  }

  /// Create a new resource.
  ///
  /// `bridgeIpAddr` is the IP address of the target bridge.
  ///
  /// If a specific resource is being queried, include `pathToResource`. This is
  /// most likely the resource's ID.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// The `resourceType` is used to let the bridge know what type of resource is
  /// being queried.
  ///
  /// `body` is the actual content being sent to the bridge.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  static Future<Map<String, dynamic>?> post({
    required String bridgeIpAddr,
    String? pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
    required String body,
    String Function(String ciphertext)? decrypter,
  }) async {
    return await HueHttpClient.post(
      url: getTargetUrl(
        bridgeIpAddr: bridgeIpAddr,
        resourceType: resourceType,
        pathToResource: pathToResource,
        isRemote: false,
      ),
      applicationKey: applicationKey,
      token: null,
      body: body,
    ).timeout(
      const Duration(seconds: 1),
      onTimeout: () async {
        String? token = await TokenRepo.getToken(decrypter: decrypter);

        return await HueHttpClient.post(
          url: getTargetUrl(
            bridgeIpAddr: bridgeIpAddr,
            resourceType: resourceType,
            pathToResource: pathToResource,
            isRemote: true,
          ),
          applicationKey: applicationKey,
          token: token,
          body: body,
        );
      },
    );
  }

  /// Update an existing resource.
  ///
  /// `bridgeIpAddr` is the IP address of the target bridge.
  ///
  /// If a specific resource is being queried, include `pathToResource`. This is
  /// most likely the resource's ID.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// The `resourceType` is used to let the bridge know what type of resource is
  /// being queried.
  ///
  /// `body` is the actual content being sent to the bridge.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  static Future<Map<String, dynamic>?> put({
    required String bridgeIpAddr,
    String? pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
    required String body,
    String Function(String ciphertext)? decrypter,
  }) async {
    return await HueHttpClient.put(
      url: getTargetUrl(
        bridgeIpAddr: bridgeIpAddr,
        resourceType: resourceType,
        pathToResource: pathToResource,
        isRemote: false,
      ),
      applicationKey: applicationKey,
      token: null,
      body: body,
    ).timeout(
      const Duration(seconds: 1),
      onTimeout: () async {
        String? token = await TokenRepo.getToken(decrypter: decrypter);

        return await HueHttpClient.put(
          url: getTargetUrl(
            bridgeIpAddr: bridgeIpAddr,
            resourceType: resourceType,
            pathToResource: pathToResource,
            isRemote: true,
          ),
          applicationKey: applicationKey,
          token: token,
          body: body,
        );
      },
    );
  }

  /// Delete an existing resource.
  ///
  /// `bridgeIpAddr` is the IP address of the target bridge.
  ///
  /// If a specific resource is being queried, include `pathToResource`. This is
  /// most likely the resource's ID.
  ///
  /// `applicationKey` is the key associated with this devices in the bridge's
  /// whitelist.
  ///
  /// The `resourceType` is used to let the bridge know what type of resource is
  /// being queried.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// May throw [ExpiredAccessTokenException] if trying to connect to the bridge
  /// remotely and the token is expired. If this happens, refresh the token with
  /// [TokenRepo.refreshRemoteToken].
  static Future<Map<String, dynamic>?> delete({
    required String bridgeIpAddr,
    required String pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
    String Function(String ciphertext)? decrypter,
  }) async {
    return await HueHttpClient.delete(
      url: getTargetUrl(
        bridgeIpAddr: bridgeIpAddr,
        resourceType: resourceType,
        pathToResource: pathToResource,
        isRemote: false,
      ),
      applicationKey: applicationKey,
      token: null,
    ).timeout(
      const Duration(seconds: 1),
      onTimeout: () async {
        String? token = await TokenRepo.getToken(decrypter: decrypter);

        return await HueHttpClient.delete(
          url: getTargetUrl(
            bridgeIpAddr: bridgeIpAddr,
            resourceType: resourceType,
            pathToResource: pathToResource,
            isRemote: true,
          ),
          applicationKey: applicationKey,
          token: token,
        );
      },
    );
  }
}
