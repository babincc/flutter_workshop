import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_dimming/light_dimming_delta_action.dart';
import 'package:flutter_hue/exceptions/percentage_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents the change in the dim level value for a light.
class LightDimmingDelta {
  /// Creates a [LightDimmingDelta] object.
  LightDimmingDelta({
    required this.action,
    required double? delta,
  })  : assert(delta == null || Validators.isValidPercentage(delta),
            "`delta` must be between 0 and 100 (inclusive)"),
        _originalAction = action,
        _delta = delta,
        _originalDelta = delta;

  /// Creates a [LightDimmingDelta] object from the JSON response to a GET
  /// request.
  factory LightDimmingDelta.fromJson(Map<String, dynamic> dataMap) {
    return LightDimmingDelta(
      action:
          LightDimmingDeltaAction.fromString(dataMap[ApiFields.action] ?? ""),
      delta: ((dataMap[ApiFields.brightnessDelta]) as num?)?.toDouble(),
    );
  }

  /// Creates an empty [LightDimmingDelta] object.
  LightDimmingDelta.empty()
      : action = LightDimmingDeltaAction.fromString(""),
        _originalAction = LightDimmingDeltaAction.fromString(""),
        _delta = null,
        _originalDelta = null;

  /// Describes the action be taken with a light's dim level.
  LightDimmingDeltaAction action;

  /// The value of [action] when this object was instantiated.
  LightDimmingDeltaAction _originalAction;

  double? _delta;

  /// Brightness percentage of full-scale increase delta to current dim level.
  ///
  /// Clip at Max-level or Min-level.
  ///
  /// Throws [PercentageException] if `delta` is set to something outside of the
  /// range 0 to 100 (inclusive).
  double? get delta => _delta;
  set delta(double? delta) {
    if (delta == null || Validators.isValidPercentage(delta)) {
      _delta = delta;
    } else {
      throw PercentageException.withValue(delta);
    }
  }

  /// The value of [delta] when this object was instantiated.
  double? _originalDelta;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => action != _originalAction || delta != _originalDelta;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalAction = action;
    _originalDelta = delta;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [delta] is nullable, it is defaulted to a negative number in this
  /// method. If left as a negative number, its current value in this
  /// [LightDimmingDelta] object will be used. This way, if it is `null`, the
  /// program will know that it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightDimmingDelta copyWith({
    LightDimmingDeltaAction? action,
    double? delta = -1.0,
    bool copyOriginalValues = true,
  }) {
    LightDimmingDelta toReturn = LightDimmingDelta(
      action: copyOriginalValues ? _originalAction : (action ?? this.action),
      delta: copyOriginalValues
          ? _originalDelta
          : (delta == null || delta >= 0 ? delta : this.delta),
    );

    if (copyOriginalValues) {
      toReturn.action = action ?? this.action;
      toReturn.delta = delta == null || delta >= 0 ? delta : this.delta;
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

      if (!identical(action, _originalAction)) {
        toReturn[ApiFields.action] = action.value;
      }

      if (delta != _originalDelta) {
        toReturn[ApiFields.brightnessDelta] = delta;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.action: action.value,
        ApiFields.brightnessDelta: delta,
      };
    }

    // DEFAULT
    return {
      ApiFields.action: action.value,
      ApiFields.brightnessDelta: delta,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightDimmingDelta &&
        other.action == action &&
        ((other.delta == null && delta == null) ||
            ((other.delta != null && delta != null) && (other.delta == delta)));
  }

  @override
  int get hashCode => Object.hash(action, delta);

  @override
  String toString() =>
      "Instance of 'LightDimmingDelta' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
