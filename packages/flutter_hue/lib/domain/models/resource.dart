import 'package:collection/collection.dart';
import 'package:flutter_hue/domain/models/bridge/bridge.dart';
import 'package:flutter_hue/domain/models/hue_network.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/missing_hue_network_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a Philips Hue resource.
abstract class Resource {
  /// Creates a [Resource] object.
  Resource({
    required this.type,
    required this.id,
    this.bridge,
  })  : assert(id.isEmpty || Validators.isValidId(id),
            '"$id" is not a valid `id`'),
        _originalType = type;

  /// Creates an empty [Resource] object.
  Resource.empty()
      : type = ResourceType.fromString(""),
        _originalType = ResourceType.fromString(""),
        id = "",
        bridge = Bridge.empty();

  /// Type of the supported resource.
  ResourceType type;

  /// The value of [type] when this object was instantiated.
  ResourceType _originalType;

  ResourceType get originalType => _originalType;

  /// Unique identifier representing a specific resource instance.
  ///
  /// Regex pattern `^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$`
  final String id;

  /// The bridge that this resource is associated with.
  Bridge? bridge;

  /// The [HueNetwork] that this resource is associated with.
  HueNetwork? hueNetwork;

  /// Returns a list of [Resource] objects that represent the `relatives` of
  /// this [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if a
  /// [Relative] cannot be found on the [hueNetwork], or if the `relative`'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  List<Resource> getRelativesAsResources(List<Relative> relatives) {
    List<Resource> toReturn = [];

    for (Relative relative in relatives) {
      toReturn.add(getRelativeAsResource(relative));
    }

    return toReturn;
  }

  /// Returns a [Resource] object that represents the `relative` of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// `relative` cannot be found on the [hueNetwork], or if the `relative`'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource getRelativeAsResource(Relative relative) {
    if (hueNetwork == null) {
      throw const MissingHueNetworkException();
    }

    ResourceType type = relative.type;

    List<Resource>? resources = hueNetwork!.getListType(type);

    if (resources == null) {
      throw const MissingHueNetworkException();
    }

    Resource? resource = resources.firstWhereOrNull(
      (resource) => resource.id == relative.id,
    );

    if (resource == null) {
      throw const MissingHueNetworkException();
    }

    return resource;
  }

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalType = type;
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
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put});
}
