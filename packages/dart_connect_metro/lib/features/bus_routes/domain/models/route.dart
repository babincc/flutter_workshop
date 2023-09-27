import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents a bus route.
class Route {
  /// Creates a [Route] object.
  const Route({
    required this.routeId,
    required this.name,
    required this.lineDescription,
  });

  /// Creates a [Route] object from a JSON object.
  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      routeId: json[ApiFields.routeId] ?? '',
      name: json[ApiFields.name] ?? '',
      lineDescription: json[ApiFields.lineDescription] ?? '',
    );
  }

  /// Creates an empty [Route] object.
  Route.empty()
      : routeId = '',
        name = '',
        lineDescription = '';

  /// Whether or not this object is empty.
  bool get isEmpty =>
      routeId.isEmpty && name.isEmpty && lineDescription.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Base route name as shown on the bus.
  ///
  /// Note that the base route name could also refer to any variant, so a
  /// RouteID of 10A could refer to 10A, 10Av1, 10Av2, etc.
  final String routeId;

  /// Descriptive name of the route variant.
  final String name;

  /// Denotes the route variant’s grouping – lines are a combination of routes
  /// which lie in the same corridor and which have significant portions of
  /// their paths along the same roadways.
  final String lineDescription;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.routeId: routeId,
      ApiFields.name: name,
      ApiFields.lineDescription: lineDescription,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Route &&
        other.routeId == routeId &&
        other.name == name &&
        other.lineDescription == lineDescription;
  }

  @override
  int get hashCode => Object.hash(
        routeId,
        name,
        lineDescription,
      );

  @override
  String toString() => "Instance of 'Route' ${toJson().toString()}";
}
