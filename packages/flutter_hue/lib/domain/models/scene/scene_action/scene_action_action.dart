import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_gradient/light_gradient.dart';
import 'package:flutter_hue/domain/models/light/light_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_color_temperature.dart';
import 'package:flutter_hue/exceptions/negative_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents an action to be executed on recall.
class SceneActionAction {
  /// Creates a [SceneActionAction] object.
  SceneActionAction({
    required this.on,
    required this.dimming,
    required this.xy,
    required this.colorTemperature,
    required this.gradient,
    required this.effect,
    int? durationMilliseconds,
  })  : _originalOn = on.copyWith(),
        _originalDimming = dimming.copyWith(),
        _originalXy = xy.copyWith(),
        _originalColorTemperature = colorTemperature.copyWith(),
        _originalGradient = gradient.copyWith(),
        _originalEffect = effect,
        _originalDurationMilliseconds = durationMilliseconds,
        _durationMilliseconds = durationMilliseconds;

  /// Creates a [SceneActionAction] object from the JSON response to a GET
  /// request.
  factory SceneActionAction.fromJson(Map<String, dynamic> dataMap) {
    return SceneActionAction(
        on: LightOn.fromJson(
            Map<String, dynamic>.from(dataMap[ApiFields.isOn] ?? {})),
        dimming: LightDimming.fromJson(
            Map<String, dynamic>.from(dataMap[ApiFields.dimming] ?? {})),
        xy: LightColorXy.fromJson(
            Map<String, dynamic>.from(dataMap[ApiFields.color] ?? {})),
        colorTemperature: LightPowerUpColorColorTemperature.fromJson(
            Map<String, dynamic>.from(
                dataMap[ApiFields.colorTemperature] ?? {})),
        gradient: LightGradient.fromJson(
            Map<String, dynamic>.from(dataMap[ApiFields.gradient] ?? {})),
        effect: Map<String, dynamic>.from(
                dataMap[ApiFields.effects] ?? {})[ApiFields.effect] ??
            "",
        durationMilliseconds: Map<String, dynamic>.from(
            dataMap[ApiFields.dynamics] ?? {})[ApiFields.duration]);
  }

  /// Creates an empty [SceneActionAction] object.
  SceneActionAction.empty()
      : _originalOn = LightOn.empty(),
        on = LightOn.empty(),
        _originalDimming = LightDimming.empty(),
        dimming = LightDimming.empty(),
        _originalXy = LightColorXy.empty(),
        xy = LightColorXy.empty(),
        _originalColorTemperature = LightPowerUpColorColorTemperature.empty(),
        colorTemperature = LightPowerUpColorColorTemperature.empty(),
        _originalGradient = LightGradient.empty(),
        gradient = LightGradient.empty(),
        effect = "",
        _originalEffect = "",
        _originalDurationMilliseconds = null;

  /// On/Off state of the light on=true, off=false
  LightOn on;

  /// The value of [on] when this object was instantiated.
  LightOn _originalOn;

  /// The brightness percentage of the light.
  LightDimming dimming;

  /// The value of [dimming] when this object was instantiated.
  LightDimming _originalDimming;

  /// CIE XY gamut position.
  LightColorXy xy;

  /// The value of [xy] when this object was instantiated.
  LightColorXy _originalXy;

  /// The color temperature of the light.
  LightPowerUpColorColorTemperature colorTemperature;

  /// The value of [colorTemperature] when this object was instantiated.
  LightPowerUpColorColorTemperature _originalColorTemperature;

  /// Basic feature containing gradient properties.
  LightGradient gradient;

  /// The value of [gradient] when this object was instantiated.
  LightGradient _originalGradient;

  /// Basic feature containing effect properties.
  String effect;

  /// The value of [effect] when this object was instantiated.
  String _originalEffect;

  int? _durationMilliseconds;

  /// Duration of a light transition or timed effects in ms.
  ///
  /// Throws [NegativeValueException] if `durationMilliseconds` is less than 0.
  int? get durationMilliseconds => _durationMilliseconds;
  set durationMilliseconds(int? durationMilliseconds) {
    if (durationMilliseconds == null || durationMilliseconds >= 0) {
      _durationMilliseconds = durationMilliseconds;
    } else {
      throw NegativeValueException.withValue(durationMilliseconds);
    }
  }

