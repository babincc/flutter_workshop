import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station/address.dart';

/// Contains information about a station.
class Station {
  /// Creates a new [Station] instance.
  const Station({
    required this.address,
    required this.stationCode,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.lineCode1,
    required this.lineCode2,
    required this.lineCode3,
    required this.lineCode4,
    required this.stationTogether1,
    required this.stationTogether2,
  });

  /// Creates a new [Station] instance from a JSON object.
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      address: Address.fromJson(json[ApiFields.address] ?? {}),
      stationCode: json[ApiFields.code] ?? '',
      name: json[ApiFields.name] ?? '',
      latitude: ((json[ApiFields.latitude] ?? 0.0) as num).toDouble(),
      longitude: ((json[ApiFields.longitude] ?? 0.0) as num).toDouble(),
      lineCode1: json[ApiFields.lineCode1] ?? '',
      lineCode2: json[ApiFields.lineCode2] ?? '',
      lineCode3: json[ApiFields.lineCode3] ?? '',
      lineCode4: json[ApiFields.lineCode4] ?? '',
      stationTogether1: json[ApiFields.stationTogether1] ?? '',
      stationTogether2: json[ApiFields.stationTogether2] ?? '',
    );
  }

  /// Creates an empty [Station] instance.
  Station.empty()
      : address = Address.empty(),
        stationCode = '',
        name = '',
        latitude = 0.0,
        longitude = 0.0,
        lineCode1 = '',
        lineCode2 = '',
        lineCode3 = '',
        lineCode4 = '',
        stationTogether1 = '',
        stationTogether2 = '';

  /// Whether or not this [Station] instance is empty.
  bool get isEmpty =>
      address.isEmpty &&
      stationCode.isEmpty &&
      name.isEmpty &&
      latitude == 0.0 &&
      longitude == 0.0 &&
      lineCode1.isEmpty &&
      lineCode2.isEmpty &&
      lineCode3.isEmpty &&
      lineCode4.isEmpty &&
      stationTogether1.isEmpty &&
      stationTogether2.isEmpty;

  /// Whether or not this [Station] instance is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The address information for this station.
  final Address address;

  /// The station code.
  final String stationCode;

  /// The name of the station.
  final String name;

  final double latitude;

  final double longitude;

  /// Two-letter abbreviation for one line (e.g.: RD, BL, YL, OR, GR, or SV)
  /// served by this station.
  final String lineCode1;

  /// Additional line served by this station, if applicable.
  final String lineCode2;

  /// Additional line served by this station, if applicable.
  final String lineCode3;

  /// Additional line served by this station, if applicable.
  final String lineCode4;

  /// For stations with multiple platforms (e.g.: Gallery Place, Fort Totten,
  /// L'Enfant Plaza, and Metro Center), the additional station code will be
  /// listed here.
  final String stationTogether1;

  /// Similar in function to [stationTogether1].
  final String stationTogether2;

  /// Returns a JSON representation of this [Station] instance.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.address: address.toJson(),
      ApiFields.code: stationCode,
      ApiFields.name: name,
      ApiFields.latitude: latitude,
      ApiFields.longitude: longitude,
      ApiFields.lineCode1: lineCode1,
      ApiFields.lineCode2: lineCode2,
      ApiFields.lineCode3: lineCode3,
      ApiFields.lineCode4: lineCode4,
      ApiFields.stationTogether1: stationTogether1,
      ApiFields.stationTogether2: stationTogether2,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Station &&
        other.address == address &&
        other.stationCode == stationCode &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.lineCode1 == lineCode1 &&
        other.lineCode2 == lineCode2 &&
        other.lineCode3 == lineCode3 &&
        other.lineCode4 == lineCode4 &&
        other.stationTogether1 == stationTogether1 &&
        other.stationTogether2 == stationTogether2;
  }

  @override
  int get hashCode => Object.hash(
        address,
        stationCode,
        name,
        latitude,
        longitude,
        lineCode1,
        lineCode2,
        lineCode3,
        lineCode4,
        stationTogether1,
        stationTogether2,
      );

  @override
  String toString() => "Instance of 'Station' ${toJson().toString()}";
}
