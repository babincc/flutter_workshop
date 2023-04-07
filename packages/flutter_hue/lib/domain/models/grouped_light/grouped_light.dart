// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_alert.dart';
import 'package:flutter_hue/domain/models/light/light_color/light_color_xy.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_delta.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_delta.dart';
import 'package:flutter_hue/domain/models/light/light_dynamics.dart';
import 'package:flutter_hue/domain/models/light/light_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_color/light_power_up_color_color_temperature.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/resource.dart';
import 'package:flutter_hue/domain/models/resource_type.dart';
import 'package:flutter_hue/exceptions/negative_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/misc_tools.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a grouped light in the Philips Hue data structure.
class GroupedLight extends Resource {
  /// Creates a [GroupedLight] object.
  GroupedLight({
    required super.type,
    required super.id,
    this.idV1 = "",
    required this.owner,
    required this.on,
    required this.dimming,
    this.dimmingDelta,
    this.colorTemperature,
    this.colorTemperatureDelta,
    this.xy,
    required this.alert,
    int? durationMilliseconds,
  })  : assert(idV1.isEmpty || Validators.isValidIdV1(idV1),
            '"$idV1" is not a valid `idV1`'),
        assert(durationMilliseconds == null || durationMilliseconds >= 0,
            "`durationMilliseconds` must be greater than 0"),
        _originalOn = on.copyWith(),
        _originalDimming = dimming.copyWith(),
        _originalDimmingDelta = dimmingDelta?.copyWith(),
        _originalColorTemperature = colorTemperature?.copyWith(),
        _originalColorTemperatureDelta = colorTemperatureDelta?.copyWith(),
        _originalXy = xy?.copyWith(),
        _originalAlert = alert.copyWith(),
        _originalDurationMilliseconds = durationMilliseconds;

  /// Creates a [GroupedLight] object from the JSON response to a GET request.
  factory GroupedLight.fromJson(Map<String, dynamic> dataMap) {
    // Handle entire response given with no filter.
    Map<String, dynamic> data = MiscTools.extractData(dataMap);

    return GroupedLight(
      type: ResourceType.fromString(data[ApiFields.type] ?? ""),
      id: data[ApiFields.id] ?? "",
      idV1: data[ApiFields.idV1] ?? "",
      owner: Relative.fromJson(
          Map<String, dynamic>.from(data[ApiFields.owner] ?? {})),
      on: LightOn.fromJson(
          Map<String, dynamic>.from(data[ApiFields.isOn] ?? {})),
      dimming: LightDimming.fromJson(
          Map<String, dynamic>.from(data[ApiFields.dimming] ?? {})),
      dimmingDelta: data[ApiFields.dimmingDelta] == null
          ? null
          : LightDimmingDelta.fromJson(
              Map<String, dynamic>.from(data[ApiFields.dimmingDelta] ?? {})),
      colorTemperature: data[ApiFields.colorTemperature] == null
          ? null
          : LightPowerUpColorColorTemperature.fromJson(
              data[ApiFields.colorTemperature] ?? {}),
      colorTemperatureDelta: data[ApiFields.colorTemperatureDelta] == null
          ? null
          : LightColorTemperatureDelta.fromJson(Map<String, dynamic>.from(
              data[ApiFields.colorTemperatureDelta] ?? {})),
      xy: data[ApiFields.color] == null
          ? null
          : LightColorXy.fromJson(
              Map<String, dynamic>.from(
                Map<String, dynamic>.from(
                        data[ApiFields.color] ?? {})[ApiFields.xy] ??
                    {},
              ),
            ),
      alert: LightAlert.fromJson(
          Map<String, dynamic>.from(data[ApiFields.alert] ?? {})),
      durationMilliseconds: data[ApiFields.duration],
    );
  }

