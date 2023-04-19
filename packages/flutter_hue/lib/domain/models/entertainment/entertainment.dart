// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/entertainment/entertainment_segment/entertainment_segment_capabilities.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents an entertainment resource.
class Entertainment extends Resource {
  /// Creates a [Entertainment] object.
  Entertainment({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.isRenderer,
    required this.isProxy,
    required this.isEqualizer,
    required this.maxStreams,
    required this.segmentCapabilities,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(maxStreams >= 1, "`maxStreams` must be at least 1");

  /// Creates a [Entertainment] object from the JSON response to a GET request.
  factory Entertainment.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Entertainment(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      isRenderer: data[ApiFields.isRenderer] ?? false,
      isProxy: data[ApiFields.isProxy] ?? false,
      isEqualizer: data[ApiFields.isEqualizer] ?? false,
      maxStreams: data[ApiFields.maxStreams] ?? 1,
      segmentCapabilities: EntertainmentSegmentCapabilities.fromJson(
          Map<String, dynamic>.from(data[ApiFields.segments] ?? {})),
    );
  }

  /// Creates an empty [Entertainment] object.
  Entertainment.empty()
      : idV1 = "",
        owner = Relative.empty(),
        isRenderer = false,
        isProxy = false,
        isEqualizer = false,
        maxStreams = 1,
        segmentCapabilities = EntertainmentSegmentCapabilities.empty(),
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Owner of this service, in case the owner service is deleted, this service
  /// also gets deleted.
  final Relative owner;

  /// Returns a [Resource] object that represents the [owner] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// [owner] cannot be found on the [hueNetwork], or if the [owner]'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource get ownerAsResource => getRelativeAsResource(owner);

  /// Whether or not a lamp can be used for entertainment streaming as renderer.
  final bool isRenderer;

  /// Whether or not a lamp can be used for entertainment streaming as a proxy
  /// node.
  final bool isProxy;

  /// Whether or not a lamp can handle the equalization factor to dimming
  /// maximum brightness in a stream.
  final bool isEqualizer;

  /// Indicates the maximum number of parallel streaming sessions the bridge
  /// supports.
  final int maxStreams;

  /// Holds all parameters concerning the segmentation capabilities of a device.
  final EntertainmentSegmentCapabilities segmentCapabilities;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [action] is nullable, it is defaulted to an empty string in this
  /// method. If left as an empty string, its current value in this
  /// [Entertainment] object will be used. This way, if it is
  /// `null`, the program will know that it is intentionally being set to
  /// `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Entertainment copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    bool? isRenderer,
    bool? isProxy,
    bool? isEqualizer,
    int? maxStreams,
    EntertainmentSegmentCapabilities? segmentCapabilities,
    bool copyOriginalValues = true,
  }) {
    Entertainment toReturn = Entertainment(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      isRenderer: isRenderer ?? this.isRenderer,
      isProxy: isProxy ?? this.isProxy,
      isEqualizer: isEqualizer ?? this.isEqualizer,
      maxStreams: maxStreams ?? this.maxStreams,
      segmentCapabilities:
          segmentCapabilities ?? this.segmentCapabilities.copyWith(),
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
  /// Throws [InvalidNameException] if [name] doesn't have a length of 1 - 32
  /// (inclusive) and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (type != originalType) {
        toReturn[ApiFields.type] = type.value;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.isRenderer: isRenderer,
      ApiFields.isProxy: isProxy,
      ApiFields.isEqualizer: isEqualizer,
      ApiFields.maxStreams: maxStreams,
      ApiFields.segments: segmentCapabilities.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Entertainment &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.isRenderer == isRenderer &&
        other.isProxy == isProxy &&
        other.isEqualizer == isEqualizer &&
        other.maxStreams == maxStreams &&
        other.segmentCapabilities == segmentCapabilities;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        isRenderer,
        isProxy,
        isEqualizer,
        maxStreams,
        segmentCapabilities,
      );

  @override
  String toString() =>
      "Instance of 'Entertainment' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
