import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';

class PathDetailsStop {
  /// Creates a [PathDetailsStop] object.
  PathDetailsStop({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.routes,
    required this.stopId,
  });

  /// Creates a [PathDetailsStop] object from a JSON object.
  factory PathDetailsStop.fromJson(Map<String, dynamic> json) {
    return PathDetailsStop(
      latitude: ((json[ApiFields.latitude] ?? 0.0) as num).toDouble(),
      longitude: ((json[ApiFields.longitude] ?? 0.0) as num).toDouble(),
      name: json[ApiFields.name] ?? '',
      routes: ((json[ApiFields.routes] as List?) ?? [])
          .map((route) => route.toString())
          .toList(),
      stopId: int.parse((json[ApiFields.stopId] ?? '0') as String),
    );
  }

  /// Creates an empty [PathDetailsStop] object.
  PathDetailsStop.empty()
      : latitude = 0.0,
        longitude = 0.0,
        name = '',
        routes = [],
        stopId = 0;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      latitude == 0.0 &&
      longitude == 0.0 &&
      name.isEmpty &&
      routes.isEmpty &&
      stopId == 0;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  final double latitude;

  final double longitude;

  /// Stop name.
  ///
  /// May be slightly different from what is spoken or displayed in the bus.
  final String name;

  /// String array of route variants which provide service at this stop.
  ///
  /// Note that these are not date-specific; any route variant which stops at
  /// this stop on any day will be listed.
  final List<String> routes;

  /// 7-digit regional ID which can be used in various bus-related methods.
  ///
  /// If unavailable, the `stopId` will be `0`.
  final int stopId;

  /// Returns a JSON object which represents this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.latitude: latitude,
      ApiFields.longitude: longitude,
      ApiFields.name: name,
      ApiFields.routes: routes,
      ApiFields.stopId: stopId.toString(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is PathDetailsStop &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.name == name &&
        const DeepCollectionEquality.unordered().equals(other.routes, routes) &&
        other.stopId == stopId;
  }

  @override
  int get hashCode => Object.hash(
        latitude,
        longitude,
        name,
        Object.hashAllUnordered(routes),
        stopId,
      );

  @override
  String toString() => "Instance of 'PathDetailsStop' ${toJson.toString()}";
}
