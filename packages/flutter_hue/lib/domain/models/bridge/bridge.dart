// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a Philips Hue bridge device.
class Bridge extends Resource {
  /// Creates a [Bridge] object.
  Bridge({
    required super.type,
    required super.id,
    this.idV1 = "",
    this.applicationKey,
    this.ipAddress,
    required this.owner,
    required this.bridgeId,
    required this.timeZone,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(ipAddress == null || Validators.isValidIpAddress(ipAddress),
            '"$ipAddress" is not a valid `ipAddress`');

  /// Creates a [Bridge] object from the JSON response to a GET request.
  factory Bridge.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Bridge(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      applicationKey: data[ApiFields.applicationKey],
      ipAddress: data[ApiFields.ipAddress],
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      bridgeId: data[ApiFields.bridgeId] ?? "",
      timeZone: Map<String, dynamic>.from(
              data[ApiFields.timeZone] ?? {})[ApiFields.timeZone] ??
          "",
    );
  }

  /// Creates an empty [Bridge] object.
  Bridge.empty()
      : owner = Relative.empty(),
        bridgeId = "",
        idV1 = "",
        applicationKey = null,
        ipAddress = null,
        timeZone = "",
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// The secret key that is used to talk with the bridge.
  final String? applicationKey;

  /// The internal IP address of this bridge.
  ///
  /// Regex pattern `^(?:\d{1,3}\.){3}\d{1,3}$`
  final String? ipAddress;

  /// Owner of this bridge, in case the owner is deleted, this also gets
  /// deleted.
  final Relative owner;

  /// Returns a [Resource] object that represents the [owner] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// [owner] cannot be found on the [hueNetwork], or if the [owner]'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource get ownerAsResource => getRelativeAsResource(owner);

  /// Unique identifier of this bridge as printed on the device.
  ///
  /// Lower case.
  final String bridgeId;

  /// Time zone where this bridge is located (as Olson ID).
  final String timeZone;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [ipAddress] and [applicationKey] are nullable, they are defaulted to
  /// empty strings in this method. If left as empty strings, their current
  /// values in this [Bridge] object will be used. This way, if they are `null`,
  /// the program will know that they are intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ///
  /// Throws [InvalidIdException] if [owner.id] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  Bridge copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    String? applicationKey = "",
    String? ipAddress = "",
    Relative? owner,
    String? bridgeId,
    String? timeZone,
    bool copyOriginalValues = true,
  }) {
    Bridge toReturn = Bridge(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      applicationKey: applicationKey == null || applicationKey.isNotEmpty
          ? applicationKey
          : this.applicationKey,
      ipAddress: ipAddress == null || ipAddress.isNotEmpty
          ? ipAddress
          : this.ipAddress,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      bridgeId: bridgeId ?? this.bridgeId,
      timeZone: timeZone ?? this.timeZone,
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
    }

    return toReturn;
  }

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
      ApiFields.applicationKey: applicationKey,
      ApiFields.ipAddress: ipAddress,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.bridgeId: bridgeId,
      ApiFields.timeZone: {ApiFields.timeZone: timeZone},
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Bridge &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        ((other.applicationKey == null && applicationKey == null) ||
            ((other.applicationKey != null && applicationKey != null) &&
                (other.applicationKey == applicationKey))) &&
        ((other.ipAddress == null && ipAddress == null) ||
            ((other.ipAddress != null && ipAddress != null) &&
                (other.ipAddress == ipAddress))) &&
        other.owner == owner &&
        other.bridgeId == bridgeId &&
        other.timeZone == timeZone;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        applicationKey,
        ipAddress,
        owner,
        bridgeId,
        timeZone,
      );

  @override
  String toString() =>
      "Instance of 'Bridge' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
