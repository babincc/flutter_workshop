import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/smart_scene/smart_scene_week/smart_scene_week_timeslot.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represent that data on light state during different time slots throughout
/// the day.
class SmartSceneWeek {
  /// Creates a [SmartSceneWeek] object.
  SmartSceneWeek({
    required this.timeslots,
    required this.recurrence,
  })  : _originalTimeslots =
            timeslots.map((timeslot) => timeslot.copyWith()).toList(),
        _originalRecurrence = List<String>.from(recurrence);

  /// Creates a [SmartSceneWeek] object from the JSON response to a GET
  /// request.
  factory SmartSceneWeek.fromJson(Map<String, dynamic> dataMap) {
    return SmartSceneWeek(
      timeslots: (dataMap[ApiFields.timeslots] as List<dynamic>?)
              ?.map((timeslotMap) => SmartSceneWeekTimeslot.fromJson(
                  Map<String, dynamic>.from(timeslotMap)))
              .toList() ??
          [],
      recurrence: List<String>.from(dataMap[ApiFields.recurrence] ?? []),
    );
  }

  /// Creates an empty [SmartSceneWeek] object.
  SmartSceneWeek.empty()
      : timeslots = [],
        _originalTimeslots = [],
        recurrence = [],
        _originalRecurrence = [];

  /// The times during the day when the smart scene is active.
  List<SmartSceneWeekTimeslot> timeslots;

  /// The value of [timeslots] when this object was instantiated.
  List<SmartSceneWeekTimeslot> _originalTimeslots;

  /// The days that the smart scene is active.
  List<String> recurrence;

  /// The value of [recurrence] when this object was instantiated.
  List<String> _originalRecurrence;

  /// Whether or not this object has been updated.
  ///
  /// If `true`, then the data in this object differs from what is on the
  /// bridge.
  bool get hasUpdate =>
      !(const DeepCollectionEquality.unordered()
          .equals(timeslots, _originalTimeslots)) ||
      timeslots.any((timeslot) => timeslot.hasUpdate) ||
      !(const DeepCollectionEquality.unordered()
          .equals(recurrence, _originalRecurrence)) ||
      recurrence.any((recurrence) => !_originalRecurrence.contains(recurrence));

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    _originalTimeslots = timeslots.map((timeslot) {
      timeslot.refreshOriginals();
      return timeslot.copyWith();
    }).toList();
    _originalRecurrence = List<String>.from(recurrence);
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SmartSceneWeek copyWith({
    List<SmartSceneWeekTimeslot>? timeslots,
    List<String>? recurrence,
    bool copyOriginalValues = true,
  }) {
    SmartSceneWeek toReturn = SmartSceneWeek(
      timeslots: copyOriginalValues
          ? _originalTimeslots.map((timeslot) => timeslot.copyWith()).toList()
          : (timeslots ??
              this
                  .timeslots
                  .map((timeSlot) =>
                      timeSlot.copyWith(copyOriginalValues: copyOriginalValues))
                  .toList()),
      recurrence: copyOriginalValues
          ? _originalRecurrence
          : (recurrence ?? List<String>.from(this.recurrence)),
    );

    if (copyOriginalValues) {
      toReturn._originalTimeslots = timeslots ??
          this
              .timeslots
              .map((timeSlot) =>
                  timeSlot.copyWith(copyOriginalValues: copyOriginalValues))
              .toList();
      toReturn.recurrence = recurrence ?? List<String>.from(this.recurrence);
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

      if (!const DeepCollectionEquality.unordered()
          .equals(timeslots, _originalTimeslots)) {
        toReturn[ApiFields.timeslots] = timeslots
            .map(
                (timeslot) => timeslot.toJson(optimizeFor: OptimizeFor.putFull))
            .toList();
      }

      if (!const DeepCollectionEquality.unordered()
          .equals(recurrence, _originalRecurrence)) {
        toReturn[ApiFields.recurrence] = recurrence;
      }

      return toReturn;
    }

    // DEFAULT
    return {
      ApiFields.timeslots: timeslots
          .map((timeslot) => timeslot.toJson(optimizeFor: optimizeFor))
          .toList(),
      ApiFields.recurrence: recurrence,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SmartSceneWeek &&
        const DeepCollectionEquality.unordered()
            .equals(other.timeslots, timeslots) &&
        const DeepCollectionEquality.unordered()
            .equals(other.recurrence, recurrence);
  }

  @override
  int get hashCode => Object.hash(
        const DeepCollectionEquality.unordered().hash(timeslots),
        const DeepCollectionEquality.unordered().hash(recurrence),
      );

  @override
  String toString() =>
      "Instance of 'SmartSceneWeek' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
