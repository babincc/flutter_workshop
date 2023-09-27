import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_routes/domain/models/path_details/path_details_direction.dart';
import 'package:dart_connect_metro/utils/date_time_formatter.dart';

/// Represents the path details for a bus route on a given [date].
class PathDetails {
  /// Creates a [PathDetails] object.
  const PathDetails({
    required this.direction0,
    required this.direction1,
    required this.name,
    required this.routeId,
    required this.date,
  });

  /// Creates a [PathDetails] object from a JSON object.
  factory PathDetails.fromJson(Map<String, dynamic> json) {
    return PathDetails(
      direction0:
          PathDetailsDirection.fromJson(json[ApiFields.direction0] ?? {}),
      direction1:
          PathDetailsDirection.fromJson(json[ApiFields.direction1] ?? {}),
      name: json[ApiFields.name] ?? '',
      routeId: json[ApiFields.routeId] ?? '',
      date: DateTime.tryParse(json[ApiFields.dateTime] ?? '') ?? emptyDateTime,
    );
  }

  /// Creates an empty [PathDetails] object.
  PathDetails.empty()
      : direction0 = PathDetailsDirection.empty(),
        direction1 = PathDetailsDirection.empty(),
        name = '',
        routeId = '',
        date = emptyDateTime;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      direction0.isEmpty &&
      direction1.isEmpty &&
      name.isEmpty &&
      routeId.isEmpty &&
      date == emptyDateTime;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Structures describing path/stop information.
  ///
  /// Most routes will return content in both [direction0] and [direction1]
  /// elements, though a few will return `null` for [direction0] or for
  /// [direction1].
  ///
  /// 0 or 1 are binary properties. There is no specific mapping to direction,
  /// but a different value for the same route signifies that the route is in an
  /// opposite direction.
  final PathDetailsDirection direction0;

  /// Structures describing path/stop information.
  ///
  /// Most routes will return content in both [direction0] and [direction1]
  /// elements, though a few will return `null` for [direction0] or for
  /// [direction1].
  ///
  /// 0 or 1 are binary properties. There is no specific mapping to direction,
  /// but a different value for the same route signifies that the route is in an
  /// opposite direction.
  final PathDetailsDirection direction1;

  /// Descriptive name for the route.
  final String name;

  /// Bus route variant (e.g.: 10A, 10Av1, etc.).
  final String routeId;

  /// The date that this set of path details came from.
  final DateTime date;

  /// Returns a JSON object representing this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.direction0: direction0.toJson(),
      ApiFields.direction1: direction1.toJson(),
      ApiFields.name: name,
      ApiFields.routeId: routeId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is PathDetails &&
        other.direction0 == direction0 &&
        other.direction1 == direction1 &&
        other.name == name &&
        other.routeId == routeId &&
        other.date == date;
  }

  @override
  int get hashCode => Object.hash(
        direction0,
        direction1,
        name,
        routeId,
        date,
      );

  @override
  String toString() {
    Map<String, dynamic> json = toJson();

    json[ApiFields.dateTime] = date;

    return "Instance of 'PathDetails' ${json.toString()}";
  }
}
