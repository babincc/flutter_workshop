import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/station_to_station/rail_fare.dart';

/// Information about a station to station journey.
class StationToStation {
  /// Creates a new [StationToStation] object.
  StationToStation({
    required this.startStation,
    required this.destinationStation,
    required this.compositeMiles,
    required this.railFare,
    required this.travelTimeMinutes,
  });

  /// Creates a new [StationToStation] object from a JSON object.
  factory StationToStation.fromJson(Map<String, dynamic> json) {
    return StationToStation(
      startStation: json[ApiFields.sourceStation] ?? '',
      destinationStation: json[ApiFields.destinationStation] ?? '',
      compositeMiles:
          ((json[ApiFields.compositeMiles] ?? -1.0) as num).toDouble(),
      railFare: RailFare.fromJson(json[ApiFields.railFare] ?? {}),
      travelTimeMinutes: ((json[ApiFields.railTime] ?? -1.0) as num).toInt(),
    );
  }

  /// Creates an empty [StationToStation] object.
  StationToStation.empty()
      : startStation = '',
        destinationStation = '',
        compositeMiles = -1.0,
        railFare = RailFare.empty(),
        travelTimeMinutes = -1;

  /// Whether or not this [StationToStation] object is empty.
  bool get isEmpty =>
      startStation.isEmpty &&
      destinationStation.isEmpty &&
      compositeMiles == -1.0 &&
      railFare.isEmpty &&
      travelTimeMinutes == -1;

  /// Whether or not this [StationToStation] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The unique identifier for the start station.
  final String startStation;

  /// The unique identifier for the destination station.
  final String destinationStation;

  /// Average of distance traveled between two stations and straight-line
  /// distance (as used for WMATA fare calculations).
  ///
  /// https://www.wmata.com/about/records/public_docs/upload/Tariff-on-Fares-Annotated-2-12-18.pdf#page=6
  final double compositeMiles;

  /// The fare information for this journey.
  final RailFare railFare;

  /// Estimated travel time (schedule time) in minutes between the start and
  /// destination station.
  final int travelTimeMinutes;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.sourceStation: startStation,
      ApiFields.destinationStation: destinationStation,
      ApiFields.compositeMiles: compositeMiles,
      ApiFields.railFare: railFare.toJson(),
      ApiFields.railTime: travelTimeMinutes,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is StationToStation &&
        other.startStation == startStation &&
        other.destinationStation == destinationStation &&
        other.compositeMiles == compositeMiles &&
        other.railFare == railFare &&
        other.travelTimeMinutes == travelTimeMinutes;
  }

  @override
  int get hashCode => Object.hash(
        startStation,
        destinationStation,
        compositeMiles,
        railFare,
        travelTimeMinutes,
      );

  @override
  String toString() => "Instance of 'StationToStation' ${toJson().toString()}";
}
