import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_dimming/light_power_up_dimming_mode.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the dimming settings that should be applied to the light on power
/// up.
class LightPowerUpDimming extends LightDimming {
  /// Creates a [LightPowerUpDimming] object.
  LightPowerUpDimming({
    required this.mode,
    required super.brightness,
  }) : _originalMode = mode;

  /// Creates a [LightPowerUpDimming] object from the JSON response to a GET
  /// request.
  factory LightPowerUpDimming.fromJson(Map<String, dynamic> dataMap) {
    Map<String, dynamic> dimmingMap = dataMap[ApiFields.dimming] ?? {};

    return LightPowerUpDimming(
      mode: LightPowerUpDimmingMode.fromString(dataMap[ApiFields.mode] ?? ""),
      brightness: (dimmingMap[ApiFields.brightness] ?? 0.0).toDouble(),
    );
  }

  /// Creates an empty [LightPowerUpDimming] object.
  LightPowerUpDimming.empty()
      : mode = LightPowerUpDimmingMode.fromString(""),
        _originalMode = LightPowerUpDimmingMode.fromString(""),
        super.empty();

  /// Dimming will set the brightness to the specified value after power up.
  LightPowerUpDimmingMode mode;

  /// The value of [mode] when this object was instantiated.
  LightPowerUpDimmingMode _originalMode;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    _originalMode = mode;
    super.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  @override
  LightPowerUpDimming copyWith({
    LightPowerUpDimmingMode? mode,
    double? brightness,
    bool copyOriginalValues = true,
  }) {
    LightPowerUpDimming toReturn = LightPowerUpDimming(
      mode: copyOriginalValues ? _originalMode : (mode ?? this.mode),
      brightness: copyOriginalValues
          ? originalBrightness
          : (brightness ?? this.brightness),
    );

    if (copyOriginalValues) {
      toReturn.mode = mode ?? this.mode;
      toReturn.brightness = brightness ?? this.brightness;
    }

    return toReturn;
  }

  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Super JSON
    final Map<String, dynamic> superJson = {
      ApiFields.dimming: super.toJson(optimizeFor: optimizeFor)
    };

    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (Map<String, dynamic>.from(superJson[ApiFields.dimming]).isNotEmpty) {
        toReturn.addAll(superJson);
      }

      if (!identical(mode, _originalMode)) {
        toReturn[ApiFields.mode] = mode.value;
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ...superJson,
      ...{
        ApiFields.mode: mode.value,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightPowerUpDimming &&
        other.mode == mode &&
        other.brightness == brightness;
  }

  @override
  int get hashCode => Object.hash(mode, brightness);

  @override
  String toString() =>
      "Instance of 'LightPowerUpDimming' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
