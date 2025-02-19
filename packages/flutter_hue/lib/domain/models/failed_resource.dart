import 'package:collection/collection.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/hue_network.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';

/// Represents a resource that failed to be fetched.
class FailedResource {
  /// Creates a new [FailedResource] instance.
  FailedResource({
    required this.type,
    required this.id,
    this.bridge,
    this.hueNetwork,
    required this.error,
    this.additionalInfo,
    this.json,
  });

  /// Creates an empty [FailedResource] object.
  FailedResource.empty()
      : type = ResourceType.device,
        id = '',
        bridge = null,
        hueNetwork = null,
        error = ErrorType.unknown,
        additionalInfo = null,
        json = null;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      identical(type, ResourceType.device) &&
      id.isEmpty &&
      bridge == null &&
      hueNetwork == null &&
      identical(error, ErrorType.unknown) &&
      additionalInfo == null &&
      json == null;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Type of the supported resource.
  final ResourceType type;

  /// Unique identifier representing a specific resource instance.
  ///
  /// Regex pattern `^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$`
  final String id;

  /// The bridge that this resource is associated with.
  final Bridge? bridge;

  /// The [HueNetwork] that this resource is associated with.
  final HueNetwork? hueNetwork;

  /// The error that occurred.
  ///
  /// Call [error.message] to get the error message.
  final ErrorType error;

  /// Additional information about the error.
  ///
  /// This is given if the bridge has something to say that isn't covered by the
  /// [error] field.
  final String? additionalInfo;

  /// The JSON data that was able to be fetched.
  final Map<String, dynamic>? json;

  /// Returns a copy of this object.
  FailedResource copy() => copyWith();

  /// Used in the [copyWith] method to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  ///
  /// Since [bridge], [hueNetwork], [additionalInfo], and [json] are nullable,
  /// they are defaulted to an empty object in this method. If left as empty
  /// objects, their current values in this [FailedResource] object will be
  /// used. This way, if they are `null`, the program will know that they are
  /// intentionally being set to `null`.
  FailedResource copyWith({
    ResourceType? type,
    String? id,
    Object? bridge = sentinelValue,
    Object? hueNetwork = sentinelValue,
    ErrorType? error,
    Object? additionalInfo = sentinelValue,
    Object? json = sentinelValue,
  }) {
    if (!identical(bridge, sentinelValue)) {
      assert(bridge is Bridge?, '`bridge` must be a `Bridge?` object');
    }
    if (!identical(hueNetwork, sentinelValue)) {
      assert(hueNetwork is HueNetwork?,
          '`hueNetwork` must be a `HueNetwork?` object');
    }
    if (!identical(additionalInfo, sentinelValue)) {
      assert(additionalInfo is String?, '`additionalInfo` must be a `String?`');
    }
    if (!identical(json, sentinelValue)) {
      assert(json is Map<String, dynamic>?,
          '`json` must be a `Map<String, dynamic>?` object');
    }

    return FailedResource(
      type: type ?? this.type,
      id: id ?? this.id,
      bridge: identical(bridge, sentinelValue)
          ? this.bridge?.copyWith()
          : bridge as Bridge?,
      hueNetwork: identical(hueNetwork, sentinelValue)
          ? this.hueNetwork
          : hueNetwork as HueNetwork?,
      error: error ?? this.error,
      additionalInfo: identical(additionalInfo, sentinelValue)
          ? this.additionalInfo
          : additionalInfo as String?,
      json: identical(json, sentinelValue)
          ? this.json == null
              ? null
              : Map<String, dynamic>.from(this.json!)
          : json as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is FailedResource &&
        identical(other.type, type) &&
        other.id == id &&
        other.bridge == bridge &&
        other.hueNetwork == hueNetwork &&
        identical(other.error, error) &&
        other.additionalInfo == additionalInfo &&
        const DeepCollectionEquality.unordered().equals(other.json, json);
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        bridge,
        hueNetwork,
        error,
        additionalInfo,
        const DeepCollectionEquality.unordered().hash(json),
      );

  @override
  String toString() => 'Instance of FailedResource:\n'
      '\ttype: ${type.value}\n'
      '\tid: $id\n'
      '\tbridgeId: ${bridge?.id ?? '[no_bridge]'}\n'
      '\terror: ${error.message}\n'
      '\tadditionalInfo: $additionalInfo\n'
      '\tjson: $json';
}

enum ErrorType {
  /// The resource was not found.
  notFound('None of the bridges that were searched had the resource.'),

  /// Failed to fetch any resource of the given type.
  typeNotFound(
      'Failed to fetch any resource of the given type from the given bridge.'),

  /// The data was corrupted or not in the expected format.
  dataCorrupted('The data was corrupted or not in the expected format.'),

  /// Something unexpected happened that has not been accounted for.
  unknown('An unknown error occurred.');

  const ErrorType(this.message);

  final String message;
}
