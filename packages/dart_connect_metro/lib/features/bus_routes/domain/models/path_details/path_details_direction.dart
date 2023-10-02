import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/path_details/shape_point.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/stop.dart';

/// Represents a direction of a bus route.
class PathDetailsDirection {
  /// Creates a [PathDetailsDirection] object.
  const PathDetailsDirection({
    required this.direction,
    required this.shape,
    required this.stops,
    required this.tripHeadsign,
  });

  /// Creates a [PathDetailsDirection] object from a JSON object.
  factory PathDetailsDirection.fromJson(Map<String, dynamic> json) {
    return PathDetailsDirection(
      direction: json[ApiFields.direction] ?? '',
      shape: ((json[ApiFields.shape] as List?) ?? [])
          .map((shapePoint) => ShapePoint.fromJson(shapePoint))
          .toList()
        ..sort(),
      stops: ((json[ApiFields.stops] as List?) ?? [])
          .map((stop) => Stop.fromJson(stop))
          .toList(),
      tripHeadsign: json[ApiFields.tripHeadsign] ?? '',
    );
  }

  /// Creates an empty [PathDetailsDirection] object.
  PathDetailsDirection.empty()
      : direction = '',
        shape = [],
        stops = [],
        tripHeadsign = '';

  /// Whether or not this object is empty.
  bool get isEmpty =>
      direction.isEmpty &&
      shape.isEmpty &&
      stops.isEmpty &&
      tripHeadsign.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// General direction of the route variant (NORTH, SOUTH, EAST, WEST, LOOP,
  /// etc.).
  final String direction;

  /// List of shape points for the route variant.
  final List<ShapePoint> shape;

  /// List of stops for the route variant.
  final List<Stop> stops;

  /// Descriptive text of where the bus is headed.
  ///
  /// This is similar, but not necessarily identical, to what is displayed on
  /// the bus.
  final String tripHeadsign;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.direction: direction,
      ApiFields.shape: shape.map((shapePoint) => shapePoint.toJson()).toList(),
      ApiFields.stops: stops.map((stop) => stop.toJson()).toList(),
      ApiFields.tripHeadsign: tripHeadsign,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is PathDetailsDirection &&
        other.direction == direction &&
        const DeepCollectionEquality.unordered().equals(other.shape, shape) &&
        const DeepCollectionEquality.unordered().equals(other.stops, stops) &&
        other.tripHeadsign == tripHeadsign;
  }

  @override
  int get hashCode => Object.hash(
        direction,
        Object.hashAllUnordered(shape),
        Object.hashAllUnordered(stops),
        tripHeadsign,
      );

  @override
  String toString() =>
      "Instance of 'PathDetailsDirection' ${toJson().toString()}";
}