  /// Creates an empty [GroupedLight] object.
  GroupedLight.empty()
      : idV1 = "",
        owner = Relative.empty(),
        on = LightOn.empty(),
        _originalOn = LightOn.empty(),
        dimming = LightDimming.empty(),
        _originalDimming = LightDimming.empty(),
        alert = LightAlert.empty(),
        _originalDimmingDelta = null,
        _originalColorTemperature = null,
        _originalColorTemperatureDelta = null,
        _originalXy = null,
        _originalAlert = LightAlert.empty(),
        _originalDurationMilliseconds = 0,
        super.empty();

  /// Clip v1 resource identifier.
  ///
  /// Regex pattern `^(\/[a-z]{4,32}\/[0-9a-zA-Z-]{1,32})?$`
  @Deprecated(
      "Use `id` instead. This will be removed when Philips Hue API v1 is "
      "removed.")
  final String idV1;

  /// Child devices/services to group by the derived group.
  final Relative owner;

  /// Joined on control & aggregated on state.
  ///
  /// "on" is true if any light in the group is on.
  LightOn on;

  /// The value of [on] when this object was instantiated.
  LightOn _originalOn;

  /// Joined dimming control – "dimming.brightness" contains average brightness
  /// of group containing turned-on lights only.
  LightDimming dimming;

  /// The value of [dimming] when this object was instantiated.
  LightDimming _originalDimming;

  /// The change to this light's dimming property.
  LightDimmingDelta? dimmingDelta;

  /// The value of [dimmingDelta] when this object was instantiated.
  LightDimmingDelta? _originalDimmingDelta;

  /// Joined color temperature control.
  LightPowerUpColorColorTemperature? colorTemperature;

  /// The value of [colorTemperature] when this object was instantiated.
  LightPowerUpColorColorTemperature? _originalColorTemperature;

  /// The change in color temperature of this light.
  LightColorTemperatureDelta? colorTemperatureDelta;

  /// The value of [colorTemperatureDelta] when this object was instantiated.
  LightColorTemperatureDelta? _originalColorTemperatureDelta;

  /// Joined color control.
  ///
  /// CIE XY gamut position.
  LightColorXy? xy;

  /// The value of [xy] when this object was instantiated.
  LightColorXy? _originalXy;

  /// Joined alert control.
  LightAlert alert;

  /// The value of [alert] when this object was instantiated.
  LightAlert _originalAlert;

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
  @override
  void refreshOriginals() {
    on.refreshOriginals();
    _originalOn = on.copyWith();
    dimming.refreshOriginals();
    _originalDimming = dimming.copyWith();
    dimmingDelta?.refreshOriginals();
    _originalDimmingDelta = dimmingDelta?.copyWith();
    colorTemperature?.refreshOriginals();
    _originalColorTemperature = colorTemperature?.copyWith();
    colorTemperatureDelta?.refreshOriginals();
    _originalColorTemperatureDelta = colorTemperatureDelta?.copyWith();
    xy?.refreshOriginals();
    _originalXy = xy?.copyWith();
    alert.refreshOriginals();
    _originalAlert = alert.copyWith();
    _originalDurationMilliseconds = durationMilliseconds;
    super.refreshOriginals();
  }

