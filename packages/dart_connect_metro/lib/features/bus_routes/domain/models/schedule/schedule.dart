import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/schedule/schedule_direction.dart';

/// Represents a bus route schedule.
class Schedule {
  /// Creates a [Schedule] object.
  const Schedule({
    required this.direction0,
    required this.direction1,
    required this.name,
  });

  /// Creates a [Schedule] object from a JSON object.
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      direction0: (json[ApiFields.direction0] as List<dynamic>? ?? [])
          .map((direction) =>
              ScheduleDirection.fromJson(direction as Map<String, dynamic>))
          .toList(),
      direction1: (json[ApiFields.direction1] as List<dynamic>? ?? [])
          .map((direction) =>
              ScheduleDirection.fromJson(direction as Map<String, dynamic>))
          .toList(),
      name: json[ApiFields.name] ?? '',
    );
  }

  /// Creates an empty [Schedule] object.
  const Schedule.empty()
      : direction0 = const [],
        direction1 = const [],
        name = '';

  /// Whether or not this object is empty.
  bool get isEmpty => direction0.isEmpty && direction1.isEmpty && name.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Array containing trip information.
  ///
  /// Most routes will return content in both [direction0] and [direction1]
  /// elements, though a few (especially ones which run in a loop, such as the
  /// U8) will return content only for [direction0] and `null` content for
  /// [direction1].
  ///
  /// 0 or 1 are binary properties. There is no specific mapping to direction,
  /// but a different value for the same route signifies that the route is in an
  /// opposite direction.
  final List<ScheduleDirection> direction0;

  /// Array containing trip information.
  ///
  /// Most routes will return content in both [direction0] and [direction1]
  /// elements, though a few (especially ones which run in a loop, such as the
  /// U8) will return content only for [direction0] and `null` content for
  /// [direction1].
  ///
  /// 0 or 1 are binary properties. There is no specific mapping to direction,
  /// but a different value for the same route signifies that the route is in an
  /// opposite direction.
  final List<ScheduleDirection> direction1;

  /// Descriptive name for the route.
  final String name;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.direction0:
          direction0.map((direction) => direction.toJson()).toList(),
      ApiFields.direction1:
          direction1.map((direction) => direction.toJson()).toList(),
      ApiFields.name: name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Schedule &&
        const DeepCollectionEquality.unordered()
            .equals(other.direction0, direction0) &&
        const DeepCollectionEquality.unordered()
            .equals(other.direction1, direction1) &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(direction0),
        Object.hashAllUnordered(direction1),
        name,
      );

  @override
  String toString() => "Instance of 'Schedule' ${toJson().toString()}";
}
