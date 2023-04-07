import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// Represents the active time slot in execution.
class SmartSceneActiveTimeslot {
  /// Creates a [SmartSceneActiveTimeslot] object.
  SmartSceneActiveTimeslot({
    required this.timeslotId,
    required this.weekday,
  });

  /// Creates a [SmartSceneActiveTimeslot] object from the JSON response to a GET
  /// request.
  factory SmartSceneActiveTimeslot.fromJson(Map<String, dynamic> dataMap) {
    return SmartSceneActiveTimeslot(
      timeslotId: dataMap[ApiFields.timeslotId] ?? 0,
      weekday: dataMap[ApiFields.weekday] ?? "",
    );
  }

  /// Creates an empty [SmartSceneActiveTimeslot] object.
  SmartSceneActiveTimeslot.empty()
      : timeslotId = 0,
        weekday = "";

  /// The ID of this time slot.
  final int timeslotId;

  /// The day of the week.
  final String weekday;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  SmartSceneActiveTimeslot copyWith({
    int? timeslotId,
    String? weekday,
  }) {
    return SmartSceneActiveTimeslot(
      timeslotId: timeslotId ?? this.timeslotId,
      weekday: weekday ?? this.weekday,
    );
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
  Map<String, dynamic> toJson() {
    return {
      ApiFields.timeslotId: timeslotId,
      ApiFields.weekday: weekday,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is SmartSceneActiveTimeslot &&
        other.timeslotId == timeslotId &&
        other.weekday == weekday;
  }

  @override
  int get hashCode => Object.hash(timeslotId, weekday);

  @override
  String toString() =>
      "Instance of 'SmartSceneActiveTimeslot' ${toJson().toString()}";
}
