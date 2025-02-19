import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_color_temperature.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the color temperature of a scene.
class ScenePaletteColorTemperature {
  /// Creates a [ScenePaletteColorTemperature] object.
  ScenePaletteColorTemperature({
    required this.colorTemperature,
    required this.dimming,
  })  : _originalColorTemperature = colorTemperature.copyWith(),
        _originalDimming = dimming.copyWith();

  /// Creates a [ScenePaletteColorTemperature] object from the JSON response to
  /// a GET request.
  factory ScenePaletteColorTemperature.fromJson(Map<String, dynamic> dataMap) {
    return ScenePaletteColorTemperature(
      colorTemperature: LightPowerUpColorColorTemperature.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.colorTemperature] ?? {})),
      dimming: LightDimming.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.dimming] ?? {})),
    );
  }

  /// Creates an empty [ScenePaletteColorTemperature] object.
  ScenePaletteColorTemperature.empty()
      : _originalColorTemperature = LightPowerUpColorColorTemperature.empty(),
        colorTemperature = LightPowerUpColorColorTemperature.empty(),
        _originalDimming = LightDimming.empty(),
        dimming = LightDimming.empty();

  /// The color temperature of the light.
  LightPowerUpColorColorTemperature colorTemperature;

  /// The value of [colorTemperature] when this object was instantiated.
  LightPowerUpColorColorTemperature _originalColorTemperature;

  /// The dimming level of the light.
  LightDimming dimming;

  /// The value of [dimming] when this object was instantiated.
  LightDimming _originalDimming;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      colorTemperature != _originalColorTemperature ||
      colorTemperature.hasUpdate ||
      dimming != _originalDimming ||
      dimming.hasUpdate;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    colorTemperature.refreshOriginals();
    _originalColorTemperature = colorTemperature.copyWith();
    dimming.refreshOriginals();
    _originalDimming = dimming.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ScenePaletteColorTemperature copyWith({
    LightPowerUpColorColorTemperature? colorTemperature,
    LightDimming? dimming,
    bool copyOriginalValues = true,
  }) {
    ScenePaletteColorTemperature toReturn = ScenePaletteColorTemperature(
      colorTemperature: copyOriginalValues
          ? _originalColorTemperature.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (colorTemperature ??
              this
                  .colorTemperature
                  .copyWith(copyOriginalValues: copyOriginalValues)),
      dimming: copyOriginalValues
          ? _originalDimming.copyWith(copyOriginalValues: copyOriginalValues)
          : (dimming ??
              this.dimming.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.colorTemperature = colorTemperature ??
          this
              .colorTemperature
              .copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimming = dimming ??
          this.dimming.copyWith(copyOriginalValues: copyOriginalValues);
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
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (colorTemperature != _originalColorTemperature) {
        toReturn[ApiFields.colorTemperature] =
            colorTemperature.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (dimming != _originalDimming) {
        toReturn[ApiFields.dimming] =
            dimming.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.colorTemperature:
          colorTemperature.toJson(optimizeFor: optimizeFor),
      ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScenePaletteColorTemperature &&
        other.colorTemperature == colorTemperature &&
        other.dimming == dimming;
  }

  @override
  int get hashCode => Object.hash(colorTemperature, dimming);

  @override
  String toString() =>
      "Instance of 'ScenePaletteColorTemperature' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
