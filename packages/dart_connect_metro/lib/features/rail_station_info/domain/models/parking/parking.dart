import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/parking/all_day_parking.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/parking/short_term_parking.dart';

/// Represents parking information at a station.
class Parking {
  /// Creates a new [Parking] instance.
  Parking({
    required this.stationCode,
    this.notes,
    required this.allDayParking,
    required this.shortTermParking,
  });

  /// Creates a new [Parking] instance from a JSON object.
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      stationCode: json[ApiFields.code] ?? '',
      notes: json[ApiFields.notes],
      allDayParking:
          AllDayParking.fromJson(json[ApiFields.allDayParking] ?? {}),
      shortTermParking:
          ShortTermParking.fromJson(json[ApiFields.shortTermParking] ?? {}),
    );
  }

  /// Creates an empty [Parking] instance.
  Parking.empty()
      : stationCode = '',
        notes = null,
        allDayParking = AllDayParking.empty(),
        shortTermParking = ShortTermParking.empty();

  /// Whether or not this [Parking] object is empty.
  bool get isEmpty =>
      stationCode.isEmpty &&
      notes == null &&
      allDayParking.isEmpty &&
      shortTermParking.isEmpty;

  /// Whether or not this [Parking] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Unique identifier for the station associated with this parking
  /// information.
  final String stationCode;

  /// When not `null`, provides additional parking resources such as nearby
  /// lots.
  final String? notes;

  /// Structure describing all-day parking options.
  final AllDayParking allDayParking;

  /// Structure describing short-term parking options.
  final ShortTermParking shortTermParking;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.code: stationCode,
      ApiFields.notes: notes,
      ApiFields.allDayParking: allDayParking.toJson(),
      ApiFields.shortTermParking: shortTermParking.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Parking &&
        other.stationCode == stationCode &&
        ((other.notes == null && notes == null) ||
            ((other.notes != null && notes != null) &&
                (other.notes == notes))) &&
        other.allDayParking == allDayParking &&
        other.shortTermParking == shortTermParking;
  }

  @override
  int get hashCode => Object.hash(
        stationCode,
        notes,
        allDayParking,
        shortTermParking,
      );

  @override
  String toString() => "Instance of 'Parking' ${toJson().toString()}";
}
