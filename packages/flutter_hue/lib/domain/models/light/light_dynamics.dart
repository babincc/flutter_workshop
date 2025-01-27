import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/exceptions/negative_value_exception.dart';
import 'package:flutter_hue/exceptions/unit_interval_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// The dynamics properties of a light.
class LightDynamics {
  /// Creates a [LightDynamics] object.
  LightDynamics({
    required this.status,
    required this.statusValues,
    required double speed,
    required this.speedValid,
    int? durationMilliseconds,
  })  : assert(status.isEmpty || Validators.isValidValue(status, statusValues),
            '`statusValues` does not contain "$status"'),
        assert(Validators.isUnitInterval(speed),
            "`speed` must be between 0 and 1 (inclusive)"),
        assert(durationMilliseconds == null || durationMilliseconds >= 0,
            "`durationMilliseconds` must be greater than 0"),
        _originalSpeed = speed,
        _speed = speed,
        _originalDurationMilliseconds = durationMilliseconds;

  /// Creates a [LightDynamics] object from the JSON response to a GET request.
  factory LightDynamics.fromJson(Map<String, dynamic> dataMap) {
    return LightDynamics(
      status: dataMap[ApiFields.status] ?? "",
      statusValues: List<String>.from(dataMap[ApiFields.statusValues] ?? []),
      speed: ((dataMap[ApiFields.speed] ?? 0.0) as num).toDouble(),
      speedValid: dataMap[ApiFields.speedValid] ?? false,
      durationMilliseconds: dataMap[ApiFields.duration],
    );
  }

  /// Creates an empty [LightDynamics] object.
  LightDynamics.empty()
      : status = "",
        statusValues = [],
        _originalSpeed = 0.0,
        _speed = 0.0,
        speedValid = false,
        _originalDurationMilliseconds = null;

  /// Current status of the lamp with dynamics.
  final String status;

  /// Statuses in which a lamp could be when playing dynamics.
  final List<String> statusValues;

  double _speed;

  /// Speed of dynamic palette or effect.
  ///
  /// The speed is valid for the dynamic palette if the status is
  /// [LightDynamicsStatus.dynamic_palette] or for the corresponding effect
  /// listed in status. In case of status [LightDynamicsStatus.none], the speed
  /// is not valid.
  ///
  /// Range: 0 - 1
  ///
  /// Throws [UnitIntervalException] if `speed` is set to something outside of
  /// the range 0 to 1 (inclusive).
  double get speed => _speed;
  set speed(double speed) {
    if (Validators.isUnitInterval(speed)) {
      _speed = speed;
    } else {
      throw UnitIntervalException.withValue(speed);
    }
  }

  /// The value of [speed] when this object was instantiated.
  double _originalSpeed;

  /// Whether or not the value presented in [speed] is valid.
  final bool speedValid;

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

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      speed != _originalSpeed ||
      durationMilliseconds != _originalDurationMilliseconds;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalSpeed = speed;
    _originalDurationMilliseconds = durationMilliseconds;
  }

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
  ///
  /// Throws [InvalidValueException] if the [LightDynamics] copy has a [status]
  /// that is not in its [statusValues] array.
  LightDynamics copyWith({
    String? status,
    List<String>? statusValues,
    double? speed,
    bool? speedValid,
    int? durationMilliseconds = -1,
    bool copyOriginalValues = true,
  }) {
    // Make sure [status] is valid.
    if (statusValues != null &&
        status == null &&
        !Validators.isValidValue(this.status, statusValues)) {
      throw InvalidValueException.withValue(this.status, statusValues);
    }

    LightDynamics toReturn = LightDynamics(
      status: status ?? this.status,
      statusValues: statusValues ?? List<String>.from(this.statusValues),
      speed: copyOriginalValues ? _originalSpeed : (speed ?? this.speed),
      speedValid: speedValid ?? this.speedValid,
      durationMilliseconds: copyOriginalValues
          ? _originalDurationMilliseconds
          : (durationMilliseconds == null || durationMilliseconds >= 0
              ? durationMilliseconds
              : this.durationMilliseconds),
    );

    if (copyOriginalValues) {
      toReturn.speed = speed ?? this.speed;
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

      if (durationMilliseconds != _originalDurationMilliseconds) {
        toReturn[ApiFields.duration] = durationMilliseconds;
      }

      if (speed != _originalSpeed) {
        toReturn[ApiFields.speed] = speed;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.duration: durationMilliseconds,
        ApiFields.speed: speed,
      };
    }

    // DEFAULT
    return {
      ApiFields.status: status,
      ApiFields.statusValues: statusValues,
      ApiFields.speed: speed,
      ApiFields.speedValid: speedValid,
      ApiFields.duration: durationMilliseconds,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightDynamics &&
        other.status == status &&
        const DeepCollectionEquality.unordered()
            .equals(other.statusValues, statusValues) &&
        other.speed == speed &&
        other.speedValid == speedValid &&
        ((other.durationMilliseconds == null && durationMilliseconds == null) ||
            ((other.durationMilliseconds != null &&
                    durationMilliseconds != null) &&
                (other.durationMilliseconds == durationMilliseconds)));
  }

  @override
  int get hashCode => Object.hash(
        status,
        const DeepCollectionEquality.unordered().hash(statusValues),
        speed,
        speedValid,
        durationMilliseconds,
      );

  @override
  String toString() =>
      "Instance of 'LightDynamics' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
