import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/services/hue_http_client.dart';

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
  static String getTargetUrl({
    required String bridgeIpAddr,
    ResourceType? resourceType,
    String? pathToResource,
  }) {
    String resourceTypeStr = resourceType?.value ?? "";

    if (resourceTypeStr.isNotEmpty) {
      resourceTypeStr = "/$resourceTypeStr";
    }

    String subPath = pathToResource ?? "";

    if (subPath.isNotEmpty && !subPath.startsWith("/")) {
      subPath = "/$subPath";
    }

    return "https://$bridgeIpAddr/clip/v2/resource$resourceTypeStr$subPath";
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
  static Future<Map<String, dynamic>?> get({
    required String bridgeIpAddr,
    String? pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
  }) async =>
      await HueHttpClient.get(
        url: getTargetUrl(
          bridgeIpAddr: bridgeIpAddr,
          resourceType: resourceType,
          pathToResource: pathToResource,
        ),
        applicationKey: applicationKey,
      );

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
  static Future<Map<String, dynamic>?> post({
    required String bridgeIpAddr,
    String? pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
    required String body,
  }) async =>
      await HueHttpClient.post(
        url: getTargetUrl(
          bridgeIpAddr: bridgeIpAddr,
          resourceType: resourceType,
          pathToResource: pathToResource,
        ),
        applicationKey: applicationKey,
        body: body,
      );

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
  static Future<Map<String, dynamic>?> put({
    required String bridgeIpAddr,
    String? pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
    required String body,
  }) async =>
      await HueHttpClient.put(
        url: getTargetUrl(
          bridgeIpAddr: bridgeIpAddr,
          resourceType: resourceType,
          pathToResource: pathToResource,
        ),
        applicationKey: applicationKey,
        body: body,
      );

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
  static Future<Map<String, dynamic>?> delete({
    required String bridgeIpAddr,
    required String pathToResource,
    required String applicationKey,
    required ResourceType? resourceType,
  }) async =>
      await HueHttpClient.delete(
        url: getTargetUrl(
          bridgeIpAddr: bridgeIpAddr,
          resourceType: resourceType,
          pathToResource: pathToResource,
        ),
        applicationKey: applicationKey,
      );
}
