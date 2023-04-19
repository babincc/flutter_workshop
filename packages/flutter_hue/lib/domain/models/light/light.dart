// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_alert.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_delta.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_full.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_delta.dart';
import 'package:flutter_hue/domain/models/light/light_dynamics.dart';
import 'package:flutter_hue/domain/models/light/light_effects.dart';
import 'package:flutter_hue/domain/models/light/light_gradient/light_gradient_full.dart';
import 'package:flutter_hue/domain/models/light/light_metadata.dart';
import 'package:flutter_hue/domain/models/light/light_mode.dart';
import 'package:flutter_hue/domain/models/light/light_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up.dart';
import 'package:flutter_hue/domain/models/light/light_signaling/light_signaling.dart';
import 'package:flutter_hue/domain/models/light/light_timed_effects.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a Philips Hue light.
class Light extends Resource {
  /// Creates a [Light] object.
  Light({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    LightMetadata? metadata,
    required this.on,
    required this.dimming,
    this.dimmingDelta,
    required this.colorTemperature,
    this.colorTemperatureDelta,
    required this.color,
    required this.dynamics,
    required this.alert,
    required this.signaling,
    required this.mode,
    required this.gradient,
    required this.effects,
    required this.timedEffects,
    required this.powerUp,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        metadata = metadata ?? LightMetadata.empty(),
        _originalMetadata = metadata?.copyWith() ?? LightMetadata.empty(),
        _originalOn = on.copyWith(),
        _originalDimming = dimming.copyWith(),
        _originalDimmingDelta = dimmingDelta?.copyWith(),
        _originalColorTemperature = colorTemperature.copyWith(),
        _originalColorTemperatureDelta = colorTemperatureDelta?.copyWith(),
        _originalColor = color.copyWith(),
        _originalDynamics = dynamics.copyWith(),
        _originalAlert = alert.copyWith(),
        _originalGradient = gradient.copyWith(),
        _originalEffects = effects.copyWith(),
        _originalTimedEffects = timedEffects.copyWith(),
        _originalPowerUp = powerUp.copyWith();

  /// Creates a [Light] object from the JSON response to a GET request.
  factory Light.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return Light(
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      metadata: LightMetadata.fromJson(
          Map<String, dynamic>.from(data[ApiFields.metadata] ?? {})),
      on: LightOn.fromJson(
          Map<String, dynamic>.from(data[ApiFields.isOn] ?? {})),
      dimming: LightDimmingFull.fromJson(
          Map<String, dynamic>.from(data[ApiFields.dimming] ?? {})),
      dimmingDelta: data[ApiFields.dimmingDelta] == null
          ? null
          : LightDimmingDelta.fromJson(
              Map<String, dynamic>.from(data[ApiFields.dimmingDelta] ?? {})),
      colorTemperature: LightColorTemperature.fromJson(
          data[ApiFields.colorTemperature] ?? {}),
      colorTemperatureDelta: data[ApiFields.colorTemperatureDelta] == null
          ? null
          : LightColorTemperatureDelta.fromJson(Map<String, dynamic>.from(
              data[ApiFields.colorTemperatureDelta] ?? {})),
      color: LightColor.fromJson(
          Map<String, dynamic>.from(data[ApiFields.color] ?? {})),
      dynamics: LightDynamics.fromJson(
          Map<String, dynamic>.from(data[ApiFields.dynamics] ?? {})),
      alert: LightAlert.fromJson(
          Map<String, dynamic>.from(data[ApiFields.alert] ?? {})),
      signaling: LightSignaling.fromJson(
          Map<String, dynamic>.from(data[ApiFields.signaling] ?? {})),
      mode: LightMode.fromString(data[ApiFields.mode] ?? ""),
      gradient: LightGradientFull.fromJson(
          Map<String, dynamic>.from(data[ApiFields.gradient] ?? {})),
      effects: LightEffects.fromJson(
          Map<String, dynamic>.from(data[ApiFields.effects] ?? {})),
      timedEffects: LightTimedEffects.fromJson(
          Map<String, dynamic>.from(data[ApiFields.timedEffects] ?? {})),
      powerUp: LightPowerUp.fromJson(
          Map<String, dynamic>.from(data[ApiFields.powerUp] ?? {})),
    );
  }

  /// Creates an empty [Light] object.
  Light.empty()
      : idV1 = "",
        owner = Relative.empty(),
        metadata = LightMetadata.empty(),
        on = LightOn.empty(),
        dimming = LightDimmingFull.empty(),
        dimmingDelta = null,
        _originalDimmingDelta = null,
        colorTemperature = LightColorTemperature.empty(),
        colorTemperatureDelta = null,
        _originalColorTemperatureDelta = null,
        color = LightColor.empty(),
        dynamics = LightDynamics.empty(),
        alert = LightAlert.empty(),
        signaling = LightSignaling.empty(),
        mode = LightMode.normal,
        gradient = LightGradientFull.empty(),
        effects = LightEffects.empty(),
        timedEffects = LightTimedEffects.empty(),
        powerUp = LightPowerUp.empty(),
        _originalMetadata = LightMetadata.empty(),
        _originalOn = LightOn.empty(),
        _originalDimming = LightDimmingFull.empty(),
        _originalColorTemperature = LightColorTemperature.empty(),
        _originalColor = LightColor.empty(),
        _originalDynamics = LightDynamics.empty(),
        _originalAlert = LightAlert.empty(),
        _originalGradient = LightGradientFull.empty(),
        _originalEffects = LightEffects.empty(),
        _originalTimedEffects = LightTimedEffects.empty(),
        _originalPowerUp = LightPowerUp.empty(),
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Owner of this light, in case the owner is deleted, this also gets deleted.
  final Relative owner;

  /// Returns a [Resource] object that represents the [owner] of this
  /// [Resource].
  ///
  /// Throws [MissingHueNetworkException] if the [hueNetwork] is null, if the
  /// [owner] cannot be found on the [hueNetwork], or if the [owner]'s
  /// [ResourceType] cannot be found on the [hueNetwork].
  Resource get ownerAsResource => getRelativeAsResource(owner);

  /// Metadata about this light.
  @Deprecated("Use metadata on device level")
  LightMetadata metadata;

  /// The value of [metadata] when this object was instantiated.
  LightMetadata _originalMetadata;

  /// On/Off state of the light on=true, off=false.
  LightOn on;

  /// The value of [on] when this object was instantiated.
  LightOn _originalOn;

  /// Whether or not this light is on.
  bool get isOn => on.isOn;

  /// The brightness of this light.
  LightDimmingFull dimming;

  /// The value of [dimming] when this object was instantiated.
  LightDimmingFull _originalDimming;

  /// The change to this light's dimming property.
  LightDimmingDelta? dimmingDelta;

  /// The value of [dimmingDelta] when this object was instantiated.
  LightDimmingDelta? _originalDimmingDelta;

  /// The color temperature of this light.
  LightColorTemperature colorTemperature;

  /// The value of [colorTemperature] when this object was instantiated.
  LightColorTemperature _originalColorTemperature;

  /// The change in color temperature of this light.
  LightColorTemperatureDelta? colorTemperatureDelta;

  /// The value of [colorTemperatureDelta] when this object was instantiated.
  LightColorTemperatureDelta? _originalColorTemperatureDelta;

  /// The color of this light.
  LightColor color;

  /// The value of [color] when this object was instantiated.
  LightColor _originalColor;

  /// Details about this light's dynamics functionality.
  LightDynamics dynamics;

  /// The value of [dynamics] when this object was instantiated.
  LightDynamics _originalDynamics;

  /// The alerts associated with this light.
  LightAlert alert;

  /// The value of [alert] when this object was instantiated.
  LightAlert _originalAlert;

  /// Feature containing signaling properties.
  final LightSignaling signaling;

  /// The mode this light is in.
  final LightMode mode;

  /// Basic feature containing gradient properties.
  LightGradientFull gradient;

  /// The value of [gradient] when this object was instantiated.
  LightGradientFull _originalGradient;

  /// Basic feature containing effect properties.
  LightEffects effects;

  /// The value of [effects] when this object was instantiated.
  LightEffects _originalEffects;

  /// Basic feature containing timed effect properties.
  LightTimedEffects timedEffects;

  /// The value of [timedEffects] when this object was instantiated.
  LightTimedEffects _originalTimedEffects;

  /// Feature containing properties to configure power up behavior of a light
  /// source.
  LightPowerUp powerUp;

  /// The value of [powerUp] when this object was instantiated.
  LightPowerUp _originalPowerUp;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  @override
  void refreshOriginals() {
    metadata.refreshOriginals();
    _originalMetadata = metadata.copyWith();
    on.refreshOriginals();
    _originalOn = on.copyWith();
    dimming.refreshOriginals();
    _originalDimming = dimming.copyWith();
    dimmingDelta?.refreshOriginals();
    _originalDimmingDelta = dimmingDelta?.copyWith();
    colorTemperature.refreshOriginals();
    _originalColorTemperature = colorTemperature.copyWith();
    colorTemperatureDelta?.refreshOriginals();
    _originalColorTemperatureDelta = colorTemperatureDelta?.copyWith();
    color.refreshOriginals();
    _originalColor = color.copyWith();
    dynamics.refreshOriginals();
    _originalDynamics = dynamics.copyWith();
    alert.refreshOriginals();
    _originalAlert = alert.copyWith();
    gradient.refreshOriginals();
    _originalGradient = gradient.copyWith();
    effects.refreshOriginals();
    _originalEffects = effects.copyWith();
    timedEffects.refreshOriginals();
    _originalTimedEffects = timedEffects.copyWith();
    powerUp.refreshOriginals();
    _originalPowerUp = powerUp.copyWith();
    super.refreshOriginals();
  }

  /// Used in the [copyWith] method to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [dimmingDelta] and [colorTemperatureDelta] are nullable, they are
  /// defaulted to empty objects in this method. If left as empty objects, their
  /// current value in this [Light] object will be used. This way, if they are
  /// `null`, the program will know that they are intentionally being set to
  /// `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  Light copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    LightMetadata? metadata,
    LightOn? on,
    LightDimmingFull? dimming,
    Object? dimmingDelta = sentinelValue,
    LightColorTemperature? colorTemperature,
    Object? colorTemperatureDelta = sentinelValue,
    LightColor? color,
    LightDynamics? dynamics,
    LightAlert? alert,
    LightSignaling? signaling,
    LightMode? mode,
    LightGradientFull? gradient,
    LightEffects? effects,
    LightTimedEffects? timedEffects,
    LightPowerUp? powerUp,
    bool copyOriginalValues = true,
  }) {
    if (!identical(dimmingDelta, sentinelValue)) {
      assert(dimmingDelta is LightDimmingDelta?,
          "`dimmingDelta` must be a `LightDimmingDelta?` object");
    }
    if (!identical(colorTemperatureDelta, sentinelValue)) {
      assert(colorTemperatureDelta is LightColorTemperatureDelta?,
          "`colorTemperatureDelta` must be a `LightColorTemperatureDelta?` object");
    }

    Light toReturn = Light(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
      metadata: copyOriginalValues
          ? _originalMetadata.copyWith(copyOriginalValues: copyOriginalValues)
          : (metadata ??
              this.metadata.copyWith(copyOriginalValues: copyOriginalValues)),
      on: copyOriginalValues
          ? _originalOn.copyWith(copyOriginalValues: copyOriginalValues)
          : (on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues)),
      dimming: copyOriginalValues
          ? _originalDimming.copyWith(copyOriginalValues: copyOriginalValues)
          : (dimming ??
              this.dimming.copyWith(copyOriginalValues: copyOriginalValues)),
      dimmingDelta: copyOriginalValues
          ? _originalDimmingDelta?.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (identical(dimmingDelta, sentinelValue)
              ? this
                  .dimmingDelta
                  ?.copyWith(copyOriginalValues: copyOriginalValues)
              : dimmingDelta as LightDimmingDelta?),
      colorTemperature: copyOriginalValues
          ? _originalColorTemperature.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (colorTemperature ??
              this
                  .colorTemperature
                  .copyWith(copyOriginalValues: copyOriginalValues)),
      colorTemperatureDelta: copyOriginalValues
          ? _originalColorTemperatureDelta?.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (identical(colorTemperatureDelta, sentinelValue)
              ? this
                  .colorTemperatureDelta
                  ?.copyWith(copyOriginalValues: copyOriginalValues)
              : colorTemperatureDelta as LightColorTemperatureDelta?),
      color: copyOriginalValues
          ? _originalColor.copyWith(copyOriginalValues: copyOriginalValues)
          : (color ??
              this.color.copyWith(copyOriginalValues: copyOriginalValues)),
      dynamics: copyOriginalValues
          ? _originalDynamics.copyWith(copyOriginalValues: copyOriginalValues)
          : (dynamics ??
              this.dynamics.copyWith(copyOriginalValues: copyOriginalValues)),
      alert: copyOriginalValues
          ? _originalAlert.copyWith(copyOriginalValues: copyOriginalValues)
          : (alert ??
              this.alert.copyWith(copyOriginalValues: copyOriginalValues)),
      signaling: signaling ?? this.signaling.copyWith(),
      mode: mode ?? this.mode,
      gradient: copyOriginalValues
          ? _originalGradient.copyWith(copyOriginalValues: copyOriginalValues)
          : (gradient ??
              this.gradient.copyWith(copyOriginalValues: copyOriginalValues)),
      effects: copyOriginalValues
          ? _originalEffects.copyWith(copyOriginalValues: copyOriginalValues)
          : (effects ??
              this.effects.copyWith(copyOriginalValues: copyOriginalValues)),
      timedEffects: copyOriginalValues
          ? _originalTimedEffects.copyWith(
              copyOriginalValues: copyOriginalValues)
          : timedEffects ??
              this
                  .timedEffects
                  .copyWith(copyOriginalValues: copyOriginalValues),
      powerUp: copyOriginalValues
          ? _originalPowerUp.copyWith(copyOriginalValues: copyOriginalValues)
          : (powerUp ??
              this.powerUp.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.metadata = metadata ??
          this.metadata.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.on =
          on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimming = dimming ??
          this.dimming.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimmingDelta = identical(dimmingDelta, sentinelValue)
          ? this.dimmingDelta?.copyWith(copyOriginalValues: copyOriginalValues)
          : dimmingDelta as LightDimmingDelta?;
      toReturn.colorTemperature = colorTemperature ??
          this
              .colorTemperature
              .copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.colorTemperatureDelta =
          identical(colorTemperatureDelta, sentinelValue)
              ? this
                  .colorTemperatureDelta
                  ?.copyWith(copyOriginalValues: copyOriginalValues)
              : colorTemperatureDelta as LightColorTemperatureDelta?;
      toReturn.color =
          color ?? this.color.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dynamics = dynamics ??
          this.dynamics.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.alert =
          alert ?? this.alert.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.gradient = gradient ??
          this.gradient.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.effects = effects ??
          this.effects.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.timedEffects = timedEffects ??
          this.timedEffects.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.powerUp = powerUp ??
          this.powerUp.copyWith(copyOriginalValues: copyOriginalValues);
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
  ///
  /// Throws [GradientException] if [gradient.points] has is not in the proper
  /// range. It must either have 0 elements or between 2 and 5 (inclusive), and
  /// `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  ///
  /// Throws [InvalidValueException] if [gradient.mode], [effects.effect],
  /// [timedEffects.effect], or [alert.action] are empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  ///
  /// Throws [InvalidNameException] if [metadata.name] doesn't have 1 to 32
  /// characters (inclusive), and `optimizeFor` is not set to
  /// [OptimizeFor.dontOptimize].
  @override
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (!identical(type, originalType)) {
        toReturn[ApiFields.type] = type.value;
      }

      if (metadata != _originalMetadata) {
        toReturn[ApiFields.metadata] =
            metadata.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (on != _originalOn) {
        toReturn[ApiFields.isOn] = on.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (dimming != _originalDimming) {
        toReturn[ApiFields.dimming] =
            dimming.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (!(_originalDimmingDelta == null && dimmingDelta == null) &&
          (((_originalDimmingDelta != null && dimmingDelta != null) &&
                  (_originalDimmingDelta != dimmingDelta)) ||
              (_originalDimmingDelta == null || dimmingDelta == null))) {
        toReturn[ApiFields.dimmingDelta] =
            dimmingDelta?.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (colorTemperature != _originalColorTemperature) {
        toReturn[ApiFields.colorTemperature] =
            colorTemperature.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (!(_originalColorTemperatureDelta == null &&
              colorTemperatureDelta == null) &&
          (((_originalColorTemperatureDelta != null &&
                      colorTemperatureDelta != null) &&
                  (_originalColorTemperatureDelta != colorTemperatureDelta)) ||
              (_originalColorTemperatureDelta == null ||
                  colorTemperatureDelta == null))) {
        toReturn[ApiFields.colorTemperatureDelta] =
            colorTemperatureDelta?.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (color != _originalColor) {
        toReturn[ApiFields.color] =
            color.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (dynamics != _originalDynamics) {
        toReturn[ApiFields.dynamics] =
            dynamics.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (alert != _originalAlert) {
        toReturn[ApiFields.alert] =
            alert.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (gradient != _originalGradient) {
        toReturn[ApiFields.gradient] =
            gradient.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (effects != _originalEffects) {
        toReturn[ApiFields.effects] =
            effects.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (timedEffects != _originalTimedEffects) {
        toReturn[ApiFields.timedEffects] =
            timedEffects.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (powerUp != _originalPowerUp) {
        toReturn[ApiFields.powerUp] =
            powerUp.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
        ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
        ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
        ApiFields.dimmingDelta: dimmingDelta?.toJson(optimizeFor: optimizeFor),
        ApiFields.colorTemperature:
            colorTemperature.toJson(optimizeFor: optimizeFor),
        ApiFields.colorTemperatureDelta:
            colorTemperatureDelta?.toJson(optimizeFor: optimizeFor),
        ApiFields.color: color.toJson(optimizeFor: optimizeFor),
        ApiFields.dynamics: dynamics.toJson(optimizeFor: optimizeFor),
        ApiFields.alert: alert.toJson(optimizeFor: optimizeFor),
        ApiFields.gradient: gradient.toJson(optimizeFor: optimizeFor),
        ApiFields.effects: effects.toJson(optimizeFor: optimizeFor),
        ApiFields.timedEffects: timedEffects.toJson(optimizeFor: optimizeFor),
        ApiFields.powerUp: powerUp.toJson(optimizeFor: optimizeFor),
      };
    }

    // DEFAULT
    return {
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.type: type.value,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.metadata: metadata.toJson(optimizeFor: optimizeFor),
      ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
      ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
      ApiFields.dimmingDelta: dimmingDelta?.toJson(optimizeFor: optimizeFor),
      ApiFields.colorTemperature:
          colorTemperature.toJson(optimizeFor: optimizeFor),
      ApiFields.colorTemperatureDelta:
          colorTemperatureDelta?.toJson(optimizeFor: optimizeFor),
      ApiFields.color: color.toJson(optimizeFor: optimizeFor),
      ApiFields.dynamics: dynamics.toJson(optimizeFor: optimizeFor),
      ApiFields.alert: alert.toJson(optimizeFor: optimizeFor),
      ApiFields.signaling: signaling.toJson(),
      ApiFields.mode: mode.value,
      ApiFields.gradient: gradient.toJson(optimizeFor: optimizeFor),
      ApiFields.effects: effects.toJson(optimizeFor: optimizeFor),
      ApiFields.timedEffects: timedEffects.toJson(optimizeFor: optimizeFor),
      ApiFields.powerUp: powerUp.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Light &&
        identical(other.type, type) &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.metadata == metadata &&
        other.on == on &&
        other.dimming == dimming &&
        ((other.dimmingDelta == null && dimmingDelta == null) ||
            ((other.dimmingDelta != null && dimmingDelta != null) &&
                (other.dimmingDelta == dimmingDelta))) &&
        other.colorTemperature == colorTemperature &&
        ((other.colorTemperatureDelta == null &&
                colorTemperatureDelta == null) ||
            ((other.colorTemperatureDelta != null &&
                    colorTemperatureDelta != null) &&
                (other.colorTemperatureDelta == colorTemperatureDelta))) &&
        other.color == color &&
        other.dynamics == dynamics &&
        other.alert == alert &&
        other.signaling == signaling &&
        other.mode == mode &&
        other.gradient == gradient &&
        other.effects == effects &&
        other.timedEffects == timedEffects &&
        other.powerUp == powerUp;
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        metadata,
        on,
        dimming,
        dimmingDelta,
        colorTemperature,
        colorTemperatureDelta,
        color,
        dynamics,
        alert,
        signaling,
        mode,
        gradient,
        effects,
        timedEffects,
        powerUp,
      );

  @override
  String toString() =>
      "Instance of 'Light' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
