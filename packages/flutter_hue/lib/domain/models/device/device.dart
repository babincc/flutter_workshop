// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/device/device_metadata.dart';
import 'package:flutter_hue/domain/models/device/device_product_data.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a Philips Hue device.
class Device extends Resource {
  /// Creates a [Device] object.
  Device({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.productData,
    required this.metadata,
    required this.services,
    String? identifyAction,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        _originalMetadata = metadata,
        _originalIdentifyAction = identifyAction;

  /// Creates a [Device] object from the JSON response to a GET request.
  factory Device.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Device(
        type: ResourceType.fromString(data[ApiFields.type] ?? ""),
        id: data[ApiFields.id] ?? "",
        idV1: data[ApiFields.idV1] ?? "",
        productData: DeviceProductData.fromJson(
            Map<String, dynamic>.from(data[ApiFields.productData] ?? {})),
        metadata: DeviceMetadata.fromJson(
          Map<String, dynamic>.from(
            data[ApiFields.metadata] ?? {},
          ),
        ),
        services: (data[ApiFields.services] as List<dynamic>?)
                ?.map((service) => Relative.fromJson(service))
                .toList() ??
            [],
        identifyAction: Map<String, dynamic>.from(
            data[ApiFields.identify] ?? {})[ApiFields.action]);
  }

  /// Creates an empty [Device] object.
  Device.empty()
      : idV1 = "",
        productData = DeviceProductData.empty(),
        metadata = DeviceMetadata.empty(),
        _originalMetadata = DeviceMetadata.empty(),
        services = [],
        _originalIdentifyAction = null,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Product data about this device.
  final DeviceProductData productData;

  /// Configuration object for this room.
  DeviceMetadata metadata;

  /// The value of [metadata] when this object was instantiated.
  DeviceMetadata _originalMetadata;

  /// References all services aggregating control and state of children in the
  /// group.
  ///
  /// This includes all services grouped in the group hierarchy given by child
  /// relation This includes all services of a device grouped in the group
  /// hierarchy given by child relation Aggregation is per service type, ie
  /// every service type which can be grouped has a corresponding definition of
  /// grouped type Supported types: – grouped_light
  final List<Relative> services;

  /// Returns a list of the [services] as [Resource] objects.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// service can not be found on the [hueNetwork], or if the service's
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> get servicesAsResources => getRelativesAsResources(services);

  /// identify: Triggers a visual identification sequence, current implemented
  /// as (which can change in the future):
  ///
  /// * Bridge performs Zigbee LED identification cycles for 5 seconds
  /// * Lights perform one breathe cycle
  /// * Sensors perform LED identification cycles for 15 seconds
  String? identifyAction;

  /// The value of [identifyAction] when this object was instantiated.
  String? _originalIdentifyAction;

  @override
  bool get hasUpdate =>
      super.hasUpdate ||
      metadata != _originalMetadata ||
      metadata.hasUpdate ||
      identifyAction != _originalIdentifyAction ||
      services.any((service) => service.hasUpdate);

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalMetadata = metadata;
    _originalIdentifyAction = null;
    identifyAction = null;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [identifyAction] is nullable, it is defaulted to an empty string in
  /// this method. If left as an empty string, its current value in this
  /// [Device] object will be used. This way, if it is `null`, the program will
  /// know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Device copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    DeviceProductData? productData,
    DeviceMetadata? metadata,
    List<Relative>? services,
    String? identifyAction = "",
    bool copyOriginalValues = true,
  }) {
    Device toReturn = Device(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      productData: productData ?? this.productData.copyWith(),
      metadata: copyOriginalValues
          ? _originalMetadata.copyWith(copyOriginalValues: copyOriginalValues)
          : (metadata ??
              this.metadata.copyWith(copyOriginalValues: copyOriginalValues)),
      services: services ??
          this
              .services
              .map((service) =>
                  service.copyWith(copyOriginalValues: copyOriginalValues))
              .toList(),
      identifyAction: copyOriginalValues
          ? _originalIdentifyAction
          : (identifyAction == null || identifyAction.isNotEmpty
              ? identifyAction
              : this.identifyAction),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.metadata = metadata ??
          this.metadata.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.identifyAction =
          identifyAction == null || identifyAction.isNotEmpty
              ? identifyAction
              : this.identifyAction;
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
  /// Throws [InvalidNameException] if [metadata.name] doesn't have 1 to 32
  /// characters (inclusive), and `optimizeFor` is not set to
  /// [OptimizeFor.dontOptimize].
  ///
  /// Throws [InvalidIdException] if any of the service's IDs are empty and
  /// `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (!identical(type, originalType)) {
        toReturn[ApiFields.type] = type.value;
      }

      if (metadata != _originalMetadata) {
        toReturn[ApiFields.metadata] =
            metadata.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (identifyAction != _originalIdentifyAction) {
        toReturn[ApiFields.identify] = {ApiFields.action: identifyAction};
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.identify: {ApiFields.action: identifyAction},
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.productData: productData.toJson(),
      ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
      ApiFields.services: services
          .map((service) => service.toJson(optimizeFor: optimizeFor))
          .toList(),
      ApiFields.identify: {ApiFields.action: identifyAction},
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Device &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.productData == productData &&
        other.metadata == metadata &&
        const DeepCollectionEquality.unordered()
            .equals(other.services, services) &&
        other.identifyAction == identifyAction;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        productData,
        metadata,
        Object.hashAllUnordered(services),
        identifyAction,
      );

  @override
  String toString() =>
      "Instance of 'Device' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
