import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents an entrance to a station.
class StationEntrance {
  /// Creates a new [StationEntrance].
  const StationEntrance({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.stationCode1,
    required this.stationCode2,
  });

  /// Creates a new [StationEntrance] from a JSON object.
  factory StationEntrance.fromJson(Map<String, dynamic> json) {
    return StationEntrance(
      name: json[ApiFields.name] ?? '',
      description: json[ApiFields.description] ?? '',
      latitude: ((json[ApiFields.latitude] ?? 0.0) as num).toDouble(),
      longitude: ((json[ApiFields.longitude] ?? 0.0) as num).toDouble(),
      stationCode1: json[ApiFields.stationCode1] ?? '',
      stationCode2: json[ApiFields.stationCode2] ?? '',
    );
  }

  /// Creates an empty [StationEntrance].
  StationEntrance.empty()
      : name = '',
        description = '',
        latitude = 0.0,
        longitude = 0.0,
        stationCode1 = '',
        stationCode2 = '';

  /// Whether or not this [StationEntrance] is empty.
  bool get isEmpty =>
      name.isEmpty &&
      description.isEmpty &&
      latitude == 0.0 &&
      longitude == 0.0 &&
      stationCode1.isEmpty &&
      stationCode2.isEmpty;

  /// Whether or not this [StationEntrance] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Name of the entrance (usually the station name and nearest intersection).
  final String name;

  /// Additional information for the entrance, if available.
  final String description;

  final double latitude;

  final double longitude;

  /// The station code associated with this entrance.
  final String stationCode1;

  /// For stations containing multiple platforms (e.g.: Gallery Place, Fort
  /// Totten, L'Enfant Plaza, and Metro Center), the other station code.
  final String stationCode2;

  /// Returns a JSON representation of this [StationEntrance].
  Map<String, dynamic> toJson() {
    return {
      ApiFields.name: name,
      ApiFields.description: description,
      ApiFields.latitude: latitude,
      ApiFields.longitude: longitude,
      ApiFields.stationCode1: stationCode1,
      ApiFields.stationCode2: stationCode2,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is StationEntrance &&
        other.name == name &&
        other.description == description &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.stationCode1 == stationCode1 &&
        other.stationCode2 == stationCode2;
  }

  @override
  int get hashCode => Object.hash(
        name,
        description,
        latitude,
        longitude,
        stationCode1,
        stationCode2,
      );

  @override
  String toString() => "Instance of 'StationEntrance' ${toJson().toString()}";
}
