import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents a prediction for a bus arrival at a stop.
class Prediction {
  /// Creates a new [Prediction] instance.
  const Prediction({
    required this.directionNum,
    required this.direction,
    required this.minutesAway,
    required this.routeID,
    required this.tripID,
    required this.vehicleID,
  });

  /// Creates a new [Prediction] instance from a JSON object.
  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      directionNum: int.parse(json[ApiFields.directionNum] ?? "-1"),
      direction: json[ApiFields.direction] ?? '',
      minutesAway: ((json[ApiFields.minutes] ?? -1) as num).toInt(),
      routeID: json[ApiFields.routeId] ?? '',
      tripID: json[ApiFields.tripId] ?? '',
      vehicleID: json[ApiFields.vehicleId] ?? '',
    );
  }

  /// Creates an empty [Prediction] instance.
  Prediction.empty()
      : directionNum = -1,
        direction = '',
        minutesAway = -1,
        routeID = '',
        tripID = '',
        vehicleID = '';

  /// Whether or not this [Prediction] is empty.
  bool get isEmpty =>
      directionNum == -1 &&
      direction.isEmpty &&
      minutesAway == -1 &&
      routeID.isEmpty &&
      tripID.isEmpty &&
      vehicleID.isEmpty;

  /// Whether or not this [Prediction] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Denotes a binary direction (0 or 1) of the bus.
  ///
  /// There is no specific mapping to direction, but a different value for the
  /// same route signifies that the buses are traveling in opposite directions.
  ///
  /// Use [direction] to show the actual direction of the bus.
  final int directionNum;

  /// General direction of the trip (e.g.: NORTH, SOUTH, EAST, WEST).
  final String direction;

  /// Minutes until bus arrival at this stop.
  final int minutesAway;

  /// Base route name as shown on the bus.
  ///
  /// Note that the base route name could also refer to any variant, so a
  /// RouteID of 10A could refer to 10A, 10Av1, 10Av2, etc.
  final String routeID;

  /// Unique identifier for the trip.
  final String tripID;

  /// Unique identifier for the bus. This is usually visible on the bus itself.
  final String vehicleID;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.directionNum: directionNum.toString(),
      ApiFields.direction: direction,
      ApiFields.minutes: minutesAway,
      ApiFields.routeId: routeID,
      ApiFields.tripId: tripID,
      ApiFields.vehicleId: vehicleID,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Prediction &&
        other.directionNum == directionNum &&
        other.direction == direction &&
        other.minutesAway == minutesAway &&
        other.routeID == routeID &&
        other.tripID == tripID &&
        other.vehicleID == vehicleID;
  }

  @override
  int get hashCode => Object.hash(
        directionNum,
        direction,
        minutesAway,
        routeID,
        tripID,
        vehicleID,
      );

  @override
  String toString() => "Instance of 'Prediction' ${toJson().toString()}";
}
