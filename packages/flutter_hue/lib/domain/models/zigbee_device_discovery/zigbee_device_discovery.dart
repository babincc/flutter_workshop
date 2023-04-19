// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/domain/models/zigbee_device_discovery/zigbee_device_discovery_action.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents zigbee device discover settings.
class ZigbeeDeviceDiscovery extends Resource {
  /// Creates a [ZigbeeDeviceDiscovery] object.
  ZigbeeDeviceDiscovery({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.status,
    this.action,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        _originalAction = action?.copyWith();

  /// Creates a [ZigbeeDeviceDiscovery] object from the JSON response to a GET
  /// request.
  factory ZigbeeDeviceDiscovery.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return ZigbeeDeviceDiscovery(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      status: data[ApiFields.status] ?? "",
      action: data[ApiFields.action] == null
          ? null
          : ZigbeeDeviceDiscoveryAction.fromJson(
              Map<String, dynamic>.from(data[ApiFields.action])),
    );
  }

  /// Creates an empty [ZigbeeDeviceDiscovery] object.
  ZigbeeDeviceDiscovery.empty()
      : idV1 = "",
        owner = Relative.empty(),
        status = "",
        action = null,
        _originalAction = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Owner of the service, in case the owner service is deleted, the service
  /// also gets deleted
  final Relative owner;

  /// Returns a [Resource] object that represents the [owner] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// [owner] cannot be found on the [hueNetwork], or if the [owner]'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource get ownerAsResource => getRelativeAsResource(owner);

  /// Describes this device's status on the network.
  ///
  /// * active
  /// * ready
  final String status;

  /// Action being performed in this discovery.
  ZigbeeDeviceDiscoveryAction? action;

  /// The value of [action] when this object was instantiated.
  ZigbeeDeviceDiscoveryAction? _originalAction;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    action?.refreshOriginals();
    _originalAction = action?.copyWith();
    super.refreshOriginals();
  }

  /// Used in the [copyWith] method to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [action] is nullable, it is defaulted to an empty object in this
  /// method. If left as an empty object, its current value in this
  /// [ZigbeeDeviceDiscovery] object will be used. This way, if it is `null`,
  /// the program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ZigbeeDeviceDiscovery copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    String? status,
    Object? action = sentinelValue,
    bool copyOriginalValues = true,
  }) {
    if (!identical(action, sentinelValue)) {
      assert(action is ZigbeeDeviceDiscoveryAction?,
          "`action` must be a `ZigbeeDeviceDiscoveryAction?` object");
    }

    ZigbeeDeviceDiscovery toReturn = ZigbeeDeviceDiscovery(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      status: status ?? this.status,
      action: copyOriginalValues
          ? _originalAction?.copyWith(copyOriginalValues: copyOriginalValues)
          : (identical(action, sentinelValue)
              ? this.action?.copyWith(copyOriginalValues: copyOriginalValues)
              : action as ZigbeeDeviceDiscoveryAction?),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.action = identical(action, sentinelValue)
          ? this.action?.copyWith(copyOriginalValues: copyOriginalValues)
          : action as ZigbeeDeviceDiscoveryAction?;
    }

    return toReturn;
  }

  /// Converts this object into JSON format.
  ///
  /// `optimizeFor` lets the program know what information to include in the
  /// JSON data map.
  /// * [OptimizeFor.put] (the default value) is used when making a data map
  /// that is being placed in a PUT request. This only includes data that has
  /// changed.
  /// * [OptimizeFor.putFull] is used when a parent object updates; so, all of
  /// the children are required to be present for the PUT request.
  /// * [OptimizeFor.post] is used when making a data map for a POST request.
  /// * [OptimizeFor.dontOptimize] is used to get all of the data contained in
  /// this object.
  ///
  /// Throws [InvalidIdException] if [owner.id] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (!identical(type, originalType)) {
        toReturn[ApiFields.type] = type.value;
      }

      if (action != _originalAction) {
        toReturn[ApiFields.action] =
            action?.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.action: action?.toJson(optimizeFor: optimizeFor),
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.status: status,
      ApiFields.action: action?.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ZigbeeDeviceDiscovery &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.status == status &&
        other.action == action;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        status,
        action,
      );

  @override
  String toString() =>
      "Instance of 'ZigbeeDeviceDiscovery' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
