import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents the next trains arriving at a station.
class NextTrain {
  /// Creates a new [NextTrain] instance.
  NextTrain({
    required this.locationCode,
    required this.locationName,
    this.numCars,
    required this.destination,
    this.destinationCode,
    this.destinationName,
    required this.group,
    required this.line,
    required this.minutesAway,
    this.specialStatus,
  });

  /// Creates a new [NextTrain] instance from a JSON object.
  factory NextTrain.fromJson(Map<String, dynamic> json) {
    final String? numCarsStr = json[ApiFields.car];
    final int? numCars = numCarsStr == null ? null : int.tryParse(numCarsStr);

    final String lineRaw = json[ApiFields.line] ?? '';
    final String line = lineRaw == 'No' ? '' : lineRaw;

    final String minutesAwayStr = json[ApiFields.min] ?? '';
    final int? minutesAway = int.tryParse(minutesAwayStr);

    late final TrainStatus? specialStatus;
    if (minutesAwayStr == "ARR" || minutesAwayStr == "BRD") {
      specialStatus = TrainStatus.fromString(minutesAwayStr);
    } else {
      specialStatus = null;
    }

    return NextTrain(
      locationCode: json[ApiFields.locationCode] ?? '',
      locationName: json[ApiFields.locationName] ?? '',
      numCars: numCars,
      destination: json[ApiFields.destination] ?? '',
      destinationCode: json[ApiFields.destinationCode],
      destinationName: json[ApiFields.destinationName],
      group: int.parse(json[ApiFields.group] ?? "-1"),
      line: line,
      minutesAway: minutesAway,
      specialStatus: specialStatus,
    );
  }

  /// Creates an empty [NextTrain] instance.
  NextTrain.empty()
      : locationCode = '',
        locationName = '',
        numCars = null,
        destination = '',
        destinationCode = null,
        destinationName = null,
        group = -1,
        line = '',
        minutesAway = null,
        specialStatus = null;

  /// Whether or not this [NextTrain] instance is empty.
  bool get isEmpty =>
      locationCode.isEmpty &&
      locationName.isEmpty &&
      numCars == null &&
      destination.isEmpty &&
      destinationCode == null &&
      destinationName == null &&
      group == -1 &&
      line.isEmpty &&
      minutesAway == null &&
      specialStatus == null;

  /// Whether or not this [NextTrain] instance is not empty.
  bool get isNotEmpty => locationCode.isNotEmpty;

  /// Unique identifier for the station.
  ///
  /// This is the station who's point of view we are looking at.
  final String locationCode;

  /// Full name of the station where the train is arriving.
  ///
  /// This is the station who's point of view we are looking at.
  final String locationName;

  /// Number of cars on the train.
  ///
  /// Might be `null` if the API doesn't provide this information.
  final int? numCars;

  /// Abbreviated version of the final destination for a train.
  ///
  /// This is similar to what is displayed on the signs at stations.
  final String destination;

  /// Unique identifier for the final destination station.
  ///
  /// Might be `null` if the API doesn't provide this information.
  final String? destinationCode;

  /// Full name of the final destination station.
  ///
  /// Might be `null` if the API doesn't provide this information.
  final String? destinationName;

  /// Denotes the track this train is on, but does not necessarily equate to
  /// Track 1 or Track 2.
  ///
  /// With the exception of terminal stations, predictions at the same station
  /// with different [group] values refer to trains on different tracks.
  final int group;

  /// Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR, GR, or SV).
  ///
  /// May also be blank for trains with no passengers.
  final String line;

  /// Minutes until train arrival at this stop.
  ///
  /// May be `null` if the API doesn't provide this information.
  final int? minutesAway;

  /// The status of the train.
  ///
  /// Only provided if the train is arriving or boarding; otherwise, `null`.
  final TrainStatus? specialStatus;

  /// Returns a JSON representation of this [NextTrain] instance.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ApiFields.locationCode: locationCode,
      ApiFields.locationName: locationName,
      ApiFields.car: numCars?.toString(),
      ApiFields.destination: destination,
      ApiFields.destinationCode: destinationCode,
      ApiFields.destinationName: destinationName,
      ApiFields.group: group.toString(),
      ApiFields.line: line,
      ApiFields.min: specialStatus?.value ?? minutesAway?.toString() ?? '',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is NextTrain &&
        other.locationCode == locationCode &&
        other.locationName == locationName &&
        ((other.numCars == null && numCars == null) ||
            ((other.numCars != null && numCars != null) &&
                (other.numCars == numCars))) &&
        other.destination == destination &&
        ((other.destinationCode == null && destinationCode == null) ||
            ((other.destinationCode != null && destinationCode != null) &&
                (other.destinationCode == destinationCode))) &&
        ((other.destinationName == null && destinationName == null) ||
            ((other.destinationName != null && destinationName != null) &&
                (other.destinationName == destinationName))) &&
        other.group == group &&
        other.line == line &&
        ((other.minutesAway == null && minutesAway == null) ||
            ((other.minutesAway != null && minutesAway != null) &&
                (other.minutesAway == minutesAway))) &&
        ((other.specialStatus == null && specialStatus == null) ||
            ((other.specialStatus != null && specialStatus != null) &&
                (other.specialStatus == specialStatus)));
  }

  @override
  int get hashCode => Object.hash(
        locationCode,
        locationName,
        numCars,
        destination,
        destinationCode,
        destinationName,
        group,
        line,
        minutesAway,
        specialStatus,
      );

  @override
  String toString() => "Instance of 'NextTrain' ${toJson().toString()}";
}

/// Represents the status of a train.
enum TrainStatus {
  /// Train is pulling into the station.
  arriving("ARR"),

  /// The train is stopped at the station, and the doors are open.
  boarding("BRD"),

  unknown("---");

  const TrainStatus(this.value);

  /// The string representation of this [TrainStatus].
  final String value;

  /// Get a [TrainStatus] from a given string `value`.
  static TrainStatus fromString(String value) {
    return values.firstWhere(
      (unitType) => unitType.value == value,
      orElse: () => unknown,
    );
  }
}