  /// The value of [durationMilliseconds] when this object was instantiated.
  int? _originalDurationMilliseconds;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    on.refreshOriginals();
    _originalOn = on.copyWith();
    dimming.refreshOriginals();
    _originalDimming = dimming.copyWith();
    xy.refreshOriginals();
    _originalXy = xy.copyWith();
    colorTemperature.refreshOriginals();
    _originalColorTemperature = colorTemperature.copyWith();
    gradient.refreshOriginals();
    _originalGradient = gradient.copyWith();
    _originalEffect = effect;
    _originalDurationMilliseconds = durationMilliseconds;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [durationMilliseconds] is nullable, it is defaulted to a negative number in this
  /// method. If left as a negative number, its current value in this
  /// [SceneActionAction] object will be used. This way, if it is `null`,
  /// the program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SceneActionAction copyWith({
    LightOn? on,
    LightDimming? dimming,
    LightColorXy? xy,
    LightPowerUpColorColorTemperature? colorTemperature,
    LightGradient? gradient,
    String? effect,
    int? durationMilliseconds = -1,
    bool copyOriginalValues = true,
  }) {
    SceneActionAction toReturn = SceneActionAction(
      on: copyOriginalValues
          ? _originalOn.copyWith(copyOriginalValues: copyOriginalValues)
          : (on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues)),
      dimming: copyOriginalValues
          ? _originalDimming.copyWith(copyOriginalValues: copyOriginalValues)
          : (dimming ??
              this.dimming.copyWith(copyOriginalValues: copyOriginalValues)),
      xy: copyOriginalValues
          ? _originalXy.copyWith(copyOriginalValues: copyOriginalValues)
          : (xy ?? this.xy.copyWith(copyOriginalValues: copyOriginalValues)),
      colorTemperature: copyOriginalValues
          ? _originalColorTemperature.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (colorTemperature ??
              this
                  .colorTemperature
                  .copyWith(copyOriginalValues: copyOriginalValues)),
      gradient: copyOriginalValues
          ? _originalGradient.copyWith(copyOriginalValues: copyOriginalValues)
          : (gradient ??
              this.gradient.copyWith(copyOriginalValues: copyOriginalValues)),
      effect: copyOriginalValues ? _originalEffect : (effect ?? this.effect),
      durationMilliseconds: copyOriginalValues
          ? _originalDurationMilliseconds
          : (durationMilliseconds == null || durationMilliseconds >= 0
              ? durationMilliseconds
              : this.durationMilliseconds),
    );

    if (copyOriginalValues) {
      toReturn.on =
          on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimming = dimming ??
          this.dimming.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.xy =
          xy ?? this.xy.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.colorTemperature = colorTemperature ??
          this
              .colorTemperature
              .copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.gradient = gradient ??
          this.gradient.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.effect = effect ?? this.effect;
      toReturn.durationMilliseconds =
          durationMilliseconds == null || durationMilliseconds >= 0
              ? durationMilliseconds
              : this.durationMilliseconds;
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

      if (on != _originalOn) {
        toReturn[ApiFields.isOn] = on.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (dimming != _originalDimming) {
        toReturn[ApiFields.dimming] =
            dimming.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (xy != _originalXy) {
        toReturn[ApiFields.color] = {
          ApiFields.xy: xy.toJson(optimizeFor: OptimizeFor.putFull)
        };
      }

      if (colorTemperature != _originalColorTemperature) {
        toReturn[ApiFields.colorTemperature] =
            colorTemperature.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (gradient != _originalGradient) {
        toReturn[ApiFields.gradient] =
            gradient.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (effect != _originalEffect) {
        toReturn[ApiFields.effects] = {ApiFields.effect: effect};
      }

      if (durationMilliseconds != _originalDurationMilliseconds) {
        toReturn[ApiFields.dynamics] = {
          ApiFields.duration: durationMilliseconds
        };
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
      ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
      ApiFields.color: {ApiFields.xy: xy.toJson(optimizeFor: optimizeFor)},
      ApiFields.colorTemperature:
          colorTemperature.toJson(optimizeFor: optimizeFor),
      ApiFields.gradient: gradient.toJson(optimizeFor: optimizeFor),
      ApiFields.effects: {ApiFields.effect: effect},
      ApiFields.dynamics: {ApiFields.duration: durationMilliseconds},
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SceneActionAction &&
        other.on == on &&
        other.dimming == dimming &&
        other.xy == xy &&
        other.colorTemperature == colorTemperature &&
        other.gradient == gradient &&
        other.effect == effect &&
        ((other.durationMilliseconds == null && durationMilliseconds == null) ||
            ((other.durationMilliseconds != null &&
                    durationMilliseconds != null) &&
                (other.durationMilliseconds == durationMilliseconds)));
  }

  @override
  int get hashCode => Object.hash(
        on,
        dimming,
        xy,
        colorTemperature,
        gradient,
        effect,
        durationMilliseconds,
      );

  @override
  String toString() =>
      "Instance of 'SceneActionAction' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