  /// Used in the [copyWith] method to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [durationMilliseconds] is nullable, it is defaulted to a negative
  /// number in this method. If left as a negative number, its current value in
  /// this [LightDynamics] object will be used. This way, if it is `null`, the
  /// program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  GroupedLight copyWith({
    ResourceType? type,
    String? id,
    String? idV1,
    Relative? owner,
    LightOn? on,
    LightDimming? dimming,
    Object? dimmingDelta = sentinelValue,
    Object? colorTemperature = sentinelValue,
    Object? colorTemperatureDelta = sentinelValue,
    Object? xy = sentinelValue,
    LightAlert? alert,
    int? durationMilliseconds = -1,
    bool copyOriginalValues = true,
  }) {
    if (!identical(dimmingDelta, sentinelValue)) {
      assert(dimmingDelta is LightDimmingDelta?,
          "`dimmingDelta` must be a `LightDimmingDelta?` object");
    }
    if (!identical(colorTemperature, sentinelValue)) {
      assert(colorTemperature is LightPowerUpColorColorTemperature?,
          "`colorTemperature` must be a `LightPowerUpColorColorTemperature?` object");
    }
    if (!identical(colorTemperatureDelta, sentinelValue)) {
      assert(colorTemperatureDelta is LightColorTemperatureDelta?,
          "`colorTemperatureDelta` must be a `LightColorTemperatureDelta?` object");
    }
    if (!identical(xy, sentinelValue)) {
      assert(xy is LightColorXy?, "`xy` must be a `LightColorXy?` object");
    }

    GroupedLight toReturn = GroupedLight(
      type: copyOriginalValues ? originalType : (type ?? this.type),
      id: id ?? this.id,
      idV1: idV1 ?? this.idV1,
      owner:
          owner ?? this.owner.copyWith(copyOriginalValues: copyOriginalValues),
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
          ? _originalColorTemperature?.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (identical(colorTemperature, sentinelValue)
              ? this
                  .colorTemperature
                  ?.copyWith(copyOriginalValues: copyOriginalValues)
              : colorTemperature as LightPowerUpColorColorTemperature?),
      colorTemperatureDelta: copyOriginalValues
          ? _originalColorTemperatureDelta?.copyWith(
              copyOriginalValues: copyOriginalValues)
          : (identical(colorTemperatureDelta, sentinelValue)
              ? this
                  .colorTemperatureDelta
                  ?.copyWith(copyOriginalValues: copyOriginalValues)
              : colorTemperatureDelta as LightColorTemperatureDelta?),
      xy: copyOriginalValues
          ? _originalXy?.copyWith(copyOriginalValues: copyOriginalValues)
          : (identical(xy, sentinelValue)
              ? this.xy?.copyWith(copyOriginalValues: copyOriginalValues)
              : xy as LightColorXy?),
      alert: copyOriginalValues
          ? _originalAlert.copyWith(copyOriginalValues: copyOriginalValues)
          : (alert ??
              this.alert.copyWith(copyOriginalValues: copyOriginalValues)),
      durationMilliseconds: copyOriginalValues
          ? _originalDurationMilliseconds
          : (durationMilliseconds == null || durationMilliseconds >= 0
              ? durationMilliseconds
              : this.durationMilliseconds),
    );

    if (copyOriginalValues) {
      toReturn.type = type ?? this.type;
      toReturn.on =
          on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimming = dimming ??
          this.dimming.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.dimmingDelta = identical(dimmingDelta, sentinelValue)
          ? this.dimmingDelta?.copyWith(copyOriginalValues: copyOriginalValues)
          : dimmingDelta as LightDimmingDelta?;
      toReturn.colorTemperature = identical(colorTemperature, sentinelValue)
          ? this
              .colorTemperature
              ?.copyWith(copyOriginalValues: copyOriginalValues)
          : colorTemperature as LightPowerUpColorColorTemperature?;
      toReturn.colorTemperatureDelta =
          identical(colorTemperatureDelta, sentinelValue)
              ? this
                  .colorTemperatureDelta
                  ?.copyWith(copyOriginalValues: copyOriginalValues)
              : colorTemperatureDelta as LightColorTemperatureDelta?;
      toReturn.xy = identical(xy, sentinelValue)
          ? this.xy?.copyWith(copyOriginalValues: copyOriginalValues)
          : xy as LightColorXy?;
      toReturn.alert =
          alert ?? this.alert.copyWith(copyOriginalValues: copyOriginalValues);
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

      if (!(_originalColorTemperature == null && colorTemperature == null) &&
          (((_originalColorTemperature != null && colorTemperature != null) &&
                  (_originalColorTemperature != colorTemperature)) ||
              (_originalColorTemperature == null ||
                  colorTemperature == null))) {
        toReturn[ApiFields.colorTemperature] =
            colorTemperature?.toJson(optimizeFor: OptimizeFor.putFull);
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

      if (!(_originalXy == null && xy == null) &&
          (((_originalXy != null && xy != null) && (_originalXy != xy)) ||
              (_originalXy == null || xy == null))) {
        toReturn[ApiFields.xy] = xy?.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (alert != _originalAlert) {
        toReturn[ApiFields.alert] =
            alert.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (durationMilliseconds != _originalDurationMilliseconds) {
        toReturn[ApiFields.dynamics] = {
          ApiFields.duration: durationMilliseconds
        };
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.type: type.value,
        ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
        ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
        ApiFields.dimmingDelta: dimmingDelta?.toJson(optimizeFor: optimizeFor),
        ApiFields.colorTemperature:
            colorTemperature?.toJson(optimizeFor: optimizeFor),
        ApiFields.colorTemperatureDelta:
            colorTemperatureDelta?.toJson(optimizeFor: optimizeFor),
        ApiFields.color: {ApiFields.xy: xy?.toJson(optimizeFor: optimizeFor)},
        ApiFields.alert: alert.toJson(optimizeFor: optimizeFor),
        ApiFields.dynamics: {ApiFields.duration: durationMilliseconds},
      };
    }

    // DEFAULT
    return {
      ApiFields.type: type.value,
      ApiFields.id: id,
      ApiFields.idV1: idV1,
      ApiFields.owner: owner.toJson(optimizeFor: optimizeFor),
      ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
      ApiFields.dimming: dimming.toJson(optimizeFor: optimizeFor),
      ApiFields.dimmingDelta: dimmingDelta?.toJson(optimizeFor: optimizeFor),
      ApiFields.colorTemperature:
          colorTemperature?.toJson(optimizeFor: optimizeFor),
      ApiFields.colorTemperatureDelta:
          colorTemperatureDelta?.toJson(optimizeFor: optimizeFor),
      ApiFields.color: {ApiFields.xy: xy?.toJson(optimizeFor: optimizeFor)},
      ApiFields.alert: alert.toJson(optimizeFor: optimizeFor),
      ApiFields.dynamics: {ApiFields.duration: durationMilliseconds},
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is GroupedLight &&
        other.type == type &&
        other.id == id &&
        other.idV1 == idV1 &&
        other.owner == owner &&
        other.on == on &&
        other.dimming == dimming &&
        ((other.dimmingDelta == null && dimmingDelta == null) ||
            ((other.dimmingDelta != null && dimmingDelta != null) &&
                (other.dimmingDelta == dimmingDelta))) &&
        ((other.colorTemperature == null && colorTemperature == null) ||
            ((other.colorTemperature != null && colorTemperature != null) &&
                (other.colorTemperature == colorTemperature))) &&
        ((other.colorTemperatureDelta == null &&
                colorTemperatureDelta == null) ||
            ((other.colorTemperatureDelta != null &&
                    colorTemperatureDelta != null) &&
                (other.colorTemperatureDelta == colorTemperatureDelta))) &&
        ((other.xy == null && xy == null) ||
            ((other.xy != null && xy != null) && (other.xy == xy))) &&
        other.alert == alert &&
        ((other.durationMilliseconds == null && durationMilliseconds == null) ||
            ((other.durationMilliseconds != null &&
                    durationMilliseconds != null) &&
                (other.durationMilliseconds == durationMilliseconds)));
  }

  @override
  int get hashCode => Object.hash(
        type,
        id,
        idV1,
        owner,
        on,
        dimming,
        dimmingDelta,
        colorTemperature,
        colorTemperatureDelta,
        xy,
        alert,
        durationMilliseconds,
      );

  @override
  String toString() =>
      "Instance of 'GroupedLight' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
