import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_dimming/light_power_up_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_on/light_power_up_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_preset.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the properties to configure powerup behavior of a light source.
class LightPowerUp {
  /// Creates a [LightPowerUp] object.
  LightPowerUp({
    required this.preset,
    required this.isConfigured,
    required this.on,
    required this.dimming,
    required this.color,
  })  : _originalPreset = preset,
        _originalOn = on.copyWith(),
        _originalDimming = dimming.copyWith(),
        _originalColor = color.copyWith();

  /// Creates a [LightPowerUp] object from the JSON response to a GET request.
  factory LightPowerUp.fromJson(Map<String, dynamic> dataMap) {
    return LightPowerUp(
      preset: LightPowerUpPreset.fromString(dataMap[ApiFields.preset] ?? ""),
      isConfigured: dataMap[ApiFields.isConfigured] ?? false,
      on: LightPowerUpOn.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.isOn] ?? {})),
      dimming: LightPowerUpDimming.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.dimming] ?? {})),
      color: LightPowerUpColor.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.color] ?? {})),
    );
  }

  /// Creates an empty [LightPowerUp] object.
  LightPowerUp.empty()
      : preset = LightPowerUpPreset.fromString(""),
        isConfigured = false,
        on = LightPowerUpOn.empty(),
        _originalOn = LightPowerUpOn.empty(),
        dimming = LightPowerUpDimming.empty(),
        _originalDimming = LightPowerUpDimming.empty(),
        color = LightPowerUpColor.empty(),
        _originalColor = LightPowerUpColor.empty(),
        _originalPreset = LightPowerUpPreset.fromString("");

  /// When setting the custom preset the additional properties can be set.
  ///
  /// For all other presets, no other properties can be included.
  LightPowerUpPreset preset;

  /// The value of [preset] when this object was instantiated.
  LightPowerUpPreset _originalPreset;

  /// Whether or not the shown values have been configured in the light source.
  final bool isConfigured;

  /// On/Off state of the light on=true, off=false.
  LightPowerUpOn on;

  /// The value of [on] when this object was instantiated.
  LightPowerUpOn _originalOn;

  /// Whether or not this light is on.
  bool get isOn => on.isOn;

  /// Describes the dimming behavior of the light source on power up.
  LightPowerUpDimming dimming;

  /// The value of [dimming] when this object was instantiated.
  LightPowerUpDimming _originalDimming;

  /// Describes the color behavior of the light source on power up.
  LightPowerUpColor color;

  /// The value of [color] when this object was instantiated.
  LightPowerUpColor _originalColor;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      !identical(preset, _originalPreset) ||
      on != _originalOn ||
      on.hasUpdate ||
      dimming != _originalDimming ||
      dimming.hasUpdate ||
      color != _originalColor ||
      color.hasUpdate;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalPreset = preset;
    on.refreshOriginals();
    _originalOn = on.copyWith();
    dimming.refreshOriginals();
    _originalDimming = dimming.copyWith();
    color.refreshOriginals();
    _originalColor = color.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightPowerUp copyWith({
    LightPowerUpPreset? preset,
    bool? isConfigured,
    LightPowerUpOn? on,
    LightPowerUpDimming? dimming,
    LightPowerUpColor? color,
    bool copyOriginalValues = true,
  }) {
    LightPowerUp toReturn = LightPowerUp(
      preset: copyOriginalValues ? _originalPreset : (preset ?? this.preset),
      isConfigured: isConfigured ?? this.isConfigured,
      on: copyOriginalValues
          ? _originalOn.copyWith(copyOriginalValues: copyOriginalValues)
          : (on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues)),
      dimming: copyOriginalValues
          ? _originalDimming.copyWith(copyOriginalValues: copyOriginalValues)
          : (dimming ??
              this.dimming.copyWith(copyOriginalValues: copyOriginalValues)),
      color: copyOriginalValues
          ? _originalColor.copyWith(copyOriginalValues: copyOriginalValues)
          : (color ??
              this.color.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.preset = preset ?? this.preset;
      toReturn.on =
          on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimming = dimming ??
          this.dimming.copyWith(copyOriginalValues: copyOriginalValues);
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

      if (!identical(preset, _originalPreset)) {
        toReturn[ApiFields.preset] = preset.value;
      }

      if (on != _originalOn) {
        toReturn[ApiFields.isOn] = on.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (dimming != _originalDimming) {
        toReturn[ApiFields.dimming] =
            dimming.toJson(optimizeFor: OptimizeFor.putFull);
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
        ApiFields.preset: preset.value,
        ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
        ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
        ApiFields.color: color.toJson(optimizeFor: optimizeFor),
      };
    }

    // DEFAULT
    return {
      ApiFields.preset: preset.value,
      ApiFields.isConfigured: isConfigured,
      ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
      ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
      ApiFields.color: color.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightPowerUp &&
        other.preset == preset &&
        other.isConfigured == isConfigured &&
        other.on == on &&
        other.dimming == dimming &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(preset, isConfigured, on, dimming, color);

  @override
  String toString() =>
      "Instance of 'LightPowerUp' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
