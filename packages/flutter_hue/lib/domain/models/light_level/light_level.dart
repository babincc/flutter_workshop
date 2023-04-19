// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents Philips Hue light level sensor.
class LightLevel extends Resource {
  /// Creates a [LightLevel] object.
  LightLevel({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.isEnabled,
    required this.level,
    required this.isValidLevel,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        _originalIsEnabled = isEnabled;

  /// Creates a [LightLevel] object from the JSON response to a GET request.
  factory LightLevel.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    Map<String, dynamic> innerLevelMap =
        Map<String, dynamic>.from(data[ApiFields.light]);

    return LightLevel(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      isEnabled: data[ApiFields.isEnabled] ?? false,
      level: innerLevelMap[ApiFields.lightLevel] ?? 0,
      isValidLevel: innerLevelMap[ApiFields.lightLevelValid] ?? false,
    );
  }

  /// Creates an empty [LightLevel] object.
  LightLevel.empty()
      : idV1 = "",
        owner = Relative.empty(),
        _originalIsEnabled = false,
        isEnabled = false,
        level = 0,
        isValidLevel = false,
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

  /// Whether or not the sensor is activated.
  bool isEnabled;

  /// The value of [isEnabled] when this object was instantiated.
  bool _originalIsEnabled;

  /// Light level in 10000*log10(lux) +1 measured by sensor.
  ///
  /// Logarithmic scale used because the human eye adjusts to light levels and
  /// small changes at low lux levels are more noticeable than at high lux
  /// levels. This allows use of linear scale configuration sliders.
  final int level;

  /// Whether or not the value presented in [level] is valid.
  final bool isValidLevel;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalIsEnabled = isEnabled;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightLevel copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    bool? isEnabled,
    int? level,
    bool? isValidLevel,
    bool copyOriginalValues = true,
  }) {
    LightLevel toReturn = LightLevel(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      isEnabled: copyOriginalValues
          ? _originalIsEnabled
          : (isEnabled ?? this.isEnabled),
      level: level ?? this.level,
      isValidLevel: isValidLevel ?? this.isValidLevel,
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.isEnabled = isEnabled ?? this.isEnabled;
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

      if (isEnabled != _originalIsEnabled) {
        toReturn[ApiFields.isEnabled] = isEnabled;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.isEnabled: isEnabled,
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.isEnabled: isEnabled,
      ApiFields.light: {
        ApiFields.lightLevel: level,
        ApiFields.lightLevelValid: isValidLevel,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightLevel &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.isEnabled == isEnabled &&
        other.level == level &&
        other.isValidLevel == isValidLevel;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        isEnabled,
        level,
        isValidLevel,
      );

  @override
  String toString() =>
      "Instance of 'LightLevel' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
