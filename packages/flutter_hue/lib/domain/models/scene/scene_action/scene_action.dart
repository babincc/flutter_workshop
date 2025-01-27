import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/scene/scene_action/scene_action_action.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents an action to be executed on recall.
class SceneAction {
  /// Creates a [SceneAction] object.
  SceneAction({
    required this.target,
    required this.action,
  })  : _originalTarget = target.copyWith(),
        _originalAction = action.copyWith();

  /// Creates a [SceneAction] object from the JSON response to a GET request.
  factory SceneAction.fromJson(Map<String, dynamic> dataMap) {
    return SceneAction(
      target: Relative.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.target] ?? {})),
      action: SceneActionAction.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.action] ?? {})),
    );
  }

  /// Creates an empty [SceneAction] object.
  SceneAction.empty()
      : _originalTarget = Relative.empty(),
        target = Relative.empty(),
        _originalAction = SceneActionAction.empty(),
        action = SceneActionAction.empty();

  /// The identifier of the light to execute the action on.
  Relative target;

  /// The value of [target] when this object was instantiated.
  Relative _originalTarget;

  /// The action to be executed on recall
  SceneActionAction action;

  /// The value of [action] when this object was instantiated.
  SceneActionAction _originalAction;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      target != _originalTarget ||
      target.hasUpdate ||
      action != _originalAction ||
      action.hasUpdate;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    target.refreshOriginals();
    _originalTarget = target.copyWith();
    action.refreshOriginals();
    _originalAction = action.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SceneAction copyWith({
    Relative? target,
    SceneActionAction? action,
    bool copyOriginalValues = true,
  }) {
    SceneAction toReturn = SceneAction(
      target: copyOriginalValues
          ? _originalTarget.copyWith(copyOriginalValues: copyOriginalValues)
          : (target ??
              this.target.copyWith(copyOriginalValues: copyOriginalValues)),
      action: copyOriginalValues
          ? _originalAction.copyWith(copyOriginalValues: copyOriginalValues)
          : (action ??
              this.action.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.target = target ??
          this.target.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.action = action ??
          this.action.copyWith(copyOriginalValues: copyOriginalValues);
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
  /// Throws [InvalidIdException] if [target.id] is empty and `optimizeFor` is
  /// not set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    // PUT
    if (identical(optimizeFor, OptimizeFor.put)) {
      Map<String, dynamic> toReturn = {};

      if (target != _originalTarget) {
        toReturn[ApiFields.target] =
            target.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (action != _originalAction) {
        toReturn[ApiFields.action] =
            action.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.target: target.toJson(optimizeFor: optimizeFor),
      ApiFields.action: action.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SceneAction &&
        other.target == target &&
        other.action == action;
  }

  @override
  int get hashCode => Object.hash(target, action);

  @override
  String toString() =>
      "Instance of 'SceneAction' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
