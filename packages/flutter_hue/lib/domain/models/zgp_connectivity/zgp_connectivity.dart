// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents ZGP connectivity of a device.
class ZgpConnectivity extends Resource {
  /// Creates a [ZgpConnectivity] object.
  ZgpConnectivity({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.status,
    required this.sourceId,
  }) : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`');

  /// Creates a [ZgpConnectivity] object from the JSON response to a GET
  /// request.
  factory ZgpConnectivity.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return ZgpConnectivity(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      status: data[ApiFields.status] ?? "",
      sourceId: data[ApiFields.sourceId] ?? "",
    );
  }

  /// Creates an empty [ZgpConnectivity] object.
  ZgpConnectivity.empty()
      : idV1 = "",
        owner = Relative.empty(),
        status = "",
        sourceId = "",
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

  /// Describes this device's connection status to the zigbee network.
  ///
  /// * connected - if device has been recently been available
  /// * connectivity_issues - the device is powered off or has network issues
  /// * unidirectional_incoming - the device only talks to bridge
  /// * disconnected - the device is not connected
  final String status;

  /// Identifies the source of this.
  final String sourceId;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ZgpConnectivity copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    String? status,
    String? sourceId,
    bool copyOriginalValues = true,
  }) {
    ZgpConnectivity toReturn = ZgpConnectivity(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      status: status ?? this.status,
      sourceId: sourceId ?? this.sourceId,
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
      ApiFields.status: status,
      ApiFields.sourceId: sourceId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ZgpConnectivity &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.status == status &&
        other.sourceId == sourceId;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        status,
        sourceId,
      );

  @override
  String toString() =>
      "Instance of 'ZgpConnectivity' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
