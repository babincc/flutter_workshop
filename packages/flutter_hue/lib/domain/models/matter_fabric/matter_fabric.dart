// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/matter_fabric/matter_fabric_data.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/date_time_tool.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The configuration settings for a matter fabric resource.
class MatterFabric extends Resource {
  /// Creates a [MatterFabric] object.
  MatterFabric({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.status,
    required this.fabricData,
    required this.creationTime,
  }) : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`');

  /// Creates a [MatterFabric] object from the JSON response to a
  /// GET request.
  factory MatterFabric.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return MatterFabric(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      status: data[ApiFields.status] ?? "",
      fabricData: MatterFabricData.fromJson(
          Map<String, dynamic>.from(data[ApiFields.fabricData] ?? {})),
      creationTime: DateTime.tryParse(data[ApiFields.creationTime] ?? "") ??
          DateUtils.dateOnly(DateTime.now()),
    );
  }

  /// Creates an empty [MatterFabric] object.
  MatterFabric.empty()
      : idV1 = "",
        status = "",
        fabricData = MatterFabricData.empty(),
        creationTime = DateUtils.dateOnly(DateTime.now()),
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Only a fabric with status paired has label and vendor_id [fabricData]
  /// properties.
  ///
  /// one of: pending, timedout, paired
  final String status;

  /// Human readable context to identify fabric.
  final MatterFabricData fabricData;

  /// UTC date and time when this fabric was created.
  final DateTime creationTime;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  MatterFabric copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    String? status,
    MatterFabricData? fabricData,
    DateTime? creationTime,
    bool copyOriginalValues = true,
  }) {
    MatterFabric toReturn = MatterFabric(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      status: status ?? this.status,
      fabricData: fabricData ?? this.fabricData.copyWith(),
      creationTime: creationTime ?? this.creationTime.copyWith(),
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
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.status: status,
      ApiFields.fabricData: fabricData.toJson(),
      ApiFields.creationTime: DateTimeTool.toHueString(creationTime),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is MatterFabric &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.status == status &&
        other.fabricData == fabricData &&
        other.creationTime == creationTime;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        status,
        fabricData,
        creationTime,
      );

  @override
  String toString() => "Instance of 'MatterFabric' ${toJson().toString()}";
}
