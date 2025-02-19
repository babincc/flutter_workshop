import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/repos/hue_http_repo.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';

/// Hue HTTP repo requests made easy.
extension HttpRequests on Bridge {
  /// Fetch the given `resource` from this bridge.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// Will return `null` if:
  /// * The `resource` does not exist on this bridge
  /// * This bridge does not have an IP address
  /// * This bridge does not have an application key
  /// * Any other unforeseen error
  Future<Map<String, dynamic>?> get(
    Resource resource, {
    String Function(String ciphertext)? decrypter,
  }) async {
    if (ipAddress == null) return null;
    if (applicationKey == null) return null;

    try {
      return await HueHttpRepo.get(
        bridgeIpAddr: ipAddress!,
        pathToResource: resource.id,
        applicationKey: applicationKey!,
        resourceType: resource.type,
        decrypter: decrypter,
      );
    } catch (_) {
      return null;
    }
  }

  /// Fetch all resources of the given resource `type` from this bridge.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// Will return `null` if:
  /// * This bridge does not have an IP address
  /// * This bridge does not have an application key
  /// * Any other unforeseen error
  Future<List<Map<String, dynamic>>?> getResource(
    ResourceType type, {
    String Function(String ciphertext)? decrypter,
  }) async {
    if (ipAddress == null) return null;
    if (applicationKey == null) return null;

    try {
      final Map<String, dynamic>? result = await HueHttpRepo.get(
        bridgeIpAddr: ipAddress!,
        applicationKey: applicationKey!,
        resourceType: type,
        decrypter: decrypter,
      );

      if (result == null) return null;

      return MiscTools.extractDataList(result);
    } catch (_) {
      return null;
    }
  }

  /// Fetch the given `resource` from this bridge.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If the POST request is successful, then the original values in `resource`
  /// will be refreshed and set to their current values. To disable this
  /// behavior, set `refreshOriginals` to `false`.
  ///
  /// Will return `null` if:
  /// * The `resource` does not exist on this bridge
  /// * This bridge does not have an IP address
  /// * This bridge does not have an application key
  /// * The `resource` does not have any data to POST
  /// * Any other unforeseen error
  Future<Map<String, dynamic>?> post(
    Resource resource, {
    String Function(String ciphertext)? decrypter,
    bool refreshOriginals = true,
  }) async {
    if (ipAddress == null) return null;
    if (applicationKey == null) return null;

    final Map<String, dynamic> resourceJson =
        resource.toJson(optimizeFor: OptimizeFor.post);

    if (resourceJson.isEmpty) return null;

    String body = JsonTool.writeJson(resourceJson);

    try {
      Map<String, dynamic>? result = await HueHttpRepo.post(
        bridgeIpAddr: ipAddress!,
        pathToResource: resource.id,
        applicationKey: applicationKey!,
        resourceType: resource.type,
        body: body,
        decrypter: decrypter,
      );

      if (result == null) return null;

      if (result[ApiFields.errors] == null ||
          (result[ApiFields.errors] as List<dynamic>).isEmpty) {
        resource.refreshOriginals();
      }

      return result;
    } catch (_) {
      return null;
    }
  }

  /// Fetch the given `resource` from this bridge.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// If the PUT request is successful, then the original values in `resource`
  /// will be refreshed and set to their current values. To disable this
  /// behavior, set `refreshOriginals` to `false`.
  ///
  /// Will return `null` if:
  /// * The `resource` does not exist on this bridge
  /// * This bridge does not have an IP address
  /// * This bridge does not have an application key
  /// * The `resource` does not have any data to PUT
  /// * Any other unforeseen error
  Future<Map<String, dynamic>?> put(
    Resource resource, {
    String Function(String ciphertext)? decrypter,
    bool refreshOriginals = true,
  }) async {
    if (ipAddress == null) return null;
    if (applicationKey == null) return null;

    final Map<String, dynamic> resourceJson =
        resource.toJson(optimizeFor: OptimizeFor.put);

    if (resourceJson.isEmpty) return null;

    String body = JsonTool.writeJson(resourceJson);

    try {
      Map<String, dynamic>? result = await HueHttpRepo.put(
        bridgeIpAddr: ipAddress!,
        pathToResource: resource.id,
        applicationKey: applicationKey!,
        resourceType: resource.type,
        body: body,
        decrypter: decrypter,
      );

      if (result == null) return null;

      if (result[ApiFields.errors] == null ||
          (result[ApiFields.errors] as List<dynamic>).isEmpty) {
        resource.refreshOriginals();
      }

      return result;
    } catch (_) {
      return null;
    }
  }

  /// Fetch the given `resource` from this bridge.
  ///
  /// `decrypter` When the old tokens are read from local storage, they are
  /// decrypted. This parameter allows you to provide your own decryption
  /// method. This will be used in addition to the default decryption method.
  /// This will be performed after the default decryption method.
  ///
  /// Will return `null` if:
  /// * The `resource` does not exist on this bridge
  /// * This bridge does not have an IP address
  /// * This bridge does not have an application key
  /// * Any other unforeseen error
  Future<Map<String, dynamic>?> delete(
    Resource resource, {
    String Function(String ciphertext)? decrypter,
  }) async {
    if (ipAddress == null) return null;
    if (applicationKey == null) return null;

    try {
      return await HueHttpRepo.delete(
        bridgeIpAddr: ipAddress!,
        pathToResource: resource.id,
        applicationKey: applicationKey!,
        resourceType: resource.type,
        decrypter: decrypter,
      );
    } catch (_) {
      return null;
    }
  }
}
