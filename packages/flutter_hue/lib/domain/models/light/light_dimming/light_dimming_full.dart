import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the current brightness and dimming capabilities of a light.
class LightDimmingFull extends LightDimming {
  /// Creates a [LightDimmingFull] object.
  LightDimmingFull({
    required super.brightness,
    required this.minDimLevel,
  }) : assert(Validators.isValidPercentage(minDimLevel),
            "`minDimLevel` must be between 0 - 100 (inclusive)");

  /// Creates a [LightDimmingFull] object from the JSON response to a GET
  /// request.
  factory LightDimmingFull.fromJson(Map<String, dynamic> dataMap) {
    return LightDimmingFull(
      brightness: dataMap[ApiFields.brightness] ?? 0.0,
      minDimLevel: dataMap[ApiFields.minDimLevel] ?? 0.0,
    );
  }

  /// Creates an empty [LightDimmingFull] object.
  LightDimmingFull.empty()
      : minDimLevel = 0,
        super.empty();

  /// Percentage of the maximum lumen the device outputs on minimum brightness.
  ///
  /// Range: 0 - 100
  final double minDimLevel;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  @override
  LightDimmingFull copyWith({
    double? brightness,
    double? minDimLevel,
    bool copyOriginalValues = true,
  }) {
    LightDimmingFull toReturn = LightDimmingFull(
      brightness: copyOriginalValues
          ? originalBrightness
          : (brightness ?? this.brightness),
      minDimLevel: minDimLevel ?? this.minDimLevel,
    );

    if (copyOriginalValues) {
      toReturn.brightness = brightness ?? this.brightness;
    }

    return toReturn;
  }

  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Super JSON
    final Map<String, dynamic> superJson =
        super.toJson(optimizeFor: optimizeFor);

    // PUT & PUT FULL
    if (identical(optimizeFor, OptimizeFor.put) ||
        identical(optimizeFor, OptimizeFor.putFull)) {
      return superJson;
    }

    // DEFAULT
    return {
      ...superJson,
      ...{
        ApiFields.brightness: brightness,
        ApiFields.minDimLevel: minDimLevel,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightDimmingFull &&
        other.brightness == brightness &&
        other.minDimLevel == minDimLevel;
  }

  @override
  int get hashCode => Object.hash(brightness, minDimLevel);

  @override
  String toString() =>
      "Instance of 'LightDimmingFull' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
