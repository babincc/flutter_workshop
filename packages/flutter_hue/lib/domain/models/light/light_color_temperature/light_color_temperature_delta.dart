import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/light/light_color_temperature/light_color_temperature_delta_action.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the change in the mirek value for a light.
class LightColorTemperatureDelta {
  /// Creates a [LightColorTemperatureDelta] object.
  LightColorTemperatureDelta({
    required this.action,
    required int? delta,
  })  : assert(delta == null || (delta >= 0 && delta <= 347),
            "`delta` must be between 0 and 347 (inclusive)"),
        _originalAction = action,
        _delta = delta,
        _originalDelta = delta;

  /// Creates a [LightColorTemperatureDelta] object from the JSON response to a
  /// GET request.
  factory LightColorTemperatureDelta.fromJson(Map<String, dynamic> dataMap) {
    return LightColorTemperatureDelta(
      action: LightColorTemperatureDeltaAction.fromString(
          dataMap[ApiFields.action] ?? ""),
      delta: dataMap[ApiFields.mirekDelta],
    );
  }

  /// Creates an empty [LightColorTemperatureDelta] object.
  LightColorTemperatureDelta.empty()
      : action = LightColorTemperatureDeltaAction.fromString(""),
        _delta = null,
        _originalDelta = null,
        _originalAction = LightColorTemperatureDeltaAction.fromString("");

  /// Describes the action be taken with a light's color temperature.
  LightColorTemperatureDeltaAction action;

  /// The value of [action] when this object was instantiated.
  LightColorTemperatureDeltaAction _originalAction;

  int? _delta;

  /// Mirek delta to current mirek.
  ///
  /// Clip at mirek_minimum and mirek_maximum of mirek_schema.
  ///
  /// Throws [Exception] if `delta` is not between 0 and 347 (inclusive).
  int? get delta => _delta;
  set delta(int? delta) {
    if (delta == null || delta >= 0 && delta <= 347) {
      _delta = delta;
    } else {
      throw Exception(
        "\n"
        "\tExpected: number between 0 and 347 (inclusive)\n"
        "\tActual: $delta",
      );
    }
  }

  /// The value of [delta] when this object was instantiated.
  int? _originalDelta;

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
  /// [LightColorTemperatureDelta] object will be used. This way, if it is
  /// `null`, the program will know that it is intentionally being set to
  /// `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  LightColorTemperatureDelta copyWith({
    LightColorTemperatureDeltaAction? action,
    int? delta = -1,
    bool copyOriginalValues = true,
  }) {
    LightColorTemperatureDelta toReturn = LightColorTemperatureDelta(
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
        toReturn[ApiFields.mirekDelta] = delta;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.action: action.value,
        ApiFields.mirekDelta: delta,
      };
    }

    // DEFAULT
    return {
      ApiFields.action: action.value,
      ApiFields.mirekDelta: delta,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightColorTemperatureDelta &&
        other.action == action &&
        ((other.delta == null && delta == null) ||
            ((other.delta != null && delta != null) && (other.delta == delta)));
  }

  @override
  int get hashCode => Object.hash(action, delta);

  @override
  String toString() =>
      "Instance of 'LightColorTemperatureDelta' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
