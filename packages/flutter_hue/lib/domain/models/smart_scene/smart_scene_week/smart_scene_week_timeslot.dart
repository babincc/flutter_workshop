import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_week/smart_scene_week_start_time.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represent that data on light state during different time slots throughout
/// the day.
class SmartSceneWeekTimeslot {
  /// Creates a [SmartSceneWeekTimeslot] object.
  SmartSceneWeekTimeslot({
    required this.startTime,
    required this.target,
  })  : _originalStartTime = startTime.copyWith(),
        _originalTarget = target.copyWith();

  /// Creates a [SmartSceneWeekTimeslot] object from the JSON response to a GET
  /// request.
  factory SmartSceneWeekTimeslot.fromJson(Map<String, dynamic> dataMap) {
    return SmartSceneWeekTimeslot(
      startTime: SmartSceneWeekStartTime.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.startTime] ?? {})),
      target: Relative.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.target] ?? {})),
    );
  }

  /// Creates an empty [SmartSceneWeekTimeslot] object.
  SmartSceneWeekTimeslot.empty()
      : startTime = SmartSceneWeekStartTime.empty(),
        _originalStartTime = SmartSceneWeekStartTime.empty(),
        target = Relative.empty(),
        _originalTarget = Relative.empty();

  /// The start time of this time slot.
  SmartSceneWeekStartTime startTime;

  /// The value of [startTime] when this object was instantiated.
  SmartSceneWeekStartTime _originalStartTime;

  /// The identifier of the scene to recall.
  Relative target;

  /// The value of [target] when this object was instantiated.
  Relative _originalTarget;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      startTime != _originalStartTime ||
      startTime.hasUpdate ||
      target != _originalTarget ||
      target.hasUpdate;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    startTime.refreshOriginals();
    _originalStartTime = startTime.copyWith();
    target.refreshOriginals();
    _originalTarget = target.copyWith();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SmartSceneWeekTimeslot copyWith({
    SmartSceneWeekStartTime? startTime,
    Relative? target,
    bool copyOriginalValues = true,
  }) {
    SmartSceneWeekTimeslot toReturn = SmartSceneWeekTimeslot(
      startTime: copyOriginalValues
          ? _originalStartTime.copyWith(copyOriginalValues: copyOriginalValues)
          : (startTime ??
              this.startTime.copyWith(copyOriginalValues: copyOriginalValues)),
      target: copyOriginalValues
          ? _originalTarget.copyWith(copyOriginalValues: copyOriginalValues)
          : (target ??
              this.target.copyWith(copyOriginalValues: copyOriginalValues)),
    );

    if (copyOriginalValues) {
      toReturn.startTime = startTime ??
          this.startTime.copyWith(copyOriginalValues: copyOriginalValues);
      toReturn.target = target ??
          this.target.copyWith(copyOriginalValues: copyOriginalValues);
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

      if (startTime != _originalStartTime) {
        toReturn[ApiFields.startTime] =
            startTime.toJson(optimizeFor: OptimizeFor.putFull);
      }

      if (target != _originalTarget) {
        toReturn[ApiFields.target] =
            target.toJson(optimizeFor: OptimizeFor.putFull);
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.startTime: startTime.toJson(optimizeFor: optimizeFor),
      ApiFields.target: target.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SmartSceneWeekTimeslot &&
        other.startTime == startTime &&
        other.target == target;
  }

  @override
  int get hashCode => Object.hash(startTime, target);

  @override
  String toString() =>
      "Instance of 'SmartSceneWeekTimeslot' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
