// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a bridge home in the Philips Hue data structure.
class BridgeHome extends Resource {
  /// Creates a [BridgeHome] object.
  BridgeHome({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.children,
    required this.services,
  }) : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`');

  /// Creates a [BridgeHome] object from the JSON response to a GET request.
  factory BridgeHome.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return BridgeHome(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      children: (data[ApiFields.children] as List<dynamic>?)
              ?.map((child) => Relative.fromJson(child))
              .toList() ??
          [],
      services: (data[ApiFields.services] as List<dynamic>?)
              ?.map((service) => Relative.fromJson(service))
              .toList() ??
          [],
    );
  }

  /// Creates an empty [BridgeHome] object.
  BridgeHome.empty()
      : idV1 = "",
        children = [],
        services = [],
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Child devices/services to group by the derived group.
  final List<Relative> children;

  /// Returns a list of the [children] as [Resource] objects.
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// child can not be found on the [hueNetwork], or if the child's
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> get childrenAsResources => getRelativesAsResources(children);

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
  /// service can not be found on the [hueNetwork], or if the `relative`'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> get servicesAsResources => getRelativesAsResources(services);

  @override
  bool get hasUpdate =>
      super.hasUpdate ||
      children.any((child) => child.hasUpdate) ||
      services.any((service) => service.hasUpdate);

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  BridgeHome copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    List<Relative>? children,
    List<Relative>? services,
    bool copyOriginalValues = true,
  }) {
    BridgeHome toReturn = BridgeHome(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      children: children ??
          this
              .children
              .map((child) =>
                  child.copyWith(copyOriginalValues: copyOriginalValues))
              .toList(),
      services: services ??
          this
              .services
              .map((service) =>
                  service.copyWith(copyOriginalValues: copyOriginalValues))
              .toList(),
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
  /// Throws [InvalidIdException] if any of the children's IDs or service's IDs
  /// are empty and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.children: children
          .map((child) => child.toJson(
              optimizeFor: identical(optimizeFor, OptimizeFor.dontOptimize)
                  ? optimizeFor
                  : OptimizeFor.putFull))
          .toList(),
      ApiFields.services: services
          .map((service) => service.toJson(
              optimizeFor: identical(optimizeFor, OptimizeFor.dontOptimize)
                  ? optimizeFor
                  : OptimizeFor.putFull))
          .toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is BridgeHome &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        const DeepCollectionEquality.unordered()
            .equals(other.children, children) &&
        const DeepCollectionEquality.unordered()
            .equals(other.services, services);
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        const DeepCollectionEquality.unordered().hash(children),
        const DeepCollectionEquality.unordered().hash(services),
      );

  @override
  String toString() =>
      "Instance of 'BridgeHome' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
