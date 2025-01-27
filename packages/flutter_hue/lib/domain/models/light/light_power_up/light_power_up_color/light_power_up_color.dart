import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_color_temperature.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_mode.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the color that is meant to be applied to the light on power up.
class LightPowerUpColor {
  /// Creates a [LightPowerUpColor] object.
  LightPowerUpColor({
    required this.mode,
    required this.colorTemperature,
    required this.color,
  })  : _originalMode = mode,
        _originalColorTemperature = colorTemperature.copyWith(),
        _originalColor = color.copyWith();

  /// Creates a [LightPowerUpColor] object from the JSON response to a GET
  /// request.
  factory LightPowerUpColor.fromJson(Map<String, dynamic> dataMap) {
    return LightPowerUpColor(
      mode: LightPowerUpColorMode.fromString(dataMap[ApiFields.mode] ?? ""),
      colorTemperature: LightPowerUpColorColorTemperature.fromJson(
          dataMap[ApiFields.colorTemperature] ?? {}),
      color: LightColorXy.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.color] ?? {})),
    );
  }

  /// Creates an empty [LightPowerUpColor] object.
  LightPowerUpColor.empty()
      : mode = LightPowerUpColorMode.fromString(""),
        colorTemperature = LightPowerUpColorColorTemperature.empty(),
        color = LightColorXy.empty(),
        _originalMode = LightPowerUpColorMode.fromString(""),
        _originalColorTemperature = LightPowerUpColorColorTemperature.empty(),
        _originalColor = LightColorXy.empty();

  /// State to activate after power up.
  ///
  /// Availability of "color_temperature" and "color" modes depend on the
  /// capabilities of the lamp.
  LightPowerUpColorMode mode;

  /// The value of [mode] when this object was instantiated.
  LightPowerUpColorMode _originalMode;

  /// The color temperature of the light.
  LightPowerUpColorColorTemperature colorTemperature;

  /// The value of [colorTemperature] when this object was instantiated.
  LightPowerUpColorColorTemperature _originalColorTemperature;

  /// CIE XY gamut position.
  LightColorXy color;

  /// The value of [color] when this object was instantiated.
  LightColorXy _originalColor;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      mode != _originalMode ||
      colorTemperature != _originalColorTemperature ||
      colorTemperature.hasUpdate ||
      color != _originalColor ||
      color.hasUpdate;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalMode = mode;
    colorTemperature.refreshOriginals();
    _originalColorTemperature = colorTemperature.copyWith();
    color.refreshOriginals();
    _originalColor = color.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightPowerUpColor copyWith({
    LightPowerUpColorMode? mode,
    LightPowerUpColorColorTemperature? colorTemperature,
    LightColorXy? color,
    bool copyOriginalValues = true,
  }) {
    LightPowerUpColor toReturn = LightPowerUpColor(
      mode: copyOriginalValues ? _originalMode : (mode ?? this.mode),
      colorTemperature: copyOriginalValues
          ? _originalColorTemperature.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (colorTemperature ??
              this
                  .colorTemperature
                  .copyWith(copyOriginalValues: copyOriginalValues)),
      color: copyOriginalValues
          ? _originalColor.copyWith(copyOriginalValues: copyOriginalValues)
          : (color ??
              this.color.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.mode = mode ?? this.mode;
      toReturn.colorTemperature = colorTemperature ??
          this
              .colorTemperature
              .copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.color =
          color ?? this.color.copyWith(copyOriginalValues: copyOriginalValues);
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

      if (!identical(mode, _originalMode)) {
        toReturn[ApiFields.mode] = mode;
      }

      if (colorTemperature != _originalColorTemperature) {
        toReturn[ApiFields.colorTemperature] =
            colorTemperature.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (color != _originalColor) {
        toReturn[ApiFields.color] =
            color.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.mode: mode,
        ApiFields.colorTemperature:
            colorTemperature.toJson(optimizeFor: optimizeFor),
        ApiFields.color: color.toJson(optimizeFor: optimizeFor),
      };
    }

    // DEFAULT
    return {
      ApiFields.mode: mode.value,
      ApiFields.colorTemperature:
          colorTemperature.toJson(optimizeFor: optimizeFor),
      ApiFields.color: color.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightPowerUpColor &&
        other.mode == mode &&
        other.colorTemperature == colorTemperature &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(mode, colorTemperature, color);

  @override
  String toString() =>
      "Instance of 'LightPowerUpColor' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
