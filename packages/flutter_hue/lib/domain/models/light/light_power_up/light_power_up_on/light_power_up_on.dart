import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_on.dart';
import 'package:flutter_hue/domain/models/light/light_power_up/light_power_up_on/light_power_up_on_mode.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the on/off settings the light should take on power up.
class LightPowerUpOn {
  /// Creates a [LightPowerUpOn] object.
  LightPowerUpOn({
    required this.mode,
    required this.on,
  })  : _originalMode = mode,
        _originalOn = on.copyWith();

  /// Creates a [LightPowerUpOn] object from the JSON response to a GET request.
  factory LightPowerUpOn.fromJson(Map<String, dynamic> dataMap) {
    return LightPowerUpOn(
      mode: LightPowerUpOnMode.fromString(dataMap[ApiFields.mode] ?? ""),
      on: LightOn.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.isOn] ?? {})),
    );
  }

  /// Creates an empty [LightPowerUpOn] object.
  LightPowerUpOn.empty()
      : mode = LightPowerUpOnMode.fromString(""),
        on = LightOn.empty(),
        _originalMode = LightPowerUpOnMode.fromString(""),
        _originalOn = LightOn.empty();

  /// State to activate after power up.
  LightPowerUpOnMode mode;

  /// The value of [mode] when this object was instantiated.
  LightPowerUpOnMode _originalMode;

  /// On/Off state of the light on=true, off=false.
  LightOn on;

  /// The value of [on] when this object was instantiated.
  LightOn _originalOn;

  /// Whether or not this light is on.
  bool get isOn => on.isOn;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalMode = mode;
    on.refreshOriginals();
    _originalOn = on.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightPowerUpOn copyWith({
    LightPowerUpOnMode? mode,
    LightOn? on,
    bool copyOriginalValues = true,
  }) {
    LightPowerUpOn toReturn = LightPowerUpOn(
      mode: copyOriginalValues ? _originalMode : (mode ?? this.mode),
      on: copyOriginalValues
          ? _originalOn.copyWith(copyOriginalValues: copyOriginalValues)
          : (on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.mode = mode ?? this.mode;
      toReturn.on =
          on ?? this.on.copyWith(copyOriginalValues: copyOriginalValues);
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
        toReturn[ApiFields.mode] = mode.value;
      }

      if (on != _originalOn) {
        toReturn[ApiFields.isOn] = on.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.mode: mode.value,
      ApiFields.isOn: on.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightPowerUpOn && other.mode == mode && other.on == on;
  }

  @override
  int get hashCode => Object.hash(mode, on);

  @override
  String toString() =>
      "Instance of 'LightPowerUpOn' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
