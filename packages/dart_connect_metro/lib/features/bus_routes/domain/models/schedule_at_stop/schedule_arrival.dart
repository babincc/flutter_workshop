import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents a scheduled arrival of a bus at a stop.
class ScheduleArrival {
  /// Creates a new [ScheduleArrival].
  const ScheduleArrival({
    required this.directionNum,
    required this.endTime,
    required this.routeId,
    required this.scheduleTime,
    required this.startTime,
    required this.direction,
    required this.tripHeadsign,
    required this.tripId,
  });

  /// Creates a new [ScheduleArrival] from a JSON object.
  factory ScheduleArrival.fromJson(Map<String, dynamic> json) {
    return ScheduleArrival(
      directionNum: int.parse((json[ApiFields.directionNum] ?? '-1')),
      endTime:
          DateTime.tryParse(json[ApiFields.endTime] ?? '') ?? emptyDateTime,
      routeId: json[ApiFields.routeId] ?? '',
      scheduleTime: DateTime.tryParse(json[ApiFields.scheduleTime] ?? '') ??
          emptyDateTime,
      startTime:
          DateTime.tryParse(json[ApiFields.startTime] ?? '') ?? emptyDateTime,
      direction: json[ApiFields.tripDirection] ?? '',
      tripHeadsign: json[ApiFields.tripHeadsign] ?? '',
      tripId: json[ApiFields.tripId] ?? '',
    );
  }

  /// Creates an empty [ScheduleArrival].
  ScheduleArrival.empty()
      : directionNum = -1,
        endTime = emptyDateTime,
        routeId = '',
        scheduleTime = emptyDateTime,
        startTime = emptyDateTime,
        direction = '',
        tripHeadsign = '',
        tripId = '';

  /// Whether or not this [ScheduleArrival] is empty.
  bool get isEmpty =>
      directionNum == -1 &&
      endTime == emptyDateTime &&
      routeId.isEmpty &&
      scheduleTime == emptyDateTime &&
      startTime == emptyDateTime &&
      direction.isEmpty &&
      tripHeadsign.isEmpty &&
      tripId.isEmpty;

  /// Whether or not this [ScheduleArrival] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Denotes a binary direction (0 or 1) of the bus.
  ///
  /// There is no specific mapping to direction, but a different value for the
  /// same route signifies that the buses are traveling in opposite directions.
  ///
  /// Use [direction] to show the actual direction of the bus.
  final int directionNum;

  /// Scheduled end date and time (Eastern Standard Time) for this trip.
  final DateTime endTime;

  /// Base route name as shown on the bus.
  ///
  /// Note that the base route name could also refer to any variant, so a
  /// RouteID of 10A could refer to 10A, 10Av1, 10Av2, etc.
  final String routeId;

  /// Date and time (Eastern Standard Time) when the bus is scheduled to stop at
  /// this location.
  final DateTime scheduleTime;

  /// Scheduled start date and time (Eastern Standard Time) for this trip.
  final DateTime startTime;

  /// General direction of the trip (e.g.: NORTH, SOUTH, EAST, WEST).
  final String direction;

  /// Destination of the bus.
  final String tripHeadsign;

  /// Unique identifier for the trip.
  final String tripId;

  /// Returns a JSON representation of this [ScheduleArrival].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.directionNum: directionNum.toString(),
      ApiFields.endTime: endTime.toWmataString(),
      ApiFields.routeId: routeId,
      ApiFields.scheduleTime: scheduleTime.toWmataString(),
      ApiFields.startTime: startTime.toWmataString(),
      ApiFields.tripDirection: direction,
      ApiFields.tripHeadsign: tripHeadsign,
      ApiFields.tripId: tripId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScheduleArrival &&
        other.directionNum == directionNum &&
        other.endTime == endTime &&
        other.routeId == routeId &&
        other.scheduleTime == scheduleTime &&
        other.startTime == startTime &&
        other.direction == direction &&
        other.tripHeadsign == tripHeadsign &&
        other.tripId == tripId;
  }

  @override
  int get hashCode => Object.hash(
        directionNum,
        endTime,
        routeId,
        scheduleTime,
        startTime,
        direction,
        tripHeadsign,
        tripId,
      );

  @override
  String toString() => "Instance of 'ScheduleArrival' ${toJson().toString()}";
}
