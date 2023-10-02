import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_timings/day_timings.dart';

/// Represents the timing info at a station.
class StationTimings {
  /// Creates a new [StationTimings] object.
  const StationTimings({
    required this.stationCode,
    required this.name,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  /// Creates a new [StationTimings] object from JSON data.
  factory StationTimings.fromJson(Map<String, dynamic> json) {
    return StationTimings(
      stationCode: json[ApiFields.code] ?? '',
      name: json[ApiFields.stationName] ?? '',
      monday: DayTimings.fromJson(json[ApiFields.monday] ?? {}),
      tuesday: DayTimings.fromJson(json[ApiFields.tuesday] ?? {}),
      wednesday: DayTimings.fromJson(json[ApiFields.wednesday] ?? {}),
      thursday: DayTimings.fromJson(json[ApiFields.thursday] ?? {}),
      friday: DayTimings.fromJson(json[ApiFields.friday] ?? {}),
      saturday: DayTimings.fromJson(json[ApiFields.saturday] ?? {}),
      sunday: DayTimings.fromJson(json[ApiFields.sunday] ?? {}),
    );
  }

  /// Creates an empty [StationTimings] object.
  StationTimings.empty()
      : stationCode = '',
        name = '',
        monday = DayTimings.empty(),
        tuesday = DayTimings.empty(),
        wednesday = DayTimings.empty(),
        thursday = DayTimings.empty(),
        friday = DayTimings.empty(),
        saturday = DayTimings.empty(),
        sunday = DayTimings.empty();

  /// Whether or not this [StationTimings] object is empty.
  bool get isEmpty =>
      stationCode.isEmpty &&
      name.isEmpty &&
      monday.isEmpty &&
      tuesday.isEmpty &&
      wednesday.isEmpty &&
      thursday.isEmpty &&
      friday.isEmpty &&
      saturday.isEmpty &&
      sunday.isEmpty;

  /// Whether or not this [StationTimings] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Unique code for the station.
  final String stationCode;

  /// Full name of the station.
  final String name;

  /// The time info for Monday at the station.
  final DayTimings monday;

  /// The time info for Tuesday at the station.
  final DayTimings tuesday;

  /// The time info for Wednesday at the station.
  final DayTimings wednesday;

  /// The time info for Thursday at the station.
  final DayTimings thursday;

  /// The time info for Friday at the station.
  final DayTimings friday;

  /// The time info for Saturday at the station.
  final DayTimings saturday;

  /// The time info for Sunday at the station.
  final DayTimings sunday;

  /// Returns a JSON representation of this [StationTimings] object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.code: stationCode,
      ApiFields.stationName: name,
      ApiFields.monday: monday.toJson(),
      ApiFields.tuesday: tuesday.toJson(),
      ApiFields.wednesday: wednesday.toJson(),
      ApiFields.thursday: thursday.toJson(),
      ApiFields.friday: friday.toJson(),
      ApiFields.saturday: saturday.toJson(),
      ApiFields.sunday: sunday.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is StationTimings &&
        other.stationCode == stationCode &&
        other.name == name &&
        other.monday == monday &&
        other.tuesday == tuesday &&
        other.wednesday == wednesday &&
        other.thursday == thursday &&
        other.friday == friday &&
        other.saturday == saturday &&
        other.sunday == sunday;
  }

  @override
  int get hashCode => Object.hash(
        stationCode,
        name,
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        sunday,
      );

  @override
  String toString() => "Instance of 'StationTimings' ${toJson().toString()}";
}
