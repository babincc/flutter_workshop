import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/exceptions/invalid_value_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';
import 'package:flutter_hue/utils/validators.dart';

/// Represents a light alert.
class LightAlert {
  /// Creates a [LightAlert] object.
  LightAlert({required this.actionValues, String? action})
      : assert(action == null || Validators.isValidValue(action, actionValues),
            "$action is not a valid `action`"),
        _originalAction = action,
        _action = action;

  /// Creates a [LightAlert] object from the JSON response to a GET request.
  factory LightAlert.fromJson(Map<String, dynamic> dataMap) {
    return LightAlert(
      actionValues: List<String>.from(dataMap[ApiFields.actionValues] ?? {}),
      action: dataMap[ApiFields.action],
    );
  }

  /// Creates an empty [LightAlert] object.
  LightAlert.empty()
      : actionValues = [],
        _originalAction = null,
        _action = null;

  /// Alert effects that the light supports.
  final List<String> actionValues;

  String? _action;

  /// Alert effect for the light.
  ///
  /// Must be from [actionValues].
  ///
  /// Throws [InvalidValueException] if `actionValue` is not found within
  /// [actionValues].
  String? get action => _action;
  set action(String? actionValue) {
    if (actionValue == null ||
        Validators.isValidValue(actionValue, actionValues)) {
      _action = actionValue;
    } else {
      throw InvalidValueException.withValue(actionValue, actionValues);
    }
  }

  /// The value of [action] when this object was first instantiated.
  String? _originalAction;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate => action != _originalAction;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalAction = action;
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// Since [action] is nullable, it is defaulted to an empty string in this
  /// method. If left as an empty string, its current value in this [LightAlert]
  /// object will be used. This way, if it is `null`, the program will know that
  /// it is intentionally being set to `null`.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  ///
  /// Throws [InvalidValueException] if the [LightAlert] copy has an
  /// [action] that is not in its [actionValues] array.
  LightAlert copyWith({
    List<String>? actionValues,
    String? action = "",
    bool copyOriginalValues = true,
  }) {
    // Make sure [actionValue] is valid.
    if (actionValues != null &&
        (action != null && action.isEmpty) &&
        !Validators.isValidValue(this.action, actionValues)) {
      throw InvalidValueException.withValue(this.action, actionValues);
    }

    LightAlert toReturn = LightAlert(
      actionValues: actionValues ?? List<String>.from(this.actionValues),
      action: copyOriginalValues
          ? _originalAction
          : (action == null || action.isNotEmpty ? action : this.action),
    );

    if (copyOriginalValues) {
      toReturn.action =
          action == null || action.isNotEmpty ? action : this.action;
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
  /// Throws [InvalidValueException] if [action] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // Validate [action].
    if (!identical(optimizeFor, OptimizeFor.dontOptimize)) {
      if (!Validators.isValidValue(action, actionValues)) {
        if (!identical(optimizeFor, OptimizeFor.put) ||
            action != _originalAction) {
          throw InvalidValueException.withValue(action, actionValues);
        }
      }
    }

    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (action != null &&
          (_originalAction == null || action != _originalAction)) {
        toReturn[ApiFields.action] = action;
      }

      return toReturn;
    }

    // PUT FULL
    if (identical(optimizeFor, OptimizeFor.putFull)) {
      return {
        ApiFields.action: action,
      };
    }

    // DEFAULT
    return {
      ApiFields.actionValues: actionValues,
      ApiFields.action: action,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is LightAlert &&
        const DeepCollectionEquality.unordered()
            .equals(other.actionValues, actionValues) &&
        ((other.action == null && action == null) ||
            ((other.action != null && action != null) &&
                (other.action == action)));
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(actionValues),
        action,
      );

  @override
  String toString() =>
      "Instance of 'LightAlert' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
