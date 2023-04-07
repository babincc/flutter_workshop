// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/device_power/device_power_power_state.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a Philips Hue device's power level.
class DevicePower extends Resource {
  /// Creates a [DevicePower] object.
  DevicePower({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.powerState,
  }) : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`');

  /// Creates a [DevicePower] object from the JSON response to a GET request.
  factory DevicePower.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return DevicePower(
        type: ResourceType.fromString(data[ApiFields.type] ?? ""),
        id: data[ApiFields.id] ?? "",
        idV1: data[ApiFields.idV1] ?? "",
        owner: Relative.fromJson(
            Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
        powerState: DevicePowerPowerState.fromJson(
            Map<String, dynamic>.from(data[ApiFields.powerState] ?? {})));
  }

  /// Creates an empty [DevicePower] object.
  DevicePower.empty()
      : idV1 = "",
        owner = Relative.empty(),
        powerState = DevicePowerPowerState.empty(),
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

  /// The power state of this device.
  ///
  /// Only applies to battery powered devices.
  final DevicePowerPowerState powerState;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  DevicePower copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    DevicePowerPowerState? powerState,
    bool copyOriginalValues = true,
  }) {
    DevicePower toReturn = DevicePower(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      powerState: powerState ?? this.powerState.copyWith(),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
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

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.powerState: powerState.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is DevicePower &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.powerState == powerState;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        powerState,
      );

  @override
  String toString() =>
      "Instance of 'DevicePower' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
