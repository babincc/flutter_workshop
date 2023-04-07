// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents Philips Hue temperature sensor.
class Temperature extends Resource {
  /// Creates a [Temperature] object.
  Temperature({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.isEnabled,
    required this.temperatureCelsius,
    required this.isValidTemperature,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        _originalIsEnabled = isEnabled;

  /// Creates a [Temperature] object from the JSON response to a GET request.
  factory Temperature.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    Map<String, dynamic> innerTemperatureMap =
        Map<String, dynamic>.from(data[ApiFields.temperature]);

    return Temperature(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      isEnabled: data[ApiFields.isEnabled] ?? false,
      temperatureCelsius: innerTemperatureMap[ApiFields.temperature] ?? 0.0,
      isValidTemperature:
          innerTemperatureMap[ApiFields.temperatureValid] ?? false,
    );
  }

  /// Creates an empty [Temperature] object.
  Temperature.empty()
      : idV1 = "",
        owner = Relative.empty(),
        _originalIsEnabled = false,
        isEnabled = false,
        temperatureCelsius = 0.0,
        isValidTemperature = false,
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

  /// Whether or not the sensor is activated.
  bool isEnabled;

  /// The value of [isEnabled] when this object was instantiated.
  bool _originalIsEnabled;

  /// Temperature in 1.00 degrees Celsius.
  final double temperatureCelsius;

  /// Whether or not the value presented in temperature is valid.
  final bool isValidTemperature;

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
  Temperature copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    bool? isEnabled,
    double? temperatureCelsius,
    bool? isValidTemperature,
    bool copyOriginalValues = true,
  }) {
    Temperature toReturn = Temperature(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      isEnabled: copyOriginalValues
          ? _originalIsEnabled
          : (isEnabled ?? this.isEnabled),
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      isValidTemperature: isValidTemperature ?? this.isValidTemperature,
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
      ApiFields.temperature: {
        ApiFields.temperature: temperatureCelsius,
        ApiFields.temperatureValid: isValidTemperature,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Temperature &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.isEnabled == isEnabled &&
        other.temperatureCelsius == temperatureCelsius &&
        other.isValidTemperature == isValidTemperature;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        isEnabled,
        temperatureCelsius,
        isValidTemperature,
      );

  @override
  String toString() =>
      "Instance of 'Temperature' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
