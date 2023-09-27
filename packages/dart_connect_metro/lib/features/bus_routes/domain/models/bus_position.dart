import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents the real world position of a bus.
class BusPosition {
  /// Creates a [BusPosition] object.
  BusPosition({
    required this.dateTime,
    required this.deviationMinutes,
    required this.direction,
    required this.latitude,
    required this.longitude,
    required this.routeId,
    required this.tripStartTime,
    required this.tripEndTime,
    required this.tripHeadsign,
    required this.tripId,
    required this.vehicleId,
  });

  /// Creates a [BusPosition] object from a JSON object.
  factory BusPosition.fromJson(Map<String, dynamic> json) {
    return BusPosition(
      dateTime:
          DateTime.tryParse(json[ApiFields.dateTime] ?? '') ?? emptyDateTime,
      deviationMinutes:
          ((json[ApiFields.deviationMinutes] ?? -9999) as num).toInt(),
      direction: json[ApiFields.direction] ?? '',
      latitude: ((json[ApiFields.latitude] ?? 0.0) as num).toDouble(),
      longitude: ((json[ApiFields.longitude] ?? 0.0) as num).toDouble(),
      routeId: json[ApiFields.routeId] ?? '',
      tripStartTime: DateTime.tryParse(json[ApiFields.tripStartTime] ?? '') ??
          emptyDateTime,
      tripEndTime:
          DateTime.tryParse(json[ApiFields.tripEndTime] ?? '') ?? emptyDateTime,
      tripHeadsign: json[ApiFields.tripHeadsign] ?? '',
      tripId: json[ApiFields.tripId] ?? '',
      vehicleId: json[ApiFields.vehicleId] ?? '',
    );
  }

  /// Creates an empty [BusPosition] object.
  BusPosition.empty()
      : dateTime = emptyDateTime,
        deviationMinutes = -9999,
        direction = '',
        latitude = 0.0,
        longitude = 0.0,
        routeId = '',
        tripStartTime = emptyDateTime,
        tripEndTime = emptyDateTime,
        tripHeadsign = '',
        tripId = '',
        vehicleId = '';

  /// Whether or not this object is empty.
  bool get isEmpty =>
      dateTime == emptyDateTime &&
      deviationMinutes == -9999 &&
      direction.isEmpty &&
      latitude == 0.0 &&
      longitude == 0.0 &&
      routeId.isEmpty &&
      tripStartTime == emptyDateTime &&
      tripEndTime == emptyDateTime &&
      tripHeadsign.isEmpty &&
      tripId.isEmpty &&
      vehicleId.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Date and time (Eastern Standard Time) of last position update.
  final DateTime dateTime;

  /// Deviation, in minutes, from schedule.
  ///
  /// Positive values indicate that the bus is running late while negative ones
  /// are for buses running ahead of schedule.
  final int deviationMinutes;

  /// General direction of the trip, not the bus itself (e.g.: NORTH, SOUTH,
  /// EAST, WEST).
  final String direction;

  /// Last reported Latitude of the bus.
  final double latitude;

  /// Last reported Longitude of the bus.
  final double longitude;

  /// Base route name as shown on the bus.
  ///
  /// Note that the base route name could also refer to any variant, so a
  /// RouteID of 10A could refer to 10A, 10Av1, 10Av2, etc.
  final String routeId;

  /// Scheduled start date and time (Eastern Standard Time) of the bus's current
  /// trip.
  final DateTime tripStartTime;

  /// Scheduled end date and time (Eastern Standard Time) of the bus's current
  /// trip.
  final DateTime tripEndTime;

  /// Destination of the bus.
  final String tripHeadsign;

  /// Unique trip ID.
  final String tripId;

  /// Unique identifier for the bus. This is usually visible on the bus itself.
  final String vehicleId;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.dateTime: dateTime.toWmataString(),
      ApiFields.deviationMinutes: deviationMinutes,
      ApiFields.direction: direction,
      ApiFields.latitude: latitude,
      ApiFields.longitude: longitude,
      ApiFields.routeId: routeId,
      ApiFields.tripStartTime: tripStartTime.toWmataString(),
      ApiFields.tripEndTime: tripEndTime.toWmataString(),
      ApiFields.tripHeadsign: tripHeadsign,
      ApiFields.tripId: tripId,
      ApiFields.vehicleId: vehicleId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is BusPosition &&
        other.dateTime == dateTime &&
        other.deviationMinutes == deviationMinutes &&
        other.direction == direction &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.routeId == routeId &&
        other.tripStartTime == tripStartTime &&
        other.tripEndTime == tripEndTime &&
        other.tripHeadsign == tripHeadsign &&
        other.tripId == tripId &&
        other.vehicleId == vehicleId;
  }

  @override
  int get hashCode => Object.hash(
        dateTime,
        deviationMinutes,
        direction,
        latitude,
        longitude,
        routeId,
        tripStartTime,
        tripEndTime,
        tripHeadsign,
        tripId,
        vehicleId,
      );

  @override
  String toString() => "Instance of 'BusPosition' ${toJson().toString()}";
}
