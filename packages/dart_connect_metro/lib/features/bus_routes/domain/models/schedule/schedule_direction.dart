import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/schedule/schedule_stop.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents a direction of a bus route in a schedule.
class ScheduleDirection {
  /// Creates a [ScheduleDirection] object.
  const ScheduleDirection({
    required this.endTime,
    required this.routeId,
    required this.startTime,
    required this.stops,
    required this.direction,
    required this.tripHeadsign,
    required this.tripId,
  });

  /// Creates a [ScheduleDirection] object from a JSON object.
  factory ScheduleDirection.fromJson(Map<String, dynamic> json) {
    return ScheduleDirection(
      endTime:
          DateTime.tryParse(json[ApiFields.endTime] ?? '') ?? emptyDateTime,
      routeId: json[ApiFields.routeId] ?? '',
      startTime:
          DateTime.tryParse(json[ApiFields.startTime] ?? '') ?? emptyDateTime,
      stops: ((json[ApiFields.stopTimes] as List?) ?? [])
          .map((scheduleStop) => ScheduleStop.fromJson(scheduleStop))
          .toList(),
      direction: json[ApiFields.tripDirection] ?? '',
      tripHeadsign: json[ApiFields.tripHeadsign] ?? '',
      tripId: json[ApiFields.tripId] ?? '',
    );
  }

  /// Creates an empty [ScheduleDirection] object.
  ScheduleDirection.empty()
      : endTime = emptyDateTime,
        routeId = '',
        startTime = emptyDateTime,
        stops = [],
        direction = '',
        tripHeadsign = '',
        tripId = '';

  /// Whether or not this object is empty.
  bool get isEmpty =>
      endTime == emptyDateTime &&
      routeId.isEmpty &&
      startTime == emptyDateTime &&
      stops.isEmpty &&
      direction.isEmpty &&
      tripHeadsign.isEmpty &&
      tripId.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Scheduled end date and time (Eastern Standard Time) for this trip.
  final DateTime endTime;

  /// Base route name as shown on the bus.
  ///
  /// Note that the base route name could also refer to any variant, so a
  /// RouteID of 10A could refer to 10A, 10Av1, 10Av2, etc.
  final String routeId;

  /// Scheduled start date and time (Eastern Standard Time) for this trip.
  final DateTime startTime;

  /// Array containing location and time information for each stop in the
  /// schedule.
  final List<ScheduleStop> stops;

  /// General direction of the trip (NORTH, SOUTH, EAST, WEST, LOOP, etc.).
  final String direction;

  /// Descriptive text of where the bus is headed.
  ///
  /// This is similar, but not necessarily identical, to what is displayed on
  /// the bus.
  final String tripHeadsign;

  /// Unique trip ID.
  final String tripId;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.endTime: endTime.toWmataString(),
      ApiFields.routeId: routeId,
      ApiFields.startTime: startTime.toWmataString(),
      ApiFields.stopTimes: stops.map((stop) => stop.toJson()).toList(),
      ApiFields.tripDirection: direction,
      ApiFields.tripHeadsign: tripHeadsign,
      ApiFields.tripId: tripId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ScheduleDirection &&
        other.endTime == endTime &&
        other.routeId == routeId &&
        other.startTime == startTime &&
        const DeepCollectionEquality.unordered().equals(other.stops, stops) &&
        other.direction == direction &&
        other.tripHeadsign == tripHeadsign &&
        other.tripId == tripId;
  }

  @override
  int get hashCode => Object.hash(
        endTime,
        routeId,
        startTime,
        Object.hashAllUnordered(stops),
        direction,
        tripHeadsign,
        tripId,
      );

  @override
  String toString() => "Instance of 'ScheduleDirection' ${toJson().toString()}";
}
